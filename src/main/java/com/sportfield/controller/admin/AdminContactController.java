package com.sportfield.controller.admin;

import java.io.IOException;
import java.util.List;

import com.sportfield.dao.ContactDAO;
import com.sportfield.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminContactController", urlPatterns = {"/admin/contacts"})
public class AdminContactController extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            int contactID = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            boolean success = contactDAO.updateContactStatus(contactID, status);
            
            if (success) {
                request.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật!");
            }
        }
        
        List<ContactMessage> messages = contactDAO.getAllContactMessages();
        request.setAttribute("contactMessages", messages);
        
        request.getRequestDispatcher("/views/admin/contacts/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
