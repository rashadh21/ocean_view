package com.oceanview.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    // Resources that don't require login
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login", 
            "/logout", 
            "/css/", 
            "/js/", 
            "/index.jsp", 
            "/error.jsp"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI().substring(request.getContextPath().length());
        
        // Check if resource is public
        boolean isPublic = PUBLIC_URLS.stream().anyMatch(path::startsWith);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isPublic || isLoggedIn) {
            chain.doFilter(req, res);
        } else {
            // Redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
