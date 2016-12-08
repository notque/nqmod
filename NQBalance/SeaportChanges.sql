-- Created by HellBlazer 01/11/16

-- Make seaports give +1 production to coast tiles
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_SEAPORT', 'PORT_ADDCOASTPROD');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES ('PORT_ADDCOASTPROD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'SHIPYARD_COAST_REQUIREMENTS');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('SHIPYARD_COAST_REQUIREMENTS', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('SHIPYARD_COAST_REQUIREMENTS', 'REQUIRES_COAST_IN_PLOT');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('PORT_ADDCOASTPROD', 'Amount', '1');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('PORT_ADDCOASTPROD', 'YieldType', 'YIELD_PRODUCTION');