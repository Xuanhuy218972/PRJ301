package com.sportfield.controller;

import java.io.IOException;
import java.util.List;

import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.SportField;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ShopController", urlPatterns = {"/shop"})
public class ShopController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String typeParam = request.getParameter("type");
        List<SportField> fields;
        String selectedType = "ALL";

        if ("5".equals(typeParam) || "7".equals(typeParam)) {
            int fieldType = Integer.parseInt(typeParam);
            fields = fieldDAO.getActiveFieldsByType(fieldType);
            selectedType = typeParam;
        } else {
            fields = fieldDAO.getActiveFields();
        }

        request.setAttribute("fields", fields);
        request.setAttribute("selectedType", selectedType);
        request.getRequestDispatcher("/views/customer/shop.jsp").forward(request, response);
    }
}
