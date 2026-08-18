-- Mobile (iOS / Delta) bobdar (FIXED) v2.34 - Full Version (English)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- **Global Settings State**
local Settings = {
    ESP = true,
    ItemESP = true,
    FOV = true,
    Aim = false,
    NoRecoil = true,       -- No Recoil & Perfect Accuracy
    SpeedHack = false,     -- Extra Feature: Speed Boost
    WalkSpeed = 24,        -- Custom WalkSpeed value
    JumpMode = "High",     -- Modes: "Off", "High", "Infinite"
    JumpForce = 60,        -- Jump force
    FOVRadius = 120,
    ESPColor = Color3.fromRGB(0, 255, 50) -- Green ESP Highlight
}

-- **Minecraft Arcade Font**
local MinecraftFont = Enum.Font.Arcade

-- **Parent UI**
local ParentGui = LocalPlayer:WaitForChild("PlayerGui")
if ParentGui:FindFirstChild("DeltaMobileHub") then
    ParentGui.DeltaMobileHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMobileHub"
ScreenGui.Parent = ParentGui
ScreenGui.ResetOnSpawn = false

-- **1. FPS and Ping Widget**
local StatsFrame = Instance.new("Frame")
local StatsCorner = Instance.new("UICorner")
local StatsStroke = Instance.new("UIStroke")
local StatsLabel = Instance.new("TextLabel")

StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = ScreenGui
StatsFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
StatsFrame.Size = UDim2.new(0, 160, 0, 28)
StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatsFrame.BackgroundTransparency = 0.2
StatsFrame.Active = true
StatsFrame.Draggable = true

StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

StatsStroke.Parent = StatsFrame
StatsStroke.Color = Color3.fromRGB(0, 255, 150)
StatsStroke.Thickness = 1

StatsLabel.Name = "StatsLabel"
StatsLabel.Parent = StatsFrame
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "FPS: ... | Ping: ..."
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatsLabel.Font = MinecraftFont
StatsLabel.TextSize = 14

local FrameCount = 0
local LastUpdate = tick()

RunService.RenderStepped:Connect(function()
    FrameCount = FrameCount + 1
    local now = tick()
    if now - LastUpdate >= 0.5 then
        local fps = math.floor(FrameCount / (now - LastUpdate))
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        StatsLabel.Text = string.format("FPS: %d | Ping: %dms", fps, ping)
        FrameCount = 0
        LastUpdate = now
    end
end)

-- **2. Toggle Menu Button (ImageButton)**
local ToggleMenuBtn = Instance.new("ImageButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")

ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Parent = ScreenGui
ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleMenuBtn.Size = UDim2.new(0, 56, 0, 56)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleMenuBtn.Image = "rbxassetid://152648714"
ToggleMenuBtn.Active = true
ToggleMenuBtn.Draggable = true

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleMenuBtn

ToggleStroke.Parent = ToggleMenuBtn
ToggleStroke.Color = Color3.fromRGB(0, 255, 150)
ToggleStroke.Thickness = 1.5

-- **3. Main Menu Frame**
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local TitleLabel = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.02, 0, 0.24, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 410)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Thickness = 1.5

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "bobdar (FIXED) v2.34"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = MinecraftFont
TitleLabel.TextSize = 13

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Container = Instance.new("UIListLayout")
Container.Parent = MainFrame
Container.SortOrder = Enum.SortOrder.LayoutOrder
Container.Padding = UDim.new(0, 6)
Container.HorizontalAlignment = Enum.HorizontalAlignment.Center

TitleLabel.LayoutOrder = 0

-- **4. FOV Circle**
local FOVFrame = Instance.new("Frame")
local FOVCorner = Instance.new("UICorner")
local FOVStroke = Instance.new("UIStroke")

FOVFrame.Name = "FOVCircle"
FOVFrame.Parent = ScreenGui
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = Settings.FOV

FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

FOVStroke.Parent = FOVFrame
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 2

local function UpdateFOVSize()
    FOVFrame.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
end

local function CreateToggleButton(name, text, defaultState, onClick)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    
    btn.Name = name
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Font = MinecraftFont
    btn.TextSize = 12
    btn.Active = true
    
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local function UpdateAppearence(state)
        if state then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    UpdateAppearence(defaultState)
    btn.MouseButton1Click:Connect(function()
        local newState = onClick()
        UpdateAppearence(newState)
    end)
