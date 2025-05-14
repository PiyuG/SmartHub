<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Your Orders</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        body { background-color: #f5f5f5; font-family: 'Segoe UI', sans-serif; }
        .main-content { margin-left: 260px; padding: 20px; }
        .order-card { border: 1px solid #ddd; border-radius: 12px; padding: 20px; margin-bottom: 25px; background-color: #fff; }
        .order-status { padding: 5px 12px; border-radius: 20px; font-size: 13px; font-weight: 500; background-color: #e6f4ea; color: #2e7d32; }
        .product-list { margin-top: 15px; display: flex; flex-direction: column; gap: 15px; }
        .product-item { display: flex; align-items: center; border-top: 1px solid #eee; padding-top: 15px; }
        .product-img { width: 75px; height: 75px; object-fit: cover; border-radius: 8px; margin-right: 15px; border: 1px solid #ddd; }
        .feedback-btn { margin-top: 10px; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container mt-4">
        <h2 class="mb-4">Your Orders</h2>

        <!-- ✅ Feedback Message -->
        <%
    String feedbackMessage = (String) request.getAttribute("feedbackMessage");
    if (feedbackMessage != null) {
%>
    <div class="alert alert-info alert-dismissible fade show" role="alert" id="feedbackAlert">
        <%= feedbackMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>

    <script>
        setTimeout(function () {
            const alert = document.getElementById('feedbackAlert');
            if (alert) {
                alert.classList.remove("show");
                alert.classList.add("fade");
            }
        }, 4000); // auto-hide after 4s
    </script>
<%
    }
%>


        <%
            int userId = (int) session.getAttribute("user_id");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBConection.getConnection();
                String sql = "SELECT o.*, p.image, p.name, p.price, oi.quantity, " +
                             "(SELECT COUNT(*) FROM feedback f WHERE f.order_id = o.order_id AND f.customer_id = ?) AS feedback_given " +
                             "FROM orders o " +
                             "JOIN order_items oi ON o.order_id = oi.order_id " +
                             "JOIN products p ON oi.product_id = p.prod_id " +
                             "WHERE o.customer_id = ? ORDER BY o.order_date DESC";

                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setInt(2, userId);
                rs = stmt.executeQuery();

                int lastOrderId = -1;
                boolean feedbackGiven = false;
                String status = "";

                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    if (orderId != lastOrderId) {
                        if (lastOrderId != -1) {
        %>
        </div>
        <div class="mt-3 text-end">
            <a href="track_order.jsp?order_id=<%= lastOrderId %>" class="btn btn-outline-primary">Track Order</a>
            <a href="<%= request.getContextPath() + "/jsp_pages/admin/print_invoice.jsp?orderId=" + lastOrderId %>" target="_blank" class="btn btn-secondary">Download Invoice</a>
            <% if ("Delivered".equals(status) && !feedbackGiven) { %>
                <button class="btn btn-success feedback-btn" onclick="openFeedbackModal(<%= lastOrderId %>)">Give Feedback</button>
            <% } %>
        </div>
    </div>
        <%
                        }
                        lastOrderId = orderId;
                        feedbackGiven = rs.getInt("feedback_given") > 0;
                        status = rs.getString("status");
        %>
    <div class="order-card">
        <div class="d-flex justify-content-between align-items-center">
            <div>Order #<%= orderId %></div>
            <div class="order-status"><%= status %></div>
        </div>
        <div class="order-meta mt-1">Date: <%= rs.getString("order_date") %></div>
        <div class="order-meta">Ship To: <%= rs.getString("fullname") %>, <%= rs.getString("address") %>, <%= rs.getString("pincode") %></div>
        <div class="order-meta">Phone: <%= rs.getString("phone") %></div>
        <div class="product-list">
        <%
                    }

                    double price = rs.getDouble("price");
                    int quantity = rs.getInt("quantity");
                    double subtotal = price * quantity;
        %>
        <div class="product-item">
            <img src="<%= request.getContextPath() + "/" + rs.getString("image") %>" class="product-img" />
            <div>
                <strong><%= rs.getString("name") %></strong><br/>
                Quantity: <%= quantity %><br/>
                Price: ₹<%= price %><br/>
                Subtotal: ₹<%= subtotal %>
            </div>
        </div>
        <%
                }

                if (lastOrderId != -1) {
        %>
        </div>
        <div class="mt-3 text-end">
            <a href="track_order.jsp?order_id=<%= lastOrderId %>" class="btn btn-outline-primary">Track Order</a>
            <a href="<%= request.getContextPath() + "/jsp_pages/admin/print_invoice.jsp?orderId=" + lastOrderId %>" target="_blank" class="btn btn-secondary">Download Invoice</a>
            <% if ("Delivered".equals(status) && !feedbackGiven) { %>
                <button class="btn btn-success feedback-btn" onclick="openFeedbackModal(<%= lastOrderId %>)">Give Feedback</button>
            <% } %>
        </div>
    </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</div>

<!-- ✅ Feedback Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1">
  <div class="modal-dialog">
    <form method="post" action="<%= request.getContextPath() %>/SubmitFeedbackServlet" class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Submit Feedback</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="order_id" id="feedbackOrderId" />
        <div class="mb-3">
          <label for="rating" class="form-label">Rating</label>
          <select class="form-select" name="rating" required>
            <option value="">Choose...</option>
            <option value="5">⭐⭐⭐⭐⭐</option>
            <option value="4">⭐⭐⭐⭐</option>
            <option value="3">⭐⭐⭐</option>
            <option value="2">⭐⭐</option>
            <option value="1">⭐</option>
          </select>
        </div>
        <div class="mb-3">
          <label for="comments" class="form-label">Comments</label>
          <textarea class="form-control" name="comments" rows="3" required></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Submit Feedback</button>
      </div>
    </form>
  </div>
</div>

<!-- ✅ JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openFeedbackModal(orderId) {
        document.getElementById("feedbackOrderId").value = orderId;
        var modal = new bootstrap.Modal(document.getElementById('feedbackModal'));
        modal.show();
    }

    window.addEventListener("DOMContentLoaded", () => {
        const alert = document.getElementById("feedbackAlert");
        if (alert) {
            setTimeout(() => {
                let bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                bsAlert.close();
            }, 4000);
        }
    });
</script>

</body>
</html>
