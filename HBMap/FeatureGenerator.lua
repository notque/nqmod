------------------------------------------------------------------------------
FeatureGenerator = {};
------------------------------------------------------------------------------
function FeatureGenerator.Create(args)
	--
	local args = args or {};
	local rainfall = args.rainfall or 2; -- Default is Normal rainfall.
	local iEquatorAdjustment = args.iEquatorAdjustment or 0;
	
	-- Sea Level and World Age map options affect only plot generation.
	-- Temperature map options affect only terrain generation.
	-- Rainfall map options affect only feature generation.

	if rainfall == 1 then
			rainfall = -4;
	elseif rainfall == 2 then
		rainfall = 0
	elseif rainfall == 3 then
		rainfall = 4;	
	else
		rainfall = TerrainBuilder.GetRandomNumber(11, "Random Rainfall - Lua") - 5;
	end

	-- Set feature traits.
	local iJunglePercent = args.iJunglePercent or 12;
	local iForestPercent = args.iForestPercent or 18;
	local iMarshPercent = args.iMarshPercent or 3;
	local iOasisPercent = args.iOasisPercent or 1;

	iJunglePercent = iJunglePercent + rainfall;
	iForestPercent = iForestPercent + rainfall;
	iMarshPercent = iMarshPercent + rainfall / 2;
	iOasisPercent = iOasisPercent + rainfall / 4;

	local gridWidth, gridHeight = Map.GetGridSize();
	local iEquator = math.ceil(gridHeight / 2) + iEquatorAdjustment;
--
	-- create instance data
	local instance = {
	
		-- methods
		__initFractals		= FeatureGenerator.__initFractals,
		__initFeatureTypes	= FeatureGenerator.__initFeatureTypes,
		AddFeatures			= FeatureGenerator.AddFeatures,
		GetLatitudeAtPlot	= FeatureGenerator.GetLatitudeAtPlot,
		AddFeaturesAtPlot	= FeatureGenerator.AddFeaturesAtPlot,
		AddOasisAtPlot		= FeatureGenerator.AddOasisAtPlot,
		AddIceAtPlot		= FeatureGenerator.AddIceAtPlot,
		AddMarshAtPlot		= FeatureGenerator.AddMarshAtPlot,
		AddJunglesAtPlot	= FeatureGenerator.AddJunglesAtPlot,
		AddForestsAtPlot	= FeatureGenerator.AddForestsAtPlot,
		AddAtolls			= FeatureGenerator.AddAtolls,
		AdjustTerrainTypes	= FeatureGenerator.AdjustTerrainTypes,
		
		-- members
		iGridW = gridWidth,
		iGridH = gridHeight,
		
		iJungleMaxPercent = iJunglePercent,
		iForestMaxPercent = iForestPercent,
		iMarshMaxPercent = iMarshPercent,
		iOasisMaxPercent = iOasisPercent,

		iForestCount = 0,
		iJungleCount = 0,
		iMarshCount = 0,
		iOasisCount = 0,
		iNumLandPlots = 0,
		iJungleBottom = iEquator -  math.ceil(iJunglePercent * 0.5),
		iJungleTop = iEquator +  math.ceil(iJunglePercent * 0.5)
	};

	-- initialize instance data
	
	return instance;
