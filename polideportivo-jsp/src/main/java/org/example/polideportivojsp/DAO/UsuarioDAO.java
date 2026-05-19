package org.example.polideportivojsp.DAO;

import org.example.polideportivojsp.models.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario login(String username, String password) {
        String sql = "SELECT * FROM usuarios WHERE username = ?";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashGuardado = rs.getString("password");

                if (BCrypt.checkpw(password, hashGuardado)) {
                    return new Usuario(rs.getInt("id"), rs.getString("username"), hashGuardado, rs.getString("nombre"), rs.getString("email"), rs.getString("telefono"));
                }
            }

        } catch (SQLException e) { System.err.println("Error en login: " + e.getMessage()); }

        return null;
    }

    public boolean registrar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (username, password, nombre, email, telefono) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            String hash = BCrypt.hashpw(usuario.getPassword(), BCrypt.gensalt());

            ps.setString(1, usuario.getUsername());
            ps.setString(2, hash);
            ps.setString(3, usuario.getNombre());
            ps.setString(4, usuario.getEmail());
            ps.setString(5, usuario.getTelefono());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) { System.err.println("Error en registrar: " + e.getMessage()); return false; }
    }

    public boolean actualizarPerfil(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, email = ?, telefono = ? WHERE id = ?";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, usuario.getTelefono());
            ps.setInt(4, usuario.getId());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) { System.err.println("Error en actualizarPerfil: " + e.getMessage()); return false; }
    }

    public boolean cambiarClave(Usuario usuario, String nuevaClave) {
        String sql = "UPDATE usuarios SET password = ? WHERE id = ?";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            String hash = BCrypt.hashpw(nuevaClave, BCrypt.gensalt());
            ps.setString(1, hash);
            ps.setInt(2, usuario.getId());
            ps.executeUpdate();
            usuario.setPassword(hash);
            return true;

        } catch (SQLException e) { System.err.println("Error en cambiarClave: " + e.getMessage()); return false; }
    }
}
