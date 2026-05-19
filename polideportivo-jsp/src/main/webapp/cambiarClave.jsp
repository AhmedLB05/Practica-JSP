<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.polideportivojsp.models.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cambiar Contrasena - Polideportivo Martos</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, #1a252f 0%, #2c3e50 50%, #34495e 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .card {
            background: white;
            padding: 44px 40px 36px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.35);
            width: 100%;
            max-width: 420px;
        }

        .logo { text-align: center; margin-bottom: 28px; }
        .logo h2 { color: #1a252f; font-size: 22px; font-weight: 700; }
        .logo p { color: #888; font-size: 13px; margin-top: 4px; }

        label {
            display: block;
            margin-bottom: 6px;
            color: #444;
            font-size: 13px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 11px 14px;
            border: 2px solid #dde1e7;
            border-radius: 9px;
            margin-bottom: 16px;
            font-size: 14px;
            font-family: 'Inter', Arial, sans-serif;
            color: #222;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231,76,60,0.12);
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            color: white;
            border: none;
            border-radius: 9px;
            font-size: 15px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        button[type="submit"]:hover { opacity: 0.9; }

        .alerta-error {
            background: #fdecea;
            color: #c0392b;
            padding: 11px 14px;
            border-radius: 9px;
            margin-bottom: 18px;
            text-align: center;
            font-size: 13px;
            font-weight: 500;
            border-left: 4px solid #e74c3c;
        }

        .pie { text-align: center; margin-top: 18px; font-size: 13px; }
        .pie a { color: #3498db; text-decoration: none; font-weight: 600; }
        .pie a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <h2>Cambiar contraseña</h2>
        <p>Introduce tu contraseña actual y la nueva</p>
    </div>

    <% if (error != null) { %>
    <div class="alerta-error"><%= error %></div>
    <% } %>

    <form method="post" action="CambiarClaveServlet">
        <label>Contraseña actual</label>
        <label>
            <input type="password" name="claveActual" placeholder="Tu contraseña actual" required>
        </label>

        <label>Nueva contraseña</label>
        <label>
            <input type="password" name="claveNueva" placeholder="Nueva contraseña" required>
        </label>

        <label>Repetir nueva contraseña</label>
        <label>
            <input type="password" name="claveRepetir" placeholder="Repite la nueva contraseña" required>
        </label>

        <button type="submit">Cambiar contraseña</button>
    </form>

    <div class="pie">
        <a href="panel.jsp">Volver al panel</a>
    </div>
</div>
</body>
</html>