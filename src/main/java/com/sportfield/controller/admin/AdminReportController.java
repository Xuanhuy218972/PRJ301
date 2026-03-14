package com.sportfield.controller.admin;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.sportfield.dao.ReportDAO;
import com.sportfield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class AdminReportController extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User account = (User) session.getAttribute("account");
            return account != null && "ADMIN".equals(account.getRole());
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");

        if ("exportExcel".equals(action)) {
            exportExcel(request, response);
            return;
        }

        // Default: show revenue report page
        showRevenueReport(request, response);
    }

    private void showRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocalDate now = LocalDate.now();
        String year = request.getParameter("year");
        String month = request.getParameter("month");

        if (year == null || year.isEmpty()) {
            year = String.valueOf(now.getYear());
        }
        if (month == null || month.isEmpty()) {
            month = String.valueOf(now.getMonthValue());
        }

        BigDecimal monthlyRevenue = reportDAO.getTotalRevenue(year, month);
        BigDecimal dailyRevenue = reportDAO.getTotalRevenueToday();
        int totalBookings = reportDAO.getTotalBookingsByMonth(year, month);
        int completedBookings = reportDAO.getCompletedBookingsByMonth(year, month);
        int cancelledBookings = reportDAO.getCancelledBookingsByMonth(year, month);
        int newCustomers = reportDAO.getNewCustomersByMonth(year, month);
        Map<Integer, BigDecimal> dailyChart = reportDAO.getDailyRevenueByMonth(year, month);
        List<Map<String, Object>> topFields = reportDAO.getTopFieldsByRevenue(year, month);
        List<Integer> availableYears = reportDAO.getAvailableYears();

        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("completedBookings", completedBookings);
        request.setAttribute("cancelledBookings", cancelledBookings);
        request.setAttribute("newCustomers", newCustomers);
        request.setAttribute("dailyChart", dailyChart);
        request.setAttribute("topFields", topFields);
        request.setAttribute("availableYears", availableYears);

        request.getRequestDispatcher("/views/admin/reports/revenue.jsp").forward(request, response);
    }

    private void exportExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String year = request.getParameter("year");
        String month = request.getParameter("month");

        LocalDate now = LocalDate.now();
        if (year == null || year.isEmpty()) year = String.valueOf(now.getYear());
        if (month == null || month.isEmpty()) month = String.valueOf(now.getMonthValue());

        BigDecimal monthlyRevenue = reportDAO.getTotalRevenue(year, month);
        int totalBookings = reportDAO.getTotalBookingsByMonth(year, month);
        int completedBookings = reportDAO.getCompletedBookingsByMonth(year, month);
        int cancelledBookings = reportDAO.getCancelledBookingsByMonth(year, month);
        int newCustomers = reportDAO.getNewCustomersByMonth(year, month);
        Map<Integer, BigDecimal> dailyChart = reportDAO.getDailyRevenueByMonth(year, month);
        List<Map<String, Object>> topFields = reportDAO.getTopFieldsByRevenue(year, month);

        // Build Excel
        Workbook workbook = new XSSFWorkbook();

        // ===== Styles =====
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 14);
        headerStyle.setFont(headerFont);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle subHeaderStyle = workbook.createCellStyle();
        Font subHeaderFont = workbook.createFont();
        subHeaderFont.setBold(true);
        subHeaderFont.setFontHeightInPoints((short) 11);
        subHeaderStyle.setFont(subHeaderFont);
        subHeaderStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
        subHeaderStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        subHeaderStyle.setBorderBottom(BorderStyle.THIN);
        subHeaderStyle.setBorderTop(BorderStyle.THIN);
        subHeaderStyle.setBorderLeft(BorderStyle.THIN);
        subHeaderStyle.setBorderRight(BorderStyle.THIN);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        CellStyle moneyStyle = workbook.createCellStyle();
        moneyStyle.cloneStyleFrom(dataStyle);
        DataFormat format = workbook.createDataFormat();
        moneyStyle.setDataFormat(format.getFormat("#,##0"));
        moneyStyle.setAlignment(HorizontalAlignment.RIGHT);

        CellStyle boldStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        boldStyle.setFont(boldFont);

        CellStyle totalStyle = workbook.createCellStyle();
        totalStyle.cloneStyleFrom(moneyStyle);
        Font totalFont = workbook.createFont();
        totalFont.setBold(true);
        totalStyle.setFont(totalFont);
        totalStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        totalStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        CellStyle totalLabelStyle = workbook.createCellStyle();
        totalLabelStyle.cloneStyleFrom(dataStyle);
        totalLabelStyle.setFont(totalFont);
        totalLabelStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        totalLabelStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        // ===== Sheet 1: Tổng quan =====
        Sheet overviewSheet = workbook.createSheet("Tổng quan");
        overviewSheet.setColumnWidth(0, 8000);
        overviewSheet.setColumnWidth(1, 8000);

        int rowNum = 0;

        // Title
        Row titleRow = overviewSheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO DOANH THU - THÁNG " + month + "/" + year);
        titleCell.setCellStyle(headerStyle);
        overviewSheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));

        rowNum++; // blank row

        // Summary data
        String[][] summaryData = {
            {"Doanh thu tháng", null},
            {"Tổng đơn", String.valueOf(totalBookings)},
            {"Đơn hoàn thành", String.valueOf(completedBookings)},
            {"Đơn đã hủy", String.valueOf(cancelledBookings)},
            {"Khách mới", String.valueOf(newCustomers)}
        };

        for (String[] item : summaryData) {
            Row row = overviewSheet.createRow(rowNum++);
            Cell labelCell = row.createCell(0);
            labelCell.setCellValue(item[0]);
            labelCell.setCellStyle(boldStyle);

            Cell valueCell = row.createCell(1);
            if (item[1] == null) {
                // Revenue - use number format
                valueCell.setCellValue(monthlyRevenue.doubleValue());
                valueCell.setCellStyle(moneyStyle);
            } else {
                valueCell.setCellValue(item[1]);
                valueCell.setCellStyle(dataStyle);
            }
        }

        // ===== Sheet 2: Doanh thu theo ngày =====
        Sheet dailySheet = workbook.createSheet("Doanh thu theo ngày");
        dailySheet.setColumnWidth(0, 4000);
        dailySheet.setColumnWidth(1, 8000);

        rowNum = 0;

        // Title
        Row dailyTitle = dailySheet.createRow(rowNum++);
        Cell dailyTitleCell = dailyTitle.createCell(0);
        dailyTitleCell.setCellValue("DOANH THU THEO NGÀY - THÁNG " + month + "/" + year);
        dailyTitleCell.setCellStyle(headerStyle);
        dailySheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));

        rowNum++; // blank

        // Table header
        Row hdrRow = dailySheet.createRow(rowNum++);
        Cell hdr1 = hdrRow.createCell(0);
        hdr1.setCellValue("Ngày");
        hdr1.setCellStyle(subHeaderStyle);
        Cell hdr2 = hdrRow.createCell(1);
        hdr2.setCellValue("Doanh thu (VNĐ)");
        hdr2.setCellStyle(subHeaderStyle);

        // Data rows
        BigDecimal total = BigDecimal.ZERO;
        for (Map.Entry<Integer, BigDecimal> entry : dailyChart.entrySet()) {
            Row row = dailySheet.createRow(rowNum++);
            Cell dayCell = row.createCell(0);
            dayCell.setCellValue("Ngày " + entry.getKey());
            dayCell.setCellStyle(dataStyle);

            Cell revCell = row.createCell(1);
            revCell.setCellValue(entry.getValue().doubleValue());
            revCell.setCellStyle(moneyStyle);

            total = total.add(entry.getValue());
        }

        // Total row
        Row totalRow = dailySheet.createRow(rowNum++);
        Cell totalLabel = totalRow.createCell(0);
        totalLabel.setCellValue("TỔNG CỘNG");
        totalLabel.setCellStyle(totalLabelStyle);
        Cell totalValue = totalRow.createCell(1);
        totalValue.setCellValue(total.doubleValue());
        totalValue.setCellStyle(totalStyle);

        // ===== Sheet 3: Top sân =====
        if (topFields != null && !topFields.isEmpty()) {
            Sheet topSheet = workbook.createSheet("Top sân");
            topSheet.setColumnWidth(0, 3000);
            topSheet.setColumnWidth(1, 8000);
            topSheet.setColumnWidth(2, 4000);
            topSheet.setColumnWidth(3, 8000);

            rowNum = 0;

            Row topTitle = topSheet.createRow(rowNum++);
            Cell topTitleCell = topTitle.createCell(0);
            topTitleCell.setCellValue("SÂN CÓ DOANH THU CAO NHẤT - THÁNG " + month + "/" + year);
            topTitleCell.setCellStyle(headerStyle);
            topSheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));

            rowNum++;

            Row topHdr = topSheet.createRow(rowNum++);
            String[] topHeaders = {"#", "Tên sân", "Số lượt", "Doanh thu (VNĐ)"};
            for (int i = 0; i < topHeaders.length; i++) {
                Cell c = topHdr.createCell(i);
                c.setCellValue(topHeaders[i]);
                c.setCellStyle(subHeaderStyle);
            }

            int rank = 1;
            for (Map<String, Object> field : topFields) {
                Row row = topSheet.createRow(rowNum++);

                Cell rankCell = row.createCell(0);
                rankCell.setCellValue(rank++);
                rankCell.setCellStyle(dataStyle);

                Cell nameCell = row.createCell(1);
                nameCell.setCellValue((String) field.get("fieldName"));
                nameCell.setCellStyle(dataStyle);

                Cell countCell = row.createCell(2);
                countCell.setCellValue((Integer) field.get("totalBookings"));
                countCell.setCellStyle(dataStyle);

                Cell revCell = row.createCell(3);
                revCell.setCellValue(((BigDecimal) field.get("totalRevenue")).doubleValue());
                revCell.setCellStyle(moneyStyle);
            }
        }

        // ===== Write to response =====
        String fileName = "BaoCaoDoanhThu_Thang" + month + "_" + year + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        } finally {
            workbook.close();
        }
    }
}
