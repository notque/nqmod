-- Created by HellBlazer 01/11/16

-- Add HB Pangaea to maps table (So it shows in drop down selection for map)
INSERT INTO Maps (File, Name, Description, SortIndex) VALUES ('HBPangaea.lua','HB Pangaea v2.1','HellBlazers Modified Pangaea Map for Civ6','5');

INSERT INTO Parameters (Key1, Key2, ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Hash, SortIndex) VALUES
	('Map','HBPangaea.lua','WorldAge','LOC_MAP_WORLD_AGE_NAME','LOC_MAP_WORLD_AGE_DESCRIPTION','WorldAge','2','Map','world_age','MapOptions','0','230'),
	('Map','HBPangaea.lua','Temperature','LOC_MAP_TEMPERATURE_NAME','LOC_MAP_TEMPERATURE_DESCRIPTION','Temperature','2','Map','temperature','MapOptions','0','240'),
	('Map','HBPangaea.lua','Rainfall','LOC_MAP_RAINFALL_NAME','LOC_MAP_RAINFALL_DESCRIPTION','Rainfall','2','Map','rainfall','MapOptions','0','250'),
	('Map','HBPangaea.lua','SeaLevel','LOC_MAP_SEA_LEVEL_NAME','LOC_MAP_SEA_LEVEL_LOW_DESCRIPTION','SeaLevel','2','Map','sea_level','MapOptions','0','260'),
	('Map','HBPangaea.lua','Resources','LOC_MAP_RESOURCES_NAME','LOC_MAP_RESOURCES_DESCRIPTION','Resources','2','Map','resources','MapOptions','0','270'),
	('Map','HBPangaea.lua','StartPosition','LOC_MAP_START_POSITION_NAME','LOC_MAP_START_POSITION_DESCRIPTION','StartPosition','1','Map','start','MapOptions','0','280'),
	('Map','HBPangaea.lua','MountDensity','Mountain Density','Amount of mountains on map','MountDensity','2','Map','MountDensity','MapOptions','0','290');

INSERT INTO DomainValues (Domain, Value, Name, Description, SortIndex) VALUES
	('MountDensity','1','Sparse','Reduced Number Of Mountains', '10'),
	('MountDensity','2','Moderate','Normal Amount Of Mountains', '20'),
	('MountDensity','3','Saturated','Increased Number Of Mountains', '30');

UPDATE Parameters SET DefaultValue='HBPangaea.lua' WHERE ParameterId='Map';

-- Add HB Oval to maps table
INSERT INTO Maps (File, Name, Description, SortIndex) VALUES ('HBOval.lua','HB Oval with Small Islands v2','HellBlazers Oval Map for Civ6','5');

INSERT INTO Parameters (Key1, Key2, ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, Hash, SortIndex) VALUES
	('Map','HBOval.lua','WorldAge','LOC_MAP_WORLD_AGE_NAME','LOC_MAP_WORLD_AGE_DESCRIPTION','WorldAge','2','Map','world_age','MapOptions','0','230'),
	('Map','HBOval.lua','Temperature','LOC_MAP_TEMPERATURE_NAME','LOC_MAP_TEMPERATURE_DESCRIPTION','Temperature','2','Map','temperature','MapOptions','0','240'),
	('Map','HBOval.lua','Rainfall','LOC_MAP_RAINFALL_NAME','LOC_MAP_RAINFALL_DESCRIPTION','Rainfall','2','Map','rainfall','MapOptions','0','250'),
	('Map','HBOval.lua','SeaLevel','LOC_MAP_SEA_LEVEL_NAME','LOC_MAP_SEA_LEVEL_LOW_DESCRIPTION','SeaLevel','2','Map','sea_level','MapOptions','0','260'),
	('Map','HBOval.lua','Resources','LOC_MAP_RESOURCES_NAME','LOC_MAP_RESOURCES_DESCRIPTION','Resources','2','Map','resources','MapOptions','0','270'),
	('Map','HBOval.lua','StartPosition','LOC_MAP_START_POSITION_NAME','LOC_MAP_START_POSITION_DESCRIPTION','StartPosition','1','Map','start','MapOptions','0','280'),
	('Map','HBOval.lua','MountDensity','Mountain Density','Amount of mountains on map','MountDensity','2','Map','MountDensity','MapOptions','0','290');