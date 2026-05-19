package org.example.polideportivojsp.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.polideportivojsp.DAO.UsuarioDAO;
import org.example.polideportivojsp.models.Usuario;

import java.io.IOException;

@WebServlet("/EditarPerfilServlet")
public class EditarPerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("editarPerfil.jsp");
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
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");

        if (nombre == null || nombre.isBlank()) {
            request.setAttribute("error", "El nombre no puede estar vacio");
            request.getRequestDispatcher("/editarPerfil.jsp").forward(request, response);
            return;
        }

        if (email != null && !email.isBlank() && !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            request.setAttribute("error", "El formato del email no es valido");
            request.getRequestDispatcher("/editarPerfil.jsp").forward(request, response);
            return;
        }

        usuario.setNombre(nombre);
        usuario.setEmail(email);
        usuario.setTelefono(telefono);

        UsuarioDAO dao = new UsuarioDAO();
        boolean actualizado = dao.actualizarPerfil(usuario);

        if (actualizado) {
            session.setAttribute("usuario", usuario);
            response.sendRedirect("panel.jsp?msg=perfil_ok");
        } else {
            request.setAttribute("error", "Error al actualizar los datos");
            request.getRequestDispatcher("/editarPerfil.jsp").forward(request, response);
        }
    }
}