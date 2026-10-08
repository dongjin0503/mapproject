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

		<input type="hidden"
			id="storeId"
			name="storeId"
			value="${party.storeId}">

		<input type="text"
			id="storeName"
			value="${party.storeName}"
			readonly>


		<div id="party-map"></div>


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

		var map = new kakao.maps.Map(
			document.getElementById("party-map"),
			{
				center : new kakao.maps.LatLng(
					37.4902,
					126.9275
				),
				level : 4
			}
		);

		loadStores();


		function loadStores() {

			var bounds = map.getBounds();

			var sw =
				bounds.getSouthWest();

			var ne =
				bounds.getNorthEast();


			$.ajax({

				url : "/map/ajax/store",

				type : "get",

				traditional : true,

				data : {

					swLat : sw.getLat(),
					swLng : sw.getLng(),

					neLat : ne.getLat(),
					neLng : ne.getLng(),

					price : 0
				},

				success : function(stores) {

					for (const store of stores) {

						var marker =
							new kakao.maps.Marker({

								map : map,

								position :
									new kakao.maps.LatLng(
										store.latitude,
										store.longitude
									)
							});


						kakao.maps.event.addListener(
							marker,
							"click",
							function() {

								$("#storeId")
									.val(store.store_id);

								$("#storeName")
									.val(store.store_name);
							}
						);

					}

				}

			});

		}

	</script>

</body>
</html>