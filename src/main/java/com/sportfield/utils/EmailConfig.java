package com.sportfield.utils;

/**
 * Email SMTP Configuration Constants.
 * Dùng Gmail App Password (không phải mật khẩu thường).
 *
 * SECURITY: Nên set các giá trị này qua environment variables hoặc
 * context.xml thay vì hardcode trong source code.
 * Ví dụ trong context.xml:
 *   <Environment name="SMTP_USER" value="your@gmail.com" type="java.lang.String"/>
 *   <Environment name="SMTP_PASSWORD" value="xxxx xxxx xxxx xxxx" type="java.lang.String"/>
 */
public class EmailConfig {

    public static final String SMTP_HOST     = getEnv("SMTP_HOST",     "sandbox.smtp.mailtrap.io");
    public static final String SMTP_PORT     = getEnv("SMTP_PORT",     "587");
    public static final String SMTP_USER     = getEnv("SMTP_USER",     "e7bb8688c4669f");
    public static final String SMTP_PASSWORD = getEnv("SMTP_PASSWORD", "6aa9b014cb3eee");
    public static final String ADMIN_EMAIL   = getEnv("ADMIN_EMAIL",   "admin@sportfieldhub.com");
    public static final String FROM_NAME     = "SportFieldHub";

    private static String getEnv(String key, String defaultValue) {
        String val = System.getenv(key);
        return (val != null && !val.isEmpty()) ? val : defaultValue;
    }
}
