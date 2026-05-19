package org.example.polideportivojsp.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.polideportivojsp.DAO.MensajeDAO;
import org.example.polideportivojsp.models.Usuario;

import java.io.IOException;
import java.util.List;

@WebServlet("/MensajeServlet")
public class MensajeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String accion = request.getParameter("accion");

        if ("enviar".equals(accion)) {
            String destinatarioIdStr = request.getParameter("destinatarioId");
            String contenido = request.getParameter("contenido");

            if (destinatarioIdStr == null) {
                response.sendRedirect("MensajeServlet");
                return;
            }

            int destinatarioId;
            try {
                destinatarioId = Integer.parseInt(destinatarioIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("MensajeServlet");
                return;
            }

            if (contenido == null || contenido.isBlank()) {
                response.sendRedirect("MensajeServlet?con=" + destinatarioId + "&error=vacio");
                return;
            }

            MensajeDAO dao = new MensajeDAO();
            dao.enviar(usuario.getId(), destinatarioId, contenido);
            response.sendRedirect("MensajeServlet?con=" + destinatarioId);
        } else {
            response.sendRedirect("MensajeServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        MensajeDAO dao = new MensajeDAO();

        List<Usuario> conversaciones = dao.getConversaciones(usuario.getId());
        request.setAttribute("conversaciones", conversaciones);

        String query = request.getParameter("buscar");
        if (query != null && !query.isBlank()) {
            List<Usuario> resultados = dao.buscarUsuarios(query, usuario.getId());
            request.setAttribute("resultados", resultados);
            request.setAttribute("query", query);
        }

        String conStr = request.getParameter("con");
        if (conStr != null) {
            int otroId;
            try {
                otroId = Integer.parseInt(conStr);
            } catch (NumberFormatException e) {
                request.getRequestDispatcher("/mensajes.jsp").forward(request, response);
                return;
            }
            List<String[]> mensajes = dao.getConversacion(usuario.getId(), otroId);
            request.setAttribute("mensajes", mensajes);
            request.setAttribute("otroId", otroId);

            for (Usuario u : conversaciones) {
                if (u.getId() == otroId) {
                    request.setAttribute("otroUsuario", u);
                    break;
                }
            }

            if (request.getAttribute("otroUsuario") == null) {
                Usuario otro = dao.buscarPorId(otroId);
                request.setAttribute("otroUsuario", otro);
            }
        }

        request.getRequestDispatcher("/mensajes.jsp").forward(request, response);
    }
}