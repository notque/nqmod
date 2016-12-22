-- ===========================================================================
--	View list of slots representing districts that can house great works.
--
--	Original Author: Sam Batista
-- ===========================================================================
include("InstanceManager");
include("PopupDialogSupport")
include( "SupportFunctions" );

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local RELOAD_CACHE_ID:string = "DemosScreen"; -- Must be unique (usually the same as the file name)

local LOC_SCREEN_TITLE:string = "DEMOGRAPHICS";
local LOC_UNKNOWN_CIV:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER");
local LOC_UNKNOWN_CIV_COLORED:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER_COLORED");
local ICON_UNKNOWN_CIV:string = "ICON_CIVILIZATION_UNKNOWN";

local YIELD_FONT_ICONS:table = {
	YIELD_FOOD				= "[ICON_FoodLarge]",
	YIELD_PRODUCTION		= "[ICON_ProductionLarge]",
	YIELD_GOLD				= "[ICON_GoldLarge]",
	YIELD_SCIENCE			= "[ICON_ScienceLarge]",
	YIELD_CULTURE			= "[ICON_CultureLarge]",
	YIELD_FAITH				= "[ICON_FaithLarge]",
	YIELD_TOURISM			= "[ICON_TourismLarge]"
};

local m_isLocalPlayerTurn:boolean = true;

-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================


-- ===========================================================================
--	PLAYER VARIABLES
-- ===========================================================================
local m_LocalPlayer:table;
local m_LocalPlayerID:number;

-- ===========================================================================
--	Called every time screen is shown
-- ===========================================================================
function UpdatePlayerData()
	m_LocalPlayerID = Game.GetLocalPlayer();
	if m_LocalPlayerID ~= -1 then
		m_LocalPlayer = Players[m_LocalPlayerID];
	end
end

