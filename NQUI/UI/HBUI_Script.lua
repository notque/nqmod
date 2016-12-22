

local g_cacheRefreshObserver = false;
local g_cachedTeamCityLands = {};
local g_cachedTeamPlayers = {};

function OnLocalPlayerTurnBegin()
	print("MasterBalance OnLocalPlayerTurnBegin!");
end

-- ===========================================================================
function OnPlayerTurnActivated( ePlayer:number, isFirstTimeThisTurn:boolean )
	print("Check For Observer In Game");
	if ePlayer == Game.GetLocalPlayer() then
		if (g_cachedTeamPlayers[ePlayer] == 1000) then
			print("Observer In Game");
			RefreshObserver(ePlayer);
		else
			Refresh(ePlayer);
		end
	end
end

function checkTeamStr()
	local ePlayer:number = Game.GetLocalPlayer();
	local teamStr = GameConfiguration.GetValue("MASTER_BALANCE_TEAM_DATA");
	
	if (teamStr ~= "") and (teamStr ~= nil) then
		print("##################################################");
		print(teamStr);
		print("##################################################");
		local iNumMajorCivs = PlayerManager.GetAliveMajorsCount();
		local tmpStr;
		local valueStr;
		local valuePos = 1;
		local playerId = -1;

		local num = string.len(teamStr);
		g_cachedTeamPlayers = {};
		for i = 1, num do
			tmpStr = string.sub(teamStr, i, i);
			if (tmpStr == "|") then
				valueStr = string.sub(teamStr, valuePos, i - 1);
				g_cachedTeamPlayers[playerId] = tonumber(valueStr);
				valuePos = i + 1;
			elseif (tmpStr == "=") then
				valueStr = string.sub(teamStr, valuePos, i - 1);
				playerId = tonumber(valueStr);
				valuePos = i + 1;
			end
		end

		local majorList = PlayerManager.GetAliveMajorIDs();
		for i = 1, iNumMajorCivs do
			if (g_cachedTeamPlayers[majorList[i]] == 1000) then
				return true;
			end
		end
	end
	
	return false;
end

function RefreshObserver( ePlayer:number )
	--if (not g_cacheRefreshObserver) then
		g_cacheRefreshObserver = true;
		local iNumMajorCivs = PlayerManager.GetAliveMajorsCount();
		--if (MapConfiguration.GetValue("map_position") == '2') then
			local pLocalPlayerVis = PlayersVisibility[ePlayer];
			local players		:table = Game.GetPlayers();

			local iCount = Map.GetPlotCount();
			for plotIndex = 0, iCount-1, 1 do
				pLocalPlayerVis:ChangeVisibilityCount(plotIndex, -1);
				pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 0);
			end

			for _, player in ipairs(Players) do
				local iPlayer = player:GetID();
				if (iPlayer ~= ePlayer) or (iPlayer ~= 63) then
					local pLocalPlayerVistmp = PlayersVisibility[iPlayer];

					if (pLocalPlayerVistmp ~= nil) then
						local iCount = Map.GetPlotCount();
						for plotIndex = 0, iCount-1, 1 do
							local isVis = false;
							local pPlot = Map.GetPlotByIndex(plotIndex);
							local locX = pPlot:GetX();
							local locY = pPlot:GetY();
							local isVis = pLocalPlayerVistmp:IsVisible(locX, locY);

							if (isVis) then
								pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 1);
							end
						end
					end
				end
			end
			
		--end
	--end
end

function Refresh( ePlayer:number )
	local pLocalPlayerVis = PlayersVisibility[ePlayer];
	if (pLocalPlayerVis ~= nil) then

		local curTeamCityLands = {};
		local iCount = Map.GetPlotCount();
		local majorList = PlayerManager.GetAliveMajorIDs();
		local iNumMajorCivs = PlayerManager.GetAliveMajorsCount();
		for plotIndex = 0, iCount-1, 1 do
			local pPlot = Map.GetPlotByIndex(plotIndex);
			local landNum = pPlot:GetX() * 1000 + pPlot:GetY();
			local localCount = pLocalPlayerVis:GetVisibilityCount(plotIndex);
			for i = 1, iNumMajorCivs do
				if (majorList[i] ~= ePlayer and g_cachedTeamPlayers[ePlayer] == g_cachedTeamPlayers[majorList[i]]) then
					local playerVis = PlayersVisibility[majorList[i]];
					if (playerVis:GetVisibilityCount(plotIndex) > 1) then
						if (pPlot:GetOwner() == majorList[i]) then
							curTeamCityLands[landNum] = 1;
						end
						if (pPlot:GetOwner() == majorList[i] and localCount <= 0) then
							pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 1);
						elseif (not pLocalPlayerVis:IsRevealed(plotIndex)) then
							pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 0);
						end
					elseif (playerVis:IsRevealed(plotIndex) and (not pLocalPlayerVis:IsRevealed(plotIndex))) then
						pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 0);
					end
				end
			end

			if (g_cachedTeamCityLands[landNum] == 1 and curTeamCityLands[landNum] == nil) then
				if (localCount <= 1) then
					pLocalPlayerVis:ChangeVisibilityCount(plotIndex, -1);
					pLocalPlayerVis:ChangeVisibilityCount(plotIndex, 0);
				else
					curTeamCityLands[landNum] = 1;
				end
			end
		end
		g_cachedTeamCityLands = curTeamCityLands;
	end
end

function OnActionCommand(isConnect, pPlot, pUnitType)
	if (isConnect) then
		print("MasterBalance OnActionCommand isConnect!");
		LuaEvents.MB_ActionCommandConnect();
	else
		if (pPlot ~= nil and pUnitType ~= nil) then
			print("MasterBalance OnActionCommand action!");
			Players[pPlot:GetOwner()]:GetUnits():Create(pUnitType, pPlot:GetX(), pPlot:GetY());
		end
	end
end

function OnActionCommandCity(pSelectedCity)
	print("OnActionCommandCity destroy!");
	CityManager.DestroyCity(pSelectedCity:GetOwner(), pSelectedCity:GetID());
end

function Initialize()
	print("MasterBalance Initialize!");
	LuaEvents.MB_ActionCommand.Add( OnActionCommand );
--	LuaEvents.MB_ActionCommandCity.Add( OnActionCommandCity );

	if (not checkTeamStr()) then
		return;
	end

	Events.LocalPlayerTurnBegin.Add( OnLocalPlayerTurnBegin );
	Events.PlayerTurnActivated.Add(	OnPlayerTurnActivated );
end
Initialize();