end
------------------------------------------------------------------------------
function FeatureGenerator:AddFeatures(allow_mountains_on_coast)
	local flag = allow_mountains_on_coast or true;

	if allow_mountains_on_coast == false then -- remove any mountains from coastal plots
		for x = 0, self.iGridW - 1 do
			for y = 0, self.iGridH - 1 do
				local plot = Map.GetPlot(x, y)
				if plot:GetPlotType() == g_PLOT_TYPE_MOUNTAIN then
					if plot:IsCoastalLand() then
						plot:SetPlotType(g_PLOT_TYPE_HILLS, false, true); -- These flags are for recalc of areas and rebuild of graphics. Instead of recalc over and over, do recalc at end of loop.
					end
				end
			end
		end
		-- This function needs to recalculate areas after operating. However, so does 
		-- adding feature ice, so the recalc was removed from here and put in MapGenerator()
	end
	
	-- Main loop, adds features to all plots as appropriate based on the count and percentage of that type
	for y = 0, self.iGridH - 1, 1 do
		for x = 0, self.iGridW - 1, 1 do
			

			local i = y * self.iGridW + x;
			local plot = Map.GetPlotByIndex(i);
			if(plot ~= nil) then
				local featureType = plot:GetFeatureType();

				if(plot:IsImpassable() or featureType ~= g_FEATURE_NONE) then
					--No Feature
				elseif(plot:IsWater() == true) then
					if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_ICE) == true and IsAdjacentToRiver(x, y) == false) then
						self:AddIceAtPlot(plot, x, y);
					end
				else
					self.iNumLandPlots = self.iNumLandPlots + 1;
					if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FLOODPLAINS) == true) then
						-- All desert plots along river are set to flood plains.
						TerrainBuilder.SetFeatureType(plot, g_FEATURE_FLOODPLAINS)
					elseif(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_OASIS) == true and math.ceil(self.iOasisCount * 100 / self.iNumLandPlots) <= self.iOasisMaxPercent ) then
						if(TerrainBuilder.GetRandomNumber(4, "Oasis Random") == 1) then
							TerrainBuilder.SetFeatureType(plot, g_FEATURE_OASIS);
							self.iOasisCount = self.iOasisCount + 1;
						end
					end

					local bMarsh = false;
					local bJungle = false;
					if(featureType == g_FEATURE_NONE) then
						--First check to add Marsh
						bMarsh = self:AddMarshAtPlot(plot, x, y);

						if(featureType == g_FEATURE_NONE and  bMarsh == false) then
							--check to add Jungle
							bJungle = self:AddJunglesAtPlot(plot, x, y);
						end
						
						if(featureType == g_FEATURE_NONE and bMarsh== false and bJungle == false) then 
							--check to add Forest
							self:AddForestsAtPlot(plot, x, y);
						end
					end
				end
			end
		end
	end
	
	print("Number of Forests: ", self.iForestCount);
	print("Number of Jungles: ", self.iJungleCount);
	print("Number of Marshes: ", self.iMarshCount);
	print("Number of Oasis: ", self.iOasisCount);
end
------------------------------------------------------------------------------
function FeatureGenerator:AddIceAtPlot(plot, iX, iY)
	local lat = math.abs((self.iGridH/2) - iY)/(self.iGridH/2)

	lat=lat*.5;
	
	if Map.IsWrapX() and (iY == 0 or iY == self.iGridH - 1) then
		TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
	else
		local rand = TerrainBuilder.GetRandomNumber(100, "Add Ice Lua")/100.0;
		
		if(rand < 8 * (lat - 0.875)) then
			TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
		elseif(rand < 4 * (lat - 0.75)) then
			TerrainBuilder.SetFeatureType(plot, g_FEATURE_ICE);
		end
	end
end
------------------------------------------------------------------------------
function FeatureGenerator:AddMarshAtPlot(plot, iX, iY)
	--Marsh Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_MARSH)) then
		if(math.ceil(self.iMarshCount * 100 / self.iNumLandPlots) <= self.iMarshMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 300;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_MARSH);
				

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_MARSH);
				self.iMarshCount = self.iMarshCount + 1;

				return true;
			end
		end
	end

	return false;
end
------------------------------------------------------------------------------
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY)
	--Jungle Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE)) then
		if(math.ceil(self.iJungleCount * 100 / self.iNumLandPlots) <= self.iJungleMaxPercent) then
			if(iY >= self.iJungleBottom  and iY <= self.iJungleTop) then 
				--Weight based on adjacent plots if it has more than 3 start subtracting
				local iScore = 300;
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JUNGLE);

				if(iAdjacent == 0 ) then
					iScore = iScore;
				elseif(iAdjacent == 1) then
					iScore = iScore + 50;
				elseif (iAdjacent == 2 or iAdjacent == 3) then
					iScore = iScore + 150;
				elseif (iAdjacent == 4) then
					iScore = iScore - 50;
				else
					iScore = iScore - 200;
				end

				if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
					local terrainType = plot:GetTerrainType();

					if(terrainType == g_TERRAIN_TYPE_PLAINS_HILLS or terrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS_HILLS);
					else
						TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS);
					end

					self.iJungleCount = self.iJungleCount + 1;
					return true;
				end
			end
		end
	end

	return false
end
------------------------------------------------------------------------------
function FeatureGenerator:AddForestsAtPlot(plot, iX, iY)
	--Forest Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FOREST)) then
		if(math.ceil(self.iForestCount * 100 / self.iNumLandPlots) <= self.iForestMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 300;
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_FOREST);

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);
				self.iForestCount = self.iForestCount + 1;
			end
		end
	end
end
------------------------------------------------------------------------------
