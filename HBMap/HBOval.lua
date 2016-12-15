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

	local iW, iH = Map.GetGridSize();

	-- Fill all rows with water plots.
	plotTypes = table.fill(g_PLOT_TYPE_OCEAN, iW * iH);

	
	local fracFlags = {FRAC_POLAR = true};
	
	local axis_list = {0.87, 0.81, 0.75};
	local axis_multiplier = axis_list[sea_level];
	local cohesion_list = {0.60, 0.57, 0.54};
	local cohesion_multiplier = cohesion_list[sea_level];

	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * axis_multiplier;
	local minorAxis = centerY * axis_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local deltaX = x - centerX;
			local deltaY = y - centerY;
			local deltaXSquared = deltaX * deltaX;
			local deltaYSquared = deltaY * deltaY;
			local d = deltaXSquared/majorAxisSquared + deltaYSquared/minorAxisSquared;
			if d <= 1 then
				local i = y * iW + x + 1;
				plotTypes[i] = g_PLOT_TYPE_LAND;
			end
		end
	end
	
	-- Now add bays, fjords, inland seas, etc, but not inside the cohesion area.
	local baysFrac = Fractal.Create(iW, iH, 3, fracFlags, -1, -1);
	local iBaysThreshold = baysFrac:GetHeight(90);
	local centerX = iW / 2;
	local centerY = iH / 2;
	local majorAxis = centerX * cohesion_multiplier;
	local minorAxis = centerY * cohesion_multiplier;
	local majorAxisSquared = majorAxis * majorAxis;
	local minorAxisSquared = minorAxis * minorAxis;
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
				end
			end
		end
	end
	

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
	
	



	--PlotIndexreate islands. Try to make more useful islands than the default code.
	-- pick a random tile and check if it is ocean, if it is check tiles around it
	-- to see how big an island we can make, then make an island from size 1 up to the biggest we can make

	-- Hex Adjustment tables. These tables direct plot by plot scans in a radius 
	-- around a center hex, starting to Northeast, moving clockwise.
	local firstRingYIsEven = {{0, 1}, {1, 0}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}};

	local secondRingYIsEven = {
	{1, 2}, {1, 1}, {2, 0}, {1, -1}, {1, -2}, {0, -2},
	{-1, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-1, 2}, {0, 2}
	};

	local thirdRingYIsEven = {
	{1, 3}, {2, 2}, {2, 1}, {3, 0}, {2, -1}, {2, -2},
	{1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-2, -2}, {-3, -1},
	{-3, 0}, {-3, 1}, {-2, 2}, {-2, 3}, {-1, 3}, {0, 3}
	};

	local firstRingYIsOdd = {{1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {0, 1}};

	local secondRingYIsOdd = {		
	{1, 2}, {2, 1}, {2, 0}, {2, -1}, {1, -2}, {0, -2},
	{-1, -2}, {-1, -1}, {-2, 0}, {-1, 1}, {-1, 2}, {0, 2}
	};

	local thirdRingYIsOdd = {		
	{2, 3}, {2, 2}, {3, 1}, {3, 0}, {3, -1}, {2, -2},
	{2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -2}, {-2, -1},
	{-3, 0}, {-2, 1}, {-2, 2}, {-1, 3}, {0, 3}, {1, 3}
	};

	-- Direction types table, another method of handling hex adjustments, in combination with Map.PlotDirection()
	local direction_types = {
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_NORTHWEST
		};

	local iW, iH = Map.GetGridSize();
	local islMax = 12;
	local iLandSize = 1.8;
	local mapSize = iW * iH;
	local islCount = 0;
	local islLandInRing = 0;
	local goodX = 0;
	local goodY = 0;

	local wrapX = Map:IsWrapX();
	local wrapY = Map:IsWrapY();
	local nextX, nextY, plot_adjustments;
	local odd = firstRingYIsOdd;
	local even = firstRingYIsEven;

	print("######### Creating Islands #########");

	islCount = islMax;

	while islCount > 0 do
		local islLandInRing = 0;
		--pick random location
		local x = TerrainBuilder.GetRandomNumber(iW, "");
		local y = 6 + TerrainBuilder.GetRandomNumber((iH-12), "");	
		local plotIndex = y * iW + x;
		local radius = 2 + math.floor(TerrainBuilder.GetRandomNumber((islCount/iLandSize), ""));
		--print("Count: ", islCount);
		--print ("Radius: ", radius);
		--print("X=", x);
		--print("Y=", y);		

		--print("--------");
		--print("Random Plot Is: ", plotIndex);

		--check if random location is ocean
		if plotTypes[plotIndex] == g_PLOT_TYPE_OCEAN then

			--print("Location is Ocean");

			for ripple_radius = 1, radius do
				local ripple_value = radius - ripple_radius + 1;
				local currentX = x - ripple_radius;
				local currentY = y;
				for direction_index = 1, 6 do
					for plot_to_handle = 1, ripple_radius do
			 			if currentY / 2 > math.floor(currentY / 2) then
							plot_adjustments = odd[direction_index];
						else
							plot_adjustments = even[direction_index];
						end
						nextX = currentX + plot_adjustments[1];
						nextY = currentY + plot_adjustments[2];
						if wrapX == false and (nextX < 0 or nextX >= iW) then
							-- X is out of bounds.
						elseif wrapY == false and (nextY < 0 or nextY >= iH) then
							-- Y is out of bounds.
						else
							local realX = nextX;
							local realY = nextY;
							if wrapX then
								realX = realX % iW;
							end
							if wrapY then
								realY = realY % iH;
							end
							-- We've arrived at the correct x and y for the current plot.
							local plot = Map.GetPlot(realX, realY);
							local plotIndex = realY * iW + realX + 1;

							--print("--------");
							--print("Plot Is: ", plotIndex);

							-- Check this plot for land.

							if plotTypes[plotIndex] == g_PLOT_TYPE_LAND then
								islLandInRing = ripple_radius;
								break;
							end

							currentX, currentY = nextX, nextY;
						end
					end

					if islLandInRing ~= 0 then
						break;
					end
				end

				if islLandInRing ~= 0 then
					break;
				end

			end

			if islLandInRing == 0 then
		
				local actradius = radius - 1;
				local thisislandvar = TerrainBuilder.GetRandomNumber(40, "") + 40;

				plotIndex = y * iW + x+1;
				--print("---------PlotIndex: ", plotIndex);
				--print("---------");
				--print("Island Location Found At X=", x, ", Y=",y);
				--print("Island Size: ", actradius);
			
				plotTypes[plotIndex] = g_PLOT_TYPE_LAND;

				for ripple_radius = 1, actradius do
					local ripple_value = actradius - ripple_radius + 1;
					local currentX = x - ripple_radius;
					local currentY = y;
					for direction_index = 1, 6 do
						for plot_to_handle = 1, ripple_radius do
				 			if currentY / 2 > math.floor(currentY / 2) then
								plot_adjustments = odd[direction_index];
							else
								plot_adjustments = even[direction_index];
							end
							nextX = currentX + plot_adjustments[1];
							nextY = currentY + plot_adjustments[2];
							if wrapX == false and (nextX < 0 or nextX >= iW) then
								-- X is out of bounds.
							elseif wrapY == false and (nextY < 0 or nextY >= iH) then
								-- Y is out of bounds.
							else
								local realX = nextX;
								local realY = nextY;
								if wrapX then
									realX = realX % iW;
								end
								if wrapY then
									realY = realY % iH;
								end
								-- We've arrived at the correct x and y for the current plot.
								local plot = Map.GetPlot(realX, realY);
								local plotIndex = realY * iW + realX + 1;

								--print("--------");
								--print("Plot Is: ", plotIndex);

								-- closer we get to outer edge increase chance of ocean.
								if ripple_radius == 1  then --100%
									islThresh = TerrainBuilder.GetRandomNumber(27, "") + thisislandvar;
								elseif ripple_radius == 2 then -- 57% to 74%
									islThresh = TerrainBuilder.GetRandomNumber(32, "") + (thisislandvar / 1.25);
								elseif ripple_radius == 3 then --40% to 57%
									islThresh = TerrainBuilder.GetRandomNumber(25, "") + (thisislandvar / 1.5);
								else --30% to 50%
									islThresh = TerrainBuilder.GetRandomNumber(20, "") + (thisislandvar / 2);
								end

								local islRand = TerrainBuilder.GetRandomNumber(100, "");
								local islHill = TerrainBuilder.GetRandomNumber(100, "");

								--print("Rand: ", islRand, "Thresh: ", islThresh);

								if islRand > islThresh then
									plotTypes[plotIndex] = g_PLOT_TYPE_OCEAN
								else
									if islHill <= 30 then
										plotTypes[plotIndex] = g_PLOT_TYPE_LAND
									else
										plotTypes[plotIndex] = g_PLOT_TYPE_HILLS
									end
								end

								currentX, currentY = nextX, nextY;
							end
						end
					end

				end
		
				islCount = islCount - 1;
			else
			
				--print("---------");
				--print("Land In Ring: ", islLandInRing);
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