-- Szybki opis --
-- Gracz dostaje crowbara za każdym razem jak ginie i spawnowany jest na jednej z pozycji spawna --
-- Gra kończy się po 5 minutach (14 linijka) --
-- Wybierany jest zwycięzca i wypisywany do konsoli --

local DM = {}

hook.Add("MinigamesGameStarted","testowy",function()
	if Minigames.ActualGame == "deathmatch" then
		startFirstDM()
	end
end)

function startFirstDM()
	-- timer.Simple( 5*60, function() endDmGame() end )
	timer.Create("DMTimerEnd",5*60,1,function() endDmGame() end)
	-- timer.Simple( 10, function() endDmGame() end )
	DM.countDeaths = 0
	DM.stats = {}
	DM.beforeWeapons = {}
	DM.weapons = Minigames.GameConfig.weapons
	DM.spawns = Minigames.buildingMode.getActualMinigameSpawns()
	for i,k in pairs(Minigames.PlayersQue) do
		DM.beforeWeapons[k] = {}
		for z,p in pairs(k:GetWeapons()) do
			table.insert(DM.beforeWeapons[k],p:GetClass())
		end
		dmSpawnPly(k)
			-- Reset stats
		DM.stats[k] = {}
		DM.stats[k].deaths = 0
		DM.stats[k].kills = 0
	end
end

hook.Add("minigameEndGameCommand","DmCustomEnd",function()
	if Minigames.ActualGame == "deathmatch" then
		timer.Stop("DMTimerEnd")
		endDmGame()
		return
	end
end)

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

-- Zabrania noclipa
hook.Add("PlayerNoClip","DmNoclip",function(ply)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			return false
		end
	end
end)

-- Zaprania spawnowania propów
hook.Add("PlayerSpawnProp","DmSPawnProp",function(ply)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			return false
		end
	end
end)
-- Zabrania spawnowania broni
hook.Add("PlayerSpawnSWEP","DmSPawnWeapon",function(ply)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			return false
		end
	end
end)
hook.Add("PlayerCanPickupWeapon","DmSPawnPickup",function(ply, wep)
	if Minigames.ActualGame == "deathmatch" then
		if Minigames.isPlayerInGame(ply) then
			-- DM.weapons
			local wepC = wep:GetClass()
			if weaponAvilable(wepC) == false then
				return false
			end
		end
	end
end)

function weaponAvilable(weaponName)
	for i,k in pairs(DM.weapons) do
		if k.ClassName == weaponName then return true end
	end
	return true
end

function dmSpawnPly(ply)
-- Reset weapons
	ply:StripWeapons()
	for i,k in pairs(DM.weapons) do
		ply:Give(k.ClassName)
		if k.AmmoStart ~= nil and k.AmmoStart > 0 and k.PrimaryAmmoType ~= nil then
			ply:SetAmmo(k.AmmoStart,k.PrimaryAmmoType)
		end
	end
	-- Spawn players
	local rand = math.Rand(1,table.Count(DM.spawns))
	rand = math.floor(rand)

	local rSpawn = DM.spawns[rand]

	ply:SetPos(rSpawn.pos)
	ply:SetAngles(Angle(0,rSpawn.ang,0))
end

function playerExit(ply)
	ply:StripWeapons()
	for i,k in pairs(DM.beforeWeapons[ply]) do
		ply:Give(k)
	end
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
	local qP = Minigames.PlayersQue
	Minigames.endGame()
	for i,k in pairs(qP) do
		playerExit(k)
	end
end