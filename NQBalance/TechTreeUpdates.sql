-- Created by HellBlazer 10/11/16

-- reduce cost of sailing
UPDATE Technologies SET Cost = '25' WHERE TechnologyType = 'TECH_SAILING';

--reduce cost of irrigation
UPDATE Technologies SET Cost = '25' WHERE TechnologyType = 'TECH_IRRIGATION';

--increase the cost of pottery
UPDATE Technologies SET Cost = '50' WHERE TechnologyType = 'TECH_POTTERY';

-- increase the cost of writing to 80
UPDATE Technologies SET Cost = '80' WHERE TechnologyType = 'TECH_WRITING';

-- remove the preqs for irrigation
DELETE FROM TechnologyPrereqs WHERE Technology = 'TECH_IRRIGATION';

-- set pottery prequs tech to irrigation
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_POTTERY', 'TECH_IRRIGATION');

-- make horseback riding require bronze working
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_HORSEBACK_RIDING', 'TECH_BRONZE_WORKING');

-- make horseback riding require archery
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_ARCHERY' WHERE Technology = 'TECH_HORSEBACK_RIDING' AND PrereqTech = 'TECH_ANIMAL_HUSBANDRY';

-- make maths require writing
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_WRITING' WHERE Technology = 'TECH_MATHEMATICS';
UPDATE Technologies SET Cost = '120' WHERE TechnologyType = 'TECH_MATHEMATICS';

-- make currency require maths
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_MATHEMATICS' WHERE Technology = 'TECH_CURRENCY';
UPDATE Technologies SET Cost = '200' WHERE TechnologyType = 'TECH_CURRENCY';

-- remove horseback riding from construction
DELETE FROM TechnologyPrereqs WHERE Technology = 'TECH_CONSTRUCTION' AND PrereqTech = 'TECH_HORSEBACK_RIDING';

-- make castles require stirrups
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_CASTLES', 'TECH_STIRRUPS');

-- make pikemen require iron working
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_MILITARY_TACTICS', 'TECH_IRON_WORKING');

-- remove iron working from machinery and add construction
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_CONSTRUCTION' WHERE Technology = 'TECH_MACHINERY' AND PrereqTech = 'TECH_IRON_WORKING';

-- make stirrups require iron working
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_STIRRUPS', 'TECH_IRON_WORKING');

-- make apprenticeship require engineering
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_APPRENTICESHIP', 'TECH_ENGINEERING');

--swap celestial navigation and ship building
UPDATE Technologies SET Cost = '200' WHERE TechnologyType = 'TECH_CELESTIAL_NAVIGATION';
UPDATE Technologies SET Cost = '120' WHERE TechnologyType = 'TECH_SHIPBUILDING';

-- make celestial navigation require shipbuilding
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_SHIPBUILDING' WHERE Technology = 'TECH_CELESTIAL_NAVIGATION' AND PrereqTech = 'TECH_SAILING';

--make catograpy require celestial navigation and education not shipbuilding
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_EDUCATION' WHERE Technology = 'TECH_CARTOGRAPHY';
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_CELESTIAL_NAVIGATION' WHERE Technology = 'TECH_MASS_PRODUCTION' AND PrereqTech ='TECH_SHIPBUILDING';

--move military tactics in front of military engineering
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_MILITARY_TACTICS' WHERE Technology = 'TECH_MILITARY_ENGINEERING';
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_CONSTRUCTION' WHERE Technology = 'TECH_MILITARY_TACTICS' AND PrereqTech = 'TECH_MATHEMATICS';

-- move Astronmy in between celestial navigation and cartography
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_CELESTIAL_NAVIGATION' WHERE Technology = 'TECH_ASTRONOMY';
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_CARTOGRAPHY', 'TECH_ASTRONOMY');
UPDATE Technologies SET Cost = '390' WHERE TechnologyType = 'TECH_ASTRONOMY';
UPDATE Technologies SET EraType = 'ERA_MEDIEVAL' WHERE TechnologyType = 'TECH_ASTRONOMY';

-- make mass production require machinery
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_MASS_PRODUCTION', 'TECH_MACHINERY');

-- make scientific theroy require banking, not astonomy
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_BANKING' WHERE Technology = 'TECH_SCIENTIFIC_THEORY';

-- move banking up 1 column
UPDATE Technologies SET Cost = '660' WHERE TechnologyType = 'TECH_BANKING';
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_PRINTING' WHERE Technology = 'TECH_BANKING' AND PrereqTech ='TECH_STIRRUPS';

