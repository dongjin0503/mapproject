<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
html {
	min-height: 100%;
}

body {
	position: relative;
	min-height: 100vh;
	margin: 0;
	padding-bottom: 145px; /* footer가 본문을 가리지 않도록 공간 확보 */
	box-sizing: border-box;
}

.site-footer {
	position: absolute;
	left: 0;
	bottom: 0;
	width: 100%;
	padding: 25px 40px 15px;
	border-top: 1px solid #ddd;
	background-color: #fafafa;
	color: #777;
	font-size: 12px;
	box-sizing: border-box;
}

.footer-inner {
	max-width: 1100px;
	margin: 0 auto;
}

.footer-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding-bottom: 20px;
	border-bottom: 1px solid #ddd;
}

.footer-brand {
	display: flex;
	align-items: center;
	gap: 12px;
}

.footer-brand img {
	width: 55px;
}

.footer-title {
	font-size: 14px;
	font-weight: bold;
	color: #333;
}

.footer-menu {
	display: flex;
	align-items: center;
	gap: 20px;
}

.footer-menu a {
	color: #777;
	text-decoration: none;
}

.footer-menu a:hover {
	color: #333;
}

.footer-sns {
	display: flex;
	align-items: center;
	gap: 14px;
}

.footer-sns a {
	color: #777;
	font-size: 18px;
	text-decoration: none;
}

.footer-sns a:hover {
	color: #333;
}

.footer-bottom {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding-top: 15px;
}
</style>

<footer class="site-footer">

	<div class="footer-inner">

		<div class="footer-top">

			<div class="footer-brand">

				<img src="/images/logo.png" alt="짠내맵">

				<div>
					<div class="footer-title">짠내맵</div>
					<div>착한가격업소 기반 절약 생활 커뮤니티</div>
				</div>

			</div>

			<div class="footer-menu">

				<a href="#">서비스 소개</a>
				<a href="#">이용안내</a>
				<a href="#">문의하기</a>
				<a href="#">개인정보처리방침</a>

			</div>

			<div class="footer-sns">

				<a href="#" title="YouTube">
					<i class="fa-brands fa-youtube"></i>
				</a>

				<a href="#" title="Instagram">
					<i class="fa-brands fa-instagram"></i>
				</a>

				<a href="#" title="Community">
					<i class="fa-solid fa-comment-dots"></i>
				</a>

			</div>

		</div>

		<div class="footer-bottom">

			<span>© 2026 짠내맵. All rights reserved.</span>

			<span>오늘도 알뜰한 하루, 짠내맵과 함께해요.</span>

		</div>

	</div>

</footer>