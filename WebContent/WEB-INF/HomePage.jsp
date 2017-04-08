<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String username, value = "";

	if ((username = (String) session.getAttribute("username")) != null) {
		value = "value='" + username + "'";
		session.removeAttribute("username");
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home Page | Deal or No Deal</title>
<meta name="description" content="Deal or No Deal game home page.">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/png">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/bootstrap.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">

<script src="https://code.jquery.com/jquery-2.2.4.js"
	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.validate.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/assets/js/validate.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/assets/js/script.js" type="text/javascript"></script>

</head>
<body>
	<div class="container">
		<header>
		<h1>Deal or No Deal</h1>
		<h2>Home page</h2>
		</header>

		<p class="separator-top"></p>

		<div class="row">
			<div class="col-sm-7">
				<h3>Instructions</h3>
				<p>
					If you already played to the <em>Deal or No Deal</em> game and
					saved your game, you can load it by clicking the 'Load game'
					button. If you want to start a new game, just press the 'New game'
					button.
				</p>
				<p class="important-text">If you start a new game with a
					username that has a saved game, it will overwrite it. If you load a
					game, do not forget to save it otherwise it will be cleared.</p>
			</div>
			<div class="col-sm-5">
				<h3>Play</h3>
				<p>
					<small>Username must be at least 5 characters.</small>
				</p>

				<form action="<%=request.getContextPath() + "/"%>" method="post"
					name="gameForm">
					<div class="form-group">
						<input type="text" name="username" placeholder="Username"
							<%=value%> class="form-control" required autofocus>
					</div>
					<div class="form-group">
						<div class="row">
							<div class="col-sm-6">
								<button class="btn btn-primary btn-block" type="submit"
									name="game_selection" value="new_game">
									<i class="fa fa-plus"></i> New game
								</button>
							</div>
							<div class="col-sm-6">
								<button class="btn btn-success btn-block" type="submit"
									name="game_selection" value="load_game">
									<i class="fa fa-download"></i> Load game
								</button>
							</div>
						</div>
					</div>
				</form>
				<%
					if (session.getAttribute("gameError") != null) {
				%>
				<p class="important-text error"><%=(String) session.getAttribute("gameError")%></p>
				<%
					session.removeAttribute("gameError");
					} else if (session.getAttribute("gameSuccess") != null) {
				%>
				<p class="important-text success"><%=(String) session.getAttribute("gameSuccess")%></p>
				<%
					session.removeAttribute("gameSuccess");
					}

					session.invalidate();
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