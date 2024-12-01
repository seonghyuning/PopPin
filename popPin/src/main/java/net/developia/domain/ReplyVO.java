package net.developia.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class ReplyVO {
	private Long rno;         // 댓글 고유 ID (기본 키)
    private Long storeId;     // 팝업스토어 ID
    private String reply;     // 댓글 내용
    private String replyer;   // 작성자
    private Date replyDate;   // 댓글 작성 시간
    private Date updateDate;  // 댓글 수정 시간
}
