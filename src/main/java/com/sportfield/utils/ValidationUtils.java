/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportfield.utils;

import java.util.regex.Pattern;

/**
 *
 * @author hxhbang
 */
public class ValidationUtils {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    private static final String PHONE_REGEX = "^0\\d{9}$";

    public static boolean isEmpty(String text) {
        return text == null || text.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return email != null && Pattern.matches(EMAIL_REGEX, email);
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && Pattern.matches(PHONE_REGEX, phone);
    }

    public static String validatePasswordStrength(String password) {
        if (password == null || password.length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự!";
        }
        if (!password.matches(".*[A-Z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ cái viết hoa!";
        }
        if (!password.matches(".*[a-z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ cái viết thường!";
        }
        if (!password.matches(".*\\d.*")) {
            return "Mật khẩu phải có ít nhất 1 chữ số!";
        }
        return null;
    }
}
