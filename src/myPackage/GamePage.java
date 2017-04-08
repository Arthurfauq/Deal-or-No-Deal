package myPackage;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Map.Entry;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GamePage extends HttpServlet implements Serializable {
	private static final long serialVersionUID = 1L;

	public GamePage() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		RequestDispatcher dispatcher;

		if(session.getAttribute("gameBean") != null) {
			session.removeAttribute("gameBean");
		}

		dispatcher = getServletContext().getRequestDispatcher("/WEB-INF/HomePage.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		RequestDispatcher dispatcher;

		GameBean gameBean = null;
		String username = null;
		String game_selection = null;
		String deal_selection = null;
		String next_round = null;
		int briefcaseNb = -1;

		for(Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
			String paramName = entry.getKey();
			String[] paramValues = entry.getValue();

			switch (paramName) {
			case "username":
				username = paramValues[0];
				break;

			case "game_selection":
				game_selection = paramValues[0];
				break;

			case "briefcaseSelect":
				briefcaseNb = Integer.parseInt((String) paramValues[0]);
				break;

			case "next_round":
				next_round = paramName;
				break;

			case "deal_selection":
				deal_selection = paramValues[0];
				break;
			}
		}

		// If the request comes from the home page
		if(username != null && game_selection != null) {
			
			switch(game_selection) {
			case "new_game":
				gameBean = new GameBean();
				gameBean.setUsername(username);

				// If this user already had a saved game, we overwrite it with the empty game
				if(loadGame(request, username) != null) {
					saveGame(request, username, gameBean);
				}

				session.setAttribute("gameSuccess", "Game created successfully.");
				session.setAttribute("gameBean", gameBean);
				response.sendRedirect("jsp/GamePage.jsp");
				break;

			case "load_game":
				// If the game was loaded successfully
				if((gameBean = loadGame(request, username)) != null) {
					session.setAttribute("gameSuccess", "Game loaded successfully.");
					session.setAttribute("gameBean", gameBean);

					if(gameBean.isGameEnded()) {
						response.sendRedirect("jsp/EndGame.jsp");
					} else {
						response.sendRedirect("jsp/GamePage.jsp");
					}
				} else {
					session.setAttribute("gameError", "There is no saved game for this username.");
					session.setAttribute("username", username);
					response.sendRedirect(request.getContextPath());
				}
				break;

			}
		} else { // The request comes from the Game Page or the Bank Offer page
			gameBean = (GameBean) session.getAttribute("gameBean");

			if(gameBean != null) {
				Briefcase[] briefcaseList = gameBean.getBriefcaseList();
				int casesToOpen = gameBean.getCasesToOpen();
				int roundNb = gameBean.getRoundNb();
				username = gameBean.getUsername();
				double cashPrize;

				// If the user tries to save the current game
				if(game_selection != null && game_selection.equals("save_game")) {
					saveGame(request, username, gameBean);

					session.setAttribute("gameSuccess", "Game saved successfully.");
					response.sendRedirect(request.getContextPath());
				}

				// If the user clicks on a briefcase, the briefcase number is sent
				if (briefcaseNb != -1) {
					for(Briefcase briefcase : briefcaseList) {
						if(casesToOpen > 0) {
							// We search for the briefcase in the list
							// and we check if it is not revealed
							if((briefcase.getNumber() == briefcaseNb) && (briefcase.isRevealed() == false)) {
								briefcase.setRevealed(true);
								casesToOpen--;
								gameBean.setCasesToOpen(casesToOpen);
							}
						} else {
							session.setAttribute("casesMessage", "No more cases to open this round.");
						}
					}

					session.setAttribute("token", true);
					response.sendRedirect("jsp/GamePage.jsp");
				}

				// If the user clicks on the 'Continue' or 'Finish' button
				if (next_round != null) {

					// If the user clicked on the 'Continue' button   
					if(roundNb < 5) {
						// If the user has no more cases to open, we redirect him to the offer of the bank
						if(casesToOpen == 0) {
							dispatcher = getServletContext().getRequestDispatcher("/BankOffer");
							dispatcher.forward(request, response);
						} else {
							session.setAttribute("gameError", "You must still open " + casesToOpen + " briefcases.");
							response.sendRedirect("jsp/GamePage.jsp");
						}
					} else { // If the user clicked on the 'Finish' button   
						for(Briefcase briefcase : briefcaseList) {
							// We search for the remaining briefcase
							if(!briefcase.isRevealed()) {
								// We set the prize to the amount of the remaining case
								cashPrize = briefcase.getAmount();
								gameBean.setCashPrize(cashPrize);
							}
						}

						// The game is finished
						gameBean.setGameEnded(true);
						saveGame(request, username, gameBean);
						response.sendRedirect("jsp/EndGame.jsp");
					}
				}

				// If the user clicks on 'Deal' or 'No Deal' button
				if (deal_selection != null) {
					if(deal_selection.equals("deal")) {
						cashPrize = (double) session.getAttribute("bankOffer");
						gameBean.setCashPrize(cashPrize);
						gameBean.setGameEnded(true);

						saveGame(request, username, gameBean);
						session.setAttribute("gameSuccess", "Game saved successfully.");

						response.sendRedirect("jsp/EndGame.jsp");

					} else if (deal_selection.endsWith("no_deal")) {
						roundNb++;
						gameBean.setRoundNb(roundNb);

						response.sendRedirect("jsp/GamePage.jsp");
					}
				}
			} else {
				session.setAttribute("gameError", "An error occured, please try again.");
				response.sendRedirect(request.getContextPath());
			}
		}

	}

	private GameBean loadGame(HttpServletRequest request, String username) {
		username = username.toLowerCase();
		InputStream inputStream = getServletContext().getResourceAsStream("/WEB-INF/savedgames/" + username + ".ser");

		if(inputStream != null) {
			try {
				// We read the saved object
				ObjectInputStream objectInputStream = new ObjectInputStream(inputStream);
				GameBean savedGame = (GameBean) objectInputStream.readObject();
				
				objectInputStream.close();
				inputStream.close();

				// If the saved game was not ended, we clear the data from the file 
				if(!savedGame.isGameEnded()) {
					GameBean emptyGame = new GameBean();
					emptyGame.setUsername(username);
					saveGame(request,username,emptyGame);
				}

				return savedGame;

			} catch (IOException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}

		return null;
	}

	private void saveGame(HttpServletRequest request, String username, GameBean gameBean) {
		FileOutputStream outputStream;
		username = username.toLowerCase();

		try {
			// We get the file if it exists, if not we create it
			outputStream = new FileOutputStream(getServletContext().getRealPath("/WEB-INF/savedgames/" + username + ".ser"));

			if(outputStream != null) {
				// We write the object in the file
				ObjectOutputStream out = new ObjectOutputStream(outputStream);
				out.writeObject(gameBean);
				out.close();
			}

			outputStream.close();

		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}