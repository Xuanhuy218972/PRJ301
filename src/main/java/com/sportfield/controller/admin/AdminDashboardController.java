package com.sportfield.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.ReportDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.dao.UserDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.SportField;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminDashboardController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null || (!"ADMIN".equals(account.getRole()) && !"STAFF".equals(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        // --- Common data for both ADMIN and STAFF ---
        List<SportField> fields = fieldDAO.getAll();
        int totalFields = fields.size();

        long activeFields = 0;
        for (SportField f : fields) {
            if ("ACTIVE".equals(f.getStatus())) {
                activeFields++;
            }
        }

        int bookingsToday = bookingDAO.countBookingsToday();

        List<User> allUsers = userDAO.getAll();
        int totalCustomers = 0;
        for (User u : allUsers) {
            if ("CUSTOMER".equals(u.getRole())) {
                totalCustomers++;
            }
        }

        List<Booking> recentBookings = bookingDAO.getAllBookings();
        int recentLimit = Math.min(recentBookings.size(), 5);
        List<Booking> latestBookings = recentBookings.subList(0, recentLimit);

        request.setAttribute("totalFields", totalFields);
        request.setAttribute("activeFields", activeFields);
        request.setAttribute("bookingsToday", bookingsToday);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("latestBookings", latestBookings);

        // --- ADMIN-only data: revenue + 12-month chart ---
        if ("ADMIN".equals(account.getRole())) {
            BigDecimal monthlyRevenue = bookingDAO.getMonthlyRevenue();
            String currentYear = String.valueOf(java.time.LocalDate.now().getYear());
            Map<Integer, BigDecimal> monthlyChart = reportDAO.getMonthlyRevenueByYear(currentYear);

            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("monthlyChart", monthlyChart);
            request.setAttribute("chartYear", currentYear);
        }

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
