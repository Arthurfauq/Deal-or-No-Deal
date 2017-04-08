<%@page import="myPackage.GameBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	GameBean gameBean = (GameBean) request.getSession().getAttribute("gameBean");

	if (session.getAttribute("gameBean") == null) {
		response.sendRedirect(request.getContextPath());
		return;
	} else if (gameBean.isGameEnded()) {
		response.sendRedirect("jsp/EndGame.jsp");
		return;
	} else if (gameBean.getCasesToOpen() > 0) {
		response.sendRedirect("jsp/GamePage.jsp");
		return;
	}

	int roundNb = gameBean.getRoundNb();

	double bankOffer = (double) session.getAttribute("bankOffer");
	double maxAmount = (double) session.getAttribute("maxAmount");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Round <%=roundNb%> | Deal or No Deal
</title>
<meta name="description" content="Deal or No Deal game home page.">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/png">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
	<div class="container">
		<header>
		<div class="row">
			<div class="col-sm-9">
				<h1>Deal or No Deal</h1>
				<h2>
					Round
					<%=roundNb%>
					- Bank Offer
				</h2>
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
				<h3>Instructions</h3>
				<p>On the right is displayed the amount that the bank offers
					together with the largest amount unrevealed at this point.</p>
				<p>
					By clicking on <em>'Deal'</em>, the player accepts the offer and
					quits the game at this point.
				</p>
				<p>
					By clicking on <em>'No Deal'</em>, the player refuses the offer and
					moves to the next round.
				</p>
			</div>
			<div class="col-sm-6">
				<h3>Make your choice</h3>
				<h4>
					Bank offer<span class="pull-right">$ <%=bankOffer%>
					</span>
				</h4>

				<h4>
					Largest amount unrevealed<span class="pull-right">$ <%=Math.round(maxAmount * 100) / 100%>
					</span>
				</h4>

				<form action="<%=request.getContextPath() + "/"%>" method="post">
					<div class="row">
						<div class="col-sm-6">
							<button class="btn btn-default btn-block" type="submit"
								name="deal_selection" value="deal">
								<i class="fa fa-suitcase"></i> Deal
							</button>
						</div>
						<div class="col-sm-6">
							<button class="btn btn-primary btn-block" type="submit"
								name="deal_selection" value="no_deal">
								<i class="fa fa-forward"></i> No Deal
							</button>
						</div>
					</div>
				</form>
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