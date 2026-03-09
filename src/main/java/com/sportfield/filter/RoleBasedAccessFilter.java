package com.sportfield.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RoleBasedAccessFilter implements Filter {

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

        HttpSession session = httpRequest.getSession(false);
        String userRole = null;

        if (session != null) {
            Object roleObj = session.getAttribute("userRole");
            if (roleObj instanceof String) {
                userRole = (String) roleObj;
            }
        }

        boolean isAdminOrStaff = "ADMIN".equals(userRole) || "STAFF".equals(userRole);

        boolean isCustomerUrl = false;

        if (requestURI.equals(contextPath + "/")
                || requestURI.equals(contextPath + "/index.jsp")
                || requestURI.startsWith(contextPath + "/login")
                || requestURI.startsWith(contextPath + "/register")
                || requestURI.startsWith(contextPath + "/shop")
                || requestURI.startsWith(contextPath + "/field-detail")
                || requestURI.startsWith(contextPath + "/customer")
                || requestURI.startsWith(contextPath + "/profile")) {
            isCustomerUrl = true;
        }

        if (isAdminOrStaff && isCustomerUrl) {
            System.out.println("RoleBasedAccessFilter: admin/staff tried to access customer page " + requestURI);
            httpResponse.sendRedirect(contextPath + "/admin/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
