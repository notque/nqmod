-- ===========================================================================
--	Contains scaffolding for WorldRankings and other Right Anchored screens
-- ===========================================================================
include("TabSupport");
include("InstanceManager");
include("SupportFunctions");
include("AnimSidePanelSupport");

-- ===========================================================================
--	DEBUG
-- ===========================================================================
local m_isDebugForceShowAllScoreCategories :boolean = false;		-- (false) Show all scoring categories under details

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================
local RELOAD_CACHE_ID:string = "NotificationLog"; -- Must be unique (usually the same as the file name)
local REQUIREMENT_CONTEXT:string = "VictoryProgress";
local DATA_FIELD_SELECTION:string = "Selection";
local DATA_FIELD_LEADER_TOOLTIP:string = "LeaderTooltip";
local DATA_FIELD_HEADER_HEIGHT:string = "HeaderHeight";
local DATA_FIELD_HEADER_RESIZED:string = "HeaderResized";
local DATA_FIELD_HEADER_EXPANDED:string = "HeaderExpanded";
local DATA_FIELD_OVERALL_PLAYERS_IM:string = "OverallPlayersIM";
local DATA_FIELD_DOMINATED_CITIES_IM:string = "DominatedCitiesIM";
local DATA_FIELD_RELIGION_CONVERTED_CIVS_IM:string = "ConvertedCivsIM";

local PADDING_HEADER:number = 10;
local PADDING_CULTURE_HEADER:number = 90;
local PADDING_GENERIC_ITEM_BG:number = 25;
local PADDING_TAB_BUTTON_TEXT:number = 17;
local PADDING_EXTRA_TAB_BG:number = 10;
local PADDING_EXTRA_TAB_SHADOW:number = 23;
local PADDING_ADVISOR_TEXT_BG:number = 20;
local PADDING_RELIGION_NAME_BG:number = 42;
local PADDING_RELIGION_BG_HEIGHT:number = 26;
local PADDING_VICTORY_GRADIENT:number = 45;
local PADDING_NEXT_STEP_HIGHLIGHT:number = 4;
local PADDING_VICTORY_LABEL_UNDERLINE:number = 90;
local PADDING_SCORE_DETAILS_BUTTON_WIDTH:number = 40;
local OFFSET_VIEW_CONTENTS:number = 130;
local OFFSET_ADVISOR_ICON_Y:number = 5;
local OFFSET_ADVISOR_TEXT_Y:number = 70;
local OFFSET_HIDDEN_SCROLLBAR:number = 0;
local OFFSET_CONTRACT_BUTTON_Y:number = 63;
local OFFSET_SCIENCE_REQUIREMENTS_Y:number = 80;
local SIZE_OVERALL_TOP_PLAYER_ICON:number = 48;
local SIZE_OVERALL_PLAYER_ICON:number = 36;
local SIZE_OVERALL_BG_HEIGHT:number = 100;
local SIZE_OVERALL_INSTANCE:number = 40;
local SIZE_VICTORY_ICON_SMALL:number = 64;
local SIZE_RELIGION_BG_HEIGHT:number = 55;
local SIZE_RELIGION_ICON_SMALL:number = 22;
local SIZE_RELIGION_CIV_ICON:number = 30;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local SIZE_SCORE_ITEM_DEFAULT:number = 54;
local SIZE_SCORE_ITEM_DETAILS:number = 180;
local SIZE_STACK_DEFAULT:number = 225;
local SIZE_HEADER_DEFAULT:number = 60;
local SIZE_HEADER_MIN_Y:number = 46;
local SIZE_HEADER_MAX_Y:number = 270;
local SIZE_HEADER_ICON:number = 80;
local SIZE_LEADER_ICON:number = 55;
local SIZE_CIV_ICON:number = 36;

local TAB_SCORE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_TAB");
local TAB_OVERALL:string = Locale.Lookup("LOC_WORLD_RANKINGS_OVERALL_TAB");
local TAB_SCIENCE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_TAB");
local TAB_CULTURE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TAB");
local TAB_RELIGION:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_TAB");
local TAB_DOMINATION:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_TAB");

local SCORE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_VICTORY");
local SCORE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCORE_DETAILS");

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3")
};

