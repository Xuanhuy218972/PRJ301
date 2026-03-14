package com.sportfield.controller.customer;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import com.sportfield.dao.BookingDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.User;
import com.sportfield.vnpay.VNPayUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles VNPay return callback after payment.
 * VNPay redirects user here with payment result parameters.
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Collect all VNPay return parameters
        Map<String, String> params = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (paramValue != null && !paramValue.isEmpty()) {
                params.put(paramName, paramValue);
            }
        }

        // Extract key info
        String vnpResponseCode = params.get("vnp_ResponseCode");
        String vnpTxnRef = params.get("vnp_TxnRef"); // This is our bookingID
        String vnpAmount = params.get("vnp_Amount");
        String vnpOrderInfo = params.get("vnp_OrderInfo");
        String vnpTransactionNo = params.get("vnp_TransactionNo");

        // Verify hash
        boolean isValidHash = VNPayUtil.verifyReturnHash(params);

        HttpSession session = request.getSession(true);

        if (isValidHash && "00".equals(vnpResponseCode)) {
            // PAYMENT SUCCESS
            try {
                // Parse booking ID from TxnRef (format: bookingID_timestamp)
                String bookingIdStr = vnpTxnRef;
                if (vnpTxnRef.contains("_")) {
                    bookingIdStr = vnpTxnRef.substring(0, vnpTxnRef.indexOf("_"));
                }
                int bookingID = Integer.parseInt(bookingIdStr);

                // Get booking to determine payment type
                Booking booking = bookingDAO.getBookingByID(bookingID);

                if (booking != null) {
                    // VNPay amount is in smallest unit (x100), convert back
                    BigDecimal paidAmount = new BigDecimal(vnpAmount).divide(new BigDecimal("100"));

                    String paymentStatus;
                    String bookingStatus = "CONFIRMED";

                    // Check if this was full payment or deposit
                    if (paidAmount.compareTo(booking.getTotalPrice()) >= 0) {
                        paymentStatus = "PAID";
                    } else {
                        paymentStatus = "DEPOSITED";
                    }

                    // Update booking payment info
                    bookingDAO.updatePaymentInfo(bookingID, paidAmount, paymentStatus, bookingStatus);

                    // Reload booking to get updated data
                    booking = bookingDAO.getBookingByID(bookingID);

                    // Set success attributes for the success page
                    session.setAttribute("bookingSuccess", true);
                    session.setAttribute("successBookingID", bookingID);
                    session.setAttribute("successTotalPrice", booking.getTotalPrice());
                    session.setAttribute("successPaidAmount", paidAmount);
                    session.setAttribute("successPaymentStatus", paymentStatus);
                    session.setAttribute("successPaymentMethod", "VNPAY");
                    session.setAttribute("vnpTransactionNo", vnpTransactionNo);

                    // Try to get field/slot info from the order info or session
                    if (session.getAttribute("successFieldName") == null) {
                        session.setAttribute("successFieldName", vnpOrderInfo);
                    }

                    // Send confirmation email
                    User account = (User) session.getAttribute("account");
                    if (account != null) {
                        String slotTimeStr = (String) session.getAttribute("successSlotTime");
                        if (slotTimeStr == null) slotTimeStr = "Đã xác nhận";
                        String emailContent;
                        if ("DEPOSITED".equals(paymentStatus)) {
                            emailContent = com.sportfield.utils.EmailTemplates.depositConfirmed(
                                account.getFullName(), (String)session.getAttribute("successFieldName"), 
                                (String)session.getAttribute("successDate"), slotTimeStr, paidAmount, booking.getRemainingAmount());
                        } else {
                            emailContent = com.sportfield.utils.EmailTemplates.bookingConfirmed(
                                account.getFullName(), (String)session.getAttribute("successFieldName"), 
                                (String)session.getAttribute("successDate"), slotTimeStr, booking.getTotalPrice());
                        }
                        com.sportfield.utils.EmailService.sendAsync(account.getEmail(), "Xác nhận thanh toán đặt sân - SportFieldHub", emailContent);
                    }

                    response.sendRedirect(request.getContextPath() + "/booking?action=success");
                    return;
                }
            } catch (Exception e) {
                getServletContext().log("[VNPayReturnController] payment success processing error", e);
            }
            session.setAttribute("bookingSuccess", true);
            session.setAttribute("successPaymentMethod", "VNPAY");
            session.setAttribute("successPaymentStatus", "PAID");
            response.sendRedirect(request.getContextPath() + "/booking?action=success");

        } else {
            // PAYMENT FAILED or CANCELLED
            String errorMsg;
            if (!isValidHash) {
                errorMsg = "Chữ ký không hợp lệ. Giao dịch có thể bị giả mạo!";
            } else {
                // Map VNPay response codes to Vietnamese messages
                switch (vnpResponseCode != null ? vnpResponseCode : "") {
                    case "24": errorMsg = "Bạn đã hủy giao dịch thanh toán."; break;
                    case "51": errorMsg = "Tài khoản không đủ số dư."; break;
                    case "65": errorMsg = "Tài khoản đã vượt quá hạn mức giao dịch trong ngày."; break;
                    case "75": errorMsg = "Ngân hàng thanh toán đang bảo trì."; break;
                    case "99": errorMsg = "Lỗi không xác định từ VNPay."; break;
                    default: errorMsg = "Thanh toán thất bại (Mã lỗi: " + vnpResponseCode + ")."; break;
                }
            }

            // If we have a booking that was created pending, we could cancel it
            // or leave it for the user to retry
            try {
                if (vnpTxnRef != null) {
                    String bookingIdStr = vnpTxnRef;
                    if (vnpTxnRef.contains("_")) {
                        bookingIdStr = vnpTxnRef.substring(0, vnpTxnRef.indexOf("_"));
                    }
                    int bookingID = Integer.parseInt(bookingIdStr);
                    // Cancel the pending booking since payment failed
                    bookingDAO.updatePaymentInfo(bookingID, BigDecimal.ZERO, "UNPAID", "CANCELLED");
                }
            } catch (Exception e) {
                getServletContext().log("[VNPayReturnController] cancel pending booking error", e);
            }
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }
}
