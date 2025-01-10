<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.TrackEase.Db.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrackEase-View Expense</title>
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
        .table-wrapper {
            max-height: 400px; /* Set the maximum height for the scrollable area */
            overflow-y: auto; /* Enable vertical scrolling */
            overflow-x: hidden; /* Prevent horizontal scrolling */
            margin-top: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
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
        .btn {
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            text-transform: uppercase;
        }

        .btn-delete {
            background-color: #FF5C5C;
            color: white;
        }

        .btn-delete:hover {
            background-color: #FF3838;
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
    PreparedStatement pstmt=con.prepareStatement("select * from expense");
    ResultSet rs=pstmt.executeQuery();
    %>
    <main class="main-content">
        <div class="expense-container">
            <h2 class="expense-table-title">Expense Details</h2>
            <div class="table-wrapper">
            <table class="expense-table">
                <thead>
                    <tr>
                        <th>Sr_no</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Delete Expense</th>
                    </tr>
                </thead>
                <%while(rs.next()){ %>
                <tbody>
                    <tr>
                        <td><%=rs.getInt(1)%></td>
                        <td><%=rs.getDate(2)%></td>
                        <td><%=rs.getInt(3)%> Rs</td>
                        <td><%=rs.getString(4)%></td>
                        <td><%=rs.getString(5)%></td>
                        <!--  <td><a href="deleteExpAsk.jsp?expid=<%=rs.getInt(1)%>">Delete</a></td>-->
                        <td>
                            <a href="deleteExpAsk.jsp?expid=<%=rs.getInt(1)%>" style="text-decoration: none;">
                                <button class="btn btn-delete">Delete</button>
                            </a>
                        </td>
                    </tr>
                </tbody>
                <%} %>
            </table>
            </div>
        </div>
    </main>
</body>
</html>
</body>
</html>