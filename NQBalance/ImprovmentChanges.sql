-- Created by HellBlazer 01/11/16

-- Move +1 food from plantations from Scientific theory to Medieval Faires
DELETE FROM Improvement_BonusYieldChanges WHERE Id="10";
INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqCivic) VALUES ('10', 'IMPROVEMENT_PLANTATION', 'YIELD_FOOD', '1', 'CIVIC_MEDIEVAL_FAIRES');

-- Move +1 from pastures from Robotics to Civil Service
DELETE FROM Improvement_BonusYieldChanges WHERE Id="9";
INSERT INTO Improvement_BonusYieldChanges (Id, ImprovementType, YieldType, BonusYieldChange, PrereqCivic) VALUES ('9', 'IMPROVEMENT_PASTURE', 'YIELD_PRODUCTION', '1', 'CIVIC_CIVIL_SERVICE');

-- Move grassland hills and plains hills farms to Feudalism from civli engineering
UPDATE Improvement_ValidTerrains SET PrereqCivic = 'CIVIC_FEUDALISM' WHERE
	(ImprovementType = 'IMPROVEMENT_FARM' AND TerrainType = 'TERRAIN_PLAINS_HILLS') or
	(ImprovementType = 'IMPROVEMENT_FARM' AND TerrainType = 'TERRAIN_GRASS_HILLS');