<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 상세</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
* {
   box-sizing: border-box;
}

.container {
   max-width: 1090px;
   margin: 0 auto;
   padding: 20px;
}

.detail-image-box {
	position: relative;
	width: 100%;
	aspect-ratio: 16 / 9;
	overflow: hidden;
	border-radius: 8px;
	margin-bottom: 20px;
}

.detail-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

#prev-image-btn, #next-image-btn {
   position: absolute;
   top: 50%;
   transform: translateY(-50%);
   width: 40px;
   height: 40px;
   border: none;
   border-radius: 50%;
   background: rgba(0, 0, 0, 0.5);
   color: white;
   font-size: 28px;
   cursor: pointer;
}

#prev-image-btn {
   left: 10px;
}

#next-image-btn {
   right: 10px;
}

.party-summary {
   position: relative;
   margin: -40px 30px 30px;
   padding: 25px;
   background-color: white;
   border-radius: 10px;
   box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
   display: flow-root;
}

.party-summary h1 {
   margin: 0 0 20px;
   font-size: 28px;
}

.party-summary p {
   margin: 0px;
   padding: 10px;
   width: 50%;
   float: left;
   font-size: 15px;
   color: #555;
}

.party-intro {
   padding: 25px 30px;
   border-bottom: 1px solid #ddd;
}

.party-intro h2 {
   margin: 0 0 15px;
   font-size: 22px;
}

.party-intro p {
   margin: 0;
   line-height: 1.7;
   white-space: pre-line;
}

.party-members {
   padding: 25px 30px;
   border-bottom: 1px solid #ddd;
}

.party-memvers h2 {
   margin: 0 0 15px;
   font-size: 22px;
}

.member {
   display: inline-block;
   padding: 10px 15px;
   margin: 0 8px 8px 0;
   background-color: #f2f2f2;
   border-radius: 20px;
   font-size: 14px;
}

.party-conditions {
   padding: 25px 30px;
}

.party-conditions h2 {
   margin: 0 0 15px;
   font-size: 22px;
}

.party-conditions p {
   margin: 0 0 10px;
   font-size: 15px;
   color: #555;
}

.party-buttons {
   display: flex;
   justify-content: center;
   align-items: center;
   gap: 20px;
   margin: 30px 0;
}

#manage-btn {
   width: 170px;
   height: 45px;
   padding: 12px 20px;
   margin: 0 20px;
   background-color: black;
   color: white;
   border: 1px solid black;
   border-radius: 5px;
   font-size: 15px;
   cursor: pointer;
   vertical-align: middle;
}

.apply-btn {
   width: 170px;
   height: 45px;
   padding: 12px 20px;
   margin: 0 20px;
   background-color: black;
   color: white;
   border: 1px solid black;
   border-radius: 5px;
   font-size: 15px;
   cursor: pointer;
   vertical-align: middle;
}

#list-btn {
   width: 170px;
   height: 45px;
   padding: 12px 20px;
   background-color: white;
   color: black;
   border: 1px solid #ccc;
   border-radius: 5px;
   font-size: 15px;
   cursor: pointer;
   vertical-align: middle;
}

