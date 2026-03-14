package com.sportfield.listener;

import com.sportfield.dao.BookingDAO;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Background jobs cho hệ thống booking.
 * - Auto-cancel PENDING bookings > 30 phút
 * - Auto-complete bookings đã qua ngày đá
 */
@WebListener
public class BookingJobListener implements ServletContextListener {

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
                    System.out.println("[BookingJob] Auto-cancelled " + cancelled + " expired PENDING bookings");
                }
            } catch (Exception e) {
                System.err.println("[BookingJob] Error in auto-cancel job: " + e.getMessage());
            }
        }, 5, 10, TimeUnit.MINUTES);

        // Job 2: Auto-complete bookings đã qua ngày đá (chạy mỗi 60 phút)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                BookingDAO dao = new BookingDAO();
                int completed = dao.autoCompletePassedBookings();
                if (completed > 0) {
                    System.out.println("[BookingJob] Auto-completed " + completed + " passed bookings");
                }
            } catch (Exception e) {
                System.err.println("[BookingJob] Error in auto-complete job: " + e.getMessage());
            }
        }, 10, 60, TimeUnit.MINUTES);

        System.out.println("[BookingJob] Background jobs initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            System.out.println("[BookingJob] Background jobs stopped");
        }
    }
}
