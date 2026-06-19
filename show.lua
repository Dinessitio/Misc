print("Showing!")
local Players = game:GetService("Players")
_G.Active = true
while _G.Active do
	for _, player in ipairs(Players:GetPlayers())  do
		local GameData = player:FindFirstChild("GameData")
		local leaderstats = player:FindFirstChild("leaderstats")
		if GameData and leaderstats then
			local soulmateColor = GameData:FindFirstChild("SoulmateColor")
			local HiddenColor = GameData:FindFirstChild("ColorHidden")
			local color = leaderstats:FindFirstChild("Color")
			if soulmateColor and color then
				if HiddenColor.Value == true then
				    color.Value = soulmateColor.Value .. " 🔒"
                else
				    color.Value = soulmateColor.Value
				end
			end
		end
	end
	wait(1)
end
