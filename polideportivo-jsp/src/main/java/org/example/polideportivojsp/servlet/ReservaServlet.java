package org.example.polideportivojsp.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.polideportivojsp.DAO.ReservaDAO;
import org.example.polideportivojsp.models.Usuario;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    private static final List<String> PISTAS_VALIDAS = Arrays.asList(
            "futbol_1", "futbol_2", "tenis_1", "tenis_2", "tenis_3", "tenis_4"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
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
        String accion = request.getParameter("accion");

        if ("reservar".equals(accion)) {
            String pista = request.getParameter("pista");
            String fechaStr = request.getParameter("fecha");
            String horaStr = request.getParameter("hora");

            if (pista == null || fechaStr == null || horaStr == null) {
                request.setAttribute("error", "Faltan datos en la reserva");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            if (!PISTAS_VALIDAS.contains(pista)) {
                request.setAttribute("error", "Pista no valida");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            int hora;
            try {
                hora = Integer.parseInt(horaStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Hora no valida");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            LocalDate fecha;
            try {
                fecha = LocalDate.parse(fechaStr);
            } catch (Exception e) {
                request.setAttribute("error", "Fecha no valida");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            LocalDate hoy = LocalDate.now();
            LocalDate maxFecha = hoy.plusDays(6);

            if (fecha.isBefore(hoy) || fecha.isAfter(maxFecha)) {
                request.setAttribute("error", "Solo puedes reservar con un maximo de una semana de antelacion");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            if (!horaValida(hora)) {
                request.setAttribute("error", "Hora no valida");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            ReservaDAO dao = new ReservaDAO();
            boolean ok = dao.reservar(usuario.getId(), pista, fecha, hora);

            if (ok) {
                response.sendRedirect("index.jsp?msg=reserva_ok");
            } else {
                response.sendRedirect("index.jsp?msg=reserva_error");
            }

        } else if ("cancelar".equals(accion)) {
            String reservaIdStr = request.getParameter("reservaId");

            if (reservaIdStr == null) {
                response.sendRedirect("panel.jsp");
                return;
            }

            int reservaId;
            try {
                reservaId = Integer.parseInt(reservaIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("panel.jsp");
                return;
            }

            ReservaDAO dao = new ReservaDAO();
            dao.cancelar(reservaId, usuario.getId());
            response.sendRedirect("panel.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    private boolean horaValida(int hora) {
        return (hora >= 9 && hora <= 13) || (hora >= 16 && hora <= 22);
    }
}
