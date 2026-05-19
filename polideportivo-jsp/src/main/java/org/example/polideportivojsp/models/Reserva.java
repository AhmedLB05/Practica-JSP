package org.example.polideportivojsp.models;

import java.time.LocalDate;

public class Reserva {

    private int id;
    private int usuarioId;
    private String usernameUsuario;
    private String pista;
    private LocalDate fecha;
    private int hora;

    public Reserva() {
    }

    public Reserva(int id, int usuarioId, String usernameUsuario, String pista, LocalDate fecha, int hora) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.usernameUsuario = usernameUsuario;
        this.pista = pista;
        this.fecha = fecha;
        this.hora = hora;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getUsernameUsuario() {
        return usernameUsuario;
    }

    public void setUsernameUsuario(String usernameUsuario) {
        this.usernameUsuario = usernameUsuario;
    }

    public String getPista() {
        return pista;
    }

    public void setPista(String pista) {
        this.pista = pista;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public int getHora() {
        return hora;
    }

    public void setHora(int hora) {
        this.hora = hora;
    }

    public String getHoraFormateada() {
        return String.format("%02d:00 - %02d:00", hora, hora + 1);
    }
}