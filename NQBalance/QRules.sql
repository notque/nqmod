-----------------------------------------------
-- General Changes
-----------------------------------------------
-- Scaling cost escalation for online speed.
 UPDATE GlobalParameters SET Value = 1000 WHERE Name = 'GAME_COST_ESCALATION'; -- Was 1000
 UPDATE GlobalParameters SET Value = .03 WHERE Name = 'COMBAT_POWER_SCALING'; -- Was .04
-- set chopand harvest changes for online speed
UPDATE Resource_Harvests SET Amount = round(Amount * 0.5, 0);
UPDATE Feature_Removes SET Yield = round(Yield * 0.5, 0);
 
 -----------------------------------------------
-- War Weariness
-----------------------------------------------
 
-- War Weariness for Nukes Increase
UPDATE GlobalParameters SET Value = '2000' WHERE Name = 'WAR_WEARINESS_PER_WMD_LAUNCHED'; -- was 10
-- War Weariness removal per turn while at peace increase
UPDATE GlobalParameters SET Value = '200' WHERE Name = 'WAR_WEARINESS_DECAY_TURN_AT_PEACE'; -- was 200
-- War Weariness removal per turn while at war scaling
UPDATE GlobalParameters SET Value = '50' WHERE Name = 'WAR_WEARINESS_DECAY_TURN_AT_WAR'; -- was 50
-- War Weariness removal @ peace increase
UPDATE GlobalParameters SET Value = '2000' WHERE Name = 'WAR_WEARINESS_DECAY_PEACE_DECLARED'; -- was 2000
-- Remove base war weariness penalty for Defending in your lands, still loses for killing units
UPDATE GlobalParameters SET Value = '1' WHERE Name = 'WAR_WEARINESS_PER_COMBAT_IN_ALLIED_LANDS'; -- was 1
-- Remove Per Unit killed as it hurts the defender of the war
UPDATE GlobalParameters SET Value = '3' WHERE Name = 'WAR_WEARINESS_PER_UNIT_KILLED'; -- was 3
UPDATE GlobalParameters SET Value = '3' WHERE Name = 'WAR_WEARINESS_LOSS_OVER_REQ_AMENITIES_AT_WAR_CITY'; -- was 3
UPDATE GlobalParameters SET Value = '0' WHERE Name = 'WAR_WEARINESS_LOSS_OVER_REQ_AMENITIES_FOUNDED_CITY'; -- was 0
UPDATE GlobalParameters SET Value = '1' WHERE Name = 'WAR_WEARINESS_LOSS_OVER_REQ_AMENITIES_NONFOUNDED_CITY'; -- was 1
UPDATE GlobalParameters SET Value = '16' WHERE Name = 'WAR_WEARINESS_WARMONGER_BASE'; -- was 16
UPDATE GlobalParameters SET Value = '400' WHERE Name = 'WAR_WEARINESS_POINTS_FOR_AMENITY_LOSS'; -- was 400
 
-- Remove base war weariness penalty for Defending in your lands, still loses for killing units
UPDATE GlobalParameters SET Value = '2' WHERE Name = 'WAR_WEARINESS_PER_COMBAT_IN_FOREIGN_LANDS'; -- was 2
 
-- Lower Rebellion cooldown
UPDATE GlobalParameters SET Value = '10' WHERE Name = 'REBELLION_COOLDOWN_TURNS'; -- was 20
 
UPDATE GlobalParameters SET Value = '5' WHERE Name = 'DIPLOMACY_WAR_MIN_TURNS'; -- was 10
UPDATE GlobalParameters SET Value = '5' WHERE Name = 'DIPLOMACY_PEACE_MIN_TURNS'; -- was 10
UPDATE GlobalParameters SET Value = '15' WHERE Name = 'DIPLOMACY_ALLIANCE_TIME_LIMIT'; -- was 30
 
--UPDATE GlobalParameters SET Value = '15' WHERE Name = 'COMBAT_MAX_EXTRA_DAMAGE'; -- was 12
 
--Major Natural Wonders more spread out so competition for them.
--UPDATE GlobalParameters SET Value = 7 WHERE Name = 'START_DISTANCE_MAJOR_NATURAL_WONDER';
 
--Border Expanding
--UPDATE GlobalParameters SET Value = 5 WHERE Name = 'CULTURE_COST_FIRST_PLOT'; -- was 10
--UPDATE GlobalParameters SET Value = 1.4 WHERE Name = 'CULTURE_COST_LATER_PLOT_EXPONENT'; -- Used to be 1.3
UPDATE GlobalParameters SET Value = 3 WHERE Name = 'CULTURE_COST_LATER_PLOT_MULTIPLIER'; -- Used to be 6
--UPDATE GlobalParameters SET Value = 4 WHERE Name = 'CITY_MIN_RANGE'; -- Used to be 3
 
