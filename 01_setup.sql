
/*
================================================================================
Tampa Railway System - Database Tables & Structure
================================================================================
Target System: Microsoft SQL Server (T-SQL)
Description: Creates the core database and sets up the 50 tables needed to 
             track staff, ticket sales, trains, and maintenance.
*/

USE master;

-- If the database already exists, delete it so we can start fresh
IF DB_ID('Tampa_Railway') IS NOT NULL DROP DATABASE Tampa_Railway;
GO

CREATE DATABASE Tampa_Railway;
GO

USE Tampa_Railway;
GO

-- -----------------------------------------------------------------------------
-- CLEANUP SCRIPT (Deletes existing tables to prevent errors if rerun)
-- -----------------------------------------------------------------------------

IF OBJECT_ID('employees') IS NOT NULL DROP TABLE employees;
IF OBJECT_ID('tickets') IS NOT NULL DROP TABLE tickets;
IF OBJECT_ID('locations') IS NOT NULL DROP TABLE locations;
IF OBJECT_ID('cabin_types') IS NOT NULL DROP TABLE cabin_types;
IF OBJECT_ID('travels') IS NOT NULL DROP TABLE travels;
IF OBJECT_ID('routes') IS NOT NULL DROP TABLE routes;
IF OBJECT_ID('customers') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('trains') IS NOT NULL DROP TABLE trains;
IF OBJECT_ID('trains_maintenances') IS NOT NULL DROP TABLE trains_maintenances;
IF OBJECT_ID('maintenances') IS NOT NULL DROP TABLE maintenances;
IF OBJECT_ID('travels_employees') IS NOT NULL DROP TABLE travels_employees;
IF OBJECT_ID('routes_cabin_types') IS NOT NULL DROP TABLE routes_cabin_types;
IF OBJECT_ID('discounts') IS NOT NULL DROP TABLE discounts;
IF OBJECT_ID('job_positions') IS NOT NULL DROP TABLE job_positions;
IF OBJECT_ID('location_types') IS NOT NULL DROP TABLE location_types;
IF OBJECT_ID('cities_states') IS NOT NULL DROP TABLE cities_states;
IF OBJECT_ID('states') IS NOT NULL DROP TABLE states;
IF OBJECT_ID('weekdays') IS NOT NULL DROP TABLE weekdays;
IF OBJECT_ID('zipcodes') IS NOT NULL DROP TABLE zipcodes;
IF OBJECT_ID('employees_job_positions') IS NOT NULL DROP TABLE employees_job_positions;
IF OBJECT_ID('payment_types') IS NOT NULL DROP TABLE payment_types;
IF OBJECT_ID('passes') IS NOT NULL DROP TABLE passes;
IF OBJECT_ID('passes_travels') IS NOT NULL DROP TABLE passes_travels;
IF OBJECT_ID('pass_types') IS NOT NULL DROP TABLE pass_types;
IF OBJECT_ID('travel_roles') IS NOT NULL DROP TABLE travel_roles;
IF OBJECT_ID('wagons') IS NOT NULL DROP TABLE wagons;
IF OBJECT_ID('wagon_types') IS NOT NULL DROP TABLE wagon_types;
IF OBJECT_ID('travels_wagons') IS NOT NULL DROP TABLE travel_wagons;
IF OBJECT_ID('wagons_maintenances') IS NOT NULL DROP TABLE wagons_maintenances;
IF OBJECT_ID('cards') IS NOT NULL DROP TABLE cards;

-- -----------------------------------------------------------------------------
-- TABLE CREATION
-- -----------------------------------------------------------------------------

CREATE TABLE employees (
  employee_id					int not null,
  first_name					varchar(50) null,
  last_name						varchar(50) null, 
  birth_date					date null,
  hire_date						date null,
  email							varchar(50) null,
  gender						char null,
  ssn							varchar(50) null,
  phone1						varchar(50) null,
  phone2						varchar(50) null,
  address_line1					varchar(50) null,
  address_line2					varchar(50) null,
  zipcode_id					int null,
  city_state_id					int null,
  job_position_id				int null,
  employee_id_reports_to		int null,
  travel_role_id				int null
);



