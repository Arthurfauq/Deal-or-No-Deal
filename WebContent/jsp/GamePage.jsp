<%@page import="myPackage.GameBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="myPackage.Briefcase"%>
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
	}

	Briefcase[] briefcaseList = gameBean.getBriefcaseList();
	int roundNb = gameBean.getRoundNb();
	int casesToOpen = gameBean.getCasesToOpen();

	String buttonType = (casesToOpen > 0) ? "submit" : "button";

	String pageTitle = "Round " + Integer.toString(roundNb);
	String submitButtonText = "Continue";
	String submitButtonColor = "btn-primary";

	if (roundNb == 5) {
		pageTitle += " - Last Round";

		if (casesToOpen == 0) {
			session.setAttribute("casesMessage", "Click on the Finish button to see cash prize.");

			submitButtonText = "Finish";
			submitButtonColor = "btn-success";
		}
	}
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

<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
<script
	src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

</head>
<body>
	<div class="container">
		<header>
		<div class="row">
			<div class="col-sm-9">
				<h1>Deal or No Deal</h1>
				<h2><%=pageTitle%></h2>
			</div>
			<div class="col-sm-3">
				<a href="<%=request.getContextPath()%>"
					class="btn btn-default btn-lg pull-right" style="margin-top: 30px">Home
					Page</a>
			</div>
		</div>
		</header>

		<div class="row">
			<div class="col-sm-6">
				<h3>Instructions</h3>
				<p>For each round, the player is asked to open a specific number
					of briefcases: 4 for the first round, 3 for the second round, 2
					cases in the third round, 1 for round 4, and 1 for round 5.</p>
				<p>
					To open a briefcase, simply click on it and its monetary amount
					will be revealed. Once there is no more briefcases to be opened,
					click on the <em>Continue</em> button.
				</p>
				<%
					if (session.getAttribute("casesMessage") != null) {
				%>
				<p class="important-text">
					<strong><%=session.getAttribute("casesMessage")%></strong>
				</p>
				<%
					session.removeAttribute("casesMessage");

					} else {
				%>
				<p class="important-text">
					<strong>Briefcases left to open : <%=casesToOpen%></strong>
				</p>
				<%
					}
					if (session.getAttribute("gameSuccess") != null) {
				%>
				<p class="important-text success"><%=(String) session.getAttribute("gameSuccess")%></p>
				<%
					session.removeAttribute("gameSuccess");
					}
				%>
			</div>
			<div class="col-sm-6">
				<form action="<%=request.getContextPath() + "/"%>" method="post">
					<div class="form-group">
						<table>
							<tr>
								<%
									int i = 0;
									for (Briefcase briefcase : briefcaseList) {
										i++;
										if (briefcase.isRevealed()) {
								%>
								<td class="col-sm-3"><p class="amount">
										$
										<%
											if (briefcase.getAmount() != 0.5) {
														out.println(Math.round(briefcase.getAmount() * 100) / 100);
													} else {
														out.println(briefcase.getAmount());
													}
										%>
									</p></td>
								<%
									} else {
								%>
								<td class="col-sm-3"><input type="<%=buttonType%>"
									name="briefcaseSelect" value="<%=briefcase.getNumber()%>"
									id="<%=briefcase.getNumber()%>"><label
									for="<%=briefcase.getNumber()%>"></label></td>
								<%
									}
										if ((i % 4 == 0) && (i < briefcaseList.length)) {
								%>
							</tr>
							<tr>
								<%
									}
									}
								%>
							</tr>
						</table>
					</div>

					<div class="row">
						<div class="col-sm-5 col-sm-offset-1">
							<button class="btn btn-default btn-block" type="submit"
								name="game_selection" value="save_game">
								<i class="fa fa-floppy-o"></i> Save game
							</button>
						</div>
						<div class="col-sm-5">
							<button class="btn <%=submitButtonColor%> btn-block"
								type="submit" name="next_round" value="">
								<i class="fa fa-forward"></i>
								<%=submitButtonText%>
							</button>
						</div>
					</div>
				</form>
				<%
					if (session.getAttribute("gameError") != null) {
				%>
				<p class="important-text error"><%=(String) session.getAttribute("gameError")%></p>
				<%
					session.removeAttribute("gameError");
					}
				%>

			</div>
		</div>
	</div>

	<footer>
	<p>
		<small>Deal or No Deal &copy; Arthur FAUQUENOT 2016</small>
	</p>
	</footer>
</body>
</html>