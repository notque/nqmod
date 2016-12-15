------------------------------------------------------------------------------
--	FILE:	 Pangaea.lua
--	AUTHOR:  
--	PURPOSE: Base game script - Simulates a Pan-Earth Supercontinent.
------------------------------------------------------------------------------
--	Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"
include "MountainsCliffs"
include "RiversLakes"
include "FeatureGenerator"
include "TerrainGenerator"
include "NaturalWonderGenerator"
include "ResourceGenerator"
include "AssignStartingPlots"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local g_iNumTotalLandTiles = 0; 

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Pangea Map");

	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = MapConfiguration.GetValue("temperature"); -- Default setting is Temperate.
	if temperature == 4 then
		temperature  =  1 + TerrainBuilder.GetRandomNumber(3, "Random Temperature- Lua");
	end
	
	--bShift = -0.2;
	
	local allcomplete = false;

	while allcomplete == false do
		plotTypes = GeneratePlotTypes();

		--check to make sure map has not failed
		local iNumLandTilesInUse = 0;
		local iW, iH = Map.GetGridSize();
		local iPercent = (iW * iH) * 0.30;

		for y = 0, iH - 1 do
			for x = 0, iW - 1 do
				local i = iW * y + x;
				--print("PlotType", plotTypes[i])
				if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
					iNumLandTilesInUse = iNumLandTilesInUse + 1;
				end
			end
		end
 
		print("######### Map Failure Check #########");
		print("30% Of Map Area: ", iPercent);
		print("Map Land Tiles: ", iNumLandTilesInUse);

		if iNumLandTilesInUse >= iPercent then
			allcomplete = true;
			print("######### Map Pass #########");
		else
			print("######### Map Failure #########");
		end
	end

	terrainTypes = GenerateTerrainTypes(plotTypes, g_iW, g_iH, g_iFlags, true, temperature, bShift);

	for i = 0, (g_iW * g_iH) - 1, 1 do
		pPlot = Map.GetPlotByIndex(i);
		if (plotTypes[i] == g_PLOT_TYPE_HILLS) then
			terrainTypes[i] = terrainTypes[i] + 1;
		end
		TerrainBuilder.SetTerrainType(pPlot, terrainTypes[i]);
	end

	-- Temp
	AreaBuilder.Recalculate();
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();
	
	-- Lakes would interfere with rivers, causing them to stop and not reach the ocean, if placed any sooner.
	local numLargeLakes = math.ceil(GameInfo.Maps[Map.GetMapSize()].Continents * 1.5);
	AddLakes(numLargeLakes);

	AddFeatures();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};

	local nwGen = NaturalWonderGenerator.Create(args);

	AreaBuilder.Recalculate();
	TerrainBuilder.AnalyzeChokepoints();
	TerrainBuilder.StampContinents();
	
	resourcesConfig = MapConfiguration.GetValue("resources");
	local args = {
		resources = resourcesConfig,
		bLandBias = true,
	}
	local resGen = ResourceGenerator.Create(args);

