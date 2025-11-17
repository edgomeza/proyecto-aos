package com.alicatadosplasencia.logistics_service.service;

import com.alicatadosplasencia.logistics_service.model.Route;
import com.alicatadosplasencia.logistics_service.model.Route.RouteStatus;
import com.alicatadosplasencia.logistics_service.repository.RouteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class RouteService {

    @Autowired
    private RouteRepository routeRepository;

    public List<Route> findAll() {
        return routeRepository.findAll();
    }

    public Route findById(Long id) {
        return routeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Route not found"));
    }

    public List<Route> findByStatus(RouteStatus status) {
        return routeRepository.findByStatus(status);
    }

    public List<Route> findByScheduleDate(LocalDate date) {
        return routeRepository.findByScheduleDate(date);
    }

    public Route save(Route route) {
        return routeRepository.save(route);
    }

    public void delete(Long id) {
        routeRepository.deleteById(id);
    }
}
