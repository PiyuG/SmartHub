<!-- Fonts and Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

<style>
  body {
    margin: 0;
    font-family: 'Poppins', sans-serif;
  }

  .container {
    position: fixed;
    top: 0;
    width: 100%;
    background: black;
    z-index: 1050;
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    transition: background 0.3s ease, box-shadow 0.3s ease;
    max-width: 2300px;
  }

  .header-main {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    padding: 10px 30px;
  }

  .logo {
    font-size: 2rem;
    font-weight: bold;
    color: #fff;
    text-decoration: none;
    transition: color 0.3s ease;
  }
  .logo:hover {
    color: #00c6ff;
  }

  .nav-menu {
    display: flex;
    align-items: center;
    gap: 25px;
    flex-wrap: wrap;
  }

  .menu {
    display: flex;
    list-style: none;
    gap: 20px;
    margin: 0;
    padding: 0;
  }

  .menu-item a {
    text-decoration: none;
    font-weight: bold;
    color: #fff;
    font-weight: 500;
    padding: 8px 12px;
    border-radius: 10px;
    transition: background 0.3s ease, color 0.3s ease;
  }
  .menu-item a:hover,
  .menu-item a.active {
    background: rgba(255, 255, 255, 0.1);
    color: #00c6ff;
  }

  .menu-item-has-children {
    position: relative;
  }

  .menu-item-has-children > a::after {
    content: " \f107";
    font-family: "Font Awesome 6 Free";
    font-weight: 900;
    margin-left: 6px;
  }

  .sub-menu {
    display: none;
    position: absolute;
    top: 120%;
    left: 0;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
    padding: 10px 0;
    min-width: 180px;
    opacity: 0;
    list-style: none;
    transform: translateY(10px);
    transition: all 0.3s ease;
    z-index: 999;
  }

  .menu-item-has-children:hover .sub-menu {
    display: block;
    opacity: 1;
    transform: translateY(0);
  }

  .sub-menu .menu-item a {
    color: #333;
    padding: 10px 20px;
    display: block;
    font-weight: 500;
  }

  .sub-menu .menu-item a:hover {
    background: #f1f1f1;
    color: #00c6ff;
  }

  .btn-get-started {
    margin-left: 20px;
    padding: 10px 25px;
    background: linear-gradient(135deg, #007bff, #00c6ff);
    color: white;
    font-weight: 600;
    border: none;
    border-radius: 50px;
    text-decoration: none;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    white-space: nowrap;
  }

  .btn-get-started:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 123, 255, 0.3);
  }

  .open-nav-menu {
    display: none;
    cursor: pointer;
  }

  .open-nav-menu span,
  .open-nav-menu span::before,
  .open-nav-menu span::after {
    content: "";
    display: block;
    height: 3px;
    width: 25px;
    background: #fff;
    margin: 5px 0;
  }

  .close-nav-menu {
    display: none;
    width: 100%;
    text-align: right;
    margin-bottom: 20px;
  }

  .close-nav-menu i {
    font-size: 24px;
    color: #fff;
    cursor: pointer;
  }

  .menu-overlay {
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    width: 100vw;
    background: rgba(0, 0, 0, 0.4);
    display: none;
    z-index: 1040;
  }

  .menu-overlay.active {
    display: block;
  }

  @media screen and (max-width: 991px) {
  .open-nav-menu {
    display: block;
  }

  .header-main {
    padding: 12px 16px; /* Reduced padding */
  }

  .logo {
    font-size: 1.5rem; /* Slightly smaller logo */
  }

  .nav-menu {
    position: fixed;
    top: 0;
    right: -100%;
    background: rgba(0, 0, 0, 0.95);
    height: 100vh;
    width: 260px;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    padding: 40px 20px;
    transition: right 0.4s ease;
    z-index: 1050;
  }

  .nav-menu.open {
    right: 0;
  }

  .close-nav-menu {
    display: block;
    width: 100%;
    text-align: right;
  }

  .menu {
    flex-direction: column;
    gap: 12px;
    width: 100%;
    padding-left: 0;
  }

  .menu-item a {
    color: #fff;
    font-size: 16px;
    padding: 10px 0;
  }

  .sub-menu {
    position: static;
    background: transparent;
    box-shadow: none;
    opacity: 1;
    transform: none;
    display: none;
  }

  .menu-item-has-children.active .sub-menu {
    display: block;
  }

  .sub-menu .menu-item a {
    color: #fff;
    padding-left: 30px;
    font-size: 15px;
  }

  .btn-get-started {
    margin-top: 20px;
    padding: 10px 20px;
    font-size: 15px;
  }
}