local CULTURE_ICON:string = "ICON_VICTORY_CULTURE";
local CULTURE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY");
local CULTURE_VICTORY_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_VICTORY_DETAILS");
local CULTURE_DOMESTIC_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_DOMESTIC_TOURISTS");
local CULTURE_VISITING_TOURISTS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_DETAILS_VISITING_TOURISTS");

local DOMINATION_ICON:string = "ICON_VICTORY_DOMINATION";
local DOMINATION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_VICTORY");
local DOMINATION_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_DETAILS");
local DOMINATION_HAS_ORIGINAL_CAPITAL:string = Locale.Lookup("LOC_WORLD_RANKINGS_DOMINATION_HAS_ORIGINAL_CAPITAL");

local RELIGION_ICON:string = "ICON_VICTORY_RELIGIOUS";
local RELIGION_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_VICTORY");
local RELIGION_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_RELIGION_DETAILS");

local ICON_GENERIC:string = "ICON_VICTORY_GENERIC";
local ICON_UNKNOWN_CIV:string = "ICON_CIVILIZATION_UNKNOWN";
local LOC_UNKNOWN_CIV:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER");
local LOC_UNKNOWN_CIV_COLORED:string = Locale.Lookup("LOC_WORLD_RANKING_UNMET_PLAYER_COLORED");

local UNKNOWN_COLOR:number = RGBAValuesToABGRHex(1, 1, 1, 1);

--antonjs: Removed the other state and related text, in favor of showing all information together. Leaving state functionality intact in case we want to use it in the future.
--[[
local CULTURE_HOW_TO_VICTORY:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_VICTORY");
local CULTURE_HOW_TO_TOURISM:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_HOW_TO_TOURISM");
local CULTURE_TOURISM_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CULTURE_TOURISM_DETAILS");
--]]
local CULTURE_HEADER_STATES:table = {
	WHAT_IS_CULTURE_VICTORY	= 0;
};

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_PROJECT_INFOS:table = { 
	GameInfo.Projects["PROJECT_LAUNCH_MARS_REACTOR"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HABITATION"],
	GameInfo.Projects["PROJECT_LAUNCH_MARS_HYDROPONICS"]
};
local SCIENCE_PROJECTS:table = {
	EARTH_SATELLITE_PROJECT_INFOS,
	MOON_LANDING_PROJECT_INFOS,
	MARS_COLONY_PROJECT_INFOS
};

local STANDARD_VICTORY_TYPES:table = {
	"VICTORY_DEFAULT",
	"VICTORY_SCORE",
	"VICTORY_TECHNOLOGY",
	"VICTORY_CULTURE",
	"VICTORY_CONQUEST",
	"VICTORY_RELIGIOUS"
};

function IsCustomVictoryType(victoryType:string)
	for _, checkVictoryType in ipairs(STANDARD_VICTORY_TYPES) do
		if victoryType == checkVictoryType then
			return false;
		end
	end
	return true;
end

-- ===========================================================================
--	PLAYER VARIABLES
-- ===========================================================================
local m_LocalPlayer:table;
local m_LocalPlayerID:number;
-- ===========================================================================
--	SCREEN VARIABLES
-- ===========================================================================
local m_TabSupport:table; -- TabSupport
local m_AnimSupport:table; --AnimSidePanelSupport
local m_ActiveHeader:table;
local m_TotalTabSize:number = 0;
local m_MaxExtraTabSize:number = 0;
local m_ExtraTabs:table = {};
local m_HeaderInstances:table = {};
local m_ActiveViewUpdate:ifunction;
local m_ShowScoreDetails:boolean = false;
local m_CultureHeaderState:number = CULTURE_HEADER_STATES.WHAT_IS_CULTURE_VICTORY;
local m_TabSupportIM:table = InstanceManager:new("TabInstance", "Button", Controls.TabContainer);
local m_GenericHeaderIM:table = InstanceManager:new("GenericHeaderInstance", "HeaderTop"); -- Used by Score, Religion and Domination Views
local m_ScienceHeaderIM:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);
local m_CultureHeaderIM:table = InstanceManager:new("CultureHeaderInstance", "HeaderTop", Controls.CultureViewHeader);
local m_OverallIM:table = InstanceManager:new("OverallInstance", "ButtonBG", Controls.OverallViewStack);
local m_ScoreIM:table = InstanceManager:new("ScoreInstance", "ButtonBG", Controls.ScoreViewStack);
local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_CultureIM:table = InstanceManager:new("CultureInstance", "ButtonBG", Controls.CultureViewStack);
local m_DominationIM:table = InstanceManager:new("DominationInstance", "ButtonBG", Controls.DominationViewStack);
local m_ReligionIM:table = InstanceManager:new("ReligionInstance", "ButtonBG", Controls.ReligionViewStack);
local m_GenericIM:table = InstanceManager:new("GenericInstance", "ButtonBG", Controls.GenericViewStack);
local m_ExtraTabsIM:table = InstanceManager:new("ExtraTab", "Button", Controls.ExtraTabStack);

