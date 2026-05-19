<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.polideportivojsp.models.Usuario" %>
<%@ page import="org.example.polideportivojsp.models.Reserva" %>
<%@ page import="org.example.polideportivojsp.DAO.ReservaDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    LocalDate hoy = LocalDate.now();
    LocalDate finSemana = hoy.plusDays(6);
    ReservaDAO reservaDAO = new ReservaDAO();
    List<Reserva> reservasSemana = reservaDAO.getReservasSemana(hoy, finSemana);
    String[] pistas = {"futbol_1", "futbol_2", "tenis_1", "tenis_2", "tenis_3", "tenis_4"};
    String[] pistasNombres = {"Futbol sala 1", "Futbol sala 2", "Tenis 1", "Tenis 2", "Tenis 3", "Tenis 4"};
    int[] horas = {9,10,11,12,13,16,17,18,19,20,21,22};
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Polideportivo Martos</title>
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

        header h1 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.3px;
        }

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

        .contenido {
            max-width: 1150px;
            margin: 32px auto;
            padding: 0 20px;
        }

        .page-title {
            text-align: center;
            color: #1a252f;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        .alerta {
            padding: 13px 18px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 14px;
            font-weight: 500;
        }

        .alerta-ok {
            background: #eafaf1;
            border-left: 4px solid #27ae60;
            color: #1e6b3c;
        }

        .alerta-aviso {
            background: #fef9e7;
            border-left: 4px solid #f39c12;
            color: #7d6608;
        }

        .alerta-info {
            background: #eaf4fd;
            border-left: 4px solid #3498db;
            color: #1a5276;
        }

        .alerta-info a { color: #2980b9; font-weight: 600; }

        .selector-pistas {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 24px;
        }

        .btn-pista {
            padding: 9px 18px;
            border-radius: 8px;
            border: 2px solid #2c3e50;
            background: white;
            color: #2c3e50;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            transition: all 0.2s;
        }

        .btn-pista:hover,
        .btn-pista.activo {
            background: #2c3e50;
            color: white;
        }

        .pista-tabla {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .oculto { display: none; }

        .pista-titulo {
            background: linear-gradient(135deg, #1a252f, #2c3e50);
            color: white;
            padding: 14px 20px;
            font-size: 15px;
            font-weight: 600;
        }

        .tabla-wrapper { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        thead th {
            background: #34495e;
            color: white;
            padding: 10px 8px;
            text-align: center;
            font-weight: 600;
        }

        thead th:first-child { text-align: left; padding-left: 16px; }

        tbody td {
            padding: 8px 6px;
            text-align: center;
            border-bottom: 1px solid #f0f4f8;
        }

        tbody td:first-child {
            font-weight: 600;
            color: #445;
            white-space: nowrap;
            text-align: left;
            padding-left: 16px;
        }

        tbody tr:hover td { background: #fafbfd; }

        .badge-libre {
            background: #27ae60;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge-ocupado {
            background: #e74c3c;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }

        .badge-ocupado:hover { background: #c0392b; }

        .btn-reservar {
            background: #27ae60;
            color: white;
            border: none;
            padding: 5px 12px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 11px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            transition: background 0.2s;
        }

        .btn-reservar:hover { background: #1e8449; }
    </style>
</head>
<body>

<header>
    <h1>Polideportivo Martos</h1>
    <div class="nav-links">
        <% if (usuarioLogueado != null) { %>
        <a href="panel.jsp">Mi Panel</a>
        <a href="LogoutServlet">Cerrar Sesión</a>
        <% } else { %>
        <a href="login.jsp">Iniciar Sesión</a>
        <a href="registro.jsp">Registrarse</a>
        <% } %>
    </div>
</header>

<div class="contenido">
    <%
        String msg = request.getParameter("msg");
        if ("reserva_ok".equals(msg)) {
    %>
    <div class="alerta alerta-ok">Reserva realizada correctamente</div>
    <% } else if ("reserva_error".equals(msg)) { %>
    <div class="alerta alerta-aviso">Ese horario ya está reservado. Elige otro</div>
    <% } %>

    <%
        String errorAttr = (String) request.getAttribute("error");
        if (errorAttr != null) {
    %>
    <div class="alerta alerta-aviso"><%= errorAttr %></div>
    <% } %>

    <% if (usuarioLogueado != null) { %>
    <div class="alerta alerta-ok">
        Bienvenido, <strong><%= usuarioLogueado.getNombre() %></strong>. Haz clic en un hueco libre para reservar
    </div>
    <% } else { %>
    <div class="alerta alerta-info">
        Estas viendo la disponibilidad como invitado. <a href="login.jsp">Inicia sesión</a> para poder reservar
    </div>
    <% } %>

    <h2 class="page-title">Disponibilidad de Pistas</h2>

    <div class="selector-pistas">
        <% for (int i = 0; i < pistas.length; i++) {
            String claseBoton = (i == 0) ? "btn-pista activo" : "btn-pista";
        %>
        <button class="<%= claseBoton %>"
                onclick="mostrarPista('<%= pistas[i] %>', this)">
            <%= pistasNombres[i] %>
        </button>
        <% } %>
    </div>

    <% for (int p = 0; p < pistas.length; p++) {
        String claseTabla = (p == 0) ? "pista-tabla" : "pista-tabla oculto";
    %>
    <div id="pista_<%= pistas[p] %>" class="<%= claseTabla %>">
        <div class="pista-titulo"><%= pistasNombres[p] %></div>
        <div class="tabla-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Hora</th>
                    <% for (int d = 0; d < 7; d++) {
                        LocalDate dia = hoy.plusDays(d);
                        String nombreDia = dia.getDayOfWeek().getDisplayName(TextStyle.SHORT, new Locale("es","ES"));
                    %>
                    <th><%= nombreDia %><br><small><%= dia %></small></th>
                    <% } %>
                </tr>
                </thead>
                <tbody>
                <% for (int hora : horas) { %>
                <tr>
                    <td><%= String.format("%02d:00", hora) %></td>
                    <% for (int d = 0; d < 7; d++) {
                        LocalDate dia = hoy.plusDays(d);
                        Reserva reservaEncontrada = null;
                        for (Reserva r : reservasSemana) {
                            if (r.getPista().equals(pistas[p]) && r.getFecha().equals(dia) && r.getHora() == hora) {
                                reservaEncontrada = r;
                                break;
                            }
                        }
                    %>
                    <td>
                        <% if (reservaEncontrada != null) { %>
                            <% if (usuarioLogueado != null && reservaEncontrada.getUsuarioId() != usuarioLogueado.getId()) { %>
                            <a href="MensajeServlet?con=<%= reservaEncontrada.getUsuarioId() %>"
                               class="badge-ocupado"
                               title="Enviar mensaje a <%= reservaEncontrada.getUsernameUsuario() %>">
                                <%= reservaEncontrada.getUsernameUsuario() %>
                            </a>
                            <% } else { %>
                            <span class="badge-ocupado"><%= reservaEncontrada.getUsernameUsuario() %></span>
                            <% } %>
                        <% } else if (usuarioLogueado != null) { %>
                        <form method="post" action="ReservaServlet" style="margin:0">
                            <input type="hidden" name="accion" value="reservar">
                            <input type="hidden" name="pista" value="<%= pistas[p] %>">
                            <input type="hidden" name="fecha" value="<%= dia %>">
                            <input type="hidden" name="hora" value="<%= hora %>">
                            <button type="submit" class="btn-reservar">Libre</button>
                        </form>
                        <% } else { %>
                        <span class="badge-libre">Libre</span>
                        <% } %>
                    </td>
                    <% } %>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <script>
        function mostrarPista(id, btn) {
            document.querySelectorAll('.pista-tabla').forEach(el => el.classList.add('oculto'));
            document.querySelectorAll('.btn-pista').forEach(b => b.classList.remove('activo'));
            document.getElementById('pista_' + id).classList.remove('oculto');
            btn.classList.add('activo');
        }
    </script>

</div>

</body>
</html>