UPDATE Units SET CostProgressionParam1 = CostProgressionParam1*2 where UnitType = "UNIT_SETTLER";
 
-- remove free amenities to new cities
--UPDATE GlobalParameters SET Value = '0' WHERE Name = 'CITY_AMENITIES_FOR_FREE';
 
 
--give palace 1 extra amenity
--UPDATE Buildings SET Entertainment = "2" WHERE BuildingType = 'BUILDING_PALACE';
 
-- prevent moon landing making tourism impossible
UPDATE ModifierArguments SET Value = 1 WHERE ModifierId = 'PROJECT_COMPLETION_GRANT_CULTURE_BASED_ON_SCIENCE_RATE' and Name = 'Multiplier' ; -- Was 10
 
 --Cities still hurt after being taken. Need to heal
UPDATE GlobalParameters SET Value = 25 WHERE Name = 'CITY_CAPTURED_DAMAGE_PERCENTAGE'; -- Used to be 50
 --Scaling turns of anarchy for choosing previous government
UPDATE GlobalParameters SET Value = 1 WHERE Name = 'GOVERNMENT_BASE_ANARCHY_TURNS'; -- Used to be 2
 --Scaling Great work art lock time
UPDATE GlobalParameters SET Value = 5 WHERE Name = 'GREATWORK_ART_LOCK_TIME'; -- Used to be 10
 
-----------------------------------------------
-- City States
-----------------------------------------------
-- Credit thecrazyscotsman's Omnibus Mod
UPDATE ModifierArguments SET Value = 1 WHERE ModifierId = 'MINOR_CIV_SCIENTIFIC_YIELD_FOR_CAMPUS' and Name = 'Amount';
UPDATE ModifierArguments SET Value = 1 WHERE ModifierId = 'MINOR_CIV_RELIGIOUS_YIELD_FOR_HOLY_SITE' and Name = 'Amount';
UPDATE ModifierArguments SET Value = 1 WHERE ModifierId = 'MINOR_CIV_CULTURAL_YIELD_FOR_THEATER_DISTRICT' and Name = 'Amount';
UPDATE ModifierArguments SET Value = 1 WHERE ModifierId = 'MINOR_CIV_INDUSTRIAL_BUILDING_PRODUCTION_FOR_INDUSTRIAL_ZONE' and Name = 'Amount';
 
-----------------------------------------------
-- Projects
-----------------------------------------------
-- Double production cost, gives far too many GPs for value in Online Speed
--UPDATE Projects SET Cost = Cost*2;
 
-----------------------------------------------
-- Buildings
-----------------------------------------------
-- Nerf Colosseum to +1 amenity
--UPDATE Buildings SET Entertainment = 1 WHERE BuildingType = 'BUILDING_COLOSSEUM';
 
 
-----------------------------------------------
-- Religion
-----------------------------------------------
UPDATE GlobalParameters SET Value = 2 WHERE Name = 'RELIGION_SPREAD_ADJACENT_PER_TURN_PRESSURE'; -- Was 1
UPDATE GlobalParameters SET Value = 100 WHERE Name = 'RELIGION_SPREAD_ATHEISM_PRESSURE_PER_POP'; -- Was 50
UPDATE GlobalParameters SET Value = 400 WHERE Name = 'RELIGION_SPREAD_HOLY_CITY_PRESSURE_PER_POP'; -- Was 200
UPDATE GlobalParameters SET Value = 8 WHERE Name = 'RELIGION_SPREAD_HOLY_CITY_PRESSURE_MULTIPLIER'; -- Was 4
UPDATE GlobalParameters SET Value = 4 WHERE Name = 'RELIGION_SPREAD_HOLY_SITE_PRESSURE_MULTIPLIER'; -- Was 2
-- No losing pressure for military units capturing religious units - Can this go negative and give you pressure?
UPDATE GlobalParameters SET Value = 0 WHERE Name = 'RELIGION_SPREAD_UNIT_CAPTURE'; -- Was 125

 -- Religious Buildings give 1 amenity each
UPDATE Buildings SET Entertainment = 1 Where PurchaseYield = 'YIELD_FAITH';

-- Make Religious Units able to move better.
--UPDATE GlobalParameters SET Value=3 WHERE Name='PLOT_UNIT_LIMIT';
--UPDATE Units SET Stackable = 1
--where FormationClass = 'FORMATION_CLASS_CIVILIAN'; --UnitType = "UNIT_MISSIONARY" or UnitType = "UNIT_APOSTLE" or UnitType = "UNIT_INQUISITOR";
 
