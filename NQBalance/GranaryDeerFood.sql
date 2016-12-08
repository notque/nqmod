-- Created by HellBlazer 01/11/16

-- Make granary give +1 food to deer tiles
INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_GRANARY', 'GRANARY_ADDDEERFOOD');
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES ('GRANARY_ADDDEERFOOD', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'RESOURCE_IS_DEER');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('RESOURCE_IS_DEER', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('RESOURCE_IS_DEER', 'REQUIRES_DEER_IN_PLOT');
INSERT INTO Requirements (RequirementId, RequirementType) VALUES ('REQUIRES_DEER_IN_PLOT', 'REQUIREMENT_PLOT_RESOURCE_TYPE_MATCHES');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQUIRES_DEER_IN_PLOT', 'ResourceType', 'RESOURCE_DEER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('GRANARY_ADDDEERFOOD', 'Amount', '1');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('GRANARY_ADDDEERFOOD', 'YieldType', 'YIELD_FOOD');
