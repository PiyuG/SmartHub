<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%
    if (session != null && !session.isNew()) {
        session.invalidate(); 
    }

    String redirectURL = request.getContextPath() + "/jsp_pages/index/index.jsp";
    response.sendRedirect(redirectURL);
%>
