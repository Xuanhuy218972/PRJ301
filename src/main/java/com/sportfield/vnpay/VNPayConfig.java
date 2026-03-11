package com.sportfield.vnpay;

/**
 * VNPay Configuration Constants.
 * Replace vnp_TmnCode and vnp_HashSecret with your actual sandbox credentials
 * from https://sandbox.vnpayment.vn/devreg
 */
public class VNPayConfig {

    // ===== VNPAY SANDBOX CREDENTIALS =====
    public static final String VNP_TMN_CODE = "H07067R0";
    public static final String VNP_HASH_SECRET = "ZOAC1FZIEMPTZD4GT5SUGE0WSAX0V0WZ";
    // =====================================

    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_ORDER_TYPE = "billpayment";
    public static final String VNP_LOCALE = "vn";
    public static final String VNP_CURRENCY_CODE = "VND";
    public static final String VNP_RETURN_URL_PATH = "/vnpay-return";
}