CREATE TABLE job_positions (
  job_position_id				int not null,
  name							varchar(50) null,
  description					varchar(800) null,
  salary_base					decimal(10,2) null
);


CREATE TABLE passes (
  pass_id						int not null,
  first_name					varchar(50) null,
  last_name						varchar(50) null,
  employee_id					int null,
  card_id						int null,
  pass_type_id					int null,
  purchase_date					date null,
  purchase_time					time null,
  start_date					date null,
  start_time					time null,
  end_date						date null,
  end_time						time null,
  purchase_location_id			int null,
  cabin_type_id					int null,
  discount_id					int null,
  final_price					decimal(10,2) null,
  payment_type_id				int null
);


CREATE TABLE cards (
  card_id						int not null,
  employee_id					int null,
  customer_id					int null,
  purchase_date					date null,
  purchase_time					time null,
  purchase_location_id			int null
);


CREATE TABLE passes_travels (
	pass_id						int not null,
	travel_id					int not null,
	boarding_date				date null,
	boarding_time				time null
);


CREATE TABLE pass_types (
	pass_type_id				int not null,
	name						varchar(50) null
);


CREATE TABLE tickets (
  ticket_id						int not null,
  travel_id						int null,
  customer_id					int null,
  employee_id					int null,
  purchase_date					date null,
  purchase_time					time null,
  boarding_date					date null,
  boarding_time					time null,
  purchase_location_id			int null,
  cabin_type_id					int null,
  discount_id					int null,
  final_price					decimal(10,2) null,
  payment_type_id				int null
);


CREATE TABLE locations (
  location_id					int not null,
  name							varchar(50) null,
  location_type_id				int null,
  address_line1					varchar(50) null,
  address_line2					varchar(50) null,
  zipcode_id					int null,
  city_state_id					int null,
  location_x					varchar(50) null,
  location_y					varchar(50) null
);


CREATE TABLE location_types (
  location_type_id				int not null,
  name							varchar(50) null
);


CREATE TABLE cabin_types (
  cabin_type_id					int not null,
  name							varchar(50) null
);

CREATE TABLE travels (
  travel_id						int not null,
  date							date null,
  start_time_actual				time null,
  end_time_actual				time null,
  route_id						int null,
  train_id						int null
);

CREATE TABLE wagons (
  wagon_id						int not null,
  fabrication_date				date null,
  first_use_date				date null,
  brand							varchar(50) null,
  model							varchar(50) null,
  capacity						varchar(50) null
);

CREATE TABLE wagon_types (
  wagon_type_id					int not null,
  name							varchar(50) null
);

CREATE TABLE wagons_maintenances (
  wagon_maintenance_id			int not null,
  wagon_id						int not null,
  maintenance_id				int not null,
  date							date null,
  status						int null,
  observations					varchar(50) null,
  employee_id					int null
);

CREATE TABLE travels_wagons (
  wagon_id						int not null,
  travel_id						int not null,
  order_number					int null
);

CREATE TABLE routes (
  route_id						int not null,
  city_state_id_origin			int null,
  city_state_id_destination		int null,
  start_time					time null,
  end_time						time null,
  weekday_id					int null
);

CREATE TABLE zipcodes (
  zipcode_id					int not null,
  name							varchar(50) null,
  state_id						int null
);

CREATE TABLE cities_states (
  city_state_id					int not null,
  name							varchar(50) null,
  state_id						int null
);

CREATE TABLE states (
  state_id						int not null,
  name							varchar(50) null
);

CREATE TABLE customers (
  customer_id					int not null,
  first_name					varchar(50) null,
  last_name						varchar(50) null, 
  birth_date					date null,
  start_date					date null,
  email							varchar(50) null,
  gender						char null,
  phone1						varchar(50) null,
  phone2						varchar(50) null,
  address_line1					varchar(50) null,
  address_line2					varchar(50) null,
  zipcode_id					int null,
  city_state_id					int null
);

CREATE TABLE trains (
  train_id						int not null,
  fabrication_date				date null,
  first_use_date				date null,
  brand							varchar(50) null,
  model							varchar(50) null
);

