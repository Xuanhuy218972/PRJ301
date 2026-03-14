package com.sportfield.vnpay;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Utility class for VNPay HMAC-SHA512 signing and URL building.
 */
public class VNPayUtil {

    /**
     * HMAC-SHA512 hash function.
     */
    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] hash = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error generating HMAC-SHA512", e);
        }
    }

    /**
     * Build the VNPay payment URL from parameters.
     */
    public static String buildPaymentUrl(Map<String, String> params) {
        // Sort params alphabetically by key
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (int i = 0; i < fieldNames.size(); i++) {
            String fieldName = fieldNames.get(i);
            String fieldValue = params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                try {
                    // VNPay requires exact URL encoding for both hashData and query string
                    String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                    
                    hashData.append(fieldName).append('=').append(encodedValue);
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                         .append('=')
                         .append(encodedValue);
                         
                    if (i < fieldNames.size() - 1) {
                        hashData.append('&');
                        query.append('&');
                    }
                } catch (Exception e) {
                    throw new RuntimeException("URL encoding error", e);
                }
            }
        }

        String vnpSecureHash = hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnpSecureHash);

        return VNPayConfig.VNP_PAY_URL + "?" + query.toString();
    }

    /**
     * Verify the VNPay return hash from response parameters.
     */
    public static boolean verifyReturnHash(Map<String, String> params) {
        String vnpSecureHash = params.get("vnp_SecureHash");
        if (vnpSecureHash == null) return false;

        // Remove hash params from the map before re-computing
        Map<String, String> cleanParams = new TreeMap<>(params);
        cleanParams.remove("vnp_SecureHash");
        cleanParams.remove("vnp_SecureHashType");

        // Build hash data string (sorted alphabetically)
        StringBuilder hashData = new StringBuilder();
        List<String> keys = new ArrayList<>(cleanParams.keySet());
        Collections.sort(keys);

        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = cleanParams.get(key);
            if (value != null && !value.isEmpty()) {
                try {
                    hashData.append(key).append('=').append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));
                    if (i < keys.size() - 1) {
                        hashData.append('&');
                    }
                } catch (Exception e) {
                    throw new RuntimeException("URL encoding error", e);
                }
            }
        }

        String computedHash = hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        return computedHash.equalsIgnoreCase(vnpSecureHash);
    }

    /**
     * Generate current timestamp in VNPay format: yyyyMMddHHmmss
     */
    public static String getCurrentTimestamp() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        return formatter.format(new Date());
    }

    /**
     * Generate expire timestamp (15 minutes from now)
     */
    public static String getExpireTimestamp() {
        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        cal.add(Calendar.MINUTE, 15);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        formatter.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        return formatter.format(cal.getTime());
    }

    /**
     * Get client IP address.
     */
    public static String getIpAddress(jakarta.servlet.http.HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        // Normalize localhost IPv6
        if ("0:0:0:0:0:0:0:1".equals(ipAddress)) {
            ipAddress = "127.0.0.1";
        }
        return ipAddress;
    }
}
