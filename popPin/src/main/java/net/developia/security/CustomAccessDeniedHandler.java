package net.developia.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException)
            throws IOException, ServletException {
        log.error("Access Denied Handler - Handling Unauthorized Access");

        // 로그인 여부 확인
        if (request.getUserPrincipal() == null) {
            // 인증되지 않은 사용자 -> 로그인 페이지로 메시지 전달
            response.sendRedirect("/store/list?error=unauthorized");
        } else {
            // 인증된 사용자 -> 권한 부족 페이지로 메시지 전달
            response.sendRedirect("/store/list?error=accessDenied");
        }
    }
}