-----------------------------------------------
-- Tourism
-----------------------------------------------
--Scaling for online speed.
UPDATE GlobalParameters SET Value = 150 WHERE Name = 'TOURISM_TOURISM_TO_MOVE_CITIZEN'; -- Was 150
UPDATE GlobalParameters SET Value = 100 WHERE Name = 'TOURISM_CULTURE_PER_CITIZEN'; -- Was 100
UPDATE GlobalParameters SET Value = 4 WHERE Name = 'TOURISM_BASE_FROM_WONDER'; -- Was 2
 
-----------------------------------------------
-- Trade Routes
-----------------------------------------------
-- Scaling for online speed.
UPDATE GlobalParameters SET Value = 10 WHERE Name = 'TRADE_ROUTE_TURN_DURATION_BASE'; -- Was 20
 
-----------------------------------------------
-- Spys
-----------------------------------------------
-- Stop Counterspys bugging you - Already fixed in patch
--UPDATE UnitOperations SET Turns = 50 WHERE OperationType = 'UNITOPERATION_SPY_COUNTERSPY';
 
-----------------------------------------------
-- Growth
-----------------------------------------------
-- Scaling for online speed. -- Still testing
UPDATE GlobalParameters SET Value = 4 WHERE Name = 'CITY_GROWTH_MULTIPLIER'; -- Was 8
 
-----------------------------------------------
-- Units
-----------------------------------------------
-- Great Generals Die when captured
UPDATE Units Set CanRetreatWhenCaptured = 0 Where UnitType = 'UNIT_GREAT_GENERAL';
 
-- All Units that have a Base Maintenance of 0 cost 1, except for scouts and cilivian units
UPDATE Units SET Maintenance = Maintenance + 1 WHERE Maintenance = 0 AND NOT UnitType = 'UNIT_SCOUT' AND NOT FormationClass = 'FORMATION_CLASS_CIVILIAN';
 
 
-- Religious Missionaries retreat when captured
-- UPDATE Units Set CanRetreatWhenCaptured = 1 Where UnitType = 'UNIT_MISSIONARY';
 
-- Siege units don't work for cav
 
--INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES ('UNIT_IS_NOT_HEAVY_CAVALRY_REQUIREMENT','REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES','1');
--INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES ('UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT','REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES','1');
--INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT','UnitPromotionClass','PROMOTION_CLASS_LIGHT_CAVALRY');
--INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('UNIT_IS_NOT_HEAVY_CAVALRY_REQUIREMENT','UnitPromotionClass','PROMOTION_CLASS_HEAVY_CAVALRY');
--INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('BYPASS_WALLS_REQUIREMENTS','REQUIREMENTSET_TEST_ALL');
--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('BYPASS_WALLS_REQUIREMENTS','UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT');
--UPDATE Modifiers Set SubjectRequirementSetId = 'BYPASS_WALLS_REQUIREMENTS' Where ModifierType = 'MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS';
--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('BYPASS_WALLS_REQUIREMENTS','UNIT_IS_NOT_HEAVY_CAVALRY_REQUIREMENT');
-- REQUIREMENT_UNIT_IS_MELEE
--INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES ('UNIT_IS_MELEE_REQUIREMENT','REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES','0');
--INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('UNIT_IS_MELEE_REQUIREMENT','UnitPromotionClass','PROMOTION_CLASS_MELEE');
--INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('BYPASS_WALLS_REQUIREMENTS','REQUIREMENTSET_TEST_ALL');
--INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('BYPASS_WALLS_REQUIREMENTS','UNIT_IS_MELEE_REQUIREMENT');
--UPDATE Modifiers Set SubjectRequirementSetId = 'BYPASS_WALLS_REQUIREMENTS' where ModifierId = 'BYPASS_WALLS';
 
--UPDATE Units Set CanRetreatWhenCaptured = 0 Where CanRetreatWhenCaptured = 1;
 
-- Scythia ability cut from healing 50 points on kill to 25.
Update ModifierArguments Set Value = '25' where ModifierId = 'HEAL_AFTER_DEFEATING_UNIT';
 
UPDATE Units SET PrereqTech='TECH_THE_WHEEL' WHERE UnitType = 'UNIT_SUMERIAN_WAR_CART';
UPDATE Units SET ZoneOfControl='0' WHERE UnitType = 'UNIT_SCOUT';
UPDATE Units SET ZoneOfControl='0' WHERE UnitType = 'UNIT_RANGER';
UPDATE Units SET BuildCharges='4' WHERE UnitType = 'UNIT_MILITARY_ENGINEER';
UPDATE Units SET Combat='38' WHERE UnitType = 'UNIT_PIKEMAN';
UPDATE Units SET Combat='48' WHERE UnitType = 'UNIT_NORWEGIAN_BERSERKER';
UPDATE Units SET Combat='60', Range='2' WHERE UnitType = 'UNIT_MACHINE_GUN';
UPDATE Units SET Combat='90' WHERE UnitType = 'UNIT_MODERN_AT';
UPDATE Units SET Combat='100' WHERE UnitType = 'UNIT_MODERN_ARMOR';
-- Remove Aerodome requirement for building planes, still need it for having several available
UPDATE Units SET PrereqDistrict= null WHERE UnitType = 'UNIT_BIPLANE' or UnitType = 'UNIT_FIGHTER' or  UnitType = 'UNIT_AMERICAN_P51' or UnitType = 'UNIT_JET_FIGHTER';
-- Make intercepting anti air, actually intercept
UPDATE Units SET AntiAirCombat=AntiAirCombat+15 where AntiAirCombat > 0;
 UPDATE Units SET Bombard='95' WHERE UnitType = 'UNIT_JET_BOMBER'; -- was 80, same as bomber
