<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵</title>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a"></script>
</head>
	<Style>
	#map {
	width: 1200px;
	height : 800px;
	}
	</Style>
<body>

	<div id = "map">dassa </div>
	
	<script>
		var container = document.getElementById("map");
		var options = {
				center : new kakao.maps.LatLng(37.5665,126.9780),
				level: 5		
		};
		var map = new kakao.maps.Map(container, options);
	</script>
</body>
</html>