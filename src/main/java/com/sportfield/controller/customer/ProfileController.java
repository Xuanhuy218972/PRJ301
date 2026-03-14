package com.sportfield.controller.customer;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.UserDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.BookingDetail;
import com.sportfield.model.User;
import com.sportfield.utils.EmailService;
import com.sportfield.utils.EmailTemplates;
import com.sportfield.utils.SecurityUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile" })
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = userDAO.getUserByID(account.getUserID());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<BookingDetail> bookings = bookingDAO.getBookingsByUserID(user.getUserID());

        request.setAttribute("user", user);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/views/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, account);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, account);
        } else if ("cancelBooking".equals(action)) {
            cancelBooking(request, response, account);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User account)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        User user = userDAO.getUserByID(account.getUserID());
        if (user != null) {
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setEmail(email);

            if (userDAO.update(user)) {
                request.getSession().setAttribute("account", user);
                request.getSession().setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.getSession().setAttribute("error", "Cập nhật thông tin thất bại!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User account)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.getSession().setAttribute("error", "Mật khẩu mới không khớp!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        User user = userDAO.getUserByID(account.getUserID());
        String hashedCurrentPassword = SecurityUtils.hashPassword(currentPassword);
        if (user != null && user.getPassword().equals(hashedCurrentPassword)) {
            String hashedNewPassword = SecurityUtils.hashPassword(newPassword);
            if (userDAO.updatePassword(user.getUserID(), hashedNewPassword)) {
                user.setPassword(hashedNewPassword);
                request.getSession().setAttribute("account", user);
                request.getSession().setAttribute("success", "Đổi mật khẩu thành công!");

                // Send password changed email
                EmailService.sendAsync(
                    user.getEmail(),
                    "Mật khẩu đã được thay đổi",
                    EmailTemplates.passwordChanged(user.getFullName())
                );
            } else {
                request.getSession().setAttribute("error", "Đổi mật khẩu thất bại!");
            }
        } else {
            request.getSession().setAttribute("error", "Mật khẩu hiện tại không đúng!");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, User account)
            throws ServletException, IOException {
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            String cancelReason = request.getParameter("cancelReason");
            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                cancelReason = "Khách hàng hủy sân";
            }

            // Verify booking belongs to user
            Booking booking = bookingDAO.getBookingByID(bookingID);
            if (booking == null || booking.getCustomerID() != account.getUserID()) {
                request.getSession().setAttribute("error", "Không tìm thấy booking hoặc bạn không có quyền!");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Verify status = CONFIRMED
            if (!"CONFIRMED".equals(booking.getStatus())) {
                request.getSession().setAttribute("error", "Chỉ có thể hủy booking đang xác nhận!");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Get first detail to check slot time
            BookingDetail detail = bookingDAO.getFirstDetailByBookingID(bookingID);
            if (detail == null || detail.getBookingDate() == null || detail.getSlotStartTime() == null) {
                request.getSession().setAttribute("error", "Không tìm thấy thông tin slot!");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Calculate slot datetime
            LocalTime slotTime = LocalTime.parse(detail.getSlotStartTime());
            LocalDateTime slotDateTime = detail.getBookingDate().atTime(slotTime);
            LocalDateTime now = LocalDateTime.now();

            // Cannot cancel past slot
            if (slotDateTime.isBefore(now)) {
                request.getSession().setAttribute("error", "Không thể hủy sân đã qua giờ đá!");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            // Calculate refund
            BigDecimal paidAmount = booking.getPaidAmount() != null ? booking.getPaidAmount() : BigDecimal.ZERO;
            BigDecimal refundAmount;
            long hoursUntilSlot = Duration.between(now, slotDateTime).toHours();

            if (hoursUntilSlot > 48) {
                refundAmount = paidAmount; // 100%
            } else {
                // 70% refund
                refundAmount = paidAmount.multiply(new BigDecimal("0.7")).setScale(0, RoundingMode.FLOOR);
            }

            // Execute cancel
            boolean success = bookingDAO.cancelBooking(bookingID, cancelReason.trim(), refundAmount);

            if (success) {
                String msg = "Hủy sân thành công! ";
                if (paidAmount.compareTo(BigDecimal.ZERO) > 0) {
                    msg += "Số tiền hoàn lại: " + refundAmount.toPlainString() + "đ. Vui lòng liên hệ với chúng tôi để nhận lại tiền sân đã thanh toán.";
                }

                // Send cancel email
                User user = userDAO.getUserByID(account.getUserID());
                if (user != null) {
                    EmailService.sendAsync(
                        user.getEmail(),
                        "Hủy sân thành công",
                        EmailTemplates.bookingCancelled(
                            user.getFullName(),
                            detail.getFieldName(),
                            detail.getBookingDate().toString(),
                            refundAmount
                        )
                    );
                }
                request.getSession().setAttribute("success", msg);
            } else {
                request.getSession().setAttribute("error", "Hủy sân thất bại!");
            }

        } catch (Exception e) {
            getServletContext().log("[ProfileController] cancelBooking error", e);
            request.getSession().setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau!");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