local m_CivTooltip = {};
TTManager:GetTypeControlTable("CivTooltip", m_CivTooltip);

local MessageLog :table = nil;
local TotalMessages = 0;
local bShowing :boolean = false;

-- ===========================================================================
--	Called once during Init
-- ===========================================================================
function OnAddMessage(str:string, fDisplayTime:number, type:number)
	-- function will run when new status messages are sent

	-- type 101 = wonder completed
	-- type 102 = natral wonder discovered
	print(ReportingStatusTypes.GOSSIP )
	if (type == ReportingStatusTypes.GOSSIP or type == 101 or type == 102) then
		local mMessage :table = {
		Turn 	= tostring(Game.GetCurrentGameTurn()),
		MsgStr 	= str,
		nType = type
		};
		if (MessageLog == nil) then
			MessageLog = {};
		end
		MessageLog[TotalMessages] = mMessage;
		print("=========================================================");
		print("Turn: " .. MessageLog[TotalMessages].Turn);
		print("Message: " .. MessageLog[TotalMessages].MsgStr);
		print("Message Type: " .. MessageLog[TotalMessages].nType);
		print("=========================================================");
		TotalMessages = TotalMessages + 1;
		LuaEvents.NewNoteLogMsg(true);
		UI.PlaySound("UI_Notification_Bar_Notch");
	end

	print("Showing: " .. tostring(bShowing));
	if (bShowing) then
		ShowMessages();
	end
end

-- ===========================================================================
function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	--m_ExtraTabsIM:ResetInstances();
	--m_TabSupportIM:ResetInstances();
	
	-- Deselect previously selected tab
	if(m_TabSupport ~= nil) then
		m_TabSupport.SelectTab(nil);
		if(m_TabSupport.prevSelectedControl ~= nil) then
			m_TabSupport.prevSelectedControl[DATA_FIELD_SELECTION]:SetHide(false);
		end
	end

	-- Create TabSupport object
	m_TabSupport = CreateTabs(Controls.TabContainer, 42, 34, 0xFF331D05);

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);
	
	m_TabSupport.SelectTab(defaultTab);
	m_TabSupport.EvenlySpreadTabs();
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = m_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > Controls.TabContainer:GetSizeX() then
		m_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else

		local callback = function()
			if(m_TabSupport.prevSelectedControl ~= nil) then
				m_TabSupport.prevSelectedControl[DATA_FIELD_SELECTION]:SetHide(false);
			end
			tabInst.Selection:SetHide(false);
			onClickCallback();
			--CloseExtraTabs();
		end

		m_TabSupport.AddTab(tabInst.Button, callback);
	end

	return tabInst.Button;
end

function AddExtraTab(label:string, onClickCallback:ifunction)
	local extraTabInst:table = m_ExtraTabsIM:GetInstance();
	extraTabInst.Button:SetText(label);

	local callback = function()
		if(m_TabSupport.selectedControl ~= nil) then
			m_TabSupport.selectedControl[DATA_FIELD_SELECTION]:SetHide(false);
			m_TabSupport.SetSelectedTabVisually(nil);
		end
		for _,tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSelected(tabInst == extraTabInst);
		end
		onClickCallback();
	end

	extraTabInst.Button:RegisterCallback(Mouse.eLClick, callback);

	local textControl = extraTabInst.Button:GetTextControl();
	local textSize:number = textControl:GetSizeX();
	extraTabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	extraTabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	local tabSize:number = extraTabInst.Button:GetSizeX();
	if tabSize > m_MaxExtraTabSize then
		m_MaxExtraTabSize = tabSize;
	end

	table.insert(m_ExtraTabs, extraTabInst);
