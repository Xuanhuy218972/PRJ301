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
            String date = request.getParameter("date");
            if (date != null && !date.isEmpty()) {
                exportDailyExcel(request, response, date);
            } else {
                exportExcel(request, response);
            }
            return;
        }

        // Default: show revenue report page
        showRevenueReport(request, response);
    }

    private void exportDailyExcel(HttpServletRequest request, HttpServletResponse response, String dateStr)
            throws ServletException, IOException {
        
        com.sportfield.dao.BookingDAO bookingDAO = new com.sportfield.dao.BookingDAO();
        List<com.sportfield.model.BookingDetail> details = bookingDAO.getBookingDetailsByDate(dateStr);
        
        Workbook workbook = new XSSFWorkbook();
        
        // Styles
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 14);
        headerStyle.setFont(headerFont);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle subHeaderStyle = workbook.createCellStyle();
        Font subHeaderFont = workbook.createFont();
        subHeaderFont.setBold(true);
        subHeaderStyle.setFont(subHeaderFont);
        subHeaderStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
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
        moneyStyle.setDataFormat(workbook.createDataFormat().getFormat("#,##0"));

        Sheet sheet = workbook.createSheet("Báo cáo ngày " + dateStr);
        int rowNum = 0;

        // Title
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("DANH SÁCH CHI TIẾT ĐẶT SÂN NGÀY " + dateStr);
        titleCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));

        rowNum++; // blank

        // Headers
        String[] headers = {"Mã đơn", "Khách hàng", "Số điện thoại", "Sân được đặt", "Khung giờ", "Tổng tiền", "Trạng thái", "Ngày đá"};
        Row headRow = sheet.createRow(rowNum++);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(subHeaderStyle);
        }

        // Data
        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (com.sportfield.model.BookingDetail d : details) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue("#BK" + d.getBookingID());
            row.createCell(1).setCellValue(d.getCustomerName());
            row.createCell(2).setCellValue(d.getCustomerPhone());
            row.createCell(3).setCellValue(d.getFieldName());
            row.createCell(4).setCellValue(d.getSlotStartTime() + " - " + d.getSlotEndTime());
            
            Cell priceCell = row.createCell(5);
            priceCell.setCellValue(d.getPrice().doubleValue());
            priceCell.setCellStyle(moneyStyle);
            
            row.createCell(6).setCellValue(d.getBookingStatus());
            row.createCell(7).setCellValue(d.getBookingDate().toString());

            if ("COMPLETED".equals(d.getBookingStatus())) {
                totalRevenue = totalRevenue.add(d.getPrice());
            }
            
            // Set data style for all cells in row
            for(int i=0; i<8; i++) {
                if (row.getCell(i) == null) row.createCell(i);
                row.getCell(i).setCellStyle(dataStyle);
            }
            row.getCell(5).setCellStyle(moneyStyle);
        }

        rowNum++;
        Row totalRow = sheet.createRow(rowNum);
        Cell labelCell = totalRow.createCell(4);
        labelCell.setCellValue("TỔNG DOANH THU THỰC TẾ:");
        labelCell.setCellStyle(subHeaderStyle);
        
        Cell revCell = totalRow.createCell(5);
        revCell.setCellValue(totalRevenue.doubleValue());
        revCell.setCellStyle(moneyStyle);

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Response
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=BaoCaoChiTietNgay_" + dateStr + ".xlsx");

        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        }
        workbook.close();
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

        BigDecimal totalRevenue = reportDAO.getTotalRevenue(year, month);
        int totalBookings = reportDAO.getTotalBookingsByMonth(year, month);
        int completedBookings = reportDAO.getCompletedBookingsByMonth(year, month);
        int cancelledBookings = reportDAO.getCancelledBookingsByMonth(year, month);
        int pendingBookings = reportDAO.getPendingBookingsByMonth(year, month);
        int totalCustomers = reportDAO.getTotalCustomersInMonth(year, month);
        int newCustomers = reportDAO.getNewCustomersByMonth(year, month);
        int returningCustomers = reportDAO.getReturningCustomersByMonth(year, month);

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

        Sheet overviewSheet = workbook.createSheet("Báo cáo tháng " + month + "-" + year);
        int rowNum = 0;

        // Title
        Row titleRow = overviewSheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO CHỈ SỐ KINH DOANH - THÁNG " + month + "/" + year);
        titleCell.setCellStyle(headerStyle);
        overviewSheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 2));

        rowNum++; // blank row

        // Headers
        Row headRow = overviewSheet.createRow(rowNum++);
        String[] headers = {"Chỉ số", "Kết quả", "Ghi chú"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(subHeaderStyle);
        }

        // Data Rows
        // 1. Doanh thu tháng
        addReportRow(overviewSheet, rowNum++, "Doanh thu tháng", totalRevenue, "", moneyStyle, dataStyle);
        
        // 2. Giá trị trung bình/đơn
        BigDecimal avgValue = completedBookings > 0 ? totalRevenue.divide(new BigDecimal(completedBookings), 0, java.math.RoundingMode.HALF_UP) : BigDecimal.ZERO;
        addReportRow(overviewSheet, rowNum++, "Giá trị trung bình/đơn", avgValue, "(Dựa trên " + completedBookings + " đơn hoàn thành)", moneyStyle, dataStyle);
        
        // 3. Tổng tiền giảm giá
        addReportRow(overviewSheet, rowNum++, "Tổng tiền giảm giá", BigDecimal.ZERO, "Chưa áp dụng khuyến mãi", moneyStyle, dataStyle);
        
        // 4. Tổng số đơn
        addReportRow(overviewSheet, rowNum++, "Tổng số đơn", totalBookings, "", dataStyle, dataStyle);
        
        // 5. Đơn hoàn thành
        double completedRate = totalBookings > 0 ? (double) completedBookings / totalBookings * 100 : 0;
        addReportRow(overviewSheet, rowNum++, "Đơn hoàn thành", completedBookings, String.format("Tỉ lệ: %.1f%%", completedRate), dataStyle, dataStyle);
        
        // 6. Đơn đang xử lý
        double pendingRate = totalBookings > 0 ? (double) pendingBookings / totalBookings * 100 : 0;
        addReportRow(overviewSheet, rowNum++, "Đơn đang xử lý", pendingBookings, String.format("Tỉ lệ: %.1f%%", pendingRate), dataStyle, dataStyle);
        
        // 7. Đơn đã hủy
        double cancelledRate = totalBookings > 0 ? (double) cancelledBookings / totalBookings * 100 : 0;
        addReportRow(overviewSheet, rowNum++, "Đơn đã hủy", cancelledBookings, String.format("Tỉ lệ: %.1f%%", cancelledRate), dataStyle, dataStyle);
        
        // 8. Tổng số khách hàng
        addReportRow(overviewSheet, rowNum++, "Tổng số khách hàng", totalCustomers, "", dataStyle, dataStyle);
        
        // 9. Khách mới
        addReportRow(overviewSheet, rowNum++, "Khách mới", newCustomers, "", dataStyle, dataStyle);
        
        // 10. Khách cũ quay lại
        addReportRow(overviewSheet, rowNum++, "Khách cũ quay lại", returningCustomers, "", dataStyle, dataStyle);

        // Auto-size columns
        for (int i = 0; i < 3; i++) overviewSheet.autoSizeColumn(i);

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

    private void addReportRow(Sheet sheet, int rowIdx, String metric, Object value, String note, CellStyle valueStyle, CellStyle baseStyle) {
        Row row = sheet.createRow(rowIdx);
        Cell c1 = row.createCell(0);
        c1.setCellValue(metric);
        c1.setCellStyle(baseStyle);

        Cell c2 = row.createCell(1);
        if (value instanceof BigDecimal) {
            c2.setCellValue(((BigDecimal) value).doubleValue());
        } else if (value instanceof Integer) {
            c2.setCellValue((Integer) value);
        } else {
            c2.setCellValue(value.toString());
        }
        c2.setCellStyle(valueStyle);

        Cell c3 = row.createCell(2);
        c3.setCellValue(note);
        c3.setCellStyle(baseStyle);
    
    }
}
