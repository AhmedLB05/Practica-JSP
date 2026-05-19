<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Polideportivo Martos</title>
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
            padding: 24px 0;
        }

        .card {
            background: white;
            padding: 44px 40px 36px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.35);
            width: 100%;
            max-width: 420px;
        }

        .logo {
            text-align: center;
            margin-bottom: 28px;
        }

        .logo h2 {
            color: #1a252f;
            font-size: 22px;
            font-weight: 700;
        }

        .logo p {
            color: #888;
            font-size: 13px;
            margin-top: 4px;
        }

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
            border-color: #27ae60;
            box-shadow: 0 0 0 3px rgba(39,174,96,0.12);
        }

        .campo-req { font-size: 11px; color: #aaa; font-weight: 400; margin-left: 4px; }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #1e8449, #27ae60);
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

        .pie {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #888;
        }

        .pie a { color: #3498db; text-decoration: none; font-weight: 600; }
        .pie a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <h2>Crear cuenta</h2>
        <p>Completa el formulario para registrarte</p>
    </div>

    <% if (error != null) { %>
    <div class="alerta-error"><%= error %></div>
    <% } %>

    <form method="post" action="RegistroServlet">
        <label>Usuario <span class="campo-req">obligatorio</span></label>
        <label>
            <input type="text" name="username" placeholder="Elige un nombre de usuario" required>
        </label>

        <label>Contraseña <span class="campo-req">Obligatorio, minimo 8 caracteres</span></label>
        <label>
            <input type="password" name="password" placeholder="Tu contraseña" required>
        </label>

        <label>Nombre completo <span class="campo-req">obligatorio</span></label>
        <label>
            <input type="text" name="nombre" placeholder="Tu nombre completo" required>
        </label>

        <label>Email</label>
        <label>
            <input type="email" name="email" placeholder="Tu email">
        </label>

        <label>Teléfono</label>
        <label>
            <input type="tel" name="telefono" placeholder="Tu numero de teléfono">
        </label>

        <button type="submit">Crear cuenta</button>
    </form>

    <div class="pie">
        Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
    </div>
</div>
</body>
</html>