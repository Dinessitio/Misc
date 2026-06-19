print("loading")
local args = {
    [1] = "Luminescentdagger",
}

game:GetService("ReplicatedStorage").RequestAvatarChange:FireServer(unpack(args))
local Rayfield = loadstring(game:HttpGet('https://pastebin.com/raw/4irvPrd0'))()
local Window = Rayfield:CreateWindow({
	Name = "Slap shit",
    Theme = "Amethyst",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait",
	ConfigurationSaving = {               -- <-- Включение сохранения
        Enabled = true,                   -- Обязательно: true
        FolderName = nil,                 -- Можно указать свою папку
        FileName = "SlapScript"     -- Обязательно: уникальное имя файла
    }
})

local MainTab = Window:CreateTab("Local Player", 4483362458)
local SocialTab = Window:CreateTab("Players", 3610245072)
local ServTab = Window:CreateTab("Lagging", 3944668846)
local KeybindsTab = Window:CreateTab("Keybinds")
local MiscTab =  Window:CreateTab("Misc")

local isImmunityActive = false

local DeathImmunity = MainTab:CreateToggle({
    Name = "Glory Immunity/Instakill",
    CurrentValue = false,
    Flag = "DeathImmunity",
    Callback = function(Value)
        isImmunityActive = Value  -- обновляем глобальный флаг

        if Value then
            -- Запускаем цикл в отдельном потоке
            task.spawn(function()
                while isImmunityActive do  -- проверяем флаг, а не параметр Value
                    local localplayer = game:GetService("Players").LocalPlayer
                    local character = localplayer.Character
                    if not character then 
                        task.wait(0.1)
                        continue
                    end

                    local rightarm = character:FindFirstChild("Right Arm")
                    local leftarm = character:FindFirstChild("Left Arm")
                    local rightleg = character:FindFirstChild("Right Leg")
                    local leftleg = character:FindFirstChild("Left Leg")
                    local torso = character:FindFirstChild("Torso")
                    local head = character:FindFirstChild("Head")

                    -- Проверяем, что все части существуют
                    if head and torso and leftleg and rightleg and leftarm and rightarm then
                        if head.Transparency == 1 or torso.Transparency == 1 
                           or leftleg.Transparency == 1 or rightleg.Transparency == 1
                           or leftarm.Transparency == 1 or rightarm.Transparency == 1 then
                            
                            for i = 1, 100 do
                            game:GetService("ReplicatedStorage").Scener:FireServer()
							end
						end
                    end

                    task.wait(0.1)  -- используем task.wait() вместо wait()
                end
            end)
        end
    end
})

local isSlapImmunityActive = false
local AttackImmunity = MainTab:CreateToggle({
   Name = "Attack Immune",
   CurrentValue = false,
   Flag = "AttackImmunity",
   Callback = function(Value)
      isSlapImmunityActive = Value

      if Value then
         spawn(function()
            while isSlapImmunityActive do
               pcall(function()
                local args = {
                [1] = "Active",
				}
                game:GetService("ReplicatedStorage").abilities.BlueHotSlap.Event:FireServer(unpack(args))
               end)
               wait(1)
            end
         end)
      end
   end
})
-- === ОБЛАСТЬ ВИДИМОСТИ СКРИПТА (вне зависимости от тогла) ===
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("equipments"):WaitForChild("BloxyColaremote")

-- Состояние и подключения
local isActive = false
local heartbeatConnection = nil
local characterAddedConnection = nil
local currentCharacter = nil
local wasRagdoll = false

-- Функция проверки ragdoll (по BallSocketConstraint)
local function isInRagdoll(character)
    if not character then return false end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") then
            return true
        end
    end
    return false
end

-- Функция, вызываемая каждый кадр
local function onHeartbeat()
    if not currentCharacter or not currentCharacter.Parent then
        return
    end

    local inRagdollNow = isInRagdoll(currentCharacter)

    if inRagdollNow and not wasRagdoll then
        wasRagdoll = true
        remote:FireServer()
    elseif not inRagdollNow then
        wasRagdoll = false
    end
end

-- Обработчик смены персонажа
local function onCharacterAdded(character)
    currentCharacter = character
    wasRagdoll = false
end

-- Функция включения анти-рагдолла
local function enable()
    if isActive then return end
    isActive = true

    currentCharacter = player.Character
    wasRagdoll = false

    characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
    heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
end

-- Функция выключения анти-рагдолла
local function disable()
    if not isActive then return end
    isActive = false

    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    currentCharacter = nil
    wasRagdoll = false
end

-- === СОЗДАНИЕ ТОГЛА ===
local Antiragdoll = MainTab:CreateToggle({
    Name = "Anti ragdoll",
    CurrentValue = false,
    Flag = "Antiragdoll",
    Callback = function(Value)
        if Value then
            enable()
        else
            disable()
        end
    end
})

