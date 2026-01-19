local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Speed = 50
local SpeedEnabled = false
local Dragging = false
local DragStart, StartPos

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame
TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "CFrame Speed"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -20, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 40)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBox.Text = "50"
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.Parent = Frame

local UICorner2 = UICorner:Clone()
UICorner2.Parent = SpeedBox

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 80)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Text = "CFRAME"
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = Frame

local UICorner3 = UICorner:Clone()
UICorner3.Parent = ToggleButton
Frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
Dragging = true
DragStart = input.Position
StartPos = Frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
Dragging = false
end
end)
end
end)

Frame.InputChanged:Connect(function(input)
if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local Delta = input.Position - DragStart
Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
end
end)
local function SpeedControl()
while SpeedEnabled do
RunService.RenderStepped:Wait()
if Character and Character:FindFirstChild("HumanoidRootPart") then
local MoveDirection = Character.Humanoid.MoveDirection
if MoveDirection.Magnitude > 0 then
Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + MoveDirection * Speed / 10
end
end
end
end

ToggleButton.MouseButton1Click:Connect(function()
SpeedEnabled = not SpeedEnabled
ToggleButton.Text = SpeedEnabled and "🟢" or "🔴"
if SpeedEnabled then
SpeedControl()
end
end)

SpeedBox.FocusLost:Connect(function(enterPressed)
if enterPressed then
local NewSpeed = tonumber(SpeedBox.Text)
if NewSpeed and NewSpeed > 0 then
Speed = NewSpeed
else
SpeedBox.Text = tostring(Speed)
end
end
end)

--// Toggle GUI
local ToggleGuiButton = Instance.new("TextButton")
ToggleGuiButton.Size = UDim2.new(0, 100, 0, 30)
ToggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
ToggleGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleGuiButton.Text = "Hide"
ToggleGuiButton.Font = Enum.Font.Gotham
ToggleGuiButton.TextSize = 14
ToggleGuiButton.TextColor3 = Color3.new(1, 1, 1)
ToggleGuiButton.Parent = ScreenGui

local UICorner4 = UICorner:Clone()
UICorner4.Parent = ToggleGuiButton

local GuiVisible = true
ToggleGuiButton.MouseButton1Click:Connect(function()
GuiVisible = not GuiVisible
Frame.Visible = GuiVisible
ToggleGuiButton.Text = GuiVisible and "Hide" or "Show"
end)
LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
Character = NewCharacter
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
if SpeedEnabled then
SpeedControl()
end
end)
