<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.TrackEase.Db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TrackEase-Budget Visualization</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
 
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh; /* Full viewport height */
        margin: 0;
        padding: 0;
        overflow: hidden; /* Prevent scrolling */
    }
    .chart-container {
        width: 60%; /* Utilize more horizontal space */
        height: auto;
        max-width: 700px; /* Limit the maximum size */
        max-height: 80%; /* Ensure it doesn't overflow the viewport */
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    canvas {
        display: block;
        width: 100%; /* Ensures the canvas fully utilizes the container */
        height: 100%; /* Scales to the container's height */
    }
</style>
    
</head>
<body>
	<% 
        // Data for pie chart
        String[] categories = {"Food", "Transportation", "Shopping", "Bills", "Entertainment", "Education", "Other"};
        double[] percentages = new double[categories.length];

        String budgetName = "Default Budget"; // Default budget name
        try {
            // Establish database connection using your custom class
            Connection conn = TrackEaseConnection.connect();
            int budget_id=Integer.parseInt(request.getParameter("budget_id"));
            // Query to fetch budget data
            String sql = "SELECT BudgetName, food_val, transportation_val, shopping_val, bills_val, entertainment_val, education_val, other_val " +
                         "FROM budget WHERE BudgetId = ?"; 
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, budget_id); 

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Get budget name
                budgetName = rs.getString("BudgetName");

                // Fetch category values
                int food = rs.getInt("food_val");
                int transportation = rs.getInt("transportation_val");
                int shopping = rs.getInt("shopping_val");
                int bills = rs.getInt("bills_val");
                int entertainment = rs.getInt("entertainment_val");
                int education = rs.getInt("education_val");
                int other = rs.getInt("other_val");

                // Calculate total allocated value
                int total = food + transportation + shopping + bills + entertainment + education + other;

                // Calculate percentages
                if (total > 0) {
                    percentages[0] = (food / (double) total) * 100;
                    percentages[1] = (transportation / (double) total) * 100;
                    percentages[2] = (shopping / (double) total) * 100;
                    percentages[3] = (bills / (double) total) * 100;
                    percentages[4] = (entertainment / (double) total) * 100;
                    percentages[5] = (education / (double) total) * 100;
                    percentages[6] = (other / (double) total) * 100;
                }
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <h1><%= budgetName %> - Budget Allocation</h1>
    <div class="chart-container">
        <canvas id="budgetPieChart"></canvas>
    </div>
    <script>
        // Data passed from JSP to JavaScript
        const categories = <%= java.util.Arrays.toString(categories).replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
        const percentages = <%= java.util.Arrays.toString(percentages) %>;

        // Create Pie Chart
        const ctx = document.getElementById('budgetPieChart').getContext('2d');
        const budgetPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: categories,
                datasets: [{
                    data: percentages,
                    backgroundColor: ['#FF5733', '#33FF57', '#3357FF', '#FFD700', '#FF33A8', '#8A2BE2', '#7FFFD4'],
                    borderColor: '#fff',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                }
            }
        });
    </script>
	
</body>
</html>