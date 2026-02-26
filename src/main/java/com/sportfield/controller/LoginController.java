package com.sportfield.controller;

import java.io.IOException;

import com.sportfield.dao.UserDAO;
import com.sportfield.model.User;
import com.sportfield.utils.SecurityUtils;
import com.sportfield.utils.ValidationUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/login-internal", "/admin"})
public class LoginController extends HttpServlet {

    private static final String CUSTOMER_PAGE = "views/auth/login.jsp";
    private static final String INTERNAL_PAGE = "views/auth/login-internal.jsp";
    private static final String ROLE_ADMIN = "ADMIN";
    private static final String ROLE_STAFF = "STAFF";
    private static final String ROLE_CUSTOMER = "CUSTOMER";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String targetPage;

        HttpSession session = request.getSession(false);
        User account = null;
        String role = null;

        if (session != null) {
            account = (User) session.getAttribute("account");
            if (account != null) {
                role = account.getRole();
            }
        }

        boolean isStaff = ROLE_ADMIN.equals(role) || ROLE_STAFF.equals(role);
        boolean isCustomer = ROLE_CUSTOMER.equals(role);

        if (isStaff && "/login".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if (isStaff && ("/admin".equals(path) || "/login-internal".equals(path))) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        if (isCustomer && "/admin".equals(path)) {
            request.setAttribute("error", "Bạn không có quyền truy cập khu vực quản trị.");
            request.getRequestDispatcher(INTERNAL_PAGE).forward(request, response);
            return;
        }

        if (session != null) {
            String authError = (String) session.getAttribute("authError");
            if (authError != null) {
                request.setAttribute("error", authError);
                session.removeAttribute("authError");
            }
        }

        if ("/login-internal".equals(path) || "/admin".equals(path)) {
            targetPage = INTERNAL_PAGE;
        } else {
            targetPage = CUSTOMER_PAGE;
        }

        request.getRequestDispatcher(targetPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType");

        if (loginType == null || loginType.trim().isEmpty()) {
            loginType = "customer";
        }

        if (ValidationUtils.isEmpty(username)) {
            forwardWithError(request, response, "Vui lòng nhập tên đăng nhập!", username, loginType);
            return;
        }

        if (ValidationUtils.isEmpty(password)) {
            forwardWithError(request, response, "Vui lòng nhập mật khẩu!", username, loginType);
            return;
        }

        UserDAO userDAO = new UserDAO();
        String hashedPassword = SecurityUtils.hashPassword(password);

        User account = null;
        try {
            account = userDAO.login(username.trim(), hashedPassword);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("System error when trying to login for username: " + username);
        }

        if (account == null) {
            System.out.println("Login failed for username: " + username);
            forwardWithError(request, response, "Tài khoản hoặc mật khẩu không chính xác!", username, loginType);
            return;
        }

        String role = account.getRole();
        boolean isStaff = ROLE_ADMIN.equals(role) || ROLE_STAFF.equals(role);
        boolean isCustomer = ROLE_CUSTOMER.equals(role);

        if ("internal".equals(loginType) && !isStaff) {
            System.out.println("Unauthorized internal login attempt by username: " + username);
            forwardWithError(request, response,
                    "Tài khoản của bạn không có quyền truy cập trang Quản trị!", username, "internal");
            return;
        }

        if ("customer".equals(loginType) && !isCustomer) {
            System.out.println("Unauthorized customer login attempt by username: " + username);
            forwardWithError(request, response,
                    "Tài khoản nhân viên/ quản trị, vui lòng đăng nhập qua cổng dành cho Nhân viên!", username,
                    "customer");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("account", account);
        session.setAttribute("userRole", role);
        session.setMaxInactiveInterval(30 * 60);

        if (isStaff) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
            String errorMsg, String username, String loginType) throws ServletException, IOException {

        request.setAttribute("error", errorMsg);
        request.setAttribute("username", username);

        String targetPage = getLoginPageByType(loginType);
        request.getRequestDispatcher(targetPage).forward(request, response);
    }

    private String getLoginPageByType(String loginType) {
        if ("internal".equals(loginType)) {
            return INTERNAL_PAGE;
        }
        return CUSTOMER_PAGE;
    }
}
