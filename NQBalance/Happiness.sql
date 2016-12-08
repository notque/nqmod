--  Created 7th Nov 2016 by HellBlazer

-- add new jubilation happniess to database
INSERT INTO Types (Type, Kind) VALUES ('HAPPINESS_JUBILATION', 'KIND_HAPPINESS');
INSERT INTO Happinesses (HappinessType, Name, MinimumAmenityScore, GrowthModifier, NonFoodYieldModifier, RebellionPoints) VALUES
	('HAPPINESS_JUBILATION', 'LOC_HAPPINESS_JUBILATION_NAME', '5', '30', '20', '-2');

-- update settings for current states of happiness
--UPDATE Happinesses SET MinimumAmenityScore = '2' WHERE HappinessType = 'HAPPINESS_HAPPY';
--UPDATE Happinesses SET MaximumAmenityScore = '3' WHERE HappinessType = 'HAPPINESS_HAPPY';

--UPDATE Happinesses SET MinimumAmenityScore = '4' WHERE HappinessType = 'HAPPINESS_ECSTATIC';
UPDATE Happinesses SET MaximumAmenityScore = '4' WHERE HappinessType = 'HAPPINESS_ECSTATIC';

--UPDATE Happinesses SET MaximumAmenityScore = '1' WHERE HappinessType = 'HAPPINESS_CONTENT';

-- set rebelion points for current states
--UPDATE Happinesses SET RebellionPoints = '0' WHERE HappinessType = 'HAPPINESS_DISPLEASED'; 
--UPDATE Happinesses SET RebellionPoints = '1' WHERE HappinessType = 'HAPPINESS_UNHAPPY'; 
--UPDATE Happinesses SET RebellionPoints = '2' WHERE HappinessType = 'HAPPINESS_UNREST'; 
