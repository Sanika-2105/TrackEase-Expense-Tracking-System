<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.TrackEase.Db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TrackEase-Expense by Category</title>
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
            max-width: 600px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
	 <% 
        String[] categories = {"Food", "Transportation", "Shopping", "Bills", "Entertainment", "Education", "Other"};
        double[] expenses = new double[categories.length];
        double[] allocatedAmounts = new double[categories.length];
        double[] remainingAmounts = new double[categories.length];
        String budgetName = "Default Budget"; // Default budget name

        try {
            Connection conn = TrackEaseConnection.connect();

            // Query to get both the allocated and spent amounts for each category
            String sql = "SELECT BudgetName, " +
                         "food_allocated, transportation_allocated, shopping_allocated, bills_allocated, " +
                         "entertainment_allocated, education_allocated, other_allocated, " +
                         "food_spent, transportation_spent, shopping_spent, bills_spent, " +
                         "entertainment_spent, education_spent, other_spent " +
                         "FROM budget WHERE BudgetId = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, 1); // Replace with desired BudgetId

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                budgetName = rs.getString("BudgetName");

                // Fetch both allocated and spent amounts for each category
                allocatedAmounts[0] = rs.getDouble("food_allocated");
                allocatedAmounts[1] = rs.getDouble("transportation_allocated");
                allocatedAmounts[2] = rs.getDouble("shopping_allocated");
                allocatedAmounts[3] = rs.getDouble("bills_allocated");
                allocatedAmounts[4] = rs.getDouble("entertainment_allocated");
                allocatedAmounts[5] = rs.getDouble("education_allocated");
                allocatedAmounts[6] = rs.getDouble("other_allocated");

                expenses[0] = rs.getDouble("food_spent");
                expenses[1] = rs.getDouble("transportation_spent");
                expenses[2] = rs.getDouble("shopping_spent");
                expenses[3] = rs.getDouble("bills_spent");
                expenses[4] = rs.getDouble("entertainment_spent");
                expenses[5] = rs.getDouble("education_spent");
                expenses[6] = rs.getDouble("other_spent");
            }

            // Calculate remaining amounts for each category
            for (int i = 0; i < categories.length; i++) {
                remainingAmounts[i] = allocatedAmounts[i] - expenses[i];
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <h1><%= budgetName %> - Expense by Category</h1>
    <div class="chart-container">
        <canvas id="expenseBarChart"></canvas>
    </div>

    <script>
        const categories = <%= java.util.Arrays.toString(categories).replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
        const expenses = <%= java.util.Arrays.toString(expenses) %>;
        const allocatedAmounts = <%= java.util.Arrays.toString(allocatedAmounts) %>;
        const remainingAmounts = <%= java.util.Arrays.toString(remainingAmounts) %>;

        const ctx = document.getElementById('expenseBarChart').getContext('2d');
        const expenseBarChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: categories,
                datasets: [
                    {
                        label: 'Spent Amount',
                        data: expenses,
                        backgroundColor: '#FF6384',  // Red color for spent
                        borderColor: '#FF6384',
                        borderWidth: 1
                    },
                    {
                        label: 'Remaining Amount',
                        data: remainingAmounts,
                        backgroundColor: '#36A2EB',  // Blue color for remaining
                        borderColor: '#36A2EB',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        beginAtZero: true
                    },
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                const label = tooltipItem.dataset.label;
                                const value = tooltipItem.raw;
                                return label + ': ₹' + value.toFixed(2);
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>