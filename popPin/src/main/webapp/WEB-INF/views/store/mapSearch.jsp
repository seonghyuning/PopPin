<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        <div id="map" style="width: 100%; height: 500px;"></div> <!-- 지도 크기 설정 -->
    </div>

    <div id="popup-store-list" class="popup-store-list">
        <h3>현재 지도에 보이는 팝업스토어 목록</h3>
        <div id="store-list-container"> <input type="hidden" name="storeId" value="${store.storeId}" /></div> <!-- 실제 팝업스토어 리스트가 여기에 추가됩니다 -->
    </div>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2a11eb426bd8d22b527b68106a60722a&libraries=services,clusterer,drawing"></script>

    <script type="text/javascript">
        // 지도 객체 생성
        var container = document.getElementById('map'); // 지도가 표시될 DOM 요소
        var options = {
            center: new kakao.maps.LatLng(37.543976, 127.051266), // 서울 시청 기본 중심 좌표
            level: 3 // 지도의 확대 수준
        };
        var map = new kakao.maps.Map(container, options);

        // 서버에서 위치 데이터를 가져와서 지도에 마커를 추가
        var locations = ${locationsJson};  // 서버에서 전달받은 JSON 형식의 팝업스토어 위치 정보

        // 마커들을 저장할 배열
        var markers = [];

        // 지도에 마커 추가
        locations.forEach(function(location) {
            var lat = location.latitude;
            var lng = location.longitude;
            var markerPosition = new kakao.maps.LatLng(lat, lng);
            var marker = new kakao.maps.Marker({
                position: markerPosition,
                title: location.title // 마커의 title로 팝업스토어 ID를 설정
            });

            // 마커를 지도에 표시
            marker.setMap(map);

            // 마커 클릭 시 팝업스토어 제목을 표시하는 함수
            kakao.maps.event.addListener(marker, 'click', function() {
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

        // 지도 영역을 기준으로 보이는 팝업스토어만 필터링하는 함수
        function getVisibleStores() {
            var bounds = map.getBounds();
            var swLatLng = bounds.getSouthWest();
            var neLatLng = bounds.getNorthEast();

            // 지도에 보이는 범위 내 팝업스토어 필터링
            var visibleStores = markers.filter(function(item) {
                var lat = item.location.latitude;
                var lng = item.location.longitude;
                return lat >= swLatLng.getLat() &&
                       lat <= neLatLng.getLat() &&
                       lng >= swLatLng.getLng() &&
                       lng <= neLatLng.getLng();
            }).map(function(item) {
                return item.location;
            });
            // 필터링된 팝업스토어 리스트를 콘솔에 출력
            console.log(visibleStores);

            // 필터링된 팝업스토어 리스트 업데이트
            updateStoreList(visibleStores);
            
        }

        // 필터링된 팝업스토어 리스트를 페이지에 표시하는 함수
        function updateStoreList(visibleStores) {
		    var storeListDiv = document.getElementById('store-list-container');
		    storeListDiv.innerHTML = ''; // 기존 리스트 초기화
		
		    if (visibleStores.length === 0) {
		        storeListDiv.innerHTML = '<p>현재 지도에 표시된 팝업스토어가 없습니다.</p>';
		    } else {
		    	 visibleStores.forEach(function(store) {
		             var storeItem = document.createElement('div');
		             storeItem.classList.add('store-item');
		             
		             // <a> 태그 내부의 onclick을 자바스크립트로 처리하여 동적으로 값을 할당
		             var link = document.createElement('a');
		             link.href = '/store/storeDetail';
		             link.innerHTML = store.title;
		             link.onclick = function() {
		                 alert('ID: ' + store.storeId + ', 제목: ' + store.title);
		             };

		             var storeContent = document.createElement('div');
		             storeContent.classList.add('store-item-content');
		             storeContent.appendChild(link);

		             storeItem.appendChild(storeContent);
		             storeItem.style.color = 'white'; // 글씨 색을 흰색으로 설정
		             storeItem.style.backgroundColor = '#333'; // 항목 배경색 설정

		             storeListDiv.appendChild(storeItem);
		         });
		    }
		}

        // 지도 크기나 이동이 완료된 후 visibleStores를 갱신
        kakao.maps.event.addListener(map, 'idle', getVisibleStores);

        // 초기 지도 로딩 시 보이는 팝업스토어 리스트 표시
        getVisibleStores();
    </script>
</body>
</html>
