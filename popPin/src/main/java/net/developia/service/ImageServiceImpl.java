// 김정은 소스코드
package net.developia.service;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.domain.ImageVO;
import net.developia.mapper.ImageMapper;

@Log4j
@Service
@RequiredArgsConstructor
public class ImageServiceImpl implements ImageService {
    private final ImageMapper imageMapper;
    
    @Override
    public void saveImage(ImageVO imageVO) throws Exception {
        try {
            // DB에 이미지 정보 저장
            imageMapper.saveImage(imageVO);
            log.info("이미지 정보 DB 저장 성공: " + imageVO);
        } catch (Exception e) {
            log.error("이미지 DB 저장 중 오류 발생", e);
            throw e;
        }
    }
    
    @Override
    public void deleteImage(Long imageId) throws Exception {
        try {
            imageMapper.deleteImage(imageId);
            log.info("이미지 삭제 성공: 이미지 ID = " + imageId);
        } catch (Exception e) {
            log.error("이미지 삭제 중 오류 발생", e);
            throw e;
        }
    }
    
    // 특정 팝업스토어의 모든 이미지 삭제
    @Override
    public void deleteImagesByStoreId(Long storeId) throws Exception {
        try {
            imageMapper.deleteImagesByStoreId(storeId);
            log.info("스토어 ID " + storeId + "의 모든 이미지 삭제 성공");
        } catch (Exception e) {
            log.error("스토어 ID " + storeId + "의 이미지 삭제 중 오류 발생", e);
            throw e;
        }
    }

    @Override
    public List<ImageVO> getImagesByStoreId(Long storeId) {
        try {
            List<ImageVO> imageList = imageMapper.getImagesByStoreId(storeId);
            log.info("이미지 조회 성공: 스토어 ID = " + storeId + ", 이미지 수 = " + imageList.size());
            return imageList;
        } catch (Exception e) {
            log.error("이미지 조회 중 오류 발생: 스토어 ID = " + storeId, e);
            throw e;
        }
    }
    
    // 이미지 id 조회
    @Override
    public ImageVO getImageById(Long imageId) {
        return imageMapper.getImageById(imageId);
    }
}
