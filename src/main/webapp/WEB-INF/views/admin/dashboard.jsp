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

.dashboard {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.chart-box {
	border: 1px solid #ddd;
	border-radius: 10px;
	padding: 25px;
	height: 320px;
	position: relative;
}

.chart-box h3 {
	margin: 0 0 20px;
	font-size: 18px;
}

.chart-box canvas {
	max-width: 100%;
	max-height: 230px;
}
</style>
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">

		<h2>관리자 대시보드</h2>

		<form action="/admin/dashboard" method="get"
			style="margin-bottom: 20px;">
			<input type="date" name="startDate" value="${startDate}"> ~ <input
				type="date" name="endDate" value="${endDate}">
			<button type="submit">조회</button>
		</form>

		<div class="dashboard">

			<div class="chart-box">
				<h3>파티 카테고리별 생성 / 참여 수</h3>
				<canvas id="partyCategoryChart"></canvas>
			</div>

			<div class="chart-box">
				<h3>챌린지 카테고리별 생성 / 참여 수</h3>
				<canvas id="challengeCategoryChart"></canvas>
			</div>
			<div class="chart-box">
				<h3>성별 회원 비율</h3>
				<canvas id="genderChart"></canvas>
			</div>

			<div class="chart-box">
				<h3>연령대별 회원 비율</h3>
				<canvas id="ageGroupChart"></canvas>
			</div>

		</div>

	</div>
	<script>
	let partyCategoryLabels = [];
	let partyCreateCounts = [];
	let partyJoinCounts = [];

	<c:forEach var="item" items="${partyCategoryStats}">
	partyCategoryLabels.push("${item.category}");
	partyCreateCounts.push(${item.createCount});
	partyJoinCounts.push(${item.joinCount});
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
					label : "참여 수",
					data : partyJoinCounts
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
	let challengeJoinCounts = [];

	<c:forEach var="item" items="${challengeCategoryStats}">
	challengeCategoryLabels.push("${item.category}");
	challengeCreateCounts.push(${item.createCount});
	challengeJoinCounts.push(${item.joinCount});
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
					label : "참여 수",
					data : challengeJoinCounts
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

	new Chart(document.getElementById("genderChart"),{
		type : "pie",
		data : {
			labels : genderLabels,
			datasets : [{
				data : genderCounts,
				backgroundColor : ["#4A90E2", "#FF8FA3"]
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