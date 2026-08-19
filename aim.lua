-- Mobile (iOS / Delta) bobdar (FIXED v2.47 - New Players ESP Fix)
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
    SmoothAim = true,      
    Smoothness = 5,        
    NoRecoil = true,        
    SpeedHack = false,      
    WalkSpeed = 24,         
    JumpMode = "High",      
    JumpForce = 50,         
    FOVRadius = 120,
    ESPColor = Color3.fromRGB(0, 255, 50)
}

-- **Minecraft Arcade Font**
local MinecraftFont = Enum.Font.Arcade

-- **Parent UI**
local ParentGui = LocalPlayer:WaitForChild("PlayerGui")
if ParentGui:FindFirstChild("DeltaMobileHub") then
    ParentGui.DeltaMobileHub:Destroy()
end
if ParentGui:FindFirstChild("DeviceSelectorGui") then
    ParentGui.DeviceSelectorGui:Destroy()
end

-- **Стартовое меню выбора устройства**
local SelectorGui = Instance.new("ScreenGui")
SelectorGui.Name = "DeviceSelectorGui"
SelectorGui.Parent = ParentGui
SelectorGui.ResetOnSpawn = false

local SelectorFrame = Instance.new("Frame")
SelectorFrame.Size = UDim2.new(0, 280, 0, 220)
SelectorFrame.Position = UDim2.new(0.5, -140, 0.4, -110)
SelectorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SelectorFrame.BackgroundTransparency = 0.1
SelectorFrame.Active = true
SelectorFrame.Draggable = true
SelectorFrame.Parent = SelectorGui

local SelCorner = Instance.new("UICorner")
SelCorner.CornerRadius = UDim.new(0, 10)
SelCorner.Parent = SelectorFrame

local SelStroke = Instance.new("UIStroke")
SelStroke.Parent = SelectorFrame
SelStroke.Color = Color3.fromRGB(0, 255, 150)
SelStroke.Thickness = 1.5

local SelTitle = Instance.new("TextLabel")
SelTitle.Size = UDim2.new(1, 0, 0, 45)
SelTitle.BackgroundTransparency = 1
SelTitle.Text = "SELECT YOUR DEVICE"
SelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SelTitle.Font = MinecraftFont
SelTitle.TextSize = 14
SelTitle.Parent = SelectorGui

local SelectorLayout = Instance.new("UIListLayout")
SelectorLayout.Parent = SelectorFrame
SelectorLayout.SortOrder = Enum.SortOrder.LayoutOrder
SelectorLayout.Padding = UDim.new(0, 10)
SelectorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SelTitle.LayoutOrder = 0

local menuSizes = {
    Phone = {mainSize = UDim2.new(0, 180, 0, 500), btnSize = UDim2.new(0, 45, 0, 45)},
    PC = {mainSize = UDim2.new(0, 220, 0, 500), btnSize = UDim2.new(0, 56, 0, 56)},
    Tablet = {mainSize = UDim2.new(0, 280, 0, 560), btnSize = UDim2.new(0, 70, 0, 70)}
}

local selectedConfig = menuSizes.PC

