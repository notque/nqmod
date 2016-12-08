------------------------------------------------------------------------------
--	FILE:               ResourceGenerator.lua
--	ORIGNIAL AUTHOR:    Ed Beach
--	PURPOSE:            Default method for resource placement
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"

local scoreRnd = 300;

------------------------------------------------------------------------------
ResourceGenerator = {};
------------------------------------------------------------------------------
function ResourceGenerator.Create(args)

	print ("In ResourceGenerator.Create()");
	print ("    Placing resources");

	local iNumMajorCivs = PlayerManager.GetAliveMajorsCount();
	
	-- create instance data
	local instance = {
			
		-- methods
		__InitResourceData		= ResourceGenerator.__InitResourceData,
		__FindValidLocs			= ResourceGenerator.__FindValidLocs,
		__GetLuxuryResources	= ResourceGenerator.__GetLuxuryResources,
		__IsCoastal				= ResourceGenerator.__IsCoastal,
		__ValidLuxuryPlots		= ResourceGenerator.__ValidLuxuryPlots,
		__PlaceLuxuryResources		= ResourceGenerator.__PlaceLuxuryResources,
		__ScoreLuxuryPlots			= ResourceGenerator.__ScoreLuxuryPlots,
		__PlaceWaterLuxury			= ResourceGenerator.__PlaceWaterLuxury,
		__GetStrategicResources	= ResourceGenerator.__GetStrategicResources,
		__ValidStrategicPlots		= ResourceGenerator.__ValidStrategicPlots,
		__ScoreStrategicPlots			= ResourceGenerator.__ScoreStrategicPlots,
		__PlaceStrategicResources		= ResourceGenerator.__PlaceStrategicResources,
		__GetOtherResources		= ResourceGenerator.__GetOtherResources,
		__PlaceOtherResources		= ResourceGenerator.__PlaceOtherResources,
		__RemoveOtherDuplicateResources		= ResourceGenerator.__RemoveOtherDuplicateResources,
		__RemoveDuplicateResources		= ResourceGenerator.__RemoveDuplicateResources,
		__ScorePlots			= ResourceGenerator.__ScorePlots,

		-- data
		bCoastalBias = args.bCoastalBias or false;
		bLandBias = args.bLandBias or false;

		resources = args.resources;
		iResourcesInDB      = 0;
		iNumContinents		= 0;
		iTotalValidPlots    = 0;
		iFrequencyTotal     = 0;
		iFrequencyStrategicTotal     = 0;
		iTargetPercentage   = 28;
		iStandardPercentage = 28;
		iLuxuryPercentage   = 20;
		iStrategicPercentage   = 21;
		iOccurencesPerFrequency = 0;
		iLuxuriesPerRegion = 4;
		eResourceType		= {},
		eResourceClassType	= {},
		iFrequency          = {},
		aLuxuryType		= {},
		aLuxuryTypeCoast		= {},
		aStrategicType		= {},
		aOtherType		= {},
		aStrategicCoast = {},
		aaPossibleLuxLocs		= {},
		aaPossibleLuxLocsWater = {},
		aaPossibleStratLocs		= {},
		aaPossibleStratLocsWater = {},
		aaPossibleLocs		= {},
		aResourcePlacementOrderStrategic = {},
		aResourcePlacementOrder = {},
		aPeakEra = {},
		aResourceName ={},
	};

	-- initialize instance data
	instance:__InitResourceData()
	
	-- Chooses and then places the strategic resources
	instance:__GetStrategicResources()

	-- Chooses and then places the luxury resources
	instance:__GetLuxuryResources()

	-- Chooses and then places the other resources [other is now only bonus, but later could be resource types added through mods]
	instance:__GetOtherResources()

	-- Removes too many adjacent other resources.
	instance:__RemoveOtherDuplicateResources()

	return instance;