#edit-btn {
	width: 170px;
	height: 45px;
	padding: 12px 20px;
	background-color: white;
	color: black;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 15px;
	cursor: pointer;
}
</style>
</head>
<body>
   <jsp:include page="/WEB-INF/views/common/header.jsp" />
   <div class="container">
      <C:if test="${not empty partyImages}">

         <div class="detail-image-box">

            <C:forEach var="image" items="${partyImages}" varStatus="status">

               <img class="detail-image" src="/uploads/${image}"
                  style="${status.index == 0 ? '' : 'display:none;'}">

            </C:forEach>

            <C:if test="${partyImages.size() > 1}">
               <button type="button" id="prev-image-btn">‹</button>
               <button type="button" id="next-image-btn">›</button>
            </C:if>
         </div>

      </C:if>

      <section class="party-summary">
         <h1>${party.title}</h1>

         <C:if test="${not empty message}">
            <p>${message}</p>
         </C:if>
         <p>
            모임 날짜:
            <fmt:formatDate value="${party.meetDate}"
               pattern="yyyy.MM.dd(E) HH:mm" />
         </p>
         <p>모임장: ${hostName}</p>
         <p>모임 장소: ${party.storeName}</p>
         <p>위치: ${party.address}</p>
         <p>참여 방식: ${party.joinType == 'FCFS' ? '선착순' : '승인제'}</p>
         <p>참여 인원: ${memberCount}명 / ${party.maxPeople}명</p>
      </section>

      <section class="party-intro">
         <h2>모임 소개</h2>
         <p>${party.contents}</p>
      </section>

      <section class="party-members">
         <h2>참여 확정 멤버</h2>
         <C:forEach var="member" items="${members}">

            <div class="member">

               ${member.memberName}

               <C:if
                  test="${sessionScope.loginId == party.hostId 
         and member.memberId != party.hostId}">

                  <form action="/party/kick" method="post" style="display: inline;">

                     <input type="hidden" name="partyId" value="${party.partyId}">

                     <input type="hidden" name="memberId" value="${member.memberId}">

                     <button type="submit"
                        onclick="return confirm('이 멤버를 내보내시겠습니까?');">내보내기</button>

                  </form>

               </C:if>

            </div>

         </C:forEach>

         <C:if test="${empty members}">
            <p>아직 참여 확정 멤버가 없습니다.</p>
         </C:if>
      </section>

      <section class="party-conditions">
         <h2>참여 조건</h2>

         <C:if test="${not empty party.genderRule}">
            <p>참여 성별: ${party.genderRule == 'male' ? '남자만' :
          party.genderRule == 'female' ? '여자만' : '제한 없음'}
            </p>
         </C:if>
         <C:if test="${party.minAge != null}">
            <p>최소 나이: ${party.minAge}세</p>
         </C:if>
         <C:if test="${party.maxAge != null}">
            <p>최대 나이: ${party.maxAge}세</p>
         </C:if>
         <C:if test="${not empty party.question}">
            <p>참여 신청 질문: ${party.question}</p>
         </C:if>
      </section>
      <div class="party-buttons">
         <C:if
	test="${not empty sessionScope.loginId 
	and sessionScope.loginId == party.hostId}">

	<button type="button"
		id="edit-btn"
		onclick="location.href='/party/edit?partyId=${party.partyId}'">
		모임 수정
	</button>

	<button type="button"
		id="manage-btn"
		onclick="location.href='/party/applications?partyId=${party.partyId}'">
		신청관리
	</button>

</C:if>

         <C:if test="${sessionScope.loginId != party.hostId}">

            <C:choose>

               <C:when test="${hasPending}">

                  <form action="/party/cancelApplication" method="post">

                     <input type="hidden" name="partyId" value="${party.partyId}">

                     <button type="submit" class="apply-btn"
                        onclick="return confirm('참여 신청을 취소하시겠습니까?');">신청 취소</button>

                  </form>

               </C:when>


               <C:when test="${isMember}">
                  <form action="/party/leave" method="post">
                     <input type="hidden" name="partyId" value="${party.partyId}">

                     <button type="submit" class="apply-btn"
                        onclick="return confirm('정말로 나가시겠습니까?');">모임 나가기</button>
                  </form>
               </C:when>


               <C:otherwise>

                  <button type="button" class="apply-btn"
                     onclick="location.href='/party/apply?partyId=${party.partyId}'">
                     신청하기</button>

               </C:otherwise>

            </C:choose>

         </C:if>
         <C:if test="${isMember}">
            <button type="button" id="chat-btn" onclick="location.href='/Chattingroom/chat?partyId=${party.partyId}'">
               채팅방 입장</button>
         </C:if>
         <button type="button" id="list-btn"
            onclick="location.href='/party/list'">목록으로 돌아가기</button>
      </div>
   </div>
   <script>
      let currentImage = 0;

      const detailImages = document.querySelectorAll(".detail-image");

      $("#next-image-btn").on("click", function() {

         if (detailImages.length <= 1) {
            return;
         }

         detailImages[currentImage].style.display = "none";

         currentImage++;

         if (currentImage >= detailImages.length) {
            currentImage = 0;
         }

         detailImages[currentImage].style.display = "block";
      });

      $("#prev-image-btn").on("click", function() {

         if (detailImages.length <= 1) {
            return;
         }

         detailImages[currentImage].style.display = "none";

         currentImage--;

         if (currentImage < 0) {
            currentImage = detailImages.length - 1;
         }

         detailImages[currentImage].style.display = "block";
      });
      
      
      
   </script>
</body>
</html>