<%
String adminName = (String) session.getAttribute("adminName");
String adminEmail = (String) session.getAttribute("adminEmail");
%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
.sidebar {
   position: fixed;
   top: 0;
   overflow-y: auto;
   width: 250px;
   height: 100vh;
   background: #ffffff;
   box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
   z-index: 9999;
}
.dropdown-list {
    display: none;
    margin-left: 15px;
}
.dropdown-list .list-group-item {
    background: #f8f9fa;
    padding-left: 30px;
    cursor: pointer;
}
.profile-section {
    text-align: center;
    margin-bottom: 20px;
}
.profile-card {
    width: 100%;
    padding: 15px;
    background: linear-gradient(135deg, #007bff, #0056b3);
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease-in-out;
}
.profile-card:hover {
    background: linear-gradient(135deg, #0056b3, #003f7f);
}
.profile-card img {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    border: 3px solid #ffffff;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
}
.profile-card h4 {
    font-size: 16px;
    color: white;
    margin-top: 10px;
}
.profile-card small {
    color: #f0f0f0;
}
.list-group-item.active {
    background: #007bff !important;
    color: white !important;
}
.loader-wrapper {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(255, 255, 255, 0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
    visibility: hidden;
    opacity: 0;
    transition: opacity 0.3s ease-in-out;
}
.loader-wrapper.show {
    visibility: visible;
    opacity: 1;
}
.spinner {
    width: 50px; height: 50px;
    border: 5px solid rgba(0, 0, 0, 0.1);
    border-left-color: #007bff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>

<script src="<%= request.getContextPath() %>/js/dashboard.js"></script>

<div class="sidebar">
    <div class="profile-section">
        <div class="profile-card">
            <img src="<%= request.getContextPath() %>/image/avatar-1.jpg" alt="User Profile">
            <h4><%= adminName %></h4>
            <small>Administrator</small>
        </div>
    </div>

    <h4 class="text-primary text-center">Mahalakshmi</h4>

    <ul class="list-group list-group-flush">

        <!-- Dashboard -->
        <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/index.jsp')">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </li>

        <!-- Staff Dropdown -->
        <li class="list-group-item menu-item" onclick="toggleDropdown1('staffDropdown', 'staffIcon', this)">
            <i class="fas fa-users"></i> Staff <span id="staffIcon" class="float-end">+</span>
        </li>
        <ul id="staffDropdown" class="dropdown-list list-group list-group-flush">
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addEmployee.jsp')"><i class="fas fa-user-plus"></i> Add Staff</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addDepartment.jsp')"><i class="fas fa-building"></i> Add Department</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/manageStaff.jsp')"><i class="fas fa-user-cog"></i> Manage Staff</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/attendance.jsp')"><i class="fas fa-calendar-check"></i> Attendance</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/salary.jsp')"><i class="fas fa-money-bill-wave"></i> Salary</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/leave.jsp')"><i class="fas fa-person-walking-arrow-right"></i> Leave</li>
        </ul>

        <!-- Customer Dropdown -->
        <li class="list-group-item menu-item" onclick="toggleDropdown1('customerDropdown', 'customerIcon', this)">
            <i class="fas fa-user-friends"></i> Customer <span id="customerIcon" class="float-end">+</span>
        </li>
        <ul id="customerDropdown" class="dropdown-list list-group list-group-flush">
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/manageCustomer.jsp')"><i class="fas fa-user-cog"></i> Manage Customer</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/view_feedback.jsp')"><i class="fas fa-comment-dots"></i> Feedback</li>
        </ul>

        <!-- Inventory Dropdown -->
        <li class="list-group-item menu-item" onclick="toggleDropdown1('inventoryDropdown', 'inventoryIcon', this)">
            <i class="fas fa-box-open"></i> Inventory <span id="inventoryIcon" class="float-end">+</span>
        </li>
        <ul id="inventoryDropdown" class="dropdown-list list-group list-group-flush">
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addCategories.jsp')"><i class="fas fa-layer-group"></i> Add Categories</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addProduct.jsp')"><i class="fas fa-plus-square"></i> Add Product</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addOffers.jsp')"><i class="fas fa-tags"></i> Add Offers</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/viewProduct.jsp')"><i class="fas fa-eye"></i> View Product</li>
            <li class="list-group-item sub-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/manageProduct.jsp')"><i class="fas fa-cogs"></i> Manage Product</li>
        </ul>

        <!-- Orders -->
        <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/admin_orders.jsp')">
            <i class="fas fa-box"></i> Orders
        </li>

        <!-- Product Report -->
        <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/product_report.jsp')">
            <i class="fas fa-chart-line"></i> Product Report
        </li>

        <!-- Analytics -->
        <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/analytics.jsp')">
            <i class="fas fa-chart-pie"></i> Analytics
        </li>
    </ul>
</div>

<!-- Loader Overlay -->
<div id="loader" class="loader-wrapper">
    <div class="spinner"></div>
</div>
