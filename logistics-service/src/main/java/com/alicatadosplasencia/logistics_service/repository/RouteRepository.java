package com.alicatadosplasencia.logistics_service.repository;

import com.alicatadosplasencia.logistics_service.model.Route;
import com.alicatadosplasencia.logistics_service.model.Route.RouteStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface RouteRepository extends JpaRepository<Route, Long> {
    List<Route> findByStatus(RouteStatus status);
    List<Route> findByScheduleDate(LocalDate scheduleDate);
}
