-- Create the database entertainment
CREATE DATABASE IF NOT EXISTS entertainment_db;

-- Use the database
USE DATABASE entertainment_db;

--create schema
CREATE SCHEMA netflix_titles;

-- Create a staging table to server as doorstep to load data from a CSV file and it will allow duplicates.
CREATE TABLE IF NOT EXISTS netflix_titles.stg_shows
  (
     show_id      VARCHAR(50),
     type         VARCHAR(50),
     title        VARCHAR(255),
     director     VARCHAR(255),
     cast         VARCHAR(5000),
     country      VARCHAR(5000),
     date_added   VARCHAR(50),
     release_year INT,
     rating       VARCHAR(10),
     duration     VARCHAR(50),
     listed_in    VARCHAR(255),
     description  VARCHAR(5000)
  );

-- Create STREAM table on top of Staging table to capture INSERTS into STAGING:
CREATE STREAM IF NOT EXISTS netflix_titles.stg_shows_stream ON TABLE netflix_titles.stg_shows APPEND_ONLY = TRUE;

-- Create a DIM table to store types of shows.
CREATE TABLE IF NOT EXISTS netflix_titles.show_types 
    (
        type_id INT PRIMARY KEY IDENTITY start 1 increment 1,
        type_name VARCHAR(50)
    );

-- Create a CLEANSED table to MERGE data from Staging table. It will have UNIQUE records based on PK show_id.
CREATE TABLE IF NOT EXISTS netflix_titles.cleansed_shows
  (
     show_id      VARCHAR(50) PRIMARY KEY,
     type_id      INT,
     type         VARCHAR(50),
     title        VARCHAR(255),
     director     VARCHAR(255),
     cast         VARCHAR(5000),
     country      VARCHAR(5000),
     date_added   VARCHAR(50),
     release_year INT,
     rating       VARCHAR(10),
     duration     VARCHAR(50),
     listed_in    VARCHAR(255),
     description  VARCHAR(5000),
     FOREIGN KEY (type_id) REFERENCES netflix_titles.show_types(type_id)
  ) cluster BY (release_year) -- Clustering key
  ;

  -- Create additional table to save gender details
CREATE TABLE IF NOT EXISTS netflix_titles.cast_gender(
    cast_name VARCHAR(100),
    cast_gender VARCHAR(50)
);
 
