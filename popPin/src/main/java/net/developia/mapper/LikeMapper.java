package net.developia.mapper;

import java.util.List;

import net.developia.domain.LikeDTO;
import net.developia.domain.PopUpStoreVO;

public interface LikeMapper {
    int isLiked(LikeDTO like);                  // 좋아요 여부 확인
    void insertLike(LikeDTO like);             // 좋아요 추가
    void deleteLike(LikeDTO like);             // 좋아요 삭제
    List<PopUpStoreVO> selectLikedStores(String username); // 사용자의 관심 팝업 조회
}
