package net.developia.service;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import net.developia.domain.UserDTO;
import net.developia.mapper.UserMapper;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JavaMailSender mailSender;

    @Override
    public void register(UserDTO userDTO) {
    	// 비밀번호 암호화
        userDTO.setPassword(passwordEncoder.encode(userDTO.getPassword()));
        // 활성화 상태 설정
        userDTO.setEnabled("1");
        // Provider 설정
        userDTO.setProvider("local");
        userDTO.setProviderId(null);
        
        // 사용자 등록
        userMapper.insertUser(userDTO);
        // 권한 부여
        userMapper.insertAuthority(userDTO.getUsername(), "ROLE_MEMBER");
    }

    @Override
    public boolean authenticate(String email, String password) {
    	UserDTO user = userMapper.findByEmail(email);

        if (user != null) {
            return passwordEncoder.matches(password, user.getPassword()); // 비밀번호 일치 확인
        }
        return false; // 사용자 정보가 없는 경우
    }

    @Override
    public String generatePasswordResetToken(String email) {
        UserDTO user = userMapper.findByEmail(email);
        if (user != null) {
            String token = UUID.randomUUID().toString();
            userMapper.updateResetToken(email, token);
            return token; // 이메일 전송 로직 추가 가능
        }
        return null;
    }

    @Override
    public boolean resetPassword(String token, String newPassword) {
        UserDTO user = userMapper.findByResetToken(token);
        if (user != null) {
            userMapper.updatePassword(user.getEmail(), passwordEncoder.encode(newPassword));
            userMapper.updateResetToken(user.getEmail(), null); // 토큰 초기화
            return true;
        }
        return false;
    }
    
    @Override
    public void sendPasswordResetEmail(String email, String resetToken) {
        String resetUrl = "http://localhost/member/reset-password?token=" + resetToken;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Password Reset Request");
            message.setText("Click the following link to reset your password: " + resetUrl);
            mailSender.send(message); // 이메일 전송
        } catch (Exception e) {
        	System.err.println("Error while sending email: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to send email: " + e.getMessage(), e);
        }
    }
    @Override
    public UserDTO getUserByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    public void updateUserInfo(String username, String nickname, String email, String password) {
        UserDTO user = new UserDTO();
        user.setUsername(username);
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPassword(password); // 암호화된 비밀번호 전달

        userMapper.updateUserInfo(user);
    }

    
}
