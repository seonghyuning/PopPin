package net.developia.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import net.developia.domain.ImageVO;
import net.developia.domain.PopUpStoreLocationVO;
import net.developia.domain.PopUpStoreVO;
import net.developia.mapper.StoreMapper;

@Service
@AllArgsConstructor
public class StoreServiceImpl implements StoreService{
	
	@Autowired
    private StoreMapper storeMapper;
	
	@Override
    public List<PopUpStoreVO> getList() {
        return storeMapper.getList();
    }

	@Override
	public PopUpStoreVO getStoreId(Long storeId) {
		// 조회수 증가
        storeMapper.incrementViews(storeId);
		//팝업 스토어 정보 ID로 가져오기
		return storeMapper.getStoreId(storeId);
	}
	
	@Override
	public PopUpStoreVO getAddStoreId(Long storeId) {
		//팝업 스토어 정보 ID로 가져오기
		return storeMapper.getStoreId(storeId);
	}
	
	// 팝업스토어 신청
    @Override
    public void applyStore(PopUpStoreVO popUpStore) {
        storeMapper.applyStore(popUpStore);
    }

    // 관리자가 팝업스토어 신청 목록 조회
    @Override
    public List<PopUpStoreVO> getPendingStores() {
        return storeMapper.getPendingStores();
    }
    
    
    
    //스토어 검색
    @Override
    public List<PopUpStoreVO> searchStores(String keyword) {
        return storeMapper.searchStores(keyword);
    }
    //각 스토어 이미지
    @Override
    public List<ImageVO> getImagesByStoreId(Long storeId) {
        return storeMapper.getImagesByStoreId(storeId);
    }

	@Override
	public void register(PopUpStoreVO store) {
		storeMapper.register(store);	
	}
	
	//스토어 신청 승인/거절 처리
    @Override
    public void updateStoreStatus(Long storeId, int status) {
        storeMapper.updateStoreStatus(storeId, status); // 매퍼에서 상태 업데이트 처리
    }
	
	// 위도와 경도 추가 메서드
    @Override
    public void addStoreLocation(Long storeId, Double latitude, Double longitude) {
        PopUpStoreLocationVO locationVO = new PopUpStoreLocationVO();
        locationVO.setStoreId(storeId);
        locationVO.setLatitude(latitude);
        locationVO.setLongitude(longitude);
        
        storeMapper.addStoreLocation(locationVO); // 매퍼에 위도, 경도 추가
    }
	
	//스토어 아이디로 위치 가져오기
	@Override
    public String getStoreLocation(Long storeId) {
		return storeMapper.getStoreLocation(storeId);
	}
	
	@Override
    public PopUpStoreLocationVO getStoreCoordinate(Long storeId) {
        return storeMapper.getStoreCoordinate(storeId);  // Mapper에서 위치 정보 가져오기
    }

	@Override
	public List<PopUpStoreLocationVO> getAllStoreCoordinate() {
	    List<PopUpStoreLocationVO> locations = storeMapper.getAllStoreCoordinate();
	    
	    // 위치 데이터에 제목 추가
	    for (PopUpStoreLocationVO location : locations) {
	        PopUpStoreVO store = storeMapper.getStoreId(location.getStoreId());
	        location.setTitle(store.getName());  // 팝업스토어의 이름을 제목으로 설정
	    }
	    return locations;
	}

}
