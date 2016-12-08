-- ===========================================================================
--	Popups when a Tech or Civic are completed
-- ===========================================================================
include("TechAndCivicSupport"); -- (Already includes Civ6Common and InstanceManager) PopulateUnlockablesForTech, PopulateUnlockablesForCivic, GetUnlockablesForCivic, GetUnlockablesForTech

-- ===========================================================================
--	CONSTANTS / MEMBERS
-- ===========================================================================
local RELOAD_CACHE_ID		:string = "TechCivicCompletedPopup";
local m_unlockIM			:table = InstanceManager:new( "UnlockInstance", "Top", Controls.UnlockStack );
local m_unlockTCIM			:table = InstanceManager:new( "UnlockInst", "UnlockAni", Controls.TechStack);

local m_isWaitingToShowPopup:boolean = false;
local m_isDisabledByTutorial:boolean = false;
local m_kQueuedPopups		:table	 = {};
local m_bIsCivic            :boolean = false;
local m_quote_audio;

local m_kMessages :table = {};

-- =========================================================================== 
--	FUNCTIONS
-- =========================================================================== 

-- =========================================================================== 
-- =========================================================================== 


function ShowCompletedPopup(completedPopup:table, queueEntry:table)
	
	if completedPopup.tech ~= nil then
		ShowTechCompletedPopup(completedPopup.player, completedPopup.tech, completedPopup.isCanceled);
        m_bIsCivic = false;
	elseif completedPopup.civic ~= nil then
		ShowCivicCompletedPopup(completedPopup.player, completedPopup.civic, completedPopup.isCanceled);
        m_bIsCivic = true;
	elseif queueEntry.techIndex ~= nil then
		ShowTechBoost(queueEntry.techIndex, queueEntry.iTechProgress, queueEntry.eSource);
	else
		ShowCivicBoost(queueEntry.civicIndex, queueEntry.iCivicProgress, queueEntry.eSource);
	end
	
	-- Queue Popup through UI Manager
	UIManager:QueuePopup( ContextPtr, PopupPriority.Low);	-- Made low so any Boost popups related will be shown first
	m_isWaitingToShowPopup = true;
end

-- ===========================================================================
function ShowCivicCompletedPopup(player:number, civic:number, isCanceled:boolean)
	local civicInfo:table = GameInfo.Civics[civic];
	if civicInfo ~= nil then
		local civicType = civicInfo.CivicType;

		local isCivicUnlockGovernmentType:boolean = false;
		
		local kTypeEntry:table = m_kMessages[0];
		if (kTypeEntry == nil) then
			-- New type
			m_kMessages[0] = {
				InstanceManager = nil,
				MessageInstances= {}
			};
			kTypeEntry = m_kMessages[0];
		
			kTypeEntry.InstanceManager	= m_unlockTCIM;
		end
		
		local TextMsg = "CIVIC COMPLETE: " .. Locale.ToUpper(Locale.Lookup(civicInfo.Name));
		local pInstance:table = kTypeEntry.InstanceManager:GetInstance();
		
		table.insert( kTypeEntry.MessageInstances, pInstance );
		
		pInstance.StatusLabel:SetText( TextMsg );
		pInstance.TCGrid:SetColor(115,0,115,150);
		pInstance.Anim:SetEndPauseTime( 5 );
		pInstance.Anim:RegisterEndCallback( function() OnEndAnim(kTypeEntry, pInstance) end );
		pInstance.Anim:SetToBeginning();
		pInstance.Anim:Play();
		
		Controls.TechStack:CalculateSize();
		Controls.TechStack:ReprocessAnchoring();
	end
end

