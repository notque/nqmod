-- Created by HellBlazer 10/11/16

-- move neighbourhoods to civil engeneering
UPDATE Districts SET PrereqCivic = 'CIVIC_CIVIL_ENGINEERING' WHERE DistrictType = 'DISTRICT_NEIGHBORHOOD';