</style>

<header class="header">
  <div class="container">
    <div class="header-main">
      <a href="${pageContext.request.contextPath}/" class="logo">SmartHub</a>

      <div class="open-nav-menu"><span></span></div>
      <div class="menu-overlay"></div>

      <nav class="nav-menu">
        <div class="close-nav-menu"><i class="fas fa-times"></i></div>
        <ul class="menu">
          <li class="menu-item"><a class="<%= request.getRequestURI().contains("index.jsp") ? "active" : "" %>" href="${pageContext.request.contextPath}/jsp_pages/index/index.jsp">Home</a></li>
          <li class="menu-item"><a class="<%= request.getRequestURI().contains("contact.jsp") ? "active" : "" %>" href="${pageContext.request.contextPath}/jsp_pages/index/contact.jsp">Contact Us</a></li>
          <li class="menu-item"><a class="<%= request.getRequestURI().contains("about.jsp") ? "active" : "" %>" href="${pageContext.request.contextPath}/jsp_pages/index/about.jsp">About Us</a></li>

          <li class="menu-item menu-item-has-children">
            <a href="javascript:void(0)">Registration</a>
            <ul class="sub-menu">
              <li class="menu-item"><a href="${pageContext.request.contextPath}/jsp_pages/index/employeeRegistration.jsp">Employee</a></li>
              <li class="menu-item"><a href="${pageContext.request.contextPath}/jsp_pages/index/customerregistration.jsp">Customer</a></li>
            </ul>
          </li>

          <li class="menu-item menu-item-has-children">
            <a href="javascript:void(0)">Login</a>
            <ul class="sub-menu">
              <li class="menu-item"><a href="${pageContext.request.contextPath}/jsp_pages/index/adminlogin.jsp">Admin</a></li>
              <li class="menu-item"><a href="${pageContext.request.contextPath}/jsp_pages/index/employeelogin.jsp">Employee</a></li>
              <li class="menu-item"><a href="${pageContext.request.contextPath}/jsp_pages/index/customerlogin.jsp">Customer</a></li>
            </ul>
          </li>

        </ul>

        <a href="${pageContext.request.contextPath}/jsp_pages/index/customerregistration.jsp" class="btn-get-started">Get Started</a>
      </nav>
    </div>
  </div>
</header>

<script>
  const openMenu = document.querySelector('.open-nav-menu');
  const closeMenu = document.querySelector('.close-nav-menu i');
  const navMenu = document.querySelector('.nav-menu');
  const menuOverlay = document.querySelector('.menu-overlay');
  const dropdowns = document.querySelectorAll('.menu-item-has-children');

  openMenu.onclick = () => {
    navMenu.classList.add('open');
    menuOverlay.classList.add('active');
  };

  closeMenu.onclick = () => {
    navMenu.classList.remove('open');
    menuOverlay.classList.remove('active');
  };

  menuOverlay.onclick = () => {
    navMenu.classList.remove('open');
    menuOverlay.classList.remove('active');
  };

  dropdowns.forEach(item => {
    item.addEventListener('click', function (e) {
      if (window.innerWidth <= 991) {
        this.classList.toggle('active');
      }
    });
  });
</script>
