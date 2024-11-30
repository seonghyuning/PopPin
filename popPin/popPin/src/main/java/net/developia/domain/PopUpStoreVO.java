package net.developia.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class PopUpStoreVO {
	private Long storeId;       // 팝업스토어 고유 ID
    private String name;        // 팝업스토어 이름
    private String location;    // 팝업스토어 위치 정보
    private String description; // 팝업스토어 설명
    private Date startDate;     // 운영 시작일
    private Date endDate;       // 운영 종료일
    private int views;          // 조회수
    private String createdBy;   // 작성자 ID
    private int status;         // 승인 여부 (0: 대기, 1: 승인, 2: 거절)
}
