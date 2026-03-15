package com.sportfield.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.FieldSlot;
import com.sportfield.model.SportField;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminFieldController", urlPatterns = {"/admin/fields"})
public class AdminFieldController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User account = (User) session.getAttribute("account");
            return account != null && "ADMIN".equals(account.getRole());
        }
        return false;
    }

    private boolean isStaffOrAdmin(HttpServletRequest request) {
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
        if (!isStaffOrAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        // STAFF only has access to "list", "manageSlots" (view only)
        if ("STAFF".equals(((User)request.getSession().getAttribute("account")).getRole())) {
            if (!"list".equals(action) && !"manageSlots".equals(action)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Staff only allowed to view fields and slots");
                return;
            }
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "manageSlots":
                manageSlots(request, response);
                break;
            case "list":
            default:
                listFields(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required for modifications");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
            return;
        }

        switch (action) {
            case "insert":
                insertField(request, response);
                break;
            case "update":
                updateField(request, response);
                break;
            case "delete":
                deleteField(request, response);
                break;
            case "hide":
                hideField(request, response);
                break;
            case "addSlot":
                addSlot(request, response);
                break;
            case "updateSlot":
                updateSlot(request, response);
                break;
            case "deleteSlot":
                deleteSlot(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/fields");
                break;
        }
    }

    private void listFields(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SportField> fields = fieldDAO.getAll();
        request.setAttribute("fields", fields);
        request.getRequestDispatcher("/views/admin/fields/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/fields/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
            return;
        }

        try {
            int fieldID = Integer.parseInt(idParam);
            SportField field = fieldDAO.getByID(fieldID);
            
            if (field != null) {
                request.setAttribute("field", field);
                request.getRequestDispatcher("/views/admin/fields/form.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy sân");
                response.sendRedirect(request.getContextPath() + "/admin/fields");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }

    private void insertField(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fieldName = request.getParameter("fieldName");
            int fieldType = Integer.parseInt(request.getParameter("fieldType"));
            BigDecimal pricePerHour = new BigDecimal(request.getParameter("pricePerHour"));
            String imageURL = request.getParameter("imageURL");
            String status = request.getParameter("status");

            SportField field = new SportField();
            field.setFieldName(fieldName);
            field.setFieldType(fieldType);
            field.setPricePerHour(pricePerHour);
            field.setImageURL(imageURL);
            field.setStatus(status);

            boolean success = fieldDAO.insert(field);
            
            if (success) {
                request.getSession().setAttribute("success", "Thêm sân thành công");
            } else {
                request.getSession().setAttribute("error", "Thêm sân thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/fields");
    }

    private void updateField(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int fieldID = Integer.parseInt(request.getParameter("fieldID"));
            String fieldName = request.getParameter("fieldName");
            int fieldType = Integer.parseInt(request.getParameter("fieldType"));
            BigDecimal pricePerHour = new BigDecimal(request.getParameter("pricePerHour"));
            String imageURL = request.getParameter("imageURL");
            String status = request.getParameter("status");

            SportField field = new SportField();
            field.setFieldID(fieldID);
            field.setFieldName(fieldName);
            field.setFieldType(fieldType);
            field.setPricePerHour(pricePerHour);
            field.setImageURL(imageURL);
            field.setStatus(status);

            boolean success = fieldDAO.update(field);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật sân thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật sân thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/fields");
    }

    private void deleteField(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int fieldID = Integer.parseInt(request.getParameter("id"));
            
            slotDAO.deleteByFieldID(fieldID);
            boolean success = fieldDAO.delete(fieldID);
            
            if (success) {
                request.getSession().setAttribute("success", "Xóa sân thành công");
            } else {
                request.getSession().setAttribute("error", "Xóa sân thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/fields");
    }

    private void hideField(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int fieldID = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("newStatus");
            
            boolean success = fieldDAO.updateStatus(fieldID, newStatus);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật trạng thái thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/fields");
    }

    private void manageSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
            return;
        }

        try {
            int fieldID = Integer.parseInt(idParam);
            SportField field = fieldDAO.getByID(fieldID);
            List<FieldSlot> slots = slotDAO.getByFieldID(fieldID);
            
            if (field != null) {
                request.setAttribute("field", field);
                request.setAttribute("slots", slots);
                request.getRequestDispatcher("/views/admin/fields/slots.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy sân");
                response.sendRedirect(request.getContextPath() + "/admin/fields");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }

    private void addSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int fieldID = Integer.parseInt(request.getParameter("fieldID"));
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String status = request.getParameter("status");

            FieldSlot slot = new FieldSlot();
            slot.setFieldID(fieldID);
            slot.setStartTime(java.time.LocalTime.parse(startTime));
            slot.setEndTime(java.time.LocalTime.parse(endTime));
            slot.setPrice(price);
            slot.setStatus(status);

            boolean success = slotDAO.insert(slot);
            
            if (success) {
                request.getSession().setAttribute("success", "Thêm khung giờ thành công");
            } else {
                request.getSession().setAttribute("error", "Thêm khung giờ thất bại");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/fields?action=manageSlots&id=" + fieldID);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }

    private void updateSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int slotID = Integer.parseInt(request.getParameter("slotID"));
            int fieldID = Integer.parseInt(request.getParameter("fieldID"));
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String status = request.getParameter("status");

            FieldSlot slot = new FieldSlot();
            slot.setSlotID(slotID);
            slot.setFieldID(fieldID);
            slot.setStartTime(java.time.LocalTime.parse(startTime));
            slot.setEndTime(java.time.LocalTime.parse(endTime));
            slot.setPrice(price);
            slot.setStatus(status);

            boolean success = slotDAO.update(slot);
            
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật khung giờ thành công");
            } else {
                request.getSession().setAttribute("error", "Cập nhật khung giờ thất bại");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/fields?action=manageSlots&id=" + fieldID);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }

    private void deleteSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int slotID = Integer.parseInt(request.getParameter("slotID"));
            int fieldID = Integer.parseInt(request.getParameter("fieldID"));
            
            boolean success = slotDAO.delete(slotID);
            
            if (success) {
                request.getSession().setAttribute("success", "Xóa khung giờ thành công");
            } else {
                request.getSession().setAttribute("error", "Xóa khung giờ thất bại");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/fields?action=manageSlots&id=" + fieldID);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }
}
