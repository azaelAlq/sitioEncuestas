<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*" %>
<%
    // Variables de conexión a la base de datos
    String url = "jdbc:postgresql://127.0.0.1/demo";
    String usuario = "azael";
    String password = "yo";

    // Inicialización de datos
    String pregunta = "";
    String[] opciones = null;
    int encuestaId = 0;

    try {
        // Conexión a la base de datos
        Class.forName("org.postgresql.Driver");
        Connection conexion = DriverManager.getConnection(url, usuario, password);

        // Consulta de la encuesta activa
        String query = "SELECT id, pregunta, opciones FROM Encuestas WHERE estado = true";
        PreparedStatement stmt = conexion.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            encuestaId = rs.getInt("id");
            pregunta = rs.getString("pregunta");
            opciones = rs.getString("opciones").split(",");
        }

        // Cerrar conexión
        rs.close();
        stmt.close();
        conexion.close();
    } catch (Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Votar</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>
    <div class="container">
        <h1>Votar en la Encuesta Activa</h1>
        <h2>Pregunta: <%= pregunta %></h2>

        <form method="POST" action="registrarVoto.jsp">
            <input type="hidden" name="encuestaId" value="<%= encuestaId %>">
            <div class="opciones">
                <%
                    if (opciones != null) {
                        for (int i = 0; i < opciones.length; i++) {
                %>
                <div class="opcion">
                    <input type="radio" id="opcion<%= i %>" name="opcion" value="<%= i %>" required>
                    <label for="opcion<%= i %>"><%= opciones[i] %></label>
                </div>
                <%
                        }
                %>
                <div class="submit-container">
                    <button type="submit" class="button">Votar</button>
                    <a href="mostrarEncuestas.jsp" class="button">Volver a Encuestas</a>
                </div>
                <%
                    } else {
                %>
                <p>No hay una encuesta activa actualmente.</p>
                <div class="submit-container">
                    <a href="mostrarEncuestas.jsp" class="button">Volver a Encuestas</a>
                </div>
                <%
                    }
                %>
            </div>
        </form>
    </div>
</body>
</html>