end

-- **5. FOV Adjustment Controls ( - / + )**
local FOVControlFrame = Instance.new("Frame")
FOVControlFrame.Name = "FOVControlFrame"
FOVControlFrame.Parent = MainFrame
FOVControlFrame.Size = UDim2.new(0.9, 0, 0, 32)
FOVControlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local FOVControlCorner = Instance.new("UICorner")
FOVControlCorner.CornerRadius = UDim.new(0, 6)
FOVControlCorner.Parent = FOVControlFrame

local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = FOVControlFrame
MinusBtn.Size = UDim2.new(0, 35, 1, 0)
MinusBtn.Position = UDim2.new(0, 0, 0, 0)
MinusBtn.BackgroundTransparency = 1
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
MinusBtn.Font = MinecraftFont
MinusBtn.TextSize = 16

local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = FOVControlFrame
PlusBtn.Size = UDim2.new(0, 35, 1, 0)
PlusBtn.Position = UDim2.new(1, -35, 0, 0)
PlusBtn.BackgroundTransparency = 1
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
PlusBtn.Font = MinecraftFont
PlusBtn.TextSize = 16

local FOVValLabel = Instance.new("TextLabel")
FOVValLabel.Parent = FOVControlFrame
FOVValLabel.Size = UDim2.new(1, -70, 1, 0)
FOVValLabel.Position = UDim2.new(0, 35, 0, 0)
FOVValLabel.BackgroundTransparency = 1
FOVValLabel.Text = "FOV: " .. Settings.FOVRadius
FOVValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVValLabel.Font = MinecraftFont
FOVValLabel.TextSize = 12

MinusBtn.MouseButton1Click:Connect(function()
    if Settings.FOVRadius > 30 then
        Settings.FOVRadius = Settings.FOVRadius - 10
        FOVValLabel.Text = "FOV: " .. Settings.FOVRadius
        UpdateFOVSize()
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    if Settings.FOVRadius < 350 then
        Settings.FOVRadius = Settings.FOVRadius + 10
        FOVValLabel.Text = "FOV: " .. Settings.FOVRadius
        UpdateFOVSize()
    end
end)

-- **6. Jump Mechanics Logic**
local function HookSmoothJump()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if hum and root then
        hum.Jumping:Connect(function()
            if Settings.JumpMode == "High" then
                task.wait(0.02)
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    Settings.JumpForce,
                    root.AssemblyLinearVelocity.Z
                )
            end
        end)
    end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.JumpMode == "Infinite" then
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    Settings.JumpForce,
                    root.AssemblyLinearVelocity.Z
                )
            end
        end
    end
end)

if LocalPlayer.Character then HookSmoothJump() end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    HookSmoothJump()
end)

-- **7. Menu Toggle Buttons Setup**
CreateToggleButton("ESPBtn", "Wallhack ESP", Settings.ESP, function()
    Settings.ESP = not Settings.ESP
    return Settings.ESP
end)

CreateToggleButton("ItemBtn", "Item ESP", Settings.ItemESP, function()
    Settings.ItemESP = not Settings.ItemESP
    return Settings.ItemESP
end)

CreateToggleButton("FOVBtn", "FOV Circle", Settings.FOV, function()
    Settings.FOV = not Settings.FOV
    FOVFrame.Visible = Settings.FOV
    return Settings.FOV
end)

CreateToggleButton("AimBtn", "Auto Aim", Settings.Aim, function()
    Settings.Aim = not Settings.Aim
    return Settings.Aim
end)

CreateToggleButton("RecoilBtn", "No Recoil", Settings.NoRecoil, function()
    Settings.NoRecoil = not Settings.NoRecoil
    return Settings.NoRecoil
end)

CreateToggleButton("SpeedBtn", "Speed Hack", Settings.SpeedHack, function()
    Settings.SpeedHack = not Settings.SpeedHack
    return Settings.SpeedHack
end)

