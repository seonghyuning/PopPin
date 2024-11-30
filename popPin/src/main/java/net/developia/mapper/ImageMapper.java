package net.developia.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import net.developia.domain.ImageVO;

@Mapper
public interface ImageMapper {
    // 이미지 삽입 쿼리
    void saveImage(ImageVO imageVO);
    
    // 이미지 id로 이미지 삭제
    void deleteImage(Long imageId);
    
    // 특정 팝업스토어의 모든 이미지 삭제
    void deleteImagesByStoreId(Long storeId);
    
    // 스토어 ID로 이미지 조회
    List<ImageVO> getImagesByStoreId(Long storeId);
}