-- ===========================================================================
function ShowTechCompletedPopup(player:number, techId:number, isCanceled:boolean)
	local techInfo:table = GameInfo.Technologies[techId];
	if techInfo ~= nil then
		
		local techType = techInfo.TechnologyType;
		
		local kTypeEntry:table = m_kMessages[0];
		if (kTypeEntry == nil) then
			-- New type
			m_kMessages[0] = {
				InstanceManager = nil,
				MessageInstances= {}
			};
			kTypeEntry = m_kMessages[0];
		
			kTypeEntry.InstanceManager	= m_unlockTCIM;
		end
		
		local TextMsg = "RESEARCH COMPLETE: " .. Locale.ToUpper(Locale.Lookup(techInfo.Name));
		local pInstance:table = kTypeEntry.InstanceManager:GetInstance();
		
		table.insert( kTypeEntry.MessageInstances, pInstance );
		
		pInstance.StatusLabel:SetText( TextMsg );
		pInstance.TCGrid:SetColor(0X96E07D00);
		pInstance.Anim:SetEndPauseTime( 5 );
		pInstance.Anim:RegisterEndCallback( function() OnEndAnim(kTypeEntry, pInstance) end );
		pInstance.Anim:SetToBeginning();
		pInstance.Anim:Play();
		
		Controls.TechStack:CalculateSize();
		Controls.TechStack:ReprocessAnchoring();
	end
end

-- ===========================================================================
function OnEndAnim( kTypeEntry:table, pInstance:table )
	print("Tech Ended");
	pInstance.Anim:ClearEndCallback();
	Controls.TechStack:CalculateSize();
	Controls.TechStack:ReprocessAnchoring();
	kTypeEntry.InstanceManager:ReleaseInstance( pInstance );
	--UIManager:DequeuePopup(ContextPtr);
end

-- ===========================================================================
function OnCivicCompleted( player:number, civic:number, isCanceled:boolean)
	if player == Game.GetLocalPlayer() and (not m_isDisabledByTutorial) then
		local civicCompletedEntry:table = { player=player, civic=civic, isCanceled=isCanceled };
		local tmpTable = {};
		ShowCompletedPopup(civicCompletedEntry, tmpTable);
	end
end

-- ===========================================================================
function OnResearchCompleted( player:number, tech:number, isCanceled:boolean)
	--print("Player: ", player); 
	if player == Game.GetLocalPlayer() then --and (not m_isDisabledByTutorial) then
		local techCompletedEntry:table = { player=player, tech=tech, isCanceled=isCanceled };
		local tmpTable = {};
		ShowCompletedPopup(techCompletedEntry, tmpTable);
	end
end

-- ===========================================================================
--	Closes the immediate popup, will raise more if queued.
-- ===========================================================================
function Close()
	-- Dequeue popup from UI mananger (will re-queue if another is about to show).
	UIManager:DequeuePopup( ContextPtr );

	-- Find first entry in table, display that, then remove it from the internal queue
	for i, entry in ipairs(m_kQueuedPopups) do
		ShowCompletedPopup(entry);
		table.remove(m_kQueuedPopups, i);
		break;
	end

	-- If no more popups are in the queue, close the whole context down.
	if table.count(m_kQueuedPopups) == 0 then
		m_isWaitingToShowPopup = false;
	end
end

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnClose()
    if m_bIsCivic then
        UI.PlaySound("Stop_Speech_Civics");
    else
        UI.PlaySound("Stop_Speech_Tech");
    end
	Close();
end

-- ===========================================================================
function OnChangeGovernment()	
	Close();
	LuaEvents.TechCivicCompletedPopup_GovernmentOpenGovernments();	-- Open Government Screen	
	UI.PlaySound("Stop_Speech_Civics");
end

-- ===========================================================================
function OnChangePolicy()	
	Close();
	LuaEvents.TechCivicCompletedPopup_GovernmentOpenPolicies();		-- Open Government Screen	
	UI.PlaySound("Stop_Speech_Civics");
end

-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then		
		LuaEvents.GameDebug_GetValues(RELOAD_CACHE_ID);		
	end
end

-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnShow( )
    UI.PlaySound("Pause_Advisor_Speech");
    UI.PlaySound("Resume_TechCivic_Speech");
    if(m_quote_audio and #m_quote_audio > 0) then
        UI.PlaySound(m_quote_audio);
    end
end

-- ===========================================================================
--	UI EVENT
-- ===========================================================================
function OnShutdown()
	-- Cache values for hotloading...
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "isHidden",		ContextPtr:IsHidden() );
	LuaEvents.GameDebug_AddValue(RELOAD_CACHE_ID, "kQueuedPopups",	m_kQueuedPopups );
	-- TODO: Add current popup to queue list.
