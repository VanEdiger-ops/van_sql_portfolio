/*
================================================================================
Tampa Railway System - Constraints, Triggers, and Views
================================================================================
Target System: Microsoft SQL Server (T-SQL)
Description: Data validation rules, business logic triggers, and summary views.
*/

USE Tampa_Railway;
GO

-- -----------------------------------------------------------------------------
-- 1. DATA VALIDATION RULES (CONSTRAINTS)
-- -----------------------------------------------------------------------------

-- Employees
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE employees ADD CONSTRAINT gender_check CHECK (gender IN ('F', 'M'));
ALTER TABLE employees ADD CONSTRAINT unique_ssn UNIQUE (ssn);
ALTER TABLE employees ADD CONSTRAINT birth_date_check CHECK (birth_date < GETDATE());
ALTER TABLE employees ADD CONSTRAINT hire_date_check CHECK (hire_date <= GETDATE());
ALTER TABLE employees ADD CONSTRAINT not_self_manager_check CHECK (employee_id_reports_to <> employee_id);
ALTER TABLE employees ADD CONSTRAINT default_second_address DEFAULT 'N/A' FOR address_line2;

-- Passes
ALTER TABLE passes ADD CONSTRAINT purchase_start_date CHECK (purchase_date <= start_date);
ALTER TABLE passes ADD CONSTRAINT purchase_start_time CHECK (purchase_time < start_time);
ALTER TABLE passes ADD CONSTRAINT start_end_date CHECK (start_date <= end_date);
ALTER TABLE passes ADD CONSTRAINT start_end_time CHECK (start_time < end_time);
ALTER TABLE passes ADD CONSTRAINT unique_employee_singlepass UNIQUE (start_date, start_time, employee_id);
ALTER TABLE passes ADD CONSTRAINT purchase_date_future CHECK (purchase_date <= GETDATE());
ALTER TABLE passes ADD CONSTRAINT final_price_check CHECK (final_price >= 0);

-- Customers
ALTER TABLE customers ADD CONSTRAINT customer_birthdate_check CHECK (birth_date < GETDATE());
ALTER TABLE customers ADD CONSTRAINT unique_customer_email UNIQUE (email);
ALTER TABLE customers ADD CONSTRAINT customer_default_secondaddress DEFAULT 'N/A' FOR address_line2;
ALTER TABLE customers ADD CONSTRAINT customer_gender_check CHECK (gender IN ('F', 'M'));
ALTER TABLE customers ADD CONSTRAINT unique_phone1 UNIQUE (phone1);
ALTER TABLE customers ADD CONSTRAINT phone_different_check CHECK (phone1 <> phone2);

-- Tickets
ALTER TABLE tickets ADD CONSTRAINT purchase_boarding_date CHECK (purchase_date <= boarding_date);
ALTER TABLE tickets ADD CONSTRAINT unique_ticket_travel_customer UNIQUE (travel_id, customer_id);
ALTER TABLE tickets ADD CONSTRAINT purchase_future_date CHECK (purchase_date <= GETDATE());
ALTER TABLE tickets ADD CONSTRAINT final_price_not_negative CHECK (final_price >= 0);
ALTER TABLE tickets ADD CONSTRAINT customer_id_gt CHECK (customer_id > 0);
ALTER TABLE tickets ADD CONSTRAINT travel_id_gt CHECK (travel_id > 0);

-- Locations
ALTER TABLE locations ADD CONSTRAINT unique_name_location UNIQUE (name);
ALTER TABLE locations ADD CONSTRAINT check_location_exists CHECK (location_x IS NOT NULL AND location_y IS NOT NULL);
ALTER TABLE locations ADD CONSTRAINT unique_location_coordinates UNIQUE (location_x, location_y);
ALTER TABLE locations ADD CONSTRAINT default_second_address_locations DEFAULT 'N/A' FOR address_line2;
ALTER TABLE locations ADD CONSTRAINT check_city_state_id CHECK (city_state_id > 0);

-- Wagons
ALTER TABLE wagons ADD CONSTRAINT fabrication_future_date CHECK (fabrication_date <= first_use_date);
ALTER TABLE wagons ADD CONSTRAINT capacity_check CHECK (capacity > 0);
ALTER TABLE wagons ADD CONSTRAINT brand_model_check CHECK (brand <> model);

-- Travels
ALTER TABLE travels ADD CONSTRAINT start_end_actual CHECK (start_time_actual < end_time_actual);
ALTER TABLE travels ADD CONSTRAINT date_travels_check CHECK (date <= GETDATE());
ALTER TABLE travels ADD CONSTRAINT route_id_check CHECK (route_id > 0);

-- Routes
ALTER TABLE routes ADD CONSTRAINT start_end_routes CHECK (start_time < end_time);
ALTER TABLE routes ADD CONSTRAINT origin_destination_check CHECK (city_state_id_origin <> city_state_id_destination);
ALTER TABLE routes ADD CONSTRAINT weekday_id_check CHECK (weekday_id BETWEEN 1 AND 7);

