/*
================================================================================
Tampa Railway System - Queries and Analytical Reports
================================================================================
Target System: Microsoft SQL Server (T-SQL)
Description: Operational metrics, capacity analysis, and passenger demographics.
*/

USE Tampa_Railway;
GO

--Based on historical data, your projections for the next year are to have 20% more demand (proportional to all tickets and cabins), would you rather: 
--a) Offer more travels? 
--b) Increase the number of wagons per travel according to demand, 
--c) Increase prices, or 
--d) do nothing. 
--Please answer this question from an industrial engineering point of view. Some options may not require writing a query but they may require some analysis.

-- Note: Counts the number of tickets sold for each travel to see passenger volume.

SELECT			tr.travel_id, count(ti.ticket_id) as ticket_demand
FROM			travels as tr, tickets as ti
WHERE			ti.travel_id = tr.travel_id
GROUP BY		tr.travel_id
ORDER BY		ticket_demand DESC;


-- Note: Counts how many times a pass was used for each travel.

SELECT			pt.travel_id, count(*) as pass_demand
FROM			passes_travels as pt
GROUP BY		pt.travel_id
ORDER BY		pass_demand DESC;


-- Note: Combines ticket sales and pass usage to find the total headcount on each train trip.

SELECT			tr.travel_id, count(distinct ti.ticket_id) as ticket_demand, count(distinct pt.pass_id) as pass_demand, count(distinct ti.ticket_id) + count(distinct pt.pass_id) as total_demand 
FROM			travels as tr 
	left join	tickets as ti 
	on			ti.travel_id = tr.travel_id 
	left join	passes_travels as pt 
	on			pt.travel_id = tr.travel_id
GROUP BY		tr.travel_id
ORDER BY		total_demand DESC;

-- Technical Analysis:
-- Trains currently run with 3 wagons holding 60 people each, giving a maximum capacity of 180 seats per trip. The combined 
-- demand query shows that our busiest trips are already overcrowding at 186 passengers.
-- With an expected 20% increase next year, our busiest periods will hit an estimated 223.2 passengers. 
-- Adding a 4th wagon during high-demand periods expands our capacity to 240 seats (4 x 60). This handles the passenger 
-- surge using our existing schedules, completely avoiding the major extra costs of running entirely new trains (fuel, 
-- crew, and scheduling). Therefore, option (B) is the most efficient choice.


--What is the most used route on weekends (saturday, sunday) in terms of customers travelling including passes and tickets in 2016?

-- Note: Finds the most popular weekend route by adding up tickets and pass uses, keeping trips even if they only sold one type.

SELECT	TOP 1	count(distinct ti.ticket_id) + count(distinct pt.pass_id) as total_customers, r.route_id as most_used_route
FROM			routes as r
	join		travels as tr on r.route_id = tr.route_id
	left join	tickets as ti on tr.travel_id = ti.travel_id
	left join	passes_travels as pt on tr.travel_id = pt.travel_id
WHERE			year(tr.date) = 2016 and datepart(weekday, tr.date) in (1, 7)
GROUP BY		r.route_id
ORDER BY		total_customers DESC;


--What is the most sold cabin type in tickets in the first quarter of 2016 within each age group?

-- Note: Groups customers into Young, Adult, and Senior brackets based on their age on March 31, 2016, and shows which cabin type sold the best for each.

SELECT			count(*) as tickets_sold, ct.name,
  CASE
    WHEN datediff(Year, c.birth_date, '2016-03-31') between 18 and 35 THEN 'Young'
    WHEN datediff(Year, c.birth_date, '2016-03-31') between 36 and 64 THEN 'Adult'
    WHEN datediff(Year, c.birth_date, '2016-03-31') >= 65 THEN 'Senior'
  END AS age_group
FROM			tickets as ti
	join		customers as c on c.customer_id = ti.customer_id
	join		cabin_types as ct on ct.cabin_type_id = ti.cabin_type_id
WHERE			ti.purchase_date between '2016-01-01' and '2016-03-31'
GROUP BY		ct.name,
  CASE
    WHEN datediff(Year, c.birth_date, '2016-03-31') between 18 and 35 THEN 'Young'
    WHEN datediff(Year, c.birth_date, '2016-03-31') between 36 and 64 THEN 'Adult'
    WHEN datediff(Year, c.birth_date, '2016-03-31') >= 65 THEN 'Senior'
  END 
ORDER BY		age_group, tickets_sold DESC;


--What is the hour of the day where the most tickets were sold in 2016?

-- Note: Looks at the hour component of the sales timestamp to find out which specific hour of the day had the highest volume of ticket sales.

SELECT TOP 1	datepart(hour, purchase_time) as hour_of_day, count(*) as tickets_sold
FROM			tickets as ti
WHERE			year(purchase_date) = 2016
GROUP BY		datepart(hour, purchase_time)
ORDER BY		tickets_sold DESC;


--What are the three employees that have sold the most passes in 2016?

-- Note: Counts up total pass transactions to find the top three employees with the highest sales numbers.

SELECT TOP 3    employee_id, COUNT(*) AS passes_sold
FROM			passes as p
WHERE			YEAR(purchase_date) = 2016
GROUP BY		employee_id
ORDER BY		passes_sold DESC;