-- Make Unique Units properly replace units
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType) VALUES ('UNIT_SUMERIAN_WAR_CART', 'UNIT_HEAVY_CHARIOT');
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType) VALUES ('UNIT_INDIAN_VARU', 'UNIT_KNIGHT');
INSERT INTO UnitReplaces (CivUniqueUnitType, ReplacesUnitType) VALUES ('UNIT_CHINESE_CROUCHING_TIGER', 'UNIT_CROSSBOWMAN');
 
UPDATE UnitUpgrades SET UpgradeUnit='UNIT_TANK' WHERE Unit = 'UNIT_AMERICAN_ROUGH_RIDER';
 
INSERT INTO TypeTags (Tag, Type) VALUES ('CLASS_RELIGIOUS', 'ABILITY_STEALTH');
INSERT INTO TypeTags (Tag, Type) VALUES ('CLASS_RELIGIOUS', 'ABILITY_SEE_HIDDEN');
 
--Observation baloons ignore terrain cost
INSERT INTO TypeTags (Tag, Type) VALUES ('CLASS_OBSERVATION', 'ABILITY_IGNORE_TERRAIN_COST');
 
INSERT INTO TypeTags (Tag, Type) VALUES ('CLASS_RECON', 'ABILITY_IGNORE_ZOC');
DELETE FROM TypeTags WHERE Type = 'ABILITY_IGNORE_ZOC' and (Tag = 'CLASS_HEAVY_CAVALRY' or Tag = 'CLASS_WAR_CART');
 
UPDATE ModifierStrings SET Text='+20 against cavalry' WHERE ModifierId = 'ANTI_CAVALRY_COMBAT_BONUS';
UPDATE ModifierArguments SET Value='20' WHERE ModifierId = 'ANTI_CAVALRY_COMBAT_BONUS' and Name='Amount';
 
-----------------------------------------------
-- Barbarians
-----------------------------------------------
UPDATE BarbarianTribes SET ResourceRange ='3' WHERE TribeType = 'TRIBE_CAVALRY';
UPDATE GlobalParameters SET Value ='4' WHERE Name = 'BARBARIAN_BOLDNESS_PER_TURN';
 -- Camps spawn further away from players (4 tiles -> 6 tiles)
UPDATE GlobalParameters SET Value = 6 WHERE Name = 'BARBARIAN_CAMP_MINIMUM_DISTANCE_CITY';
UPDATE GlobalParameters SET Value = 3 WHERE Name = 'EXPERIENCE_MAX_BARB_LEVEL'; -- was 2
UPDATE GlobalParameters SET Value = 2 WHERE Name = 'EXPERIENCE_BARB_SOFT_CAP'; -- was 1
 
 
-----------------------------------------------
-- Eurekas
-----------------------------------------------
--UPDATE Boosts SET Boost = '25' WHERE Boost = '50';
 
-----------------------------------------------
-- Roads
-----------------------------------------------
UPDATE Routes SET
    MovementCost='1',
    SupportsBridges='0',
    PlacementValue='1'
    WHERE RouteType='ROUTE_ANCIENT_ROAD';
 
UPDATE Routes SET
    MovementCost='1',
    SupportsBridges='1',
    PlacementValue='2',
    PrereqEra='ERA_CLASSICAL'
    WHERE RouteType='ROUTE_MEDIEVAL_ROAD';
 
UPDATE Routes SET
    MovementCost='0.75',
    SupportsBridges='1',
    PlacementValue='3',
    PrereqEra='ERA_RENAISSANCE'
    WHERE RouteType='ROUTE_INDUSTRIAL_ROAD';
 
UPDATE Routes SET
    MovementCost='0.50',
    SupportsBridges='1',
    PlacementValue='4',
    PrereqEra='ERA_INDUSTRIAL'
    WHERE RouteType='ROUTE_MODERN_ROAD';
 
