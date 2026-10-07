<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵</title>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a&libraries=services,clusterer"></script>
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
#map { width: 100%; height: calc(100vh - 90px); }  /* 60px는 헤더 높이에 맞게 */

/* 가격 알약 마커 */
.price-pill {
	display: inline-flex; align-items: center; gap: 4px;
	height: 30px; padding: 0 10px;
	background: #fff; border: 3px solid #22c55e; border-radius: 999px;
	font-size: 13px; font-weight: 700; white-space: nowrap; cursor: pointer;
	box-shadow: 0 2px 6px rgba(0,0,0,.2);
}
.price-pill.mid  { border-color: #f59e0b; }   /* 중간 가격: 주황 */
.price-pill.high { border-color: #ef4444; }   /* 비싼 가격: 빨강 */
.price-pill.none { border-color: #9ca3af; color: #6b7280; }   /* 가격 정보 없음: 회색 */
	</Style>
	
	</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" >
	<jsp:param name="showAdmin" value="true" />
	</jsp:include>
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
	
	
	</div>
	<div class ="fp-applied">
	<div class="fp-applied-head">
		<span> 적용된 조건 </span>
		<a href = "#"  id ="clearAll"> 전체 해제</a>
	</div>
	<div id ="chips"></div>
	</div>
	
	<input type="text" class ="fp-search" placeholder ="지역 검색 (예: 관악구, 당곡역)">
		
	</div>
	</div>
	
	<script>
var ctx = "${pageContext.request.contextPath}";

// 글자를 안전하게 바꿔주는 함수 (null이면 빈 글자)
function esc(str) {
	if (str == null) {
		str = "";
	}
	return $("<div>").text(str).html();
}

// ===== 지도 =====
var map = new kakao.maps.Map(document.getElementById("map"), {
	center : new kakao.maps.LatLng(37.490223280126 , 126.927560844494),
	level : 4
});

var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.BOTTOMRIGHT);

var infowindow = new kakao.maps.InfoWindow({ removable : true });
var markers = [];

var clusterer = new kakao.maps.MarkerClusterer({
	map : map,
	averageCenter : true,
	minLevel : 1,
	gridSize : 100,            // 이 크기(px) 안에 있는 마커끼리 묶음 (기본 60)
	minClusterSize : 1,        // 1개짜리도 동그라미로 (기본 2라서 혼자인 건 파란 핀으로 남았음)
	calculator : [10, 50],
	styles : [
		{ width : "36px", height : "36px", background : "#3b82f6", color : "#fff",
		  borderRadius : "18px", textAlign : "center", lineHeight : "36px", fontWeight : "bold",
		  boxShadow : "0 2px 6px rgba(0,0,0,.3)" },
		{ width : "46px", height : "46px", background : "#3b82f6", color : "#fff",
		  borderRadius : "23px", textAlign : "center", lineHeight : "46px", fontWeight : "bold",
		  boxShadow : "0 2px 6px rgba(0,0,0,.3)" },
		{ width : "58px", height : "58px", background : "#3b82f6", color : "#fff",
		  borderRadius : "29px", textAlign : "center", lineHeight : "58px", fontWeight : "bold",
		  boxShadow : "0 2px 6px rgba(0,0,0,.3)" }
	]
});

//업종별 아이콘 (알약 왼쪽에 보여줄 이모지)
var catIcon = {
	"한식" : "🍚", "중식" : "🥟", "일식" : "🍣", "양식" : "🍝",
	"기타요식업" : "🍴", "미용업" : "✂️", "이용업" : "✂️",
	"세탁업" : "🧺", "숙박업" : "🛏️", "목욕업" : "♨️", "기타비요식업" : "🏪"
};
var reqSeq = 0;

// ===== 선택된 조건 =====
var filters = { category : [], price : null };

var priceLabel = {
	"5000" : "5천원 이하",
	"10000" : "1만원 이하",
	"20000" : "2만원 이하",
	"30000" : "3만원 이하"
};

// ===== 지도 이벤트 =====
kakao.maps.event.addListener(map, "idle", loadStores);

kakao.maps.event.addListener(map, "click", function() {
	infowindow.close();
	closeAllPopups();
});

// 처음 한 번 실행 (idle이 처음엔 안 뜰 수 있어서)
loadStores();

// ===== 가게 불러오기 =====
function loadStores() {
	// 북마크에서 넘어온 가게 열기 (/map/main?store_id=번호)
	var openStoreId = new URLSearchParams(location.search).get("store_id");
	if (openStoreId) {
		$.ajax({
			url : ctx + "/map/ajax/storeOne",
			type : "get",
			data : { storeId : openStoreId }
		}).done(function(s) {
			map.setLevel(3);
			map.setCenter(new kakao.maps.LatLng(s.latitude, s.longitude));
			showInfo(s, null);    // 기존 정보창 그대로 사용 (마커 없이 위치로 열기)
		});
	}
	
	var b = map.getBounds();
	var sw = b.getSouthWest();
	var ne = b.getNorthEast();

	reqSeq++;
	var mySeq = reqSeq;

	$.ajax({
		url : ctx + "/map/ajax/store",
		type : "get",
		traditional : true,
		data : {
			swLat : sw.getLat(),
			swLng : sw.getLng(),
			neLat : ne.getLat(),
			neLng : ne.getLng(),
			category : filters.category,
			price : filters.price || 0
		}
	}).done(function(rest) {
		// 오래된 응답이면 무시
		if (mySeq !== reqSeq) {
			return;
		}
		
		clusterer.clear();
		// 기존 마커 지우기
		for (var i = 0; i < markers.length; i++) {
			markers[i].setMap(null);
		}
		markers = [];

		// 새 마커 찍기
		for (var j = 0; j < rest.length; j++) {
			addMarker(rest[j]);
		}
		if (map.getLevel() >= 5	) {
			clusterer.addMarkers(markers);
		}
		
		console.log("가게 수 : " + rest.length);
	}).fail(function(xhr) {
		console.log("가게 불러오기 실패", xhr.status);
	});
}

// 마커 하나 만들기 (함수로 빼야 가게마다 따로 기억함)
function addMarker(s) {
	// 가까이 볼 때(레벨 4 이하)는 가격 알약으로 그림
	if (map.getLevel() <= 4) {
		addPill(s);
		return;                       // 아래 기본 마커는 안 그림
	}

	// 멀리서 볼 때는 기본 마커 (3단계에서 클러스터로 바꿀 예정)
	var marker = new kakao.maps.Marker({
		
		position : new kakao.maps.LatLng(s.latitude, s.longitude)
	});

	kakao.maps.event.addListener(marker, "click", function() {
		showInfo(s, marker);
	});

	markers.push(marker);
}

//가격 알약 하나 만들기
function addPill(s) {
	var cls = "price-pill";           // 기본 모양 (초록 테두리)
	var label = "가격 미정";

	if (s.min_price == null) {
		cls += " none";               // 가격 없음 → 회색
	} else {
		label = s.min_price.toLocaleString() + "원";
		if (s.min_price > 9000) {
			cls += " high";           // 9천원 초과 → 빨강
		} else if (s.min_price > 6000) {
			cls += " mid";            // 6천원 초과 → 주황
		}
	}

	// 업종 이모지 (표에 없는 업종이면 기본 🍴)
	var icon = catIcon[s.category];
	if (icon == null) {
		icon = "🍴";
	}

	// 알약 요소 만들기
	var el = document.createElement("div");
	el.className = cls;
	el.innerHTML = icon + " " + label;

	// 알약을 누르면 정보창 열기 (마커가 아니라서 마커 자리에 null)
	el.onclick = function() {
		showInfo(s, null);
	};

	// 지도 위에 올리기 (clickable: 이 클릭이 지도 클릭으로 안 넘어가게)
	var overlay = new kakao.maps.CustomOverlay({
		position : new kakao.maps.LatLng(s.latitude, s.longitude),
		content : el,
		yAnchor : 1
	});
	overlay.setMap(map);

	markers.push(overlay);           // 나중에 지우려고 바구니에 넣음
}

// ===== 정보창 =====
function showInfo(s, marker) {
	$.ajax({
		url : ctx + "/map/ajax/service",
		type : "get",
		data : { storeId : s.store_id }
	}).done(function(list) {
		var html = "<div style='width:260px; padding:12px; box-sizing:border-box; font-size:13px; overflow-wrap:break-word;'>";

		// 가게 이름 (오른쪽 위 닫기 X 버튼과 안 겹치게 오른쪽 여백)
		html += "<div style='font-size:15px; font-weight:700; padding-right:18px; margin-bottom:2px;'>" + esc(s.store_name) + " <span id='bmBtn' onclick='toggleBookmark(" + s.store_id + ")' style='cursor:pointer; color:#f59e0b; font-size:18px;'>☆</span></div>";
		html += "<div style='color:#6b7280; margin-bottom:6px;'>" + esc(s.category) + "</div>";

		if (s.phone != null && s.phone != "") {
			html += "<div>☎ " + esc(s.phone) + "</div>";
		}
		html += "<div style='color:#374151;'>" + esc(s.address) + "</div>";

		// 구분선
		html += "<div style='border-top:1px solid #e5e7eb; margin:8px 0;'></div>";

		// 메뉴 영역 (길면 이 안에서만 스크롤)
		html += "<div style='max-height:140px; overflow-y:auto;'>";

		if (list.length == 0) {
			html += "<div style='color:#9ca3af;'>등록된 메뉴가 없어요</div>";
		}
		for (var i = 0; i < list.length; i++) {
			var priceText = "가격 미정";
			if (list[i].price != null) {
				priceText = list[i].price.toLocaleString() + "원";
			}
			html += "<div style='display:flex; justify-content:space-between; gap:8px; padding:3px 0;'>";
			html += "<span>" + esc(list[i].service_name) + "</span>";
			html += "<b style='white-space:nowrap;'>" + priceText + "</b>";
			html += "</div>";
		}

		html += "</div>";   // 메뉴 영역 닫기	
		html += "</div>";   // 전체 닫기

		infowindow.setContent(html);
		if (marker !== null) {
			infowindow.open(map, marker);
		} else {
			infowindow.setPosition(new kakao.maps.LatLng(s.latitude, s.longitude));
			infowindow.open(map);
		}
		$.ajax({
			url : ctx + "/map/ajax/bookmarkCheck",
			type : "get",
			data : {storeId : s.store_id}
		}).done(function(state){
			if(state === "on") {
				$("#bmBtn").text("★");
			}
		});
	});
}
	//===== 북마크 누르기 =====
function toggleBookmark(storeId) {
	$.ajax({
		url : ctx + "/map/ajax/bookmark",
		type : "post",
		data : { storeId : storeId }
	}).done(function(result) {
		if (result === "login") {
			alert("로그인 후 이용가능합니다.");
			location.href = ctx + "/member/login";
		} else if (result === "on") {
			$("#bmBtn").text("★");
		} else {
			$("#bmBtn").text("☆");
		}
	});
}
// ===== 팝업 열기/닫기 =====
$(".pill[data-pop]").on("click", function(e) {
	e.stopPropagation();

	var $pop = $("#" + $(this).data("pop"));
	var willOpen = !$pop.is(":visible");

	closeAllPopups();

	if (willOpen) {
		syncInputs();
		$pop.show();
		$(this).addClass("open");
	}
});

// 팝업 안쪽 클릭은 닫히지 않게
$(".popup").on("click", function(e) {
	e.stopPropagation();
});

// 바깥 클릭하면 닫기
$(document).on("click", closeAllPopups);

function closeAllPopups() {
	$(".popup").hide();
	$(".pill").removeClass("open");
}

// 팝업 열 때, 체크 상태를 filters 와 맞추기
function syncInputs() {
	$("input[name=category]").each(function() {
		this.checked = (filters.category.indexOf(this.value) !== -1);
	});

	$("input[name=price]").each(function() {
		this.checked = (this.value === filters.price);
	});
}

// ===== 적용 / 초기화 버튼 =====
$(".btn-apply").on("click", function() {
	var type = $(this).data("for");

	if (type === "category") {
		filters.category = $("input[name=category]:checked").map(function() {
			return this.value;
		}).get();
	} else if (type === "price") {
		filters.price = $("input[name=price]:checked").val() || null;
	}

	closeAllPopups();
	refresh();
});

$(".btn-reset").on("click", function() {
	var type = $(this).data("for");

	$("input[name=" + type + "]").prop("checked", false);

	if (type === "category") {
		filters.category = [];
	} else if (type === "price") {
		filters.price = null;
	}

	closeAllPopups();
	refresh();
});

// ===== 적용된 조건 칩 =====
function renderChips() {
	var $chips = $("#chips");
	$chips.empty();

	for (var i = 0; i < filters.category.length; i++) {
		$chips.append(makeChip("category", filters.category[i], filters.category[i]));
	}

	if (filters.price != null) {
		$chips.append(makeChip("price", filters.price, priceLabel[filters.price]));
	}
}

function makeChip(type, value, label) {
	var $chip = $("<span class='chip-applied'></span>");
	$chip.append($("<span></span>").text(label));
	$chip.append(
		$("<span class='x'>×</span>")
			.attr("data-type", type)
			.attr("data-value", value)
	);
	return $chip;
}

// 칩의 × 누르면 그 조건만 빼기
$("#chips").on("click", ".x", function() {
	var type = $(this).attr("data-type");
	var value = $(this).attr("data-value");

	if (type === "category") {
		var idx = filters.category.indexOf(value);
		if (idx !== -1) {
			filters.category.splice(idx, 1);
		}
	} else if (type === "price") {
		filters.price = null;
	}

	refresh();
});

// 전체 해제
$("#clearAll").on("click", function(e) {
	e.preventDefault();
	filters.category = [];
	filters.price = null;
	refresh();
});

// 칩 다시 그리고, 가게 다시 불러오기
function refresh() {
	renderChips();
	loadStores();
}

	// "관악구" 같은 주소를 위도 경도로 변환해주는객체생성
	var geocoder = new kakao.maps.services.Geocoder();
	
	// "화곡역" 같은 장소 이름으로 찾아주는 객체 생성
	var places = new kakao.maps.services.Places();
	
	$(".fp-search").on("keydown",function(e){
		
		if (e.key !== "Enter" || e.originalEvent.isComposing) {
			return;
		}
		
		var keyword = $(this).val().trim();
		
		if(keyword == ""){
			return;
		}
		
		// [1차 시도] 주소로 찾기                //찾은 결과목록, 찾았는지 성공여부
		geocoder.addressSearch(keyword , function (result, status) {
			if (status === kakao.maps.services.Status.OK) { 
				map.setCenter(new kakao.maps.LatLng(result[0].y , result[0].x));
			map.setLevel(6);
			}else {
				
				//[2차 시도] 장소 이름으로 찾기              //찾은 장소목록 , 찾았는지 성공여부
				places.keywordSearch(keyword, function (data, status2) {
					
					 if(status2 === kakao.maps.services.Status.OK) {
						 map.setCenter(new kakao.maps.LatLng(data[0].y , data[0].x));
						 map.setLevel(4);
					 } else {
						 alert("검색 결과가 없습니다. 다른 지역명으로 입력해주세요.")
					 }
				})
			}
		})  
	})
	
</script>
</body>
</html>