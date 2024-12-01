package net.developia.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.domain.PopUpStoreVO;
import net.developia.domain.UserDTO;
import net.developia.service.PopupStoreService;

@Controller
@Log4j
@RequestMapping("mypage/*")
@AllArgsConstructor
public class PopupStoreController {

    @Autowired
    private PopupStoreService storeservice;

    // 로그인, 시큐리티 구현 후 수정
    // 마이페이지 (사용자 정보 출력 + 등록 팝업 관리 이동 버튼)
    @GetMapping("/popupstore/mypage")
    public String myPage(Model model) {
        // 더미 사용자 정보
        UserDTO user = new UserDTO();
        user.setUsername("user1");
        user.setNickname("사용자 닉네임");

        model.addAttribute("user", user); // 사용자 정보 전달
        return "mypage/popupstore/mypage"; // 마이페이지 JSP 파일 경로
    }

    // 등록 팝업 관리 페이지 (대기/승인/거절 목록 출력)
    @GetMapping("/popupstore/manage")
    public String managePopups(Model model) {
    	//public String managePopups(@RequestParam("username") String username, Model model) {
        List<PopUpStoreVO> popupStores = storeservice.getPopupStoresByUser("user1"); // 나중에 username 으로 변경
        List<PopUpStoreVO> apporovedStores = storeservice.getApprovePopupStoresByUser("user1");
        List<PopUpStoreVO> rejectedStores = storeservice.getRejectedPopupStoresByUser("user1");

        model.addAttribute("popupStores", popupStores);
        model.addAttribute("apporovedStores", apporovedStores);
        model.addAttribute("rejectedStores", rejectedStores);
        return "mypage/popupstore/manage"; // 등록 팝업 관리 JSP 파일 경로
    }

    // 팝업스토어 등록 페이지
    @GetMapping("/popupstore/new")
    public String newPopupStoreForm() {
        return "mypage/popupstore/new";
    }

    @PostMapping("/popupstore/new")
    public String createPopupStore(PopUpStoreVO popupStore, RedirectAttributes rttr) {
        try {        	
            log.info("등록 요청: " + popupStore.toString()); // 전달된 데이터 로그 출력
            popupStore.setStatus(0); // 기본값 설정
            popupStore.setCreatedBy("user1"); // 더미 데이터 설정 (나중에 로그인 정보로 대체)
            storeservice.registerPopupStore(popupStore);
            rttr.addFlashAttribute("success", "성공적으로 등록되었습니다.");
            return "redirect:/mypage/popupstore/manage";
        } catch (Exception e) {
            log.error("등록 중 오류 발생", e);
            rttr.addFlashAttribute("error", "등록에 실패했습니다.");
            return null;
        }
    }
    
//    // 팝업스토어 등록 처리
//    @PostMapping("/popupstore/new")
//    public String createPopupStore(@ModelAttribute PopupStoreVO popupStore, RedirectAttributes rttr) {
//        try {
//            popupStoreService.registerPopupStore(popupStore);
//            rttr.addFlashAttribute("success", "성공적으로 등록되었습니다.");
//        } catch (Exception e) {
//            log.error("등록 중 오류 발생", e);
//            rttr.addFlashAttribute("error", "등록에 실패했습니다.");
//        }
//        return "redirect:/mypage/popupstore/manage";
//    }

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
        model.addAttribute("popupStore", popupStore);
        return "mypage/popupstore/edit";
    }
    
    // 사용자 팝업스토어 수정
    @PostMapping("/popupstore/edit")
    public String updatePopupStore(@RequestParam("storeId") Long storeId, @ModelAttribute PopUpStoreVO popupStore, RedirectAttributes rttr) {
        popupStore.setStoreId(storeId);
        try {
        	storeservice.updatePopupStore(popupStore);
            rttr.addFlashAttribute("success", "성공적으로 수정되었습니다.");
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

}
