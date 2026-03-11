package com.sportfield.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.sportfield.dao.BookingDAO;
import com.sportfield.model.Booking;
import com.sportfield.model.BookingDetail;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminBookingController extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

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

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showDetail(request, response);
                break;
            case "list":
            default:
                listBookings(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
            return;
        }

        switch (action) {
            case "updateStatus":
                updateStatus(request, response);
                break;
            case "delete":
                deleteBooking(request, response);
                break;
            case "addService":
                addService(request, response);
                break;
            case "checkout":
                checkout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/bookings");
                break;
        }
    }

    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String dateFilter = request.getParameter("date");
        String nameFilter = request.getParameter("customerName");
        
        List<Booking> bookings = bookingDAO.getBookingsByFilters(statusFilter, dateFilter, nameFilter);
        
        request.setAttribute("currentStatus", statusFilter);
        request.setAttribute("selectedDate", dateFilter);
        request.setAttribute("selectedCustomerName", nameFilter);

        int pendingCount = bookingDAO.countByStatus("PENDING");
        int confirmedCount = bookingDAO.countByStatus("CONFIRMED");
        int completedCount = bookingDAO.countByStatus("COMPLETED");
        int cancelledCount = bookingDAO.countByStatus("CANCELLED");

        request.setAttribute("bookings", bookings);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("confirmedCount", confirmedCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);

        request.getRequestDispatcher("/views/admin/bookings/list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idParam);
            Booking booking = bookingDAO.getBookingByID(bookingID);

            if (booking != null) {
                List<BookingDetail> details = bookingDAO.getDetailsByBookingID(bookingID);
                request.setAttribute("booking", booking);
                request.setAttribute("details", details);
                request.getRequestDispatcher("/views/admin/bookings/detail.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy đơn đặt sân");
                response.sendRedirect(request.getContextPath() + "/admin/bookings");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            String newStatus = request.getParameter("newStatus");

            boolean success = bookingDAO.updateStatus(bookingID, newStatus);

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật trạng thái đơn #" + bookingID + " thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingID = Integer.parseInt(request.getParameter("id"));
            boolean success = bookingDAO.deleteBooking(bookingID);

            if (success) {
                request.getSession().setAttribute("success", "Xóa đơn đặt sân #" + bookingID + " thành công");
            } else {
                request.getSession().setAttribute("error", "Xóa đơn đặt sân thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }

    private void addService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            BigDecimal amount = new BigDecimal(request.getParameter("serviceAmount"));
            String description = request.getParameter("serviceDesc");

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.getSession().setAttribute("error", "Số tiền dịch vụ phải lớn hơn 0");
            } else {
                boolean success = bookingDAO.addServiceCharge(bookingID, amount, description != null ? description : "Dịch vụ khác");
                if (success) {
                    request.getSession().setAttribute("success", "Thêm dịch vụ thành công: " + amount + "đ — " + description);
                } else {
                    request.getSession().setAttribute("error", "Thêm dịch vụ thất bại");
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/bookings?action=detail&id=" + bookingID);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
        }
    }

    private void checkout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));

            // Get current booking to calculate total
            Booking booking = bookingDAO.getBookingByID(bookingID);
            if (booking == null) {
                request.getSession().setAttribute("error", "Không tìm thấy đơn");
                response.sendRedirect(request.getContextPath() + "/admin/bookings");
                return;
            }

            // Mark as fully paid
            BigDecimal totalPrice = booking.getTotalPrice();
            boolean success = bookingDAO.updatePaymentInfo(bookingID, totalPrice, "PAID", "COMPLETED");

            if (success) {
                request.getSession().setAttribute("success", "Checkout thành công đơn #BK" + bookingID + " — Đã thu đủ " + totalPrice + "đ");
            } else {
                request.getSession().setAttribute("error", "Checkout thất bại");
            }

            response.sendRedirect(request.getContextPath() + "/admin/bookings?action=detail&id=" + bookingID);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/bookings");
        }
    }
}
