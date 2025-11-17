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

    public Route update(Long id, Route routeDetails) {
        Route route = findById(id);

        // Update fields
        route.setRouteCode(routeDetails.getRouteCode());
        route.setOrigin(routeDetails.getOrigin());
        route.setDestination(routeDetails.getDestination());
        route.setDistanceKm(routeDetails.getDistanceKm());
        route.setEstimatedDuration(routeDetails.getEstimatedDuration());
        route.setScheduleDate(routeDetails.getScheduleDate());
        route.setDepartureTime(routeDetails.getDepartureTime());
        route.setStatus(routeDetails.getStatus());
        route.setDriverName(routeDetails.getDriverName());
        route.setVehiclePlate(routeDetails.getVehiclePlate());

        return routeRepository.save(route);
    }

    public void delete(Long id) {
        routeRepository.deleteById(id);
    }
}
