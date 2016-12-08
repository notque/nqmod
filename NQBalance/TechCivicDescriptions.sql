-- Created by HellBlazer 01/11/16

-- Add +1 food plantation description to medieval faires
UPDATE Civics SET Description = 'LOC_CIVIC_MEDIEVAL_FAIRES_DESCRIPTION' WHERE CivicType='CIVIC_MEDIEVAL_FAIRES';

-- Remove description from Robotics
UPDATE Technologies SET Description = '' WHERE TechnologyType='TECH_ROBOTICS';

-- Set Granary description to show food from deer tiles
UPDATE Buildings SET Description = 'LOC_BUILDING_GRANARY_DESCRIPTION' WHERE BuildingType='BUILDING_GRANARY';

