package com.sportfield.controller;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.SportField;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeController", urlPatterns = { "/home" })
public class HomeController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<SportField> allFields = fieldDAO.getActiveFields();

        List<SportField> hotFields = allFields.stream()
                .limit(3)
                .collect(Collectors.toList());

        request.setAttribute("hotFields", hotFields);

        com.sportfield.dao.FieldSlotDAO fieldSlotDAO = new com.sportfield.dao.FieldSlotDAO();
        List<com.sportfield.model.HotSlotDTO> hotSlots = fieldSlotDAO.getHotSlots();
        request.setAttribute("hotSlots", hotSlots);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
