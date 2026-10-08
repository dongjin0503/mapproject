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

container h2 {
margin-bottom : 25px;
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

		<div class="dashboard">

			<div class="chart-box">
				<h3>월별 모임 생성 수</h3>
				<canvas id="partyChart"></canvas>
			</div>

			<div class="chart-box">
				<h3>월별 모임 참여 수</h3>
				<canvas id="partyMemberChart"></canvas>
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
let partyLabels = [];
let partyCounts = [];

<c:forEach var="item" items="${monthlyPartyCount}">
partyLabels.push("${item.month}");
partyCounts.push(${item.count});
</c:forEach>

new Chart(document.getElementById("partyChart"),{
	type : "line",
	data : {
		labels : partyLabels,
		datasets : [{
			label : "모임 생성 수",
			data : partyCounts
		}]
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

let partyMemberLabels = [];
let partyMemberCounts = [];

<c:forEach var="item" items="${monthlyPartyMemberCount}">
partyMemberLabels.push("${item.month}");
partyMemberCounts.push(${item.count});
</c:forEach>

new Chart(document.getElementById("partyMemberChart"),{
	type : "line",
	data : {
		labels : partyMemberLabels,
		datasets : [{
			label : "모임 참여 수",
			data : partyMemberCounts
		}]
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
			data : genderCounts
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