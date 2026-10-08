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

.party-top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 20px 0;
}

.filter-buttons {
	display: flex;
	gap: 10px;
}

.filter-buttons button {
	padding: 8px 18px;
	border: 1px solid #ccc;
	border-radius: 16px;
	background-color: white;
	cursor: pointer;
}

.filter-buttons button:hover {
	background-color: #f3f3f3;
}

.filter-buttons button.active {
	background-color: black;
	color: white;
	border-color: black;
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
	margin : 0;
	display: block;
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
	overflow: visible;
}

#party-list a {
	color: inherit;
	text-decoration: none;
}

.card {
	position: relative;
	height: 360px;
	width: 350px;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 8px;
	cursor: pointer;
	transition: transform 0.25s ease, box-shadow 0.25s ease;
	background-color: white;
}

.card:hover {
	transform: scale(1.07);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
	z-index: 20;
}

.bookmark-btn {
	position: absolute;
	top: 15px;
	right: 15px;
	width: 36px;
	height: 36px;
	padding: 0;
	border: 1px solid #ddd;
	border-radius: 50%;
	background: white;
	color: #f59e0b;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 19px;
	cursor: pointer;
	z-index: 10;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.image {
	width: 100%;
	height: 250px;
	overflow: hidden;
	background-color: transparent;
	display: flex;
	align-items: center;
	justify-content: center;
}

.image img {
	max-width: 100%;
	max-height: 100%;
	object-fit: contain;
	display: block;
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
	<h2>모임 리스트</h2>
		<div class="party-top">
			<div class="filter-buttons">

				<button type="button" class="${empty status ? 'active' : ''}"
					onclick="location.href='/party/list'">전체</button>

				<button type="button"
					class="${status == 'recruiting' ? 'active' : ''}"
					onclick="location.href='/party/list?status=recruiting'">
					모집중</button>

				<button type="button" class="${status == 'ended' ? 'active' : ''}"
					onclick="location.href='/party/list?status=ended'">종료</button>
			</div>

			<button type="button" id="create-btn"
				onclick="location.href='/party/create'">모임 만들기</button>

		</div>

		<div id="party-list">
			<C:forEach var="party" items="${parties}">
				<div class="card"
					onclick="location.href='/party/detail?partyId=${party.partyId}'">

					<button type="button" class="bookmark-btn"
						data-party-id="${party.partyId}">

						<C:choose>
							<C:when test="${bookmarkedPartyIds.contains(party.partyId)}">
								<i class="fa-solid fa-star"></i>
							</C:when>

							<C:otherwise>
								<i class="fa-regular fa-star"></i>
							</C:otherwise>
						</C:choose>

					</button>

					<div class="image">
						<C:choose>
							<C:when test="${not empty party.imageSysName}">
								<img src="/uploads/${party.imageSysName}">
							</C:when>

							<C:otherwise>
        						 모임사진
      						</C:otherwise>
						</C:choose>
					</div>

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
   const bookmarkedIds = [<C:forEach var="b" items="${bookmarkedPartyIds}" varStatus="s">${b}<C:if test="${!s.last}">,</C:if></C:forEach>];
   let loading = false;
   let offset = 9;
   window.addEventListener("scroll", function(){
   
      if ((window.innerHeight + window.scrollY >= document.documentElement.scrollHeight -100)&& !loading){
         loading = true;
         
         
         const status = "${status}";
         fetch("/party/more?offset=" + offset + "&status=" + status)
         .then(response => response.json())
         .then(parties => {
         for(const party of parties){
         const card = document.createElement("div");
         card.className = "card";
         
         const bookmarkBtn = document.createElement("button");

         bookmarkBtn.type = "button";
         bookmarkBtn.className = "bookmark-btn";
         bookmarkBtn.dataset.partyId = party.partyId;
         bookmarkBtn.innerHTML = bookmarkedIds.includes(party.partyId)
         ? '<i class="fa-solid fa-star"></i>'
         : '<i class="fa-regular fa-star"></i>';

         card.appendChild(bookmarkBtn);
         
         const image = document.createElement("div");
         image.className = "image";

         if (party.imageSysName) {

            const img = document.createElement("img");
            img.src = "/uploads/" + party.imageSysName;

            image.appendChild(img);

         } else {

            image.textContent = "모임사진";
         }

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
         const date = new Date(party.meetDate);

         const days = ["일", "월", "화", "수", "목", "금", "토"];

         const year = date.getFullYear();
         const month = String(date.getMonth() + 1).padStart(2, "0");
         const day = String(date.getDate()).padStart(2, "0");
         const dayName = days[date.getDay()];
         const hour = String(date.getHours()).padStart(2, "0");
         const minute = String(date.getMinutes()).padStart(2, "0");

         meetDate.textContent =
         	year + "." + month + "." + day
         	+ "(" + dayName + ") "
         	+ hour + ":" + minute;
         card.appendChild(meetDate);
         
         card.onclick = function() {
        		location.href = "/party/detail?partyId=" + party.partyId;
        	};

        	document.getElementById("party-list").appendChild(card);
         }
         offset += parties.length;
         if(parties.length === 9) loading = false;
         });
      }
   });
   
   $(document).on("click", ".bookmark-btn", function(e) {
      e.stopPropagation();
      e.preventDefault();
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

            	   btn.html('<i class="fa-solid fa-star"></i>');

            	} else if (result === "DELETE") {

            	   btn.html('<i class="fa-regular fa-star"></i>');
            	}
         }
      });
   });
   </script>
</body>
</html>