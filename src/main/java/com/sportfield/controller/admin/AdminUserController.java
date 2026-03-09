package com.sportfield.controller.admin;

import java.io.IOException;
import java.util.List;

import com.sportfield.dao.UserDAO;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Admin User Management Controller
 * @author hxhbang
 */
@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User account = (User) session.getAttribute("account");
            return account != null && "ADMIN".equals(account.getRole());
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin only");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "list":
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin only");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        switch (action) {
            case "update":
                updateUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "changeRole":
                changeUserRole(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String type = request.getParameter("type");
        List<User> users;

        if ("new_customers".equals(type)) {
            String monthStr = request.getParameter("month");
            String yearStr = request.getParameter("year");
            
            int month = 0;
            int year = 0;
            
            try {
                if (monthStr != null && !monthStr.isEmpty()) {
                    month = Integer.parseInt(monthStr);
                } else {
                    month = java.time.LocalDate.now().getMonthValue();
                }
                
                if (yearStr != null && !yearStr.isEmpty()) {
                    year = Integer.parseInt(yearStr);
                } else {
                    year = java.time.LocalDate.now().getYear();
                }
            } catch (NumberFormatException e) {
                month = java.time.LocalDate.now().getMonthValue();
                year = java.time.LocalDate.now().getYear();
            }
            
            users = userDAO.getNewCustomers(month, year);
            request.setAttribute("selectedRole", "NEW_CUSTOMERS");
            request.setAttribute("filterMonth", month);
            request.setAttribute("filterYear", year);
        } else if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) {
            users = userDAO.getUsersByRole(role);
            request.setAttribute("selectedRole", role);
        } else {
            users = userDAO.getAll();
            request.setAttribute("selectedRole", "ALL");
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/admin/users/list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userID = Integer.parseInt(idParam);
            User user = userDAO.getUserByID(userID);
            
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/views/admin/users/form.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/users");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("userID"));
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String avatar = request.getParameter("avatar");
            String walletBalanceParam = request.getParameter("walletBalance");

            User user = new User();
            user.setUserID(userID);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setGender(gender);
            user.setDateOfBirth(dateOfBirth);
            
            // Set avatar URL nếu có
            if (avatar != null && !avatar.trim().isEmpty()) {
                user.setAvatar(avatar.trim());
            }

            if (walletBalanceParam != null && !walletBalanceParam.trim().isEmpty()) {
                try {
                    double walletBalance = Double.parseDouble(walletBalanceParam);
                    if (walletBalance < 0) {
                        walletBalance = 0;
                    }
                    user.setWalletBalance(walletBalance);
                } catch (NumberFormatException ignored) {
                }
            }

            boolean success = userDAO.update(user);
            
            if (success) {
                request.getSession().setAttribute("success", "User updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update user");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("id"));
            
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("account");
            
            if (currentUser.getUserID() == userID) {
                request.getSession().setAttribute("error", "Cannot delete your own account");
            } else {
                boolean success = userDAO.delete(userID);
                
                if (success) {
                    request.getSession().setAttribute("success", "User deleted successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to delete user");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void changeUserRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userID = Integer.parseInt(request.getParameter("id"));
            String newRole = request.getParameter("newRole");

            if (!newRole.equals("ADMIN") && !newRole.equals("STAFF") && !newRole.equals("CUSTOMER")) {
                request.getSession().setAttribute("error", "Invalid role");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("account");
            
            if (currentUser.getUserID() == userID) {
                request.getSession().setAttribute("error", "Cannot change your own role");
            } else {
                boolean success = userDAO.changeRole(userID, newRole);
                
                if (success) {
                    request.getSession().setAttribute("success", "User role changed successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to change user role");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
