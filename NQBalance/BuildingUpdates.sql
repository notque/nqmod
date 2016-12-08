-- Created by HellBlazer 10/11/16

--move great lighthouse to shipbulding and colossus to celestial navigation
UPDATE Buildings SET PrereqTech = 'TECH_SHIPBUILDING' WHERE BuildingType = 'BUILDING_GREAT_LIGHTHOUSE';
UPDATE Buildings SET PrereqTech = 'TECH_CELESTIAL_NAVIGATION' WHERE BuildingType = 'BUILDING_COLOSSUS';

--move hanging gardens to pottery
UPDATE Buildings SET PrereqTech = 'TECH_POTTERY' WHERE BuildingType = 'BUILDING_HANGING_GARDENS';