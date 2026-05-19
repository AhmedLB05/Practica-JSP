package org.example.polideportivojsp.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.polideportivojsp.DAO.UsuarioDAO;
import org.example.polideportivojsp.models.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/CambiarClaveServlet")
public class CambiarClaveServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cambiarClave.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String claveActual = request.getParameter("claveActual");
        String claveNueva = request.getParameter("claveNueva");
        String claveRepetir = request.getParameter("claveRepetir");

        if (!BCrypt.checkpw(claveActual, usuario.getPassword())) {
            request.setAttribute("error", "La contraseña actual no es correcta");
            request.getRequestDispatcher("/cambiarClave.jsp").forward(request, response);
            return;
        }

        if (!claveNueva.equals(claveRepetir)) {
            request.setAttribute("error", "Las nuevas contraseñas no coinciden");
            request.getRequestDispatcher("/cambiarClave.jsp").forward(request, response);
            return;
        }

        if (claveNueva.length() < 8) {
            request.setAttribute("error", "La nueva contraseña debe tener al menos 8 caracteres");
            request.getRequestDispatcher("/cambiarClave.jsp").forward(request, response);
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();
        boolean ok = dao.cambiarClave(usuario, claveNueva);

        if (ok) {
            session.setAttribute("usuario", usuario);
            response.sendRedirect("panel.jsp?msg=clave_ok");
        } else {
            request.setAttribute("error", "Error al cambiar la contraseña");
            request.getRequestDispatcher("/cambiarClave.jsp").forward(request, response);
        }
    }
}