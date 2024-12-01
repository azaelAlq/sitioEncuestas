psql -U postgres

CREATE USER azael WITH PASSWORD 'yo';


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO azael;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO azael;

CREATE DATABASE demo;
GRANT ALL PRIVILEGES ON DATABASE demo TO azael;

CREATE TABLE Encuestas (
    id SERIAL PRIMARY KEY,             -- Identificador único de la encuesta
    pregunta TEXT NOT NULL,            -- Pregunta de la encuesta
    opciones TEXT NOT NULL,            -- Opciones separadas por comas (e.g., "Opción 1,Opción 2,Opción 3")
    votos TEXT NOT NULL,               -- Votos separados por comas (e.g., "0, 0, 0"), si o si tienen que tener espacios
    estado BOOLEAN NOT NULL DEFAULT false  -- Estado de la encuesta (true si está activa)
);
