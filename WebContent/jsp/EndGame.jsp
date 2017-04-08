<%@page import="myPackage.GameBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	GameBean gameBean = (GameBean) session.getAttribute("gameBean");

	if ((session.getAttribute("gameBean") == null) || (!gameBean.isGameEnded())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	double cashPrize = gameBean.getCashPrize();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Game Ended | Deal or No Deal</title>
<meta name="description" content="Deal or No Deal game home page.">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/png">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">

<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

</head>
<body>
	<div class="container">
		<header>
		<div class="row">
			<div class="col-sm-9">
				<h1>Deal or No Deal</h1>
				<h2>End Game</h2>
			</div>
			<div class="col-sm-3">
				<a href="<%=request.getContextPath()%>"
					class="btn btn-default btn-lg pull-right" style="margin-top: 30px">Home
					Page</a>
			</div>
		</div>
		</header>

		<p class="separator-top"></p>

		<div class="row">
			<div class="col-sm-6">
				<h3>Information</h3>
				<p>The game is finished.</p>
				<p>
					Click on the <em>Home Page</em> button to head back to the home
					page and start a new game.
				</p>
			</div>
			<div class="col-sm-6">
				<h3>
					<i class="fa fa-money"></i> Your prize
				</h3>
				<p class="cash-prize">
					$
					<%=cashPrize%></p>
				<%
					if (session.getAttribute("gameSuccess") != null) {
				%>
				<p class="important-text success"><%=(String) session.getAttribute("gameSuccess")%></p>
				<%
					session.removeAttribute("gameSuccess");
					}
				%>
			</div>
		</div>

		<p class="separator-bottom"></p>

	</div>

	<footer>
	<p>
		<small>Deal or No Deal &copy; Arthur FAUQUENOT 2016</small>
	</p>
	</footer>
</body>
</html>