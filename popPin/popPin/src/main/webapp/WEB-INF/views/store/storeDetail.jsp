<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Store Detail</title>
    <link rel="stylesheet" href="/resources/css/list.css">
    
<body>
<%@ include file="../includes/header.jsp"%>
</head>
<p id="view">조회수: ${store.views}</p></br>
<div class="container">
    <div class="detailImg"><img class="imgClass" src="/resources/img/kakao.jpg" alt=""></div>
    <div class="detailText"><h2><c:out value="${store.name}" /></h2><h4><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-geo-alt-fill" viewBox="0 0 16 16">
        <path d="M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10m0-7a3 3 0 1 1 0-6 3 3 0 0 1 0 6"/>
      </svg><c:out value="${store.location}" /></h4></div>
    <div class="detailText">
    	<h3>팝업스토어 소개</h3>
    	<p><c:out value="${store.description}" /></p></br>
    	<h3>기간</h3>
    	<p>
    	<fmt:formatDate value="${store.startDate}" pattern="yyyy.MM.dd" />
       	 ~
        <fmt:formatDate value="${store.endDate}" pattern="yyyy.MM.dd" />
        </p>
    </div>
    <div class="detailImg"><img class="imgClass" src="/resources/img/kakao2.jpg" alt=""></div>
</div>
<div class="mapContainer" >
    <h2>지도 주소</h2>
    <div id="map"></div> 

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2a11eb426bd8d22b527b68106a60722a&libraries=services,clusterer,drawing"></script>
	
	<script type="text/javascript">
	// 지도 영역
    let container = document.getElementById('map');

    // 주소를 변수로 전달
    let address = "${store.location}";
	console.log(address);
    // Kakao 지도 초기화
    let options = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 초기값(임시)
        level: 3 // 지도 확대 레벨
    };
    let map = new kakao.maps.Map(container, options);
	
    // 주소-좌표 변환 객체 생성
    let geocoder = new kakao.maps.services.Geocoder();
    
    // 주소로 좌표를 검색
    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            // 검색이 성공하면 지도 중심 이동
            let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            map.setCenter(coords);

            // 지도에 마커 추가
            let marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });
        } else {
            console.error("주소 변환 실패: " + status);
        }
    });
</script>
	<div><p><c:out value="${store.location}" /></p></div>
</div>

</body>
</html>