local isAutoHealActive = false
local IfBelowHP = 30

local AutoHeal = MainTab:CreateToggle({
   Name = "Auto Heal",
   CurrentValue = false,
   Flag = "AutoHeal",
   Callback = function(Value)
      isAutoHealActive = Value

      if Value then
         spawn(function()
            while isAutoHealActive do
               local localPlayer = game.Players.LocalPlayer
               local character = localPlayer.Character
               local humanoid = character.Humanoid

               if humanoid.Health < IfBelowHP and humanoid.Health > 0 then
				    for i = 1, 5 do
                        game:GetService("ReplicatedStorage").equipments.BloxyColaremote:FireServer()
				    end
			   end

               wait(0.01)
            end
         end)
      end
   end
})
local HealIfBelowSlider = MainTab:CreateSlider({
   Name = "Auto heal If below HP",
   Range = {0, 100},
   Increment = 10,
   CurrentValue = 30,
   Flag = "AutoHealIfBelow",
   Callback = function(Value)
    IfBelowHP = Value
   end,
})

local KillsToGetInput = MainTab:CreateInput({
   Name = "Kills giver",
   PlaceholderText = "1000",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      local localPlayer = game.Players.LocalPlayer
      local character = localPlayer.Character
      local remoteEvent = localPlayer.PlayerGui.Rewards.RemoteEvent

      local args = {
         [1] = character
      }
    for i = 1, Value do
		remoteEvent:FireServer(unpack(args))
	end
   end,
})
local CoinsToGetInput = MainTab:CreateInput({
   Name = "Coins giver",
   PlaceholderText = "1000",
   RemoveTextAfterFocusLost = false,
   Callback = function(Value)
      local remoteEvent = game:GetService("Players").LocalPlayer.PlayerGui.Pumpkin.RemoteEvent

    local args = {
        [1] = Value,
        [2] = Color3.new(1, 0.690196, 0),
    }
    remoteEvent:FireServer(unpack(args))
   end,
})
local LagInputNumber = 0


local GetPingButton = ServTab:CreateButton({
   Name = "Ping creator",
   Callback = function()
      local localPlayer = game.Players.LocalPlayer
      local character = localPlayer.Character
      local remoteEvent = localPlayer.PlayerGui.Rewards.RemoteEvent

      local args = {
         [1] = character
      }

      for i = 1, LagInputNumber do
         remoteEvent:FireServer(unpack(args))
      end
   end
})

local LagMSInput = ServTab:CreateInput({
   Name = "Ping lagtime (In milliseconds)",
   PlaceholderText = "1000",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      LagInputNumber = math.floor(tonumber(Text) or 0)
      LagMSInput:SetValue(tostring(LagInputNumber))
   end
})

