<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuario") != null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Polideportivo Martos</title>
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
            max-width: 390px;
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

        input[type="text"],
        input[type="password"] {
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

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.12);
        }

        .opciones-login {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .opciones-login label {
            display: flex;
            align-items: center;
            gap: 7px;
            cursor: pointer;
            color: #555;
            font-weight: 500;
            margin-bottom: 0;
        }

        .opciones-login input[type="checkbox"] {
            width: auto;
            margin: 0;
            padding: 0;
            accent-color: #3498db;
        }

        .opciones-login a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            font-size: 13px;
        }

        .opciones-login a:hover { text-decoration: underline; }

        .aviso-clave {
            background: #eaf4fd;
            border-left: 4px solid #3498db;
            color: #1a5276;
            padding: 10px 14px;
            border-radius: 9px;
            font-size: 13px;
            margin-bottom: 18px;
            display: none;
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #2980b9, #3498db);
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

        .alerta-ok {
            background: #eafaf1;
            color: #1e6b3c;
            border-left: 4px solid #27ae60;
            padding: 11px 14px;
            border-radius: 9px;
            margin-bottom: 18px;
            font-size: 13px;
            font-weight: 500;
        }

        .separador {
            text-align: center;
            color: #bbb;
            font-size: 13px;
            margin: 18px 0;
            position: relative;
        }

        .separador::before,
        .separador::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #e0e0e0;
        }

        .separador::before { left: 0; }
        .separador::after { right: 0; }

        .btn-invitado {
            display: block;
            text-align: center;
            padding: 11px;
            background: #f5f6fa;
            color: #555;
            border-radius: 9px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            border: 2px solid #dde1e7;
            transition: background 0.2s;
        }

        .btn-invitado:hover { background: #eaecf2; }

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
        <h2>Polideportivo Martos</h2>
        <p>Accede a tu cuenta para gestionar reservas</p>
    </div>

    <% if (error != null) { %>
    <div class="alerta-error"><%= error %></div>
    <% } %>

    <%
        String msg = request.getParameter("msg");
        if ("registro_ok".equals(msg)) {
    %>
    <div class="alerta-ok">Cuenta creada correctamente. Ya puedes iniciar sesión</div>
    <% } %>

    <form method="post" action="LoginServlet">
        <label>Usuario</label>
        <label>
            <input type="text" name="username" placeholder="Nombre de usuario" required>
        </label>

        <label>Contraseña</label>
        <label>
            <input type="password" name="password" placeholder="Tu contraseña" required>
        </label>

        <div class="opciones-login">
            <label>
                <input type="checkbox" name="recuérdame" value="1"> Recuérdame
            </label>
            <a href="#" onclick="mostrarAvisoClave(); return false;">¿Contraseña olvidada?</a>
        </div>

        <div class="aviso-clave" id="avisoClave">
            Contacta con el administrador del polideportivo para recuperar tu contraseña.
        </div>

        <button type="submit">Iniciar sesión</button>
    </form>

    <script>
        function mostrarAvisoClave() {
            const aviso = document.getElementById('avisoClave');
            aviso.style.display = aviso.style.display === 'block' ? 'none' : 'block';
        }
    </script>

    <div class="separador">o</div>

    <a href="index.jsp" class="btn-invitado">Continuar como invitado</a>

    <div class="pie">
        ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
    </div>
</div>
</body>
</html>