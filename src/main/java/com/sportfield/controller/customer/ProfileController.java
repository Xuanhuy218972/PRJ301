package com.sportfield.controller.customer;

import java.io.IOException;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.UserDAO;
import com.sportfield.model.BookingDetail;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile" })
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = userDAO.getUserByID(account.getUserID());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<BookingDetail> bookings = bookingDAO.getBookingsByUserID(user.getUserID());

        request.setAttribute("user", user);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/views/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User account = null;
        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, account);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, account);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User account)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        User user = userDAO.getUserByID(account.getUserID());
        if (user != null) {
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setEmail(email);

            if (userDAO.update(user)) {
                request.getSession().setAttribute("account", user);
                request.getSession().setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.getSession().setAttribute("error", "Cập nhật thông tin thất bại!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User account)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.getSession().setAttribute("error", "Mật khẩu mới không khớp!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        User user = userDAO.getUserByID(account.getUserID());
        if (user != null && user.getPassword().equals(currentPassword)) {
            user.setPassword(newPassword);
            if (userDAO.update(user)) {
                request.getSession().setAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                request.getSession().setAttribute("error", "Đổi mật khẩu thất bại!");
            }
        } else {
            request.getSession().setAttribute("error", "Mật khẩu hiện tại không đúng!");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
