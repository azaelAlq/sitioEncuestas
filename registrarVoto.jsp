<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Variables de conexión a la base de datos
    String url = "jdbc:postgresql://127.0.0.1/demo";
    String usuario = "azael";
    String password = "yo";

    // Obtener parámetros enviados desde votar.jsp
    int encuestaId = Integer.parseInt(request.getParameter("encuestaId").trim());
    int opcionSeleccionada = Integer.parseInt(request.getParameter("opcion").trim());

    try {
        // Conexión a la base de datos
        Class.forName("org.postgresql.Driver");
        Connection conexion = DriverManager.getConnection(url, usuario, password);

        // Consulta para obtener los votos actuales
        String query = "SELECT votos FROM Encuestas WHERE id = ?";
        PreparedStatement stmt = conexion.prepareStatement(query);
        stmt.setInt(1, encuestaId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            // Obtener y actualizar los votos
            String[] votos = rs.getString("votos").split(",");
            int[] votosActuales = new int[votos.length];

            for (int i = 0; i < votos.length; i++) {
                votosActuales[i] = Integer.parseInt(votos[i].trim()); // Eliminar espacios antes de convertir
            }

            // Incrementar el voto para la opción seleccionada
            votosActuales[opcionSeleccionada]++;

            // Convertir los votos actualizados a un string separado por comas
            StringBuilder votosActualizados = new StringBuilder();
            for (int i = 0; i < votosActuales.length; i++) {
                votosActualizados.append(votosActuales[i]);
                if (i < votosActuales.length - 1) votosActualizados.append(", ");
            }

            // Actualizar los votos en la base de datos
            String updateQuery = "UPDATE Encuestas SET votos = ? WHERE id = ?";
            PreparedStatement updateStmt = conexion.prepareStatement(updateQuery);
            updateStmt.setString(1, votosActualizados.toString());
            updateStmt.setInt(2, encuestaId);
            updateStmt.executeUpdate();

            // Cerrar recursos
            updateStmt.close();
        }

        // Cerrar conexión
        rs.close();
        stmt.close();
        conexion.close();

        // Redirigir a mostrarResultados.jsp
        response.sendRedirect("mostrarResultados.jsp");
    } catch (Exception e) {
        out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
    }
%>