end

------------------------------------------------------------------------------------------------
function OnLocalPlayerTurnEnd()
	if(GameConfiguration.IsHotseat()) then
		Close();
	end
end

-- ===========================================================================
--	LUA Event
--	Set cached values back after a hotload.
-- ===========================================================================
function OnGameDebugReturn( context:string, contextTable:table )
	if context ~= RELOAD_CACHE_ID then
		return;
	end
	local isHidden:boolean = contextTable["isHidden"]; 
	if not isHidden then
		local kQueuedPopups:table = contextTable["kQueuedPopups"];
		if kQueuedPopups ~= nil then
			for _,entry in ipairs(kQueuedPopups) do
				ShowCompletedPopup( entry );
			end
		end
	end
end

-- ===========================================================================
--	LUA Event
-- ===========================================================================
function OnDisableTechAndCivicPopups()
	m_isDisabledByTutorial = true;
end

-- ===========================================================================
--	LUA Event
-- ===========================================================================
function OnEnableTechAndCivicPopups()
	m_isDisabledByTutorial = false;
end


-- ===========================================================================
function ShowBoost(queueEntry:table)
	--do return end;	-- TAG_DISABLE_BOOST_POPUP remove the eureka / inspiration popup
	if queueEntry.techIndex ~= nil then
		ShowTechBoost(queueEntry.techIndex, queueEntry.iTechProgress, queueEntry.eSource);
	else
		--ShowCivicBoost(queueEntry.civicIndex, queueEntry.iCivicProgress, queueEntry.eSource);
	end
end
-- ===========================================================================

function ShowTechBoost(techIndex, iTechProgress, eSource)
	
	-- Make sure we're the local player
	local localPlayer = Players[Game.GetLocalPlayer()];
	if (localPlayer == nil) then
		return;
	end

	local currentTech = GameInfo.Technologies[techIndex];
	local techName = " ";

	if currentTech ~= nil then
		techName = currentTech.Name;
	end
	
	local kTypeEntry :table = m_kMessages[type];
	if (kTypeEntry == nil) then
		-- New type
		m_kMessages[type] = {
			InstanceManager = nil,
			MessageInstances= {}
		};
		kTypeEntry = m_kMessages[type];
	
		kTypeEntry.InstanceManager	= m_unlockTCIM;
	end
	
	local TextMsg = "EUREKA: " .. Locale.ToUpper(techName);
	local pInstance:table = kTypeEntry.InstanceManager:GetInstance();
	
	table.insert( kTypeEntry.MessageInstances, pInstance );
	
	pInstance.StatusLabel:SetText( TextMsg );
	pInstance.TCGrid:SetColor(0X96FFAE48);
	pInstance.Anim:SetEndPauseTime( 5 );
	pInstance.Anim:RegisterEndCallback( function() OnEndAnim(kTypeEntry, pInstance) end );
	pInstance.Anim:SetToBeginning();
	pInstance.Anim:Play();
	Controls.TechStack:CalculateSize();
	Controls.TechStack:ReprocessAnchoring();
end
-- ===========================================================================

