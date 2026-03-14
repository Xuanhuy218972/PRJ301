package com.sportfield.listener;

import com.sportfield.dao.BookingDAO;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class BookingJobListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(BookingJobListener.class.getName());
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Job 1: Auto-cancel PENDING bookings > 30 phút (chạy mỗi 10 phút)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                BookingDAO dao = new BookingDAO();
                int cancelled = dao.autoCancelExpiredPendingBookings();
                if (cancelled > 0) {
                    LOGGER.info("[BookingJob] Auto-cancelled " + cancelled + " expired PENDING bookings");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[BookingJob] Error in auto-cancel job", e);
            }
        }, 5, 10, TimeUnit.MINUTES);

        // Job 2: Auto-complete bookings đã qua ngày đá (chạy mỗi 60 phút)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                BookingDAO dao = new BookingDAO();
                int completed = dao.autoCompletePassedBookings();
                if (completed > 0) {
                    LOGGER.info("[BookingJob] Auto-completed " + completed + " passed bookings");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[BookingJob] Error in auto-complete job", e);
            }
        }, 10, 60, TimeUnit.MINUTES);

        // Job 3: Low Occupancy Alert (Gửi deal hời vào 8h sáng hàng ngày)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                com.sportfield.dao.FieldSlotDAO slotDAO = new com.sportfield.dao.FieldSlotDAO();
                java.util.List<com.sportfield.model.HotSlotDTO> slots = slotDAO.getHotSlots();
                if (!slots.isEmpty()) {
                    com.sportfield.dao.UserDAO userDAO = new com.sportfield.dao.UserDAO();
                    java.util.List<com.sportfield.model.User> customers = userDAO.getUsersByRole("CUSTOMER");
                    String subject = "🔥 SportFieldHub - Deal Hời Hôm Nay!";
                    String htmlBody = com.sportfield.utils.EmailTemplates.lowOccupancyAlert(slots);
                    for (com.sportfield.model.User u : customers) {
                        if (u.getEmail() != null) {
                            com.sportfield.utils.EmailService.sendEmail(u.getEmail(), subject, htmlBody);
                        }
                    }
                    LOGGER.info("[BookingJob] Sent low occupancy alert to " + customers.size() + " customers");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[BookingJob] Error in low occupancy alert job", e);
            }
        }, 1, 24 * 60, TimeUnit.MINUTES);

        // Job 4: Daily Revenue Report
        scheduler.scheduleAtFixedRate(() -> {
            try {
                BookingDAO dao = new BookingDAO();
                java.math.BigDecimal daily = dao.getDailyRevenue();
                java.math.BigDecimal weekly = dao.getWeeklyRevenue();
                int dailyBookings = dao.countBookingsToday();
                String subject = "📊 Báo cáo doanh thu SportFieldHub - " + java.time.LocalDate.now();
                String htmlBody = com.sportfield.utils.EmailTemplates.dailyRevenueReport(daily, weekly, dailyBookings);
                com.sportfield.utils.EmailService.sendEmail(com.sportfield.utils.EmailConfig.ADMIN_EMAIL, subject, htmlBody);
                LOGGER.info("[BookingJob] Sent daily revenue report to admin");
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[BookingJob] Error in revenue report job", e);
            }
        }, 5, 24 * 60, TimeUnit.MINUTES);

        LOGGER.info("[BookingJob] Background jobs initialized (Total 4 jobs)");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            LOGGER.info("[BookingJob] Background jobs stopped");
        }
    }
}
