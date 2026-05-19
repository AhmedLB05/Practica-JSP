package org.example.polideportivojsp.DAO;

import org.example.polideportivojsp.models.Reserva;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    public List<Reserva> getReservasSemana(LocalDate inicio, LocalDate fin) {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
                    SELECT r.*, u.username
                    FROM reservas r
                    JOIN usuarios u ON r.usuario_id = u.id
                    WHERE r.fecha BETWEEN ? AND ?
                    ORDER BY r.fecha, r.hora
                """;

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(inicio));
            ps.setDate(2, Date.valueOf(fin));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Reserva(rs.getInt("id"), rs.getInt("usuario_id"), rs.getString("username"), rs.getString("pista"), rs.getDate("fecha").toLocalDate(), rs.getInt("hora")));
            }
        } catch (SQLException e) { System.err.println("Error en getReservasSemana: " + e.getMessage()); }

        return lista;
    }

    public boolean reservar(int usuarioId, String pista, LocalDate fecha, int hora) {
        String sql = "INSERT INTO reservas (usuario_id, pista, fecha, hora) VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, pista);
            ps.setDate(3, Date.valueOf(fecha));
            ps.setInt(4, hora);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { System.err.println("Error en reservar: " + e.getMessage()); return false; }
    }

    public boolean cancelar(int reservaId, int usuarioId) {
        String sql = "DELETE FROM reservas WHERE id = ? AND usuario_id = ?";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reservaId);
            ps.setInt(2, usuarioId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { System.err.println("Error en cancelar: " + e.getMessage()); return false; }
    }

    public List<Reserva> getHistorialUsuario(int usuarioId) {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
                    SELECT r.*, u.username
                    FROM reservas r
                    JOIN usuarios u ON r.usuario_id = u.id
                    WHERE r.usuario_id = ?
                    ORDER BY r.fecha DESC, r.hora
                """;

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Reserva(rs.getInt("id"), rs.getInt("usuario_id"), rs.getString("username"), rs.getString("pista"), rs.getDate("fecha").toLocalDate(), rs.getInt("hora")));
            }
        } catch (SQLException e) { System.err.println("Error en getHistorialUsuario: " + e.getMessage()); }

        return lista;
    }
}
