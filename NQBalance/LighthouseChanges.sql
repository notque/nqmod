-- Created by HellBlazer 01/11/16

-- Make lighthouse give +1 food to coast tiles
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_LIGHTHOUSE', 'LIGHTHOUSE_ADDCOASTFOOD');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES ('LIGHTHOUSE_ADDCOASTFOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'LIGHTHOUSE_FOOD_REQUIREMENTS');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('LIGHTHOUSE_FOOD_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('LIGHTHOUSE_FOOD_REQUIREMENTS', 'REQUIRES_COAST_IN_PLOT');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES ('REQUIRES_COAST_IN_PLOT', 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQUIRES_COAST_IN_PLOT', 'TerrainType', 'TERRAIN_COAST');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('LIGHTHOUSE_ADDCOASTFOOD', 'Amount', '1');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('LIGHTHOUSE_ADDCOASTFOOD', 'YieldType', 'YIELD_FOOD');