function ShowCivicBoost(civicIndex, iCivicProgress, eSource)
-- Make sure we're the local player
	
	local localPlayer = Players[Game.GetLocalPlayer()];
	if (localPlayer == nil) then
		return;
	end

	local currentCivic = GameInfo.Civics[civicIndex];
	local civicName = " ";

	if currentCivic ~= nil then
		civicName = currentCivic.Name;
	end
	
	local kTypeEntry :table = m_kMessages[type];
	if (kTypeEntry == nil) then
		-- New type
		m_kMessages[type] = {
			InstanceManager = nil,
			MessageInstances= {}
		};
		kTypeEntry = m_kMessages[type];
	
		kTypeEntry.InstanceManager	= m_unlockTCIM;
	end
	
	local TextMsg = "INSPIRATION: " .. Locale.ToUpper(civicName);
	local pInstance:table = kTypeEntry.InstanceManager:GetInstance();
	
	table.insert( kTypeEntry.MessageInstances, pInstance );
	
	pInstance.StatusLabel:SetText( TextMsg );
	pInstance.TCGrid:SetColor(0x64D400D4);
	pInstance.Anim:SetEndPauseTime( 5 );
	pInstance.Anim:RegisterEndCallback( function() OnEndAnim(kTypeEntry, pInstance) end );
	pInstance.Anim:SetToBeginning();
	pInstance.Anim:Play();
	
	
	Controls.TechStack:CalculateSize();
	Controls.TechStack:ReprocessAnchoring();
end
-- ===========================================================================

function OnTechBoostTriggered(ePlayer, techIndex, iTechProgress, eSource)
	m_isPastLoadingScreen = true;
	print("Here", m_isPastLoadingScreen);
	-- If it's the first turn of a late start game, ignore all the boosts the come across the wire.
	if (not m_isPastLoadingScreen) and (Game.GetCurrentGameTurn() == GameConfiguration.GetStartTurn()) then 
		return; 
	end

	if ePlayer == Game.GetLocalPlayer() and (not m_isDisabledByTutorial) then
		local techBoostEntry:table = { techIndex=techIndex, iTechProgress=iTechProgress, eSource=eSource };
		local tmpTable = {};
		
		-- If we're not showing a boost popup then add it to the popup system queue
		ShowCompletedPopup(tmpTable, techBoostEntry);
	end
end
-- ===========================================================================

function OnCivicBoostTriggered(ePlayer, civicIndex, iCivicProgress, eSource)
	m_isPastLoadingScreen = true;
	print("Here", m_isPastLoadingScreen);
	-- If it's the first turn of a late start game, ignore all the boosts the come across the wire.
	if (not m_isPastLoadingScreen) and (Game.GetCurrentGameTurn() == GameConfiguration.GetStartTurn()) then 
		return; 
	end

	if ePlayer == Game.GetLocalPlayer() and (not m_isDisabledByTutorial)  then
		local civicBoostEntry:table = { civicIndex=civicIndex, iCivicProgress=iCivicProgress, eSource=eSource };
		local tmpTable = {};
		
		-- If we're not showing a boost popup then add it to the popup system queue
		ShowCompletedPopup(tmpTable, civicBoostEntry);
	end 
end
-- ===========================================================================
function OnLoadGameViewStateDone()
    m_isPastLoadingScreen = true;
end

-- ===========================================================================
function Initialize()	
	-- Controls Events
	--Controls.CloseButton:RegisterCallback( eLClick, OnClose );
	--Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetShutdown( OnShutdown );
    ContextPtr:SetShowHandler( OnShow );
	
	--Controls.EraPopupAnimation:RegisterStartCallback( function() print("START EraPopupAnimation"); end ); --??TRON debug
	--Controls.TechPopupAnimation:RegisterEndCallback( OnEraPopupAnimationEnd );
	--Controls.HeaderSlide:RegisterEndCallback( OnHeaderAnimationComplete );
	
	-- LUA Events
	LuaEvents.GameDebug_Return.Add( OnGameDebugReturn );
	--LuaEvents.TutorialUIRoot_DisableTechAndCivicPopups.Add( OnDisableTechAndCivicPopups );
	--LuaEvents.TutorialUIRoot_EnableTechAndCivicPopups.Add( OnEnableTechAndCivicPopups );

	-- Game Events
	Events.ResearchCompleted.Add(OnResearchCompleted);
	Events.CivicCompleted.Add(OnCivicCompleted);
	Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
	Events.TechBoostTriggered.Add( OnTechBoostTriggered );
	Events.CivicBoostTriggered.Add( OnCivicBoostTriggered );
	Events.LoadGameViewStateDone.Add( OnLoadGameViewStateDone );
end
Initialize();
