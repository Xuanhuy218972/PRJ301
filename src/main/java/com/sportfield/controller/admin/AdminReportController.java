package com.sportfield.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.sportfield.dao.ReportDAO;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminReportController extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User account = (User) session.getAttribute("account");
            return account != null && "ADMIN".equals(account.getRole());
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        LocalDate now = LocalDate.now();
        String year = request.getParameter("year");
        String month = request.getParameter("month");

        if (year == null || year.isEmpty()) {
            year = String.valueOf(now.getYear());
        }
        if (month == null || month.isEmpty()) {
            month = String.valueOf(now.getMonthValue());
        }

        BigDecimal monthlyRevenue = reportDAO.getTotalRevenue(year, month);
        BigDecimal dailyRevenue = reportDAO.getTotalRevenueToday();
        int totalBookings = reportDAO.getTotalBookingsByMonth(year, month);
        int completedBookings = reportDAO.getCompletedBookingsByMonth(year, month);
        int cancelledBookings = reportDAO.getCancelledBookingsByMonth(year, month);
        int newCustomers = reportDAO.getNewCustomersByMonth(year, month);
        Map<Integer, BigDecimal> dailyChart = reportDAO.getDailyRevenueByMonth(year, month);
        List<Map<String, Object>> topFields = reportDAO.getTopFieldsByRevenue(year, month);
        List<Integer> availableYears = reportDAO.getAvailableYears();

        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("completedBookings", completedBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("newCustomers", newCustomers);
        request.setAttribute("dailyChart", dailyChart);
        request.setAttribute("topFields", topFields);
        request.setAttribute("availableYears", availableYears);

        request.getRequestDispatcher("/views/admin/reports/revenue.jsp").forward(request, response);
    }
}
