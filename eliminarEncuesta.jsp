<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Eliminar Encuesta</title>
    <link rel="stylesheet" type="text/css" href="tabla.css">
</head>
<body>
    <div class="container">
        <%
            String id = request.getParameter("id"); // Obtener el ID de la encuesta
            out.println(id);
            if (id == null || id.isEmpty()) {
        %>
            <div class="error-message">
                <p>Error: No se proporcionó un ID de encuesta válido.</p>
            </div>
        <%
            } else {
                try {
                    // Paso 1: Registrar el driver
                    Class.forName("org.postgresql.Driver");

                    // Paso 2: Establecer la conexión con la base de datos
                    String url = "jdbc:postgresql://127.0.0.1/demo";
                    String usuario = "azael"; // Reemplaza con tu usuario
                    String password = "yo"; // Reemplaza con tu contraseña
                    Connection conexion = DriverManager.getConnection(url, usuario, password);

                    // Paso 3: Preparar la consulta SQL para eliminar la encuesta
                    String query = "DELETE FROM Encuestas WHERE id = ?";
                    PreparedStatement stmt = conexion.prepareStatement(query);
                    stmt.setInt(1, Integer.parseInt(id));

                    // Paso 4: Ejecutar la consulta
                    int filasAfectadas = stmt.executeUpdate();
                    if (filasAfectadas > 0) {
        %>
                        <script>
                            alert("La encuesta se eliminó correctamente.");
                            window.location = "mostrarEncuestas.jsp"; // Redirigir al listado de encuestas
                        </script>
        <%
                    } else {
        %>
                        <div class="error-message">
                            <p>Error: No se encontró la encuesta con el ID proporcionado.</p>
                        </div>
        <%
                    }
                    stmt.close();
                    conexion.close();
                } catch (Exception e) {
        %>
                    <div class="error-message">
                        <p>Error: <%= e.getMessage() %></p>
                    </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>
