
-----------------------------------------------
-- Tech Costs
-----------------------------------------------
 
-- First attempt (yes, that's +10, not * 10)
UPDATE Technologies     SET Cost = Cost + 10	WHERE EraType ='ERA_ANCIENT';
UPDATE Technologies     SET Cost = Cost * 1.25  WHERE EraType ='ERA_CLASSICAL';
UPDATE Technologies     SET Cost = Cost * 1.25  WHERE EraType ='ERA_MEDIEVAL';
UPDATE Technologies     SET Cost = Cost * 1.75  WHERE EraType ='ERA_RENAISSANCE';
UPDATE Technologies     SET Cost = Cost * 1.75  WHERE EraType ='ERA_INDUSTRIAL';
UPDATE Technologies     SET Cost = Cost * 2    	WHERE EraType ='ERA_MODERN';
UPDATE Technologies     SET Cost = Cost * 2    	WHERE EraType ='ERA_ATOMIC';
UPDATE Technologies     SET Cost = Cost * 2.25  WHERE EraType ='ERA_INFORMATION';
 
-- First attempt (yes, that's +10, not * 10)
UPDATE Civics     SET Cost = Cost + 10    WHERE EraType ='ERA_ANCIENT' AND CivicType <> 'CIVIC_CODE_OF_LAWS';
UPDATE Civics     SET Cost = Cost * 1.25  WHERE EraType ='ERA_CLASSICAL';
UPDATE Civics     SET Cost = Cost * 1.25  WHERE EraType ='ERA_MEDIEVAL';
UPDATE Civics     SET Cost = Cost * 1.75  WHERE EraType ='ERA_RENAISSANCE';
UPDATE Civics     SET Cost = Cost * 1.75  WHERE EraType ='ERA_INDUSTRIAL';
UPDATE Civics     SET Cost = Cost * 2     WHERE EraType ='ERA_MODERN';
UPDATE Civics     SET Cost = Cost * 2     WHERE EraType ='ERA_ATOMIC';
UPDATE Civics     SET Cost = Cost * 2.25  WHERE EraType ='ERA_INFORMATION';

UPDATE Technologies SET Cost = (Cost * 1.5) WHERE
	TechnologyType = 'TECH_ROBOTICS' or 
	TechnologyType = 'TECH_NUCLEAR_FUSION' or 
	TechnologyType = 'TECH_NANOTECHNOLOGY' or
	TechnologyType = 'TECH_FUTURE_TECH';


-----------------------------------------------
-- Projects
-----------------------------------------------
-- Double production cost, gives far too many GPs for value in Online Speed
UPDATE Projects SET Cost = (Cost * 2) WHERE CostProgressionModel = 'COST_PROGRESSION_GAME_PROGRESS';

UPDATE Projects SET Cost = (Cost * 2) WHERE ProjectType = 'PROJECT_BUILD_NUCLEAR_DEVICE' or ProjectType = 'PROJECT_BUILD_THERMONUCLEAR_DEVICE';

-----------------------------------------------
-- Buildings
-----------------------------------------------
-- nerf the amenities from colleseum
UPDATE Buildings SET Entertainment = '2' WHERE BuildingType = 'BUILDING_COLOSSEUM';
UPDATE Buildings SET RegionalRange = '4' WHERE BuildingType = 'BUILDING_COLOSSEUM';
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE BuildingType = 'BUILDING_COLOSSEUM';