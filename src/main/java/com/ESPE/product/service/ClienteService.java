package com.ESPE.product.service;

import com.ESPE.product.entity.Cliente;
import com.ESPE.product.repository.ClienteRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;

@Service
public class ClienteService {
    private final ClienteRepository clienteRepository;

    public ClienteService(ClienteRepository clienteRepository) {
        this.clienteRepository = clienteRepository;
    }

    public List<Cliente> listarClientes() {
        return clienteRepository.findAll();
    }

    public Cliente buscarPorId(Long id) {
        return clienteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No existe un cliente con id " + id));
    }

    public Cliente crearCliente(Cliente cliente) {
        if (clienteRepository.existsByCorreoIgnoreCase(cliente.getCorreo())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un cliente con el correo '" + cliente.getCorreo() + "'");
        }
        cliente.setId(null);
        return clienteRepository.save(cliente);
    }

    public Cliente actualizarCliente(Long id, Cliente clienteActualizado) {
        Cliente clienteExistente = buscarPorId(id);
        if (!clienteExistente.getCorreo().equalsIgnoreCase(clienteActualizado.getCorreo())
                && clienteRepository.existsByCorreoIgnoreCase(clienteActualizado.getCorreo())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un cliente con el correo '" + clienteActualizado.getCorreo() + "'");
        }
        clienteExistente.setNombre(clienteActualizado.getNombre());
        clienteExistente.setApellido(clienteActualizado.getApellido());
        clienteExistente.setCorreo(clienteActualizado.getCorreo());
        clienteExistente.setTelefono(clienteActualizado.getTelefono());
        clienteExistente.setDireccion(clienteActualizado.getDireccion());
        return clienteRepository.save(clienteExistente);
    }

    public void eliminarCliente(Long id) {
        clienteRepository.delete(buscarPorId(id));
    }
}
