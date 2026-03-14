package com.sportfield.controller.admin;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.UserDAO;
import com.sportfield.model.HotSlotDTO;
import com.sportfield.model.User;
import com.sportfield.utils.EmailConfig;
import com.sportfield.utils.EmailService;
import com.sportfield.utils.EmailTemplates;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "JobTriggerController", urlPatterns = {"/admin/trigger-jobs"})
public class JobTriggerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String type = request.getParameter("type");

        out.println("<html><body>");
        out.println("<h1>Manual Job Trigger Tool</h1>");
        out.println("<ul>");
        out.println("<li><a href='?type=cancel'>1. Test Auto-Cancel (PENDING > 30p)</a></li>");
        out.println("<li><a href='?type=complete'>2. Test Auto-Complete (Đã qua giờ đá)</a></li>");
        out.println("<li><a href='?type=alert'>3. Test Low Occupancy Alert (Gửi Mail Deal Hời cho khách)</a></li>");
        out.println("<li><a href='?type=report'>4. Test Revenue Report (Gửi Báo cáo cho Admin)</a></li>");
        out.println("</ul>");

        if (type != null) {
            out.println("<hr><pre>");
            try {
                BookingDAO bDao = new BookingDAO();
                switch (type) {
                    case "cancel":
                        int cancelled = bDao.autoCancelExpiredPendingBookings();
                        out.println("SUCCESS: Cancelled " + cancelled + " bookings.");
                        break;
                    case "complete":
                        int completed = bDao.autoCompletePassedBookings();
                        out.println("SUCCESS: Completed " + completed + " bookings.");
                        break;
                    case "alert":
                        FieldSlotDAO slotDAO = new FieldSlotDAO();
                        List<HotSlotDTO> slots = slotDAO.getHotSlots();
                        if (!slots.isEmpty()) {
                            UserDAO uDao = new UserDAO();
                            List<User> customers = uDao.getUsersByRole("CUSTOMER");
                            String html = EmailTemplates.lowOccupancyAlert(slots);
                            // Để an toàn khi test, chỉ gửi cho chính mình hoặc khách đầu tiên trong list
                            if (!customers.isEmpty()) {
                                User first = customers.get(0);
                                EmailService.sendEmail(first.getEmail(), "[TEST] 🔥 Deal Hời Hôm Nay", html);
                                out.println("SUCCESS: Sent test email to " + first.getEmail());
                            }
                        } else {
                            out.println("INFO: No hot slots available to alert.");
                        }
                        break;
                    case "report":
                        BigDecimal daily = bDao.getDailyRevenue();
                        BigDecimal weekly = bDao.getWeeklyRevenue();
                        int count = bDao.countBookingsToday();
                        String reportHtml = EmailTemplates.dailyRevenueReport(daily, weekly, count);
                        EmailService.sendEmail(EmailConfig.ADMIN_EMAIL, "[TEST] 📊 Báo cáo doanh thu", reportHtml);
                        out.println("SUCCESS: Sent revenue report to " + EmailConfig.ADMIN_EMAIL);
                        break;
                }
            } catch (Exception e) {
                out.println("ERROR: " + e.getMessage());
                e.printStackTrace(out);
            }
            out.println("</pre>");
        }
        out.println("</body></html>");
    }
}
