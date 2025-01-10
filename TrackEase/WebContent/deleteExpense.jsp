<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.TrackEase.Db.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>delete Expense</title>
</head>
<body>
<%Connection con=TrackEaseConnection.connect();

int expid=Integer.parseInt(request.getParameter("expid"));
PreparedStatement pstmt=con.prepareStatement("delete from expense where expense_id=?");
pstmt.setInt(1, expid);
int i=pstmt.executeUpdate();

if(i>0)
{
	 PrintWriter out1=response.getWriter();
	out1.println("Expense deleted successfully");
    response.sendRedirect("ViewExpense.jsp");
}
else
{
	PrintWriter out1=response.getWriter();
	out1.println("Expense not deleted");
}
%>
</body>
</html>