-- Make the area adjacent to an Oasis worth settling
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange) VALUES ('FEATURE_OASIS', 'YIELD_FOOD', '1') ;
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange) VALUES ('FEATURE_OASIS', 'YIELD_GOLD', '1') ;
INSERT INTO Feature_AdjacentYields (FeatureType, YieldType, YieldChange) VALUES ('FEATURE_OASIS', 'YIELD_FAITH', '1') ;
 
-- Make fishing boats suck less by adding 1 extra Gold
 
UPDATE Improvement_YieldChanges SET YieldChange='1' WHERE ImprovementType='IMPROVEMENT_FISHING_BOATS' AND YieldType='YIELD_GOLD' ;
 
 
 
-- TESTING
 
 
--Update Resources set Frequency='4' where ResourceType='RESOURCE_CINNAMON';
--INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES ('RESOURCE_CINNAMON', 'YIELD_FAITH', '10');
--INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES ('RESOURCE_CINNAMON', 'TERRAIN_PLAINS_HILLS');
 
--Update Resources set Frequency='4' where Frequency='0';
--INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES ('RESOURCE_CINNAMON', 'YIELD_FAITH', '10');
--INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES ('RESOURCE_CINNAMON', 'TERRAIN_PLAINS_HILLS');
/*
INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES
    ("RESOURCE_CINNAMON", "YIELD_FAITH", 10),
    ("RESOURCE_JEANS", "YIELD_FAITH", 10),
    ("RESOURCE_PERFUME", "YIELD_FAITH", 10),
    ("RESOURCE_TOYS", "YIELD_FAITH", 10),
    ("RESOURCE_CLOVES", "YIELD_FAITH", 10),
    ("RESOURCE_COSMETICS", "YIELD_FAITH", 10);
 
INSERT INTO Resource_ValidTerrains (ResourceType, TerrainType) VALUES
    ("RESOURCE_CINNAMON", "TERRAIN_GRASS"),
    ("RESOURCE_JEANS", "TERRAIN_GRASS"),
    ("RESOURCE_PERFUME", "TERRAIN_GRASS"),
    ("RESOURCE_TOYS", "TERRAIN_GRASS"),
    ("RESOURCE_CLOVES", "TERRAIN_GRASS"),
    ("RESOURCE_COSMETICS", "TERRAIN_GRASS");
 
INSERT INTO Resource_ValidFeatures (ResourceType, FeatureType) VALUES
    ("RESOURCE_CINNAMON", "FEATURE_JUNGLE"),
    ("RESOURCE_JEANS", "FEATURE_FOREST"),
    ("RESOURCE_PERFUME", "FEATURE_FOREST"),
    ("RESOURCE_TOYS", "FEATURE_FOREST"),
    ("RESOURCE_CLOVES", "FEATURE_JUNGLE"),
    ("RESOURCE_COSMETICS", "FEATURE_FOREST");
*/
 
 
 
-- TESTING BULLSHIT, REMOVE YOU IDIOT
 
-----------------------------------------------
-- Tech Cost
-----------------------------------------------
 
