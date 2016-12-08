-- Created by flimaas 03/11/16

--Industrial zone--
--Reduce workshop flat production from 2 to 1 and give the city a 5% production bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_WORKSHOP' AND YieldType = 'YIELD_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_WORKSHOP', 'WORKSHOP_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('WORKSHOP_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WORKSHOP_ADD_PERCENTAGE_PRODUCTION', 'Amount', '5');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WORKSHOP_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');

UPDATE Buildings SET Description = 'LOC_BUILDING_WORKSHOP_DESCRIPTION' WHERE BuildingType='BUILDING_WORKSHOP';

--Reduce factory flat production from 3 to 2 and give the city a 5% production bonus
UPDATE Building_YieldChanges SET YieldChange = '2' WHERE (BuildingType = 'BUILDING_FACTORY' AND YieldType = 'YIELD_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_FACTORY', 'FACTORY_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('FACTORY_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('FACTORY_ADD_PERCENTAGE_PRODUCTION', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('FACTORY_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');

--Reduce electronics factory flat production from 4 to 3 and give the city a 5% production bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_ELECTRONICS_FACTORY' AND YieldType = 'YIELD_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_ELECTRONICS_FACTORY', 'ELECTRONICS_FACTORY_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('ELECTRONICS_FACTORY_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('ELECTRONICS_FACTORY_ADD_PERCENTAGE_PRODUCTION', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('ELECTRONICS_FACTORY_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');

--Reduce power plant flat production from 4 to 3 and give the city a 5% production bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_POWER_PLANT' AND YieldType = 'YIELD_PRODUCTION');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_POWER_PLANT', 'POWER_PLANT_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('POWER_PLANT_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('POWER_PLANT_ADD_PERCENTAGE_PRODUCTION', 'Amount', '25');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('POWER_PLANT_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');

-- Give each factory or elec factory 2 citizen slots to work each
UPDATE Buildings SET CitizenSlots = '2' WHERE BuildingType='BUILDING_FACTORY' or BuildingType='BUILDING_ELECTRONICS_FACTORY';

-- Give temple & stave church 3 citizen slots each
UPDATE Buildings SET CitizenSlots = '3' WHERE BuildingType='BUILDING_POWER_PLANT';

-- give the commercial district 3 flat production
UPDATE District_CitizenYieldChanges SET YieldChange = '3' WHERE DistrictType = 'DISTRICT_INDUSTRIAL_ZONE';