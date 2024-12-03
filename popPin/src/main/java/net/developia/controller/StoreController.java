//김성현 소스코드

package net.developia.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.domain.ImageVO;
import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreLocationVO;
import net.developia.domain.PopUpStoreVO;
import net.developia.service.GeocodingService;
import net.developia.service.ImageService;
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
    
    @Autowired
    private ImageService imageservice;

    @GetMapping("addstorelist")
    public String getPendingStores(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            return "redirect:/store/list";
        }

        List<PopUpStoreVO> stores = storeService.getAddStoreList();
        model.addAttribute("stores", stores);
        return "/store/addStoreList"; // 신청 목록을 보여줄 JSP
    }

    @GetMapping("/approveReject")
    public String getAddStoreDetail(@RequestParam("storeId") Long storeId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"))) {
            // 관리자가 아닌 경우, 접근을 제한합니다.
            return "redirect:/store/list"; // 권한 없음 페이지로 리다이렉트
        }

        PopUpStoreVO store = storeService.getAddStoreId(storeId);
        model.addAttribute("store", store);
        return "store/approveReject"; // 신청 상세 페이지로 이동
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
            stores.forEach(store -> {
                List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
                if (!images.isEmpty()) {
                    store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
                }
            });

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
        stores.forEach(store -> {
            List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
            if (!images.isEmpty()) {
                store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
            }
        });

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
        // 이미지 데이터를 따로 가져오기
        stores.forEach(store -> {
            List<ImageVO> images = imageservice.getImagesByStoreId(store.getStoreId());
            if (!images.isEmpty()) {
                store.setImageId(images.get(0).getImageId()); // 첫 번째 이미지 사용
            }
        });
        

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
                enrichedLocation.put("imageId", store.getImageId());
                enrichedLocation.put("startDate", store.getStartDate());
                enrichedLocation.put("endDate", store.getEndDate());
                enrichedLocation.put("location", store.getLocation());

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
    
    @RestController
    @RequestMapping("/store")
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

                System.out.println("ImageId: " + imageId);
                System.out.println("Image Path: " + image.getFilePath());

                
                return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
            } catch (Exception e) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
        }
    }

}
