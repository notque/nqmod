--Adjust special districts to 2/3rds the cost of normal districts
UPDATE Districts
  SET Cost = MAX( Cost, COALESCE( ( ( SELECT d2.Cost FROM Districts d2 WHERE d2.DistrictType = ( SELECT ReplacesDistrictType FROM DistrictReplaces WHERE CivUniqueDistrictType = Districts.DistrictType ) ) * 2 / 3 ) , Cost ) )
  WHERE CostProgressionModel <> 'NO_COST_PROGRESSION';

--Suggested replacements for 2.4 below (and increase per copy for standard 60 cost districts):
--Duel   = 1.2 = +50 per copy
--Tiny   = 1.6 = +38 per copy
--Small  = 2.0 = +30 per copy
--Normal = 2.4 = +25 per copy
--Large  = 2.8 = +21 per copy
--Huge   = 3.2 = +19 per copy
UPDATE Districts 
  SET CostProgressionModel = 'COST_PROGRESSION_PREVIOUS_COPIES', 
      CostProgressionParam1 = Round( Cost / 2.4 / ( 2 - OnePerCity ) ),
      Cost = Round( Cost * ( SELECT ChronologyIndex FROM Eras WHERE EraType = CASE WHEN PrereqTech IS NOT NULL THEN ( SELECT EraType FROM Technologies WHERE TechnologyType = PrereqTech ) ELSE ( SELECT EraType FROM Civics WHERE CivicType = Districts.PrereqCivic ) END ) )
  WHERE CostProgressionModel <> 'NO_COST_PROGRESSION';
/*
UPDATE Districts Set RequiresPopulation = '1' Where
	DistrictType = 'DISTRICT_ACROPOLIS' or 
	DistrictType = 'DISTRICT_HANSA' or
	DistrictType = 'DISTRICT_LAVRA' or 
	DistrictType = 'DISTRICT_ROYAL_NAVY_DOCKYARD' or
	DistrictType = 'DISTRICT_STREET_CARNIVAL';
*/

/*
INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES ('UNIT_IS_NOT_HEAVY_CAVALRY_REQUIREMENT','REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES','1');
INSERT INTO Requirements (RequirementId, RequirementType, Inverse) VALUES ('UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT','REQUIREMENT_UNIT_PROMOTION_CLASS_MATCHES','1');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT','UnitPromotionClass','PROMOTION_CLASS_LIGHT_CAVALRY');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES ('UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT','UnitPromotionClass','PROMOTION_CLASS_HEAVY_CAVALRY');
INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('BYPASS_WALLS_REQUIREMENTS','REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('BYPASS_WALLS_REQUIREMENTS','UNIT_IS_NOT_LIGHT_CAVALRY_REQUIREMENT');
UPDATE Modifiers Set SubjectRequirementSetId = 'BYPASS_WALLS_REQUIREMENTS' Where ModifierType = 'MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS';
INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('BYPASS_WALLS_REQUIREMENTS','UNIT_IS_NOT_HEAVY_CAVALRY_REQUIREMENT');
*/