end
------------------------------------------------------------------------------
function ResourceGenerator:__InitResourceData()

	self.iResourcesInDB = 0;
	self.iLuxuriesThisSizeMap = GameInfo.Maps[Map.GetMapSize()].DefaultPlayers * 2;

	-- Get resource value setting input by user.
	if self.resources == 1 then
			self.resources = -5;
	elseif self.resources == 3 then
			self.resources = 5;	
	elseif self.resources == 4 then
		self.resources = TerrainBuilder.GetRandomNumber(13, "Random Resources - Lua") - 6;
		--print(self.resources);
	else
		self.resources = 0;
	end

	self.iTargetPercentage = self.iTargetPercentage + self.resources;


	for row in GameInfo.Resources() do
		self.eResourceType[self.iResourcesInDB] = row.Index;
		self.eResourceClassType[self.iResourcesInDB] = row.ResourceClassType;
		self.aaPossibleLocs[self.iResourcesInDB] = {};
		self.aaPossibleLuxLocs[self.iResourcesInDB] = {};
		self.aaPossibleStratLocs[self.iResourcesInDB] = {};
		self.aaPossibleLuxLocsWater[self.iResourcesInDB] = {};
		self.aaPossibleStratLocsWater[self.iResourcesInDB] = {};
		self.iFrequency[self.iResourcesInDB] = row.Frequency;
		self.aPeakEra[self.iResourcesInDB] = row.PeakEra;
		self.aResourceName[self.iResourcesInDB] = row.ResourceType;
	    self.iResourcesInDB = self.iResourcesInDB + 1;
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetLuxuryResources()
	local continentsInUse = Map.GetContinentsInUse();	
	self.aLuxuryType = {};
	self.aLuxuryTypeCoast = {};
	aLandLuxury = {};
	local max = self.iLuxuriesPerRegion;
	
	print("#######################################################");
	print("Luxes On Map: ", max);
	print("#######################################################");
	
	-- Find the Luxury Resources
	for row = 0, self.iResourcesInDB do
		if (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.iFrequency[row] > 0) then
			local coast = false;
				
			for row2 in GameInfo.Resource_ValidTerrains() do
				if(GameInfo.Resources[row2.ResourceType].Index == self.eResourceType[row] and row2.TerrainType=="TERRAIN_COAST") then
					coast = true;
				end
			end

			if(coast == true) then	
				--table.insert(self.aLuxuryTypeCoast, self.eResourceType[row]);
			end

			if(self.bCoastalBias == true or self.bLandBias == true) then
				if(coast == false) then	
					table.insert(aLandLuxury, self.eResourceType[row]);		
				end
			else
				table.insert(self.aLuxuryType, self.eResourceType[row]);		
			end
		end
	end

	
	local index = 1;
	if(self.bCoastalBias == true) then
		newLuxuryArray = {};
		shuffledCoast = GetShuffledCopyOfTable(self.aLuxuryTypeCoast);
		aLandLuxury = GetShuffledCopyOfTable(aLandLuxury);

		local iLandIndex = 1;
		local iWaterIndex = 1;

		for row = 0, self.iResourcesInDB do
			local mod = max + 2;
			if(row ~= 0 and ((row - math.floor(row / mod) * mod == 0) and iWaterIndex <= #self.aLuxuryTypeCoast)) then
				--table.insert(newLuxuryArray, shuffledCoast[iWaterIndex]); -- HB Removed water luxes from his map he is a HEATHEN
				iWaterIndex = iWaterIndex + 1;
			else
				table.insert(newLuxuryArray, aLandLuxury[iLandIndex]);
				iLandIndex = iLandIndex + 1;
			end
		end
		
		for  i, eLuxury in ipairs(newLuxuryArray) do
			table.insert(self.aLuxuryType, eLuxury);
		end
	elseif(self.bLandBias == true) then
		newLuxuryArray = {};
		shuffledCoast = GetShuffledCopyOfTable(self.aLuxuryTypeCoast);
		aLandLuxury = GetShuffledCopyOfTable(aLandLuxury);

		local iLandIndex = 1;
		local iWaterIndex = 1;

		for row = 0, self.iResourcesInDB do
			if(iLandIndex <= #aLandLuxury) then
				table.insert(newLuxuryArray, aLandLuxury[iLandIndex]);
				iLandIndex = iLandIndex + 1;
			else
				-- table.insert(newLuxuryArray, shuffledCoast[iWaterIndex]); -- HB Removed water luxes from his map he is a HEATHEN
				iWaterIndex = iWaterIndex + 1;
			end
		end
		
		for  i, eLuxury in ipairs(newLuxuryArray)do
			table.insert(self.aLuxuryType, eLuxury);
		end
	else
		self.aLuxuryType = GetShuffledCopyOfTable(self.aLuxuryType);
	end

	for _, eContinent in ipairs(continentsInUse) do 
		-- Shuffle the table
		--print ("Retrieved plots for continent: " .. tostring(eContinent));

		self:__ValidLuxuryPlots(eContinent);

		-- next find the valid plots for each of the luxuries
		local failed = 0;
		local iI = 1;
		while max >= iI and failed < 2 do 
			local eChosenLux = self.aLuxuryType[index];

			local isValid = true;

			if (isValid == true and #self.aLuxuryType > 0) then
				table.remove(self.aLuxuryType,index);
				if(self:__IsCoastal(eChosenLux)) then
					self:__PlaceWaterLuxury(eChosenLux, eContinent);
				else
					self:__PlaceLuxuryResources(eChosenLux, eContinent);
				end

				index = index + 1;
				iI = iI + 1;
				failed = 0;
			end

			if index > #self.aLuxuryType then
				index = 1;
				failed = failed + 1;
			end
		end
	end

	-- for loop to add water luxes to EVERY cintinent
	for _, eContinent in ipairs(continentsInUse) do 
		-- Shuffle the table
		--print ("Retrieved plots for continent: " .. tostring(eContinent));

		self:__ValidLuxuryPlots(eContinent);

		for z = 1, #self.aLuxuryTypeCoast do 
			local eChosenLux = self.aLuxuryTypeCoast[z];
			self:__PlaceWaterLuxury(eChosenLux, eContinent);
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__IsCoastal(eResource)
	for  i, eCoastalResource in ipairs(self.aLuxuryTypeCoast)do
		if eCoastalResource == eResource then
			return true
		end
	end

	return false;
end

------------------------------------------------------------------------------
function ResourceGenerator:__ValidLuxuryPlots(eContinent)
	-- go through each plot on the continent and put the luxuries	
	local iSize = #self.aLuxuryType;
	local iBaseScore = 1;
	self.iTotalValidPlots = 0;

	plots = Map.GetContinentPlots(eContinent);
	for i, plot in ipairs(plots) do
		local bCanHaveSomeResource = false;
		local pPlot = Map.GetPlotByIndex(plot);

		-- See which resources can appear here
		for iI = 1, iSize do
			local bIce = false;

			if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
				bIce = true;
			end
			
			if (ResourceBuilder.CanHaveResource(pPlot, self.aLuxuryType[iI]) and bIce == false) then
				row = {};
				row.MapIndex = plot;
				row.Score = iBaseScore;
				table.insert (self.aaPossibleLuxLocs[self.aLuxuryType[iI]], row);
				bCanHaveSomeResource = true;
			end
		end


		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end

		-- Compute how many of each resource to place
	end

	self.iOccurencesPerFrequency = self.iTargetPercentage / 100 * #plots * self.iLuxuryPercentage / 100 / self.iLuxuriesPerRegion;
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceLuxuryResources(eChosenLux, eContinent)
	-- Go through continent placing the chosen luxuries
	
	plots = Map.GetContinentPlots(eContinent);
	--print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));
	local eResourceType = self.eResourceType[eChosenLux]

	local iTotalPlaced = 0;

	-- Compute how many to place
	local iNumToPlace = 1;
	if(self.iOccurencesPerFrequency > 1) then
		iNumToPlace = self.iOccurencesPerFrequency;
	end

	-- Score possible locations
	self:__ScoreLuxuryPlots(eChosenLux, eContinent);

	-- Sort and take best score
	table.sort (self.aaPossibleLuxLocs[eChosenLux], function(a, b) return a.Score > b.Score; end);

	for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleLuxLocs[eChosenLux]) then
				local iMapIndex = self.aaPossibleLuxLocs[eChosenLux][iI].MapIndex;
				local iScore = self.aaPossibleLuxLocs[eChosenLux][iI].Score;

				-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
				iTotalPlaced = iTotalPlaced + 1;
				--print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__ScoreLuxuryPlots(iResourceIndex, eContinent)
	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleLuxLocs[iResourceIndex]) do
		self.aaPossibleLuxLocs[iResourceIndex][k] = nil;
	end

	plots = Map.GetContinentPlots(eContinent);
	for i, plot in ipairs(plots) do
		local pPlot = Map.GetPlotByIndex(plot);
		local bIce = false;
		
		if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
			bIce = true;
		end

		if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex]) and bIce == false) then
			row = {};
			row.MapIndex = plot;
			row.Score = 500;
			row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 3.5);
			row.Score = row.Score + TerrainBuilder.GetRandomNumber(scoreRnd, "Resource Placement Score Adjust");
			
			if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleLuxLocs == 0) then
					table.insert (self.aaPossibleLuxLocs[iResourceIndex], row);
			end
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceWaterLuxury(eChosenLux, eContinent)
	local eLuxuryType = self.eResourceType[eChosenLux];

	-- Compute how many to place
	local iNumToPlace = 1;
	if(self.iOccurencesPerFrequency > 1) then
		iNumToPlace = self.iOccurencesPerFrequency;
	end

	
	-- Find the water luxury plots
	for k, v in pairs(self.aaPossibleLuxLocsWater[eChosenLux]) do
		self.aaPossibleLuxLocsWater[eChosenLux][k] = nil;
	end

	coastalPlots = Map.GetContinentCoastalPlots(eContinent, 2);
	for i, plot in ipairs(coastalPlots) do
		local pPlot = Map.GetPlotByIndex(plot);
		local bIce = false;
		
		if(IsAdjacentToIce(pPlot:GetX(), pPlot:GetY()) == true) then
			bIce = true;
		end

		-- See if the resources can appear here
		if (ResourceBuilder.CanHaveResource(pPlot, eChosenLux) and bIce == false) then
			local iBonusAdjacent = 0;

			if( self.iStandardPercentage < self.iTargetPercentage) then
				iBonusAdjacent = 0.5;
			elseif ( self.iStandardPercentage > self.iTargetPercentage) then
				iBonusAdjacent = -0.5;
			end
			
			row = {};
			row.MapIndex = plot;
			
			score = 500;
			score = score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 3.5);
			score = score + 100 + TerrainBuilder.GetRandomNumber(scoreRnd, "Resource Placement Score Adjust");

			--score = TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust");
			--score = score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * (3.5 + iBonusAdjacent));
			row.Score = score;
			
			if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleLuxLocsWater == 0) then
				table.insert (self.aaPossibleLuxLocsWater[eChosenLux], row);
			end
		end
	end


	-- Sort and take best score
	table.sort (self.aaPossibleLuxLocsWater[eLuxuryType], function(a, b) return a.Score > b.Score; end);

	for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleLuxLocsWater[eLuxuryType]) then
				local iMapIndex = self.aaPossibleLuxLocsWater[eLuxuryType][iI].MapIndex;
				local iScore = self.aaPossibleLuxLocsWater[eLuxuryType][iI].Score;

				-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eLuxuryType, 1);
