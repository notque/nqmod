-- Created by flimaas 03/11/16


--Campus--
--Reduce libary flat science from 2 to 1 and give the city a 5% science bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_LIBRARY' AND YieldType = 'YIELD_SCIENCE');

--DELETE FROM Building_YieldChanges WHERE (BuildingType = 'BUILDING_LIBRARY' AND YieldType = 'YIELD_SCIENCE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_LIBRARY', 'LIBRARY_ADD_PERCENTAGE_SCIENCE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('LIBRARY_ADD_PERCENTAGE_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('LIBRARY_ADD_PERCENTAGE_SCIENCE', 'Amount', '5');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('LIBRARY_ADD_PERCENTAGE_SCIENCE', 'YieldType', 'YIELD_SCIENCE');

UPDATE Buildings SET Description = 'LOC_BUILDING_LIBRARAY_DESCRIPTION' WHERE BuildingType='BUILDING_LIBRARY';


--Reduce university flat science from 4 to 3 and give the city a 5% science bonus
UPDATE Building_YieldChanges SET YieldChange = '2' WHERE (BuildingType = 'BUILDING_UNIVERSITY' AND YieldType = 'YIELD_SCIENCE');

--DELETE FROM Building_YieldChanges WHERE (BuildingType = 'BUILDING_UNIVERSITY' AND YieldType = 'YIELD_SCIENCE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_UNIVERSITY', 'UNIVERSITY_ADD_PERCENTAGE_SCIENCE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('UNIVERSITY_ADD_PERCENTAGE_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('UNIVERSITY_ADD_PERCENTAGE_SCIENCE', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('UNIVERSITY_ADD_PERCENTAGE_SCIENCE', 'YieldType', 'YIELD_SCIENCE');

UPDATE Buildings SET Description = 'LOC_BUILDING_UNIVERSITY_DESCRIPTION' WHERE BuildingType='BUILDING_UNIVERSITY';


--Reduce madrasa flat science from 5 to 4 and give the city a 5% science bonus
UPDATE Building_YieldChanges SET YieldChange = '4' WHERE (BuildingType = 'BUILDING_MADRASA' AND YieldType = 'YIELD_SCIENCE');
--DELETE FROM Building_YieldChanges WHERE (BuildingType = 'BUILDING_MADRASA' AND YieldType = 'YIELD_SCIENCE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MADRASA', 'MADRASA_ADD_PERCENTAGE_SCIENCE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('MADRASA_ADD_PERCENTAGE_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MADRASA_ADD_PERCENTAGE_SCIENCE', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MADRASA_ADD_PERCENTAGE_SCIENCE', 'YieldType', 'YIELD_SCIENCE');


--Reduce research lab flat science from 5 to 4 and give the city a 5% science bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_RESEARCH_LAB' AND YieldType = 'YIELD_SCIENCE');
--DELETE FROM Building_YieldChanges WHERE (BuildingType = 'BUILDING_RESEARCH_LAB' AND YieldType = 'YIELD_SCIENCE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_RESEARCH_LAB', 'RESEARCH_LAB_ADD_PERCENTAGE_SCIENCE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('RESEARCH_LAB_ADD_PERCENTAGE_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('RESEARCH_LAB_ADD_PERCENTAGE_SCIENCE', 'Amount', '25');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('RESEARCH_LAB_ADD_PERCENTAGE_SCIENCE', 'YieldType', 'YIELD_SCIENCE');

UPDATE Buildings SET Description = 'LOC_BUILDING_RESEARCH_LAB_DESCRIPTION' WHERE BuildingType='BUILDING_RESEARCH_LAB';

-- Give each university  2 citizen slots to work each
UPDATE Buildings SET CitizenSlots = '2' WHERE BuildingType='BUILDING_UNIVERSITY';

-- Give labs and madrasa 3 citizen slots each
UPDATE Buildings SET CitizenSlots = '3' WHERE BuildingType='BUILDING_RESEARCH_LAB' or BuildingType='BUILDING_MADRASA';

-- give the campus district 3 flat science
UPDATE District_CitizenYieldChanges SET YieldChange = '3' WHERE DistrictType = 'DISTRICT_CAMPUS';

-- give great scientits point for working the citizen slots
--INSERT INTO District_CitizenGreatPersonPoints (DistrictType, GreatPersonClassType, PointsPerTurn) VALUES ('DISTRICT_CAMPUS', 'GREAT_PERSON_CLASS_SCIENTIST', '1');

-- remove great scientist points from library, uni's and labs
--UPDATE Building_GreatPersonPoints SET PointsPerTurn = '0' WHERE BuildingType = 'BUILDING_LIBRARY' or BuildingType = 'BUILDING_UNIVERSITY' or BuildingType = 'BUILDING_RESEARCH_LAB';

--DELETE FROM Building_GreatPersonPoints WHERE BuildingType = 'BUILDING_LIBRARY' or BuildingType = 'BUILDING_UNIVERSITY' or BuildingType = 'BUILDING_RESEARCH_LAB';