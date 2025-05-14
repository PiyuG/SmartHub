<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smart_hub.servlets.DBConection" %>

<%
    class Category {
        String name;
        String image;
        Category(String name, String image) {
            this.name = name;
            this.image = image;
        }
    }

    List<Category> categoryList = new ArrayList<>();
    try {
        Connection conn = DBConection.getConnection();
        PreparedStatement pst = conn.prepareStatement("SELECT category_name, image FROM category");
        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
            String name = rs.getString("category_name");
            String image = rs.getString("image");
            categoryList.add(new Category(name, image));
        }
        rs.close();
        pst.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Mahalakshmi Mall</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <style>
        body { font-family: 'Raleway', sans-serif; }
        .about-section {
            background-image: url('<%= request.getContextPath() %>/image/logo3.jpg');
            background-size: cover;
            background-position: center top;
        }
        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .animate-fadeInUp { animation: fadeInUp 1s ease-out; }
    </style>
</head>
<body class="bg-gray-50">

<%@ include file="header.jsp" %>

<!-- About Section -->
<section class="about-section min-h-screen flex items-center justify-center px-4 py-20">
    <div class="bg-white bg-opacity-90 rounded-xl shadow-lg p-6 md:p-12 flex flex-col md:flex-row gap-8 max-w-5xl w-full animate-fadeInUp">
        <div class="md:w-1/2">
            <h2 class="text-3xl font-bold text-gray-800 mb-4 text-center md:text-left">About Mahalakshmi Mall, Pune</h2>
            <p class="text-gray-700 mb-3 text-justify">
                Welcome to Mahalakshmi Mall — Punes’s premier destination for shopping, dining, and leisure. Designed to cater to modern lifestyles while embracing local culture, our mall brings together the best of fashion, food, and fun under one roof.
            </p>
            <p class="text-gray-700 mb-3 text-justify">
                Explore a diverse range of outlets from popular fashion brands to specialty stores offering everything from groceries to electronics. Our thoughtfully designed space ensures a seamless and enjoyable experience for individuals and families alike.
            </p>
            <p class="text-gray-700 text-justify">
                With exciting promotions, entertainment zones, and events throughout the year, Mahalakshmi Mall is more than just a shopping center — it’s a vibrant hub for community engagement and joyful moments.
            </p>
        </div>
        <div class="md:w-1/2 flex justify-center">
            <img src="<%= request.getContextPath() %>/image/cart.jpg" alt="Mahalakshmi Mall" class="rounded-lg shadow-md w-full h-auto">
        </div>
    </div>
</section>

<!-- Mission -->
<section class="bg-white py-16 text-center">
    <div class="max-w-3xl mx-auto px-4">
        <h2 class="text-3xl font-semibold text-gray-800 mb-4">Our Mission</h2>
        <p class="text-gray-600 text-lg">
            To be the heart of Punes’s retail and lifestyle experience by offering top-tier services, diverse shopping options, and a welcoming atmosphere that connects people and enriches everyday life.
        </p>
    </div>
</section>

<!-- Explore Our Categories Section -->
<section class="py-16 bg-blue-50">
    <div class="max-w-7xl mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold text-gray-800 mb-10 animate-fadeInUp">Explore Our Categories</h2>

        <div class="swiper categorySwiper px-4">
            <div class="swiper-wrapper">
                <%
                    for (Category cat : categoryList) {
                %>
                <div class="swiper-slide">
                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition-all duration-300 w-44 sm:w-48 mx-auto">
                        <img src="<%= request.getContextPath() %>/category_images/<%= cat.image %>" alt="<%= cat.name %>" class="mx-auto w-14 h-14 object-contain mb-3">
                        <h3 class="font-semibold text-lg text-gray-700"><%= cat.name %></h3>
                        <p class="text-gray-500 text-sm mt-1">Shop the latest!</p>
                    </div>
                </div>
                <%
                    }
                    if (categoryList.isEmpty()) {
                %>
                <div class="text-gray-500 swiper-slide">No categories found.</div>
                <%
                    }
                %>
            </div>

            <!-- Navigation Arrows -->
            <div class="swiper-button-next text-gray-500"></div>
            <div class="swiper-button-prev text-gray-500"></div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
    var swiper = new Swiper(".categorySwiper", {
        slidesPerView: 2,
        spaceBetween: 20,
        loop: false,
        navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev",
        },
        breakpoints: {
            640: { slidesPerView: 3, spaceBetween: 20 },
            768: { slidesPerView: 4, spaceBetween: 24 },
            1024: { slidesPerView: 5, spaceBetween: 28 }
        }
    });
</script>

</body>
</html>