end

-- ===========================================================================
--	Called anytime player switches tabs
-- ===========================================================================
function ResetState(newView:ifunction)
	m_ActiveHeader = nil;
	m_ActiveViewUpdate = newView;
	Controls.OverallView:SetHide(true);
	Controls.ScoreView:SetHide(true);
	Controls.ScienceView:SetHide(true);
	Controls.CultureView:SetHide(true);
	Controls.DominationView:SetHide(true);
	Controls.ReligionView:SetHide(true);
	Controls.GenericView:SetHide(true);

	-- Reset tourism lens unless we're now view the Culture tab
	if newView ~= ViewCulture then
		ResetTourismLens();
	end
end

function ChangeActiveHeader(headerType:string, headerIM:table, parentControl:table)
	m_ActiveHeader = m_HeaderInstances[headerType];
	if(m_ActiveHeader == nil) then
		m_ActiveHeader = headerIM:GetInstance(parentControl);
		m_HeaderInstances[headerType] = m_ActiveHeader;
	end
end

function GetCivNameAndIcon(playerID:number, bColorUnmetPlayer:boolean)
	local name:string, icon:string;
	local playerConfig:table = PlayerConfigurations[playerID];
	if(playerID == m_LocalPlayerID or playerConfig:IsHuman() or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		name = Locale.Lookup(playerConfig:GetPlayerName());
		if playerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID) then
			icon = "ICON_" .. playerConfig:GetCivilizationTypeName();
		else
			icon = ICON_UNKNOWN_CIV;
		end
	else
		name = bColorUnmetPlayer and LOC_UNKNOWN_CIV_COLORED or LOC_UNKNOWN_CIV;
		icon = ICON_UNKNOWN_CIV;
	end
	return name, icon;
end

function ColorCivIcon(instance:table, playerID:number)
	if(playerID == m_LocalPlayerID or m_LocalPlayer == nil or m_LocalPlayer:GetDiplomacy():HasMet(playerID)) then
		local backColor, frontColor = UI.GetPlayerColors(playerID);
		local darkerBackColor = DarkenLightenColor(backColor,(-55),230);
		local brighterBackColor = DarkenLightenColor(backColor,80,255);
		instance.CivIcon:SetColor(frontColor);
		if(instance.CivIconBacking ~= nil) then
			instance.CivIconBacking:SetColor(backColor);
		else
			instance.CivBacking_Base:SetColor(backColor);
			instance.CivBacking_Lighter:SetColor(brighterBackColor);
			instance.CivBacking_Darker:SetColor(darkerBackColor);
		end
	else
		instance.CivIcon:SetColor(UNKNOWN_COLOR);
		if(instance.CivIconBacking ~= nil) then
			instance.CivIconBacking:SetColor(UNKNOWN_COLOR);
		else
			instance.CivBacking_Base:SetColor(backColor);
			instance.CivBacking_Lighter:SetColor(brighterBackColor);
			instance.CivBacking_Darker:SetColor(darkerBackColor);
		end
	end
end

