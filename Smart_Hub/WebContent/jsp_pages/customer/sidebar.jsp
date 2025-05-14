
<%
String customerName = (String) session.getAttribute("name");
String customerEmail = (String) session.getAttribute("mail");
%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar {
   position: fixed;
   top: 0;
   overflow-y: auto;
   border-radius: 0px;
   box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
   width: 250px;
   height: 100vh;
   background: #ffffff;
   box-shadow: gray;
   z-index:9999;
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
    /* display: inline-block; */
  width: 100%;
  padding: 15px;
  /* border-radius: 10px; */
  background: linear-gradient(135deg, #007bff, #0056b3);  /* Attractive blue gradient */
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);  /* Soft shadow */
    transition: all 0.3s ease-in-out;
}

.profile-card:hover {
    background: linear-gradient(135deg, #0056b3, #003f7f); /* Darker on hover */
}

.profile-card img {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    border: 3px solid #ffffff;  /* White border for contrast */
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);  /* Soft shadow */
}

.profile-card h4 {
    font-size: 16px;
    color: white;
    margin-top: 10px;
}

.profile-card small {
    color: #f0f0f0;
}


/* Keep selected item highlighted */
.list-group-item.active {
    background: #007bff !important;
    color: white !important;
}

/* Hide dropdown menus by default */
.dropdown-list {
    display: none;
    margin-left: 15px;
}


 /* Loader Styles */
 .loader-wrapper {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
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
    width: 50px;
    height: 50px;
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
            <img id="profilePic" src="<%= request.getContextPath() %>/image/avatar-1.jpg" alt="User Profile">
            <h4><%= customerName %></h4>
           <small>Customer</small>
       </div>
   </div>
   
   <h4 class="text-primary">Mahalakshmi</h4>
   <ul class="list-group list-group-flush">
       <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/customer/index.jsp')"><i class="fas fa-home"></i> Dashboard</li>

   <ul class="list-group list-group-flush">
       <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/customer/cart.jsp')"><i class="fa-solid fa-cart-shopping"></i> Cart</li>

	<ul class="list-group list-group-flush">
       <li class="list-group-item menu-item" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/customer/orderHistory.jsp')"><i class="fas fa-cart-plus"></i> My Orders</li>		   
  </ul>        
</div>

<!-- Loader -->
<div id="loader" class="loader-wrapper">
    <div class="spinner"></div>
</div>