CREATE TABLE trains_maintenances (
  train_maintenance_id			int not null,
  train_id						int not null,
  maintenance_id				int not null,
  date							date null,
  status						int null,
  observations					varchar(50) null,
  employee_id					int null
);

CREATE TABLE maintenances (
  maintenance_id				int not null,
  name							varchar(800) null,
  observations					varchar(800) null
);


CREATE TABLE travels_employees (
  travel_id						int not null,
  employee_id					int not null
);


CREATE TABLE travel_roles (
  travel_role_id				int not null,
  name							varchar(50) null
);

CREATE TABLE routes_cabin_types (
  route_cabin_type_id			int not null,
  route_id						int not null,
  cabin_type_id					int not null,
  price							decimal(10,2) null,
  start_date					date null,
  end_date						date null
);

CREATE TABLE employees_job_positions (
  employee_job_position_id		int not null,
  employee_id					int not null,
  job_position_id				int not null,
  salary						decimal(10,2) null,
  start_date					date null,
  end_date						date null
);

CREATE TABLE discounts (
  discount_id				    int not null,
  name							varchar(50) null,
  percentage					decimal(5,2) null,
  observations					varchar(800) null,					
  start_date					date null,
  end_date						date null
);

CREATE TABLE payment_types (
  payment_type_id				int not null,
  name							varchar(50) null
);

CREATE TABLE weekdays (
  weekday_id					int not null,
  name							varchar(50) null,
  day_order						int null
);

CREATE TABLE pass_types_cabin_types (
  pass_type_cabin_type_id			int not null,
  pass_type_id						int not null,
  cabin_type_id						int not null,
  price								decimal(10,2) null,
  start_date						date null,
  end_date							date null
);

-- -----------------------------------------------------------------------------
-- PRIMARY KEYS
-- -----------------------------------------------------------------------------

ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);
ALTER TABLE tickets ADD CONSTRAINT pk_tickets PRIMARY KEY (ticket_id);
ALTER TABLE locations ADD CONSTRAINT pk_locations PRIMARY KEY (location_id);
ALTER TABLE cabin_types ADD CONSTRAINT pk_cabin_types PRIMARY KEY (cabin_type_id);
ALTER TABLE travels ADD CONSTRAINT pk_travels PRIMARY KEY (travel_id);
ALTER TABLE routes ADD CONSTRAINT pk_routes PRIMARY KEY (route_id);
ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);
ALTER TABLE trains ADD CONSTRAINT pk_trains PRIMARY KEY (train_id);
ALTER TABLE trains_maintenances ADD CONSTRAINT pk_trains_maintenances PRIMARY KEY (train_maintenance_id);
ALTER TABLE maintenances ADD CONSTRAINT pk_maintenances PRIMARY KEY (maintenance_id);
ALTER TABLE travels_employees ADD CONSTRAINT pk_travels_employees PRIMARY KEY (travel_id, employee_id);
ALTER TABLE routes_cabin_types ADD CONSTRAINT pk_routes_cabin_type PRIMARY KEY (route_cabin_type_id);
ALTER TABLE discounts ADD CONSTRAINT pk_discounts PRIMARY KEY (discount_id);
ALTER TABLE job_positions ADD CONSTRAINT pk_job_positions PRIMARY KEY (job_position_id);
ALTER TABLE location_types ADD CONSTRAINT pk_location_types PRIMARY KEY (location_type_id);
ALTER TABLE cities_states ADD CONSTRAINT pk_cities_states PRIMARY KEY (city_state_id);
ALTER TABLE states ADD CONSTRAINT pk_states PRIMARY KEY (state_id);
ALTER TABLE weekdays ADD CONSTRAINT pk_weekdays PRIMARY KEY (weekday_id);
ALTER TABLE zipcodes ADD CONSTRAINT pk_zipcodes PRIMARY KEY (zipcode_id);
ALTER TABLE employees_job_positions ADD CONSTRAINT pk_employees_job_positions PRIMARY KEY (employee_job_position_id);
ALTER TABLE payment_types ADD CONSTRAINT pk_payment_types PRIMARY KEY (payment_type_id);
ALTER TABLE passes ADD CONSTRAINT pk_passes PRIMARY KEY (pass_id);
ALTER TABLE passes_travels ADD CONSTRAINT pk_passes_travels PRIMARY KEY (pass_id, travel_id);
ALTER TABLE pass_types ADD CONSTRAINT pk_pass_types PRIMARY KEY (pass_type_id);
ALTER TABLE travel_roles ADD CONSTRAINT pk_travel_roles PRIMARY KEY (travel_role_id);
ALTER TABLE wagons ADD CONSTRAINT pk_wagons PRIMARY KEY (wagon_id);
ALTER TABLE wagon_types ADD CONSTRAINT pk_wagon_types PRIMARY KEY (wagon_type_id);
ALTER TABLE travels_wagons ADD CONSTRAINT pk_travels_wagons PRIMARY KEY (travel_id, wagon_id);
ALTER TABLE wagons_maintenances ADD CONSTRAINT pk_wagons_maintenances PRIMARY KEY (wagon_maintenance_id);
ALTER TABLE cards ADD CONSTRAINT pk_cards PRIMARY KEY (card_id);
ALTER TABLE pass_types_cabin_types ADD CONSTRAINT pk_pass_types_cabin_types PRIMARY KEY (pass_type_cabin_type_id);