-- Jump Mode Switcher Button
local JumpModeNames = {Off = "OFF", High = "HIGH (60)", Infinite = "INFINITE"}
local JumpModeBtn = Instance.new("TextButton")
local JumpModeCorner = Instance.new("UICorner")

JumpModeBtn.Name = "JumpModeBtn"
JumpModeBtn.Parent = MainFrame
JumpModeBtn.Size = UDim2.new(0.9, 0, 0, 32)
JumpModeBtn.Font = MinecraftFont
JumpModeBtn.TextSize = 11
JumpModeBtn.Active = true

JumpModeCorner.CornerRadius = UDim.new(0, 6)
JumpModeCorner.Parent = JumpModeBtn

local function UpdateJumpModeAppearance()
    JumpModeBtn.Text = "JUMP: " .. (JumpModeNames[Settings.JumpMode] or "OFF")
    if Settings.JumpMode == "Off" then
        JumpModeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        JumpModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        JumpModeBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        JumpModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

UpdateJumpModeAppearance()

JumpModeBtn.MouseButton1Click:Connect(function()
    if Settings.JumpMode == "Off" then
        Settings.JumpMode = "High"
    elseif Settings.JumpMode == "High" then
        Settings.JumpMode = "Infinite"
    else
        Settings.JumpMode = "Off"
    end
    UpdateJumpModeAppearance()
end)

-- **8. ESP & Items Logic**
local function GetEquippedItem(character)
    if not character then return "None" end
    local tool = character:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "Fists"
end

local function ApplyESP(player)
    if player == LocalPlayer then return end

    local function SetupCharacter(character)
        if not character then return end
        
        local head = character:WaitForChild("Head", 4)
        local humanoid = character:WaitForChild("Humanoid", 4)
        if not head or not humanoid then return end

        local highlight = character:FindFirstChild("iOS_Highlight") or Instance.new("Highlight")
        highlight.Name = "iOS_Highlight"
        highlight.Parent = character
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Settings.ESPColor
        highlight.FillTransparency = 0.6
        highlight.Enabled = Settings.ESP

        local billboard = head:FindFirstChild("iOS_ItemESP") or Instance.new("BillboardGui")
        billboard.Name = "iOS_ItemESP"
        billboard.Parent = head
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true

        local textLabel = billboard:FindFirstChild("ESPText") or Instance.new("TextLabel")
        textLabel.Name = "ESPText"
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = MinecraftFont
        textLabel.TextSize = 11

        task.spawn(function()
            while character and character.Parent and humanoid.Health > 0 do
                highlight.Enabled = Settings.ESP
                billboard.Enabled = Settings.ESP or Settings.ItemESP

                local itemText = Settings.ItemESP and ("[ " .. GetEquippedItem(character) .. " ]") or ""
                local hpText = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                
                textLabel.Text = string.format("%s\n%s\n%s", player.Name, itemText, hpText)
                task.wait(0.2)
            end
            if billboard then billboard:Destroy() end
            if highlight then highlight:Destroy() end
        end)
    end

    if player.Character then SetupCharacter(player.Character) end
    player.CharacterAdded:Connect(SetupCharacter)
end

for _, player in pairs(Players:GetPlayers()) do ApplyESP(player) end
Players.PlayerAdded:Connect(ApplyESP)

-- **9. Auto Aim Logic**
local function GetClosestTarget()
    local NearestTarget = nil
    local ShortestDistance = Settings.FOVRadius
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            if humanoid and humanoid.Health > 0 and head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - ScreenCenter).Magnitude
                    if dist < ShortestDistance then
                        ShortestDistance = dist
                        NearestTarget = head
                    end
                end
            end
        end
    end
    return NearestTarget
end

RunService.RenderStepped:Connect(function()
    if Settings.Aim then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    
    if Settings.SpeedHack then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.WalkSpeed
            end
        end
    end
end)

-- **10. No Recoil & Perfect Weapon Accuracy Logic**
RunService.Heartbeat:Connect(function()
    if Settings.NoRecoil then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("DoubleConstrainedValue") then
                            local name = v.Name:lower()
                            if name:find("recoil") or name:find("spread") or name:find("shake") or name:find("accuracy") then
                                v.Value = 0
                            end
                        end
                    end
                end)
            end
        end
    end
end)
