-- Szybki opis --
-- Gracz dostaje crowbara za każdym razem jak ginie i spawnowany jest na jednej z pozycji spawna --
-- Gra kończy się po 5 minutach (14 linijka) --
-- Wybierany jest zwycięzca i wypisywany do konsoli --
-- Do tego dopisany jest tutaj anty noclip --

-- Nie testowałem losowania zwycięzcy --

local DM = {}

hook.Add("MinigamesGameStarted","testowy",function()
	if Minigames.ActualGame == "deathmatch" then
		startFirstDM()
	end
end)

function startFirstDM()
	-- timer.Create( "EndDmGame", 5*60, 0, function() endDmGame() end )
	timer.Simple( 5*60, function() endDmGame() end )
	DM.countDeaths = 0
	DM.stats = {}
	DM.spawns = Minigames.buildingMode.getActualMinigameSpawns()
	for i,k in pairs(Minigames.PlayersQue) do
		dmSpawnPly(k)
			-- Reset stats
		DM.stats[k] = {}
		DM.stats[k].deaths = 0
		DM.stats[k].kills = 0
	end
end

hook.Add("PlayerDeath","EndGame",function(ply,attacker)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) and Minigames.isPlayerInGame(attacker) then
			DM.countDeaths = DM.countDeaths + 1
			DM.stats[ply].deaths = DM.stats[ply].deaths + 1
			DM.stats[ply].kills = DM.stats[ply].kills + 1
		end
	end
end)

hook.Add("PlayerSpawn","SpawnDm",function(ply)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			dmSpawnPly(ply)
			return false
		end
	end
end)

hook.Add("PlayerNoClip","DmNoclip",function(ply)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			return false
		end
	end
end)

function dmSpawnPly(ply)
-- Reset weapons
	ply:StripWeapons()
	ply:Give("weapon_crowbar")
	-- Spawn players
	local rand = math.Rand(1,table.Count(DM.spawns))
	rand = math.floor(rand)

	local rSpawn = DM.spawns[rand]

	ply:SetPos(rSpawn.pos)
	ply:SetAngles(Angle(0,rSpawn.ang,0))
end

function endDmGame()
	local maxK = 0
	local plywin = nil
	for i,k in pairs(DM.stats) do
		if k.kills > maxK then maxD=k.kills plywin=i end
	end
	if plywin ~= nil then
		print("[Minigry] Event wygrał " .. plywin:GetName() .. " zabijając " .. maxK .. " graczy.")
	end
	Minigames.endGame()
end