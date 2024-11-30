package net.developia.service;

import org.springframework.stereotype.Service;

import net.developia.domain.UserDTO;

@Service
public interface UserService {
    void register(UserDTO userDTO); // 회원가입
    boolean authenticate(String email, String password); // 로그인
    String generatePasswordResetToken(String email); // 비밀번호 초기화 토큰 생성
    boolean resetPassword(String token, String newPassword); // 비밀번호 초기화
    void sendPasswordResetEmail(String email, String resetToken);
	UserDTO getUserByUsername(String username);
	void updateUserInfo(String username, String nickname, String email, String password);
}