-- ===========================================================================
--	Called every time screen is shown
-- ===========================================================================
function DisplayDemos()
	local DemoData :table = {};
	local localPlayerID = Game.GetLocalPlayer();
	local Best :table = {
			Pop = 0,
			PopID = 0,
			Crop = 0,
			CropID = 0,
		  	Prod = 0;
		  	ProdID = 0,
		  	GNP = 0,
		  	GNPID = 0,
		  	Military = 0,
		  	MilitaryID = 0,
		  	Faith = 0,
		  	FaithID = 0,
		  	Tourism = 0,
		  	TourismID = 0,
		  	Happy = -10000,
		  	HappyID = 0,
		  	Culture = 0,
		  	CultureID = 0,
		  	Science = 0,
		  	ScienceID = 0
	};

	local Worst :table = {
			Pop = 10000000000000,
			PopID = 0,
			Crop = 10000,
			CropID = 0,
		  	Prod = 10000;
		  	ProdID = 0,
		  	GNP = 10000,
		  	GNPID = 0,
		  	Military = 10000,
		  	MilitaryID = 0,
		  	Faith = 10000,
		  	FaithID = 0,
		  	Tourism = 10000,
		  	TourismID = 0,
		  	Happy = 10000,
		  	HappyID = 0,
		  	Culture = 10000,
		  	CultureID = 0,
		  	Science = 10000,
		  	ScienceID = 0
	};

	local RankData :table = {
		  	Pop = 1,
		  	Crop = 1,
		  	Prod = 1,
		  	GNP = 1,
		  	Military = 1,
		  	Faith = 1,
		  	Tourism = 1,
		  	Happy = 1,
		  	Culture = 1,
		  	Science = 1
	};

	print("Local Player: " .. localPlayerID);
	
	local players = Game.GetPlayers();

	local players = Game.GetPlayers();
	for i, player in ipairs(players) do
			
		local playerID = player:GetID();
		local playerCities = players[i]:GetCities();
		local playerData :table = {
		  	Pop = 0,
		  	Crop = 0,
		  	Prod = 0,
		  	GNP = 0,
		  	Military = 0,
		  	Faith = 0,
		  	Tourism = 0,
		  	Happy = 60,
		  	Culture = 0,
		  	Science = 0
		};

		 if (player:IsAlive() == true and player:IsMajor() == true) then
			for ii, city in playerCities:Members() do

				local cityID		:number = city:GetID();

				local cityPop		:number = city:GetPopulation();
				local cityProd		:number = Round(city:GetYield(YieldTypes.PRODUCTION),1);
				local cityFaith		:number = Round(city:GetYield(YieldTypes.FAITH), 1);
				local cityGold		:number = Round(city:GetYield(YieldTypes.GOLD), 1);
				local cityFood		:number = Round(city:GetYield(YieldTypes.FOOD), 1);
				local pCityGrowth	:table = city:GetGrowth();

				playerData.Pop = playerData.Pop + math.floor(math.pow((cityPop),2.8))*1000;

				playerData.Crop = playerData.Crop + cityFood;

				playerData.Prod = playerData.Prod + cityProd;

				playerData.Faith = playerData.Faith + cityFaith;

				playerData.GNP = playerData.GNP + cityGold;

				playerData.Happy = playerData.Happy + ((pCityGrowth:GetAmenities() - pCityGrowth:GetAmenitiesNeeded())*3);
				
			end

			if (playerData.Happy > 100) then
				playerData.Happy = 100;
			end

			if (playerData.Happy < 0) then
				playerData.Happy = 0;
			end

			playerData.Tourism = player:GetStats():GetTourism();
			playerData.Military = player:GetStats():GetMilitaryStrength();
			
			playerData.Science = Round((100/68) * player:GetStats():GetNumTechsResearched());
			playerData.Culture = player:GetCategoryScore(0);
			print("Civics: " .. playerData.Culture);

			--check to see if anything is better than the best
			if (playerData.Pop >= Best.Pop) then
				Best.Pop = playerData.Pop;
				Best.PopID = playerID;
			end
			if (playerData.Crop >= Best.Crop) then
				Best.Crop = playerData.Crop;
				Best.CropID = playerID;
			end
			if (playerData.Prod >= Best.Prod) then
				Best.Prod = playerData.Prod;
				Best.ProdID = playerID;
			end
			if (playerData.GNP >= Best.GNP) then
				Best.GNP = playerData.GNP;
				Best.GNPID = playerID;
			end
			if (playerData.Faith >= Best.Faith) then
				Best.Faith = playerData.Faith;
				Best.FaithID = playerID;
			end
			if (playerData.Tourism >= Best.Tourism) then
				Best.Tourism = playerData.Tourism;
				Best.TourismID = playerID;
			end
			if (playerData.Military >= Best.Military) then
				Best.Military = playerData.Military;
				Best.MilitaryID = playerID;
			end
			if (playerData.Happy >= Best.Happy) then
				Best.Happy = playerData.Happy;
				Best.HappyID = playerID;
			end
			if (playerData.Science >= Best.Science) then
				Best.Science = playerData.Science;
				Best.ScienceID = playerID;
			end
			if (playerData.Culture >= Best.Culture) then
				Best.Culture = playerData.Culture;
				Best.CultureID = playerID;
			end

			--check to see if anything is worse than the worst
			if (playerData.Pop < Worst.Pop) then
				Worst.Pop = playerData.Pop;
				Worst.PopID = playerID;
			end
			if (playerData.Crop < Worst.Crop) then
				Worst.Crop = playerData.Crop;
				Worst.CropID = playerID;
			end
			if (playerData.Prod < Worst.Prod) then
				Worst.Prod = playerData.Prod;
				Worst.ProdID = playerID;
			end
			if (playerData.GNP < Worst.GNP) then
				Worst.GNP = playerData.GNP;
				Worst.GNPID = playerID;
			end
			if (playerData.Faith < Worst.Faith) then
				Worst.Faith = playerData.Faith;
				Worst.FaithID = playerID;
			end
			if (playerData.Tourism < Worst.Tourism) then
				Worst.Tourism = playerData.Tourism;
				Worst.TourismID = playerID;
			end
			if (playerData.Military < Worst.Military) then
				Worst.Military = playerData.Military;
				Worst.MilitaryID = playerID;
			end
			if (playerData.Happy < Worst.Happy) then
				Worst.Happy = playerData.Happy;
				Worst.HappyID = playerID;
			end
			if (playerData.Science < Worst.Science) then
				Worst.Science = playerData.Science;
				Worst.ScienceID = playerID;
			end
			if (playerData.Culture < Worst.Culture) then
				Worst.Culture = playerData.Culture;
				Worst.CultureID = playerID;
			end

			DemoData[playerID] = {
				Population = playerData.Pop,
				Crop = playerData.Crop,
				Production = playerData.Prod,
				GNP = playerData.GNP,
				Faith = playerData.Faith,
				Tourism = playerData.Tourism,
				Military = playerData.Military,
				Happy = playerData.Happy,
				Science = playerData.Science,
				Culture = playerData.Culture
			};
		end
	end

	-- set the values for the current player
	Controls.ValuePop:SetText(DemoData[localPlayerID].Population);
	Controls.ValueProd:SetText(DemoData[localPlayerID].Production);
	Controls.ValueFaith:SetText(DemoData[localPlayerID].Faith);
	Controls.ValueGNP:SetText(DemoData[localPlayerID].GNP);
	Controls.ValueTour:SetText(DemoData[localPlayerID].Tourism);
	Controls.ValueCrop:SetText(DemoData[localPlayerID].Crop);
	Controls.ValueArmy:SetText(DemoData[localPlayerID].Military);
	Controls.ValueHappy:SetText(DemoData[localPlayerID].Happy.. "%");
	Controls.ValueTech:SetText(DemoData[localPlayerID].Science.. "%");
	Controls.ValueCivics:SetText(DemoData[localPlayerID].Culture.. "%");

	-- set the details for best demos
	Controls.BestPop:SetText(Best.Pop);
	ColorIcon(Best.PopID, Controls.CivIconBestPop, Controls.CivIconBackingBestPop)

	Controls.BestProd:SetText(Best.Prod);
	ColorIcon(Best.ProdID, Controls.CivIconBestProd, Controls.CivIconBackingBestProd)

	Controls.BestFaith:SetText(Best.Faith);
	ColorIcon(Best.FaithID, Controls.CivIconBestFaith, Controls.CivIconBackingBestFaith)

	Controls.BestGNP:SetText(Best.GNP);
	ColorIcon(Best.GNPID, Controls.CivIconBestGNP, Controls.CivIconBackingBestGNP)

	Controls.BestTour:SetText(Best.Tourism);
	ColorIcon(Best.TourismID, Controls.CivIconBestTour, Controls.CivIconBackingBestTour)

	Controls.BestCrop:SetText(Best.Crop);
	ColorIcon(Best.CropID, Controls.CivIconBestCrop, Controls.CivIconBackingBestCrop)

	Controls.BestArmy:SetText(Best.Military);
	ColorIcon(Best.MilitaryID, Controls.CivIconBestArmy, Controls.CivIconBackingBestArmy)

	Controls.BestHappy:SetText(Best.Happy.. "%");
	ColorIcon(Best.HappyID, Controls.CivIconBestHappy, Controls.CivIconBackingBestHappy)
	
	Controls.BestTech:SetText(Best.Science.. "%");
	ColorIcon(Best.ScienceID, Controls.CivIconBestTech, Controls.CivIconBackingBestTech)
	
	Controls.BestCivics:SetText(Best.Culture.. "%");
	ColorIcon(Best.CultureID, Controls.CivIconBestCivics, Controls.CivIconBackingBestCivics)

	-- set the details for worse demos
	Controls.WorstPop:SetText(Worst.Pop);
	ColorIcon(Worst.PopID, Controls.CivIconWorstPop, Controls.CivIconBackingWorstPop)

	Controls.WorstProd:SetText(Worst.Prod);
	ColorIcon(Worst.ProdID, Controls.CivIconWorstProd, Controls.CivIconBackingWorstProd)

	Controls.WorstFaith:SetText(Worst.Faith);
	ColorIcon(Worst.FaithID, Controls.CivIconWorstFaith, Controls.CivIconBackingWorstFaith)

	Controls.WorstGNP:SetText(Worst.GNP);
	ColorIcon(Worst.GNPID, Controls.CivIconWorstGNP, Controls.CivIconBackingWorstGNP)

	Controls.WorstTour:SetText(Worst.Tourism);
	ColorIcon(Worst.TourismID, Controls.CivIconWorstTour, Controls.CivIconBackingWorstTour)

	Controls.WorstCrop:SetText(Worst.Crop);
	ColorIcon(Worst.CropID, Controls.CivIconWorstCrop, Controls.CivIconBackingWorstCrop)

	Controls.WorstArmy:SetText(Worst.Military);
	ColorIcon(Worst.MilitaryID, Controls.CivIconWorstArmy, Controls.CivIconBackingWorstArmy)

	Controls.WorstHappy:SetText(Worst.Happy.. "%");
	ColorIcon(Worst.HappyID, Controls.CivIconWorstHappy, Controls.CivIconBackingWorstHappy)

	Controls.WorstTech:SetText(Worst.Science.. "%");
	ColorIcon(Worst.ScienceID, Controls.CivIconWorstTech, Controls.CivIconBackingWorstTech)

	Controls.WorstCivics:SetText(Worst.Culture.. "%");
	ColorIcon(Worst.CultureID, Controls.CivIconWorstCivics, Controls.CivIconBackingWorstCivics)

	local AvgData :table = {
	  	Pop = 0,
	  	Crop = 0,
	  	Prod = 0,
	  	GNP = 0,
	  	Military = 0,
	  	Faith = 0,
	  	Tourism = 0,
	  	Happy = 0,
	  	Culture = 0,
	  	Science = 0
	};

	local playerCount = 0;

	-- set the ranks
	for i, player in ipairs(players) do
		if (player:IsAlive() == true and player:IsMajor() == true) then
			local playerID = player:GetID();
			print("Rank: PlayerID: " .. playerID);
			print("Rank: Local PlayerID: " .. localPlayerID);
		
			if (playerID ~= localPlayerID) then
				if DemoData[playerID].Population >= DemoData[localPlayerID].Population then
					RankData.Pop = RankData.Pop + 1;
				end

				if DemoData[playerID].Production >= DemoData[localPlayerID].Production then
					RankData.Prod = RankData.Prod + 1;
				end

				if DemoData[playerID].GNP >= DemoData[localPlayerID].GNP then
					RankData.GNP = RankData.GNP + 1;
				end

				if DemoData[playerID].Faith >= DemoData[localPlayerID].Faith then
					RankData.Faith = RankData.Faith + 1;
				end

				if DemoData[playerID].Tourism >= DemoData[localPlayerID].Tourism then
					RankData.Tourism = RankData.Tourism + 1;
				end

				if DemoData[playerID].Crop >= DemoData[localPlayerID].Crop then
					RankData.Crop = RankData.Crop + 1;
				end

				if DemoData[playerID].Military >= DemoData[localPlayerID].Military then
					RankData.Military = RankData.Military + 1;
				end

				if DemoData[playerID].Happy >= DemoData[localPlayerID].Happy then
					RankData.Happy = RankData.Happy + 1;
				end

				if DemoData[playerID].Science >= DemoData[localPlayerID].Science then
					RankData.Science = RankData.Science + 1;
				end

				if DemoData[playerID].Culture >= DemoData[localPlayerID].Culture then
					RankData.Culture = RankData.Culture + 1;
				end
			end

			AvgData.Pop = AvgData.Pop + DemoData[playerID].Population;
			AvgData.Crop = AvgData.Crop + DemoData[playerID].Crop;
			AvgData.Prod = AvgData.Prod + DemoData[playerID].Production;
			AvgData.GNP = AvgData.GNP + DemoData[playerID].GNP;
			AvgData.Military = AvgData.Military + DemoData[playerID].Military;
			AvgData.Faith = AvgData.Faith + DemoData[playerID].Faith;
			AvgData.Tourism = AvgData.Tourism + DemoData[playerID].Tourism;
			AvgData.Happy = AvgData.Happy + DemoData[playerID].Happy;
			AvgData.Culture = AvgData.Culture + DemoData[playerID].Culture;
			AvgData.Science = AvgData.Science + DemoData[playerID].Science;

			playerCount = playerCount +1
		end
	end

	print("Count is: " .. playerCount);
	-- set the averages
	local AvgHappy = "";

	Controls.AvgPop:SetText(Round((AvgData.Pop/playerCount),0));
	Controls.AvgProd:SetText(Round((AvgData.Prod/playerCount),1));
	Controls.AvgGNP:SetText(Round((AvgData.GNP/playerCount),1));
	Controls.AvgFaith:SetText(Round((AvgData.Faith/playerCount),1));
	Controls.AvgTour:SetText(Round((AvgData.Tourism/playerCount),1));
	Controls.AvgCrop:SetText(Round((AvgData.Crop/playerCount),1));
	Controls.AvgArmy:SetText(Round((AvgData.Military/playerCount),0));
	Controls.AvgHappy:SetText(Round((AvgData.Happy/playerCount),0) .. "%");
	Controls.AvgTech:SetText(Round((AvgData.Science/playerCount),0) .. "%");
	Controls.AvgCivics:SetText(Round((AvgData.Culture/playerCount),0) .. "%");

	-- set the local players ranks
	Controls.RankPop:SetText(RankData.Pop);
	Controls.RankProd:SetText(RankData.Prod);
	Controls.RankGNP:SetText(RankData.GNP);
	Controls.RankFaith:SetText(RankData.Faith);
	Controls.RankTour:SetText(RankData.Tourism);
	Controls.RankCrop:SetText(RankData.Crop);
	Controls.RankArmy:SetText(RankData.Military);
	Controls.RankHappy:SetText(RankData.Happy);
	Controls.RankTech:SetText(RankData.Science);
	Controls.RankCivics:SetText(RankData.Culture);
