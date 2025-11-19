package com.alicatadosplasencia.containers_service.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.hibernate6.Hibernate6Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

/**
 * Configuración de Jackson para manejar correctamente la serialización JSON
 * Especialmente importante para relaciones JPA LAZY y tipos de fecha
 */
@Configuration
public class JacksonConfig {

    @Bean
    @Primary
    public ObjectMapper objectMapper(Jackson2ObjectMapperBuilder builder) {
        ObjectMapper objectMapper = builder.createXmlMapper(false).build();

        // Registrar módulo para manejo de fechas Java 8+
        objectMapper.registerModule(new JavaTimeModule());

        // Registrar módulo de Hibernate para manejar proxies y lazy loading
        Hibernate6Module hibernate6Module = new Hibernate6Module();
        // No forzar el lazy loading, solo ignorar las propiedades no inicializadas
        hibernate6Module.configure(Hibernate6Module.Feature.FORCE_LAZY_LOADING, false);
        hibernate6Module.configure(Hibernate6Module.Feature.SERIALIZE_IDENTIFIER_FOR_LAZY_NOT_LOADED_OBJECTS, true);
        objectMapper.registerModule(hibernate6Module);

        // Deshabilitar escritura de fechas como timestamps
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        // Configuración para manejar relaciones LAZY de Hibernate
        // Esto evita errores al serializar entidades con relaciones no inicializadas
        objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);

        return objectMapper;
    }
}
