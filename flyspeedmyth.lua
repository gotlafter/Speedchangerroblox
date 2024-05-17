local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local SpeedButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local ResetButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Transparency = 0.5
Frame.Position = UDim2.new(0.5, -100, 0.5, -110)
Frame.Size = UDim2.new(0, 200, 0, 240)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame


TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BackgroundTransparency = 0.5
TextBox.Position = UDim2.new(0.1, 0, 0.1, 0)
TextBox.Size = UDim2.new(0.8, 0, 0.15, 0)
TextBox.PlaceholderText = "Enter Speed"
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BorderSizePixel = 0

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 6)
TextBoxCorner.Parent = TextBox

SpeedButton.Parent = Frame
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
SpeedButton.BackgroundTransparency = 0.5
SpeedButton.Position = UDim2.new(0.1, 0, 0.3, 0)
SpeedButton.Size = UDim2.new(0.8, 0, 0.15, 0)
SpeedButton.Text = "Set Speed"
SpeedButton.TextScaled = true
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.BorderSizePixel = 0

local SpeedButtonCorner = Instance.new("UICorner")
SpeedButtonCorner.CornerRadius = UDim.new(0, 6)
SpeedButtonCorner.Parent = SpeedButton

ResetButton.Parent = Frame
ResetButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ResetButton.BackgroundTransparency = 0.5
ResetButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ResetButton.Size = UDim2.new(0.8, 0, 0.15, 0)
ResetButton.Text = "Reset Speed"
ResetButton.TextScaled = true
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.BorderSizePixel = 0

local ResetButtonCorner = Instance.new("UICorner")
ResetButtonCorner.CornerRadius = UDim.new(0, 6)
ResetButtonCorner.Parent = ResetButton

FlyButton.Parent = Frame
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
FlyButton.BackgroundTransparency = 0.5
FlyButton.Position = UDim2.new(0.1, 0, 0.7, 0)
FlyButton.Size = UDim2.new(0.8, 0, 0.15, 0)
FlyButton.Text = "Toggle Fly"
FlyButton.TextScaled = true
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.BorderSizePixel = 0

local FlyButtonCorner = Instance.new("UICorner")
FlyButtonCorner.CornerRadius = UDim.new(0, 6)
FlyButtonCorner.Parent = FlyButton

TextLabel.Parent = Frame
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 0, 1, -30)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Text = "Close/Open is RightControl"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local isFlying = false
local connection

local function startFlying()
    local SpeedKey = Enum.KeyCode.LeftShift

    local SpeedKeyMultiplier = 5
    local FlightSpeed = 250
    local FlightAcceleration = 4
    local TurnSpeed = 16

    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local User = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local UserCharacter = User.Character or User.CharacterAdded:Wait()
    local UserRootPart = UserCharacter:WaitForChild("HumanoidRootPart")

    local CurrentVelocity = Vector3.new(0,0,0)
    local function flight(delta)
        local BaseVelocity = Vector3.new(0,0,0)
        if not UserInputService:GetFocusedTextBox() then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                BaseVelocity = BaseVelocity + (Camera.CFrame.LookVector * FlightSpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                BaseVelocity = BaseVelocity - (Camera.CFrame.RightVector * FlightSpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                BaseVelocity = BaseVelocity - (Camera.CFrame.LookVector * FlightSpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                BaseVelocity = BaseVelocity + (Camera.CFrame.RightVector * FlightSpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                BaseVelocity = BaseVelocity + (Camera.CFrame.UpVector * FlightSpeed)
            end
            if UserInputService:IsKeyDown(SpeedKey) then
                BaseVelocity = BaseVelocity * SpeedKeyMultiplier
            end
        end
        if UserRootPart then
            local car = UserRootPart:GetRootPart()
            if car.Anchored then return end
            CurrentVelocity = CurrentVelocity:Lerp(
                BaseVelocity,
                math.clamp(delta * FlightAcceleration, 0, 1)
            )
            car.Velocity = CurrentVelocity + Vector3.new(0,2,0)
            if car ~= UserRootPart then
                car.RotVelocity = Vector3.new(0,0,0)
                car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
                    car.Position,
                    car.Position + CurrentVelocity + Camera.CFrame.LookVector
                ), math.clamp(delta * TurnSpeed, 0, 1))
            end
        end
    end

    connection = RunService.Heartbeat:Connect(flight)
end

local function stopFlying()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

local function toggleFly()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
    isFlying = not isFlying
end

local function setSpeed()
    local speed = tonumber(TextBox.Text)
    if speed then
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = speed
    end
end

local function resetSpeed()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16
end

local function FadeIn()
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local tweens = {}

    tweens.Frame = TweenService:Create(Frame, tweenInfo, { BackgroundTransparency = 0.5 })
    tweens.TextBox = TweenService:Create(TextBox, tweenInfo, { BackgroundTransparency = 0.5 })
    tweens.SpeedButton = TweenService:Create(SpeedButton, tweenInfo, { BackgroundTransparency = 0.5 })
    tweens.ResetButton = TweenService:Create(ResetButton, tweenInfo, { BackgroundTransparency = 0.5 })
    tweens.FlyButton = TweenService:Create(FlyButton, tweenInfo, { BackgroundTransparency = 0.5 })

    for _, tween in pairs(tweens) do
        tween:Play()
    end
end

local function FadeOut()
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    local tweens = {}

    tweens.Frame = TweenService:Create(Frame, tweenInfo, { BackgroundTransparency = 1 })
    tweens.TextBox = TweenService:Create(TextBox, tweenInfo, { BackgroundTransparency = 1 })
    tweens.SpeedButton = TweenService:Create(SpeedButton, tweenInfo, { BackgroundTransparency = 1 })
    tweens.ResetButton = TweenService:Create(ResetButton, tweenInfo, { BackgroundTransparency = 1 })
    tweens.FlyButton = TweenService:Create(FlyButton, tweenInfo, { BackgroundTransparency = 1 })

    for _, tween in pairs(tweens) do
        tween:Play()
    end
end

local isGuiVisible = true

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        if isGuiVisible then
            FadeOut()
            wait(0.1)
            Frame.Visible = false
            isGuiVisible = false
        else
            Frame.Visible = true
            FadeIn()
            isGuiVisible = true
        end
    end
end)

FlyButton.MouseButton1Click:Connect(toggleFly)
SpeedButton.MouseButton1Click:Connect(setSpeed)
ResetButton.MouseButton1Click:Connect(resetSpeed)
