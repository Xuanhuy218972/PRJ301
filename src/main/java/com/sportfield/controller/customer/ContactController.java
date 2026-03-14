package com.sportfield.controller.customer;

import java.io.IOException;
import com.sportfield.dao.ContactDAO;
import com.sportfield.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContactController", urlPatterns = {"/contact"})
public class ContactController extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/customer/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
            request.getRequestDispatcher("/views/customer/contact.jsp").forward(request, response);
            return;
        }

        ContactMessage contactMessage = new ContactMessage();
        contactMessage.setFullName(fullName.trim());
        contactMessage.setEmail(email.trim());
        contactMessage.setPhone(phone.trim());
        contactMessage.setSubject(subject.trim());
        contactMessage.setMessage(message.trim());

        boolean success = contactDAO.saveContactMessage(contactMessage);

        if (success) {
            request.setAttribute("successMessage", "Gửi yêu cầu thành công! Chúng tôi sẽ liên hệ lại sớm nhất.");

            // Send email notification to admin
            com.sportfield.utils.EmailService.sendAsync(
                com.sportfield.utils.EmailConfig.ADMIN_EMAIL,
                "Yêu cầu liên hệ từ " + fullName.trim(),
                com.sportfield.utils.EmailTemplates.contactRequest(
                    fullName.trim(), email.trim(), phone.trim(),
                    subject.trim(), message.trim()
                )
            );
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại sau!");
        }

        request.getRequestDispatcher("/views/customer/contact.jsp").forward(request, response);
    }
}
