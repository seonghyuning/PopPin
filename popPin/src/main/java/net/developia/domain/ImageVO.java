package net.developia.domain;

import lombok.Data;

@Data
public class ImageVO {
	private Long imageId;    // 이미지 ID (기본 키)
    private Long storeId;    // 팝업스토어 ID
    private String filePath; // 이미지 경로
}
