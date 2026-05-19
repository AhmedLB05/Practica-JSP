package org.example.polideportivojsp.DAO;

import org.example.polideportivojsp.models.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MensajeDAO {

    public boolean enviar(int remitenteId, int destinatarioId, String contenido) {
        String sql = "INSERT INTO mensajes (remitente_id, destinatario_id, contenido) VALUES (?, ?, ?)";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, remitenteId);
            ps.setInt(2, destinatarioId);
            ps.setString(3, contenido);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { System.err.println("Error en enviar mensaje: " + e.getMessage()); return false; }
    }

    public List<Usuario> getConversaciones(int usuarioId) {
        List<Usuario> lista = new ArrayList<>();
        String sql = """
                    SELECT DISTINCT u.id, u.username, u.nombre, u.email, u.telefono
                    FROM usuarios u
                    WHERE u.id IN (
                        SELECT remitente_id FROM mensajes WHERE destinatario_id = ?
                        UNION
                        SELECT destinatario_id FROM mensajes WHERE remitente_id = ?
                    )
                """;

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Usuario(rs.getInt("id"), rs.getString("username"), "", rs.getString("nombre"), rs.getString("email"), rs.getString("telefono")));
            }
        } catch (SQLException e) { System.err.println("Error en getConversaciones: " + e.getMessage()); }

        return lista;
    }

    public List<String[]> getConversacion(int usuarioId, int otroId) {
        List<String[]> lista = new ArrayList<>();
        String sql = """
                    SELECT m.id, m.remitente_id, u.username, m.contenido, m.fecha
                    FROM mensajes m
                    JOIN usuarios u ON m.remitente_id = u.id
                    WHERE (m.remitente_id = ? AND m.destinatario_id = ?)
                       OR (m.remitente_id = ? AND m.destinatario_id = ?)
                    ORDER BY m.fecha ASC
                """;

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, otroId);
            ps.setInt(3, otroId);
            ps.setInt(4, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new String[]{rs.getString("id"), rs.getString("remitente_id"), rs.getString("username"), rs.getString("contenido"), rs.getString("fecha")});
            }
        } catch (SQLException e) { System.err.println("Error en getConversacion: " + e.getMessage()); }

        return lista;
    }

    public List<Usuario> buscarUsuarios(String query, int miId) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE username LIKE ? AND id != ?";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + query + "%");
            ps.setInt(2, miId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Usuario(rs.getInt("id"), rs.getString("username"), "", rs.getString("nombre"), rs.getString("email"), rs.getString("telefono")));
            }
        } catch (SQLException e) { System.err.println("Error en buscarUsuarios: " + e.getMessage()); }

        return lista;
    }

    public Usuario buscarPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Usuario(rs.getInt("id"), rs.getString("username"), "", rs.getString("nombre"), rs.getString("email"), rs.getString("telefono"));
            }
        } catch (SQLException e) { System.err.println("Error en buscarPorId: " + e.getMessage()); }
        return null;
    }
}
