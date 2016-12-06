hook.Add("MinigamesGameStarted","testowy",function()
	if Minigames.ActualGame == "deathmatch" then
		startFirstDM()
	end
end)

function startFirstDM()
	local spawns = Minigames.buildingMode.getActualMinigameSpawns()
	for i,k in pairs(Minigames.PlayersQue) do
		local rand = math.Rand(1,table.Count(spawns))
		rand = math.floor(rand)

		local rSpawn = spawns[rand]

		k:SetPos(rSpawn.pos)
		k:SetAngles(Angle(0,rSpawn.ang,0))
	end
end