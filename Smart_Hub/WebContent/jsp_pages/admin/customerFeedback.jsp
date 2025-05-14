<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
    <style>
    .main-content {
    margin-left: 260px; /* Adjust based on sidebar width */
    padding: 20px;
    transition: margin-left 0.3s;
}
        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        /* Search & Filter */
        .filter-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        input, select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 48%;
        }

        /* Feedback Table */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: #007bff;
            color: white;
        }

        .status-resolved {
            color: green;
            font-weight: bold;
        }

        /* Buttons */
        .btn {
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            color: white;
        }

        .resolve-btn {
            background: #28a745;
        }

        .delete-btn {
            background: #dc3545;
        }

        .btn:hover {
            opacity: 0.8;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .filter-container {
                flex-direction: column;
            }

            input, select {
                width: 100%;
                margin-bottom: 10px;
            }
        }
    </style>
    </head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container">
    <h2>Feedback Management</h2>

    <!-- Search & Filter -->
    <div class="filter-container">
        <input type="text" id="searchInput" placeholder="Search feedback...">
        <select id="categoryFilter">
            <option value="">All Categories</option>
            <option value="Complaint">Complaint</option>
            <option value="Suggestion">Suggestion</option>
            <option value="Praise">Praise</option>
        </select>
    </div>

    <!-- Feedback Table -->
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Customer</th>
                    <th>Feedback</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="feedbackTable">
                <tr>
                    <td>John Doe</td>
                    <td>The parking area needs improvement.</td>
                    <td>Complaint</td>
                    <td class="status">Pending</td>
                    <td>
                        <button class="btn resolve-btn" onclick="resolveFeedback(this)">Resolve</button>
                        <button class="btn delete-btn" onclick="deleteFeedback(this)">Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>Jane Smith</td>
                    <td>Great customer service at the help desk!</td>
                    <td>Praise</td>
                    <td class="status">Pending</td>
                    <td>
                        <button class="btn resolve-btn" onclick="resolveFeedback(this)">Resolve</button>
                        <button class="btn delete-btn" onclick="deleteFeedback(this)">Delete</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
</div>
<script>
    function resolveFeedback(button) {
        let row = button.closest("tr");
        let statusCell = row.querySelector(".status");
        statusCell.textContent = "Resolved";
        statusCell.classList.add("status-resolved");
        button.remove();
    }

    function deleteFeedback(button) {
        let row = button.closest("tr");
        row.remove();
    }
</script>
</body>
</html>
