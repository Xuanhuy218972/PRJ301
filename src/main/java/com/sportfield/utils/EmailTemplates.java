package com.sportfield.utils;

import java.math.BigDecimal;

/**
 * Email HTML templates cho các sự kiện.
 */
public class EmailTemplates {

    private static String wrap(String title, String body) {
        return "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;padding:20px;'>"
             + "<div style='background:#da291c;color:white;padding:20px;text-align:center;border-radius:8px 8px 0 0;'>"
             + "<h2 style='margin:0;'>SportFieldHub</h2>"
             + "</div>"
             + "<div style='background:#f8f9fa;padding:25px;border:1px solid #e0e0e0;border-radius:0 0 8px 8px;'>"
             + "<h3 style='color:#1e293b;'>" + title + "</h3>"
             + body
             + "<hr style='border:none;border-top:1px solid #e0e0e0;margin:20px 0;'/>"
             + "<p style='color:#94a3b8;font-size:12px;text-align:center;'>Email này được gửi tự động, vui lòng không trả lời.</p>"
             + "</div></div>";
    }

    public static String registrationSuccess(String fullName) {
        String body = "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                    + "<p>Chúc mừng bạn đã đăng ký tài khoản thành công tại <strong>SportFieldHub</strong>!</p>"
                    + "<p>Bạn có thể đăng nhập và bắt đầu đặt sân ngay bây giờ.</p>";
        return wrap("Đăng ký thành công!", body);
    }

    public static String bookingConfirmed(String fullName, String fieldName, String date, String time, BigDecimal amount) {
        String body = "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                    + "<p>Đặt sân của bạn đã được xác nhận!</p>"
                    + "<table style='width:100%;border-collapse:collapse;margin:15px 0;'>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Sân</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + fieldName + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Ngày</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + date + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Giờ</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + time + "</td></tr>"
                    + "<tr><td style='padding:8px;color:#64748b;'>Đã thanh toán (100%)</td>"
                    + "<td style='padding:8px;font-weight:bold;color:#16a34a;'>" + amount.toPlainString() + "đ</td></tr>"
                    + "</table>"
                    + "<p>Chúc bạn có trận đấu vui vẻ! ⚽</p>";
        return wrap("Xác nhận đặt sân", body);
    }

    public static String depositConfirmed(String fullName, String fieldName, String date, String time, BigDecimal depositAmount, BigDecimal remainingAmount) {
        String body = "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                    + "<p>Bạn đã đặt cọc sân thành công!</p>"
                    + "<table style='width:100%;border-collapse:collapse;margin:15px 0;'>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Sân</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + fieldName + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Ngày</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + date + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Giờ</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + time + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Đã đặt cọc</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;color:#16a34a;'>" + depositAmount.toPlainString() + "đ</td></tr>"
                    + "<tr><td style='padding:8px;color:#64748b;'>Còn lại cần thanh toán tại sân</td>"
                    + "<td style='padding:8px;font-weight:bold;color:#da291c;'>" + remainingAmount.toPlainString() + "đ</td></tr>"
                    + "</table>"
                    + "<p>Chúc bạn có trận đấu vui vẻ! ⚽</p>";
        return wrap("Xác nhận đặt cọc sân", body);
    }

    public static String passwordChanged(String fullName) {
        String body = "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                    + "<p>Mật khẩu tài khoản của bạn đã được thay đổi thành công.</p>"
                    + "<p>Nếu bạn không thực hiện thay đổi này, vui lòng liên hệ ngay với chúng tôi.</p>";
        return wrap("Đổi mật khẩu thành công", body);
    }

    public static String bookingCancelled(String fullName, String fieldName, String date, BigDecimal refundAmount) {
        String body = "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                    + "<p>Booking sân <strong>" + fieldName + "</strong> ngày <strong>" + date + "</strong> đã được hủy.</p>";
        if (refundAmount != null && refundAmount.compareTo(BigDecimal.ZERO) > 0) {
            body += "<p>Số tiền hoàn lại: <strong style='color:#16a34a;'>" + refundAmount.toPlainString() + "đ</strong></p>";
        }
        body += "<p>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.</p>";
        return wrap("Hủy sân thành công", body);
    }

    public static String contactRequest(String fullName, String email, String phone, String subject, String message) {
        String body = "<p>Có yêu cầu liên hệ mới từ khách hàng:</p>"
                    + "<table style='width:100%;border-collapse:collapse;margin:15px 0;'>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Họ tên</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + fullName + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Email</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;'>" + email + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>SĐT</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;'>" + phone + "</td></tr>"
                    + "<tr><td style='padding:8px;border-bottom:1px solid #e0e0e0;color:#64748b;'>Chủ đề</td>"
                    + "<td style='padding:8px;border-bottom:1px solid #e0e0e0;font-weight:bold;'>" + subject + "</td></tr>"
                    + "<tr><td style='padding:8px;color:#64748b;'>Nội dung</td>"
                    + "<td style='padding:8px;'>" + message + "</td></tr>"
                    + "</table>";
        return wrap("Yêu cầu liên hệ mới", body);
    }
}
