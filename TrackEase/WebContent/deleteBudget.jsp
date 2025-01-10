<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.TrackEase.Db.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TrackEase-Delete Budget</title>
</head>
<body>
<%Connection con=TrackEaseConnection.connect();

int budget_id=Integer.parseInt(request.getParameter("budget_id"));
PreparedStatement pstmt=con.prepareStatement("delete from budget where BudgetId=?");
pstmt.setInt(1, budget_id);
int i=pstmt.executeUpdate();

if(i>0)
{
	 PrintWriter out1=response.getWriter();
	out1.println("budget deleted successfully");
    response.sendRedirect("ViewBudget.jsp");
}
else
{
	PrintWriter out1=response.getWriter();
	out1.println("Budget not deleted");
}
%>
</body>
</html>