-- First attempt (yes, that's +10, not * 10)
--UPDATE Technologies     SET Cost = Cost + 10    WHERE EraType ='ERA_ANCIENT';
--UPDATE Technologies     SET Cost = Cost * 1.5     WHERE EraType ='ERA_CLASSICAL';
--UPDATE Technologies     SET Cost = Cost * 1.5    WHERE EraType ='ERA_MEDIEVAL';
--UPDATE Technologies     SET Cost = Cost * 2        WHERE EraType ='ERA_RENAISSANCE';
--UPDATE Technologies     SET Cost = Cost * 2        WHERE EraType ='ERA_INDUSTRIAL';
--UPDATE Technologies     SET Cost = Cost * 2.5    WHERE EraType ='ERA_MODERN';
--UPDATE Technologies     SET Cost = Cost * 2.5    WHERE EraType ='ERA_ATOMIC';
--UPDATE Technologies     SET Cost = Cost * 3        WHERE EraType ='ERA_INFORMATION';
 
-- First attempt (yes, that's +10, not * 10)
--UPDATE Civics     SET Cost = Cost + 10    WHERE EraType ='ERA_ANCIENT' AND CivicType <> 'CIVIC_CODE_OF_LAWS';
--UPDATE Civics     SET Cost = Cost * 1.5    WHERE EraType ='ERA_CLASSICAL';
--UPDATE Civics     SET Cost = Cost * 1.5    WHERE EraType ='ERA_MEDIEVAL';
--UPDATE Civics     SET Cost = Cost * 2        WHERE EraType ='ERA_RENAISSANCE';
--UPDATE Civics     SET Cost = Cost * 2     WHERE EraType ='ERA_INDUSTRIAL';
--UPDATE Civics     SET Cost = Cost * 2.5     WHERE EraType ='ERA_MODERN';
--UPDATE Civics     SET Cost = Cost * 2.5     WHERE EraType ='ERA_ATOMIC';
--UPDATE Civics     SET Cost = Cost * 3     WHERE EraType ='ERA_INFORMATION';
 
-----------------------------------------------
-- Building and Unit Cost
-----------------------------------------------
 
 
 
-- First Attempt
--UPDATE Projects SET Cost = Cost*2;
--UPDATE Buildings SET Cost = Cost*1;
--UPDATE Districts SET Cost = Cost*1;
--UPDATE Units SET Cost = Cost*2 where UnitType <> "UNIT_BUILDER";    
 
--UPDATE Boosts SET Boost = Boost / 2;
-- UPDATE Eras Set GreatPersonBaseCost = GreatPersonBaseCost*3;
--UPDATE Units SET Maintenance = Maintenance + 1 WHERE Maintenance > 0; -- All Units that have a Base Maintenance of 1+ cost 1 more
-- UPDATE Units SET Maintenance = 1 WHERE UnitType = 'UNIT_WARRIOR'; -- Gives Warriors a Base Maintenance cost
--UPDATE Units SET InitialLevel = 2 WHERE UnitType = 'UNIT_SCOUT'; -- Explorers start with a free Promotion
--UPDATE Units SET BaseSightRange = 3 WHERE UnitType = 'UNIT_SCOUT'; -- Scouts have +1 Vision Range
-- Traders Scale per Unit built, not over time
--UPDATE Units SET CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', CostProgressionParam1 = 10 WHERE UnitType = 'UNIT_TRADER';
 
 
 
 
 
 
-- ########################## CHECK THESE EFFECTS ############################
 
-- Replaces the Chiefdoms economic Slot with a wildcard to give everybody access to using the early Great Person Cards
--UPDATE Government_SlotCounts SET GovernmentSlotType = 'SLOT_WILDCARD' WHERE GovernmentType = 'GOVERNMENT_CHIEFDOM' AND GovernmentSlotType = 'SLOT_ECONOMIC';
 
 
 
-- Builers/Trade Routes cost 1 Population
-- UPDATE Units SET PopulationCost = 1, PrereqPopulation = 2 WHERE UnitType = 'UNIT_BUILDER';
-- UPDATE Units SET PopulationCost = 1, PrereqPopulation = 2 WHERE UnitType = 'UNIT_TRADER';
 
 
-- All Districts that add Production to Trade Routes (except the city center ) now add Food instead
--UPDATE District_TradeRouteYields SET YieldType = 'YIELD_FOOD' WHERE YieldType = 'YIELD_PRODUCTION' AND DistrictType <> 'DISTRICT_CITY_CENTER';
 
 
 
-- Reduce Warmonger Penalty from declaring war by 50% (/edit: I haven't tested this one, but it should work.)
--              UPDATE DiplomaticActions SET WarmongerPercent = WarmongerPercent / 2 WHERE WarmongerPercent IS NOT NULL;
 
-- Reduce Eurekas for all Techs and/or Civics  to 25%
--UPDATE Boosts SET Boost = 25 WHERE TechnologyType IS NOT NULL;
--UPDATE Boosts SET Boost = 25 WHERE CivicType IS NOT NULL;
 
 
 
-----------------------------------------------
-- Terrain
-----------------------------------------------
 
-- Update Tile Yields
-- Grass and Plains Hills lose one point of food each, to balance them
 
--UPDATE Terrain_YieldChanges SET YieldChange='1' WHERE TerrainType ='TERRAIN_GRASS_HILLS' AND YieldType='YIELD_FOOD' ;
--UPDATE Terrain_YieldChanges SET YieldChange='0' WHERE TerrainType ='TERRAIN_PLAINS_HILLS' AND YieldType='YIELD_FOOD' ;
 
 
-- Add some pizzazz to lacklustre features
 
 
-- Improve all sea resources
-- ########################## CHECK THESE EFFECTS ############################
--UPDATE Resource_YieldChanges SET YieldChange='2' WHERE ResourceType ='RESOURCE_FISH' AND YieldType='YIELD_FOOD' ;
--UPDATE Resource_YieldChanges SET YieldChange='2' WHERE ResourceType ='RESOURCE_PEARLS' AND YieldType='YIELD_FAITH' ;
--INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES ('RESOURCE_WHALES', 'YIELD_FAITH', '1') ;
--INSERT INTO Resource_YieldChanges (ResourceType, YieldType, YieldChange) VALUES ('RESOURCE_CRABS', 'YIELD_CULTURE', '1') ;
 
/*
    Originally created in XML by Biao (/u/Novemberisms on Reddit) for his Strategic Resource and Tech Tree Mod
   
    Redone in SQL and edited by thecrazyscotsman (/u/tyrannus1115 on Reddit) for thecrazyscotsman's Omnibus Mod (30 Nov 2016)
*/
 /*
--Create Strategic Resource class framework
INSERT INTO Types (Type, Kind)
    VALUES
        ("ABILITY_IRON", "KIND_ABILITY"),
        ("ABILITY_HORSE", "KIND_ABILITY"),
        ("ABILITY_NITER", "KIND_ABILITY"),
        ("ABILITY_COAL", "KIND_ABILITY"),
        ("ABILITY_OIL", "KIND_ABILITY"),
        ("ABILITY_ALU", "KIND_ABILITY"),
        ("ABILITY_URANIUM", "KIND_ABILITY");
       
INSERT INTO Tags (Tag, Vocabulary)
    VALUES
        ("CLASS_IRON", "ABILITY_CLASS"),
        ("CLASS_HORSE", "ABILITY_CLASS"),
        ("CLASS_NITER", "ABILITY_CLASS"),
        ("CLASS_COAL", "ABILITY_CLASS"),
        ("CLASS_OIL", "ABILITY_CLASS"),
        ("CLASS_ALU", "ABILITY_CLASS"),
        ("CLASS_URANIUM", "ABILITY_CLASS");
 
INSERT INTO TypeTags (Type, Tag)
    VALUES
        ("ABILITY_IRON", "CLASS_IRON"),
        ("ABILITY_HORSE", "CLASS_HORSE"),
        ("ABILITY_NITER", "CLASS_NITER"),
        ("ABILITY_COAL", "CLASS_COAL"),
        ("ABILITY_OIL", "CLASS_OIL"),
        ("ABILITY_ALU", "CLASS_ALU"),
        ("ABILITY_URANIUM", "CLASS_URANIUM"),
        ("UNIT_SWORDSMAN", "CLASS_IRON"),
        ("UNIT_MUSKETMAN", "CLASS_NITER"),
        ("UNIT_BOMBARD", "CLASS_NITER"),
        ("UNIT_KNIGHT", "CLASS_IRON"),
        ("UNIT_KNIGHT", "CLASS_HORSE"),
        ("UNIT_HORSEMAN", "CLASS_HORSE"),
        ("UNIT_CAVALRY", "CLASS_HORSE"),
        ("UNIT_IRONCLAD", "CLASS_COAL"),
        ("UNIT_BATTLESHIP", "CLASS_COAL"),
        ("UNIT_AIRCRAFT_CARRIER", "CLASS_OIL"),
        ("UNIT_TANK", "CLASS_OIL"),
        ("UNIT_FIGHTER", "CLASS_ALU"),
        ("UNIT_BOMBER", "CLASS_ALU"),
        ("UNIT_JET_BOMBER", "CLASS_ALU"),
        ("UNIT_JET_FIGHTER", "CLASS_ALU"),
        ("UNIT_NUCLEAR_SUBMARINE", "CLASS_URANIUM"),
        ("UNIT_MODERN_ARMOR", "CLASS_URANIUM");
 
--Remove Strategic Resource requirements
--Lower base combat strength of Strategic Resource unit classes    
UPDATE Units SET Combat = Combat - 3
    WHERE (StrategicResource LIKE 'RESOURCE%') AND (Combat > 0);
UPDATE Units SET RangedCombat = RangedCombat - 3
    WHERE (StrategicResource LIKE 'RESOURCE%') AND (RangedCombat > 0);
UPDATE Units SET Bombard = Bombard - 3
    WHERE (StrategicResource LIKE 'RESOURCE%') AND (Bombard > 0);
UPDATE Units SET AntiAirCombat = AntiAirCombat - 3
    WHERE (StrategicResource LIKE 'RESOURCE%') AND (AntiAirCombat > 0);
UPDATE Units SET StrategicResource = NULL;
 
--Individual unit changes  
UPDATE Units SET MandatoryObsoleteTech = 'TECH_IRON_WORKING' WHERE UnitType = 'UNIT_WARRIOR';
--UPDATE Units SET Cost = 100 WHERE UnitType = 'UNIT_HORSEMAN';
--UPDATE Units SET Combat = 38 WHERE UnitType = 'UNIT_KNIGHT';
 
INSERT INTO UnitAbilities (UnitAbilityType, Name, Description)
    VALUES
        ("ABILITY_IRON", "LOC_ABILITY_IRON_NAME", "LOC_ABILITY_IRON_DESCRIPTION"),
        ("ABILITY_HORSE", "LOC_ABILITY_HORSE_NAME", "LOC_ABILITY_HORSE_DESCRIPTION"),
        ("ABILITY_NITER", "LOC_ABILITY_NITER_NAME", "LOC_ABILITY_NITER_DESCRIPTION"),
        ("ABILITY_COAL", "LOC_ABILITY_COAL_NAME", "LOC_ABILITY_COAL_DESCRIPTION"),
        ("ABILITY_OIL", "LOC_ABILITY_OIL_NAME", "LOC_ABILITY_OIL_DESCRIPTION"),
        ("ABILITY_ALU", "LOC_ABILITY_ALU_NAME", "LOC_ABILITY_ALU_DESCRIPTION"),
        ("ABILITY_URANIUM", "LOC_ABILITY_URANIUM_NAME", "LOC_ABILITY_URANIUM_DESCRIPTION");
 
INSERT INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
    VALUES
        ("ABILITY_IRON", "IRON_RESOURCE_COMBAT"),
        ("ABILITY_HORSE", "HORSE_RESOURCE_COMBAT"),
        ("ABILITY_NITER", "NITER_RESOURCE_COMBAT"),
        ("ABILITY_COAL", "COAL_RESOURCE_COMBAT"),
        ("ABILITY_OIL", "OIL_RESOURCE_COMBAT"),
        ("ABILITY_ALU", "ALU_RESOURCE_COMBAT"),
        ("ABILITY_URANIUM", "URANIUM_RESOURCE_COMBAT");
 
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
    VALUES
        ("IRON_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "IRON_RESOURCE_COMBAT_REQUIREMENTS"),
        ("HORSE_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "HORSE_RESOURCE_COMBAT_REQUIREMENTS"),
        ("NITER_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "NITER_RESOURCE_COMBAT_REQUIREMENTS"),
        ("COAL_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "COAL_RESOURCE_COMBAT_REQUIREMENTS"),
        ("OIL_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "OIL_RESOURCE_COMBAT_REQUIREMENTS"),
        ("ALU_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "ALU_RESOURCE_COMBAT_REQUIREMENTS"),
        ("URANIUM_RESOURCE_COMBAT", "MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH", "URANIUM_RESOURCE_COMBAT_REQUIREMENTS");
 
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    VALUES
        ("IRON_RESOURCE_COMBAT", "Amount", 3),
        ("HORSE_RESOURCE_COMBAT", "Amount", 3),
        ("NITER_RESOURCE_COMBAT", "Amount", 3),
        ("COAL_RESOURCE_COMBAT", "Amount", 3),
        ("OIL_RESOURCE_COMBAT", "Amount", 3),
        ("ALU_RESOURCE_COMBAT", "Amount", 3),
        ("URANIUM_RESOURCE_COMBAT", "Amount", 3);
 
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
    VALUES
        ("IRON_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("HORSE_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("NITER_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("COAL_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("OIL_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("ALU_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY"),
        ("URANIUM_RESOURCE_COMBAT_REQUIREMENTS", "REQUIREMENTSET_TEST_ANY");
 
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
    VALUES
        ("IRON_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_IRON"),
        ("HORSE_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_HORSE"),
        ("NITER_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_NITER"),
        ("COAL_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_COAL"),
        ("OIL_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_OIL"),
        ("ALU_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_ALU"),
        ("URANIUM_RESOURCE_COMBAT_REQUIREMENTS", "REQUIRES_OWNED_URANIUM");
 
INSERT INTO Requirements (RequirementId, RequirementType)
    VALUES
        ("REQUIRES_OWNED_IRON", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_HORSE", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_NITER", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_COAL", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_OIL", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_ALU", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED"),
        ("REQUIRES_OWNED_URANIUM", "REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED");
   
INSERT INTO RequirementArguments (RequirementId, Name, Value)
    VALUES
        ("REQUIRES_OWNED_IRON", "ResourceType", "RESOURCE_IRON"),
        ("REQUIRES_OWNED_HORSE", "ResourceType", "RESOURCE_HORSES"),
        ("REQUIRES_OWNED_NITER", "ResourceType", "RESOURCE_NITER"),
        ("REQUIRES_OWNED_COAL", "ResourceType", "RESOURCE_COAL"),
        ("REQUIRES_OWNED_OIL", "ResourceType", "RESOURCE_OIL"),
        ("REQUIRES_OWNED_ALU", "ResourceType", "RESOURCE_ALUMINUM"),
        ("REQUIRES_OWNED_URANIUM", "ResourceType", "RESOURCE_URANIUM");
 
INSERT INTO ModifierStrings (ModifierId, Context, Text)
    VALUES
        ("IRON_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_IRON_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("HORSE_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_HORSE_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("NITER_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_NITER_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("COAL_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_COAL_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("OIL_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_OIL_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("ALU_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_ALU_RESOURCE_COMBAT_MODIFIER_DESCRIPTION"),
        ("URANIUM_RESOURCE_COMBAT", "Preview", "LOC_ABILITY_URANIUM_RESOURCE_COMBAT_MODIFIER_DESCRIPTION");
        */