package org.example.polideportivojsp.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.polideportivojsp.DAO.UsuarioDAO;
import org.example.polideportivojsp.models.Usuario;

import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");

        if (username == null || password == null || nombre == null
                || username.isBlank() || password.isBlank() || nombre.isBlank()) {
            request.setAttribute("error", "Usuario, contrasena y nombre son obligatorios");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("error", "La contrasena debe tener al menos 8 caracteres");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        if (email != null && !email.isBlank() && !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            request.setAttribute("error", "El formato del email no es valido");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        Usuario usuario = new Usuario();
        usuario.setUsername(username);
        usuario.setPassword(password);
        usuario.setNombre(nombre);
        usuario.setEmail(email);
        usuario.setTelefono(telefono);

        UsuarioDAO dao = new UsuarioDAO();
        boolean registrado = dao.registrar(usuario);

        if (registrado) {
            response.sendRedirect("login.jsp?msg=registro_ok");
        } else {
            request.setAttribute("error", "Ese nombre de usuario ya existe");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }
}