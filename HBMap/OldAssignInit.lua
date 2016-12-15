function AssignStartingPlots:__InitStartingData()
	if(self.uiMinMajorCivFertility <= 0) then
		self.uiMinMajorCivFertility = 5;
	end

	if(self.uiMinMinorCivFertility <= 0) then
		self.uiMinMinorCivFertility = 5;
	end

	if(self.uiMinBarbarianFertility<= 0) then
		self.uiMinBarbarianFertility = 1;
	end
	
	self.iNumMajorCivs = PlayerManager.GetAliveMajorsCount();
	self.iNumMinorCivs = PlayerManager.GetAliveMinorsCount();
	self.iNumRegions = self.iNumMajorCivs + self.iNumMinorCivs;
	local iMinNumBarbarians = self.iNumMajorCivs / 2;

	local iBonusMajor = (math.floor(self.iNumMajorCivs / 2) * 3);
	local iBonusMinor = math.floor(self.iNumMinorCivs / 2);

	if(iBonusMajor < 1) then
		iBonusMajor = 1;
	end

	if(iBonusMinor < 2) then
		iBonusMinor = 2;
	end

	StartPositioner.DivideMapIntoMajorRegions(self.iNumMajorCivs + iBonusMajor, self.iNumMinorCivs + iBonusMinor, iMinNumBarbarians, self.uiMinMajorCivFertility, self.uiMinMinorCivFertility, self.uiMinBarbarianFertility);
	
	local iMajorCivStartLocs = StartPositioner.GetNumMajorCivStarts();

	print("Number Of Starting Locations: ", iMajorCivStartLocs);

	--Find Default Number
	MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.RowId] = row.DefaultPlayers;
	end
	local sizekey = Map.GetMapSize() + 1;
	local iDefaultNumberPlayers = MapSizeTypes[sizekey] or 8;
	self.iDefaultNumberMajor = iDefaultNumberPlayers ;
	self.iDefaultNumberMinor = math.floor(iDefaultNumberPlayers * 1.5);

	self.iIndex = 0;
	self.player_ID_list = {};
	for i = 0, (self.iNumRegions) - 1 do
		table.insert(self.player_ID_list, i);
	end

	self.majorList = {};
	self.minorList = {};

	self.majorList = PlayerManager.GetAliveMajorIDs();
	self.minorList = PlayerManager.GetAliveMinorIDs();

	-- Place the major civ start plots in an array
	self.majorStartPlots = {};
	local failed = 0;
	for i = self.iNumMajorCivs - 1, 0, - 1 do
		plots = StartPositioner.GetMajorCivStartPlots(i);
		
		print("<<<<<<<<<<<<<<<<<<<<< START PLOT DATA: >>>>>>>>>>>>>>>>>>>");
		local startPlot = self:__SetStartMajor(plots);
		if(startPlot ~= nil) then
			print("<<<<<<<<<<<<<<<<<<< START LOCATION SUCCESS >>>>>>>>>>>>>>>>>>>>>>>>>>>");
			StartPositioner.MarkMajorRegionUsed(i);
			table.insert(self.majorStartPlots, startPlot);
			info = StartPositioner.GetMajorCivStartInfo(i);
			print ("ContinentType: " .. tostring(info.ContinentType));
			print ("LandmassID: " .. tostring(info.LandmassID));
			print ("Fertility: " .. tostring(info.Fertility));
			print ("TotalPlots: " .. tostring(info.TotalPlots));
			print ("WestEdge: " .. tostring(info.WestEdge));
			print ("EastEdge: " .. tostring(info.EastEdge));
			print ("NorthEdge: " .. tostring(info.NorthEdge));
			print ("SouthEdge: " .. tostring(info.SouthEdge));
		else
			failed = failed + 1;
			print("<<<<<<<<<<<<<<<<<<< START LOCATION INVALID >>>>>>>>>>>>>>>>>>>>>>>>>>>");
			info = StartPositioner.GetMajorCivStartInfo(i);
			print ("XContinentType: " .. tostring(info.ContinentType));
			print ("XLandmassID: " .. tostring(info.LandmassID));
			print ("XFertility: " .. tostring(info.Fertility));
			print ("XTotalPlots: " .. tostring(info.TotalPlots));
			print ("XWestEdge: " .. tostring(info.WestEdge));
			print ("XEastEdge: " .. tostring(info.EastEdge));
			print ("XNorthEdge: " .. tostring(info.NorthEdge));
			print ("XSouthEdge: " .. tostring(info.SouthEdge));
			print("Failed Major");
		end
	end


	local count = self.iNumMajorCivs;
	while failed > 0 and iMajorCivStartLocs > count do
		plots = StartPositioner.GetMajorCivStartPlots(count);
	
		local startPlot = self:__SetStartMajor(plots);
		print("<<<<<<<<<<<<<<<<<<<<< START PLOT DATA FOR FALIED: >>>>>>>>>>>>>>>>>>>");
		if(startPlot ~= nil) then
			print("<<<<<<<<<<<<<<<<<<< START LOCATION SUCCESS >>>>>>>>>>>>>>>>>>>>>>>>>>>");
			StartPositioner.MarkMajorRegionUsed(count);
			table.insert(self.majorStartPlots, startPlot);
			info = StartPositioner.GetMajorCivStartInfo(count);
			print ("ContinentType2: " .. tostring(info.ContinentType));
			print ("LandmassID2: " .. tostring(info.LandmassID));
			print ("Fertility2: " .. tostring(info.Fertility));
			print ("TotalPlots2: " .. tostring(info.TotalPlots));
			print ("WestEdge2: " .. tostring(info.WestEdge));
			print ("EastEdge2: " .. tostring(info.EastEdge));
			print ("NorthEdge2: " .. tostring(info.NorthEdge));
			print ("SouthEdge2: " .. tostring(info.SouthEdge));
			failed = failed - 1;
		else
			print("<<<<<<<<<<<<<<<<<<< START LOCATION INVALID >>>>>>>>>>>>>>>>>>>>>>>>>>>");
			info = StartPositioner.GetMajorCivStartInfo(count);
			print ("X2ContinentType: " .. tostring(info.ContinentType));
			print ("X2LandmassID: " .. tostring(info.LandmassID));
			print ("X2Fertility: " .. tostring(info.Fertility));
			print ("X2TotalPlots: " .. tostring(info.TotalPlots));
			print ("X2WestEdge: " .. tostring(info.WestEdge));
			print ("X2EastEdge: " .. tostring(info.EastEdge));
			print ("X2NorthEdge: " .. tostring(info.NorthEdge));
			print ("X2SouthEdge: " .. tostring(info.SouthEdge));
			print("faILed MAJOR MINOR");
		end
		count = count + 1;
	end

	for k, plot in ipairs(self.majorStartPlots) do
		table.insert(self.majorCopy, plot);
	end

	--Begin Start Bias for major
	self:__InitStartBias(false);

	if(self.uiStartConfig == 1 ) then
		self:__AddResourcesBalanced();
	elseif(self.uiStartConfig == 3 ) then
		self:__AddResourcesLegendary();
	end

	for i = 1, self.iNumMajorCivs do
		local player = Players[self.majorList[i]]
		
		if(player == nil) then
			--print("THIS PLAYER FAILED");
		else
			local hasPlot = false;
			for k, v in pairs(self.playerStarts[i]) do
				if(v~= nil and hasPlot == false) then
					hasPlot = true;
					player:SetStartingPlot(v);
					--print("Major Start X: ", v:GetX(), "Major Start Y: ", v:GetY());
				end
			end
		end
	end

	--Place the minor start plots in an array
	self.minorStartPlots = {};
	StartPositioner.DivideUnusedRegions();
	local iMinorCivStartLocs = StartPositioner.GetNumMinorCivStarts();
	local iBarbarianStartLocs = StartPositioner.GetNumBarbarianStarts();
	local i = 0;
	local valid = 0;
	while i <= iMinorCivStartLocs - 1 and valid < self.iNumMinorCivs do
		plots = StartPositioner.GetMinorCivStartPlots(i);
		local startPlot = self:__SetStartMinor(plots);
		info = StartPositioner.GetMinorCivStartInfo(i);
		if(startPlot ~= nil) then
			table.insert(self.minorStartPlots, startPlot);
			--print ("Minor ContinentType: " .. tostring(info.ContinentType));
			--print ("Minor LandmassID: " .. tostring(info.LandmassID));
			--print ("Minor Fertility: " .. tostring(info.Fertility));
			--print ("Minor TotalPlots: " .. tostring(info.TotalPlots));
			--print ("Minor WestEdge: " .. tostring(info.WestEdge));
			--print ("Minor EastEdge: " .. tostring(info.EastEdge));
			--print ("Minor NorthEdge: " .. tostring(info.NorthEdge));
			--print ("Minor SouthEdge: " .. tostring(info.SouthEdge));
			--print("Minor Tried to Start X: ", plot:GetX(), "Minor Tried to Start Y: ", plot:GetY());
			valid = valid + 1;
		else
			--print ("BAAAD Minor ContinentType: " .. tostring(info.ContinentType));
			--print ("BAAAD Minor LandmassID: " .. tostring(info.LandmassID));
			--print ("BAAAD Minor Fertility: " .. tostring(info.Fertility));
			--print ("BAAAD Minor TotalPlots: " .. tostring(info.TotalPlots));
			--print ("BAAAD Minor WestEdge: " .. tostring(info.WestEdge));
			--print ("BAAAD Minor EastEdge: " .. tostring(info.EastEdge));
			--print ("BAAAD Minor NorthEdge: " .. tostring(info.NorthEdge));
			--print ("BAAAD Minor SouthEdge: " .. tostring(info.SouthEdge));
			--print("faILed MINOR");
		end
		
		i = i + 1;
	end

	for k, plot in ipairs(self.minorStartPlots) do
		table.insert(self.minorCopy, plot);
	end

	--Begin Start Bias for minor
	self:__InitStartBias(true);

	for i = 1, self.iNumMinorCivs do
		local player = Players[self.minorList[i]]
		
		if(player == nil) then
			--print("THIS PLAYER FAILED");
		else
			local hasPlot = false;
			for k, v in pairs(self.playerStarts[i + self.iNumMajorCivs]) do
				if(v~= nil and hasPlot == false) then
					hasPlot = true;
					player:SetStartingPlot(v);
					--print("Minor Start X: ", v:GetX(), "Minor Start Y: ", v:GetY());
				end
			end
		end
	end

end