local GetFpsButtonGoonMeth = ServTab:CreateButton({
	Name = "Lag server (Goon method)",
	Callback = function()
	while true do
		for i = 1, 10 do
			game:GetService("ReplicatedStorage").HelpScenes:FireServer()
		end
		wait(0.1)
	end
	end
})
local SpawnMulti = 1
local GetDiamondButton = SocialTab:CreateButton({
	Name = "Diamond spawner",
	Callback = function()
	for i = 1, SpawnMulti do
	game:GetService("ReplicatedStorage").equipments.DiamondSackremote:FireServer()
	end
	end
})
local DropBananaButton = SocialTab:CreateButton({
	Name = "Spawn bananas",
	Callback = function()
	for i = 1, SpawnMulti do
        game:GetService("ReplicatedStorage").equipments.BananaPeelremote:FireServer()
    end
	end
})
local DropBearTrapsButton = SocialTab:CreateButton({
	Name = "Spawn Bear traps",
	Callback = function()
	for i = 1, SpawnMulti do
        game:GetService("ReplicatedStorage").equipments.Beartrapremote:FireServer()
    end
	end
})
local DropVoidBombButton = SocialTab:CreateButton({
	Name = "Spawn Void Bomb (Unaffected by multiplier)",
	Callback = function()
        game:GetService("ReplicatedStorage").equipments.VoidBombremote:FireServer()
	end
})
local SpawnMultiInput = SocialTab:CreateInput({
   Name = "Spawn Multiplier",
   PlaceholderText = "1",
   RemoveTextAfterFocusLost = false,
   Flag = "SpawnMulti",
   Callback = function(Text)
      SpawnMulti = math.floor(tonumber(Text) or 0)
      SpawnMultiInput:SetValue(tostring(SpawnMulti))
   end
})
local KeybindsEnabled = false
local KeybindToggler KeybindsTab:CreateToggle({
   Name = "Keybinds",
   CurrentValue = false,
   Flag = "Keybinds",
   Callback = function(Value)
        KeybindsEnabled = not KeybindsEnabled
   end,
})
local HealKeybind = KeybindsTab:CreateKeybind({
   Name = "Heal Keybind",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "HealKeybind",
   Callback = function(Keybind)
    if KeybindsEnabled == true then
     for i = 1, 5 do
     game:GetService("ReplicatedStorage").equipments.BloxyColaremote:FireServer()
	 end
    end
   end,
})
local BananaKeybind = KeybindsTab:CreateKeybind({
   Name = "Banana Keybind",
   CurrentKeybind = "E",
   HoldToInteract = false,
   Flag = "BananaKeybind",
   Callback = function(Keybind)
    if KeybindsEnabled == true then
     for i = 1, SpawnMulti do
     game:GetService("ReplicatedStorage").equipments.BananaPeelremote:FireServer()
	 end
    end
   end,
})
local TrapKeybind = KeybindsTab:CreateKeybind({
   Name = "BearTrap Keybind",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Flag = "BearTrapsKeybind",
   Callback = function(Keybind)
    if KeybindsEnabled == true then
     for i = 1, SpawnMulti do
     game:GetService("ReplicatedStorage").equipments.Beartrapremote:FireServer()
	 end
    end
   end,
})
local GranadeKeybind = KeybindsTab:CreateKeybind({
   Name = "VoidBomb Keybind",
   CurrentKeybind = "G",
   HoldToInteract = false,
   Flag = "VoidBombKeybind",
   Callback = function(Keybind)
    if KeybindsEnabled == true then
     for i = 1, SpawnMulti do
     game:GetService("ReplicatedStorage").equipments.VoidBombremote:FireServer()
	 end
    end
   end,
})
local LoadIYButton = MiscTab:CreateButton({
	Name = "Load IY",
	Callback = function()
     loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end
})
local HealButton = MainTab:CreateButton({
	Name = "Heal",
	Callback = function()
     for i = 1, 5 do
      game:GetService("ReplicatedStorage").equipments.BloxyColaremote:FireServer()
	 end
	end
})
local GetFpsButtonDiamMeth = ServTab:CreateButton({
	Name = "Lag server (Diamond method)",
	Callback = function()
	while true do
		for i = 1, 100 do
			game:GetService("ReplicatedStorage").equipments.DiamondSackremote:FireServer()
		end
		wait(0.1)
	end
	end
})
local GetFpsButtonAuraMeth = ServTab:CreateButton({
	Name = "Lag server (Aura method)",
	Callback = function()
	while true do
		for i = 1, 100 do
			game:GetService("ReplicatedStorage").abilities.BlueHotSlap.Event:FireServer(unpack(args))
		end
		wait(0.1)
	end
	end
})
local GetFpsButtonBananaMeth = ServTab:CreateButton({
	Name = "Lag server (Banana method)",
	Callback = function()
	while true do
		for i = 1, 11111 do
			game:GetService("ReplicatedStorage").equipments.BananaPeelremote:FireServer()
		end
		wait(0.1)
	end
	end
})
local LoadIYButton = MiscTab:CreateButton({
	Name = "Get TPTool",
	Callback = function()
     local TpTool = Instance.new("Tool")
TpTool.Name = "Teleport Tool"
TpTool.RequiresHandle = false
TpTool.Parent = game.Players.LocalPlayer.Backpack

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local function getSafePosition(targetPos)
    local rayStart = targetPos + Vector3.new(0, 10, 0)
    local rayEnd = targetPos - Vector3.new(0, 5, 0)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    local result = workspace:Raycast(rayStart, rayEnd - rayStart, raycastParams)
    if result then
        return result.Position + Vector3.new(0, 3, 0)
    else
        return targetPos + Vector3.new(0, 2, 0)
    end
end
local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end
TpTool.Activated:Connect(function()
    local character = TpTool.Parent
    if not character then return end
    local root = getRoot(character)
    local pos = mouse.Hit
    if not root or not pos then return end
    local savedVelocity = root.AssemblyLinearVelocity
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.PlatformStand = true
        wait(0.05)
        humanoid.PlatformStand = false
        end
        local safePos = getSafePosition(pos.Position)

        root.CFrame = CFrame.new(safePos)

        root.AssemblyLinearVelocity = savedVelocity
       end)
	end
})
local walkflinging = false
local walkflingCoroutine = nil

