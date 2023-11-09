-- Create the database entertainment
CREATE DATABASE IF NOT EXISTS entertainment_db;

-- Use the database
USE DATABASE entertainment_db;

-- Create the schema
CREATE SCHEMA IF NOT EXISTS models;

-- Create the models.shows table
CREATE TABLE IF NOT EXISTS models.shows (
    show_id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50),
    title VARCHAR(255),
    director VARCHAR(255),
    cast VARCHAR(5000),
    country VARCHAR(5000),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description VARCHAR(5000))
    CLUSTER BY (release_year) -- Clustering key
;

-- Create the models.types table
CREATE TABLE IF NOT EXISTS models.types (
    type_id INT PRIMARY KEY  autoincrement start 1 increment 1,
    type VARCHAR(50)
);

-- Create the models.show_types junction table
CREATE TABLE IF NOT EXISTS models.show_types (
    show_id VARCHAR(50),
    type_id INT,
    PRIMARY KEY (show_id, type_id),
    FOREIGN KEY (show_id) REFERENCES models.shows(show_id),
    FOREIGN KEY (type_id) REFERENCES models.types(type_id)
);
