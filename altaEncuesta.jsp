<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Alta Encuesta</title>
        <link rel="stylesheet" type="text/css" href="tabla.css"> <!-- Asegúrate de tener este archivo CSS -->
        <link rel="stylesheet" type="text/css" href="tabla2.css">
    </head>
<body>
    <div class="container">
        <div class="header">
            <h2>Alta de Nueva Encuesta</h2>
        </div>

        <!-- Apartado de Instrucciones -->
        <div class="instructions">
            <h3>Instrucciones:</h3>
            <ul>
                <li>Llena el campo de <strong>Pregunta</strong> con la pregunta de tu encuesta.</li>
                <li>Para cada opción, ingresa un texto en los campos de <strong>Opción 1 a Opción 6</strong>.</li>
                <li>Si no llenas un campo de opción, esa opción no se agregará a la encuesta.</li>
                <li>Al finalizar, haz clic en el botón <strong>Guardar Encuesta</strong>.</li>
            </ul>
        </div>

        <form action="guardarAltaEncuesta.jsp" method="post">
            <div class="form-row">
                <label for="pregunta">Pregunta:</label><br>
                <input type="text" id="pregunta" name="pregunta" required>
            </div>

            <label>Opciones:</label>
            <table>
                <thead>
                    <tr>
                        <th>Opción 1</th>
                        <th>Opción 2</th>
                        <th>Opción 3</th>
                        <th>Opción 4</th>
                        <th>Opción 5</th>
                        <th>Opción 6</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="table-row">
                        <td><input type="text" name="opciones[]" placeholder="Opción 1" required></td>
                        <td><input type="text" name="opciones[]" placeholder="Opción 2"></td>
                        <td><input type="text" name="opciones[]" placeholder="Opción 3"></td>
                        <td><input type="text" name="opciones[]" placeholder="Opción 4"></td>
                        <td><input type="text" name="opciones[]" placeholder="Opción 5"></td>
                        <td><input type="text" name="opciones[]" placeholder="Opción 6"></td>
                    </tr>
                </tbody>
            </table>

            <input type="submit" value="Guardar Encuesta">
            <a href="mostrarEncuestas.jsp">Mostrar preguntas</a>
        </form>
    </div>
</body>
</html>