local Walkfling = MainTab:CreateToggle({
   Name = "Walkfling",
   CurrentValue = false,
   Flag = "Walkfling",
   Callback = function(Value)
       local RunService = game:GetService("RunService")
       local player = game.Players.LocalPlayer
       
       local function getRoot(character)
           return character and character:FindFirstChild("HumanoidRootPart")
       end
       
       walkflinging = Value
       
       if Value then
           -- Если уже запущен поток, не создаём новый
           if walkflingCoroutine then return end
           
           walkflingCoroutine = coroutine.create(function()
               repeat
                   local character = player.Character
                   local root = getRoot(character)
                   local vel, movel = nil, 0.1
                   
                   while not (character and character.Parent and root and root.Parent) do
                       RunService.Heartbeat:Wait()
                       character = player.Character
                       root = getRoot(character)
                   end
                   
                   vel = root.Velocity
                   root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                   
                   RunService.RenderStepped:Wait()
                   if character and character.Parent and root and root.Parent then
                       root.Velocity = vel
                   end
                   
                   RunService.Stepped:Wait()
                   if character and character.Parent and root and root.Parent then
                       root.Velocity = vel + Vector3.new(0, movel, 0)
                       movel = movel * -1
                   end
                   
                   RunService.Heartbeat:Wait()
               until walkflinging == false
               
               walkflingCoroutine = nil
           end)
           coroutine.resume(walkflingCoroutine)
       else
           -- Выключаем: поток завершится на следующей итерации, потому что walkflinging стало false
           walkflingCoroutine = nil
       end
   end
})
local nameprotectsymbol = string.rep("雙", 1337)
local Nameprotect = MiscTab:CreateButton({
   Name = "Unload Data",
   Callback = function(Value)
local localPlayer = game.Players.LocalPlayer
local character = localPlayer.Character
local args = { [1] = string.rep(nameprotectsymbol, 64) }
game:GetService("ReplicatedStorage").SetAAttribute:FireServer(unpack(args))
character.Humanoid.Health = 0
   end
})
local Nameprotect = MiscTab:CreateButton({
   Name = "Name protect",
   Callback = function(Value)
local localPlayer = game.Players.LocalPlayer
local character = localPlayer.Character
local args = {
[1] = nameprotectsymbol,
}
game:GetService("ReplicatedStorage").SetAAttribute:FireServer(unpack(args))
character.Humanoid.Health = 0
   end
})
local Nameprotect = MiscTab:CreateInput({
Name = "Age Changer",
PlaceholderText = "67",
Callback = function(Value)
local localPlayer = game.Players.LocalPlayer
local character = localPlayer.Character
local args = {
[1] = Value,
}
game:GetService("ReplicatedStorage").SetAAttribute:FireServer(unpack(args))
character.Humanoid.Health = 0
   end
})
local InvicibilityGlitch = MainTab:CreateButton({
   Name = "Invincibility Glitch",
   Callback = function()
local localplayer = game:GetService("Players").LocalPlayer

-- Принудительно ждём персонажа, чтобы character.Humanoid существовал (это не проверка, а ожидание)
local character = localplayer.Character or localplayer.CharacterAdded:Wait()

local gender = localplayer.Data.Gender.Value  -- прямое обращение, без проверок
local gui = localplayer.PlayerGui.genderUI    -- прямое обращение

if gender == "None" then
    character.Humanoid.Health = 0   -- убиваем
    gui:Destroy()                   -- удаляем GUI (упадёт, если gui нет)
    game:GetService("ReplicatedStorage").SetAAttribute:FireServer("")  -- без проверок
    Rayfield:Notify({
        Title = "Success",
        Content = "Change your age in misc tab.",
        Duration = 6.5,
    })
else
    Rayfield:Notify({
        Title = "Error",
        Content = "Player is not in gender selection menu!",
        Duration = 6.5,
        Image = 4483362458,
    })
end
   end
})
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local antiTrapConn = nil
local antitrap = MainTab:CreateToggle({
    Name = "Удалять чужие TheTrap",
    CurrentValue = false,
    Callback = function(state)
        if state then
            for _, trap in ipairs(Workspace:GetChildren()) do
                if trap.Name == "TheTrap" then
                    local owner = trap:FindFirstChild("owner")
                    if owner and owner:IsA("StringValue") and owner.Value ~= LocalPlayer.Name then
                        trap:Destroy()
                    end
                end
            end
            -- Отслеживаем новые
            antiTrapConn = Workspace.ChildAdded:Connect(function(child)
                if child.Name == "TheTrap" then
                    local owner = child:FindFirstChild("Owner")
                    if owner and owner:IsA("StringValue") and owner.Value ~= LocalPlayer.Name then
                        child:Destroy()
                    end
                end
            end)
        else
            -- Выключаем отслеживание
            if antiTrapConn then
                antiTrapConn:Disconnect()
                antiTrapConn = nil
            end
        end
    end
})
Rayfield:LoadConfiguration()
