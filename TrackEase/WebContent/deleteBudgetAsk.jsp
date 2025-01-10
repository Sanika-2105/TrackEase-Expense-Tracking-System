<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.TrackEase.Db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TrackEase-Delete Budget confirmation</title>
<style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            display: flex;
            height: 100vh;
            min-height: 100vh;
        }
        .sidebar {
            width: 260px;
            background-color: #7A67BB;
            color: #fff;
            padding: 1rem;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        .sidebar h2 {
            margin-top: 1.5rem;
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
            text-align: center;
            color: #FFD700;
            font-weight: bold;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            margin: 1.5rem 0;
        }
        .sidebar ul li a {
            color: #fff;
            text-decoration: none;
            font-size: 1.2rem;
            display: block;
            padding: 0.8rem;
            border-radius: 6px;
            transition: background-color 0.3s ease, padding 0.3s ease;
        }
        .sidebar ul li a:hover {
            background-color: #6B5DAA;
            padding-left: 1.2rem;
        }
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            background-color: #f4f4f9;
            overflow: hidden;
        }
        .expense-container {
            width: 100%;
            max-width: 1000px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .expense-table-title {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5rem;
            font-weight: bold;
            color: #7A67BB;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .delete-message {
            text-align: center;
            color: #7A67BB;
            margin-bottom: 20px;
            font-size: 1.2rem;
        }
        .delete-confirmation {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 1rem;
        }
        .delete-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
        }
        .delete-buttons a {
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .delete-btn {
            background-color: #FF6B6B;
            color: white;
        }
        .delete-btn:hover {
            background-color: #FF4757;
        }
        .cancel-btn {
            background-color: #7A67BB;
            color: white;
        }
        .cancel-btn:hover {
            background-color: #6B5DAA;
        }
        .expense-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 12px;
            overflow: hidden;
        }
        .expense-table th {
            background-color: #7A67BB;
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .expense-table td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
            font-size: 1rem;
        }
        .expense-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .expense-table tr:last-child td {
            border-bottom: none;
        }
        .expense-table tr:hover {
            background-color: #f0f0f0;
            transition: background-color 0.3s ease;
        }
    </style>
</head>
<body>
	<aside class="sidebar">
        <h2>TrackEase</h2>
        <ul>
            <li><a href="AddExpense.html">Add Expense</a></li>
            <li><a href="ViewExpense.jsp">Manage Expense</a></li>
            <li><a href="CreateBudget.html">Add Custom Budget</a></li>
            <li><a href="ViewBudget.jsp">View Budgets</a></li>
           <li><a href="ViewAnalytics.jsp">View Analytics</a></li>
        </ul>
    </aside>
    <%
    Connection con=TrackEaseConnection.connect();
    int budget_id=Integer.parseInt(request.getParameter("budget_id"));
    PreparedStatement pstmt=con.prepareStatement("select * from budget where BudgetId=?");
    pstmt.setInt(1, budget_id);
    ResultSet rs=pstmt.executeQuery();
    %>
    <main class="main-content">
        <div class="expense-container">
            <h2 class="expense-table-title">Delete Budget</h2>
            
            <div class="delete-message">
                Are you Sure , Do you want to delete this budget?
            </div>
            
            <div class="delete-confirmation">
                <!--  Do you want to delete this expense?-->
            </div>
            
            <!--  <div class="delete-buttons">
                <a href="deleteExpense.jsp" class="delete-btn">Delete</a>
                <a href="ViewExpense.jsp" class="cancel-btn">Cancel</a>
            </div>-->

            <table class="expense-table">
                <thead>
                    <tr>
                         <th>Sr_no</th>
                        <th>Budget Name</th>
                        <th>Monthly Income</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                </thead>
                <%while(rs.next()){ %>
                <tbody>
                    <tr>
                        <td><%=rs.getInt(1)%></td>
                        <td><%=rs.getString(2)%></td>
                        <td><%=rs.getBigDecimal(3)%> Rs</td>
                        <td><%=rs.getDate(4)%></td>
                        <td><%=rs.getDate(5)%></td>
                        
                    </tr>
                </tbody>
                <div class="delete-buttons">
                <a href="deleteBudget.jsp?budget_id=<%=rs.getInt(1)%>" class="delete-btn">Delete</a>
                <a href="ViewBudget.jsp" class="cancel-btn">Cancel</a>
            </div>
                <%} %>
            </table>
        </div>
    </main>
</body>
</html>