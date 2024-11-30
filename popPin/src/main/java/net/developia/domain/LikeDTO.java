package net.developia.domain;

import lombok.Data;

@Data
public class LikeDTO {
	 private String username; // 사용자 이름
	 private Long storeId;    // 팝업스토어 ID
}