-- -----------------------------------------------------------------------------
-- DUPLICATE PREVENTION RULES
-- -----------------------------------------------------------------------------

ALTER TABLE travels_wagons ADD CONSTRAINT uq_travels_wagons_travel_id_wagon_id_order_number UNIQUE(travel_id, wagon_id, order_number);

-- -----------------------------------------------------------------------------
-- FOREIGN KEYS (Links tables together)
-- -----------------------------------------------------------------------------

ALTER TABLE trains_maintenances ADD CONSTRAINT fk_trains_maintenances_trains FOREIGN KEY (train_id) REFERENCES trains (train_id);
ALTER TABLE trains_maintenances ADD CONSTRAINT fk_trains_maintenances_manintenances FOREIGN KEY (maintenance_id) REFERENCES maintenances (maintenance_id);
ALTER TABLE trains_maintenances ADD CONSTRAINT fk_trains_maintenances_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE travels ADD CONSTRAINT fk_travels_routes FOREIGN KEY (route_id) REFERENCES routes (route_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_travels FOREIGN KEY (travel_id) REFERENCES travels (travel_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_locations FOREIGN KEY (purchase_location_id) REFERENCES locations (location_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_cabin_types FOREIGN KEY (cabin_type_id) REFERENCES cabin_types(cabin_type_id);
ALTER TABLE travels ADD CONSTRAINT fk_travels_trains FOREIGN KEY (train_id) REFERENCES trains (train_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE travels_employees ADD CONSTRAINT fk_travels_employees_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE travels_employees ADD CONSTRAINT fk_travels_employees_travels FOREIGN KEY (travel_id) REFERENCES travels (travel_id);
ALTER TABLE routes_cabin_types ADD CONSTRAINT fk_routes_cabin_type_routes FOREIGN KEY (route_id) REFERENCES routes (route_id);
ALTER TABLE routes_cabin_types ADD CONSTRAINT fk_routes_cabin_type_cabin_types FOREIGN KEY (cabin_type_id) REFERENCES cabin_types (cabin_type_id);
ALTER TABLE tickets ADD CONSTRAINT fk_discounts_tickets FOREIGN KEY (discount_id) REFERENCES discounts (discount_id);
ALTER TABLE employees_job_positions ADD CONSTRAINT fk_employees_job_positions_job_positions FOREIGN KEY (job_position_id) REFERENCES job_positions (job_position_id);
ALTER TABLE employees_job_positions ADD CONSTRAINT fk_employees_job_positions_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE locations ADD CONSTRAINT fk_locations_location_types FOREIGN KEY (location_type_id) REFERENCES location_types (location_type_id);
ALTER TABLE routes ADD CONSTRAINT fk_routes_cities_states_origin FOREIGN KEY (city_state_id_origin) REFERENCES cities_states (city_state_id);
ALTER TABLE routes ADD CONSTRAINT fk_routes_cities_states_destination FOREIGN KEY (city_state_id_destination) REFERENCES cities_states (city_state_id);
ALTER TABLE cities_states ADD CONSTRAINT fk_cities_states_states FOREIGN KEY (state_id) REFERENCES states (state_id);
ALTER TABLE employees ADD CONSTRAINT fk_employees_cities_states FOREIGN KEY (city_state_id) REFERENCES cities_states (city_state_id);
ALTER TABLE customers ADD CONSTRAINT fk_customers_cities_states FOREIGN KEY (city_state_id) REFERENCES cities_states (city_state_id);
ALTER TABLE routes ADD CONSTRAINT fk_routes_weekdays FOREIGN KEY (weekday_id) REFERENCES weekdays (weekday_id);
ALTER TABLE employees ADD CONSTRAINT fk_employees_zipcodes FOREIGN KEY (zipcode_id) REFERENCES zipcodes (zipcode_id);
ALTER TABLE customers ADD CONSTRAINT fk_customers_zipcodes FOREIGN KEY (zipcode_id) REFERENCES zipcodes (zipcode_id);
ALTER TABLE locations ADD CONSTRAINT fk_locations_zipcodes FOREIGN KEY (zipcode_id) REFERENCES zipcodes (zipcode_id);
ALTER TABLE zipcodes ADD CONSTRAINT fk_zipcodes_states FOREIGN KEY (state_id) REFERENCES states (state_id);
ALTER TABLE locations ADD CONSTRAINT fk_locations_cities_states FOREIGN KEY (city_state_id) REFERENCES cities_states (city_state_id);
ALTER TABLE passes_travels ADD CONSTRAINT fk_passes_travels_passes FOREIGN KEY (pass_id) REFERENCES passes (pass_id);
ALTER TABLE passes_travels ADD CONSTRAINT fk_passes_travels_travels FOREIGN KEY (travel_id) REFERENCES travels (travel_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_pass_types FOREIGN KEY (pass_type_id) REFERENCES pass_types (pass_type_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_cards FOREIGN KEY (card_id) REFERENCES cards (card_id);
ALTER TABLE employees ADD CONSTRAINT fk_employees_travel_roles FOREIGN KEY (travel_role_id) REFERENCES travel_roles (travel_role_id);
ALTER TABLE travels_wagons ADD CONSTRAINT fk_travels_wagons_wagons FOREIGN KEY (wagon_id) REFERENCES wagons (wagon_id);
ALTER TABLE travels_wagons ADD CONSTRAINT fk_travels_wagons_travels FOREIGN KEY (travel_id) REFERENCES travels (travel_id);
ALTER TABLE wagons_maintenances ADD CONSTRAINT fk_trains_maintenances_wagons FOREIGN KEY (wagon_id) REFERENCES wagons (wagon_id);
ALTER TABLE wagons_maintenances ADD CONSTRAINT fk_trains_maintenances_maintenances FOREIGN KEY (maintenance_id) REFERENCES maintenances (maintenance_id);
ALTER TABLE cards ADD CONSTRAINT fk_cards_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id);
ALTER TABLE cards ADD CONSTRAINT fk_cards_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id);
ALTER TABLE cards ADD CONSTRAINT fk_cards_locations FOREIGN KEY (purchase_location_id) REFERENCES locations (location_id);
ALTER TABLE pass_types_cabin_types ADD CONSTRAINT fk_pass_types_cabin_types_pass_types FOREIGN KEY (pass_type_id) REFERENCES pass_types (pass_type_id);
ALTER TABLE pass_types_cabin_types ADD CONSTRAINT fk_pass_types_cabin_types_cabin_types FOREIGN KEY (cabin_type_id) REFERENCES cabin_types (cabin_type_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_locations FOREIGN KEY (purchase_location_id) REFERENCES locations (location_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_cabin_types FOREIGN KEY (cabin_type_id) REFERENCES cabin_types (cabin_type_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_discounts FOREIGN KEY (discount_id) REFERENCES discounts (discount_id);
ALTER TABLE passes ADD CONSTRAINT fk_passes_payment_types FOREIGN KEY (payment_type_id) REFERENCES payment_types (payment_type_id);
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_payment_types FOREIGN KEY (payment_type_id) REFERENCES payment_types (payment_type_id);