// 추가
package net.developia.service;

import java.util.List;

import net.developia.domain.ImageVO;

public interface ImageService {
	void saveImage(ImageVO imageVO) throws Exception; // 이미지 정보 저장
    void deleteImage(Long imageId) throws Exception; // 이미지 id로 이미지 삭제
    void deleteImagesByStoreId(Long storeId) throws Exception; // 특정 팝업스토어의 모든 이미지 삭제
    List<ImageVO> getImagesByStoreId(Long storeId);  // 스토어 ID로 이미지 목록 조회
}