end

-- ===========================================================================
function GetCivNameAndIcon(playerID:number, bColorUnmetPlayer:boolean)
	local name:string, icon:string;
	local m_LocalPlayer = Players[Game.GetLocalPlayer()]
	local m_LocalPlayerID = Game.GetLocalPlayer();

	local playerConfig:table = PlayerConfigurations[playerID];
	
	if(playerID == m_LocalPlayerID or playerConfig:IsHuman() or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		name = Locale.Lookup(playerConfig:GetPlayerName());
		
		if playerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			icon = "ICON_" .. playerConfig:GetCivilizationTypeName();
		else
			icon = ICON_UNKNOWN_CIV;
		end
	else
		print("Unmet civ");
		name = bColorUnmetPlayer and LOC_UNKNOWN_CIV_COLORED or LOC_UNKNOWN_CIV;
		icon = ICON_UNKNOWN_CIV;
	end
	return name, icon;
end

function ColorIcon(PlayerID, cControlIcon, cControlBacking)
	print(PlayerID, cControlIcon, cControlBacking);
	local civName:string, civIcon:string = GetCivNameAndIcon(PlayerID, true);
	print("CivName=".. civName);
	print("CivIcon=".. civIcon);

	if (civIcon == "ICON_CIVILIZATION_UNKNOWN") then
		print("Unmet civ x");
		cControlBacking:SetColor(0xFF9E9382);
		cControlIcon:SetColor(0xFFFFFFFF);
		local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, 36);
		cControlIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	else
		
		local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(civIcon, 36);
		local backColor, frontColor = UI.GetPlayerColors(PlayerID);
		cControlIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
		cControlIcon:SetColor(frontColor);
		cControlBacking:SetColor(backColor);
	end
