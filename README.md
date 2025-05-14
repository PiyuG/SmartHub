
# 🚀 SmartHub – Business Management System

SmartHub is a full-featured Java-based web application designed to streamline and automate daily operations for modern businesses. Built using JSP, Servlets, and MySQL, it integrates product management, order processing, employee handling, customer engagement, and delivery tracking into a single system.

---

## 🌟 Features

### 👤 Admin Panel
- Manage employees (add/edit/deactivate)
- Assign delivery staff to orders
- Handle leaves, salaries, attendance
- View customer feedback
- Manage products, offers, categories & subcategories

### 👨‍💼 Employee Dashboard
- Mark attendance
- Apply for leave
- View salary details and download invoice
- Track assigned delivery orders (for delivery staff)

### 🧑‍💻 Customer Dashboard
- View & purchase products
- Get offers and discounts
- Add to cart and place orders
- Give feedback and ratings
- Download order invoice

---

## 🧰 Tech Stack

- **Frontend:** HTML, CSS, JavaScript, Bootstrap, JSP
- **Backend:** Java (Servlets, JSP), JDBC
- **Database:** MySQL
- **Tools:** Apache Tomcat, Eclipse/IntelliJ

---

## ⚙️ Configuration

### 📦 Requirements

- Java JDK 8+
- Apache Tomcat 10/above
- MySQL 5.7/8+
- Eclipse IDE / IntelliJ IDEA

### 🗃️ Database Setup

1. Create a MySQL database (e.g., `smarthub`)
2. Import the provided SQL file.
3. Update DB config in `DBConnection.java`:
   ```java
   String url = "jdbc:mysql://localhost:3306/smarthub";
   String username = "root";
   String password = "your_password";
   ```

---

## 🧩 JDBC Driver (JAR Configuration)

### 🔽 Download MySQL Connector/J

- Visit: [https://dev.mysql.com/downloads/connector/j/](https://dev.mysql.com/downloads/connector/j/)
- Download the platform-independent `.zip` version
- Extract and locate: `mysql-connector-j-8.x.x.jar`

### 🛠️ Add JAR to Project

#### If using Eclipse:
1. Right-click project → Build Path → Configure Build Path
2. Go to Libraries → Add External JARs
3. Select `mysql-connector-j-8.x.x.jar`

#### If using Tomcat:
- Optionally copy the `.jar` to `TOMCAT_HOME/lib/` to make it available globally

---

## ▶️ Run the Project

1. **Clone the repo:**
   ```bash
   git clone https://github.com/your-username/smarthub.git
   ```

2. **Open in Eclipse/IDEA** as a dynamic web project.

3. **Configure Tomcat Server:**
   - Add the project to the Tomcat server in your IDE.
   - Set Tomcat as the runtime in project properties.

4. **Build & Deploy:**
   - Clean and build the project.
   - Run the project on Tomcat.

5. **Visit in browser:**
   ```
   http://localhost:8080/smarthub/
   ```

---

## 🧪 Test Credentials

### Admin
- 🆔 Username: `admin`
- 🔑 Password: `admin12345`

---

## 📸 Screenshots
### 🔹 Landing Page
![image](https://github.com/user-attachments/assets/69390efa-42c5-4175-b65c-3d6e0dbe88a1)

### 🔹 Admin Dashboard
![image](https://github.com/user-attachments/assets/9d266d64-a85a-4e0a-b892-530ba5b05637)

### 🔹 Employee Dashboard
![image](https://github.com/user-attachments/assets/c128b163-b411-43af-aa6b-4e7ac816fc14)

### 🔹 Customer Dashboard
![image](https://github.com/user-attachments/assets/8b224907-d2da-412a-a1a7-760a95c5d09a)



# SmartHub
A Java-based SmartHub system for managing customers, employees, orders, salaries, attendance, product offers, and delivery operations in a unified platform. Using Java, JSP/Servlet
