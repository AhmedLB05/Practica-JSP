<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.example.polideportivojsp.models.Usuario" %>
<%@ page import="org.example.polideportivojsp.models.Reserva" %>
<%@ page import="org.example.polideportivojsp.DAO.ReservaDAO" %>
<%!
    private String nombrePista(String pista) {
        switch (pista) {
            case "futbol_1": return "Futbol sala 1";
            case "futbol_2": return "Futbol sala 2";
            case "tenis_1":  return "Tenis 1";
            case "tenis_2":  return "Tenis 2";
            case "tenis_3":  return "Tenis 3";
            case "tenis_4":  return "Tenis 4";
            default:         return pista;
        }
    }
%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    ReservaDAO dao = new ReservaDAO();
    List<Reserva> historial = dao.getHistorialUsuario(usuario.getId());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Panel - Polideportivo Martos</title>
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

        .contenido {
            max-width: 920px;
            margin: 32px auto;
            padding: 0 20px;
        }

        .alerta-ok {
            background: #eafaf1;
            border-left: 4px solid #27ae60;
            color: #1e6b3c;
            padding: 13px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .card {
            background: white;
            border-radius: 14px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07);
            padding: 28px;
            margin-bottom: 24px;
        }

        .card-titulo {
            color: #1a252f;
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f0f4f8;
        }

        .datos-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 22px;
        }

        .dato-item {
            background: #f8f9fb;
            border-radius: 9px;
            padding: 12px 16px;
        }

        .dato-label {
            font-size: 11px;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .dato-valor {
            font-size: 15px;
            font-weight: 600;
            color: #1a252f;
        }

        .acciones { display: flex; gap: 10px; flex-wrap: wrap; }

        .btn {
            padding: 10px 22px;
            border-radius: 9px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            text-decoration: none;
            display: inline-block;
            transition: opacity 0.2s;
        }

        .btn:hover { opacity: 0.85; }
        .btn-azul { background: #3498db; color: white; }
        .btn-rojo { background: #e74c3c; color: white; }
        .btn-gris { background: #2c3e50; color: white; }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        thead th {
            background: #1a252f;
            color: white;
            padding: 11px 14px;
            text-align: left;
            font-weight: 600;
        }

        tbody td {
            padding: 11px 14px;
            border-bottom: 1px solid #f0f4f8;
            color: #445;
        }

        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fafbfd; }

        .badge-pista {
            background: #eaf4fd;
            color: #2980b9;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-cancelar {
            background: #fdecea;
            color: #c0392b;
            border: 1.5px solid #e74c3c;
            padding: 6px 14px;
            border-radius: 7px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            transition: all 0.2s;
        }

        .btn-cancelar:hover { background: #e74c3c; color: white; }

        .vacio {
            text-align: center;
            color: #bbb;
            padding: 30px 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<header>
    <h1>Polideportivo Martos</h1>
    <div class="nav-links">
        <a href="index.jsp">Ver Pistas</a>
        <a href="LogoutServlet">Cerrar Sesión</a>
    </div>
</header>

<div class="contenido">
    <%
        String msg = request.getParameter("msg");
        if ("perfil_ok".equals(msg)) {
    %>
    <div class="alerta-ok">Datos actualizados correctamente</div>
    <% } else if ("clave_ok".equals(msg)) { %>
    <div class="alerta-ok">Contraseña cambiada correctamente</div>
    <% } %>

    <div class="card">
        <div class="card-titulo">Mis datos</div>
        <div class="datos-grid">
            <div class="dato-item">
                <div class="dato-label">Usuario</div>
                <div class="dato-valor"><%= usuario.getUsername() %></div>
            </div>
            <div class="dato-item">
                <div class="dato-label">Nombre</div>
                <div class="dato-valor"><%= usuario.getNombre() %></div>
            </div>
            <div class="dato-item">
                <div class="dato-label">Email</div>
                <div class="dato-valor"><%= usuario.getEmail() != null && !usuario.getEmail().isEmpty() ? usuario.getEmail() : "-" %></div>
            </div>
            <div class="dato-item">
                <div class="dato-label">Teléfono</div>
                <div class="dato-valor"><%= usuario.getTelefono() != null && !usuario.getTelefono().isEmpty() ? usuario.getTelefono() : "-" %></div>
            </div>
        </div>
        <div class="acciones">
            <a href="editarPerfil.jsp" class="btn btn-azul">Editar datos</a>
            <a href="cambiarClave.jsp" class="btn btn-rojo">Cambiar contraseña</a>
            <a href="MensajeServlet" class="btn btn-gris">Mensajes</a>
        </div>
    </div>

    <div class="card">
        <div class="card-titulo">Mis reservas</div>
        <% if (historial.isEmpty()) { %>
        <div class="vacio">No tienes reservas activas ni pasadas</div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>Pista</th>
                <th>Fecha</th>
                <th>Hora</th>
                <th>Acción</th>
            </tr>
            </thead>
            <tbody>
            <% for (Reserva r : historial) { %>
            <tr>
                <td><span class="badge-pista"><%= nombrePista(r.getPista()) %></span></td>
                <td><%= r.getFecha() %></td>
                <td><%= r.getHoraFormateada() %></td>
                <td>
                    <form method="post" action="ReservaServlet">
                        <input type="hidden" name="accion" value="cancelar">
                        <input type="hidden" name="reservaId" value="<%= r.getId() %>">
                        <button type="submit" class="btn-cancelar"
                                onclick="return confirm('¿Seguro que quieres cancelar esta reserva?')">
                            Cancelar
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>

</body>
</html>