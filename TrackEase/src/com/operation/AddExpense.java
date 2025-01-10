package com.operation;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import com.TrackEase.Db.*;

/**
 * Servlet implementation class AddExpense
 */
@WebServlet("/AddExpense")
public class AddExpense extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddExpense() {
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

		
		
    	Connection con = null;
        try {
            con = TrackEaseConnection.connect();
            con.setAutoCommit(false); // Start transaction

            // Get expense details
            int exp_id = 0;
            int amount = Integer.parseInt(request.getParameter("amount"));
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String date = request.getParameter("date");
            LocalDate dateOfExpense = LocalDate.parse(date);
            java.sql.Date sqlDate = java.sql.Date.valueOf(dateOfExpense);

            // Check if this expense falls within any budget period
            String budgetQuery = "SELECT BudgetId, BudgetName FROM budget WHERE ? BETWEEN StartDate AND EndDate";
            PreparedStatement budgetStmt = con.prepareStatement(budgetQuery);
            budgetStmt.setDate(1, sqlDate);
            ResultSet budgetRs = budgetStmt.executeQuery();

            if (budgetRs.next()) {
                // Expense belongs to a budget period
                int budgetId = budgetRs.getInt("BudgetId");
                
                // Insert into expense table with budget reference
                PreparedStatement expenseStmt = con.prepareStatement(
                    "INSERT INTO expense (expense_id, date, amount, category, description, BudgetId) VALUES (?, ?, ?, ?, ?, ?)"
                );
                expenseStmt.setInt(1, exp_id);
                expenseStmt.setDate(2, sqlDate);
                expenseStmt.setInt(3, amount);
                expenseStmt.setString(4, category);
                expenseStmt.setString(5, description);
                expenseStmt.setInt(6, budgetId);
                
                int i = expenseStmt.executeUpdate();
                
                // Update budget spent amount
                String updateBudgetQuery = "";
                switch(category.toLowerCase()) {
                    case "food":
                        updateBudgetQuery = "UPDATE budget SET food_spent = food_spent + ? WHERE BudgetId = ?";
                        break;
                    case "transportation":
                        updateBudgetQuery = "UPDATE budget SET transportation_spent = transportation_spent + ? WHERE BudgetId = ?";
                        break;
                    case "shopping":
                        updateBudgetQuery = "UPDATE budget SET shopping_spent = shopping_spent + ? WHERE BudgetId = ?";
                        break;
                    case "bills":
                        updateBudgetQuery = "UPDATE budget SET bills_spent = bills_spent + ? WHERE BudgetId = ?";
                        break;
                    case "entertainment":
                        updateBudgetQuery = "UPDATE budget SET entertainment_spent = entertainment_spent + ? WHERE BudgetId = ?";
                        break;
                    case "education":
                        updateBudgetQuery = "UPDATE budget SET education_spent = education_spent + ? WHERE BudgetId = ?";
                        break;
                    case "other":
                        updateBudgetQuery = "UPDATE budget SET other_spent = other_spent + ? WHERE BudgetId = ?";
                        break;
                }
                
                if (!updateBudgetQuery.isEmpty()) {
                    PreparedStatement updateBudgetStmt = con.prepareStatement(updateBudgetQuery);
                    updateBudgetStmt.setInt(1, amount);
                    updateBudgetStmt.setInt(2, budgetId);
                    updateBudgetStmt.executeUpdate();
                }
                
                if (i > 0) {
                    con.commit();
                    System.out.println("Successfully added to budget: " + budgetRs.getString("BudgetName"));
                    response.sendRedirect("success.html");
                }
            } else {
                // No budget period found, add as normal expense
                PreparedStatement stmt = con.prepareStatement(
                    "INSERT INTO expense (expense_id, date, amount, category, description) VALUES (?, ?, ?, ?, ?)"
                );
                stmt.setInt(1, exp_id);
                stmt.setDate(2, sqlDate);
                stmt.setInt(3, amount);
                stmt.setString(4, category);
                stmt.setString(5, description);
                
                int i = stmt.executeUpdate();
                if (i > 0) {
                    con.commit();
                    System.out.println("Successfully added as normal expense");
                    response.sendRedirect("success.html");
                }
            }
        } catch (Exception e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("error.html");
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
		
	}

}
