<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a&libraries=services,clusterer"></script>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<title>모임 수정</title>

<style>
* {
	box-sizing: border-box;
}

.party-edit-form {
	max-width: 650px;
	margin: 40px auto;
	padding: 30px;
	border: 1px solid #ddd;
	border-radius: 10px;
}

.party-edit-form h1 {
	margin: 0 0 30px;
	text-align: center;
	font-size: 26px;
}

.party-edit-form label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
}

.party-edit-form input,
.party-edit-form textarea {
	width: 100%;
	padding: 12px;
	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
}

.party-edit-form textarea {
	min-height: 160px;
	resize: vertical;
}

#party-map {
	width: 100%;
	height: 300px;
	margin-bottom: 20px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.btn-area {
	display: flex;
	gap: 10px;
}

.update-btn,
.cancel-btn {
	flex: 1;
	height: 45px;
	border-radius: 5px;
	font-size: 15px;
	cursor: pointer;
}

.update-btn {
	border: 1px solid black;
	background-color: black;
	color: white;
}

.cancel-btn {
	border: 1px solid #ccc;
	background-color: white;
	color: black;
}

.error-message {
	margin-top: 15px;
	color: #c62828;
	white-space: pre-line;
}
.store-picker { display: flex; flex-direction: column; gap: 8px; margin-bottom: 20px; }
.sp-search { display: flex; gap: 6px; }
.sp-search input { flex: 1; width: auto; min-width: 0; margin: 0; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
.sp-search button { padding: 0 16px; border: 1px solid #111; border-radius: 5px; background: #111; color: #fff; font-weight: bold; cursor: pointer; }
.sp-cats { display: flex; flex-wrap: wrap; gap: 6px; }
.sp-cats label { display: inline-flex; margin: 0; align-items: center; gap: 4px; padding: 4px 10px; border: 1px solid #ddd; border-radius: 999px; font-size: 13px; cursor: pointer; background: #fff; }
.sp-cats input { margin: 0; padding: 0; width: auto; }
.sp-cats label:has(input:checked) { border-color: #111; background: #f3f4f6; font-weight: bold; }
#sp-results { list-style: none; margin: 0; padding: 0; max-height: 220px; overflow-y: auto; border: 1px solid #ddd; border-radius: 5px; }
#sp-results li { padding: 8px 12px; border-bottom: 1px solid #eee; cursor: pointer; font-size: 14px; line-height: 1.4; }
#sp-results li:last-child { border-bottom: none; }
#sp-results li:hover, #sp-results li:focus { background: #f3f4f6; outline: none; }
#sp-results li small { display: block; color: #6b7280; font-size: 12px; }
.store-picker #party-map { width: 100%; height: 360px; border: 1px solid #ddd; border-radius: 5px; margin: 0; }
.sp-hint { margin: 0; font-size: 12px; color: #6b7280; white-space: normal; }
.sp-selected { display: flex; gap: 6px; align-items: center; }
.sp-selected input { flex: 1; }

</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<form class="party-edit-form"
		action="/party/update"
		method="post">

		<h1>모임 수정</h1>

		<input type="hidden"
			name="partyId"
			value="${party.partyId}">

		<label for="title">모임 제목</label>

		<input type="text"
			id="title"
			name="title"
			value="${party.title}"
			maxlength="100"
			required>


		<label for="contents">모임 소개</label>

		<textarea id="contents"
			name="contents"
			maxlength="2000">${party.contents}</textarea>


		<label for="meetDate">
			모임 날짜 및 시간
		</label>

		<input type="datetime-local"
			id="meetDate"
			name="meetDateText"
			value="${meetDateText}"
			required>


		<label for="question">
			참여 신청 질문
		</label>

		<input type="text"
			id="question"
			name="question"
			value="${party.question}"
			maxlength="300">


		<label>모임 장소</label>

	<div class="store-picker">

	<div class="sp-search">
		<input type="text" id="sp-keyword" maxlength="50" autocomplete="off"
			placeholder="가게 이름 · 주소 · 지역 검색 (예: 김밥, 관악구, 신림역)">
		<button type="button" id="sp-search-btn">검색</button>
	</div>

	<div class="sp-cats">
		<label><input type="checkbox" class="sp-cat" value="한식"> 한식</label>
		<label><input type="checkbox" class="sp-cat" value="중식"> 중식</label>
		<label><input type="checkbox" class="sp-cat" value="일식"> 일식</label>
		<label><input type="checkbox" class="sp-cat" value="양식"> 양식</label>
		<label><input type="checkbox" class="sp-cat" value="기타요식업"> 기타요식업</label>
		<label><input type="checkbox" class="sp-cat" value="미용업"> 미용업</label>
		<label><input type="checkbox" class="sp-cat" value="이용업"> 이용업</label>
		<label><input type="checkbox" class="sp-cat" value="세탁업"> 세탁업</label>
		<label><input type="checkbox" class="sp-cat" value="숙박업"> 숙박업</label>
		<label><input type="checkbox" class="sp-cat" value="목욕업"> 목욕업</label>
		<label><input type="checkbox" class="sp-cat" value="기타비요식업"> 기타비요식업</label>
	</div>

	<ul id="sp-results" hidden></ul>

	<div id="party-map"></div>
	<p class="sp-hint">지도를 움직이거나 확대·축소하면 그 지역의 착한가게가 다시 표시됩니다. 마커나 검색 결과를 누르면 모임 장소로 선택됩니다.</p>

	<div class="sp-selected">
		<input type="hidden" id="storeId" name="storeId" value="${party.storeId > 0 ? party.storeId : 0}">
		<input type="text" id="storeName" name="storeName" value="${party.storeName}"
			placeholder="지도나 검색에서 장소를 선택하세요" readonly>
	</div>
</div>


		<div class="btn-area">

			<button type="submit"
				class="update-btn">
				수정
			</button>

			<button type="button"
				class="cancel-btn"
				onclick="location.href='/party/detail?partyId=${party.partyId}'">
				취소
			</button>

		</div>

		<p class="error-message">${message}</p>

	</form>

	<script>
// - 지도를 움직이거나 확대/축소하면(idle) 보이는 영역의 착한가게를 다시 불러옴
// - 업종 필터 + 검색(가게 이름·주소 → 없으면 지역/장소로 지도 이동)
(function () {

	var map = new kakao.maps.Map(document.getElementById("party-map"), {
		center : new kakao.maps.LatLng(37.4902, 126.9275),
		level : 4
	});

	// 멀리서 볼 때(레벨 6 이상) 가까운 마커를 묶어서 숫자로 표시
	var clusterer = new kakao.maps.MarkerClusterer({
		map : map,
		averageCenter : true,
		minLevel : 6
	});

	var markers = [];          // 지금 지도에 있는 마커 (다시 불러올 때 지우려고 보관)
	var reqSeq = 0;            // 늦게 도착한 옛날 응답을 무시하기 위한 번호
	var infoWindow = new kakao.maps.InfoWindow({ zIndex : 3 });
	var selectedMarker = null; // 선택한 가게는 별 마커로 따로 표시
	var starImage = new kakao.maps.MarkerImage(
		"https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png",
		new kakao.maps.Size(24, 35)
	);

	var geocoder = new kakao.maps.services.Geocoder();
	var places = new kakao.maps.services.Places();

	function esc(str) {
		return String(str == null ? "" : str)
			.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;").replace(/'/g, "&#39;");
	}

	function selectedCategories() {
		return $(".sp-cat:checked").map(function () { return this.value; }).get();
	}

	function storeInfoHtml(s) {
		return '<div style="padding:6px 10px;font-size:13px;line-height:1.5;min-width:180px;">'
			+ '<strong>' + esc(s.store_name) + '</strong><br>'
			+ '카테고리 : ' + esc(s.category) + '<br>'
			+ '주소 : ' + esc(s.address)
			+ '</div>';
	}

	// 가게를 모임 장소로 선택
	function selectStore(s, moveMap) {
		$("#storeId").val(s.store_id);
		$("#storeName").val(s.store_name);

		var pos = new kakao.maps.LatLng(s.latitude, s.longitude);

		if (selectedMarker) {
			selectedMarker.setMap(null);
		}
		selectedMarker = new kakao.maps.Marker({ map : map, position : pos, image : starImage, zIndex : 2 });

		if (moveMap) {
			map.setLevel(3);
			map.setCenter(pos);
		}
		infoWindow.setContent(storeInfoHtml(s));
		infoWindow.open(map, selectedMarker);
	}

	// 지금 보이는 지도 영역의 가게 불러오기
	function loadStores() {
		var bounds = map.getBounds();
		var sw = bounds.getSouthWest();
		var ne = bounds.getNorthEast();

		reqSeq++;
		var mySeq = reqSeq;

		$.ajax({
			url : "/map/ajax/store",
			type : "get",
			traditional : true,
			data : {
				swLat : sw.getLat(),
				swLng : sw.getLng(),
				neLat : ne.getLat(),
				neLng : ne.getLng(),
				category : selectedCategories(),
				price : 0
			}
		}).done(function (stores) {
			if (mySeq !== reqSeq) {
				return; // 그 사이 지도를 또 움직였으면 옛날 결과는 버림
			}

			clusterer.clear();
			markers = [];

			for (var i = 0; i < stores.length; i++) {
				markers.push(makeMarker(stores[i]));
			}
			clusterer.addMarkers(markers);
		});
	}

	// 마커 하나 만들기 (함수로 빼야 가게마다 따로 기억함)
	function makeMarker(s) {
		var marker = new kakao.maps.Marker({
			position : new kakao.maps.LatLng(s.latitude, s.longitude)
		});
		var hover = new kakao.maps.InfoWindow({ content : storeInfoHtml(s) });

		kakao.maps.event.addListener(marker, "mouseover", function () { hover.open(map, marker); });
		kakao.maps.event.addListener(marker, "mouseout", function () { hover.close(); });
		kakao.maps.event.addListener(marker, "click", function () {
			hover.close();
			selectStore(s, false);
		});
		return marker;
	}

	// 검색: 1) 가게 이름·주소  2) 없으면 주소(지역)  3) 그래도 없으면 장소 이름
	function search() {
		var keyword = $("#sp-keyword").val().trim();
		if (keyword === "") {
			$("#sp-results").attr("hidden", true).empty();
			return;
		}

		$.ajax({
			url : "/party/searchStore",
			type : "get",
			traditional : true,
			data : { keyword : keyword, category : selectedCategories() }
		}).done(function (list) {
			var $ul = $("#sp-results").empty();

			if (list.length > 0) {
				for (var i = 0; i < list.length; i++) {
					var li = $("<li tabindex='0'></li>").html(
						"<b>" + esc(list[i].store_name) + "</b> · " + esc(list[i].category)
						+ "<small>" + esc(list[i].address) + "</small>"
					);
					li.data("store", list[i]);
					$ul.append(li);
				}
				$ul.removeAttr("hidden");
				return;
			}

			$ul.attr("hidden", true);
			moveToRegion(keyword);
		});
	}

	function moveToRegion(keyword) {
		geocoder.addressSearch(keyword, function (result, status) {
			if (status === kakao.maps.services.Status.OK) {
				map.setLevel(5);
				map.setCenter(new kakao.maps.LatLng(result[0].y, result[0].x));
				return;
			}
			places.keywordSearch(keyword, function (data, status2) {
				if (status2 === kakao.maps.services.Status.OK) {
					map.setLevel(4);
					map.setCenter(new kakao.maps.LatLng(data[0].y, data[0].x));
				} else {
					alert("검색 결과가 없습니다. 가게 이름이나 지역명을 다시 입력해 주세요.");
				}
			});
		});
	}

	// ===== 이벤트 =====
	kakao.maps.event.addListener(map, "idle", loadStores); // 이동·확대·축소가 끝날 때마다

	$("#sp-search-btn").on("click", search);

	$("#sp-keyword").on("keydown", function (e) {
		if (e.key !== "Enter") {
			return;
		}
		e.preventDefault(); // 엔터로 모임 폼이 제출되지 않게
		if (!e.originalEvent.isComposing) {
			search();
		}
	});

	$("#sp-results").on("click keydown", "li", function (e) {
		if (e.type === "keydown" && e.key !== "Enter") {
			return;
		}
		e.preventDefault();
		selectStore($(this).data("store"), true);
		$("#sp-results").attr("hidden", true);
	});

	$(".sp-cat").on("change", function () {
		loadStores();
		if (!$("#sp-results").is("[hidden]")) {
			search();
		}
	});

	// 장소를 고르지 않고 제출하면 막기 (서버에서도 한 번 더 검사함)
	$("#storeId").closest("form").on("submit", function (e) {
		if (!(Number($("#storeId").val()) > 0)) {
			alert("모임 장소를 지도나 검색에서 선택해 주세요.");
			e.preventDefault();
		}
	});

	// 수정 화면이나 입력 오류로 돌아온 경우: 이미 고른 가게로 지도 이동
	var initialId = Number($("#storeId").val());
	if (initialId > 0) {
		$.ajax({ url : "/map/ajax/storeOne", type : "get", data : { storeId : initialId } })
			.done(function (s) { selectStore(s, true); });
	} else {
		loadStores();
	}
})();
	</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>