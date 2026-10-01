<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>짠내맵</title>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=300c61e334f2ebb5afb0f5b4937b967a"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

	<Style>
	#map {
	width: 1200px;
	height : 800px;
	}
	</Style>
	
	</head>
<body>

	<div id = "map"> </div>
	
	<script>
		var container = document.getElementById("map");
		var options = {
				center : new kakao.maps.LatLng(37.5665,126.9780),
				level: 5		
		};
		var map = new kakao.maps.Map(container, options);
		kakao.maps.event.addListener(map, "idle", loadStores);
		
		var markers = [];
		
		function loadStores(){
			var b = map.getBounds();
			var sw = b.getSouthWest();
			var ne = b.getNorthEast();
		
			$.ajax({
				url : "/map/ajax/store",
				data : {swLat : sw.getLat() , swLng : sw.getLng(),  
						neLat : ne.getLat() , neLng : ne.getLng()},
				dataType : "json"
			}).done(function(rest){
			console.log("가게 수: " , rest.length);
			for (var i =0 ; i < markers.length ; i++) {
				markers[i].setMap(null);
			}
			markers = []
			
			for (var j = 0 ; j < rest.length ; j++) {
				var s = rest[j];
				
				var marker = new kakao.maps.Marker({
					map : map,
					position : new kakao.maps.LatLng(s.latitude, s.longitude),
					title : s.store_name
				})
				markers.push(marker);
			}	
			});
		}
		
		
		
	</script>
</body>
</html>