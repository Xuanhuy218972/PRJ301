package com.sportfield.vnpay;

import io.github.cdimascio.dotenv.Dotenv;

/**
 * VNPay Configuration Constants.
 * Đọc từ System env (Docker) hoặc .env file (local).
 */
public class VNPayConfig {

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

    public static final String VNP_TMN_CODE       = getEnv("VNPAY_TMN_CODE", "");
    public static final String VNP_HASH_SECRET    = getEnv("VNPAY_HASH_SECRET", "");
    public static final String VNP_PAY_URL        = getEnv("VNPAY_URL", "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
    public static final String VNP_VERSION        = "2.1.0";
    public static final String VNP_COMMAND        = "pay";
    public static final String VNP_ORDER_TYPE     = "billpayment";
    public static final String VNP_LOCALE         = "vn";
    public static final String VNP_CURRENCY_CODE  = "VND";
    public static final String VNP_RETURN_URL_PATH = "/vnpay-return";
}