--			print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetStrategicResources()
	local continentsInUse = Map.GetContinentsInUse();	
	self.iNumContinents = #continentsInUse;
	self.aStrategicType = {};

	-- Find the Strategic Resources
	for row = 0, self.iResourcesInDB do
		if (self.eResourceClassType[row] == "RESOURCECLASS_STRATEGIC" and self.iFrequency[row] > 0) then
				table.insert(self.aStrategicType, self.eResourceType[row]);
		end
	end

	aWeight = {};
	for row in GameInfo.Resource_Distribution() do
		if (row.Continents == self.iNumContinents) then
			for iI = 1, row.Scarce do
				table.insert(aWeight, 1 - row.PercentAdjusted / 100);
			end

			for iI = 1, row.Average do
				table.insert(aWeight, 1);
			end

			for iI = 1, row.Plentiful do
				table.insert(aWeight, 1 + row.PercentAdjusted / 100);
			end
		end
	end

	aWeight	= GetShuffledCopyOfTable(aWeight);

	self.iFrequencyStrategicTotal = 0;
    for i, row in ipairs(self.aStrategicType) do
		self.iFrequencyStrategicTotal = self.iFrequencyStrategicTotal + self.iFrequency[row];
	end

	for index, eContinent in ipairs(continentsInUse) do 
		-- Shuffle the table
		self.aStrategicType = GetShuffledCopyOfTable(self.aStrategicType);
		--print ("Retrieved plots for continent: " .. tostring(eContinent));

		self:__ValidStrategicPlots(aWeight[index], eContinent);

		-- next find the valid plots for each of the strategics
		self:__PlaceStrategicResources(eContinent);
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__ValidStrategicPlots(iWeight, eContinent)
	-- go through each plot on the continent and find the valid strategic plots
	local iSize = #self.aStrategicType;
	local iBaseScore = 1;
	self.iTotalValidPlots = 0;
	self.aResourcePlacementOrderStrategic = {};
	plots = Map.GetContinentPlots(eContinent);
	coastalPlots = Map.GetContinentCoastalPlots(eContinent, 2);

	-- Find valid spots for land resources first
	for i, plot in ipairs(plots) do
		local bCanHaveSomeResource = false;
		local pPlot = Map.GetPlotByIndex(plot);

		-- See which resources can appear here
		for iI = 1, iSize do
			if (ResourceBuilder.CanHaveResource(pPlot, self.aStrategicType[iI])) then
				row = {};
				row.MapIndex = plot;
				row.Score = iBaseScore;
				table.insert (self.aaPossibleStratLocs[self.aStrategicType[iI]], row);
				bCanHaveSomeResource = true;
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	-- Now run through the same logic but for coastal plots
	for i, plot in ipairs(coastalPlots) do
		local bCanHaveSomeResource = false;
		local pPlot = Map.GetPlotByIndex(plot);

		-- See which resources can appear here
		for iI = 1, iSize do
			if (ResourceBuilder.CanHaveResource(pPlot, self.aStrategicType[iI])) then
				row = {};
				row.MapIndex = plot;
				row.Score = 500;
				row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 4.5);
				row.Score = row.Score + TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust");
				table.insert (self.aaPossibleStratLocsWater[self.aStrategicType[iI]], row);
				bCanHaveSomeResource = true;
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	for iI = 1, iSize do
		row = {};
		row.ResourceIndex = self.aStrategicType[iI];
		row.NumEntries = #self.aaPossibleStratLocs[iI];
		row.Weight = iWeight or 0;
		table.insert (self.aResourcePlacementOrderStrategic, row);
	end

	table.sort (self.aResourcePlacementOrderStrategic, function(a, b) return a.NumEntries < b.NumEntries; end);

	self.iOccurencesPerFrequency = (#plots) * (self.iTargetPercentage / 100)  * (self.iStrategicPercentage / 100);
end

------------------------------------------------------------------------------
function ResourceGenerator:__PlaceStrategicResources(eContinent)
	-- Go through continent placing the chosen strategic
	for i, row in ipairs(self.aResourcePlacementOrderStrategic) do
		local eResourceType = self.eResourceType[row.ResourceIndex]

		local iNumToPlace;

		-- Compute how many to place
		iNumToPlace = self.iOccurencesPerFrequency * (self.iFrequency[row.ResourceIndex] / self.iFrequencyStrategicTotal) * row.Weight;

			-- Score possible locations
		self:__ScoreStrategicPlots(row.ResourceIndex, eContinent);

		-- Sort and take best score
		table.sort (self.aaPossibleStratLocs[row.ResourceIndex], function(a, b) return a.Score > b.Score; end);

		if(self.iFrequency[row.ResourceIndex] > 1 and iNumToPlace < 1) then
			iNumToPlace = 1;
		end

		for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleStratLocs[row.ResourceIndex]) then
				local iMapIndex = self.aaPossibleStratLocs[row.ResourceIndex][iI].MapIndex;
				local iScore = self.aaPossibleStratLocs[row.ResourceIndex][iI].Score;

				-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
