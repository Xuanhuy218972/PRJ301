/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.sportfield.validator;

import com.sportfield.utils.ValidationUtils;
import jakarta.servlet.http.HttpServletRequest;

/**
 *
 * @author hxhbang
 */

public class RegisterValidator {

    public static String validate(HttpServletRequest request) {
        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String pass = request.getParameter("password");
        String repass = request.getParameter("confirm_password");

        if (ValidationUtils.isEmpty(fullname) || ValidationUtils.isEmpty(username) ||
            ValidationUtils.isEmpty(email) || ValidationUtils.isEmpty(phone) ||
            ValidationUtils.isEmpty(pass)) {
            return "Vui lòng điền đầy đủ thông tin!";
        }

        if (!ValidationUtils.isValidEmail(email)) {
            return "Email không đúng định dạng!";
        }
        
        if (!ValidationUtils.isValidPhone(phone)) {
            return "Số điện thoại không hợp lệ (Phải có 10 số)!";
        }

        if (!pass.equals(repass)) {
            return "Mật khẩu xác nhận không khớp!";
        }
        
        return null;
    }
}