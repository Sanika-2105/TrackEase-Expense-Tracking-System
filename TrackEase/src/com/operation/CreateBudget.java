package com.operation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import com.TrackEase.Db.*;
/**
 * Servlet implementation class CreateBudget
 */
@WebServlet("/CreateBudget")
public class CreateBudget extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateBudget() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		Connection con=TrackEaseConnection.connect();
		int budget_id=0;
		int category_id=0;
		String budgetName=request.getParameter("budgetname");
		
		//startdate
		String sdate=request.getParameter("startDate");
		LocalDate startDate=LocalDate.parse(sdate);
		java.sql.Date sqlStartDate=java.sql.Date.valueOf(startDate);
		
		//enddate
		String edate=request.getParameter("endDate");
		LocalDate endDate=LocalDate.parse(edate);
		java.sql.Date sqlEndDate=java.sql.Date.valueOf(endDate);
		
		//monthly income
		String income = request.getParameter("income");
		int monthlyIncome = Integer.parseInt(income);
		System.out.println(budgetName+" "+sqlStartDate+" "+sqlEndDate+" "+monthlyIncome);
		
		int food_val=Integer.parseInt(request.getParameter("food_percentage"));
		int transportation_val=Integer.parseInt(request.getParameter("transportation_percentage"));
		int shopping_val=Integer.parseInt(request.getParameter("shopping_percentage"));
		int bills_val=Integer.parseInt(request.getParameter("bills_percentage"));
		int entertainment_val=Integer.parseInt(request.getParameter("entertainment_percentage"));
		int education_val=Integer.parseInt(request.getParameter("education_percentage"));
		int other_val=Integer.parseInt(request.getParameter("other_percentage"));
		System.out.println(food_val+" "+transportation_val+" "+" "+shopping_val+" "+bills_val+" "+entertainment_val+" "+ education_val+" "+other_val);
		
		// Calculate allocated amounts
        int foodAlloc = (monthlyIncome * food_val) / 100;
        int transportAlloc = (monthlyIncome *transportation_val) / 100;
        int shoppingAlloc = (monthlyIncome * shopping_val) / 100;
        int billsAlloc = (monthlyIncome * bills_val) / 100;
        int entertainmentAlloc = (monthlyIncome * entertainment_val) / 100;
        int educationAlloc = (monthlyIncome *education_val) / 100;
        int otherAlloc = (monthlyIncome * other_val) / 100;
        System.out.println(foodAlloc+" "+transportAlloc+" "+shoppingAlloc+" "+billsAlloc+" "+entertainmentAlloc+" "+educationAlloc+" "+otherAlloc);
		
		
		try{
			PreparedStatement stmt=con.prepareStatement("insert into budget values(?,?,?,?,?,?,?,?,?,?,?,?)");
			stmt.setInt(1, budget_id);
			stmt.setString(2,budgetName);
			stmt.setInt(3,monthlyIncome);
			stmt.setDate(4,sqlStartDate);
			stmt.setDate(5,sqlEndDate);
			stmt.setInt(6, food_val);
			stmt.setInt(7, transportation_val);
			stmt.setInt(8, shopping_val);
			stmt.setInt(9, bills_val);
			stmt.setInt(10, entertainment_val);
			stmt.setInt(11, education_val);
			stmt.setInt(12, other_val);

			
			
			int i=stmt.executeUpdate();
			if(i>0)
			{
				System.out.println("Successfully added");
				response.sendRedirect("success.html");
			}
			
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
