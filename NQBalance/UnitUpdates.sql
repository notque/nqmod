-- Created by HllBlazer 10/11/16

-- move tanks to steel tech
UPDATE Units SET PrereqTech = 'TECH_STEEL' WHERE UnitType = 'UNIT_TANK';

--move artilery to replaceable parts
UPDATE Units SET PrereqTech = 'TECH_REPLACEABLE_PARTS' WHERE UnitType = 'UNIT_ARTILLERY';