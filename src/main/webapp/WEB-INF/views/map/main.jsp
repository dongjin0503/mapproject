<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵</title>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

	<Style>
	.filter-panel {
	position: absolute; top: 20px; left: 20px; z-index: 10;
	width: 340px; padding: 16px; box-sizing: border-box;
	background: #fff; border: 1px solid #d1d5db; border-radius: 12px;
	box-shadow: 0 4px 16px rgba(0,0,0,.12);
	font-size: 13px;
}
.fp-title { font-size: 12px; color: #6b7280; font-weight: 700; margin-bottom: 8px; }
.fp-pills { display: flex; gap: 8px; margin-bottom: 14px; }
.pill-wrap { position: relative; }
.pill {
	height: 34px; padding: 0 14px; border: 1px solid #d1d5db; border-radius: 999px;
	background: #fff; font-size: 13px; cursor: pointer;
}
.pill:hover { background: #f3f4f6; }
.pill.open { background: #3157d5; color: #fff; border-color: #3157d5; }
.pill:disabled { opacity: .5; cursor: default; }

.popup {
	position: absolute; top: 40px; left: 0; z-index: 20; width: 210px;
	background: #fff; border: 1px solid #d1d5db; border-radius: 10px;
	box-shadow: 0 6px 18px rgba(0,0,0,.15); padding: 10px;
}
.popup-list { max-height: 220px; overflow-y: auto; }
.popup-list label { display: block; padding: 6px 4px; cursor: pointer; }
.popup-btns { display: flex; gap: 8px; margin-top: 8px; padding-top: 10px; border-top: 1px solid #e5e7eb; }
.popup-btns button { flex: 1; height: 32px; border-radius: 6px; cursor: pointer; font-size: 12px; }
.btn-reset { background: #fff; border: 1px solid #d1d5db; color: #6b7280; }
.btn-apply { background: #3157d5; border: 1px solid #3157d5; color: #fff; font-weight: 700; }

.fp-applied { border-top: 1px solid #e5e7eb; padding-top: 12px; margin-bottom: 12px; }
.fp-applied-head { display: flex; justify-content: space-between; color: #6b7280; margin-bottom: 8px; }
.fp-applied-head a { color: #3157d5; text-decoration: none; }
#chips { display: flex; flex-wrap: wrap; gap: 6px; min-height: 28px; }
.chip-applied {
	display: inline-flex; align-items: center; gap: 6px; height: 28px; padding: 0 10px;
	background: #3157d5; color: #fff; border-radius: 999px; font-size: 12px; font-weight: 700;
}
.chip-applied .x { cursor: pointer; }

.fp-search {
	width: 100%; height: 40px; padding: 0 12px; box-sizing: border-box;
	border: 1px solid #d1d5db; border-radius: 6px;
}
.map-wrap { position: relative; }
#map { width: 100%; height: calc(100vh - 60px); }  /* 60px는 헤더 높이에 맞게 */
	</Style>
	
	</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="map-wrap">
	<div id="map"></div>
	<div class="filter-panel">
	<div class ="fp-title"> 필터 </div>
	
	<div class ="fp-pills"> 
	<div class ="pill-wrap"> 
	<button type="button" class="pill" data-pop="popCategory">업종 ▾</button>
	<div class="popup" id = "popCategory" style ="display:none;">
	<div class="popup-list">
		<label><input type = "checkbox" name= "category" value = "한식" > 한식 </label>
		<label><input type = "checkbox" name = "category" value = "중식"> 중식 </label>
		<label><input type = "checkbox" name = "category" value = "일식"> 일식</label>
		<label><input type = "checkbox" name = "category" value = "양식"> 양식 </label>
		<label><input type = "checkbox" name = "category" value = "기타요식업" > 기타요식업 </label>
		<label><input type = "checkbox" name = "category" value = "미용업"> 미용업 </label>
		<label><input type = "checkbox" name = "category" value = "이용업"> 이용업 </label>
		<label><input type = "checkbox" name = "category" value = "세탁업"> 세탁업 </label>
		<label><input type = "checkbox" name = "category" value = "숙박업"> 숙박업 </label>
		<label><input type = "checkbox" name = "category" value = "목욕업"> 목욕업 </label>
		<label><input type = "checkbox" name = "category" value = "기타비요식업"> 기타비요식업 </label>
	
	</div>
	<div class = "popup-btns">
		<button type ="button" class ="btn-reset" data-for = "category"> 초기화</button>
		<button type ="button" class ="btn-apply" data-for = "category"> 적용 </button>
	</div>
	
	</div>
	</div>
	
	<!-- 가격대 -->
	<div class = "pill-wrap">
		<button type ="button" class ="pill" data-pop ="popPrice" > 가격대 ▾ </button>
		<div class ="popup" id = "popPrice" style = "display:none;">
		<div class ="popup-list">
			<label><input type ="radio" name ="price" value ="5000"> 5천원 이하</label>
			<label><input type ="radio" name ="price" value ="10000"> 1만원 이하 </label>
			<label><input type ="radio" name = "price" value = "20000"> 2만원 이하</label>
			<label><input type ="radio" name = "price" value = "30000"> 3만원 이하</label>
		</div>
		
		<div class="popup-btns">
			<button type ="button" class="btn-reset" data-for = "price"> 초기화 </button>
			<button type ="button" class="btn-apply" data-for = "price"> 적용</button>
		</div>
		</div>
	</div>
	
	<!--  지역별 -->
	<div class ="pill-wrap">
		<button type = "button" class = "pill" disabled> 지역별 ▾</button>
	</div>
	</div>
	<div class ="fp-applied">
	<div class="fp-applied-head">
		<span> 적용된 조건 </span>
		<a href = "#"  id ="clearAll"> 전체 해제</a>
	</div>
	<div id ="chips"></div>
	</div>
	
	<input type="text" class ="fp-search" placeholder ="지역 검색 (예: 관악구)">
		
	</div>
	</div>
	
	<script>
		
		
		var container = document.getElementById("map");
		var options = {
				center : new kakao.maps.LatLng(37.5665,126.9780),
				level: 5		
		};
		var map = new kakao.maps.Map(container, options);
		kakao.maps.event.addListener(map, "idle", loadStores);
		var infowindow = new kakao.maps.InfoWindow({}); 	
		var markers = [];
		
		function loadStores(){
			var b = map.getBounds();
			var sw = b.getSouthWest();
			var ne = b.getNorthEast();
		
			$.ajax({
				url : "/map/ajax/store",
				data : {swLat : sw.getLat() , swLng : sw.getLng(),  
						neLat : ne.getLat() , neLng : ne.getLng()},
				dataType : "json"
			}).done(function(rest){
			for (var i =0 ; i < markers.length ; i++) {
				markers[i].setMap(null);
			}
			markers = []
			
			for (var j = 0 ; j < rest.length ; j++) {
				let s = rest[j];
				
				let marker = new kakao.maps.Marker({
					map : map,
					position : new kakao.maps.LatLng(s.latitude, s.longitude),
					title : s.store_name
				})
				markers.push(marker);
				kakao.maps.event.addListener(marker, "click" , function(){
					console.log(s.store_name);
					
					$.ajax({
						url : "/map/ajax/service",
						data : {storeId : s.store_id},
						dataType : "json"
					}).done(function(menus){
						
						var phone = "전화 번호가 등록되어 있지 않습니다."
						if(s.phone != null) {
							phone = s.phone;
						}
						var html = "<div style='padding:10px; min-width:240px; max-height:250px; overflow-y:auto;'>";
							
						html += "<b>" + s.store_name + "</b><br>";
						html += s.category + "<br>" ;
						html += s.address + "<br>" ;
						html += phone + "<br><br>";
						
						for (var k = 0; k < menus.length; k++) {
							var price = "가격 정보가 등록되지 않았습니다";
							if (menus[k].price != null) {
								price = menus[k].price + "원";	
							}
							html += menus[k].service_name + " : " + price + "<br>";
							
						}
						html += "</div>";
						
						infowindow.setContent(html);
						infowindow.open(map,marker);
						
					})
				})
			}	
			});
		}
		
	
		
		
		
	</script>
</body>
</html>