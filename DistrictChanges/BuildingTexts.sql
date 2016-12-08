-- Created by flimaas 04/11/16


--Commercial hub--
--Market--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_MARKET_DESCRIPTION', '+5% [ICON_GOLD] Gold in this city.');

--Bank--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_BANK_DESCRIPTION', '+15% [ICON_GOLD] Gold in this city.');

--Stock exchange--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_STOCK_EXCHANGE_DESCRIPTION', '+25% [ICON_GOLD] Gold in this city.');


--Holy district--
--Shrine--
UPDATE LocalizedText SET Text ='Allows the purchasing of Missionaries. Missionaries can only be purchased with [ICON_Faith] Faith.[NEWLINE][NEWLINE]+15% [ICON_FAITH] Faith in this city.' WHERE Tag = 'LOC_BUILDING_SHRINE_DESCRIPTION';

--Temple--
UPDATE LocalizedText SET Text ='Allows the purchasing of Apostles. Apostles can only be purchased with [ICON_Faith] Faith.[NEWLINE][NEWLINE]+30% [ICON_FAITH] Faith in this city.' WHERE Tag = 'LOC_BUILDING_TEMPLE_DESCRIPTION';

--Stave church--
UPDATE LocalizedText SET Text ='A building unique to Norway. Required to train Apostles. Holy Site districts get an additional standard adjacency bonus from Woods.[NEWLINE][NEWLINE]+30% [ICON_FAITH] Faith in this city.' WHERE Tag = 'LOC_BUILDING_STAVE_CHRUCH_DESCRIPTION';


--Industrial zone--
--Workshop--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_WORKSHOP_DESCRIPTION', '+5% [ICON_PRODUCTION] Production in this city.');

--Factory--
UPDATE LocalizedText SET Text ='Bonus is extended to all cities within 6 tiles.[NEWLINE][NEWLINE]+15% [ICON_PRODUCTION] Production in this city.' WHERE Tag = 'LOC_BUILDING_FACTORY_DESCRIPTION';

--Electronics factory--
UPDATE LocalizedText SET Text ='A building unique to Japan. +4 [ICON_Production] Production to all cities within 6 tiles. After researching the Electricity technology this building provides an additional +4 [ICON_Culture] Culture to its city.[NEWLINE][NEWLINE]+15% [ICON_PRODUCTION] production in this city.' WHERE Tag = 'LOC_BUILDING_ELECTRONICS_FACTORY_DESCRIPTION';

--Power plant--
UPDATE LocalizedText SET Text ='Bonus extends to each city center within 6 tiles.[NEWLINE][NEWLINE]+25% [ICON_PRODUCTION] Production in this city.' WHERE Tag = 'LOC_BUILDING_POWER_PLANT_DESCRIPTION';

--Campus--
--Library--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_LIBRARAY_DESCRIPTION', '+5% [ICON_SCIENCE] Science in this city.');

--University--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_UNIVERSITY_DESCRIPTION', '+15% [ICON_SCIENCE] Science in this city.');

--Madrasa--
UPDATE LocalizedText SET Text ='A building unique to Arabia. Bonus [ICON_Faith] Faith equal to the adjacency bonus of the Campus district.[NEWLINE][NEWLINE]+15% [ICON_SCIENCE] Science in this city.' WHERE Tag = 'LOC_BUILDING_MADRASA_DESCRIPTION';

--Research lab--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_RESEARCH_LAB_DESCRIPTION', '+25% [ICON_SCIENCE] Science in this city.');

--Theater square--
--ampithearter--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_AMPHITHEATER_DESCRIPTION', '+5% [ICON_Culture] Culture in this city.');

--Art museum--
UPDATE LocalizedText SET Text ='Holds [ICON_GreatWork_Landscape] Great Works of Art. May not be built in a Theater Square district that already has an Archaeological Museum.[NEWLINE][NEWLINE]+15% [ICON_Culture] Culture in this city.' WHERE Tag = 'LOC_BUILDING_MUSEUM_ART_DESCRIPTION';

--Archeological museum--
UPDATE LocalizedText SET Text ='Holds [ICON_GreatWork_Artifact] Artifacts. May not be built in a Theater Square district that already has an Art Museum.[NEWLINE][NEWLINE]+15% [ICON_Culture] Culture in this city.' WHERE Tag = 'LOC_BUILDING_MUSEUM_ARTIFACT_DESCRIPTION';

--Broadcast center--
INSERT INTO LocalizedText (Language, Tag, Text) VALUES ('en_US', 'LOC_BUILDING_BROADCAST_CENTER_DESCRIPTION', '+25% [ICON_Culture] Culture in this city.');

--Film studio--
UPDATE LocalizedText SET Text ='A building unique to America. +100% [ICON_Tourism] Tourism pressure from this city towards other civilizations in the Modern era.[NEWLINE][NEWLINE]+25% [ICON_Culture] Culture in this city.' WHERE Tag = 'LOC_BUILDING_FILM_STUDIO_DESCRIPTION';