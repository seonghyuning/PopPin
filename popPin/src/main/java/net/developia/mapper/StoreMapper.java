package net.developia.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import net.developia.domain.ImageVO;
import net.developia.domain.PopUpStoreLocationVO;
import net.developia.domain.PopUpStoreVO;

@Mapper
public interface StoreMapper {
	
	//팝업 스토어 리스트
	List<PopUpStoreVO> getList();
	 
	//팝업 상세정보
	PopUpStoreVO getStoreId(Long storeId);

	//조회수 증가
	void incrementViews(Long storeId);

	// 팝업스토어 신청 (status = 0으로 설정)
    void applyStore(PopUpStoreVO popUpStore);

    // 관리자가 팝업스토어 신청 목록 조회 (status = 0)
    List<PopUpStoreVO> getPendingStores();
     
    // 키워드로 팝업 스토어 검색
    List<PopUpStoreVO> searchStores(@Param("keyword") String keyword);
    
    //각 스토어 이미지 
    List<ImageVO> getImagesByStoreId(Long storeId);

	void register(PopUpStoreVO store);
	
	//팝업 신청상세정보
  	PopUpStoreVO getAddStoreId(Long storeId);
	// 관리자가 팝업 신청 승인/거절 처리
    void updateStoreStatus(@Param("storeId") Long storeId, @Param("status") int status);
    
	// 위도와 경도 추가 메서드
    void addStoreLocation(PopUpStoreLocationVO locationVO);

    //스토어 아이디로 위치 가져오기
    String getStoreLocation(Long storeId);
    
    PopUpStoreLocationVO getStoreCoordinate(Long storeId);  // 특정 스토어의 위치 정보 가져오기
    
    List<PopUpStoreLocationVO> getAllStoreCoordinate();   // 모든 팝업스토어 위치 정보 가져오기
}