end
-- ===========================================================================
--	Show / Hide
-- ===========================================================================
function Open()
	print("Demos Beging Opening");
	DisplayDemos()

	if (ContextPtr:IsHidden()) then
		ContextPtr:SetHide(false);

		-- From Civ6_styles: FullScreenVignetteConsumer
		Controls.ScreenAnimIn:SetToBeginning();
		Controls.ScreenAnimIn:Play();
	else
		ContextPtr:SetHide(true);
	end
end

function Close()
	ContextPtr:SetHide(true);
end

-- ===========================================================================
--	Game Event Callbacks
-- ===========================================================================
function OnShowScreen()
	Open();
	UI.PlaySound("UI_Screen_Open");
end

-- ===========================================================================
function OnHideScreen()
	Close();
	UI.PlaySound("UI_Screen_Close");
end

-- ===========================================================================
function OnInputHandler(pInputStruct:table)
	local uiMsg = pInputStruct:GetMessageType();

	if uiMsg == KeyEvents.KeyUp then 
		local uiKey = pInputStruct:GetKey();
		if uiKey == Keys.VK_ESCAPE then
			if ContextPtr:IsHidden()==false then
				Close();
				return true;
			end
		end		
	end
	return false;
end
-- ===========================================================================

-- ===========================================================================
--	Hot Reload Related Events
-- ===========================================================================
function OnInit(isReload:boolean)
	if isReload then
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);
	end
