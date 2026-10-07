<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a&libraries=services,clusterer"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>모임 만들기</title>
<style>
* {
   box-sizing: border-box;
}

form {
   max-width: 650px;
   margin: 40px auto;
   padding: 30px;
   border: 1px solid #ddd;
   border-radius: 10px;
}

form h1 {
   margin: 0 0 30px;
   font-size: 26px;
   text-align: center;
}

form label {
   display: block;
   margin-bottom: 8px;
   font-weight: bold;
}

form input, form select, form textarea {
   width: 100%;
   padding: 12px;
   margin-bottom: 20px;
   border: 1px solid #ccc;
   border-radius: 5px;
   font-size: 15px;
}

form textarea {
   min-height: 160px;
   resize: vertical;
}

#create-btn {
   width: 100%;
   padding: 14px;
   background-color: black;
   color: white;
   border: 1px solid black;
   border-radius: 5px;
   font-size: 16px;
   font-weight: bold;
   cursor: pointer;
}

p {
   white-space: pre-line;
}

.error-message {
   white-space: pre-line;
   color: #c62828;
   font-size: 14px;
   line-height: 1.6;
   margin: 15px 0 0;
}

#party-map {
   width: 100%;
   height: 300px;
   margin-bottom: 20px;
   border: 1px solid #ddd;
   border-radius: 5px;
}

.image-row {
   display: flex;
   align-items: center;
   gap: 8px;
   margin-bottom: 8px;
}

.image-row input[type="file"] {
   width: 700px;
   margin-bottom: 0;
}
.image-row input[type="file"]::file-selector-button {
   background: black;
   color: white;
   font-size : 12px;
   border: none;
   padding: 7px 7px;
   border-radius: 5px;
   cursor: pointer;
   margin-right: 8px;
}

#image-add-btn,
.image-delete-btn {
   width: auto;
   padding: 8px 12px;
   border: 1px solid #ccc;
   border-radius: 5px;
   background: white;
   cursor: pointer;
   white-space: nowrap;
}

#image-add-btn{
margin-bottom : 10px;
}

</style>
</head>
<body>
   <jsp:include page="/WEB-INF/views/common/header.jsp" />
   <form action="/party/createSubmit" method="post"
      enctype="multipart/form-data">
      <h1>모임 만들기</h1>
      <label for="title">모임 제목</label> <input type="text" id="title"
         name="title" value="${party.title}" maxlength="100" required>
      <label for="contents">모임 소개</label>
      <textarea id="contents" name="contents" maxlength="2000">${party.contents}</textarea>

<label>모임 이미지</label>

<div id="image-list">
   <div class="image-row">
      <input type="file"
         name="partyImage"
         accept="image/*">

      <button type="button" class="image-delete-btn">
         삭제
      </button>
   </div>
</div>

<button type="button" id="image-add-btn">
   + 이미지 추가
</button>

      <label for="meetDate">모임 날짜 및 시간</label> <input type="datetime-local"
         id="meetDate" name="meetDateText" value="${meetDateText}" required>

      <label for="joinType">모집 유형</label> <select id="joinType"
         name="joinType" required>
         <option value="">모집 유형을 선택하세요.</option>
         <option value="FCFS" ${party.joinType == 'FCFS' ? 'selected' : ''}>선착순</option>
         <option value="APPROVAL"
            ${party.joinType == 'APPROVAL' ? 'selected' : '' }>모임장 승인</option>
      </select> <label for="minPeople">최소 인원</label> <input type="number"
         id="minPeople" name="minPeople" min="2" value="${party.minPeople}"
         required> <label for="maxPeople">최대 인원</label> <input
         type="number" id="maxPeople" name="maxPeople" min="2"
         value="${party.maxPeople}" required> <label for="genderRule">참여성별</label>
      <select id="genderRule" name="genderRule">
         <option value="" ${party.genderRule == '' ? 'selected' : ''}>제한없음</option>
         <option value="male" ${party.genderRule == 'male' ? 'selected' : ''}>남자만</option>
         <option value="female"
            ${party.genderRule == 'female' ? 'selected' : '' }>여자만</option>
      </select> <label for="minAge">최소 나이</label> <input type="number" id="minAge"
         name="minAge" min="1" value="${party.minAge}"> <label
         for="maxAge">최대 나이</label> <input type="number" id="maxAge"
         name="maxAge" min="1" value="${party.maxAge}"> <label
         for="question">참여 신청 질문</label> <input type="text" id="question"
         name="question" maxlength="300" placeholder="(예) 사이비신가요?"
         value="${party.question}"> <label>모임 장소</label> <input
         type="hidden" id="storeId" name="storeId" value="${party.storeId}">

      <input type="text" id="storeName" placeholder="지도에서 장소를 선택하세요"
         readonly>


      <div id="party-map"></div>

      <button type="submit" id="create-btn">모임 만들기</button>
      <p class="error-message">${message}</p>
   </form>
   <script>
   var map = new kakao.maps.Map(
      document.getElementById("party-map"),
      {
         center: new kakao.maps.LatLng(37.4902, 126.9275),
         level: 4
      }
   );

   loadStores();

   function loadStores() {

      var bounds = map.getBounds();

      var sw = bounds.getSouthWest();
      var ne = bounds.getNorthEast();

      $.ajax({
         url: "/map/ajax/store",
         type: "get",
         traditional: true,

         data: {
            swLat: sw.getLat(),
            swLng: sw.getLng(),
            neLat: ne.getLat(),
            neLng: ne.getLng(),
            price: 0
         },

         success: function(stores) {

            for (const store of stores) {

               var marker = new kakao.maps.Marker({
                  map: map,
                  position: new kakao.maps.LatLng(
                     store.latitude,
                     store.longitude
                  )
               });

               kakao.maps.event.addListener(
                  marker,
                  "click",
                  function() {

                     $("#storeId").val(store.store_id);
                     $("#storeName").val(store.store_name);
                  }
               );
            }
         }
      });
   }
   $("#image-add-btn").on("click", function() {

      let row =
         "<div class='image-row'>" +
            "<input type='file' name='partyImage' accept='image/*'>" +
            "<button type='button' class='image-delete-btn'>삭제</button>" +
         "</div>";

      $("#image-list").append(row);
   });


   $(document).on("click", ".image-delete-btn", function() {

      let row = $(this).closest(".image-row");

      if ($(".image-row").length === 1) {
         row.find("input[type='file']").val("");
         return;
      }

      row.remove();
   });
</script>
</body>
</html>