<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.polideportivojsp.models.Usuario" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Usuario> conversaciones = (List<Usuario>) request.getAttribute("conversaciones");
    if (conversaciones == null) {
        response.sendRedirect("MensajeServlet");
        return;
    }
    List<Usuario> resultados = (List<Usuario>) request.getAttribute("resultados");
    List<String[]> mensajes = (List<String[]>) request.getAttribute("mensajes");
    Integer otroId = (Integer) request.getAttribute("otroId");
    Usuario otroUsuario = (Usuario) request.getAttribute("otroUsuario");
    String query = (String) request.getAttribute("query");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mensajes - Polideportivo Martos</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', Arial, sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
        }

        header {
            background: linear-gradient(135deg, #1a252f 0%, #2c3e50 60%, #34495e 100%);
            color: white;
            padding: 16px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 12px rgba(0,0,0,0.25);
        }

        header h1 { font-size: 20px; font-weight: 700; }

        .nav-links { display: flex; gap: 10px; }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            background: rgba(255,255,255,0.12);
            padding: 8px 16px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.15);
            transition: background 0.2s;
        }

        .nav-links a:hover { background: rgba(255,255,255,0.22); }

        .chat-container {
            max-width: 1050px;
            margin: 28px auto;
            padding: 0 20px;
            display: flex;
            gap: 18px;
            height: calc(100vh - 120px);
        }

        .panel-izq {
            width: 290px;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .card-titulo {
            background: #1a252f;
            color: white;
            padding: 12px 16px;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0;
        }

        .buscador {
            display: flex;
            padding: 10px;
            gap: 8px;
        }

        .buscador input {
            flex: 1;
            padding: 8px 12px;
            border: 2px solid #dde1e7;
            border-radius: 8px;
            font-size: 13px;
            font-family: 'Inter', Arial, sans-serif;
        }

        .buscador input:focus {
            outline: none;
            border-color: #3498db;
        }

        .buscador button {
            padding: 8px 14px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            transition: background 0.2s;
        }

        .buscador button:hover { background: #2980b9; }

        .usuario-item {
            display: flex;
            align-items: center;
            padding: 10px 14px;
            cursor: pointer;
            border-bottom: 1px solid #f5f5f5;
            text-decoration: none;
            color: #2c3e50;
            font-size: 13px;
            font-weight: 500;
            transition: background 0.15s;
        }

        .usuario-item:hover { background: #f8f9fb; }

        .avatar {
            width: 34px;
            height: 34px;
            background: linear-gradient(135deg, #2980b9, #3498db);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            margin-right: 10px;
            font-size: 13px;
            flex-shrink: 0;
        }

        .vacio {
            padding: 16px;
            text-align: center;
            color: #bbb;
            font-size: 13px;
        }

        .panel-der {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .chat-header {
            background: white;
            border-radius: 12px 12px 0 0;
            padding: 14px 20px;
            border-bottom: 1px solid #f0f4f8;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            font-weight: 700;
            color: #1a252f;
            font-size: 15px;
        }

        .chat-mensajes {
            flex: 1;
            background: #f0f4f8;
            padding: 16px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .burbuja {
            max-width: 68%;
            padding: 10px 14px;
            border-radius: 14px;
            font-size: 14px;
            line-height: 1.45;
        }

        .burbuja .fecha {
            font-size: 11px;
            opacity: 0.65;
            margin-top: 5px;
            text-align: right;
        }

        .chat-input {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 12px 14px;
            display: flex;
            gap: 10px;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
        }

        .chat-input textarea {
            flex: 1;
            padding: 10px 14px;
            border: 2px solid #dde1e7;
            border-radius: 9px;
            font-size: 14px;
            resize: none;
            height: 44px;
            font-family: 'Inter', Arial, sans-serif;
            color: #222;
            transition: border-color 0.2s;
        }

        .chat-input textarea:focus {
            outline: none;
            border-color: #3498db;
        }

        .chat-input button {
            padding: 10px 22px;
            background: linear-gradient(135deg, #2980b9, #3498db);
            color: white;
            border: none;
            border-radius: 9px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            transition: opacity 0.2s;
        }

        .chat-input button:hover { opacity: 0.9; }

        .sin-chat {
            flex: 1;
            background: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #bbb;
            font-size: 15px;
            font-weight: 500;
            flex-direction: column;
            gap: 10px;
        }

        .error-msg {
            background: #fdecea;
            color: #c0392b;
            padding: 10px 16px;
            font-size: 13px;
            font-weight: 500;
            border-left: 3px solid #e74c3c;
        }

        @media (max-width: 640px) {
            .chat-container { flex-direction: column; height: auto; }
            .panel-izq { width: 100%; }
        }
    </style>
</head>
<body>

<header>
    <h1>Polideportivo Martos</h1>
    <div class="nav-links">
        <a href="index.jsp">Ver Pistas</a>
        <a href="panel.jsp">Mi Panel</a>
        <a href="LogoutServlet">Cerrar Sesión</a>
    </div>
</header>

<div class="chat-container">

    <div class="panel-izq">
        <div class="card">
            <div class="card-titulo">Buscar usuario</div>
            <form method="get" action="MensajeServlet" class="buscador">
                <label>
                    <input type="text" name="buscar"
                           placeholder="Buscar..."
                           value="<%= query != null ? query : "" %>">
                </label>
                <button type="submit">Buscar</button>
            </form>

            <% if (resultados != null) { %>
            <% if (resultados.isEmpty()) { %>
            <p class="vacio">Sin resultados</p>
            <% } else { %>
            <% for (Usuario u : resultados) { %>
            <a href="MensajeServlet?con=<%= u.getId() %>"
               class="usuario-item <%= otroId != null && otroId == u.getId() ? "activo" : "" %>">
                <div class="avatar"><%= u.getUsername().substring(0,1).toUpperCase() %></div>
                <%= u.getUsername() %>
            </a>
            <% } %>
            <% } %>
            <% } %>
        </div>

        <div class="card">
            <div class="card-titulo">Conversaciones</div>
            <% if (conversaciones == null || conversaciones.isEmpty()) { %>
            <p class="vacio">No hay conversaciones</p>
            <% } else { %>
            <% for (Usuario u : conversaciones) { %>
            <a href="MensajeServlet?con=<%= u.getId() %>"
               class="usuario-item <%= otroId != null && otroId == u.getId() ? "activo" : "" %>">
                <div class="avatar"><%= u.getUsername().substring(0,1).toUpperCase() %></div>
                <%= u.getUsername() %>
            </a>
            <% } %>
            <% } %>
        </div>
    </div>

    <div class="panel-der">
        <% if (otroId == null) { %>
        <div class="sin-chat">
            <span>Selecciona una conversación o busca un usuario</span>
        </div>
        <% } else { %>
        <div class="card" style="flex:1; display:flex; flex-direction:column; border-radius:12px;">
            <div class="chat-header">
                <%= otroUsuario != null ? otroUsuario.getUsername() : "Usuario" %>
            </div>

            <% if ("vacio".equals(error) || "vacío".equals(error)) { %>
            <div class="error-msg">El mensaje no puede estar vacío</div>
            <% } %>

            <div class="chat-mensajes" id="chatMensajes">
                <% if (mensajes == null || mensajes.isEmpty()) { %>
                <p style="text-align:center;color:#bbb;font-size:13px;margin-top:20px;">
                    No hay mensajes aún. Se el primero en escribir
                </p>
                <% } else { %>
                <% for (String[] m : mensajes) { %>
                <% boolean esEnviado = String.valueOf(usuario.getId()).equals(m[1]); %>
                <div class="burbuja <%= esEnviado ? "enviado" : "recibido" %>">
                    <%= m[3] != null ? m[3].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;") : "" %>
                    <div class="fecha"><%= m[4] != null && m[4].length() >= 16 ? m[4].substring(0, 16) : (m[4] != null ? m[4] : "") %></div>
                </div>
                <% } %>
                <% } %>
            </div>

            <div class="chat-input">
                <form method="post" action="MensajeServlet" style="display:flex; gap:10px; width:100%;">
                    <input type="hidden" name="accion" value="enviar">
                    <input type="hidden" name="destinatarioId" value="<%= otroId %>">
                    <label>
<textarea name="contenido"
          placeholder="Escribe un mensaje..."
          onkeydown="if(event.key==='Enter' && !event.shiftKey){event.preventDefault();this.form.submit();}"></textarea>
                    </label>
                    <button type="submit">Enviar</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>

</div>

<script>
    const chat = document.getElementById('chatMensajes');
    if (chat) chat.scrollTop = chat.scrollHeight;
</script>

</body>
</html>
