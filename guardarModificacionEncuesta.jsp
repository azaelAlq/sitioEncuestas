<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Guardar Modificación de Encuesta</title>
    <link rel="stylesheet" type="text/css" href="tabla.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .success-message {
            color: #28a745;
            font-size: 18px;
            font-weight: bold;
        }
        .error-message {
            color: #dc3545;
            font-size: 18px;
            font-weight: bold;
        }
        .info-message {
            color: #6c757d;
            font-size: 16px;
        }
        .btn {
            display: inline-block;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        h1 {
            color: #343a40;
        }
        p {
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            int encuestaId = Integer.parseInt(request.getParameter("id"));
            String pregunta = request.getParameter("pregunta");
            String opciones = request.getParameter("opciones");
            String votos = request.getParameter("votos");
            boolean nuevoEstado = Boolean.parseBoolean(request.getParameter("estado"));
            boolean seDesactivoAnterior = false;

            try {
                Class.forName("org.postgresql.Driver");

                String url = "jdbc:postgresql://127.0.0.1/demo";
                String usuario = "azael";
                String password = "yo";
                Connection conexion = DriverManager.getConnection(url, usuario, password);

                if (nuevoEstado) {
                    String verificarEstadoQuery = "SELECT id FROM Encuestas WHERE estado = true";
                    PreparedStatement verificarStmt = conexion.prepareStatement(verificarEstadoQuery);
                    ResultSet rs = verificarStmt.executeQuery();

                    if (rs.next()) {
                        int encuestaActivaId = rs.getInt("id");

                        if (encuestaActivaId != encuestaId) {
                            String desactivarQuery = "UPDATE Encuestas SET estado = false WHERE id = ?";
                            PreparedStatement desactivarStmt = conexion.prepareStatement(desactivarQuery);
                            desactivarStmt.setInt(1, encuestaActivaId);
                            desactivarStmt.executeUpdate();
                            desactivarStmt.close();
                            seDesactivoAnterior = true;
                        }
                    }
                    rs.close();
                    verificarStmt.close();
                }

                String query = "UPDATE Encuestas SET pregunta = ?, opciones = ?, votos = ?, estado = ? WHERE id = ?";
                PreparedStatement stmt = conexion.prepareStatement(query);
                stmt.setString(1, pregunta);
                stmt.setString(2, opciones);
                stmt.setString(3, votos);
                stmt.setBoolean(4, nuevoEstado);
                stmt.setInt(5, encuestaId);

                int filasActualizadas = stmt.executeUpdate();

                stmt.close();
                conexion.close();

                if (filasActualizadas > 0) {
                    if (nuevoEstado) {
        %>
        <h1>Pregunta Actualizada</h1>
        <p class="success-message">La pregunta "<%= pregunta %>" ahora está activa.</p>
        <%
                        if (seDesactivoAnterior) {
        %>
        <p class="info-message">Las preguntas activas anteriores fueron desactivadas.</p>
        <%
                        }
                    } else {
        %>
        <h1>Pregunta Actualizada</h1>
        <p class="success-message">La pregunta "<%= pregunta %>" ahora está inactiva.</p>
        <%
                    }
        %>
        <a href="mostrarEncuestas.jsp" class="btn">Volver al listado de preguntas</a>
        <%
                } else {
        %>
        <h1>Error al Actualizar</h1>
        <p class="error-message">No se pudo actualizar la pregunta. Inténtelo de nuevo más tarde.</p>
        <a href="mostrarEncuestas.jsp" class="btn">Volver al listado de preguntas</a>
        <%
                }
            } catch (Exception e) {
        %>
        <h1>Error</h1>
        <p class="error-message">Ocurrió un error: <%= e.getMessage() %></p>
        <a href="mostrarEncuestas.jsp" class="btn">Volver al listado de preguntas</a>
        <%
            }
        %>
    </div>
</body>
</html>
