<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html lang="es">
<head>
    <title>Modificar Encuesta</title>
    <link rel="stylesheet" type="text/css" href="tabla.css"> <!-- Asegúrate de tener este archivo CSS -->
    <meta charset="UTF-8"><meta charset="UTF-8">
</head>
<body>
    <div class="header">
        <h2>Modificar Encuesta</h2>
    </div>
    <div class="container">
        <%
            int encuestaId = Integer.parseInt(request.getParameter("id")); // Obtener ID de la encuesta a modificar
            try {
                // Paso 1: Registrar el driver
                Class.forName("org.postgresql.Driver");

                // Paso 2: Establecer la conexión con la base de datos
                String url = "jdbc:postgresql://127.0.0.1/demo";
                String usuario = "azael"; // Reemplaza con tu usuario
                String password = "yo"; // Reemplaza con tu contraseña
                Connection conexion = DriverManager.getConnection(url, usuario, password);

                // Paso 3: Preparar la consulta SQL para obtener los datos de la encuesta
                String query = "SELECT pregunta, opciones, votos, estado FROM Encuestas WHERE id = ?";
                PreparedStatement stmt = conexion.prepareStatement(query);
                stmt.setInt(1, encuestaId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String pregunta = rs.getString("pregunta");
                    String opciones = rs.getString("opciones");
                    String votos = rs.getString("votos");
                    boolean estado = rs.getBoolean("estado");

                    // Paso 4: Cerrar recursos de la consulta
                    rs.close();
        %>
        <!-- Formulario para modificar la encuesta -->
        <form action="guardarModificacionEncuesta.jsp" method="post">
            <input type="hidden" name="id" value="<%= encuestaId %>">
            
            <label for="pregunta">Pregunta:</label><br>
            <input type="text" id="pregunta" name="pregunta" value="<%= pregunta %>" required><br><br>

            <label for="opciones">Opciones (separadas por coma):</label><br>
            <input type="text" id="opciones" name="opciones" value="<%= opciones %>" required><br><br>

            <label for="votos">Votos (separados por coma):</label><br>
            <input type="text" id="votos" name="votos" value="<%= votos %>" required><br><br>

            <label for="estado">Estado:</label><br>
            <select name="estado" id="estado">
                <option value="true" <%= estado ? "selected" : "" %>>Activa</option>
                <option value="false" <%= !estado ? "selected" : "" %>>Inactiva</option>
            </select><br><br>

            <input type="submit" value="Guardar Modificación">
        </form>

        <%
                } else {
        %>
        <p>Encuesta no encontrada.</p>
        <%
                }

                // Cerrar recursos
                stmt.close();
                conexion.close();
            } catch (Exception e) {
        %>
        <div class="error-message">
            <p>Error: <%= e.getMessage() %></p>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>
