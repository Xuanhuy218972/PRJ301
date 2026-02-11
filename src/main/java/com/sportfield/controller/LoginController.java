/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.sportfield.controller;

import java.io.IOException;

import com.sportfield.dao.UserDAO;
import com.sportfield.model.User;
import com.sportfield.utils.ValidationUtils;
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
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        String errorMsg = null;

        if (ValidationUtils.isEmpty(user)) {
            errorMsg = "Vui lòng nhập tên đăng nhập!";
        } else if (ValidationUtils.isEmpty(pass)) {
            errorMsg = "Vui lòng nhập mật khẩu!";
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("username", user);
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        String hashedPass = com.sportfield.utils.SecurityUtils.hashPassword(pass);
        User account = dao.login(user.trim(), hashedPass);

        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);

            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect("index.jsp");

        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");

            request.setAttribute("username", user);

            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        }
    }
}
