package com.sportfield.controller.customer;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;

import com.sportfield.model.FieldSlot;
import com.sportfield.model.SearchResultDTO;
import com.sportfield.model.SportField;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SearchController", urlPatterns = { "/search" })
public class SearchController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String dateParam = request.getParameter("date");
        String typeParam = request.getParameter("type");
        String timeRange = request.getParameter("timeRange");

        if (dateParam == null || dateParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        LocalDate searchDate;
        try {
            searchDate = LocalDate.parse(dateParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (searchDate.isBefore(LocalDate.now())) {
            searchDate = LocalDate.now();
        }

        LocalTime minTime = LocalTime.MIN;
        LocalTime maxTime = LocalTime.MAX;

        if (timeRange != null) {
            switch (timeRange) {
                case "MORNING":
                    minTime = LocalTime.of(6, 0);
                    maxTime = LocalTime.of(12, 0);
                    break;
                case "AFTERNOON":
                    minTime = LocalTime.of(12, 0);
                    maxTime = LocalTime.of(18, 0);
                    break;
                case "EVENING":
                    minTime = LocalTime.of(18, 0);
                    maxTime = LocalTime.of(23, 30);
                    break;
                default:
                    break;
            }
        }

        List<SportField> fields;
        if (typeParam != null && !typeParam.isEmpty()) {
            try {
                int type = Integer.parseInt(typeParam);
                fields = fieldDAO.getActiveFieldsByType(type);
            } catch (NumberFormatException e) {
                fields = fieldDAO.getActiveFields();
            }
        } else {
            fields = fieldDAO.getActiveFields();
        }

        List<SearchResultDTO> searchResults = new ArrayList<>();

        for (SportField field : fields) {
            List<FieldSlot> allSlots = slotDAO.getByFieldID(field.getFieldID());
            List<Integer> bookedSlotIDs = bookingDAO.getBookedSlotIDs(field.getFieldID(), searchDate);

            List<FieldSlot> availableSlots = new ArrayList<>();

            for (FieldSlot slot : allSlots) {
                if (!"ACTIVE".equals(slot.getStatus())) {
                    continue;
                }

                if (slot.getStartTime().isBefore(minTime) || slot.getStartTime().isAfter(maxTime)
                        || slot.getStartTime().equals(maxTime)) {
                    continue;
                }

                if (searchDate.equals(LocalDate.now())) {
                    LocalDateTime slotStartDateTime = searchDate.atTime(slot.getStartTime());
                    if (slotStartDateTime.isBefore(LocalDateTime.now())) {
                        continue;
                    }
                }

                if (!bookedSlotIDs.contains(slot.getSlotID())) {
                    availableSlots.add(slot);
                }
            }

            if (!availableSlots.isEmpty()) {
                searchResults.add(new SearchResultDTO(field, availableSlots));
            }
        }

        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchDate", searchDate);
        request.setAttribute("selectedType", typeParam);
        request.setAttribute("selectedTimeRange", timeRange);

        request.getRequestDispatcher("/views/customer/search-results.jsp").forward(request, response);
    }
}
