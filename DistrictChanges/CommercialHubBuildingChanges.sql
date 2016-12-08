-- Created by flimaas 03/11/16


--Commercial hub--
--Reduce market flat gold from 3 to 2 and give the city a 7,5% gold bonus
UPDATE Building_YieldChanges SET YieldChange = '2' WHERE (BuildingType = 'BUILDING_MARKET' AND YieldType = 'YIELD_GOLD');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MARKET', 'MARKET_ADD_PERCENTAGE_GOLD');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('MARKET_ADD_PERCENTAGE_GOLD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MARKET_ADD_PERCENTAGE_GOLD', 'Amount', '5');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('MARKET_ADD_PERCENTAGE_GOLD', 'YieldType', 'YIELD_GOLD');

UPDATE Buildings SET Description = 'LOC_BUILDING_MARKET_DESCRIPTION' WHERE BuildingType='BUILDING_MARKET';

--Reduce bank flat gold from 5 to 4 and give the city a 5% gold bonus
UPDATE Building_YieldChanges SET YieldChange = '3' WHERE (BuildingType = 'BUILDING_BANK' AND YieldType = 'YIELD_GOLD');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BANK', 'BANK_ADD_PERCENTAGE_GOLD');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('BANK_ADD_PERCENTAGE_GOLD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BANK_ADD_PERCENTAGE_GOLD', 'Amount', '15');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('BANK_ADD_PERCENTAGE_GOLD', 'YieldType', 'YIELD_GOLD');

UPDATE Buildings SET Description = 'LOC_BUILDING_BANK_DESCRIPTION' WHERE BuildingType='BUILDING_BANK';

--Reduce stock exchange flat gold from 7 to 6 and give the city a 5% gold bonus
UPDATE Building_YieldChanges SET YieldChange = '4' WHERE (BuildingType = 'BUILDING_STOCK_EXCHANGE' AND YieldType = 'YIELD_GOLD');

INSERT INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STOCK_EXCHANGE', 'STOCK_EXCHANGE_ADD_PERCENTAGE_GOLD');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES ('STOCK_EXCHANGE_ADD_PERCENTAGE_GOLD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('STOCK_EXCHANGE_ADD_PERCENTAGE_GOLD', 'Amount', '25');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES ('STOCK_EXCHANGE_ADD_PERCENTAGE_GOLD', 'YieldType', 'YIELD_GOLD');

UPDATE Buildings SET Description = 'LOC_BUILDING_STOCK_EXCHANGE_DESCRIPTION' WHERE BuildingType='BUILDING_STOCK_EXCHANGE';

-- Give each bank  2 citizen slots to work each
UPDATE Buildings SET CitizenSlots = '2' WHERE BuildingType='BUILDING_BANK';

-- Give stock exchange 3 citizen slots each
UPDATE Buildings SET CitizenSlots = '3' WHERE BuildingType='BUILDING_STOCK_EXCHANGE';

-- give the commercial district 5 flat gold
UPDATE District_CitizenYieldChanges SET YieldChange = '5' WHERE DistrictType = 'DISTRICT_COMMERCIAL_HUB';