end

function OnShutdown()
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden", ContextPtr:IsHidden());
end
function OnGameDebugReturn(context:string, contextTable:table)
	if context == RELOAD_CACHE_ID and contextTable["isHidden"] ~= nil and not contextTable["isHidden"] then
		Open();
	end
end

-- ===========================================================================
--	Input Hotkey Event
-- ===========================================================================
function OnInputActionTriggered( actionId )

end

-- ===========================================================================
--	Player Turn Events
-- ===========================================================================
function OnLocalPlayerTurnBegin()
	m_isLocalPlayerTurn = true;
end
function OnLocalPlayerTurnEnd()
	m_isLocalPlayerTurn = false;
	if(GameConfiguration.IsHotseat()) then
		OnHideScreen();
	end
end

-- ===========================================================================
--	INIT
-- ===========================================================================
function Initialize()
	
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetShutdown(OnShutdown);
	ContextPtr:SetInputHandler(OnInputHandler, true);

	-- Events
	LuaEvents.TopPanel_OpenDemosScreen.Add( Open );
	LuaEvents.TopPanel_CloseDemosScreen.Add( Close );

	Controls.ModalScreenTitle:SetText(Locale.ToUpper(LOC_SCREEN_TITLE));
	Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, OnHideScreen);
	Controls.ModalScreenClose:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin);
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);

end
Initialize();
