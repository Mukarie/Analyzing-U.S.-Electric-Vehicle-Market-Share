-- check data upload to sql
SELECT *
FROM vehicle_data;
-- create new table and inserting data from original dataset
create table vehicle_data3
like vehicle_data;

insert into vehicle_data3
select *
from vehicle_data;

-- creating new column from total vehicles in each state
alter table vehicle_data3
add column total_state_vehicles INT DEFAULT 0;

-- calculate the total vehicles in state
UPDATE vehicle_data3 t1
INNER JOIN (
    SELECT state, SUM(Electric+Plug_In_Hybrid_Electric+Hybrid_Electric+Biodiesel+Ethanol_Flex+
    Compressed_Natural_Gas+Propane+Hydrogen+Methanol+Gasoline+Diesel+Unknown_Fuel) AS total_vehicles
    FROM vehicle_data3
    GROUP BY state
) t2 ON t1.state = t2.state
SET t1.total_state_vehicles = t2.total_vehicles;

-- What percentage of vehicles in each state are EVs, PHEVs, HEVs, and gasoline?
SELECT state, ROUND(( Electric * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3;


SELECT state, ROUND(( Plug_In_Hybrid_Electric * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3;


SELECT state, ROUND(( Hybrid_Electric * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3;


SELECT state, ROUND(( Gasoline * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3;


-- Which states have the highest EV adoption rates, and which states lag behind?
SELECT state, ROUND(( Electric * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3
order by per_ev desc
limit 5;


SELECT state, ROUND(( Electric * 100.0) / total_state_vehicles, 2) as per_ev
FROM vehicle_data3
order by per_ev asc
limit 5;
