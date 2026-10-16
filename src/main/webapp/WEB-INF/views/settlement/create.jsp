<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>모임비 정산</title>
<style>
* {
	box-sizing: border-box;
}

/* ===== 페이지 전체: 회색 배경 + 가운데 정렬 ===== */
.settlement-page {
	background-color: #F9FAFB;
	padding: 56px 20px 72px;
}

.container {
	max-width: 600px;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	gap: 20px;
}

/* ===== 제목 영역 ===== */
.page-head {
	text-align: center;
}

.back-link {
	font-size: 13px;
	color: #4B5563;
	text-decoration: none;
}

.back-link:hover {
	color: #111827;
}

.page-head h2 {
	margin: 6px 0;
	font-size: 28px;
	color: #111827;
}

.page-desc {
	margin: 0;
	font-size: 15px;
	color: #6B7280;
}

.message {
	margin: 0;
	padding: 12px 16px;
	border-radius: 8px;
	background-color: #FEF2F2;
	color: #B91C1C;
	text-align: center;
}

/* ===== 흰 카드 공통 ===== */
.card {
	background-color: white;
	border: 1px solid #E5E7EB;
	border-radius: 12px;
	padding: 20px 24px;
}

/* ===== 모임 정보 카드 ===== */
.party-info-top {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	gap: 12px;
	flex-wrap: wrap;
	margin-bottom: 12px;
}

.party-title {
	font-size: 17px;
	font-weight: bold;
	color: #111827;
}

.party-meta {
	font-size: 13px;
	color: #6B7280;
}

.member-chips {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.chip {
	font-size: 13px;
	padding: 4px 10px;
	border-radius: 999px;
	background-color: #F3F4F6;
	color: #374151;
}

.chip.host {
	background-color: #111827;
	color: white;
}

/* ===== 정산 카드 ===== */
.settlement-card {
	padding: 28px 24px;
	display: flex;
	flex-direction: column;
	gap: 24px;
}

.section-title {
	display: block;
	font-size: 14px;
	font-weight: bold;
	color: #111827;
	margin-bottom: 10px;
}

/* 정산 방식: 두 칸짜리 탭 */
.type-tabs {
	display: grid;
	grid-template-columns: 1fr 1fr;
	padding: 4px;
	background-color: #F3F4F6;
	border-radius: 10px;
}

.type-tab {
	position: relative;
	height: 64px;
	border-radius: 8px;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 2px;
	cursor: pointer;
	color: #4B5563;
}

/* 라디오 버튼은 숨기지만 키보드로는 선택 가능 */
.type-tab input {
	position: absolute;
	opacity: 0;
	width: 1px;
	height: 1px;
}

.type-tab .tab-name {
	font-size: 15px;
	font-weight: 500;
}

.type-tab .tab-desc {
	font-size: 12px;
	color: #6B7280;
}

.type-tab.active {
	background-color: white;
	box-shadow: 0 1px 3px rgba(17, 24, 39, 0.12);
	color: #111827;
}

.type-tab.active .tab-name {
	font-weight: bold;
}

.type-tab:focus-within {
	outline: 2px solid #111827;
	outline-offset: 2px;
}

/* 균등 정산: 큰 금액 입력칸 */
#equal-area {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 10px;
}

.amount-input-wrap {
	display: flex;
	align-items: baseline;
	gap: 8px;
	border-bottom: 2px solid #111827;
	padding: 0 8px 6px;
}

#totalAmount {
	width: 220px;
	border: none;
	outline: none;
	font-size: 36px;
	font-weight: bold;
	color: #111827;
	text-align: right;
	background: transparent;
}

.amount-unit {
	font-size: 20px;
	color: #111827;
}

.amount-hint {
	font-size: 13px;
	color: #6B7280;
}

/* 메뉴별 정산 */
#menu-area {
	display: none;
}

.menu-row {
	padding: 16px 0;
	border-bottom: 1px solid #F3F4F6;
}

.menu-inputs {
	display: flex;
	gap: 8px;
	align-items: center;
}

.menu-inputs input {
	height: 42px;
	padding: 0 12px;
	border: 1px solid #D1D5DB;
	border-radius: 8px;
	font-size: 15px;
}

.menu-name {
	flex: 1;
	min-width: 0;
}

.menu-amount {
	width: 130px;
	text-align: right;
}

