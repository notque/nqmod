-- Created by HellBlazer 01/11/16

-- Update Scientific Theory description
UPDATE LocalizedText SET Text = 'Allows Research Agreement diplomatic action.' WHERE Tag='LOC_TECH_SCIENTIFIC_THEORY_DESCRIPTION';

-- Update Civil Service description
UPDATE LocalizedText SET Text = 'Allows Alliances. +1 [ICON_Production] Production from the Pasture improvement.' WHERE Tag='LOC_CIVIC_CIVIL_SERVICE_DESCRIPTION';

-- Update Feudalism description
UPDATE LocalizedText SET Text = 'Farm improvements now gain +1 [ICON_Food] Food for each adjacent Farm improvement when 3 Farm improvements are adjacent to each other.[NEWLINE][NEWLINE]Can build Farms on Grassland Hills and Plains Hills.'
	WHERE Tag='LOC_CIVIC_FEUDALISM_DESCRIPTION';

-- Update civil engineering description
UPDATE LocalizedText SET Text = 'Unlocks Urban Defenses, giving all of your cities an automatic 200 Fortification Strength and the ability to bombard.'
	WHERE Tag='LOC_CIVIC_CIVIL_ENGINEERING_DESCRIPTION';

--Update lighhouse description to show it provides +1 food to coast tiles in this city
UPDATE LocalizedText SET Text = '+25% combat experience for all naval units trained in this city.[NEWLINE][NEWLINE] +1 [ICON_Food] Food from all coast tiles worked by this city.' WHERE Tag='LOC_BUILDING_LIGHTHOUSE_DESCRIPTION';

--Update seaport description to show it provides +1 production to coast tiles in this city
UPDATE LocalizedText SET Text = 'Faster Fleet and Armada training. +25% combat experience for all naval units trained in this city.[NEWLINE][NEWLINE] +1 [ICON_Production] Production from all coast tiles worked by this city.' WHERE Tag='LOC_BUILDING_SEAPORT_DESCRIPTION';

-- update Agoge card text to show it applies to anit cav too
UPDATE LocalizedText SET Text = '+50% [ICON_Production] Production toward Ancient and Classical era melee, ranged and anti cavalry units.' WHERE Tag='LOC_POLICY_AGOGE_DESCRIPTION';

-- update feudal contract card text to show it applies to anit cav too
UPDATE LocalizedText SET Text = '+50% [ICON_Production] Production toward Medieval and Renaissance era melee, ranged and anti cavalry units.' WHERE Tag='LOC_POLICY_FEUDAL_CONTRACT_DESCRIPTION';

-- update grande armee card text to show it applies to anit cav too
UPDATE LocalizedText SET Text = '+50% [ICON_Production] Production toward Industrial and Modern era melee, ranged and anti cavalry units.' WHERE Tag='LOC_POLICY_GRANDE_ARMEE_DESCRIPTION';

-- update military first card text to show it applies to anit cav too
UPDATE LocalizedText SET Text = '+50% [ICON_Production] Production toward Atomic and Information era melee, ranged and anti cavalry units.' WHERE Tag='LOC_POLICY_MILITARY_FIRST_DESCRIPTION';

--update mathematics eureak description
UPDATE LocalizedText SET Text = 'Build 2 different specialty districts.' WHERE Tag='LOC_BOOST_TRIGGER_MATHEMATICS';

-- Update Medieval Faires description
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_CIVIC_MEDIEVAL_FAIRES_DESCRIPTION', '+1 [ICON_Food] Food from the Plantation improvement.');

-- Update Granary description
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_GRANARY_DESCRIPTION', '[ICON_RESOURCE_DEER] Deer Resources gain +1 [ICON_Food] Food.');

-- update localzied text for new happiness state
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_HAPPINESS_JUBILATION_NAME', 'Jubilation');


--rligous beliefs
-- update stone circles text
UPDATE LocalizedText SET Text = '+3 [ICON_Faith] Faith from Quarries.' WHERE Tag='LOC_BELIEF_STONE_CIRCLES_DESCRIPTION';

-- update god of craftsmen text
UPDATE LocalizedText SET Text = '+2 [ICON_Production] Production from Mines over Strategic resources' WHERE Tag='LOC_BELIEF_GOD_OF_CRAFTSMEN_DESCRIPTION';

--update god of war text
UPDATE LocalizedText SET Text = 'Bonus [ICON_Faith] Faith equal to 100% of the strength of each enemy unit killed within 12 tiles of a Holy Site district you own.' WHERE Tag='LOC_BELIEF_GOD_OF_WAR_DESCRIPTION';

--add text for blood oath
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_INIT_RITES_NAME', 'Blood Oath');
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_INIT_RITES_DESCRIPTION', 'Whenever Your Civilization Clears a Barbarian Outpost, Receive a Tribal Village Reward.');

--add spirit of the woods text
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_FOREST_FAITH_NAME', 'Spirit of the Woods');
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_FOREST_FAITH_DESCRIPTION', '+1 [ICON_Faith] Faith From Forests');

-- add oceans bounty tetx
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_GOD_OF_THE_OPEN_SEA_NAME', 'Oceans Bounty');
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_GOD_OF_THE_OPEN_SEA_DESCRIPTION', '+1 [ICON_Culture] Culture From Fishing Boat improvements.');

--add Hospitium text
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_ROYAL_HOSPITALITY_NAME', 'Hospitium');
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BELIEF_ROYAL_HOSPITALITY_DESCRIPTION', '+2 [ICON_Housing] Housing and +1 [ICON_Amenities] Amenities In The Capital.');
