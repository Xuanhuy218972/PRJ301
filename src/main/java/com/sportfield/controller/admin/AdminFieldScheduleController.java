package com.sportfield.controller.admin;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.FieldSlot;
import com.sportfield.model.SportField;
import com.sportfield.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminFieldScheduleController", urlPatterns = {"/admin/field-schedule"})
public class AdminFieldScheduleController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User account = (User) session.getAttribute("account");
            return account != null && ("ADMIN".equals(account.getRole()) || "STAFF".equals(account.getRole()));
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

        String fieldIdParam = request.getParameter("fieldId");
        String weekParam = request.getParameter("week");

        if (fieldIdParam == null || fieldIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
            return;
        }

        try {
            int fieldID = Integer.parseInt(fieldIdParam);
            SportField field = fieldDAO.getByID(fieldID);

            if (field == null) {
                request.getSession().setAttribute("error", "Không tìm thấy sân");
                response.sendRedirect(request.getContextPath() + "/admin/fields");
                return;
            }

            LocalDate weekStart;
            if (weekParam != null && !weekParam.isEmpty()) {
                weekStart = LocalDate.parse(weekParam);
            } else {
                weekStart = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            }

            List<FieldSlot> slots = slotDAO.getByFieldID(fieldID);
            var bookings = bookingDAO.getBookingsByFieldAndWeek(fieldID, weekStart);
            
            LocalDate prevWeek = weekStart.minusWeeks(1);
            LocalDate nextWeek = weekStart.plusWeeks(1);

            request.setAttribute("field", field);
            request.setAttribute("slots", slots);
            request.setAttribute("bookings", bookings);
            request.setAttribute("weekStart", weekStart);
            request.setAttribute("prevWeek", prevWeek);
            request.setAttribute("nextWeek", nextWeek);

            request.getRequestDispatcher("/views/admin/fields/schedule.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }
}
