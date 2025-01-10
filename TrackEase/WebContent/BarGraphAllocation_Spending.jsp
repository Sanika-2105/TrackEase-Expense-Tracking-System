<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.TrackEase.Db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TrackEase-Budget Allocation vs Spending(PieChart)</title>
 <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
 
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .chart-container {
            width: 100%;
            max-width: 800px;
            margin-top: 20px;
        }
    </style>

</head>
<body>
	
	<% 
        // Data for bar graph
        String[] categories = {"Food", "Transportation", "Shopping", "Bills", "Entertainment", "Education", "Other"};
        double[] allocations = new double[categories.length];
        double[] spendings = new double[categories.length];

        String budgetName = "Default Budget"; // Default budget name
        try {
            // Establish database connection using your custom class
            Connection conn = TrackEaseConnection.connect();
            int budget_id=Integer.parseInt(request.getParameter("budget_id"));
            // Query to fetch budget data
            String sql = "SELECT BudgetName, food_val, transportation_val, shopping_val, bills_val, entertainment_val, education_val, other_val, " +
                         "food_spent, transportation_spent, shopping_spent, bills_spent, entertainment_spent, education_spent, other_spent " +
                         "FROM budget WHERE BudgetId = ?"; // Replace `?` with the budget ID to fetch
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, budget_id); 

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Get budget name
                budgetName = rs.getString("BudgetName");

                // Fetch allocated values
                allocations[0] = rs.getInt("food_val");
                allocations[1] = rs.getInt("transportation_val");
                allocations[2] = rs.getInt("shopping_val");
                allocations[3] = rs.getInt("bills_val");
                allocations[4] = rs.getInt("entertainment_val");
                allocations[5] = rs.getInt("education_val");
                allocations[6] = rs.getInt("other_val");

                // Fetch spent values
                spendings[0] = rs.getInt("food_spent");
                spendings[1] = rs.getInt("transportation_spent");
                spendings[2] = rs.getInt("shopping_spent");
                spendings[3] = rs.getInt("bills_spent");
                spendings[4] = rs.getInt("entertainment_spent");
                spendings[5] = rs.getInt("education_spent");
                spendings[6] = rs.getInt("other_spent");
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
	<h1><%= budgetName %> - Allocation vs Spending</h1>
    <div class="chart-container">
        <canvas id="budgetBarChart"></canvas>
    </div>
    <script>
        // Data passed from JSP to JavaScript
        const categories = [<% 
            for (int i = 0; i < categories.length; i++) { 
                out.print("\"" + categories[i] + "\"");
                if (i < categories.length - 1) out.print(", ");
            } 
        %>];

        const allocations = [<% 
            for (int i = 0; i < allocations.length; i++) { 
                out.print(allocations[i]);
                if (i < allocations.length - 1) out.print(", ");
            } 
        %>];

        const spendings = [<% 
            for (int i = 0; i < spendings.length; i++) { 
                out.print(spendings[i]);
                if (i < spendings.length - 1) out.print(", ");
            } 
        %>];

        // Create Bar Chart
        const ctx = document.getElementById('budgetBarChart').getContext('2d');
        const budgetBarChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: categories,
                datasets: [
                    {
                        label: 'Allocated Amount',
                        data: allocations,
                        backgroundColor: '#4CAF50',
                        borderColor: '#388E3C',
                        borderWidth: 1
                    },
                    {
                        label: 'Spent Amount',
                        data: spendings,
                        backgroundColor: '#FF5722',
                        borderColor: '#E64A19',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>