.delete-menu-btn {
	height: 42px;
	padding: 0 12px;
	border: 1px solid #E5E7EB;
	border-radius: 8px;
	background-color: white;
	color: #6B7280;
	cursor: pointer;
}

.member-list {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
	align-items: center;
	margin-top: 12px;
}

.member-list-label {
	font-size: 12.5px;
	color: #6B7280;
	margin-right: 4px;
}

.member-chip {
	display: flex;
	align-items: center;
	gap: 6px;
	height: 34px;
	padding: 0 12px;
	border: 1px solid #D1D5DB;
	border-radius: 999px;
	font-size: 13.5px;
	cursor: pointer;
}

.member-chip input {
	margin: 0;
	accent-color: #111827;
}

.member-chip:has(input:checked) {
	border-color: #111827;
	background-color: #F3F4F6;
	font-weight: bold;
}

#add-menu-btn {
	width: 100%;
	height: 46px;
	margin-top: 16px;
	border: 1.5px dashed #D1D5DB;
	border-radius: 10px;
	background-color: white;
	font-size: 14px;
	color: #4B5563;
	cursor: pointer;
}

/* ===== 미리보기 ===== */
.preview {
	background-color: #F9FAFB;
	border-radius: 10px;
	padding: 18px 20px;
}

.preview-head {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	padding-bottom: 10px;
	margin-bottom: 6px;
	border-bottom: 1px solid #E5E7EB;
	font-size: 14px;
}

.preview-head strong {
	color: #111827;
}

#preview-summary strong {
	font-size: 18px;
}

.preview-row {
	display: flex;
	justify-content: space-between;
	font-size: 14px;
	line-height: 2;
}

.preview-row .amount {
	color: #111827;
	font-weight: 500;
}

.host-tag {
	font-size: 12px;
	color: #6B7280;
	margin-left: 4px;
}

.preview-empty {
	font-size: 13.5px;
	color: #6B7280;
	text-align: center;
	padding: 8px 0;
}

#preview-note {
	margin: 8px 0 0;
	font-size: 12.5px;
	color: #6B7280;
}

/* ===== 제출 버튼 ===== */
.submit-btn {
	width: 100%;
	height: 52px;
	border: none;
	border-radius: 10px;
	background-color: #111827;
	color: white;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

/* 금액 숫자 폭을 일정하게 */
#totalAmount, .menu-amount, .preview, #preview-summary {
	font-variant-numeric: tabular-nums;
}

