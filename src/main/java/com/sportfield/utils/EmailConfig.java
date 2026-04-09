package com.sportfield.utils;

import io.github.cdimascio.dotenv.Dotenv;

/**
 * Email SMTP Configuration Constants.
 * Đọc từ System env (Docker) hoặc .env file (local).
 */
public class EmailConfig {

    private static final Dotenv dotenv;
    static {
        Dotenv d;
        try {
            d = Dotenv.configure().ignoreIfMissing().load();
        } catch (Exception e) {
            d = null;
        }
        dotenv = d;
    }

    private static String getEnv(String key, String defaultValue) {
        // 1. Try system environment variable first (for Docker)
        String val = System.getenv(key);
        if (val != null && !val.isEmpty()) {
            return val;
        }
        // 2. Try dotenv (for local development)
        if (dotenv != null) {
            val = dotenv.get(key);
            if (val != null && !val.isEmpty()) {
                return val;
            }
        }
        // 3. Return default
        return defaultValue;
    }

    public static final String SMTP_HOST     = getEnv("SMTP_HOST",     "sandbox.smtp.mailtrap.io");
    public static final String SMTP_PORT     = getEnv("SMTP_PORT",     "587");
    public static final String SMTP_USER     = getEnv("SMTP_USER",     "");
    public static final String SMTP_PASSWORD = getEnv("SMTP_PASSWORD", "");
    public static final String ADMIN_EMAIL   = getEnv("ADMIN_EMAIL",   "admin@sportfieldhub.com");
    public static final String FROM_NAME     = getEnv("FROM_NAME",     "SportFieldHub");
}
