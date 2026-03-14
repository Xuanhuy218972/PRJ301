package com.sportfield.controller.customer;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.HashMap;
import java.util.Map;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.FieldSlot;
import com.sportfield.model.SportField;
import com.sportfield.model.User;
import com.sportfield.vnpay.VNPayConfig;
import com.sportfield.vnpay.VNPayUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = { "/booking" })
public class BookingController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Handle success page
        String action = request.getParameter("action");
        if ("success".equals(action)) {
            HttpSession sess = request.getSession(false);
            if (sess != null && sess.getAttribute("bookingSuccess") != null) {
                sess.removeAttribute("bookingSuccess");
                request.getRequestDispatcher("/views/customer/booking-success.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/shop");
            }
            return;
        }

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            String returnUrl = request.getRequestURI();
            String queryString = request.getQueryString();
            if (queryString != null) {
                returnUrl += "?" + queryString;
            }
            session = request.getSession(true);
            session.setAttribute("returnUrl", returnUrl);
            session.setAttribute("error", "Vui lòng đăng nhập để đặt sân!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fieldIdParam = request.getParameter("fieldId");
        String slotIdParam = request.getParameter("slotId");
        String dateParam = request.getParameter("date");

        if (fieldIdParam == null || slotIdParam == null || dateParam == null) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int fieldID = Integer.parseInt(fieldIdParam);
            int slotID = Integer.parseInt(slotIdParam);
            LocalDate bookingDate = LocalDate.parse(dateParam);

            SportField field = fieldDAO.getByID(fieldID);
            FieldSlot slot = slotDAO.getByID(slotID);

            if (field == null || slot == null || !"ACTIVE".equals(field.getStatus())
                    || !"ACTIVE".equals(slot.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            // Không cho phép đặt khung giờ đã quá thời gian
            LocalDateTime slotEndDateTime = bookingDate.atTime(slot.getEndTime());
            if (slotEndDateTime.isBefore(LocalDateTime.now())) {
                session = request.getSession(true);
                session.setAttribute("error",
                        "Không thể đặt sân vào khung giờ đã quá thời gian. Vui lòng chọn khung giờ khác.");
                LocalDate weekStart = bookingDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                response.sendRedirect(request.getContextPath() + "/field-detail?id=" + fieldID + "&week=" + weekStart);
                return;
            }

            // Calculate deposit amount (30%)
            BigDecimal depositAmount = slot.getPrice()
                    .multiply(new BigDecimal("0.3"))
                    .setScale(0, RoundingMode.CEILING);

            request.setAttribute("field", field);
            request.setAttribute("slot", slot);
            request.setAttribute("bookingDate", bookingDate);
            request.setAttribute("user", account);
            request.setAttribute("depositAmount", depositAmount);

            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Check login
        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int fieldID = Integer.parseInt(request.getParameter("fieldId"));
            int slotID = Integer.parseInt(request.getParameter("slotId"));
            LocalDate bookingDate = LocalDate.parse(request.getParameter("date"));
            String note = request.getParameter("note");
            String paymentOption = request.getParameter("paymentOption"); // FULL, DEPOSIT

            SportField field = fieldDAO.getByID(fieldID);
            FieldSlot slot = slotDAO.getByID(slotID);

            if (field == null || slot == null) {
                session.setAttribute("error", "Thông tin sân không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            BigDecimal slotPrice = slot.getPrice();
            BigDecimal depositAmount;

            if ("FULL".equals(paymentOption) || "DEPOSIT".equals(paymentOption)) {
                // ============================================
                // VNPAY FLOW: Create booking PENDING → redirect to VNPay
                // ============================================

                if ("FULL".equals(paymentOption)) {
                    depositAmount = slotPrice;
                } else {
                    depositAmount = slotPrice.multiply(new BigDecimal("0.3")).setScale(0, RoundingMode.CEILING);
                }

                // Create booking with PENDING status (will be updated after VNPay confirms)
                Booking booking = new Booking();
                booking.setCustomerID(account.getUserID());
                booking.setBookingType("RETAIL");
                booking.setTotalPrice(slotPrice);
                booking.setDeposit(depositAmount);
                booking.setStatus("PENDING");          // Will become CONFIRMED after payment
                booking.setNote(note);
                booking.setPaymentMethod("VNPAY");
                booking.setPaymentStatus("UNPAID");    // Will become PAID/DEPOSITED after payment
                booking.setPaidAmount(BigDecimal.ZERO); // Will be updated after payment

                int newBookingID = bookingDAO.insertBookingWithDetails(booking, slotID, bookingDate, slotPrice);

                if (newBookingID > 0) {
                    // Store info in session for success page (after VNPay return)
                    session.setAttribute("successFieldName", field.getFieldName());
                    session.setAttribute("successFieldType", field.getFieldType());
                    session.setAttribute("successDate", bookingDate.toString());
                    session.setAttribute("successSlotTime", slot.getStartTime().toString().substring(0, 5)
                            + " - " + slot.getEndTime().toString().substring(0, 5));

                    // Build VNPay payment URL
                    // VNPay requires amount in smallest currency unit (VND * 100)
                    long vnpAmount = depositAmount.longValue() * 100;
                    String vnpTxnRef = newBookingID + "_" + System.currentTimeMillis();
                    String orderInfo = "Thanh toan dat san " + field.getFieldName()
                            + " - " + bookingDate + " - BK" + newBookingID;

                    String returnUrl = request.getScheme() + "://" + request.getServerName()
                            + ":" + request.getServerPort()
                            + request.getContextPath() + VNPayConfig.VNP_RETURN_URL_PATH;

                    Map<String, String> vnpParams = new HashMap<>();
                    vnpParams.put("vnp_Version", VNPayConfig.VNP_VERSION);
                    vnpParams.put("vnp_Command", VNPayConfig.VNP_COMMAND);
                    vnpParams.put("vnp_TmnCode", VNPayConfig.VNP_TMN_CODE);
                    vnpParams.put("vnp_Amount", String.valueOf(vnpAmount));
                    vnpParams.put("vnp_CurrCode", VNPayConfig.VNP_CURRENCY_CODE);
                    vnpParams.put("vnp_TxnRef", vnpTxnRef);
                    vnpParams.put("vnp_OrderInfo", orderInfo);
                    vnpParams.put("vnp_OrderType", VNPayConfig.VNP_ORDER_TYPE);
                    vnpParams.put("vnp_Locale", VNPayConfig.VNP_LOCALE);
                    vnpParams.put("vnp_ReturnUrl", returnUrl);
                    vnpParams.put("vnp_IpAddr", VNPayUtil.getIpAddress(request));
                    vnpParams.put("vnp_CreateDate", VNPayUtil.getCurrentTimestamp());
                    vnpParams.put("vnp_ExpireDate", VNPayUtil.getExpireTimestamp());

                    String paymentUrl = VNPayUtil.buildPaymentUrl(vnpParams);

                    // Redirect user to VNPay payment gateway
                    response.sendRedirect(paymentUrl);
                } else {
                    session.setAttribute("error", "Đặt sân thất bại. Vui lòng thử lại!");
                    response.sendRedirect(request.getContextPath() + "/field-detail?id=" + fieldID);
                }

            } else if ("ON_SITE".equals(paymentOption)) {
                // ============================================
                // ON-SITE FLOW: Create CONFIRMED booking, pay at field
                // ============================================
                Booking booking = new Booking();
                booking.setCustomerID(account.getUserID());
                booking.setBookingType("RETAIL");
                booking.setTotalPrice(slotPrice);
                booking.setDeposit(BigDecimal.ZERO);
                booking.setStatus("CONFIRMED");
                booking.setNote(note);
                booking.setPaymentMethod("ON_SITE");
                booking.setPaymentStatus("UNPAID");
                booking.setPaidAmount(BigDecimal.ZERO);

                int newBookingID = bookingDAO.insertBookingWithDetails(booking, slotID, bookingDate, slotPrice);

                if (newBookingID > 0) {
                    session.setAttribute("bookingSuccess", true);
                    session.setAttribute("successBookingID", newBookingID);
                    session.setAttribute("successFieldName", field.getFieldName());
                    session.setAttribute("successFieldType", field.getFieldType());
                    session.setAttribute("successDate", bookingDate.toString());
                    session.setAttribute("successSlotTime", slot.getStartTime().toString().substring(0, 5)
                            + " - " + slot.getEndTime().toString().substring(0, 5));
                    session.setAttribute("successTotalPrice", slotPrice);
                    session.setAttribute("successPaidAmount", BigDecimal.ZERO);
                    session.setAttribute("successPaymentStatus", "UNPAID");
                    session.setAttribute("successPaymentMethod", "ON_SITE");

                    // Send confirmation email
                    String email = request.getParameter("customerEmail");
                    if (email == null || email.isEmpty()) {
                        email = account.getEmail();
                    }
                    String slotTimeStr = slot.getStartTime().toString().substring(0, 5) + " - " + slot.getEndTime().toString().substring(0, 5);
                    String emailContent = com.sportfield.utils.EmailTemplates.bookingConfirmed(
                            account.getFullName(), field.getFieldName(), bookingDate.toString(), slotTimeStr, slotPrice);
                    com.sportfield.utils.EmailService.sendAsync(email, "Xác nhận đặt sân - SpotFieldHub", emailContent);

                    response.sendRedirect(request.getContextPath() + "/booking?action=success");
                } else {
                    session.setAttribute("error", "Đặt sân thất bại. Vui lòng thử lại!");
                    response.sendRedirect(request.getContextPath() + "/field-detail?id=" + fieldID);
                }

            } else {
                session.setAttribute("error", "Phương thức thanh toán không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/shop");
            }

        } catch (RuntimeException e) {
            e.printStackTrace();
            session = request.getSession(true);
            session.setAttribute("error", "Lỗi DB: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (Exception e) {
            e.printStackTrace();
            session = request.getSession(true);
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }
}

