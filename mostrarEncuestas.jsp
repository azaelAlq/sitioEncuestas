<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<html>
<head>
    <meta charset="UTF-8">
    <title>Listado de Encuestas</title>
    <link rel="stylesheet" type="text/css" href="tabla.css"> <!-- Asegúrate de tener este archivo CSS -->
</head>
<body>
    <div class="header">
        <h2>Listado de Encuestas</h2>
    </div>
    <div class="container">
        <%
            try {
                // Paso 1: Registrar el driver
                Class.forName("org.postgresql.Driver");

                // Paso 2: Establecer la conexión con la base de datos
                String url = "jdbc:postgresql://127.0.0.1/demo"; // Reemplaza con tu base de datos
                String usuario = "azael"; // Reemplaza con tu usuario
                String password = "yo"; // Reemplaza con tu contraseña
                Connection conexion = DriverManager.getConnection(url, usuario, password);

                // Paso 3: Preparar la consulta SQL para obtener todas las encuestas (activas e inactivas)
                String query = "SELECT id, pregunta, opciones, votos, estado FROM Encuestas ORDER BY id";
                Statement stmt = conexion.createStatement();
                ResultSet rs = stmt.executeQuery(query);

                // Mostrar los resultados en una tabla
        %>
        <table class="styled-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Pregunta</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                    <th>Opción</th>
                    <th>Votos</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String pregunta = rs.getString("pregunta");
                        String opciones = rs.getString("opciones");
                        String votos = rs.getString("votos");
                        boolean estado = rs.getBoolean("estado");

                        // Convertir las opciones y los votos a arrays
                        String[] opcionesArray = opciones.split(", ");
                        String[] votosArray = votos.split(", ");
                %>
                <!-- Mostrar cada pregunta -->
                <tr>
                    <td rowspan="<%= opcionesArray.length %>"><%= rs.getInt("id") %></td>
                    <td rowspan="<%= opcionesArray.length %>"><%= pregunta %></td>
                    <td rowspan="<%= opcionesArray.length %>"><%= estado ? "Activa" : "Inactiva" %></td>
                    <td rowspan="<%= opcionesArray.length %>">
                        <!-- Botones de modificar y eliminar para cada pregunta -->
                        <a href="modificarEncuesta.jsp?id=<%= rs.getInt("id") %>">
                            <button class="btn-modifyM">Modificar</button>
                        </a>
                        <a href="eliminarEncuesta.jsp?id=<%= rs.getInt("id") %>">
                            <button class="btn-modifyD">Eliminar</button>
                        </a>
                    </td>
                    <%
                        // Mostrar las opciones y votos en las filas correspondientes
                        for (int i = 0; i < opcionesArray.length; i++) {
                            int votosEntero = Integer.parseInt(votosArray[i]); // Convertimos los votos a enteros
                            if (i > 0) out.println("<tr>");
                    %>
                    <td><%= opcionesArray[i] %></td>
                    <td><%= votosEntero %></td>
                    <%
                        }
                    %>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <p></p>
        <a href="altaEncuesta.jsp">
            <button class="btn-modifyD">Registrar Nueva Encuesta</button>
        </a>
        <a href="votar.jsp">
            <button class="btn-modifyM">Votar</button>
        </a>
        <a href="mostrarResultados.jsp">
            <button class="btn-modifyD">Mostrar resultados de la pregunta</button>
        </a>
        <%
                // Cerrar recursos
                rs.close();
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
