package net.developia.service;

import java.util.List;

import org.springframework.stereotype.Service;

import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreVO;

@Service
public interface LikeService {
    boolean isLiked(LikeDTO like); // 좋아요 여부 확인
    void toggleLike(LikeDTO like); // 좋아요 추가/삭제 토글
    List<PopUpStoreVO> getLikedStores(String username); // 관심 팝업 목록 조회
}
