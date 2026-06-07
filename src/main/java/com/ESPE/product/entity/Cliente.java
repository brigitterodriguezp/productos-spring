package com.ESPE.product.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name = "clientes")
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El nombre no puede estar vacio")
    @Size(max = 100, message = "El nombre no puede superar 100 caracteres")
    @Column(nullable = false, length = 100)
    private String nombre;

    @NotBlank(message = "El apellido no puede estar vacio")
    @Size(max = 100, message = "El apellido no puede superar 100 caracteres")
    @Column(nullable = false, length = 100)
    private String apellido;

    @NotBlank(message = "El correo no puede estar vacio")
    @Email(message = "Debe ser un correo electronico valido")
    @Size(max = 150, message = "El correo no puede superar 150 caracteres")
    @Column(nullable = false, length = 150)
    private String correo;

    @NotBlank(message = "El telefono no puede estar vacio")
    @Size(max = 20, message = "El telefono no puede superar 20 caracteres")
    @Column(nullable = false, length = 20)
    private String telefono;

    @NotBlank(message = "La direccion no puede estar vacia")
    @Size(max = 255, message = "La direccion no puede superar 255 caracteres")
    @Column(nullable = false, length = 255)
    private String direccion;

    public Cliente() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}
