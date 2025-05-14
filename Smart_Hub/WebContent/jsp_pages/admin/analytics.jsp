<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>

<%!
    String toJSArray(List<?> list, boolean isString) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (isString) sb.append("\"").append(list.get(i).toString().replace("\"", "\\\"")).append("\"");
            else sb.append(list.get(i));
            if (i != list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>SmartHub Analytics</title>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- jsPDF and html2canvas -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <!-- xlsx for Excel Export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 95%; margin: 40px auto; background: #fff; border-radius: 10px; padding: 20px; box-shadow: 0px 4px 20px rgba(0,0,0,0.1); }
        .form-select, .form-control, .btn { margin-bottom: 15px; }
        canvas { max-width: 100% !important; height: auto !important; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />

<%
    Connection conn = DBConection.getConnection();

    List<String> catLabels = new ArrayList<>();
    List<Integer> catCounts = new ArrayList<>();
    PreparedStatement catStmt = conn.prepareStatement("SELECT c.category_name, COUNT(p.prod_id) as product_count FROM category c LEFT JOIN products p ON c.category_id = p.category GROUP BY c.category_id");
    ResultSet catRs = catStmt.executeQuery();
    while (catRs.next()) {
        catLabels.add(catRs.getString("category_name"));
        catCounts.add(catRs.getInt("product_count"));
    }

    List<String> prodLabels = new ArrayList<>();
    List<Integer> prodCounts = new ArrayList<>();
    PreparedStatement prodStmt = conn.prepareStatement("SELECT p.name, COUNT(oi.product_id) AS order_count FROM order_items oi JOIN products p ON oi.product_id = p.prod_id GROUP BY oi.product_id");
    ResultSet prodRs = prodStmt.executeQuery();
    while (prodRs.next()) {
        prodLabels.add(prodRs.getString("name"));
        prodCounts.add(prodRs.getInt("order_count"));
    }

    DateFormatSymbols dfs = new DateFormatSymbols();
    List<String> monthLabels = new ArrayList<>();
    List<Integer> monthCounts = new ArrayList<>();
    ResultSet monthRs = conn.prepareStatement("SELECT MONTH(order_date) AS month, COUNT(*) AS count FROM orders GROUP BY MONTH(order_date)").executeQuery();
    while (monthRs.next()) {
        monthLabels.add(dfs.getMonths()[monthRs.getInt("month") - 1]);
        monthCounts.add(monthRs.getInt("count"));
    }

    List<String> weekLabels = new ArrayList<>();
    List<Integer> weekCounts = new ArrayList<>();
    ResultSet weekRs = conn.prepareStatement("SELECT WEEK(order_date) AS week, COUNT(*) AS count FROM orders WHERE order_date >= CURDATE() - INTERVAL 30 DAY GROUP BY WEEK(order_date)").executeQuery();
    while (weekRs.next()) {
        weekLabels.add("Week " + weekRs.getInt("week"));
        weekCounts.add(weekRs.getInt("count"));
    }

    List<String> yearLabels = new ArrayList<>();
    List<Integer> yearCounts = new ArrayList<>();
    ResultSet yearRs = conn.prepareStatement("SELECT YEAR(order_date) AS year, COUNT(*) AS count FROM orders GROUP BY YEAR(order_date)").executeQuery();
    while (yearRs.next()) {
        yearLabels.add(String.valueOf(yearRs.getInt("year")));
        yearCounts.add(yearRs.getInt("count"));
    }

    String colors = "[\"#FF6384\",\"#36A2EB\",\"#FFCE56\",\"#4BC0C0\",\"#9966FF\",\"#FF9F40\",\"#8B0000\",\"#00CED1\",\"#3CB371\",\"#FFD700\",\"#DC143C\",\"#00FA9A\",\"#9370DB\",\"#FFA07A\",\"#40E0D0\"]";

    String catLabelsJS = toJSArray(catLabels, true);
    String catCountsJS = toJSArray(catCounts, false);
    String prodLabelsJS = toJSArray(prodLabels, true);
    String prodCountsJS = toJSArray(prodCounts, false);
    String monthLabelsJS = toJSArray(monthLabels, true);
    String monthCountsJS = toJSArray(monthCounts, false);
    String weekLabelsJS = toJSArray(weekLabels, true);
    String weekCountsJS = toJSArray(weekCounts, false);
    String yearLabelsJS = toJSArray(yearLabels, true);
    String yearCountsJS = toJSArray(yearCounts, false);
%>

<div class="main-content">
    <div class="container">
        <h2 class="text-center mb-4">SmartHub Analytics Dashboard</h2>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <select id="chartSelect" class="form-select w-25">
                <option value="category">Category-wise</option>
                <option value="product">Product-wise</option>
                <option value="month">Monthly</option>
                <option value="week">Weekly</option>
                <option value="year">Yearly</option>
            </select>
            <div>
                <button class="btn btn-outline-primary me-2" onclick="toggleChartType()">Toggle Pie/Bar</button>
                <button class="btn btn-success me-2" onclick="exportExcel()">Export Excel</button>
                <button class="btn btn-danger" onclick="exportPDF()">Export PDF</button>
            </div>
        </div>

        <div style="width: 100%; max-width: 900px; margin: auto;">
            <canvas id="mainChart" height="400"></canvas>
        </div>
    </div>
</div>

<script>
    let currentType = 'pie';
    let chart;
    let colorPalette = <%= colors %>;

    const datasets = {
        category: {
            labels: <%= catLabelsJS %>,
            data: <%= catCountsJS %>
        },
        product: {
            labels: <%= prodLabelsJS %>,
            data: <%= prodCountsJS %>
        },
        month: {
            labels: <%= monthLabelsJS %>,
            data: <%= monthCountsJS %>
        },
        week: {
            labels: <%= weekLabelsJS %>,
            data: <%= weekCountsJS %>
        },
        year: {
            labels: <%= yearLabelsJS %>,
            data: <%= yearCountsJS %>
        }
    };

    function renderChart(type) {
        const selected = document.getElementById("chartSelect").value;
        if (chart) chart.destroy();

        chart = new Chart(document.getElementById("mainChart"), {
            type: type,
            data: {
                labels: datasets[selected].labels,
                datasets: [{
                    label: selected.charAt(0).toUpperCase() + selected.slice(1),
                    data: datasets[selected].data,
                    backgroundColor: colorPalette,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: type === 'pie'
                    }
                },
                scales: type !== 'pie' ? {
                    y: {
                        beginAtZero: true
                    }
                } : {}
            }
        });
    }

    function toggleChartType() {
        currentType = (currentType === 'pie') ? 'bar' : 'pie';
        renderChart(currentType);
    }

    function exportPDF() {
        const { jsPDF } = window.jspdf;
        const canvas = document.getElementById("mainChart");

        html2canvas(canvas).then(canvasImg => {
            const imgData = canvasImg.toDataURL("image/png");

            const pdf = new jsPDF({
                orientation: 'landscape',
                unit: 'pt',
                format: 'a4'
            });

            const pageWidth = pdf.internal.pageSize.getWidth();
            const imgWidth = pageWidth - 80;
            const imgHeight = canvasImg.height * (imgWidth / canvasImg.width);

            pdf.setFontSize(18);
            pdf.text("SmartHub Analytics Report", 40, 40);
            pdf.addImage(imgData, 'PNG', 40, 60, imgWidth, imgHeight);
            pdf.save("analytics_report.pdf");
        });
    }

    function exportExcel() {
        const selected = document.getElementById("chartSelect").value;
        let wb = XLSX.utils.book_new();
        let ws = XLSX.utils.aoa_to_sheet([
            ["Label", "Value"],
            ...datasets[selected].labels.map((label, i) => [label, datasets[selected].data[i]])
        ]);
        XLSX.utils.book_append_sheet(wb, ws, "Report");
        XLSX.writeFile(wb, "analytics_report.xlsx");
    }

    document.getElementById("chartSelect").addEventListener("change", () => renderChart(currentType));
    renderChart(currentType);
</script>
</body>
</html>
