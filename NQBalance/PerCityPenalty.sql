-- Created by flimaas 02/11/16
 
--Adding negativ science to the city center
INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES ('DISTRICT_CITY_CENTER', 'CITY_CENTER_NEGATIV_SCIENCE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('CITY_CENTER_NEGATIV_SCIENCE', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('CITY_CENTER_NEGATIV_SCIENCE', 'Amount', '-2');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('CITY_CENTER_NEGATIV_SCIENCE', 'YieldType', 'YIELD_SCIENCE');
 
--Adding negativ culture to the city center 
INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES ('DISTRICT_CITY_CENTER', 'CITY_CENTER_NEGATIV_CULTURE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('CITY_CENTER_NEGATIV_CULTURE', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('CITY_CENTER_NEGATIV_CULTURE', 'Amount', '-2');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('CITY_CENTER_NEGATIV_CULTURE', 'YieldType', 'YIELD_CULTURE');