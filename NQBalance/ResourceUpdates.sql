-- Created by HellBlazer 01/11/16

-- Allow iron to spawn next to rivers
UPDATE Resources SET NoRiver = '0' WHERE ResourceType='RESOURCE_IRON';

-- Update Coal, Oil and Aluminium frequency to 15
UPDATE Resources SET Frequency = '15' WHERE ResourceType='RESOURCE_COAL' or ResourceType='RESOURCE_OIL' or ResourceType='RESOURCE_ALUMINUM';

-- Update Whales and Pearls frequency to 2
UPDATE Resources SET Frequency = '4' WHERE ResourceType='RESOURCE_WHALES' or ResourceType='RESOURCE_PEARLS';

-- Update the frequency of fish and crabs
UPDATE Resources SET Frequency = '15' WHERE ResourceType='RESOURCE_CRABS'; -- Was 17
UPDATE Resources SET Frequency = '21' WHERE ResourceType='RESOURCE_FISH'; -- Was 23

-- Remove marble from glassland spawns
DELETE FROM Resource_ValidTerrains WHERE ResourceType="RESOURCE_MARBLE" and TerrainType="TERRAIN_GRASS";

-- Remove furs from plain tundra tiles (will still spawn on tundra forest tiles)
DELETE FROM Resource_ValidTerrains WHERE ResourceType="RESOURCE_FURS" and TerrainType="TERRAIN_TUNDRA";

-- Update terrains that strategic, luxury and bonus resources can spawn on
INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES ('RESOURCE_ALUMINUM', 'TERRAIN_GRASS_HILLS'),
	('RESOURCE_ALUMINUM', 'TERRAIN_PLAINS_HILLS'),
	('RESOURCE_ALUMINUM', 'TERRAIN_TUNDRA_HILLS'),
	('RESOURCE_ALUMINUM', 'TERRAIN_SNOW_HILLS'),
	('RESOURCE_COAL', 'TERRAIN_TUNDRA_HILLS'),
	('RESOURCE_COAL', 'TERRAIN_DESERT_HILLS'),
	('RESOURCE_OIL', 'TERRAIN_GRASS'),
	('RESOURCE_OIL', 'TERRAIN_PLAINS'),
	('RESOURCE_IRON', 'TERRAIN_GRASS'),
	('RESOURCE_IRON', 'TERRAIN_PLAINS'),
	('RESOURCE_SILVER', 'TERRAIN_PLAINS_HILLS'),
	('RESOURCE_MERCURY', 'TERRAIN_GRASS'), 
	('RESOURCE_COCOA', 'TERRAIN_PLAINS_HILLS'), 
	('RESOURCE_COCOA', 'TERRAIN_PLAINS');

-- Add +1 more food to cattle
UPDATE Resource_YieldChanges SET YieldChange = '2' WHERE ResourceType='RESOURCE_CATTLE';

-- Remove 1 food from sugar and spices
UPDATE Resource_YieldChanges SET YieldChange = '1' WHERE ResourceType='RESOURCE_SUGAR' or ResourceType='RESOURCE_SPICES';

-- Remove science food from tea and faith from tobbaco
UPDATE Resource_YieldChanges SET YieldChange = '0' WHERE ResourceType='RESOURCE_TEA' or ResourceType='RESOURCE_TOBACCO';

-- Set gold from Cocoa and truffles to 2 from 3
UPDATE Resource_YieldChanges SET YieldChange = '2' WHERE ResourceType='RESOURCE_TRUFFLES' or ResourceType='RESOURCE_COCOA';

-- Add +1 faith to insence
UPDATE Resource_YieldChanges SET YieldChange = '2' WHERE ResourceType='RESOURCE_INCENSE';

-- Update yields for strategic, luxury and bonus resources
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES ('RESOURCE_SUGAR','YIELD_GOLD', '1'),
	('RESOURCE_TEA','YIELD_CULTURE','1'),
	('RESOURCE_TEA','YIELD_GOLD','1'),
	('RESOURCE_MERCURY','YIELD_PRODUCTION','1'),
	('RESOURCE_JADE','YIELD_GOLD','1'),
	('RESOURCE_TRUFFLES','YIELD_FOOD','1'),
	('RESOURCE_COCOA','YIELD_FOOD','1'),
	('RESOURCE_SILK','YIELD_GOLD','1'),
	('RESOURCE_PEARLS','YIELD_GOLD','2'),
	('RESOURCE_TOBACCO','YIELD_CULTURE','1'),
	('RESOURCE_TOBACCO','YIELD_GOLD','1'),
	('RESOURCE_COFFEE','YIELD_GOLD','1');


