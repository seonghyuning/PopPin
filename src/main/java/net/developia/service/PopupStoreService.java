package net.developia.service;

import java.util.List;

import net.developia.domain.PopUpStoreVO; 

public interface PopupStoreService {
	
	// 팝업 스토어 신청
	public void registerPopupStore(PopUpStoreVO popupStore);
	
	// 대기 팝업 목록 조회(status = 0)
	public List<PopUpStoreVO> getPopupStoresByUser(String username);
	
	// 승인 팝업 목록 조회(status = 1)
	public List<PopUpStoreVO> getApprovePopupStoresByUser(String username);
	
	// 거절 팝업 목록 조회(status=2)
	public List<PopUpStoreVO> getRejectedPopupStoresByUser(String username);
	
	// 사용자 특정 팝업스토어 상세 조회
    public PopUpStoreVO getPopupStoreById(Long storeId);
	
	// 팝업스토어 수정
    public int updatePopupStore(PopUpStoreVO popupStore);
	
	// 팝업스토어 삭제
    public int deletePopupStore(Long storeId);
}
