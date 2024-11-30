package net.developia.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import net.developia.domain.PopUpStoreVO;
import net.developia.mapper.PopupStoreMapper;

@Service
@AllArgsConstructor
public class PopupStoreServiceImpl implements PopupStoreService{
	private PopupStoreMapper storemapper;
	private ImageService imageService; // 추가

	// 사용자 팝업 스토어 신청
	@Transactional
    @Override
    public void registerPopupStore(PopUpStoreVO popupStore) {
        // 팝업스토어 등록
        storemapper.registerPopupStore(popupStore);
        // MyBatis를 통해 storeId가 popupStore에 설정됨
    }

	// 대기 팝업 목록 조회(status = 0)
	@Override
	public List<PopUpStoreVO> getPopupStoresByUser(String username) {
		return storemapper.getPopupStoresByUser(username);
	}
	
	// 승인 팝업 목록 조회(status = 1)
	@Override
	public List<PopUpStoreVO> getApprovePopupStoresByUser(String username) {
		return storemapper.getApprovePopupStoresByUser(username);
	}

	// 사용자 거절 팝업 목록 조회(status = 2)
	@Override
	public List<PopUpStoreVO> getRejectedPopupStoresByUser(String username) {
		return storemapper.getRejectedPopupStoresByUser(username);
	}

	// 사용자 특정 팝업스토어 상세 조회
	@Override
	public PopUpStoreVO getPopupStoreById(Long storeId) {
		return storemapper.getPopupStoreById(storeId);
	}

	// 사용자 팝업스토어 수정
	@Override
	public int updatePopupStore(PopUpStoreVO popupStore) {
		return storemapper.updatePopupStore(popupStore);
	}

	// 사용자 팝업스토어 삭제
	@Override
	public int deletePopupStore(Long storeId) {
		return storemapper.deletePopupStore(storeId);
	}
	
}
