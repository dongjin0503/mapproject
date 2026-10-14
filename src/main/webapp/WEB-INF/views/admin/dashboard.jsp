<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<title>관리자 대시보드</title>

<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 1100px;
	margin: 30px auto;
	padding: 0 20px;
}

.container h2 {
	margin-bottom: 25px;
}

.date-filter {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 18px 20px;
	margin-bottom: 25px;
	border: 1px solid #ddd;
	border-radius: 10px;
	background-color: #fafafa;
}

.date-group {
	display: flex;
	align-items: center;
	gap: 10px;
}

.date-group label {
	font-size: 14px;
	font-weight: bold;
	color: #333;
}

.date-group input {
	height: 38px;
	padding: 0 10px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
}

.date-filter button {
	height: 38px;
	padding: 0 20px;
	border: none;
	border-radius: 6px;
	background-color: #222;
	color: white;
	font-size: 14px;
	font-weight: bold;
	cursor: pointer;
}

.date-filter button:hover {
	background-color: #444;
}

.dashboard {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.chart-box {
	border: 1px solid #e5e5e5;
	border-radius: 12px;
	padding: 25px;
	min-height: 360px;
	background-color: white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.chart-box h3 {
	margin: 0 0 20px;
	font-size: 17px;
	color: #222;
}

.chart-box canvas {
	max-width: 100%;
	max-height: 230px;
}

.chart-desc {
	margin: -10px 0 15px;
	font-size: 12px;
	color: #888;
}

.success-rate {
	margin-top: 12px;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.success-rate span {
	padding: 6px 10px;
	border-radius: 20px;
	background-color: #f3f4f6;
	font-size: 12px;
	color: #444;
}
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h2>관리자 대시보드</h2>

		<form action="/admin/dashboard" method="get" class="date-filter">
			<div class="date-group">
				<label>조회기간</label> <input type="date" name="startDate"
					value="${startDate}"> <span>~</span> <input type="date"
					name="endDate" value="${endDate}">
			</div>

			<button type="submit">조회</button>
		</form>
		<div class="dashboard">

			<div class="chart-box">
				<h3>파티 카테고리별 생성 / 실제 진행 수</h3>
				<p class="chart-desc">조회기간 내 생성된 모임 중 실제 진행된 모임을 비교합니다.</p>
				<canvas id="partyCategoryChart"></canvas>

				<div class="success-rate">
					<c:forEach var="item" items="${partyCategoryStats}">
						<span> ${item.category} 성사율 : <fmt:formatNumber
								value="${item.successRate}" maxFractionDigits="1" />%
						</span>
					</c:forEach>
				</div>
			</div>

			<div class="chart-box">
				<h3>챌린지 카테고리별 생성 / 그룹 챌린지 수</h3>
				<p class="chart-desc">조회 기간 내 생성된 챌린지 대비 그룹 챌린지(2명 이상 참여) 수를 비교합니다</p>
				<canvas id="challengeCategoryChart"></canvas>
				<div class="success-rate">
					<c:forEach var="item" items="${challengeCategoryStats}">
						<span> ${item.category} 그룹 챌린지 비율 : <fmt:formatNumber
								value="${item.successRate}" maxFractionDigits="1" />%
						</span>
					</c:forEach>
				</div>
			</div>

			<div class="chart-box">
				<h3>성별 회원 비율</h3>
				<p class="chart-desc">조회기간 내 가입한 회원의 성별 분포를 보여줍니다.</p>
				<canvas id="genderChart"></canvas>
			</div>

			<div class="chart-box">
				<h3>연령대별 회원 비율</h3>
				<p class="chart-desc">조회기간 내 가입한 회원의 연령대별 분포를 보여줍니다.</p>
				<canvas id="ageGroupChart"></canvas>
			</div>

		</div>

	</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<script>
	let partyCategoryLabels = [];
	let partyCreateCounts = [];
	let partyProgressCounts = [];

	<c:forEach var="item" items="${partyCategoryStats}">
	partyCategoryLabels.push("${item.category}");
	partyCreateCounts.push(${item.createCount});
	partyProgressCounts.push(${item.progressCount});
	</c:forEach>

	new Chart(document.getElementById("partyCategoryChart"), {
		type : "bar",
		data : {
			labels : partyCategoryLabels,
			datasets : [
				{
					label : "생성 수",
					data : partyCreateCounts
				},
				{
					label : "실제 진행 수",
					data : partyProgressCounts
				}
			]
		},
		options : {
			scales : {
				y : {
					beginAtZero : true,
					ticks : {
						precision : 0
					}
				}
			}
		}
	});


	let challengeCategoryLabels = [];
	let challengeCreateCounts = [];
	let challengeProgressCounts = [];

	<c:forEach var="item" items="${challengeCategoryStats}">
	challengeCategoryLabels.push("${item.category}");
	challengeCreateCounts.push(${item.createCount});
	challengeProgressCounts.push(${item.progressCount});
	</c:forEach>

	new Chart(document.getElementById("challengeCategoryChart"), {
		type : "bar",
		data : {
			labels : challengeCategoryLabels,
			datasets : [
				{
					label : "생성 수",
					data : challengeCreateCounts
				},
				{
					label : "그룹 챌린지 수",
					data : challengeProgressCounts
				}
			]
		},
		options : {
			scales : {
				y : {
					beginAtZero : true,
					ticks : {
						precision : 0
					}
				}
			}
		}
	});

	let genderLabels = [];
	let genderCounts = [];

	<c:forEach var="item" items="${genderCount}">
	genderLabels.push("${item.gender}");
	genderCounts.push(${item.count});
	</c:forEach>
	let genderColors = genderLabels.map(function(gender) {

		if (gender === "남성") {
			return "#4A90E2";
		}

		return "#FF8FA3";
	});
	new Chart(document.getElementById("genderChart"),{
		type : "pie",
		data : {
			labels : genderLabels,
			datasets : [{
				data : genderCounts,
				backgroundColor : genderColors
			}]
		}
	});
	
	
let ageGroupLabels = [];
let ageGroupCounts = [];

<c:forEach var="item" items="${ageGroupCount}">
ageGroupLabels.push("${item.ageGroup}");
ageGroupCounts.push(${item.count});
</c:forEach>

new Chart(document.getElementById("ageGroupChart"),{
	type : "pie",
	data : {
		labels : ageGroupLabels,
		datasets : [{
			data : ageGroupCounts
		}]
	}
});



</script>
</body>
</html>