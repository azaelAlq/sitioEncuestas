<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Guardar Nueva Encuesta</title>
    <link rel="stylesheet" type="text/css" href="tabla.css"> <!-- Asegúrate de tener este archivo CSS -->
</head>
<body>
    <div class="container">
        <%
            // Obtener los parámetros del formulario
            String pregunta = request.getParameter("pregunta");

            // Recoger las opciones del formulario
            String[] opcionesArray = request.getParameterValues("opciones[]");

            // Filtrar las opciones vacías
            StringBuilder opcionesBuilder = new StringBuilder();
            for (int i = 0; i < opcionesArray.length; i++) {
                if (opcionesArray[i] != null && !opcionesArray[i].trim().isEmpty()) {
                    if (opcionesBuilder.length() > 0) {
                        opcionesBuilder.append(", ");  // Añadir coma si no es la primera opción
                    }
                    opcionesBuilder.append(opcionesArray[i].trim());
                }
            }

            // Convertir las opciones a una cadena separada por comas
            String opciones = opcionesBuilder.toString();

            // Configuramos el estado como 'false' por defecto
            boolean estado = false;  // Estado inactivo por defecto

            // Inicializar votos a 0 para cada opción
            StringBuilder votosBuilder = new StringBuilder();
            String[] opcionesFinalArray = opciones.split(", ");
            for (int i = 0; i < opcionesFinalArray.length; i++) {
                votosBuilder.append("0");
                if (i < opcionesFinalArray.length - 1) {
                    votosBuilder.append(", ");  // Separar votos con coma
                }
            }
            String votos = votosBuilder.toString();

            try {
                // Paso 1: Registrar el driver
                Class.forName("org.postgresql.Driver");

                // Paso 2: Establecer la conexión
                String url = "jdbc:postgresql://127.0.0.1/demo";
                String usuario = "azael"; // Reemplaza con tu usuario
                String password = "yo"; // Reemplaza con tu contraseña
                Connection conexion = DriverManager.getConnection(url, usuario, password);

                // Paso 3: Preparar la consulta SQL para insertar la nueva encuesta
                String query = "INSERT INTO Encuestas (pregunta, opciones, votos, estado) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conexion.prepareStatement(query);
                stmt.setString(1, pregunta);
                stmt.setString(2, opciones);
                stmt.setString(3, votos);
                stmt.setBoolean(4, estado);

                // Paso 4: Ejecutar la consulta
                int filasAfectadas = stmt.executeUpdate();
                if (filasAfectadas > 0) {
        %>
                    <script>
                        alert("La encuesta se guardó correctamente.");
                        window.location = "mostrarEncuestas.jsp"; // Redirigir al listado de encuestas
                    </script>
        <%
                } else {
        %>
                    <div class="error-message">
                        <p>Error: No se pudo guardar la encuesta. Intenta de nuevo.</p>
                    </div>
        <%
                }

                // Cerrar los recursos
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
