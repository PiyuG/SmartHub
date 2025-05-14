<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*, com.smart_hub.servlets.DBConection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
    .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 70%; margin: 40px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1); }
        
        .notif-unread {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
        }
        .notif-read {
            background-color: #fff;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container mt-5">
    <h3 class="mb-4">Your Notifications</h3>

    <form action="MarkAllNotificationsReadServlet" method="post" class="mb-3">
        <button type="submit" class="btn btn-sm btn-primary">Mark All as Read</button>
    </form>

    <%
        HttpSession sess = request.getSession();
        String userEmail = (String) sess.getAttribute("mail");

        Connection conn = DBConection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT n.id, n.message, n.status, n.created_at FROM notifications n JOIN customer c ON n.user_id = c.id WHERE c.mail = ? ORDER BY n.id DESC"
        );
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();
        boolean hasData = false;

        while (rs.next()) {
            hasData = true;
            String status = rs.getString("status");
    %>
        <div class="card mb-3 <%= "unread".equalsIgnoreCase(status) ? "notif-unread" : "notif-read" %>">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <p class="mb-1"><%= rs.getString("message") %></p>
                    <small class="text-muted"><%= rs.getTimestamp("created_at") %></small>
                </div>
                <div class="d-flex gap-2">
                    <% if ("unread".equalsIgnoreCase(status)) { %>
                        <form action="MarkNotificationReadServlet" method="post">
                            <input type="hidden" name="notifId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn btn-sm btn-success">Mark as Read</button>
                        </form>
                    <% } %>
                    <form action="DeleteNotificationServlet" method="post" onsubmit="return confirm('Are you sure?');">
                        <input type="hidden" name="notifId" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    <%
        }

        if (!hasData) {
    %>
        <div class="alert alert-info">No notifications found.</div>
    <%
        }

        rs.close();
        ps.close();
        conn.close();
    %>
</div>
</div>


</body>
</html>
