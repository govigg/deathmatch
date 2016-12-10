include("dm/server/start.lua")

Minigames.addGamemode("deathmatch",{
	["name"]="DeathMatch",
	["pickWeapons"] = true,
	["defaultWeapons"] = {
		{ClassName="weapon_crowbar",AmmoStart=40}
	},
	config = {
		time = {
			type= "number",
			tag = "Czas gry [min]",
			default = 3
		},
		hp = {
			type="number",
			tag = "Życie",
			default = 100
		}
	}
})

-- config avilable fields --
-- text:	type, [tag], [default]
-- number:	type, [tag], [deafult]