--	for i = 0, (g_iW * g_iH) - 1, 1 do
--		pPlot = Map.GetPlotByIndex(i);
--		print ("i: plotType, terrainType, featureType: " .. tostring(i) .. ": " .. tostring(plotTypes[i]) .. ", " .. tostring(terrainTypes[i]) .. ", " .. tostring(pPlot:GetFeatureType(i)));
--	end

	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 400,
		MIN_MINOR_CIV_FERTILITY = 50, 
		MIN_BARBARIAN_FERTILITY = 1,
		START_MIN_Y = 20,
		START_MAX_Y = 20,
		START_CONFIG = startConfig,
		LAND = true,
		FORCE_ALL_CIVS_ON_LARGEST_LANDMASS = true,
	};

	
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Generating Plot Types");
	local plotTypes = {};

	local sea_level_low = 48;
	local sea_level_normal = 53;
	local sea_level_high = 58;
	local world_age_old = 2;
	local world_age_normal = 3;
	local world_age_new = 5;

	local grain_amount = 3;
	local adjust_plates = 1.3;
	local shift_plot_types = true;
	local tectonic_islands = true;
	local hills_ridge_flags = g_iFlags;
	local peaks_ridge_flags = g_iFlags;
	local has_center_rift = false;
	
	--	local world_age
	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 2) then
		world_age = world_age_normal;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = 2 + TerrainBuilder.GetRandomNumber(4, "Random World Age - Lua");
	end

	--	local sea_level
    local sea_level = MapConfiguration.GetValue("sea_level");
	local water_percent;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low
	elseif sea_level == 2 then -- Normal Sea Level
		water_percent =sea_level_normal
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high
	else
		sea_level = TerrainBuilder.GetRandomNumber(2, "Random Sea Level - Lua") + 1;
		print("SEA LEVEL: " .. sea_level);
		water_percent = TerrainBuilder.GetRandomNumber(sea_level_high - sea_level_low, "Random Sea Level - Lua") + sea_level_low + 1; 
	end

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 100% or more of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold, biggest_area, iNumBiggestAreaTiles, iBiggestID;
	local bMapOK = false;

	while bMapOK == false do
		while done == false do
			local grain_dice = TerrainBuilder.GetRandomNumber(2, "Continental Grain roll - LUA Pangea");
			if grain_dice < 4 then
				grain_dice = 1;
			else
				grain_dice = 2;
			end
			local rift_dice = TerrainBuilder.GetRandomNumber(3, "Rift Grain roll - LUA Pangea");
			if rift_dice < 1 then
				rift_dice = -1;
			end
			
			rift_dice = 2;
			grain_dice = 1;

			print("Grain: ", grain_dice);
			print("Rift: ", rift_dice);

			g_continentsFrac = nil;
			InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
			iWaterThreshold = g_continentsFrac:GetHeight(water_percent);
			
			g_iNumTotalLandTiles = 0;
			for x = 0, g_iW - 1 do
				for y = 0, g_iH - 1 do
					local i = y * g_iW + x;
					local val = g_continentsFrac:GetHeight(x, y);
					local pPlot = Map.GetPlotByIndex(i);
					if(val <= iWaterThreshold) then
						plotTypes[i] = g_PLOT_TYPE_OCEAN;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);  -- temporary setting so can calculate areas
					else
						plotTypes[i] = g_PLOT_TYPE_LAND;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_DESERT);  -- temporary setting so can calculate areas
						g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
					end
				end
			end
			
			AreaBuilder.Recalculate();
			local biggest_area = Areas.FindBiggestArea(false);
			iNumBiggestAreaTiles = biggest_area:GetPlotCount();
			
			-- Now test the biggest landmass to see if it is large enough.
			if iNumBiggestAreaTiles >= g_iNumTotalLandTiles * 1 then
				
				print("-------------------- Map 100% ------------------------------");
				done = true;
				iBiggestID = biggest_area:GetID();
			end
			iAttempts = iAttempts + 1;
			
			-- Printout for debug use only
			-- print("-"); print("--- Pangea landmass generation, Attempt#", iAttempts, "---");
			-- print("- This attempt successful: ", done);
			-- print("- Total Land Plots in world:", g_iNumTotalLandTiles);
			-- print("- Land Plots belonging to biggest landmass:", iNumBiggestAreaTiles);
			-- print("- Percentage of land belonging to Pangaea: ", 100 * iNumBiggestAreaTiles / g_iNumTotalLandTiles);
			-- print("- Continent Grain for this attempt: ", grain_dice);
			-- print("- Rift Grain for this attempt: ", rift_dice);
			-- print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
			-- print(".");
		end
		
		--add water to top & bottom of map
		
		for y = 0, 5 do
			for x = 0 , g_iW - 1 do
				local i = y * g_iW + x;
				local pPlot = Map.GetPlotByIndex(i);
				local mWater = TerrainBuilder.GetRandomNumber(100, "Should This Tile Be Water");
				
				if y > 3 then
					if mWater > 49 then
						plotTypes[i] = g_PLOT_TYPE_OCEAN;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
					end
				else
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
				end
			end
		end
		
		for y = g_iH - 1, g_iH - 6, -1 do
			for x = 0 , g_iW - 1 do
				local i = y * g_iW + x;
				local pPlot = Map.GetPlotByIndex(i);
				local mWater = TerrainBuilder.GetRandomNumber(100, "Should This Tile Be Water");
				
				if y < g_iH - 4 then
					if mWater > 49 then
						plotTypes[i] = g_PLOT_TYPE_OCEAN;
						TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
					end
				else
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
					TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
				end
			end
		end
		
		-- See if we can add some variance in the edges of the landmass
		local iW, iH = Map.GetGridSize();
		local centerX = iW / 2;
		local centerY = iH / 2;
		local fracFlags = {FRAC_POLAR = true};
		local baysFrac = Fractal.Create(iW, iH, 3, fracFlags, -1, -1);
		local iBaysThreshold = baysFrac:GetHeight(98);  --lakes lavel size
		local axis_list = {0.87, 0.81, 0.75};
		local axis_multiplier = axis_list[sea_level];
		local cohesion_list = {0.37, 0.1, 0.31};
		local cohesion_multiplier = cohesion_list[sea_level];
		majorAxis = centerX * cohesion_multiplier;
		minorAxis = centerY * cohesion_multiplier;
		majorAxisSquared = majorAxis * majorAxis;
		minorAxisSquared = minorAxis * minorAxis;
		for y = 0, iH - 1 do
			for x = 0, iW - 1 do
				local deltaX = x - centerX;
				local deltaY = y - centerY;
				local deltaXSquared = deltaX * deltaX;
				local deltaYSquared = deltaY * deltaY;
				local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
				if d > 1 then
					local i = y * iW + x + 1;
					local baysVal = baysFrac:GetHeight(x, y);
					if baysVal >= iBaysThreshold then
						plotTypes[i] = g_PLOT_TYPE_OCEAN;
						print("Setting To Ocean");
					end
				end
			end
		end

		-- Bays end

		--BEGING CHECK OF LANDMASS CHOKES
		local iW, iH = Map.GetGridSize();
		local bfland = false;
		local startcol = 0;
		local cont = 0;
		local bprev = false;
		local biggest = 0;
		local mainstart = 0;
		local mainend = 0;
		--local cencol = 0;
		--local colshift = 0;
		local landincol = 0;
		local chkstart = 0;
		local chkend = 0;
		local chokepoint = 10;
		local bXChkFail = false;
		local bYChkFail = false;
		local bLastLand = false;
		local contlandincol = 0;
		--local xcen = 0;
		--local ycen = 0;

		--check y choke points
		print("-----------------------------------");
		print("Checking Y Chokes");
		print("-----------------------------------");
		for x = 1, iW do
			bfland = false;
			landincol = 0;
	
			for y = 2, iH-2  do
				local i = iW * y + x;
				--print("Plot Location = ", i);
				if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
					landincol = landincol + 1;
					bfland = true;
				end
			end
	
			if bfland == false then
				--print("No Land Found in Col: ", x);
				bprev = false;
				if cont > biggest then
					biggest = cont;
					mainstart = startcol;
					mainend = x-1;
				end
				cont = 0;
				startcol = 0;
			else
				--print("Land Found In Col: ", x, "Qty: ", landincol);
				if startcol == 0 then
					startcol = x;
				end
				bprev = true;
				cont = cont + 1;	
			end
		end
	
		xstart = mainstart;
		xend = mainend;

		chkstart = mainstart + 5;
		chkend = mainend -  5;

		for x = chkstart, chkend do
			landincol = 0;
			contlandincol = 0;
			for y = 2, iH-2  do
				local i = iW * y + x;
				--print("Plot Location = ", i);
				if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
				
					if bLastLand == true then
						landincol = landincol + 1;
						bLastLand = true;
					else
						landincol = 1;
						bLastLand = true;
					end
				else
					if contlandincol < landincol then
						contlandincol = landincol;
					end
					bLastLand = false;
					landincol = 0;
				end
			end

			--print("Checking Col:", x, "Continuous Land In Col: ", contlandincol);

			if contlandincol < chokepoint then
				--print("Choke Point in Col: ", x);
				bXChkFail = true;
			end
		end



		--check x choke points
		print("-----------------------------------");
		print("Checking X Chokes");
		print("-----------------------------------");
		startcol = 0;
		cont = 0;
		biggest = 0;
		for y = 2, iH-2 do
			bfland = false;
			landincol = 0;
	
			for x = 1, iW  do
				local i = iW * y + x;
				--print("Plot Location = ", i);
				if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
					landincol = landincol + 1;
					bfland = true;
				end
			end
	
			if bfland == false then
				--print("No Land Found in Row: ", y);
				bprev = false;
				if cont > biggest then
					biggest = cont;
					mainstart = startcol;
					mainend = y-1;
				end
				cont = 0;
				startcol = 0;
			else
				--print("Land Found In Row: ", y, "Qty: ", landincol);
				if startcol == 0 then
					startcol = y;
				end
				bprev = true;
				cont = cont + 1;	
			end
		end

		ystart = mainstart;
		yend = mainend;

		chkstart = mainstart + 5;
		chkend = mainend -  5;
		--print("-----");
		--print("Mainland Start Row: ", chkstart);
		--print("Mainland End Row: ", chkend);
		--print("-----");
		for y = chkstart, chkend do
			landincol = 0;
			contlandincol = 0;
			for x = 1, iW  do
				local i = iW * y + x;
				--print("Plot Location = ", i);
				if plotTypes[i] ~= g_PLOT_TYPE_OCEAN then
				
					if bLastLand == true then
						landincol = landincol + 1;
						bLastLand = true;
					else
						landincol = 1;
						bLastLand = true;
					end
				else
					if contlandincol < landincol then
						contlandincol = landincol;
					end
					bLastLand = false;
					landincol = 0;
				end
			end

			--print("Checking Col:", y, "Continuous Land In Col: ", contlandincol);

			if contlandincol < chokepoint then
				--print("Choke Point in Row: ", y);
				bYChkFail = true;
			end
		end



		if bXChkFail == true then
			print("X Check: False");
		else
			print("X Check: True");
		end

		if bYChkFail == true then
			print("Y Check: False");
		else
			print("Y Check: True");
		end

		if (bXChkFail == true or bYChkFail == true) then
			print("##############################################");
			print("Map No Good");
			print("##############################################");
			bMapOK = false;
			done = false;
		else
			print("##############################################");
			print("Map Passes");
			print("##############################################");
			bMapOK = true;
		
			--[[ cencol = xstart + ((xend - xstart) / 2);
			colshift = (iW/2)-cencol;
			print("Pangaea X Starts At Col: ", xstart, " And Edns At Col: ", xend);
			print("Center X of Lanmass is at Col: ", cencol, "Shift Need: ", colshift);
			xshiftamt = math.ceil(colshift);
			print("Actual Integer Shift Applied: ", xshiftamt);
			if xshiftamt > 0 then
				xshift = 1;
			elseif xshiftamt < 0 then
				xshift = 2;
			else
				xshift = 0;
			end

			print("##############################################");
			cencol = ystart + ((yend - ystart) / 2);
			colshift = (iH/2)-cencol;
			print("Pangaea Y Starts At Col: ", ystart, " And Edns At Col: ", yend);
			print("Center Y of Lanmass is at Col: ", cencol, "Shift Need: ", colshift);
			yshiftamt = math.ceil(colshift);
			print("Actual Integer Shift Applied: ", yshiftamt);
			print("##############################################");
			if yshiftamt > 0 then
				yshift = 1;
			elseif yshiftamt < 0 then
				yshift = 2;
			else
				yshift = 0;
			end--]]
		end
	end


	--####################################################
	--clear area around pangaea
	local iW, iH = Map.GetGridSize();
	for x = 0, xstart - 1 do --clear west side of map
		for y = 0, iH  do
			destPlotIndex = iW * y + x;
			plotTypes[destPlotIndex] = g_PLOT_TYPE_OCEAN;
		end
	end


	for x = xend + 1, iW  do --clear east side of map
		for y = 0, iH  do
			destPlotIndex = iW * y + x;
			plotTypes[destPlotIndex] = g_PLOT_TYPE_OCEAN;
		end
	end

	for y = 0, ystart - 1 do --clear south side of map
		for x = 0, iW  do
			destPlotIndex = iW * y + x;
			plotTypes[destPlotIndex] = g_PLOT_TYPE_OCEAN;
		end
	end

	for y = yend + 1, iH  do --clear north side of map
		for x = 0, iW  do
			destPlotIndex = iW * y + x;
			plotTypes[destPlotIndex] = g_PLOT_TYPE_OCEAN;
		end
	end

	--END CHECK OF LANDMASS CHOKES

	

	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 10;
	args.blendFract = 1;
	args.extra_mountains = 4;
	plotTypes = ApplyTectonics(args, plotTypes);
	
	local mRatioVal = MapConfiguration.GetValue("MountDensity");
	
	mRatio = 15;
	if (mRatioVal == 1) then
		mRatio = 20;
	elseif (mRatioVal == 3) then
		mRatio = 10;
	end
	
	print("Mount Ratio: ", mRatio)
	
	plotTypes = AddLonelyMountains(plotTypes, mRatio);
	
	-- Now shift everything toward one of the poles, to reduce how much jungles tend to dominate this script.
	local shift_dice = TerrainBuilder.GetRandomNumber(2, "Shift direction - LUA Pangaea");
	local iStartRow, iNumRowsToShift;
	local bFoundPangaea, bDoShift = false, false;
	if shift_dice == 1 then
		-- Shift North
		for y = g_iH - 2, 1, -1 do
			for x = 0, g_iW - 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y + 1;
						if iStartRow < iNumPlotsY - 4 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	else
		-- Shift South
		for y = 1, g_iH - 2 do
			for x = 0, g_iW- 1 do
				local i = y * g_iW + x;
				if plotTypes[i] == g_PLOT_TYPE_HILLS or plotTypes[i] == g_PLOT_TYPE_LAND then
					local plot = Map.GetPlot(x, y);
					local iAreaID = plot:GetArea();
					if iAreaID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y - 1;
						if iStartRow > 3 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea == true then
				break
			end
		end
	end
	if bDoShift == true then
		if shift_dice == 1 then -- Shift North
			local iRowsDifference = g_iH - iStartRow - 2;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands northward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from top down.
			for y = (g_iH - 1) - iNumRowsToShift, 0, -1 do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = y * g_iW + x + 1;
					local destPlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = 0, iNumRowsToShift - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		else -- Shift South
			local iRowsDifference = iStartRow - 1;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = TerrainBuilder.GetRandomNumber(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			--print("-"); print("Shifting lands southward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from bottom up.
			for y = 0, (g_iH - 1) - iNumRowsToShift do
				for x = 0, g_iW - 1 do
					local sourcePlotIndex = (y + iNumRowsToShift) * g_iW + x + 1;
					local destPlotIndex = y * g_iW + x + 1;
					plotTypes[destPlotIndex] = plotTypes[sourcePlotIndex]
				end
			end
			for y = g_iH - iNumRowsToShift, g_iH - 1 do
				for x = 0, g_iW - 1 do
					local i = y * g_iW + x + 1;
					plotTypes[i] = g_PLOT_TYPE_OCEAN;
				end
			end
		end
	end

	return plotTypes;
end

function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};
	
	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end
	
	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end
	
	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);	
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
	added some minor randomness and the slope might be a little tricky. It was 
	intended as a 'whole world' modifier to the fractal class. You can modify 
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end
	
	local args = {rainfall = rainfall}
	local featuregen = FeatureGenerator.Create(args);

	featuregen:AddFeatures();
end
