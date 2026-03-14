package com.sportfield.filter;

import com.sportfield.model.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/admin/*"})
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String contextPath = httpRequest.getContextPath();
        String requestURI = httpRequest.getRequestURI();

        // Allow access to admin login page
        if ((contextPath + "/admin").equals(requestURI)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User account = null;

        if (session != null) {
            account = (User) session.getAttribute("account");
        }

        boolean isLoggedIn = account != null;
        boolean isAllowedRole = false;

        if (isLoggedIn) {
            String role = account.getRole();
            if ("ADMIN".equals(role) || "STAFF".equals(role)) {
                isAllowedRole = true;
            }
        }

        if (!isLoggedIn || !isAllowedRole) {
            HttpSession newSession = httpRequest.getSession(true);
            if (!isLoggedIn) {
                newSession.setAttribute("authError", "Vui lòng đăng nhập để tiếp tục.");
            } else {
                newSession.setAttribute("authError", "Bạn không có quyền truy cập khu vực quản trị.");
            }

            httpResponse.sendRedirect(contextPath + "/admin");
            return;
        }

        // --- STAFF role restrictions ---
        // STAFF cannot access Users management and Revenue reports (ADMIN only)
        if ("STAFF".equals(account.getRole())) {
            boolean isAdminOnly = requestURI.startsWith(contextPath + "/admin/users")
                               || requestURI.startsWith(contextPath + "/admin/reports");

            if (isAdminOnly) {
                session.setAttribute("error", "Bạn không có quyền truy cập chức năng này. Chỉ Admin mới được phép.");
                httpResponse.sendRedirect(contextPath + "/admin/dashboard");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
