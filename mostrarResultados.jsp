<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, org.jfree.chart.*, org.jfree.chart.plot.*, org.jfree.data.category.*, org.jfree.chart.servlet.*, org.jfree.data.general.*, java.sql.*" %>
<%
    // Variables de conexión a la base de datos
    String url = "jdbc:postgresql://127.0.0.1/demo";
    String usuario = "azael";
    String password = "yo";

    // Inicialización de datos
    String pregunta = "";
    DefaultCategoryDataset datasetBarras = new DefaultCategoryDataset();
    DefaultPieDataset datasetPastel = new DefaultPieDataset();

    try {
        // Conexión a la base de datos
        Class.forName("org.postgresql.Driver");
        Connection conexion = DriverManager.getConnection(url, usuario, password);

        // Consulta de la encuesta activa
        String query = "SELECT pregunta, opciones, votos FROM Encuestas WHERE estado = true";
        PreparedStatement stmt = conexion.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            pregunta = rs.getString("pregunta");
            String[] opciones = rs.getString("opciones").split(",");
            String[] votos = rs.getString("votos").split(",");

            // Poblar datasets para gráficos
            for (int i = 0; i < opciones.length; i++) {
                String opcion = opciones[i];
                double voto = Double.parseDouble(votos[i]);
                datasetBarras.addValue(voto, "Votos", opcion);
                datasetPastel.setValue(opcion, voto);
            }
        }

        // Cerrar conexión
        rs.close();
        stmt.close();
        conexion.close();
    } catch (Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }

    // Crear gráfico de barras
    JFreeChart barChart = ChartFactory.createBarChart(
        "Resultados de la Encuesta", "Opciones", "Votos", datasetBarras, 
        PlotOrientation.VERTICAL, false, true, false
    );
    String barChartFilename = ServletUtilities.saveChartAsPNG(barChart, 600, 400, null, session);

    // Crear gráfico de pastel
    JFreeChart pieChart = ChartFactory.createPieChart(
        "Distribución de Votos", datasetPastel, true, true, false
    );
    String pieChartFilename = ServletUtilities.saveChartAsPNG(pieChart, 600, 400, null, session);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados de la Encuesta</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
    <div class="container">
        <h1>Resultados de la Encuesta Activa</h1>
        <h2>Pregunta: <%= pregunta %></h2>
        
        <div class="charts">
            <div class="chart">
                <h3>Gráfico de Barras</h3>
                <img src="<%= request.getContextPath() %>/DisplayChart?filename=<%= barChartFilename %>" alt="Gráfico de Barras">
            </div>
            <div class="chart">
                <h3>Gráfico de Pastel</h3>
                <img src="<%= request.getContextPath() %>/DisplayChart?filename=<%= pieChartFilename %>" alt="Gráfico de Pastel">
            </div>
        </div>

        <div class="footer">
            <a href="mostrarEncuestas.jsp" class="button">Volver al Inicio</a>
        </div>
    </div>
</body>
</html>