-- swap electircity and radio and move forward flight
UPDATE Technologies SET Cost = '1250' WHERE TechnologyType = 'TECH_FLIGHT';
UPDATE Technologies SET Cost = '1140' WHERE TechnologyType = 'TECH_ELECTRICITY';

-- set the new prequiset tech for radio
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_ELECTRICITY' WHERE Technology = 'TECH_RADIO' AND PrereqTech ='TECH_FLIGHT';

-- update preqs for advanced flight
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_ADVANCED_FLIGHT', 'TECH_FLIGHT');

--update the preqs for rocketry
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_FLIGHT' WHERE Technology = 'TECH_ROCKETRY' AND PrereqTech ='TECH_RADIO';

-- update computers require radio
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_RADIO' WHERE Technology = 'TECH_COMPUTERS';

-- update flight to need electricity and remove the scietific theory link
UPDATE TechnologyPrereqs SET PrereqTech = 'TECH_ELECTRICITY' WHERE Technology = 'TECH_FLIGHT' AND PrereqTech ='TECH_INDUSTRIALIZATION';
DELETE FROM TechnologyPrereqs WHERE Technology = 'TECH_FLIGHT' AND PrereqTech ='TECH_SCIENTIFIC_THEORY';

-- add scientific theory as a preq for electricty
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_ELECTRICITY', 'TECH_SCIENTIFIC_THEORY');

-- link electricty to chemestry
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_CHEMISTRY', 'TECH_ELECTRICITY');

-- move combustion back 1 tech slot
UPDATE Technologies SET Cost = '1140' WHERE TechnologyType = 'TECH_COMBUSTION';

--move steel forwards 1 tech slot
UPDATE Technologies SET Cost = '1250' WHERE TechnologyType = 'TECH_STEEL';

-- make steel require combustion
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_STEEL', 'TECH_COMBUSTION');
DELETE FROM TechnologyPrereqs WHERE Technology = 'TECH_COMBUSTION' AND PrereqTech ='TECH_STEEL';

-- make combustion require steam power
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_REPLACEABLE_PARTS', 'TECH_STEAM_POWER');

-- make steel require replaceable parts
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_STEEL', 'TECH_REPLACEABLE_PARTS');

-- make chemisrt and flight require combustion
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_FLIGHT', 'TECH_COMBUSTION');
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_CHEMISTRY', 'TECH_COMBUSTION');

--make plastics require chemisrty
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_PLASTICS', 'TECH_CHEMISTRY');

-- make robotics require telecomunications
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_ROBOTICS', 'TECH_TELECOMMUNICATIONS');

-- make nano tech require stealth
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_NANOTECHNOLOGY', 'TECH_STEALTH_TECHNOLOGY');

-- make Nuclear fusion tech require guidance systems
INSERT INTO TechnologyPrereqs (Technology, PrereqTech) VALUES ('TECH_NUCLEAR_FUSION', 'TECH_GUIDANCE_SYSTEMS');


-- make eureka for maths need to districts not 3
UPDATE Boosts SET NumItems = '2' WHERE TechnologyType = 'TECH_MATHEMATICS';

-- swap eureka from irrigation to pottery
UPDATE Boosts SET TechnologyType = 'TECH_POTTERY' WHERE BoostID = '51';


-- swap items in the tech tree for better pathing
UPDATE Technologies SET UITreeRow = '-3' WHERE
	TechnologyType = 'TECH_CELESTIAL_NAVIGATION' or
	TechnologyType = 'TECH_ASTRONOMY' or
	TechnologyType = 'TECH_RADIO';

UPDATE Technologies SET UITreeRow = '-2' WHERE
	TechnologyType = 'TECH_ELECTRICITY';

UPDATE Technologies SET UITreeRow = '-1' WHERE
	TechnologyType = 'TECH_CURRENCY' or
	TechnologyType = 'TECH_APPRENTICESHIP';

UPDATE Technologies SET UITreeRow = '0' WHERE
	TechnologyType = 'TECH_MATHEMATICS' or 
	TechnologyType = 'TECH_EDUCATION' or
	TechnologyType = 'TECH_IRRIGATION';

UPDATE Technologies SET UITreeRow = '1' WHERE
	TechnologyType = 'TECH_HORSEBACK_RIDING' or
	TechnologyType = 'TECH_ARCHERY';

UPDATE Technologies SET UITreeRow = '2' WHERE
	TechnologyType = 'TECH_BRONZE_WORKING' or 
	TechnologyType = 'TECH_MILITARY_TACTICS' or
	TechnologyType = 'TECH_IRON_WORKING';

UPDATE Technologies SET UITreeRow = '3' WHERE
	TechnologyType = 'TECH_MASONRY' or
	TechnologyType = 'TECH_CONSTRUCTION';