-- ===========================================================================
--	Called to update a generic header instance
-- ===========================================================================
function PopulateGenericHeader(resizeCallback:ifunction, title:string, subTitle:string, details:string, headerIcon:string, advisorIcon:string)
	
	local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(headerIcon, SIZE_HEADER_ICON);
	if(textureSheet == nil or textureSheet == "") then
		UI.DataError("Could not find icon in PopulateGenericHeader: icon=\""..headerIcon.."\", iconSize="..tostring(SIZE_HEADER_ICON));
	else
		m_ActiveHeader.HeaderIcon:SetTexture(textureOffsetX, textureOffsetY, textureSheet);
	end

	m_ActiveHeader.HeaderLabel:SetText(Locale.ToUpper(Locale.Lookup(title)));
	if(subTitle ~= nil and subTitle ~= "") then
		m_ActiveHeader.HeaderSubLabel:SetHide(false);
		m_ActiveHeader.HeaderSubLabel:SetText(Locale.Lookup(subTitle));
	else
		m_ActiveHeader.HeaderSubLabel:SetHide(true);
	end

	m_ActiveHeader.AdvisorText:SetText(details and Locale.Lookup(details) or "");
	
	m_ActiveHeader.ExpandHeaderButton:RegisterCallback(Mouse.eLClick, OnExpandHeader);
	m_ActiveHeader.ContractHeaderButton:RegisterCallback(Mouse.eLClick, OnContractHeader);
	
	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] == nil) then 
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = true;
	end

	m_ActiveHeader[DATA_FIELD_HEADER_RESIZED] = resizeCallback;
	RealizeHeaderSize();
end

-- ===========================================================================
--	Called anytime player presses expand/contract button on a Header Instance 
-- ===========================================================================
function OnExpandHeader(data1:number, data2:number, control:table)
	if(control == m_ActiveHeader.ExpandHeaderButton) then
		m_ActiveHeader.AdvisorIcon:SetHide(false);
		m_ActiveHeader.AdvisorText:SetHide(false);
		m_ActiveHeader.AdvisorTextBG:SetHide(false);
		m_ActiveHeader.ExpandHeaderButton:SetHide(true);
		m_ActiveHeader.ContractHeaderButton:SetHide(false);
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = true;
		RealizeHeaderSize();
	end
end
function OnContractHeader(data1:number, data2:number, control:table)
	if(control == m_ActiveHeader.ContractHeaderButton) then
		m_ActiveHeader.AdvisorIcon:SetHide(true);
		m_ActiveHeader.AdvisorText:SetHide(true);
		m_ActiveHeader.AdvisorTextBG:SetHide(true);
		m_ActiveHeader.ExpandHeaderButton:SetHide(false);
		m_ActiveHeader.ContractHeaderButton:SetHide(true);
		m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = false;
		RealizeHeaderSize();
	end
end

-- ===========================================================================
--	Called anytime header changes size (when it's expanded / contracted)
-- ===========================================================================
function RealizeHeaderSize()
	if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
		local textBubbleHeight:number = m_ActiveHeader.AdvisorText:GetSizeY() + PADDING_ADVISOR_TEXT_BG;
		if(textBubbleHeight > SIZE_HEADER_MAX_Y) then
			textBubbleHeight = SIZE_HEADER_MAX_Y;
		elseif textBubbleHeight < SIZE_HEADER_MIN_Y then
			textBubbleHeight = SIZE_HEADER_MIN_Y;
		end
		m_ActiveHeader.AdvisorTextBG:SetSizeY(textBubbleHeight);
		m_ActiveHeader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + textBubbleHeight);
		m_ActiveHeader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + textBubbleHeight);
		m_ActiveHeader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + textBubbleHeight);
		m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT] = textBubbleHeight;
	else
		m_ActiveHeader.HeaderFrame:SetSizeY(SIZE_HEADER_DEFAULT);
		m_ActiveHeader[DATA_FIELD_HEADER_HEIGHT] = SIZE_HEADER_DEFAULT;
	end
	-- Center header label if sub label is not present
	if(m_ActiveHeader.HeaderSubLabel:IsHidden()) then
		m_ActiveHeader.HeaderLabel:SetOffsetY(25);
	else
		m_ActiveHeader.HeaderLabel:SetOffsetY(18);
	end
	if(m_ActiveHeader[DATA_FIELD_HEADER_RESIZED] ~= nil) then
		m_ActiveHeader[DATA_FIELD_HEADER_RESIZED]();
	end
end

