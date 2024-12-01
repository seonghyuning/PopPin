package net.developia.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import net.developia.domain.UserDTO;

@Mapper
public interface UserMapper {
    void insertUser(UserDTO userDTO);
    void insertAuthority(@Param("username") String username, @Param("authority") String authority); // 권한 삽입
    
    
    void updateResetToken(@Param("email") String email, @Param("token") String token);
    void updatePassword(@Param("email") String email, @Param("newPassword") String newPassword);
    UserDTO findByResetToken(@Param("token") String token);
    UserDTO findByEmail(@Param("email") String email);
	UserDTO findByUsername(String username);
	void updateUserInfo(String username, String nickname, String email, String encodedPassword);
	void updateUserInfo(UserDTO user);
}