-- Discounts
ALTER TABLE discounts ADD CONSTRAINT unique_discount_name UNIQUE (name);
ALTER TABLE discounts ADD CONSTRAINT discount_start_end_date CHECK (start_date < end_date);
ALTER TABLE discounts ADD CONSTRAINT percentage_check CHECK (percentage > 0 AND percentage <= 100);

-- Cards
ALTER TABLE cards ADD CONSTRAINT unique_customer_employee_card UNIQUE (employee_id, customer_id);
ALTER TABLE cards ADD CONSTRAINT purchase_date_card_check CHECK (purchase_date <= GETDATE());
ALTER TABLE cards ADD CONSTRAINT check_card_owner CHECK (employee_id IS NOT NULL OR customer_id IS NOT NULL);
GO


-- -----------------------------------------------------------------------------
-- 2. AUTOMATED BUSINESS LOGIC (TRIGGERS)
-- -----------------------------------------------------------------------------

CREATE TRIGGER		Date_Restrict_2016
ON					travels
AFTER INSERT, UPDATE		
AS 
BEGIN

IF EXISTS (			SELECT 1 
					FROM inserted
					WHERE date < '2016-01-01' or date > GETDATE())
BEGIN				RAISERROR('Error: Dates must be between 2016-01-01 and the current date.', 16, 1);
ROLLBACK TRANSACTION
END
END;
GO


CREATE TRIGGER		Last_Name_Length
ON					customers
AFTER INSERT, UPDATE
AS
BEGIN

IF EXISTS			(SELECT 1
					FROM inserted
					WHERE 
						LEN(last_name) BETWEEN (SELECT min(len(last_name)) FROM customers) 
									   AND (SELECT max(len(last_name)) FROM customers)
					)
BEGIN				RAISERROR('Error: Last name length cannot fall between the existing minimum and maximum lengths.', 16, 1);
ROLLBACK TRANSACTION
END
END;
GO


-- -----------------------------------------------------------------------------
-- 3. SUMMARY VIEWS (REPORTING)
-- -----------------------------------------------------------------------------

CREATE VIEW City_View_Travel_MaleFemale_2016_2017 AS

SELECT TOP 50		cs.name AS city_name, COUNT(DISTINCT t.travel_id) AS total_travels, COUNT(DISTINCT CASE WHEN c.gender = 'M' THEN t.travel_id END) AS male_travels, 
					COUNT(DISTINCT CASE WHEN c.gender = 'F' THEN t.travel_id END) AS female_travels

FROM				cities_states cs
	JOIN			customers c ON cs.city_state_id = c.city_state_id
	JOIN			tickets t ON c.customer_id = t.customer_id
	JOIN			travels tr ON t.travel_id = tr.travel_id
WHERE				YEAR(tr.date) IN (2016, 2017)
GROUP BY			cs.name
ORDER BY			total_travels DESC;
GO


CREATE VIEW City_Name AS
SELECT		name as City_Name
FROM		cities_states;
GO


CREATE VIEW Travels_Customer_City_1617 AS
SELECT		count(distinct t.travel_id) as NumberOfTravels, cs.name as CityName
FROM		cities_states as cs
	JOIN		customers as c ON cs.city_state_id = c.city_state_id
	JOIN		tickets as ti ON c.customer_id = ti.customer_id
	JOIN		travels as t ON ti.travel_id = t.travel_id
WHERE		YEAR(t.date) IN (2016, 2017)
GROUP BY	cs.name;
GO


CREATE VIEW Travels_MaleCustomer_City_1617 AS
SELECT		count(distinct t.travel_id) as NumberOfTravels, cs.name as CityName
FROM		cities_states as cs
	JOIN		customers as c ON cs.city_state_id = c.city_state_id
	JOIN		tickets as ti ON c.customer_id = ti.customer_id
	JOIN		travels as t ON ti.travel_id = t.travel_id
WHERE		c.gender = 'M' and YEAR(t.date) IN (2016, 2017)
GROUP BY	cs.name;
GO


CREATE VIEW Travels_FemaleCustomer_City_1617 AS
SELECT		count(distinct t.travel_id) as NumberOfTravels, cs.name as CityName
FROM		cities_states as cs
	JOIN		customers as c ON cs.city_state_id = c.city_state_id
	JOIN		tickets as ti ON c.customer_id = ti.customer_id
	JOIN		travels as t ON ti.travel_id = t.travel_id
WHERE		c.gender = 'F' and YEAR(t.date) IN (2016, 2017)
GROUP BY	cs.name;
GO


CREATE VIEW Travels_Customer_50_City_1617 AS
SELECT TOP 50		count(distinct t.travel_id) as NumberOfTravels, cs.name as CityName
FROM				cities_states as cs
	JOIN			customers as c ON cs.city_state_id = c.city_state_id
	JOIN			tickets as ti ON c.customer_id = ti.customer_id
	JOIN			travels as t ON ti.travel_id = t.travel_id
WHERE				YEAR(t.date) IN (2016, 2017)
GROUP BY			cs.name
ORDER BY			NumberOfTravels DESC;
GO