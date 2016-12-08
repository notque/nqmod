-- Created by flimaas 03/11/16


--Theater square--
--Reduce amphitheater flat culture from 2 to 1 and give the city a 5% culture bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_AMPHITHEATER' AND YieldType = 'YIELD_CULTURE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_AMPHITHEATER', 'AMPHITHEATER_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('AMPHITHEATER_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('AMPHITHEATER_ADD_PERCENTAGE_PRODUCTION', 'Amount', '5');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('AMPHITHEATER_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_CULTURE');

UPDATE Buildings SET Description = 'LOC_BUILDING_AMPHITHEATER_DESCRIPTION' WHERE BuildingType='BUILDING_AMPHITHEATER';


--Reduce art museum flat culture from 3 to 2 and give the city a 5% culture bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_MUSEUM_ART' AND YieldType = 'YIELD_CULTURE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MUSEUM_ART', 'MUSEUM_ART_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('MUSEUM_ART_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MUSEUM_ART_ADD_PERCENTAGE_PRODUCTION', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MUSEUM_ART_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_CULTURE');


--Reduce archeological museum flat culture from 3 to 2 and give the city a 5% culture bonus
UPDATE Building_YieldChanges SET YieldChange = '1' WHERE (BuildingType = 'BUILDING_MUSEUM_ARTIFACT' AND YieldType = 'YIELD_CULTURE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MUSEUM_ARTIFACT', 'MUSEUM_ARTIFACT_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('MUSEUM_ARTIFACT_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MUSEUM_ARTIFACT_ADD_PERCENTAGE_PRODUCTION', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MUSEUM_ARTIFACT_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_CULTURE');


--Reduce broadcast center flat culture from 4 to 3 and give the city a 5% culture bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_BROADCAST_CENTER' AND YieldType = 'YIELD_CULTURE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BROADCAST_CENTER', 'BROADCAST_CENTER_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('BROADCAST_CENTER_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BROADCAST_CENTER_ADD_PERCENTAGE_PRODUCTION', 'Amount', '25');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BROADCAST_CENTER_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_CULTURE');

UPDATE Buildings SET Description = 'LOC_BUILDING_BROADCAST_CENTER_DESCRIPTION' WHERE BuildingType='BUILDING_BROADCAST_CENTER';


--Reduce film studio flat culture from 4 to 3 and give the city a 5% culture bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_FILM_STUDIO' AND YieldType = 'YIELD_CULTURE');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_FILM_STUDIO', 'FILM_STUDIO_ADD_PERCENTAGE_PRODUCTION');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('FILM_STUDIO_ADD_PERCENTAGE_PRODUCTION', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('FILM_STUDIO_ADD_PERCENTAGE_PRODUCTION', 'Amount', '25');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('FILM_STUDIO_ADD_PERCENTAGE_PRODUCTION', 'YieldType', 'YIELD_CULTURE');

-- Give each Art & archlogical museums 2 citizen slots to work each
UPDATE Buildings SET CitizenSlots = '2' WHERE BuildingType='BUILDING_MUSEUM_ART' or BuildingType='BUILDING_MUSEUM_ARTIFACT';

-- Give broadcast tower & film studio 3 citizen slots each
UPDATE Buildings SET CitizenSlots = '3' WHERE BuildingType='BUILDING_BROADCAST_CENTER' or BuildingType='BUILDING_FILM_STUDIO';

-- give the thearter district 3 flat culture
UPDATE District_CitizenYieldChanges SET YieldChange = '3' WHERE DistrictType = 'DISTRICT_THEATER';