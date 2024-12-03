<!-- 김성현, 자카소스코드 -->

<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>팝업스토어 지도</title>
<link rel="stylesheet" href="/resources/css/list.css">
</head>

<body>
	<%@ include file="../includes/header.jsp"%>
	<div class="mapContainer">
	
		<div id="map" style="width: 100%; height: 500px;"></div>
	</div>
	<h3 id="map-search-list">팝업스토어 목록</h3>
	<div id="popup-store-list" class="popup-store-list">
	
		<div id="store-list-container"></div>
	
	</div>

<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2a11eb426bd8d22b527b68106a60722a&libraries=services,clusterer,drawing"></script>

<script type="text/javascript">
	// 날짜 포맷 함수 (timestamp -> yyyy-MM-dd 형식)
	function formatDate(timestamp) {
	    var date = new Date(timestamp);
	    var year = date.getFullYear();
	    var month = ("0" + (date.getMonth() + 1)).slice(-2);  // 월은 0부터 시작하므로 +1 해줘야 함
	    var day = ("0" + date.getDate()).slice(-2);
	    return year + "-" + month + "-" + day;
	}
	
	
	// 지도 객체 생성
	var container = document.getElementById('map'); // 지도가 표시될 DOM 요소
	var options = {
	    center: new kakao.maps.LatLng(37.543976, 127.051266), // 서울 시청 기본 중심 좌표
	    level: 3 // 지도의 확대 수준
	};
	var map = new kakao.maps.Map(container, options);
	
	
	// 서버에서 전달받은 데이터
	var locations = ${ locationsJson }; // 상세 데이터 포함
	
	// 지도와 마커 설정
	var markers = [];
	
	locations.forEach(function (location) {
	    var lat = location.latitude;
	    var lng = location.longitude;
	    var markerPosition = new kakao.maps.LatLng(lat, lng);
	
	    var marker = new kakao.maps.Marker({
	        position: markerPosition,
	        title: location.title // 마커 제목
	
	    });
	
	    // 마커를 지도에 표시
	    marker.setMap(map);
	
	    // 마커 클릭 시 팝업스토어 제목을 표시하는 함수
	    kakao.maps.event.addListener(marker, 'click', function () {
	        var storeId = location.storeId;
	        var title = location.title; // storeId를 통해 제목을 가져올 수 있다면 그 정보를 넣는다.
	        alert('팝업스토어 ID: ' + storeId + ', 제목: ' + title);
	    });
	
	    // 마커 배열에 추가
	    markers.push({
	        marker: marker,
	        location: location
	    });
	});
	
	// 지도 영역 내 팝업스토어 필터링
	
	function getVisibleStores() {
	    var bounds = map.getBounds();
	    var swLatLng = bounds.getSouthWest();
	    var neLatLng = bounds.getNorthEast();
	
	
	    // 지도에 보이는 범위 내 팝업스토어 필터링
	
	    var visibleStores = markers.filter(function (item) {
	        var lat = item.location.latitude;
	        var lng = item.location.longitude;
	        return lat >= swLatLng.getLat() &&
	            lat <= neLatLng.getLat() &&
	            lng >= swLatLng.getLng() &&
	            lng <= neLatLng.getLng();
	    }).map(function (item) {
	        return item.location;
	    });
	
	    updateStoreList(visibleStores);
	}
	
	// 리스트 갱신
	function updateStoreList(visibleStores) {
	    var storeListDiv = document.getElementById('store-list-container');
	    storeListDiv.innerHTML = ''; // 기존 리스트 초기화

	    if (visibleStores.length === 0) {
	        storeListDiv.innerHTML = '<p>현재 지도에 표시된 팝업스토어가 없습니다.</p>';
	    } else {
	        visibleStores.forEach(function (store) {
	            var storeItem = document.createElement('div');
	            storeItem.classList.add('store-item');

	            // 이미지가 존재하면 해당 ID로 이미지를 불러오고, 없으면 기본 이미지를 표시
	            var storeImageDiv = document.createElement('div');
	            storeImageDiv.classList.add('store-image');
	            var storeImage = document.createElement('img');
	            storeImage.src = '/store/' + store.imageId; // 이미지 ID 기반 URL
	            storeImage.alt = store.title;
	            storeImageDiv.appendChild(storeImage);

	            var storeInfoDiv = document.createElement('div');
	            storeInfoDiv.classList.add('store-info');
	            var storeTitle = document.createElement('h4');
	            storeTitle.textContent = store.title;

	            // 기간 포맷 수정
	            var startDateFormatted = formatDate(store.startDate); // timestamp -> yyyy-MM-dd 형식
	            var endDateFormatted = formatDate(store.endDate);     // timestamp -> yyyy-MM-dd 형식
	            var storePeriod = document.createElement('p');
	            storePeriod.textContent = '기간: ' + startDateFormatted + ' ~ ' + endDateFormatted;

	            var storeAddress = document.createElement('p');
	            storeAddress.textContent = '주소: ' + store.location;

	            var storeLink = document.createElement('a');
	            storeLink.href = '/store/storeDetail?storeId=' + store.storeId;
	            storeLink.textContent = '상세보기';

	            storeInfoDiv.appendChild(storeTitle);
	            storeInfoDiv.appendChild(storePeriod);
	            storeInfoDiv.appendChild(storeAddress);
	            storeInfoDiv.appendChild(storeLink);

	            storeItem.appendChild(storeImageDiv);
	            storeItem.appendChild(storeInfoDiv);

	            storeListDiv.appendChild(storeItem);
	        });
	    }
	}

	
	// 지도 이동 및 확대/축소 완료 시 호출
	kakao.maps.event.addListener(map, 'idle', getVisibleStores);
	
	// 초기 실행
	getVisibleStores();
</script>
</body>
</html>