local function CreateDeviceBtn(text, order, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(0, 255, 150)
    btn.Font = MinecraftFont
    btn.TextSize = 13
    btn.Text = text
    btn.LayoutOrder = order
    btn.Parent = SelectorFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(onClick)
end

CreateDeviceBtn("📱 PHONE (Compact)", 1, function()
    selectedConfig = menuSizes.Phone
    SelectorGui:Destroy()
    StartMainHub()
end)

CreateDeviceBtn("💻 PC (Standard)", 2, function()
    selectedConfig = menuSizes.PC
    SelectorGui:Destroy()
    StartMainHub()
end)

CreateDeviceBtn("📱 TABLET (Large)", 3, function()
    selectedConfig = menuSizes.Tablet
    SelectorGui:Destroy()
    StartMainHub()
end)


-- **ОСНОВНОЙ ХАБ**
function StartMainHub()
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

    -- **2. Toggle Menu Button**
    local ToggleMenuBtn = Instance.new("ImageButton")
    local ToggleCorner = Instance.new("UICorner")
    local ToggleStroke = Instance.new("UIStroke")

    ToggleMenuBtn.Name = "ToggleMenuBtn"
    ToggleMenuBtn.Parent = ScreenGui
    ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleMenuBtn.Size = selectedConfig.btnSize
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
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(0, 255, 150)
    MainStroke.Thickness = 1.5

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "bobdar (FIXED ESP)"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = MinecraftFont
    TitleLabel.TextSize = 13
    TitleLabel.LayoutOrder = 0

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Position = UDim2.new(0.02, 0, 0.24, 0)
    MainFrame.Size = selectedConfig.mainSize
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Active = true
    MainFrame.Draggable = true

    ToggleMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- **Контейнер элементов меню**
    local Container = Instance.new("UIListLayout")
    Container.Parent = MainFrame
    Container.SortOrder = Enum.SortOrder.LayoutOrder
    Container.Padding = UDim.new(0, 6)
    Container.HorizontalAlignment = Enum.HorizontalAlignment.Center

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

    local itemOrder = 1
    local function CreateToggleButton(name, text, defaultState, onClick)
        local btn = Instance.new("TextButton")
        local corner = Instance.new("UICorner")
        
        btn.Name = name
        btn.Parent = MainFrame
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Font = MinecraftFont
        btn.TextSize = 12
        btn.Active = true
        btn.LayoutOrder = itemOrder
        itemOrder = itemOrder + 1
        
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

    -- **5. FOV Adjustment Controls**
    local FOVControlFrame = Instance.new("Frame")
    FOVControlFrame.Name = "FOVControlFrame"
    FOVControlFrame.Parent = MainFrame
    FOVControlFrame.Size = UDim2.new(0.9, 0, 0, 32)
    FOVControlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    FOVControlFrame.LayoutOrder = itemOrder
    itemOrder = itemOrder + 1

    local FOVControlCorner = Instance.new("UICorner")
    FOVControlCorner.CornerRadius = UDim.new(0, 6)
    FOVControlCorner.Parent = FOVControlFrame

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Parent = FOVControlFrame
    MinusBtn.Size = UDim2.new(0, 35, 1, 0)
    MinusBtn.BackgroundTransparency = 1
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    MinusBtn.Font = MinecraftFont
    MinusBtn.TextSize = 16

    local LayerPlusBtn = Instance.new("TextButton")
    LayerPlusBtn.Parent = FOVControlFrame
    LayerPlusBtn.Size = UDim2.new(0, 35, 1, 0)
    LayerPlusBtn.Position = UDim2.new(1, -35, 0, 0)
    LayerPlusBtn.BackgroundTransparency = 1
    LayerPlusBtn.Text = "+"
    LayerPlusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    LayerPlusBtn.Font = MinecraftFont
    LayerPlusBtn.TextSize = 16

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

    LayerPlusBtn.MouseButton1Click:Connect(function()
        if Settings.FOVRadius < 350 then
            Settings.FOVRadius = Settings.FOVRadius + 10
            FOVValLabel.Text = "FOV: " .. Settings.FOVRadius
            UpdateFOVSize()
        end
    end)

    -- **6. SMOOTHNESS SLIDER**
    local SmoothFrame = Instance.new("Frame")
    SmoothFrame.Name = "SmoothFrame"
    SmoothFrame.Parent = MainFrame
    SmoothFrame.Size = UDim2.new(0.9, 0, 0, 42)
    SmoothFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SmoothFrame.LayoutOrder = itemOrder
    itemOrder = itemOrder + 1

    local SmoothCorner = Instance.new("UICorner")
    SmoothCorner.CornerRadius = UDim.new(0, 6)
    SmoothCorner.Parent = SmoothFrame

    local SmoothLabel = Instance.new("TextLabel")
    SmoothLabel.Parent = SmoothFrame
    SmoothLabel.Size = UDim2.new(1, 0, 0, 20)
    SmoothLabel.BackgroundTransparency = 1
    SmoothLabel.Text = "Smooth (Weight): " .. Settings.Smoothness
    SmoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SmoothLabel.Font = MinecraftFont
    SmoothLabel.TextSize = 11

    local BarBg = Instance.new("Frame")
    BarBg.Parent = SmoothFrame
    BarBg.Size = UDim2.new(0.8, 0, 0, 6)
    BarBg.Position = UDim2.new(0.1, 0, 0, 26)
    BarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(1, 0)
    BarBgCorner.Parent = BarBg

    local BarFill = Instance.new("Frame")
    BarFill.Parent = BarBg
    BarFill.Size = UDim2.new(Settings.Smoothness / 10, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(1, 0)
    BarFillCorner.Parent = BarFill

    local SmoothMinus = Instance.new("TextButton")
    SmoothMinus.Parent = SmoothFrame
    SmoothMinus.Size = UDim2.new(0, 25, 0, 20)
    SmoothMinus.Position = UDim2.new(0, 2, 0, 20)
    SmoothMinus.BackgroundTransparency = 1
    SmoothMinus.Text = "<"
    SmoothMinus.TextColor3 = Color3.fromRGB(255, 100, 100)
    SmoothMinus.Font = MinecraftFont
    SmoothMinus.TextSize = 14

    local SmoothPlus = Instance.new("TextButton")
    SmoothPlus.Parent = SmoothFrame
    SmoothPlus.Size = UDim2.new(0, 25, 0, 20)
    SmoothPlus.Position = UDim2.new(1, -27, 0, 20)
    SmoothPlus.BackgroundTransparency = 1
    SmoothPlus.Text = ">"
    SmoothPlus.TextColor3 = Color3.fromRGB(100, 255, 100)
    SmoothPlus.Font = MinecraftFont
    SmoothPlus.TextSize = 14

    local function UpdateSmoothDisplay()
        SmoothLabel.Text = "Smooth (Weight): " .. Settings.Smoothness
        BarFill.Size = UDim2.new(Settings.Smoothness / 10, 0, 1, 0)
    end

    SmoothMinus.MouseButton1Click:Connect(function()
        if Settings.Smoothness > 1 then
            Settings.Smoothness = Settings.Smoothness - 1
            UpdateSmoothDisplay()
        end
    end)

    SmoothPlus.MouseButton1Click:Connect(function()
        if Settings.Smoothness < 10 then
            Settings.Smoothness = Settings.Smoothness + 1
            UpdateSmoothDisplay()
        end
    end)

    -- **7. ПРЫЖКИ**
    UserInputService.JumpRequest:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if root and hum then
            if Settings.JumpMode == "High" then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, Settings.JumpForce, root.AssemblyLinearVelocity.Z)
            elseif Settings.JumpMode == "Infinite" then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 50, root.AssemblyLinearVelocity.Z)
            end
        end
    end)

    -- **8. Кнопки меню**
    CreateToggleButton("ESPBtn", "Wallhack ESP", Settings.ESP, function()
        Settings.ESP = not Settings.ESP
        return Settings.ESP
    end)

    CreateToggleButton("ItemBtn", "Player Item ESP", Settings.ItemESP, function()
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

    CreateToggleButton("SmoothAimBtn", "Smooth Aim", Settings.SmoothAim, function()
        Settings.SmoothAim = not Settings.SmoothAim
        return Settings.SmoothAim
    end)

    CreateToggleButton("RecoilBtn", "No Recoil", Settings.NoRecoil, function()
        Settings.NoRecoil = not Settings.NoRecoil
        return Settings.NoRecoil
    end)

    CreateToggleButton("SpeedBtn", "Speed Hack", Settings.SpeedHack, function()
        Settings.SpeedHack = not Settings.SpeedHack
        return Settings.SpeedHack
    end)

    local JumpModeNames = {Off = "OFF", High = "HIGH (50)", Infinite = "INFINITE"}
    local JumpModeBtn = Instance.new("TextButton")
    local JumpModeCorner = Instance.new("UICorner")

    JumpModeBtn.Name = "JumpModeBtn"
    JumpModeBtn.Parent = MainFrame
    JumpModeBtn.Size = UDim2.new(0.9, 0, 0, 32)
    JumpModeBtn.Font = MinecraftFont
    JumpModeBtn.TextSize = 11
    JumpModeBtn.Active = true
    JumpModeBtn.LayoutOrder = itemOrder
    itemOrder = itemOrder + 1

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
        if Settings.JumpMode == "Off" then Settings.JumpMode = "High"
        elseif Settings.JumpMode == "High" then Settings.JumpMode = "Infinite"
        else Settings.JumpMode = "Off" end
        UpdateJumpModeAppearance()
    end)

    -- **9. ФУНКЦИЯ down time (ПУСТАЯ)**
    local function down_time()
        -- Содержимое удалено, функция отключена
    end

    -- **10. ФИКС ESP ИГРОКОВ (Автоматическое отслеживание новых игроков)**
    local function GetEquippedItem(character)
        if not character then return "None" end
        local tool = character:FindFirstChildOfClass("Tool")
        return tool and tool.Name or "Fists"
    end

    local function SetupCharacter(player, character)
        if not character then return end
        
        -- Ждем появления головы и гуманоида (если игрок только зашел)
        local head = character:WaitForChild("Head", 5)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not head or not humanoid then return end

        -- Удаляем старую подсветку, если она осталась
        if character:FindFirstChild("iOS_Highlight") then
            character.iOS_Highlight:Destroy()
        end
        if head:FindFirstChild("iOS_ItemESP") then
            head.iOS_ItemESP:Destroy()
        end

        -- Создаем Wallhack (Highlight)
        local highlight = Instance.new("Highlight")
        highlight.Name = "iOS_Highlight"
        highlight.Parent = character
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Settings.ESPColor
        highlight.FillTransparency = 0.6
        highlight.Enabled = Settings.ESP

        -- Создаем текст (Имя, Оружие, HP) над головой
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "iOS_ItemESP"
        billboard.Parent = head
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
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
                task.wait(0.3)
            end
            if billboard then billboard:Destroy() end
            if highlight then highlight:Destroy() end
        end)
    end

    local function ApplyESPToPlayer(player)
        if player == LocalPlayer then return end

        -- Если у игрока уже есть персонаж
        if player.Character then
            task.spawn(function()
                SetupCharacter(player, player.Character)
            end)
        end

        -- Следим за его новыми респаунами (возрождениями)
        player.CharacterAdded:Connect(function(newChar)
            task.spawn(function()
                SetupCharacter(player, newChar)
            end)
        end)
    end

    -- Подключаем всех текущих игроков
    for _, player in pairs(Players:GetPlayers()) do
        ApplyESPToPlayer(player)
    end

    -- Важно: автоматический перехват при подключении НОВЫХ игроков на сервер
    Players.PlayerAdded:Connect(function(newPlayer)
        ApplyESPToPlayer(newPlayer)
    end)

    -- **11. Auto Aim с плавным сглаживанием**
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
                local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                if Settings.SmoothAim then
                    local smoothnessFactor = math.clamp(Settings.Smoothness * 1.5, 1, 20)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smoothnessFactor)
                else
                    Camera.CFrame = targetCFrame
                end
            end
        end
        
        if Settings.SpeedHack then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = Settings.WalkSpeed end
            end
        end
    end)

    -- **12. No Recoil**
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
end
