package net.developia.domain;

import lombok.Data;

@Data
public class PopUpStoreLocationVO {
    private Long storeId;    // 팝업스토어 ID (기본키 및 외래키)
    private Double latitude; // 위도 (소수점 6자리)
    private Double longitude; // 경도 (소수점 6자리)
    private String title;    // 팝업스토어 제목 추가
}