/* 휴대폰처럼 좁은 화면 */
@media (max-width: 480px) {
	.menu-inputs {
		flex-wrap: wrap;
	}
	.menu-name {
		flex-basis: 100%;
	}
	#totalAmount {
		width: 160px;
		font-size: 30px;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="settlement-page">
		<div class="container">

			<!-- 제목 -->
			<div class="page-head">
				<a class="back-link" href="/party/detail?partyId=${party.partyId}">← 모임 상세로</a>
				<h2>모임비 정산</h2>
				<p class="page-desc">모임이 끝났다면 사용한 금액을 입력하고 멤버들에게 나눠 보내세요.</p>
			</div>

			<c:if test="${not empty message}">
				<p class="message">${message}</p>
			</c:if>

			<!-- 모임 정보 -->
			<div class="card">
				<div class="party-info-top">
					<span class="party-title">${party.title}</span>
					<span class="party-meta">
						<fmt:formatDate value="${party.meetDate}" pattern="yyyy.MM.dd HH:mm" />
						· ${party.storeName}
					</span>
				</div>
				<div class="member-chips">
					<c:forEach var="member" items="${members}">
						<c:choose>
							<c:when test="${member.memberId == party.hostId}">
								<span class="chip host">${member.memberName} · 모임장</span>
							</c:when>
							<c:otherwise>
								<span class="chip">${member.memberName}</span>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</div>
			</div>

			<!-- 정산 입력 -->
			<form class="card settlement-card" action="/settlement/createSubmit" method="post">
				<input type="hidden" name="partyId" value="${party.partyId}">

				<!-- 정산 방식 -->
				<div>
					<span class="section-title">정산 방식</span>
					<div class="type-tabs">
						<label class="type-tab active">
							<input type="radio" name="settlementType" value="EQUAL" checked>
							<span class="tab-name">균등 정산</span>
							<span class="tab-desc">모두 같은 금액</span>
						</label>
						<label class="type-tab">
							<input type="radio" name="settlementType" value="MENU">
							<span class="tab-name">메뉴별 정산</span>
							<span class="tab-desc">먹은 만큼</span>
						</label>
					</div>
				</div>

				<!-- 균등 정산 -->
				<div id="equal-area">
					<label class="section-title" for="totalAmount" style="margin-bottom: 0">총 사용 금액</label>
					<div class="amount-input-wrap">
						<input type="number" id="totalAmount" name="totalAmount" min="1"
							placeholder="0" required>
						<span class="amount-unit">원</span>
					</div>
					<span class="amount-hint" id="amount-hint"></span>
				</div>

				<!-- 메뉴별 정산 -->
				<div id="menu-area">
					<span class="section-title">메뉴</span>
					<div id="menu-list">
						<div class="menu-row">
							<div class="menu-inputs">
								<input maxlength="30" type="text" class="menu-name" placeholder="메뉴명">
								<input type="number" class="menu-amount" placeholder="금액" min="1">
								<button type="button" class="delete-menu-btn">삭제</button>
							</div>
							<div class="member-list">
								<span class="member-list-label">먹은 사람</span>
								<c:forEach var="member" items="${members}">
									<label class="member-chip">
										<input type="checkbox" class="member-checkbox" value="${member.memberId}">
										${member.memberName}
									</label>
								</c:forEach>
							</div>
						</div>
					</div>
					<button type="button" id="add-menu-btn">+ 메뉴 추가</button>
				</div>

				<!-- 미리보기 -->
				<div class="preview">
					<div class="preview-head">
						<strong>미리보기</strong>
						<span id="preview-summary"></span>
					</div>
					<div id="preview-rows"></div>
					<p id="preview-note"></p>
				</div>

				<div id="menu-result-inputs"></div>

				<button type="submit" class="submit-btn">정산하고 멤버에게 알리기</button>
			</form>
		</div>
	</div>

	<script>
		/* =========================================================
		   멤버 정보 (서버 데이터 → JS 목록)
		   ========================================================= */
		const hostId = "${party.hostId}";

		const members = [
			<c:forEach var="member" items="${members}" varStatus="status">
				{ id : "${member.memberId}", name : "${member.memberName}" }<c:if test="${!status.last}">,</c:if>
			</c:forEach>
		];

		function won(amount) {
			return amount.toLocaleString() + "원";
		}

		/* =========================================================
		   균등 정산 계산 (서버와 같은 규칙: 나머지는 모임장 부담)
		   ========================================================= */
		function calcEqual(total) {
			let amounts = {};
			let each = Math.floor(total / members.length);
			let remainder = total % members.length;

			for (let m of members) {
				amounts[m.id] = each + (m.id === hostId ? remainder : 0);
			}

			return { amounts : amounts, each : each, remainder : remainder };
		}

		/* =========================================================
		   메뉴별 정산 계산 (메뉴별 나머지는 첫 번째 선택 멤버 부담)
		   ========================================================= */
		function calcMenu() {
			let amounts = {};
			let total = 0;
			let valid = true;
			let message = "";

			$(".menu-row").each(function() {
				let menuAmount = Number($(this).find(".menu-amount").val());
				let checkedMembers = $(this).find(".member-checkbox:checked");

				if (!menuAmount || menuAmount <= 0) {
					valid = false;
					message = "메뉴 금액을 입력해주세요.";
					return false;
				}

				if (checkedMembers.length === 0) {
					valid = false;
					message = "정산 대상 멤버를 선택해주세요.";
					return false;
				}

				total += menuAmount;

				let each = Math.floor(menuAmount / checkedMembers.length);
				let remainder = menuAmount % checkedMembers.length;

				checkedMembers.each(function(index) {
					let memberId = $(this).val();

					if (amounts[memberId] == null) {
						amounts[memberId] = 0;
					}

					amounts[memberId] += each;

					if (index === 0) {
						amounts[memberId] += remainder;
					}
				});
			});

			return { amounts : amounts, total : total, valid : valid, message : message };
		}

		/* =========================================================
		   미리보기 그리기
		   ========================================================= */
		function showRows(amounts) {
			let html = "";

			for (let m of members) {
				let amount = amounts[m.id] || 0;
				let hostTag = m.id === hostId ? "<span class='host-tag'>모임장</span>" : "";

				html += "<div class='preview-row'>"
					+ "<span>" + m.name + hostTag + "</span>"
					+ "<span class='amount'>" + won(amount) + "</span>"
					+ "</div>";
			}

			$("#preview-rows").html(html);
		}

		function showEmpty(text) {
			$("#preview-summary").html("");
			$("#preview-rows").html("<div class='preview-empty'>" + text + "</div>");
			$("#preview-note").text("");
		}

		function renderPreview() {
			let type = $("input[name='settlementType']:checked").val();

			if (type === "EQUAL") {
				let total = Number($("#totalAmount").val());

				if (!total || total <= 0) {
					$("#amount-hint").text(members.length + "명이 나눠 내요");
					showEmpty("금액을 입력하면 1인당 금액이 보여요.");
					return;
				}

				let result = calcEqual(total);

				$("#amount-hint").text(won(total) + " ÷ " + members.length + "명");
				$("#preview-summary").html("1인당 <strong>" + won(result.each) + "</strong>");
				showRows(result.amounts);
				$("#preview-note").text(
					result.remainder > 0
						? "나누어떨어지지 않는 " + result.remainder + "원은 모임장이 부담해요."
						: ""
				);

			} else {
				let result = calcMenu();

				if (result.total === 0) {
					showEmpty("메뉴 금액과 먹은 사람을 고르면 사람별 금액이 보여요.");
					return;
				}

				$("#preview-summary").html("합계 <strong>" + won(result.total) + "</strong>");
				showRows(result.amounts);
				$("#preview-note").text(result.valid ? "" : result.message);
			}
		}

		/* =========================================================
		   정산 방식 탭 전환
		   ========================================================= */
		$("input[name='settlementType']").on("change", function() {
			let type = $(this).val();

			$(".type-tab").removeClass("active");
			$(this).closest(".type-tab").addClass("active");

			if (type === "EQUAL") {
				$("#equal-area").show();
				$("#menu-area").hide();
				$("#totalAmount").prop("required", true).prop("disabled", false);
				$("#menu-result-inputs").empty();
			} else {
				$("#equal-area").hide();
				$("#menu-area").show();
				$("#totalAmount").prop("required", false).prop("disabled", true);
			}

			renderPreview();
		});

		/* 금액·메뉴·체크가 바뀔 때마다 미리보기 새로 그리기 */
		$("#totalAmount").on("input", renderPreview);
		$(document).on("input change", ".menu-amount, .member-checkbox", renderPreview);

		/* =========================================================
		   메뉴 추가 / 삭제
		   ========================================================= */
		$("#add-menu-btn").on("click", function() {
			let newMenu = $(".menu-row").first().clone();
			newMenu.find(".menu-name").val("");
			newMenu.find(".menu-amount").val("");
			newMenu.find(".member-checkbox").prop("checked", false);
			$("#menu-list").append(newMenu);
			renderPreview();
		});

		$(document).on("click", ".delete-menu-btn", function() {
			if ($(".menu-row").length === 1) {
				alert("메뉴는 최소 1개 이상 있어야 합니다.");
				return;
			}
			$(this).closest(".menu-row").remove();
			renderPreview();
		});

		/* =========================================================
		   제출: 메뉴별 정산이면 사람별 금액을 숨은 칸에 담아 보냄
		   ========================================================= */
		$("form.settlement-card").on("submit", function(e) {
			let settlementType = $("input[name='settlementType']:checked").val();

			if (settlementType !== "MENU") {
				return;
			}

			let result = calcMenu();

			if (!result.valid) {
				alert(result.message);
				e.preventDefault();
				return;
			}

			$("#menu-result-inputs").empty();

			// 메뉴 전체 금액
			$("#menu-result-inputs").append($("<input>", {
				type : "hidden",
				name : "totalAmount",
				value : result.total
			}));

			// 사람별 최종 금액
			$.each(result.amounts, function(memberId, amount) {
				$("#menu-result-inputs").append($("<input>", {
					type : "hidden",
					name : "memberIds",
					value : memberId
				}));
				$("#menu-result-inputs").append($("<input>", {
					type : "hidden",
					name : "memberAmounts",
					value : amount
				}));
			});
		});

		renderPreview();
	</script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
