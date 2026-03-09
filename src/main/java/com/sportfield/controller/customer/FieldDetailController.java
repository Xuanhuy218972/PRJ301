package com.sportfield.controller.customer;

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

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FieldDetailController", urlPatterns = { "/field-detail" })
public class FieldDetailController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        int fieldID;
        try {
            fieldID = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        SportField field = fieldDAO.getByID(fieldID);
        if (field == null || !"ACTIVE".equals(field.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        String weekParam = request.getParameter("week");
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

        request.getRequestDispatcher("/views/customer/field-detail.jsp").forward(request, response);
    }
}
