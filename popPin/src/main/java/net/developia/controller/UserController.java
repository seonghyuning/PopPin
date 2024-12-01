package net.developia.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.developia.domain.ImageVO;
import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreVO;
import net.developia.domain.UserDTO;
import net.developia.service.LikeService;
import net.developia.service.StoreService;
import net.developia.service.UserService;

@Controller
@RequestMapping("/member")
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private LikeService likeService;
	
	@Autowired
	private StoreService storeService;

	@GetMapping("/login")
	public String loginPage() {
		return "member/login";
	}

	// 로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam("email") String email, @RequestParam("password") String password, Model model) {
		try {
			boolean isAuthenticated = userService.authenticate(email, password);

			if (isAuthenticated) {
				return "store/list"; 
			} else {
				model.addAttribute("error", "Invalid email or password");
				return "member/login";
			}
		} catch (Exception e) {
			model.addAttribute("error", "Login failed: " + e.getMessage());
			return "member/login";
		}
	}

	@GetMapping("/register")
	public String registerPage() {
		return "member/register";
	}

	@PostMapping("/register")
	public String register(@RequestParam("username") String username, @RequestParam("email") String email,
			@RequestParam("password") String password, @RequestParam("nickname") String nickname, Model model) {

		try {
			UserDTO user = new UserDTO();
			user.setUsername(username);
			user.setEmail(email);
			user.setPassword(password);
			user.setNickname(nickname);

			userService.register(user);

			model.addAttribute("success", "Registration successful!");
			return "redirect:/member/login";
		} catch (Exception e) {
			model.addAttribute("error", "Registration failed: " + e.getMessage());
			return "member/register";
		}
	}

	@GetMapping("/forgot-password")
	public String forgotPassword() {
		return "member/forgot-password";
	}

	// 비밀번호 재설정 이메일 요청
	@PostMapping("/forgot-password")
	public String forgotPassword(@RequestParam("email") String email, Model model) {
		try {
			String resetToken = userService.generatePasswordResetToken(email);
			if (resetToken != null) {
				// 이메일 전송 메서드 호출
				userService.sendPasswordResetEmail(email, resetToken);
				model.addAttribute("message", "Password reset email sent!");
			} else {
				model.addAttribute("error", "Email not found.");
			}
		} catch (Exception e) {
			model.addAttribute("error", "An error occurred: " + e.getMessage());
		}
		return "member/login";
	}

	// 비밀번호 재설정 페이지 로드
	@GetMapping("/reset-password")
	public String showResetPasswordForm(@RequestParam("token") String token, Model model) {
		model.addAttribute("token", token);
		return "member/reset-password";
	}

	// 비밀번호 재설정 처리
	@PostMapping("/reset-password")
	public String resetPassword(@RequestParam("token") String token, @RequestParam("newPassword") String newPassword,
			Model model) {
		try {
			boolean success = userService.resetPassword(token, newPassword);

			if (success) {
				model.addAttribute("message", "Password reset successfully!");
				return "redirect:member/login";
			} else {
				model.addAttribute("error", "Invalid or expired token.");
				return "member/reset-password";
			}
		} catch (Exception e) {
			model.addAttribute("error", "An error occurred while resetting the password: " + e.getMessage());
			return "member/reset-password";
		}
	}

	// 로그인 성공 시 마이페이지로 이동
	@GetMapping("/mypage")
	public String myPage(Model model) throws Exception {
	    // 로그인된 사용자 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String username = authentication.getName(); // 현재 로그인한 사용자의 username

	    if (username != null && !username.equals("anonymousUser")) {
	        // 로그인된 사용자 정보 가져오기
	        UserDTO user = userService.getUserByUsername(username);
	        model.addAttribute("user", user);

	        // 좋아요한 팝업스토어 목록 가져오기
	        List<PopUpStoreVO> likedStores = likeService.getLikedStores(username);
	        model.addAttribute("likedStores", likedStores); // 모델에 추가
	        
	        List<PopUpStoreVO> stores = storeService.getList();
        	// 이미지 데이터를 따로 가져오기
            Map<Long, List<ImageVO>> imagesMap = new HashMap<>();
            for (PopUpStoreVO store : stores) {
                List<ImageVO> images = storeService.getImagesByStoreId(store.getStoreId());
                imagesMap.put(store.getStoreId(), images);
            }
            
            // 좋아요 상태 확인
            Map<Long, Boolean> likedMap = new HashMap<>();
            if (username != null && !username.equals("anonymousUser")) {
                for (PopUpStoreVO store : stores) {
                    LikeDTO like = new LikeDTO();
                    like.setUsername(username);
                    like.setStoreId(store.getStoreId());
                    likedMap.put(store.getStoreId(), likeService.isLiked(like));
                }
            }

            model.addAttribute("imagesMap", imagesMap);
            model.addAttribute("stores", stores);
            model.addAttribute("likedMap", likedMap);
            

	        return "member/mypage";
	    }

	    // 로그인되지 않은 경우
	    model.addAttribute("error", "You must be logged in to access this page.");
	    return "member/login";
	}

	
	// 내 정보 수정 페이지
	@GetMapping("/edit")
	public String editPage(Model model) {
		String username = "로그인된 사용자"; // 로그인 정보 처리 필요
		UserDTO user = userService.getUserByUsername(username);
		model.addAttribute("user", user);
		return "member/edit";
	}

	// 내 정보 수정 처리
	@PostMapping("/edit")
	public String editUserInfo(@RequestParam("nickname") String nickname, @RequestParam("email") String email,
			@RequestParam(value = "password", required = false) String password, Model model) {
		try {
			String username = SecurityContextHolder.getContext().getAuthentication().getName();

			// 비밀번호가 입력되지 않았다면 기존 비밀번호 유지
			if (password == null || password.isEmpty()) {
				UserDTO existingUser = userService.getUserByUsername(username);
				password = existingUser.getPassword(); // 기존 비밀번호
			} else {
				password = passwordEncoder.encode(password); // 새 비밀번호 암호화
			}

			userService.updateUserInfo(username, nickname, email, password);
			model.addAttribute("success", "Your information has been updated successfully!");
			return "redirect:/member/mypage";
		} catch (Exception e) {
			model.addAttribute("error", "Failed to update information: " + e.getMessage());
			return "member/edit";
		}
	}

}