-- ===========================================================================
--	Utility to reduce code duplication
-- ===========================================================================
function RealizeStackAndScrollbar(stackControl:table, scrollbarControl:table, offsetStackIfScrollbarHidden:boolean)
	stackControl:CalculateSize();
	stackControl:ReprocessAnchoring();
	scrollbarControl:CalculateInternalSize();
	scrollbarControl:ReprocessAnchoring();
	scrollbarControl:SetScrollValue(scrollbarControl:GetSizeY());
	if(offsetStackIfScrollbarHidden ~= nil) then
		if(scrollbarControl:GetScrollBar():IsHidden()) then
			stackControl:SetOffsetX(OFFSET_HIDDEN_SCROLLBAR);
		else
			stackControl:SetOffsetX(-4);
		end
	end
end

-- ===========================================================================
--	Called when Overall tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewOverall() -- used by HB
	m_ActiveHeader = nil;
	m_ActiveViewUpdate = newView;
	Controls.OverallView:SetHide(true);
	Controls.ScoreView:SetHide(true);
	Controls.ScienceView:SetHide(true);
	Controls.CultureView:SetHide(true);
	Controls.DominationView:SetHide(true);
	Controls.ReligionView:SetHide(true);
	Controls.GenericView:SetHide(true);
	Controls.OverallView:SetHide(false);

	m_OverallIM:ResetInstances();
	--m_OverallIM:GetInstance()
end

-- ===========================================================================
--	Update player data and refresh the display state
-- ===========================================================================
function UpdatePlayerData()
	if (Game.GetLocalPlayer() ~= -1) then
		m_LocalPlayer = Players[Game.GetLocalPlayer()];
		m_LocalPlayerID = m_LocalPlayer:GetID();
	else
		m_LocalPlayer = nil;
		m_LocalPlayerID = -1;
	end
end
function UpdateData()
	UpdatePlayerData();
	if(m_LocalPlayer ~= nil and m_ActiveViewUpdate ~= nil) then
		m_ActiveViewUpdate();
	end
end
-- ===========================================================================
function ShowMessages()
	print("Updating Log");
	m_OverallIM:ResetInstances();

	if (MessageLog == nil) then
		local pInstance:table = m_OverallIM:GetInstance();
		pInstance.ButtonBG:SetSizeY(90);
		pInstance.ButtonBG:SetSizeX(470);
		pInstance.ButtonBG:SetOffsetX(7);
		pInstance.TurnLabel:SetText("TURN 0");	
		pInstance.MsgLabel:SetText(Locale.ToUpper("You Have Not Yet Received Any Notifications! The Notifications Button Will Turn Green Once You Have New UNREAD Messages."));
	end

	for i = 0, #MessageLog do
		local pInstance:table = m_OverallIM:GetInstance();
		pInstance.ButtonBG:SetSizeY(90);
		pInstance.ButtonBG:SetSizeX(470);
		pInstance.ButtonBG:SetOffsetX(7);
		pInstance.TurnLabel:SetText("TURN " .. MessageLog[i].Turn);	
		pInstance.MsgLabel:SetText(Locale.ToUpper(MessageLog[i].MsgStr));
		if (MessageLog[i].nType == 101) then
			pInstance.ButtonBG:SetColor(0xFFFFB18B);
		end
		if (MessageLog[i].nType == 102) then
			pInstance.ButtonBG:SetColor(0xFF7F7F7F);
		end
	end

	Controls.OverallViewStack:CalculateSize();
	Controls.OverallViewStack:ReprocessAnchoring();

	RealizeStackAndScrollbar(Controls.OverallViewStack, Controls.OverallViewScrollbar, true);

	LuaEvents.NewNoteLogMsg(false);
end
-- ===========================================================================
--	SCREEN EVENTS
-- ===========================================================================
function Open()
	
	if (bShowing) then
		print("Closing Log");
		Close();	
	else
		print("Setting Open To True");
		bShowing = true;
		--UpdateData();
		m_AnimSupport.Show();
		UI.PlaySound("CityStates_Panel_Open");
		-- Ensure we're the only partial screen currenly up
		LuaEvents.WorldRankings_CloseCityStates();
		ShowMessages();
	end
end

-- ===========================================================================
function Close()	
	bShowing = false;
	m_AnimSupport.Hide();
    if not ContextPtr:IsHidden() then
        UI.PlaySound("CityStates_Panel_Close");
    end
	LuaEvents.WorldRankings_Close();
end

