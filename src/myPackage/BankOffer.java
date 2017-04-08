package myPackage;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class BankOffer extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public BankOffer() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();

		double totalAmount = 0, maxAmount = 0, bankOffer = 0;

		GameBean gameBean = (GameBean) session.getAttribute("gameBean");

		if(gameBean != null) {
			Briefcase[] briefcaseList = gameBean.getBriefcaseList();

			int i = 0;
			for(Briefcase briefcase : briefcaseList) {
				if (!briefcase.isRevealed()) {
					// We sum the amounts of all the remaining cases 
					totalAmount += briefcase.getAmount();
					i++;
					
					// And we search for the highest amount in the remaining cases
					if(briefcase.getAmount() > maxAmount) {
						maxAmount = briefcase.getAmount();
					}
				}
			}
			
			bankOffer = Math.round((totalAmount/i) * 100.0) / 100.0;
			
			session.setAttribute("bankOffer", bankOffer);
			session.setAttribute("maxAmount", maxAmount);

			response.sendRedirect("jsp/BankOffer.jsp");
			
		} else {
			session.setAttribute("gameError", "An error occured, please try again.");
			response.sendRedirect(request.getContextPath());
		}
	}
}
