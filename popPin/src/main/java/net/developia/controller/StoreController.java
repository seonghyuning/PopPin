package net.developia.controller;

import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.domain.ImageVO;
import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreLocationVO;
import net.developia.domain.PopUpStoreVO;
import net.developia.service.GeocodingService;
import net.developia.service.LikeService;
import net.developia.service.StoreService;

@Controller
@Log4j
@RequestMapping("/store/*")
@AllArgsConstructor
public class StoreController {

    @Autowired
    private StoreService storeService;

    @Autowired
    private GeocodingService geocodingService;

    @Autowired
    private LikeService likeService;

    // 관리자가 팝업스토어 신청 목록 조회
    @GetMapping("/addstorelist")
    public String getPendingStores(Model model) {
        List<PopUpStoreVO> pendingStores = storeService.getPendingStores();
        model.addAttribute("pendingStores", pendingStores);
        return "/store/addStoreList"; // 신청 목록을 보여줄 JSP
    }

    // Store 신청 상세 페이지로 이동
    @GetMapping("/approveReject")
    public String getAddStoreDetail(@RequestParam("storeId") Long storeId, Model model) {
        PopUpStoreVO store = storeService.getAddStoreId(storeId);
        model.addAttribute("store", store);
        return "store/approveReject"; // storeDetail.jsp로 이동
    }

    // 팝업스토어 승인/거절 처리
    @PostMapping("/approveReject")
    public String approveReject(@RequestParam("storeId") Long storeId, @RequestParam("status") int status) {
        storeService.updateStoreStatus(storeId, status); // storeService에서 상태 업데이트 처리

        if (status == 1) { // 승인 상태일 때
            // storeId로 location을 가져옵니다.
            String location = storeService.getStoreLocation(storeId);
            log.info("location: " + location);
            if (location != null) {
                // 주소를 위도, 경도로 변환하는 메소드
                double[] latLng = geocodingService.getLatLngFromAddress(location);

                if (latLng != null) {
                    double latitude = latLng[0];
                    double longitude = latLng[1];

                    // 위도, 경도 정보를 DB에 저장
                    storeService.addStoreLocation(storeId, latitude, longitude);

                    log.info("latitude: " + latLng + " longitude: " + longitude);
                }
            }
        }

        return "redirect:/store/list"; // 처리 후 팝업스토어 목록으로 리다이렉트
    }

    // 팝업스토어 목록 조회
    @GetMapping("/list")
    public String list(Model model) {
        try {
            List<PopUpStoreVO> stores = storeService.getList();
            // 이미지 데이터를 따로 가져오기
            Map<Long, List<ImageVO>> imagesMap = new HashMap<>();
            for (PopUpStoreVO store : stores) {
                List<ImageVO> images = storeService.getImagesByStoreId(store.getStoreId());
                imagesMap.put(store.getStoreId(), images);
            }

            // 좋아요 상태 확인
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String username = authentication.getName();
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

            return "store/list";
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 좋아요 토글
    @PostMapping("/like/toggle")
    public ResponseEntity<Map<String, String>> toggleLike(@RequestParam Long storeId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        if (username == null || username.equals("anonymousUser")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "로그인 후 이용 가능합니다."));
        }

        try {
            LikeDTO like = new LikeDTO();
            like.setUsername(username);
            like.setStoreId(storeId);

            likeService.toggleLike(like);

            boolean isLiked = likeService.isLiked(like);
            // Boolean 값을 String으로 변환하여 반환
            return ResponseEntity.ok(Map.of("liked", String.valueOf(isLiked)));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "서버 오류 발생"));
        }
    }

    // Store 상세 페이지로 이동
    @GetMapping("/storeDetail")
    public String getStoreDetail(@RequestParam("storeId") Long storeId, Model model) {
        PopUpStoreVO store = storeService.getStoreId(storeId);
        model.addAttribute("store", store);
        return "store/storeDetail"; // storeDetail.jsp로 이동
    }

    // Store 검색 페이지
    @GetMapping("/search")

    public String searchStores(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        // 서비스 계층에서 검색 실행
        List<PopUpStoreVO> stores = storeService.searchStores(keyword);
        // 이미지 데이터를 따로 가져오기
        Map<Long, List<ImageVO>> imagesMap = new HashMap<>();
        for (PopUpStoreVO store : stores) {
            List<ImageVO> images = storeService.getImagesByStoreId(store.getStoreId());
            imagesMap.put(store.getStoreId(), images);
        }

        log.info("Image list: " + imagesMap);
        log.info("Store list: " + stores); // 로그를 추가하여 데이터를 확인
        model.addAttribute("imagesMap", imagesMap);
        model.addAttribute("stores", stores); // JSP로 전달
        return "store/searchResults"; // 검색 결과를 보여줄 JSP 경로
    }

    // 맵으로 스토어 검색
    @GetMapping("/mapSearch")
    public String mapSearch(Model model) throws Exception {
        // 모든 팝업스토어 좌표 정보 가져오기
        List<PopUpStoreLocationVO> locations = storeService.getAllStoreCoordinate();

        // 모든 팝업스토어 정보 가져오기
        List<PopUpStoreVO> stores = storeService.getList();

        // 이미지 매핑 (storeId 기준으로 이미지 리스트 가져오기)
        Map<Long, List<String>> imagesMap = new HashMap<>();
        List<ImageVO> images = storeService.getAllImages(); // 모든 이미지 데이터를 가져옵니다
        for (ImageVO image : images) {
            imagesMap.computeIfAbsent(image.getStoreId(), k -> new ArrayList<>()).add(image.getFilePath());
        }

        // `locations`에 상세 데이터 추가
        List<Map<String, Object>> enrichedLocations = new ArrayList<>();
        for (PopUpStoreLocationVO location : locations) {
            Long storeId = location.getStoreId();
            PopUpStoreVO store = stores.stream()
                    .filter(s -> s.getStoreId().equals(storeId))
                    .findFirst()
                    .orElse(null);

            if (store != null) {
                Map<String, Object> enrichedLocation = new HashMap<>();
                enrichedLocation.put("storeId", store.getStoreId());
                enrichedLocation.put("title", store.getName());
                enrichedLocation.put("latitude", location.getLatitude());
                enrichedLocation.put("longitude", location.getLongitude());
                enrichedLocation.put("startDate", store.getStartDate());
                enrichedLocation.put("endDate", store.getEndDate());
                enrichedLocation.put("location", store.getLocation());
                enrichedLocation.put("images", imagesMap.get(store.getStoreId())); // 이미지 URL 리스트 추가

                enrichedLocations.add(enrichedLocation);
            }
        }

        // JSON 직렬화
        ObjectMapper objectMapper = new ObjectMapper();
        String locationsJson = objectMapper.writeValueAsString(enrichedLocations);

        // 모델에 추가
        model.addAttribute("locationsJson", locationsJson);

        return "store/mapSearch";
    }

}