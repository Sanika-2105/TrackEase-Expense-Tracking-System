package com.operation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import java.util.HashMap;
//import java.util.Map;
import com.TrackEase.Db.*;
import com.mysql.jdbc.Statement;

/**
 * Servlet implementation class ViewBudgetDetails
 */
@WebServlet("/ViewBudgetDetails")
public class ViewBudgetDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewBudgetDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"en\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>TrackEase-BudgetDetails</title>");
        
        // Include your CSS
        out.println("<style>");
        out.println("* { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("body { font-family: Arial, sans-serif; background-color: #f4f4f9; color: #333; display: flex; height: 100vh; }");
        out.println(".sidebar { width: 260px; background-color: #7A67BB; color: #fff; padding: 1rem; display: flex; flex-direction: column;box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1); }");
        out.println(".sidebar h2 { margin-top: 1.5rem; margin-bottom: 1.5rem; font-size: 1.8rem; text-align: center;color: #FFD700; font-weight: bold; }");
        out.println(".sidebar ul { list-style: none;padding: 0; }");
        out.println(".sidebar ul li { margin: 1.5rem 0; }");
        out.println(".sidebar ul li a { color: #fff; text-decoration: none; font-size: 1.2rem; display: block; padding: 0.8rem; border-radius: 6px; transition: background-color 0.3s ease,padding 0.3s ease; }");
        out.println(".sidebar ul li a:hover { background-color: #6B5DAA; padding-left: 1.2rem;}");
        out.println(".main-content { flex: 1; padding: 2rem; background-color: #f4f4f9; overflow-y: auto; }");
        out.println(".details-container { background-color: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); max-width: 1000px; margin: 0 auto; }");
        out.println(".details-title { text-align: center; color: #7A67BB; margin-bottom: 25px; font-size: 1.8rem; font-weight: bold; }");
        out.println(".budget-info { margin-bottom: 30px; border-bottom: 2px solid #7A67BB; padding-bottom: 20px; }");
        out.println(".info-item { margin: 10px 0; display: flex; align-items: center; }");
        out.println(".info-label { font-weight: bold; color: #7A67BB; width: 150px; margin-right: 10px; }");
        out.println(".info-value { color: #333; }");
        out.println(".table-container { overflow-x: auto; }");
        out.println(".budget-table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: white; }");
        out.println(".budget-table th { background-color: #7A67BB; color: white; padding: 12px; text-align: left; font-weight: bold; }");
        out.println(".budget-table td { padding: 12px; border-bottom: 1px solid #ddd; }");
        out.println(".budget-table tr:hover { background-color: #f8f8ff; }");
        out.println(".amount { text-align: center; }");
        out.println(".category-name { color: #7A67BB; font-weight: 500; text-align: left; }");
        out.println(".remaining-positive { color: #28a745; font-weight: bold; }");
        out.println(".remaining-negative { color: #dc3545; font-weight: bold; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        // Sidebar
        out.println("<aside class=\"sidebar\">");
        out.println("    <h2>TrackEase</h2>");
        out.println("    <ul>");
        out.println("        <li><a href=\"AddExpense.html\">Add Expense</a></li>");
        out.println("        <li><a href=\"ViewExpense.jsp\">Manage Expense</a></li>");
        out.println("        <li><a href=\"CreateBudget.html\">Add Custom Budget</a></li>");
        out.println("        <li><a href=\"ViewBudget.jsp\">View Budgets</a></li>");
        //out.println("        <li><a href=\"#\">Reports and Analytics</a></li>");
        out.println("    </ul>");
        out.println("</aside>");

        // Main content
        out.println("<main class=\"main-content\">");
        out.println("    <div class=\"details-container\">");
        out.println("        <h2 class=\"details-title\">Budget Details</h2>");

        try (Connection con = TrackEaseConnection.connect()) {
            //Statement stmt = (Statement) con.createStatement();
            int budgetId=Integer.parseInt(request.getParameter("budget_id"));
            
            PreparedStatement stmt = con.prepareStatement("SELECT * FROM budget where BudgetId=?");
            stmt.setInt(1, budgetId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
            	int budget_Id=rs.getInt("BudgetId");
                String budgetName = rs.getString("BudgetName");
                int monthlyIncome = rs.getInt("MonthlyIncome");
                String startDate = rs.getString("StartDate");
                String endDate = rs.getString("EndDate");
                System.out.println(budget_Id+" "+budgetName+" "+monthlyIncome+" "+startDate+" "+endDate);

                // Budget Info Section
                out.println("        <div class=\"budget-info\">");
                out.println("            <div class=\"info-item\">");
                out.println("                <span class=\"info-label\">Budget Name:</span>");
                out.println("                <span class=\"info-value\">" + budgetName + "</span>");
                out.println("            </div>");
                out.println("            <div class=\"info-item\">");
                out.println("                <span class=\"info-label\">Monthly Income:</span>");
                out.println("                <span class=\"info-value\">Rs." + monthlyIncome + "</span>");
                out.println("            </div>");
                out.println("            <div class=\"info-item\">");
                out.println("                <span class=\"info-label\">Start Date:</span>");
                out.println("                <span class=\"info-value\">" + startDate + "</span>");
                out.println("            </div>");
                out.println("            <div class=\"info-item\">");
                out.println("                <span class=\"info-label\">End Date:</span>");
                out.println("                <span class=\"info-value\">" + endDate + "</span>");
                out.println("            </div>");
                out.println("        </div>");

                // Calculate allocated amounts
                int foodAlloc = (monthlyIncome * rs.getInt("food_val")) / 100;
                int transportAlloc = (monthlyIncome * rs.getInt("transportation_val")) / 100;
                int shoppingAlloc = (monthlyIncome * rs.getInt("shopping_val")) / 100;
                int billsAlloc = (monthlyIncome * rs.getInt("bills_val")) / 100;
                int entertainmentAlloc = (monthlyIncome * rs.getInt("entertainment_val")) / 100;
                int educationAlloc = (monthlyIncome * rs.getInt("education_val")) / 100;
                int otherAlloc = (monthlyIncome * rs.getInt("other_val")) / 100;

                // Get expenses for each category
                Statement expStmt = (Statement) con.createStatement();
                String expQuery = "SELECT category, SUM(amount) as total FROM expense " +
                                "WHERE date >= '" + startDate + "' AND date <= '" + endDate + "' " +
                                "GROUP BY category";
                ResultSet expRs = expStmt.executeQuery(expQuery);

                // Initialize spent amounts
//                int foodSpent = 0, transportSpent = 0, shoppingSpent = 0;
//                int billsSpent = 0, entertainmentSpent = 0, educationSpent = 0, otherSpent = 0;
                int foodSpent = rs.getInt("food_spent");
                int transportSpent = rs.getInt("transportation_spent");
                int shoppingSpent = rs.getInt("shopping_spent");
                int billsSpent = rs.getInt("bills_spent");
                int entertainmentSpent = rs.getInt("entertainment_spent");
                int educationSpent = rs.getInt("education_spent");
                int otherSpent = rs.getInt("other_spent");

                // Store expenses
                while (expRs.next()) {
                    String category = expRs.getString("category");
                    int amount = expRs.getInt("total");
                    
                    switch(category) {
                        case "food": foodSpent = amount; break;
                        case "transportation": transportSpent = amount; break;
                        case "shopping": shoppingSpent = amount; break;
                        case "bills": billsSpent = amount; break;
                        case "entertainment": entertainmentSpent = amount; break;
                        case "education": educationSpent = amount; break;
                        case "other": otherSpent = amount; break;
                    }
                    
                }

                // Table Section
                out.println("        <div class=\"table-container\">");
                out.println("            <table class=\"budget-table\">");
                out.println("                <thead>");
                out.println("                    <tr>");
                out.println("                        <th>Category</th>");
                out.println("                        <th>Allocated Amount</th>");
                out.println("                        <th>Spent Amount</th>");
                out.println("                        <th>Remaining Amount</th>");
                out.println("                    </tr>");
                out.println("                </thead>");
                out.println("                <tbody>");

                // Display each category
                displayCategoryRow(out, "Food", foodAlloc, foodSpent);
                displayCategoryRow(out, "Transport", transportAlloc, transportSpent);
                displayCategoryRow(out, "Shopping", shoppingAlloc, shoppingSpent);
                displayCategoryRow(out, "Bills", billsAlloc, billsSpent);
                displayCategoryRow(out, "Entertainment", entertainmentAlloc, entertainmentSpent);
                displayCategoryRow(out, "Education", educationAlloc, educationSpent);
                displayCategoryRow(out, "Other", otherAlloc, otherSpent);

                out.println("                </tbody>");
                out.println("            </table>");
                out.println("        </div>");

                // Close the result set and statement for expenses
                expRs.close();
                expStmt.close();
            }

        } catch (Exception e) {
            out.println("<p class=\"error\">Error: " + e.getMessage() + "</p>");
        }

        out.println("    </div>");
        out.println("</main>");
        out.println("</body>");
        out.println("</html>");
    }

    private void displayCategoryRow(PrintWriter out, String category, int allocated, int spent) {
        int remaining = allocated - spent;
        String remainingClass = remaining >= 0 ? "remaining-positive" : "remaining-negative";
        
        out.println("                    <tr>");
        out.println("                        <td class=\"category-name\">" + category + "</td>");
        out.println("                        <td class=\"amount\">Rs." + allocated + "</td>");
        out.println("                        <td class=\"amount\">Rs." + spent + "</td>");
        out.println("                        <td class=\"amount " + remainingClass + "\">Rs." + remaining + "</td>");
        out.println("                    </tr>");
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
