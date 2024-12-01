package net.developia.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.domain.ImageVO;
import net.developia.domain.PopUpStoreVO;
import net.developia.domain.UserDTO;
import net.developia.service.ImageService;
import net.developia.service.PopupStoreService;
import net.developia.service.UserService;

@Controller
@Log4j
@RequestMapping("mypage/*")
@AllArgsConstructor
public class PopupStoreController {

    @Autowired
    private PopupStoreService storeservice;
    private ImageService imageservice;
    private UserService userservice;

    // 등록 팝업 관리 페이지 (대기/승인/거절 목록 출력)
    @GetMapping("/popupstore/manage")
    public String managePopups(Model model) {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String username = authentication.getName(); // 현재 로그인한 사용자의 username
    	    
        List<PopUpStoreVO> popupStores = storeservice.getPopupStoresByUser(username);
        popupStores.forEach(store -> {
            List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
            if (!images.isEmpty()) {
                store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
            }
        });
        
        List<PopUpStoreVO> apporovedStores = storeservice.getApprovePopupStoresByUser(username);
        popupStores.forEach(store -> {
            List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
            if (!images.isEmpty()) {
                store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
            }
        });
        
        List<PopUpStoreVO> rejectedStores = storeservice.getRejectedPopupStoresByUser(username);
        popupStores.forEach(store -> {
            List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
            if (!images.isEmpty()) {
                store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
            }
        });

        
	    if (username != null && !username.equals("anonymousUser")) {
	        UserDTO user = userservice.getUserByUsername(username); // DB에서 사용자 정보 가져오기
	        model.addAttribute("user", user);
	        model.addAttribute("popupStores", popupStores);
	        model.addAttribute("apporovedStores", apporovedStores);
	        model.addAttribute("rejectedStores", rejectedStores);
	        
	        List<ImageVO> images = new ArrayList<>();
	        for (PopUpStoreVO store : popupStores) {
	            images.addAll(imageservice.getImagesByStoreId(store.getStoreId()));
	        }
	        model.addAttribute("images", images);
	        
	        return "mypage/popupstore/manage"; // 등록 팝업 관리 JSP 파일 경로
	    }
	    
	    // 로그인되지 않은 경우
	    model.addAttribute("error", "You must be logged in to access this page.");
	    return "member/login";
    }
    // 팝업스토어 등록 페이지
    @GetMapping("/popupstore/new")
    public String newPopupStoreForm() {
        return "mypage/popupstore/new";
    }

    @PostMapping("/popupstore/new")
    public String createPopupStore(
    		@ModelAttribute PopUpStoreVO popupStore,
    		@RequestParam("images") MultipartFile[] files,
    		RedirectAttributes rttr) {
    	try {
    		// 1. 로그인한 사용자 가져오기
    		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    		String username = authentication.getName();
    		popupStore.setCreatedBy(username);
    		popupStore.setStatus(0); // 기본 상태
    		
    		// 2. 팝업스토어 저장 후 storeId 생성
    		storeservice.registerPopupStore(popupStore); // 여기서 storeId가 생성됨
    		Long storeId = popupStore.getStoreId(); // MyBatis가 생성된 storeId를 채워줌
    		
    		// 3. 파일 저장 및 DB에 이미지 정보 저장
    		for (MultipartFile file : files) {
    			if (!file.isEmpty()) {
    				// (1) 파일 저장 경로 설정
    				String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
    				
    				Path uploadPath = Paths.get("C:/uploads", fileName);
    				
    				// (2) 디렉토리 생성
    				if (!Files.exists(uploadPath.getParent())) {
    					Files.createDirectories(uploadPath.getParent());
    				}
    				
    				// (3) 파일 저장
    				Files.copy(file.getInputStream(), uploadPath);
    				
    				// (4) 이미지 정보 DB 저장
    				ImageVO imageVO = new ImageVO();
    				imageVO.setStoreId(storeId); // 생성된 storeId 사용
    				imageVO.setFilePath(uploadPath.toString().replace("\\", "/")); // 경로 통일
    				imageservice.saveImage(imageVO); // DB 저장만 처리
    			}
    		}
    		
    		// 4. 성공 메시지
    		rttr.addFlashAttribute("success", "팝업스토어와 이미지가 성공적으로 등록되었습니다!");
    		return "redirect:/mypage/popupstore/manage";
    	} catch (Exception e) {
    		// 5. 실패 시 처리
    		log.error("팝업스토어 등록 중 오류 발생", e);
    		rttr.addFlashAttribute("error", "등록에 실패했습니다.");
    		return "mypage/popupstore/new";
    	}
    	
    }

    
    
