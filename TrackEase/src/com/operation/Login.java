package com.operation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.TrackEase.Db.*;
/**
 * Servlet implementation class Login
 */
@WebServlet(name = "Login.java", urlPatterns = { "/Login.java" })
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
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
		String email1=null;
		String pass1=null;
		String email=request.getParameter("username");
		String pass=request.getParameter("password");
		System.out.println(email);
		System.out.println(pass);
		
		try{
			PreparedStatement stmt=con.prepareStatement("select * from login where email=? and password=?");
			stmt.setString(1, email);
			stmt.setString(2,pass);
			ResultSet rs=stmt.executeQuery();
			while(rs.next())
			{
				 email1=rs.getString(2);
				 pass1=rs.getString(3);
			}
			if(email.equals(email1)&&pass.equals(pass1))
			{
				response.sendRedirect("dashboard.html");
			}
			else
			{
				response.sendRedirect("login.html");
			}
		} 
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
	
		}
	}

}
