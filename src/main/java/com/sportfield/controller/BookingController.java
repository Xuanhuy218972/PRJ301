package com.sportfield.controller;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;

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

@WebServlet(name = "BookingController", urlPatterns = { "/booking" })
public class BookingController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            String returnUrl = request.getRequestURI();
            String queryString = request.getQueryString();
            if (queryString != null) {
                returnUrl += "?" + queryString;
            }
            session = request.getSession(true);
            session.setAttribute("returnUrl", returnUrl);
            session.setAttribute("error", "Vui lòng đăng nhập để đặt sân!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fieldIdParam = request.getParameter("fieldId");
        String slotIdParam = request.getParameter("slotId");
        String dateParam = request.getParameter("date");

        if (fieldIdParam == null || slotIdParam == null || dateParam == null) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int fieldID = Integer.parseInt(fieldIdParam);
            int slotID = Integer.parseInt(slotIdParam);
            LocalDate bookingDate = LocalDate.parse(dateParam);

            SportField field = fieldDAO.getByID(fieldID);
            FieldSlot slot = slotDAO.getByID(slotID);

            if (field == null || slot == null || !"ACTIVE".equals(field.getStatus())
                    || !"ACTIVE".equals(slot.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            // Không cho phép đặt khung giờ đã quá thời gian
            LocalDateTime slotEndDateTime = bookingDate.atTime(slot.getEndTime());
            if (slotEndDateTime.isBefore(LocalDateTime.now())) {
                session = request.getSession(true);
                session.setAttribute("error",
                        "Không thể đặt sân vào khung giờ đã quá thời gian. Vui lòng chọn khung giờ khác.");
                LocalDate weekStart = bookingDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
                response.sendRedirect(request.getContextPath() + "/field-detail?id=" + fieldID + "&week=" + weekStart);
                return;
            }

            request.setAttribute("field", field);
            request.setAttribute("slot", slot);
            request.setAttribute("bookingDate", bookingDate);
            request.setAttribute("user", account);

            request.getRequestDispatcher("/views/customer/booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        response.sendRedirect(request.getContextPath() + "/shop");
    }
}
