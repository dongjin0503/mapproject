<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
       <%@taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core"%>
          <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 신청</title>
</head>
<body>
<h1>${party.title} 신청</h1>

<form action="/party/applySubmit" method="post">
<input type="hidden" name="partyId" value="${party.partyId}">

<C:if test="${not empty party.question}">
<p>${party.question}</p>
<textarea name="answer" rows="5" cols="50">${answer}</textarea>
</C:if>
<button type="submit">신청하기</button>
</form>
<p>${message}</p>
</body>
</html>