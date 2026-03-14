package com.sportfield.utils;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Email Service - gửi mail qua Gmail SMTP.
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

    /**
     * Gửi email (sync).
     */
    public static void sendEmail(String toEmail, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.host", EmailConfig.SMTP_HOST);
        props.put("mail.smtp.port", EmailConfig.SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EmailConfig.SMTP_USER, EmailConfig.SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EmailConfig.SMTP_USER, EmailConfig.FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=UTF-8");

            Transport.send(message);
            LOGGER.info("[EmailService] Sent to: " + toEmail);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[EmailService] Failed to send to: " + toEmail, e);
        }
    }

    /**
     * Gửi email (async) — chạy trong thread riêng, không block response.
     */
    public static void sendAsync(String toEmail, String subject, String htmlBody) {
        new Thread(() -> sendEmail(toEmail, subject, htmlBody)).start();
    }
}