--				print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__ScoreStrategicPlots(iResourceIndex, eContinent)
	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleStratLocs[iResourceIndex]) do
		self.aaPossibleStratLocs[iResourceIndex][k] = nil;
	end

	local iSize = #self.aaPossibleStratLocsWater[iResourceIndex];

	if(iSize > 0 ) then
		for k, v in pairs(self.aaPossibleStratLocsWater[iResourceIndex]) do
			row = {};
			row.MapIndex = v.MapIndex;
			row.Score = v.Score;
			table.insert (self.aaPossibleStratLocs[iResourceIndex], row);
		end
	end

	plots = Map.GetContinentPlots(eContinent);
	for i, plot in ipairs(plots) do
		local pPlot = Map.GetPlotByIndex(plot);
		if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex])) then
			row = {};
			row.MapIndex = plot;
			row.Score = 500;
			row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 4.5);
			row.Score = row.Score + TerrainBuilder.GetRandomNumber(scoreRnd, "Resource Placement Score Adjust");
			
			if(ResourceBuilder.GetAdjacentResourceCount(pPlot) <= 1 or #self.aaPossibleStratLocs == 0) then
				table.insert (self.aaPossibleStratLocs[iResourceIndex], row);
			end
		end
	end
end

------------------------------------------------------------------------------
function ResourceGenerator:__GetOtherResources()
	self.aOtherType = {};
	
	print("###################################################");
	print("Start of Other Resource Placements");
	print("###################################################");

	-- Find the other resources
    for row = 0, self.iResourcesInDB do
		if (self.eResourceClassType[row] ~= "RESOURCECLASS_STRATEGIC" and self.eResourceClassType[row] ~= "RESOURCECLASS_LUXURY" and self.eResourceClassType[row] ~= "RESOURCECLASS_ARTIFACT") then
			table.insert(self.aOtherType, self.eResourceType[row]);
		elseif (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.aResourceName[row] == 'RESOURCE_WHALES') or (self.eResourceClassType[row] == "RESOURCECLASS_LUXURY" and self.aResourceName[row] == 'RESOURCE_PEARLS') then
			print("Adding " .. self.aResourceName[row] .. " To Resource Table");
			table.insert(self.aOtherType, self.eResourceType[row]);
		end
	end

	-- Shuffle the table
	self.aOtherType = GetShuffledCopyOfTable(self.aOtherType);

	local iW, iH;
	iW, iH = Map.GetGridSize();

	local iBaseScore = 1;
	self.iTotalValidPlots = 0;
	local iSize = #self.aOtherType;
	local iPlotCount = Map.GetPlotCount();
	for i = 0, iPlotCount - 1 do
		local pPlot = Map.GetPlotByIndex(i);
		local bCanHaveSomeResource = false;

		-- See which resources can appear here
		for iI = 1, iSize do
			if (ResourceBuilder.CanHaveResource(pPlot, self.aOtherType[iI])) then
				row = {};
				row.MapIndex = i;
				row.Score = iBaseScore;
				table.insert (self.aaPossibleLocs[self.aOtherType[iI]], row);
				bCanHaveSomeResource = true;
			end
		end

		if (bCanHaveSomeResource == true) then
			self.iTotalValidPlots = self.iTotalValidPlots + 1;
		end
	end

	for iI = 1, iSize do
		row = {};
		row.ResourceIndex = self.aOtherType[iI];
		row.NumEntries = #self.aaPossibleLocs[iI];
		table.insert (self.aResourcePlacementOrder, row);
	end

	table.sort (self.aResourcePlacementOrder, function(a, b) return a.NumEntries < b.NumEntries; end);

    for i, row in ipairs(self.aOtherType) do
		self.iFrequencyTotal = self.iFrequencyTotal + self.iFrequency[row];
	end

	--print ("Total frequency: " .. tostring(self.iFrequencyTotal));

	-- Compute how many of each resource to place
	self.iOccurencesPerFrequency = (self.iTargetPercentage / 100 ) * self.iTotalValidPlots * (100 - self.iStrategicPercentage - self.iLuxuryPercentage) / 100 / self.iFrequencyTotal;

	--print ("Occurrences per frequency: " .. tostring(self.iOccurencesPerFrequency));

	self:__PlaceOtherResources();
end
------------------------------------------------------------------------------
function ResourceGenerator:__PlaceOtherResources()

    for i, row in ipairs(self.aResourcePlacementOrder) do

		local eResourceType = self.eResourceType[row.ResourceIndex]

		local iNumToPlace;

		-- Compute how many to place
		iNumToPlace = self.iOccurencesPerFrequency * self.iFrequency[row.ResourceIndex];
	
		-- Score possible locations
		self:__ScorePlots(row.ResourceIndex);
	
		-- Sort and take best score
		table.sort (self.aaPossibleLocs[row.ResourceIndex], function(a, b) return a.Score > b.Score; end);

		for iI = 1, iNumToPlace do
			if (iI <= #self.aaPossibleLocs[row.ResourceIndex]) then
				local iMapIndex = self.aaPossibleLocs[row.ResourceIndex][iI].MapIndex;
				local iScore = self.aaPossibleLocs[row.ResourceIndex][iI].Score;

					-- Place at this location
				local pPlot = Map.GetPlotByIndex(iMapIndex);
				ResourceBuilder.SetResourceType(pPlot, eResourceType, 1);
--				print ("   Placed at (" .. tostring(pPlot:GetX()) .. ", " .. tostring(pPlot:GetY()) .. ") with score of " .. tostring(iScore));
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__ScorePlots(iResourceIndex)

	local iW, iH;
	iW, iH = Map.GetGridSize();

	-- Clear all earlier entries (some might not be valid if resources have been placed
	for k, v in pairs(self.aaPossibleLocs[iResourceIndex]) do
		self.aaPossibleLocs[iResourceIndex][k] = nil;
	end

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			if (ResourceBuilder.CanHaveResource(pPlot, self.eResourceType[iResourceIndex])) then
				row = {};
				row.MapIndex = i;
				row.Score = 500;
				row.Score = row.Score / ((ResourceBuilder.GetAdjacentResourceCount(pPlot) + 1) * 1.1);
				row.Score = row.Score + TerrainBuilder.GetRandomNumber(scoreRnd, "Resource Placement Score Adjust");
				table.insert (self.aaPossibleLocs[iResourceIndex], row);
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__RemoveOtherDuplicateResources()

	local iW, iH;
	iW, iH = Map.GetGridSize();

	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			if(pPlot:GetResourceCount() > 0) then
				for row = 0, self.iResourcesInDB do
					if (self.eResourceClassType[row] ~= "RESOURCECLASS_STRATEGIC" and self.eResourceClassType[row] ~= "RESOURCECLASS_LUXURY" and self.eResourceClassType[row] ~= "RESOURCECLASS_ARTIFACT") then
						if(self.eResourceType[row]  == pPlot:GetResourceType()) then
							local bRemove = self:__RemoveDuplicateResources(pPlot, self.eResourceType[row]);
							if(bRemove == true) then
								ResourceBuilder.SetResourceType(pPlot, -1);
							end
						end
					end		
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function ResourceGenerator:__RemoveDuplicateResources(plot, eResourceType)
	local iCount = 0;
	
	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
		local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
		if (adjacentPlot ~= nil) then
			if(adjacentPlot:GetResourceCount() > 0) then
				if(adjacentPlot:GetResourceType() == eResourceType) then
					iCount = iCount + 1;
				end
			end
		end
	end

	if(iCount >= 2) then
		return true;
	else
		return false;
	end
end