-- ===========================================================================
function Toggle()	
	if(m_AnimSupport.IsVisible()) then
		Close();
	else
		Open();
	end
end

-- ===========================================================================
--	HOT-RELOADING EVENTS
-- ===========================================================================
function OnInit(isReload:boolean)
	if isReload then
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);
	end
end
function OnShutdown()
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden", ContextPtr:IsHidden());
	if(m_TabSupport ~= nil and m_TabSupport.selectedControl ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "selectedTabText", m_TabSupport.selectedControl:GetTextControl():GetText());
	end
	if(m_ActiveHeader ~= nil) then
		LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "activeHeaderExpanded", m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]);
	end
end
function OnGameDebugReturn(context:string, contextTable:table)
	if context == RELOAD_CACHE_ID and contextTable["isHidden"] ~= nil and not contextTable["isHidden"] then
		Open();
		-- Select previously selected tab
		local selectedTabText:string = contextTable["selectedTabText"];
		for _, tab in pairs(m_TabSupport.tabControls) do
			if tab:GetTextControl():GetText() == selectedTabText then
				m_TabSupport.SelectTab(tab);
			end
		end

		if(m_ActiveHeader ~= nil) then
			m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED] = contextTable["activeHeaderExpanded"];
			if(m_ActiveHeader[DATA_FIELD_HEADER_EXPANDED]) then
				OnExpandHeader(0, 0, m_ActiveHeader.ExpandHeaderButton);
			else
				OnContractHeader(0, 0, m_ActiveHeader.ContractHeaderButton);
			end
		end
	end
end

-- ===========================================================================
--	Hot-seat functionality
-- ===========================================================================
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
--	Game Events
-- ===========================================================================
function OnCapitalCityChanged()
	if(m_AnimSupport.IsVisible()) then
		m_AnimSupport.Hide();
	end
end

-- ===========================================================================
--	Game Engine Event
-- ===========================================================================
function OnInterfaceModeChanged(eOldMode:number, eNewMode:number)
	if m_AnimSupport.IsVisible() and eNewMode == InterfaceModeTypes.VIEW_MODAL_LENS then
		Close();
	end
end

-- ===========================================================================
--	LUA Event
--	Explicit close (from partial screen hooks), part of closing everything,
-- ===========================================================================
function OnCloseAllExcept( contextToStayOpen:string )
	if contextToStayOpen == ContextPtr:GetID() then return; end
	Close();
end

-- ===========================================================================
--	INIT (Generic)
-- ===========================================================================
function Initialize()

	-- Animation Controller
	m_AnimSupport = CreateScreenAnimation(Controls.SlideAnim, Close);

	-- Hot-Reload Events
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetShutdown(OnShutdown);
	LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);

	-- UI Callbacks
	ContextPtr:SetInputHandler(m_AnimSupport.OnInputHandler, true);

	Controls.CloseButton:SetOffsetY(50);		-- Move close button down to account for TabHeader
	Controls.CloseButton:RegisterCallback(Mouse.eLClick, Close);
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.Title:SetText(Locale.Lookup("NOTIFICATION LOG"));
	Controls.TabHeader:ChangeParent(Controls.Background);		-- To make it render beneath the banner image

	-- Game Events
	Events.CapitalCityChanged.Add(OnCapitalCityChanged);
	Events.InterfaceModeChanged.Add( OnInterfaceModeChanged );
	Events.LocalPlayerTurnEnd.Add(OnLocalPlayerTurnEnd);
	Events.SystemUpdateUI.Add(m_AnimSupport.OnUpdateUI);	

	Events.StatusMessage.Add( OnAddMessage ); -- Added by HB

	-- Lua Events
	LuaEvents.PartialScreenHooks_ToggleNotificationLog.Add(Toggle);
	LuaEvents.PartialScreenHooks_OpenNotificationLog.Add(Open);
	LuaEvents.PartialScreenHooks_CloseNotificationLog.Add(Close);
	LuaEvents.PartialScreenHooks_CloseAllExcept.Add(OnCloseAllExcept);

	LuaEvents.NotificationLogAddMessage.Add(OnAddMessage) -- Added By HB

	UpdatePlayerData();
	PopulateTabs();
end
Initialize();
