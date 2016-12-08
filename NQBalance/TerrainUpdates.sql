-- Created by HellBlazer 01/11/16

-- add 1 production to coast tiles
INSERT INTO Terrain_YieldChanges (TerrainType, YieldType, YieldChange) VALUES ('TERRAIN_COAST', 'YIELD_PRODUCTION', '1');

-- remove gold from coast tiles
UPDATE Terrain_YieldChanges SET YieldChange='0' WHERE TerrainType='TERRAIN_COAST' and YieldType='YIELD_GOLD';

-- add +1 more food to coast tiles
UPDATE Terrain_YieldChanges SET YieldChange='2' WHERE TerrainType='TERRAIN_COAST' and YieldType='YIELD_FOOD';