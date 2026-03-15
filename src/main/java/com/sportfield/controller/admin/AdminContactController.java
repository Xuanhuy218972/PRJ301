package com.sportfield.controller.admin;

import java.io.IOException;
import java.util.List;

import com.sportfield.dao.ContactDAO;
import com.sportfield.model.ContactMessage;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminContactController", urlPatterns = {"/admin/contacts"})
public class AdminContactController extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    private boolean isAuthorized(HttpServletRequest request) {
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
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            HttpSession session = request.getSession();
            try {
                int contactID = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                
                // Validate status
                if (status != null && (status.equals("NEW") || status.equals("READ") || status.equals("REPLIED"))) {
                    boolean updated = contactDAO.updateContactStatus(contactID, status);
                    if (updated) {
                        session.setAttribute("successMessage", "Đã cập nhật trạng thái liên hệ thành công!");
                    } else {
                        session.setAttribute("errorMessage", "Không thể cập nhật trạng thái. Vui lòng thử lại!");
                    }
                } else {
                    session.setAttribute("errorMessage", "Trạng thái không hợp lệ!");
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            }
            // Redirect to avoid re-submit and ensure fresh data
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }
        
        // Retrieve and clear flash messages from session
        HttpSession session = request.getSession();
        String success = (String) session.getAttribute("successMessage");
        String error = (String) session.getAttribute("errorMessage");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("successMessage");
        }
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("errorMessage");
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
