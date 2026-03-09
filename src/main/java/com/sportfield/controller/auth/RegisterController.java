/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.sportfield.controller.auth;

import java.io.IOException;

import com.sportfield.dao.UserDAO;
import com.sportfield.model.User;
import com.sportfield.validator.RegisterValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author hxhbang
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object roleObj = session.getAttribute("userRole");
            String userRole = roleObj instanceof String ? (String) roleObj : null;
            if ("ADMIN".equals(userRole) || "STAFF".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }

        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object roleObj = session.getAttribute("userRole");
            String userRole = roleObj instanceof String ? (String) roleObj : null;
            if ("ADMIN".equals(userRole) || "STAFF".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
        }

        request.setCharacterEncoding("UTF-8");

        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String pass = request.getParameter("password");
        String repass = request.getParameter("confirm_password");
        String avatar = request.getParameter("avatar");

        String error = RegisterValidator.validate(request);

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("param", request.getParameterMap());
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        if (dao.checkUserExist(username, email)) {
            forwardWithError(request, response, "Username hoặc Email đã được sử dụng!");
            return;
        }

        User newUser = new User();
        newUser.setFullName(fullname);
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        String hashedPass = com.sportfield.utils.SecurityUtils.hashPassword(pass);
        newUser.setPassword(hashedPass);
        
        // Set avatar nếu có
        if (avatar != null && !avatar.trim().isEmpty()) {
            newUser.setAvatar(avatar.trim());
        }

        boolean isSuccess = dao.register(newUser);

        if (isSuccess) {
            User account = dao.login(username, hashedPass);

            if (account != null) {
                HttpSession newSession = request.getSession();
                newSession.setAttribute("account", account);
                newSession.setAttribute("userRole", account.getRole());
                newSession.setMaxInactiveInterval(30 * 60);

                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                response.sendRedirect("views/auth/login.jsp");
            }
        } else {
            forwardWithError(request, response, "Đăng ký thất bại! Vui lòng thử lại sau.");
        }
    }
    
    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String error) 
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("param", request.getParameterMap()); 
        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
    }
}
