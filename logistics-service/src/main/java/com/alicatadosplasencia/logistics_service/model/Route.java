package com.alicatadosplasencia.logistics_service.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "routes")
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Route code is required")
    @Column(nullable = false, unique = true)
    private String routeCode;

    @NotBlank(message = "Origin is required")
    @Column(nullable = false)
    private String origin;

    @NotBlank(message = "Destination is required")
    @Column(nullable = false)
    private String destination;

    private Double distanceKm;

    private Integer estimatedDuration; // minutos

    @NotNull(message = "Schedule date is required")
    @Column(nullable = false)
    private LocalDate scheduleDate;

    private LocalTime departureTime;

    @Enumerated(EnumType.STRING)
    private RouteStatus status;

    private String driverName;

    private String vehiclePlate;

    public enum RouteStatus {
        PLANNED, IN_PROGRESS, COMPLETED, CANCELLED
    }

    // Constructors
    public Route() {}

    public Route(String routeCode, String origin, String destination) {
        this.routeCode = routeCode;
        this.origin = origin;
        this.destination = destination;
        this.status = RouteStatus.PLANNED;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRouteCode() {
        return routeCode;
    }

    public void setRouteCode(String routeCode) {
        this.routeCode = routeCode;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public Double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public Integer getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(Integer estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public LocalDate getScheduleDate() {
        return scheduleDate;
    }

    public void setScheduleDate(LocalDate scheduleDate) {
        this.scheduleDate = scheduleDate;
    }

    public LocalTime getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(LocalTime departureTime) {
        this.departureTime = departureTime;
    }

    public RouteStatus getStatus() {
        return status;
    }

    public void setStatus(RouteStatus status) {
        this.status = status;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getVehiclePlate() {
        return vehiclePlate;
    }

    public void setVehiclePlate(String vehiclePlate) {
        this.vehiclePlate = vehiclePlate;
    }
}