    // 사용자 팝업스토어 상세 조회 (모든 상태)
    @GetMapping("/popupstore/detail")
    public String viewPopupStore(@RequestParam("storeId") Long storeId, Model model) {
    	PopUpStoreVO popupStore = storeservice.getPopupStoreById(storeId);
        model.addAttribute("popupStore", popupStore);
        return "mypage/popupstore/detail";
    }

    // 사용자 팝업스토어 수정 페이지
    @GetMapping("/popupstore/edit")
    public String editPopupStore(@RequestParam("storeId") Long storeId, Model model) {
        PopUpStoreVO popupStore = storeservice.getPopupStoreById(storeId);
        List<ImageVO> images = imageservice.getImagesByStoreId(storeId); // 이미지 정보 가져오기
        model.addAttribute("popupStore", popupStore);
        model.addAttribute("images", images); // 이미지 리스트 전달
        return "mypage/popupstore/edit";
    }

    
    // 사용자 팝업스토어 수정
    @PostMapping("/popupstore/edit")
    public String updatePopupStore(
            @RequestParam("storeId") Long storeId,
            @RequestParam(value = "newImages", required = false) MultipartFile[] newImages, // 새 이미지
            @ModelAttribute PopUpStoreVO popupStore,
            RedirectAttributes rttr) {
        try {
            // 팝업 스토어 정보 업데이트
            popupStore.setStoreId(storeId);
            storeservice.updatePopupStore(popupStore);

            // 새로운 이미지 처리
            if (newImages != null && newImages.length > 0) {
                // 기존 이미지 삭제
                imageservice.deleteImagesByStoreId(storeId);

                // 새 이미지 저장
                for (MultipartFile file : newImages) { // newImages를 사용
                    if (!file.isEmpty()) {
                        try (InputStream inputStream = file.getInputStream()) {
                            // 파일 저장 로직
                            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
                            Path uploadPath = Paths.get("C:/uploads", fileName);

                            if (!Files.exists(uploadPath.getParent())) {
                                Files.createDirectories(uploadPath.getParent());
                            }

                            Files.copy(inputStream, uploadPath);

                            // DB 저장
                            ImageVO imageVO = new ImageVO();
                            imageVO.setStoreId(storeId);
                            imageVO.setFilePath(uploadPath.toString().replace("\\", "/")); // 경로 통일 //uploadpath -> dbpath로 수정, 이미지 url 매핑위함
                            imageservice.saveImage(imageVO);
                        } catch (IOException e) {
                            log.error("파일 업로드 중 오류 발생: " + e.getMessage());
                        }
                    }
                }
            }

            rttr.addFlashAttribute("success", "수정이 완료되었습니다.");
        } catch (Exception e) {
            log.error("수정 중 오류 발생", e);
            rttr.addFlashAttribute("error", "수정에 실패했습니다.");
        }
        return "redirect:/mypage/popupstore/manage";
    }


    // 사용자 팝업스토어 삭제
    @PostMapping("/popupstore/delete")
    public String deletePopupStore(@RequestParam("storeId") Long storeId, RedirectAttributes rttr) {
        try {
            log.info("삭제 요청 받은 storeId: " + storeId);
            storeservice.deletePopupStore(storeId);
            rttr.addFlashAttribute("success", "성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            log.error("삭제 중 오류 발생", e);
            rttr.addFlashAttribute("error", "삭제에 실패했습니다.");
        }
        return "redirect:/mypage/popupstore/manage";
    }
    
	
    
    @PostMapping("/popupstore/deleteImage")
    @ResponseBody
    public ResponseEntity<String> deleteImage(@RequestParam("imageId") Long imageId) {
        try {
            // 이미지 삭제 처리
            imageservice.deleteImage(imageId);
            return ResponseEntity.ok("이미지 삭제 성공");
        } catch (Exception e) {
            log.error("이미지 삭제 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 삭제 실패");
        }
    }
    
    
    @RestController
    @RequestMapping("/image")
    public class ImageController {
        
        @GetMapping("/{imageId}")
        public ResponseEntity<byte[]> getImage(@PathVariable Long imageId) {
            try {
                // DB에서 이미지 경로 가져오기
                ImageVO image = imageservice.getImageById(imageId); // 새로운 메서드 추가 필요
                Path imagePath = Paths.get(image.getFilePath());

                // 파일을 byte[]로 읽기
                byte[] imageBytes = Files.readAllBytes(imagePath);

                // MIME 타입 설정
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.IMAGE_JPEG); // PNG, GIF 등도 가능

                return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
            } catch (Exception e) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
        }
    }


}