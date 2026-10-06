<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="ko_KR" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파티원 찾기</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 1090px;
	margin: 0 auto;
	min-height: 100vh; /*브라우저 화면 높이의 100%*/
}

#create-btn {
	height: 40px;
	width: 120px;
	background-color: black;
	border: 1px solid black;
	border-radius: 5px;
	color: white;
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	display: block;
	margin-left: auto;
	margin-top: 20px;
	margin-bottom: 20px;
	cursor: pointer;
	transition: background-color 0.2s;
}

#create-btn:hover {
	background-color: #333;
}

#party-list {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
}

#party-list a {
	color: inherit;
	text-decoration: none;
}

.card {
	position: relative;
	height: 300px;
	width: 350px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	cursor: pointer;
}

.bookmark-btn {
	position: absolute;
	top: 15px;
	right: 15px;
	width: 36px; height : 36px; border : none; background : white;
	border-radius : 50%; font-size : 24px; cursor : pointer;
	z-index: 10;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
	height: 36px;
	border: none;
	background: white;
	border-radius: 50%;
	font-size: 24px;
	cursor: pointer;
}

.card:hover {
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.image {
	height: 180px;
	background-color: #f4f4f4;
	border-radius: 8px;
	margin-bottom: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #999;
}

.store {
	font-size: 13px;
	color: #777;
	margin-bottom: 8px;
}

.title {
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 8px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.meet-date {
	font-size: 14px;
	color: #555;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container">
		<button type="button" id="create-btn"
			onclick="location.href='/party/create'">모임 만들기</button>
		<div id="party-list">
			<C:forEach var="party" items="${parties}">
				<div class="card"
					onclick="location.href='/party/detail?partyId=${party.partyId}'">

					<button type="button" class="bookmark-btn"
						data-party-id="${party.partyId}">
						<C:choose>

							<C:when test="${bookmarkedPartyIds.contains(party.partyId)}">
			★
		</C:when>

							<C:otherwise>
			☆
		</C:otherwise>

						</C:choose>
					</button>

					<div class="image">모임사진</div>

					<div class="store">${party.address}·${party.storeName}</div>

					<div class="title">${party.title}</div>

					<div class="meet-date">
						<fmt:formatDate value="${party.meetDate}"
							pattern="yyyy.MM.dd(E) HH:mm" />
					</div>

				</div>
			</C:forEach>
		</div>
	</div>

	<script>
	let loading = false;
	let offset = 9;
	window.addEventListener("scroll", function(){
	
		if ((window.innerHeight + window.scrollY >= document.documentElement.scrollHeight -100)&& !loading){
			loading = true;
			
			fetch("/party/more?offset=" + offset)
			.then(response => response.json())
			.then(parties => {
			for(const party of parties){
			const card = document.createElement("div");
			card.className = "card";
			
			const image = document.createElement("div");
			image.className = "image";
			image.textContent = "모임사진";
			card.appendChild(image);
			
			const store = document.createElement("div");
			store.className = "store";
			store.textContent = party.address + " · " + party.storeName;
			card.appendChild(store);
			
			const title = document.createElement("div");
			title.className = "title";
			title.textContent = party.title;
			card.appendChild(title);
			
			const meetDate = document.createElement("div");
			meetDate.className = "meet-date";
			meetDate.textContent = new Date(party.meetDate).toLocaleString("ko-KR");
			card.appendChild(meetDate);
			
			const link = document.createElement("a");
			link.href = "/party/detail?partyId=" + party.partyId;
			link.appendChild(card);
			document.getElementById("party-list").appendChild(link);
			}
			offset += parties.length;
			if(parties.length === 9) loading = false;
			});
		}
	});
	
	$(".bookmark-btn").on("click", function(e) {
		e.stopPropagation();

		let btn = $(this);
		let partyId = btn.data("party-id");

		$.ajax({
			url: "/party/bookmark",
			type: "POST",
			data: {
				partyId: partyId
			},

			success: function(result) {

				if (result === "LOGIN") {

					location.href = "/member/login";

				} else if (result === "INSERT") {

					btn.text("★");

				} else if (result === "DELETE") {

					btn.text("☆");
				}
			}
		});
	});
	</script>
</body>
</html>