package myPackage;

import java.io.Serializable;

public class Briefcase implements Serializable {
	
	private static final long serialVersionUID = -87779422060665248L;
	private int number;
	private double amount;
	private boolean revealed = false;
	
	public Briefcase() {
		
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public boolean isRevealed() {
		return revealed;
	}

	public void setRevealed(boolean revealed) {
		this.revealed = revealed;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}
}
