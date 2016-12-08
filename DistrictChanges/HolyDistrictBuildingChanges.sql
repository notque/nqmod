-- Created by flimaas 03/11/16


--Holy district--
--Reduce shrine flat faith from 2 to 1 and give the city a 5% faith bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_SHRINE' AND YieldType = 'YIELD_FAITH');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_SHRINE', 'SHRINE_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('SHRINE_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('SHRINE_ADD_PERCENTAGE_PRODUCTION', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('SHRINE_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_FAITH');

--Reduce temple flat faith from 3 to 2 and give the city a 5% faith bonus
UPDATE Building_YieldChanges SET YieldChange = '2' WHERE (BuildingType = 'BUILDING_TEMPLE' AND YieldType = 'YIELD_FAITH');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_TEMPLE', 'TEMPLE_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('TEMPLE_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('TEMPLE_ADD_PERCENTAGE_PRODUCTION', 'Amount', '30');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('TEMPLE_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_FAITH');

--Reduce stave church flat faith from 3 to 2 and give the city a 5% faith bonus
UPDATE Building_YieldChanges SET YieldChange = '2' WHERE (BuildingType = 'BUILDING_STAVE_CHURCH' AND YieldType = 'YIELD_FAITH');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STAVE_CHURCH', 'STAVE_CHURCH_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('STAVE_CHURCH_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('STAVE_CHURCH_ADD_PERCENTAGE_PRODUCTION', 'Amount', '30');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('STAVE_CHURCH_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_FAITH');

-- Give each shrine 2 citizen slots to work each
UPDATE Buildings SET CitizenSlots = '2' WHERE BuildingType='BUILDING_SHRINE';

-- Give temple & stave church 3 citizen slots each
UPDATE Buildings SET CitizenSlots = '3' WHERE BuildingType='BUILDING_TEMPLE' or BuildingType='BUILDING_STAVE_CHURCH';

-- give the holy site district 3 flat faith
UPDATE District_CitizenYieldChanges SET YieldChange = '3' WHERE DistrictType = 'DISTRICT_HOLY_SITE';