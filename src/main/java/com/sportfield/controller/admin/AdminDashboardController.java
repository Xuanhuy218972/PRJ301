package com.sportfield.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.dao.UserDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.SportField;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminDashboardController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<SportField> fields = fieldDAO.getAll();
        int totalFields = fields.size();

        long activeFields = 0;
        for (SportField f : fields) {
            if ("ACTIVE".equals(f.getStatus())) {
                activeFields++;
            }
        }

        int bookingsToday = bookingDAO.countBookingsToday();
        BigDecimal monthlyRevenue = bookingDAO.getMonthlyRevenue();

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
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("latestBookings", latestBookings);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
