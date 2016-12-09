include("dm/server/start.lua")

Minigames.addGamemode("deathmatch",{
	["name"]="DeathMatch",
	["pickWeapons"] = true,
	["defaultWeapons"] = {
		{ClassName="fas2_m3s90",AmmoStart=40}
	}
})