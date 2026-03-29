--[[
    LUNARSHELL HUB - Script Library
    Tema: Monocromático Minimalista
    Versão: 2.2 (completa)
--]]

local LunarShell = {}

-- ============================================
-- CONFIGURAÇÕES
-- ============================================

local Config = {
    Theme = {
        Background = Color3.fromRGB(8, 8, 12),
        Surface = Color3.fromRGB(18, 18, 24),
        SurfaceHover = Color3.fromRGB(28, 28, 36),
        SurfaceActive = Color3.fromRGB(38, 38, 46),
        Primary = Color3.fromRGB(80, 80, 100),
        PrimaryDark = Color3.fromRGB(60, 60, 80),
        Text = Color3.fromRGB(245, 245, 250),
        TextSecondary = Color3.fromRGB(160, 160, 175),
        TextMuted = Color3.fromRGB(100, 100, 120),
        Border = Color3.fromRGB(45, 45, 55),
        Accent = Color3.fromRGB(100, 100, 130),
        Success = Color3.fromRGB(70, 100, 70),
        Danger = Color3.fromRGB(120, 80, 80),
        Warning = Color3.fromRGB(120, 100, 70),
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Medium = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
    },
    Sizes = {
        Small = 11,
        Medium = 13,
        Large = 16,
        Title = 20,
        Huge = 28,
    },
    Animations = {
        Speed = 0.2,
    },
    Settings = {
        ToggleKey = Enum.KeyCode.P,
        SaveEnabled = true,
    }
}

-- ============================================
-- UTILIDADES
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function CreateCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
    return corner
end

local function CreateStroke(frame, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Config.Theme.Border
    stroke.Parent = frame
    return stroke
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or Config.Animations.Speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local SavedData = {
    KeyValidated = false,
    Settings = {},
    ScriptsState = {}
}

local function SaveData()
    if not Config.Settings.SaveEnabled then return end
    _G.LunarShellData = {
        KeyValidated = SavedData.KeyValidated,
        Settings = SavedData.Settings,
        ScriptsState = SavedData.ScriptsState
    }
end

local function LoadData()
    if _G.LunarShellData then
        SavedData.KeyValidated = _G.LunarShellData.KeyValidated or false
        SavedData.Settings = _G.LunarShellData.Settings or {}
        SavedData.ScriptsState = _G.LunarShellData.ScriptsState or {}
    end
end

-- ============================================
-- LOADING SCREEN
-- ============================================

local function CreateLoadingScreen(parent, message, duration, callback)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.Parent = parent
    overlay.ZIndex = 100
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 280, 0, 120)
    loadingFrame.Position = UDim2.new(0.5, -140, 0.5, -60)
    loadingFrame.BackgroundColor3 = Config.Theme.Surface
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = overlay
    loadingFrame.ZIndex = 101
    CreateCorner(loadingFrame, 12)
    CreateStroke(loadingFrame, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = message or "Carregando..."
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.TextSize = Config.Sizes.Medium
    titleLabel.Font = Config.Fonts.Bold
    titleLabel.Parent = loadingFrame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0.8, 0, 0, 4)
    progressBg.Position = UDim2.new(0.1, 0, 0.7, 0)
    progressBg.BackgroundColor3 = Config.Theme.SurfaceHover
    progressBg.BorderSizePixel = 0
    progressBg.Parent = loadingFrame
    CreateCorner(progressBg, 2)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Config.Theme.Accent
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    CreateCorner(progressFill, 2)
    
    local dots = Instance.new("TextLabel")
    dots.Size = UDim2.new(1, 0, 0, 20)
    dots.Position = UDim2.new(0, 0, 0.85, 0)
    dots.BackgroundTransparency = 1
    dots.Text = "●  ●  ●"
    dots.TextColor3 = Config.Theme.TextMuted
    dots.TextSize = 12
    dots.Font = Config.Fonts.Regular
    dots.Parent = loadingFrame
    
    local step = 0
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        step = step + dt * 2
        if step >= 1 then step = 1 end
        progressFill.Size = UDim2.new(step, 0, 1, 0)
        
        local dotCount = math.floor(step * 3) % 3 + 1
        local dotString = ""
        for i = 1, 3 do
            if i <= dotCount then
                dotString = dotString .. "●  "
            else
                dotString = dotString .. "○  "
            end
        end
        dots.Text = dotString
        
        if step >= 1 then
            connection:Disconnect()
            task.wait(duration or 0.5)
            Tween(overlay, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            overlay:Destroy()
            if callback then callback() end
        end
    end)
    
    return overlay
end

-- ============================================
-- TELA DE KEY
-- ============================================

local function CreateKeyScreen(parent, onSuccess, validKeys)
    validKeys = validKeys or {"LUNAR2024", "SHELL2024", "FREE2024"}
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.9
    overlay.BorderSizePixel = 0
    overlay.Parent = parent
    overlay.ZIndex = 200
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 360, 0, 320)
    keyFrame.Position = UDim2.new(0.5, -180, 0.5, -160)
    keyFrame.BackgroundColor3 = Config.Theme.Surface
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = overlay
    keyFrame.ZIndex = 201
    CreateCorner(keyFrame, 20)
    CreateStroke(keyFrame, 1)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 70, 0, 70)
    icon.Position = UDim2.new(0.5, -35, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "🌙"
    icon.TextColor3 = Config.Theme.Accent
    icon.TextSize = 56
    icon.Font = Config.Fonts.Regular
    icon.Parent = keyFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 35)
    title.Position = UDim2.new(0, 20, 0, 100)
    title.BackgroundTransparency = 1
    title.Text = "LUNARSHELL HUB"
    title.TextColor3 = Config.Theme.Text
    title.TextSize = Config.Sizes.Huge
    title.Font = Config.Fonts.Bold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = keyFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 140)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Insira a chave de ativação"
    subtitle.TextColor3 = Config.Theme.TextSecondary
    subtitle.TextSize = Config.Sizes.Small
    subtitle.Font = Config.Fonts.Regular
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = keyFrame
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -40, 0, 44)
    inputFrame.Position = UDim2.new(0, 20, 0, 175)
    inputFrame.BackgroundColor3 = Config.Theme.Background
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = keyFrame
    CreateCorner(inputFrame, 8)
    CreateStroke(inputFrame, 1)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Chave de ativação"
    keyInput.Text = ""
    keyInput.TextColor3 = Config.Theme.Text
    keyInput.PlaceholderColor3 = Config.Theme.TextMuted
    keyInput.TextSize = Config.Sizes.Medium
    keyInput.Font = Config.Fonts.Regular
    keyInput.Parent = inputFrame
    
    local errorMsg = Instance.new("TextLabel")
    errorMsg.Size = UDim2.new(1, -40, 0, 20)
    errorMsg.Position = UDim2.new(0, 20, 0, 230)
    errorMsg.BackgroundTransparency = 1
    errorMsg.Text = ""
    errorMsg.TextColor3 = Config.Theme.Danger
    errorMsg.TextSize = Config.Sizes.Small
    errorMsg.Font = Config.Fonts.Regular
    errorMsg.TextXAlignment = Enum.TextXAlignment.Center
    errorMsg.Parent = keyFrame
    
    local validateBtn = Instance.new("TextButton")
    validateBtn.Size = UDim2.new(1, -40, 0, 44)
    validateBtn.Position = UDim2.new(0, 20, 0, 260)
    validateBtn.Text = "VALIDAR ACESSO"
    validateBtn.TextColor3 = Config.Theme.Text
    validateBtn.TextSize = Config.Sizes.Medium
    validateBtn.Font = Config.Fonts.Medium
    validateBtn.BackgroundColor3 = Config.Theme.Primary
    validateBtn.BorderSizePixel = 0
    validateBtn.Parent = keyFrame
    CreateCorner(validateBtn, 8)
    
    validateBtn.MouseEnter:Connect(function()
        Tween(validateBtn, {BackgroundColor3 = Config.Theme.PrimaryDark}, 0.15)
    end)
    validateBtn.MouseLeave:Connect(function()
        Tween(validateBtn, {BackgroundColor3 = Config.Theme.Primary}, 0.15)
    end)
    
    validateBtn.MouseButton1Click:Connect(function()
        local inputKey = string.upper(keyInput.Text)
        local isValid = false
        
        for _, validKey in ipairs(validKeys) do
            if inputKey == string.upper(validKey) then
                isValid = true
                break
            end
        end
        
        if isValid then
            SavedData.KeyValidated = true
            SaveData()
            Tween(overlay, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            overlay:Destroy()
            if onSuccess then onSuccess() end
        else
            errorMsg.Text = "❌ Chave inválida! Tente novamente."
            Tween(errorMsg, {TextTransparency = 0}, 0.2)
            keyInput.Text = ""
            keyInput:CaptureFocus()
            task.wait(2)
            Tween(errorMsg, {TextTransparency = 1}, 0.3)
        end
    end)
    
    return overlay
end

-- ============================================
-- FUNÇÃO PRINCIPAL
-- ============================================

function LunarShell:Init(options)
    options = options or {}
    local title = options.Title or "LunarShell Hub"
    local toggleKey = options.ToggleKey or Config.Settings.ToggleKey
    local requireKey = options.RequireKey or false
    local validKeys = options.ValidKeys or {"LUNAR2024", "SHELL2024", "FREE2024"}
    
    LoadData()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LunarShellHub"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    
    -- Janela principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = options.Size or UDim2.new(0, 950, 0, 620)
    mainFrame.Position = UDim2.new(0.5, -475, 0.5, -310)
    mainFrame.BackgroundColor3 = Config.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    CreateCorner(mainFrame, 16)
    CreateStroke(mainFrame, 1)
    mainFrame.Visible = false
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 52)
    titleBar.BackgroundColor3 = Config.Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    CreateCorner(titleBar, 16)
    
    -- Botões da janela (todos os três)
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Size = UDim2.new(0, 110, 1, 0)
    buttonsContainer.Position = UDim2.new(1, -120, 0, 0)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = titleBar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
    minimizeBtn.Position = UDim2.new(0, 0, 0.5, -16)
    minimizeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Config.Theme.TextSecondary
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Config.Fonts.Regular
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonsContainer
    CreateCorner(minimizeBtn, 8)
    
    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Size = UDim2.new(0, 32, 0, 32)
    maximizeBtn.Position = UDim2.new(0, 38, 0.5, -16)
    maximizeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    maximizeBtn.Text = "□"
    maximizeBtn.TextColor3 = Config.Theme.TextSecondary
    maximizeBtn.TextSize = 16
    maximizeBtn.Font = Config.Fonts.Regular
    maximizeBtn.BorderSizePixel = 0
    maximizeBtn.Parent = buttonsContainer
    CreateCorner(maximizeBtn, 8)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(0, 76, 0.5, -16)
    closeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Config.Theme.TextSecondary
    closeBtn.TextSize = 16
    closeBtn.Font = Config.Fonts.Regular
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = buttonsContainer
    CreateCorner(closeBtn, 8)
    
    -- Ícone e título
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 36, 1, 0)
    iconLabel.Position = UDim2.new(0, 16, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "🌙"
    iconLabel.TextColor3 = Config.Theme.Accent
    iconLabel.TextSize = 22
    iconLabel.Font = Config.Fonts.Regular
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 56, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.TextSize = Config.Sizes.Medium
    titleLabel.Font = Config.Fonts.Bold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -24, 1, -72)
    contentArea.Position = UDim2.new(0, 12, 0, 60)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- Sidebar
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.new(0, 210, 1, 0)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentArea
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.ScrollBarThickness = 2
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 8)
    
    -- Workarea
    local workarea = Instance.new("ScrollingFrame")
    workarea.Size = UDim2.new(1, -230, 1, 0)
    workarea.Position = UDim2.new(0, 230, 0, 0)
    workarea.BackgroundTransparency = 1
    workarea.BorderSizePixel = 0
    workarea.Parent = contentArea
    workarea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    workarea.ScrollBarThickness = 4
    
    local workareaLayout = Instance.new("UIListLayout")
    workareaLayout.Parent = workarea
    workareaLayout.SortOrder = Enum.SortOrder.LayoutOrder
    workareaLayout.Padding = UDim.new(0, 12)
    workareaLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Sistema de drag
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Funções da janela
    local isMinimized = false
    local isMaximized = false
    local savedPos = mainFrame.Position
    local savedSize = mainFrame.Size
    
    closeBtn.MouseButton1Click:Connect(function()
        LunarShell:Notify("Fechar", "Deseja realmente fechar o hub?", "warning", 0, function(confirmed)
            if confirmed then
                screenGui:Destroy()
            end
        end, true)
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            Tween(mainFrame, {Size = savedSize, Position = savedPos, BackgroundTransparency = 0}, 0.3)
            isMinimized = false
            -- Reexibir conteúdo
            contentArea.Visible = true
            sidebar.Visible = true
            workarea.Visible = true
        else
            savedPos = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 50), Position = UDim2.new(0.5, -200, 0.5, -25), BackgroundTransparency = 0}, 0.3)
            isMinimized = true
            -- Ocultar conteúdo
            contentArea.Visible = false
            sidebar.Visible = false
            workarea.Visible = false
        end
    end)
    
    maximizeBtn.MouseButton1Click:Connect(function()
        if isMaximized then
            Tween(mainFrame, {Size = savedSize, Position = savedPos}, 0.3)
            isMaximized = false
        else
            savedPos = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20)}, 0.3)
            isMaximized = true
        end
    end)
    
    -- Tecla de atalho
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == toggleKey then
            if visible then
                Tween(mainFrame, {Position = mainFrame.Position + UDim2.new(0, 0, 2, 0), BackgroundTransparency = 1}, 0.3)
                visible = false
            else
                Tween(mainFrame, {Position = savedPos, BackgroundTransparency = 0}, 0.3)
                visible = true
            end
        end
    end)
    
    -- ========== SISTEMA DE CATEGORIAS ==========
    local categories = {}
    local firstCategory = nil
    
    function LunarShell:Category(name, icon)
        local catBtn = Instance.new("TextButton")
        catBtn.Size = UDim2.new(1, -12, 0, 44)
        catBtn.Position = UDim2.new(0, 6, 0, 0)
        catBtn.BackgroundColor3 = Config.Theme.Surface
        catBtn.Text = "  " .. (icon or "◆") .. "  " .. name
        catBtn.TextColor3 = Config.Theme.TextSecondary
        catBtn.TextSize = Config.Sizes.Small
        catBtn.Font = Config.Fonts.Medium
        catBtn.TextXAlignment = Enum.TextXAlignment.Left
        catBtn.BorderSizePixel = 0
        catBtn.Parent = sidebar
        CreateCorner(catBtn, 10)
        
        local catContainer = Instance.new("Frame")
        catContainer.Size = UDim2.new(1, 0, 0, 0)
        catContainer.BackgroundTransparency = 1
        catContainer.Parent = workarea
        catContainer.Visible = false
        catContainer.AutomaticSize = Enum.AutomaticSize.Y
        
        local catLayout = Instance.new("UIListLayout")
        catLayout.Parent = catContainer
        catLayout.SortOrder = Enum.SortOrder.LayoutOrder
        catLayout.Padding = UDim.new(0, 12)
        catLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        categories[name] = {
            Button = catBtn,
            Container = catContainer
        }
        
        if not firstCategory then
            firstCategory = name
        end
        
        catBtn.MouseButton1Click:Connect(function()
            for _, cat in pairs(categories) do
                cat.Button.BackgroundColor3 = Config.Theme.Surface
                cat.Button.TextColor3 = Config.Theme.TextSecondary
                cat.Container.Visible = false
            end
            catBtn.BackgroundColor3 = Config.Theme.Primary
            catBtn.TextColor3 = Config.Theme.Text
            catContainer.Visible = true
        end)
        
        local categoryAPI = {}
        
        function categoryAPI:AddScript(name, description, callback)
            local scriptCard = Instance.new("Frame")
            scriptCard.Size = UDim2.new(1, -20, 0, 0)
            scriptCard.BackgroundColor3 = Config.Theme.Surface
            scriptCard.Parent = catContainer
            scriptCard.AutomaticSize = Enum.AutomaticSize.Y
            CreateCorner(scriptCard, 12)
            CreateStroke(scriptCard, 1)
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -24, 0, 28)
            titleLabel.Position = UDim2.new(0, 12, 0, 12)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "📜  " .. name
            titleLabel.TextColor3 = Config.Theme.Text
            titleLabel.TextSize = Config.Sizes.Medium
            titleLabel.Font = Config.Fonts.Bold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = scriptCard
            
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -24, 0, 36)
            descLabel.Position = UDim2.new(0, 12, 0, 44)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = description or "Sem descrição"
            descLabel.TextColor3 = Config.Theme.TextSecondary
            descLabel.TextSize = Config.Sizes.Small
            descLabel.Font = Config.Fonts.Regular
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextWrapped = true
            descLabel.Parent = scriptCard
            
            local executeBtn = Instance.new("TextButton")
            executeBtn.Size = UDim2.new(0, 100, 0, 34)
            executeBtn.Position = UDim2.new(1, -112, 1, -44)
            executeBtn.Text = "▶ EXECUTAR"
            executeBtn.TextColor3 = Config.Theme.Text
            executeBtn.TextSize = Config.Sizes.Small
            executeBtn.Font = Config.Fonts.Medium
            executeBtn.BackgroundColor3 = Config.Theme.Success
            executeBtn.BorderSizePixel = 0
            executeBtn.Parent = scriptCard
            CreateCorner(executeBtn, 8)
            
            executeBtn.MouseEnter:Connect(function()
                Tween(executeBtn, {BackgroundColor3 = Color3.fromRGB(90, 120, 90)}, 0.15)
            end)
            executeBtn.MouseLeave:Connect(function()
                Tween(executeBtn, {BackgroundColor3 = Config.Theme.Success}, 0.15)
            end)
            
            executeBtn.MouseButton1Click:Connect(function()
                if callback then
                    local success, err = pcall(callback)
                    if not success then
                        LunarShell:Notify("Erro", "Falha ao executar: " .. tostring(err), "error", 3)
                    else
                        LunarShell:Notify("Sucesso", "Script '" .. name .. "' executado!", "success", 2)
                    end
                end
            end)
            
            return scriptCard
        end
        
        function categoryAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 48)
            btn.BackgroundColor3 = Config.Theme.Surface
            btn.Text = text
            btn.TextColor3 = Config.Theme.Text
            btn.TextSize = Config.Sizes.Medium
            btn.Font = Config.Fonts.Medium
            btn.BorderSizePixel = 0
            btn.Parent = catContainer
            CreateCorner(btn, 10)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Config.Theme.SurfaceHover}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = Config.Theme.Surface}, 0.15)
            end)
            
            if callback then
                btn.MouseButton1Click:Connect(callback)
            end
            
            return btn
        end
        
        function categoryAPI:AddToggle(name, defaultState, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 52)
            frame.BackgroundColor3 = Config.Theme.Surface
            frame.Parent = catContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 200, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Config.Theme.Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 50, 0, 26)
            toggleBg.Position = UDim2.new(1, -62, 0.5, -13)
            toggleBg.BackgroundColor3 = defaultState and Config.Theme.Success or Config.Theme.SurfaceHover
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = frame
            CreateCorner(toggleBg, 13)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Size = UDim2.new(0, 22, 0, 22)
            toggleKnob.Position = defaultState and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            toggleKnob.BackgroundColor3 = Config.Theme.Text
            toggleKnob.BorderSizePixel = 0
            toggleKnob.Parent = toggleBg
            CreateCorner(toggleKnob, 11)
            
            local toggled = defaultState or false
            
            local function updateToggle(state)
                toggled = state
                Tween(toggleBg, {BackgroundColor3 = toggled and Config.Theme.Success or Config.Theme.SurfaceHover}, 0.2)
                Tween(toggleKnob, {Position = toggled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}, 0.2)
                if callback then callback(toggled) end
                SavedData.ScriptsState[name] = toggled
                SaveData()
            end
            
            toggleBg.MouseButton1Click:Connect(function()
                updateToggle(not toggled)
            end)
            
            if SavedData.ScriptsState[name] ~= nil then
                updateToggle(SavedData.ScriptsState[name])
            end
            
            return {
                SetState = updateToggle,
                GetState = function() return toggled end
            }
        end
        
        function categoryAPI:AddSlider(name, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 80)
            frame.BackgroundColor3 = Config.Theme.Surface
            frame.Parent = catContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 10)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Config.Theme.Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 60, 0, 24)
            valueLabel.Position = UDim2.new(1, -72, 0, 10)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or 0)
            valueLabel.TextColor3 = Config.Theme.Accent
            valueLabel.TextSize = Config.Sizes.Small
            valueLabel.Font = Config.Fonts.Medium
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = frame
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 1, -24)
            track.BackgroundColor3 = Config.Theme.SurfaceHover
            track.BorderSizePixel = 0
            track.Parent = frame
            CreateCorner(track, 2)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Config.Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            CreateCorner(fill, 2)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = UDim2.new(0, -7, 0, -5)
            knob.BackgroundColor3 = Config.Theme.Text
            knob.BorderSizePixel = 0
            knob.Parent = track
            CreateCorner(knob, 7)
            
            local value = default or min
            local dragging = false
            
            local function updateSlider(inputValue)
                local percent = (inputValue - min) / (max - min)
                percent = math.clamp(percent, 0, 1)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -7, 0, -5)
                value = min + (percent * (max - min))
                valueLabel.Text = string.format("%.1f", value)
                if callback then callback(value) end
                SavedData.Settings[name] = value
                SaveData()
            end
            
            updateSlider(value)
            
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            knob.InputEnded:Connect(function() dragging = false end)
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local pos = input.Position.X - track.AbsolutePosition.X
                    local percent = math.clamp(pos / track.AbsoluteSize.X, 0, 1)
                    updateSlider(min + (percent * (max - min)))
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = input.Position.X - track.AbsolutePosition.X
                    local percent = math.clamp(pos / track.AbsoluteSize.X, 0, 1)
                    updateSlider(min + (percent * (max - min)))
                end
            end)
            
            if SavedData.Settings[name] then
                updateSlider(SavedData.Settings[name])
            end
            
            return {
                SetValue = updateSlider,
                GetValue = function() return value end
            }
        end
        
        function categoryAPI:AddDropdown(name, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 80)
            frame.BackgroundColor3 = Config.Theme.Surface
            frame.Parent = catContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 10)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Config.Theme.Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, -24, 0, 36)
            dropdownBtn.Position = UDim2.new(0, 12, 1, -44)
            dropdownBtn.BackgroundColor3 = Config.Theme.SurfaceHover
            dropdownBtn.Text = default or options[1]
            dropdownBtn.TextColor3 = Config.Theme.Text
            dropdownBtn.TextSize = Config.Sizes.Small
            dropdownBtn.Font = Config.Fonts.Regular
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Parent = frame
            CreateCorner(dropdownBtn, 8)
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Position = UDim2.new(0, 0, 1, 4)
            dropdownList.BackgroundColor3 = Config.Theme.Surface
            dropdownList.BackgroundTransparency = 1
            dropdownList.Visible = false
            dropdownList.Parent = dropdownBtn
            CreateCorner(dropdownList, 8)
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList
            
            local isOpen = false
            local currentOption = default or options[1]
            
            local function updateOptions()
                for _, child in ipairs(dropdownList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                local height = 0
                for _, option in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 34)
                    optBtn.Text = option
                    optBtn.TextColor3 = Config.Theme.Text
                    optBtn.TextSize = Config.Sizes.Small
                    optBtn.Font = Config.Fonts.Regular
                    optBtn.BackgroundColor3 = Config.Theme.SurfaceHover
                    optBtn.BorderSizePixel = 0
                    optBtn.Parent = dropdownList
                    
                    optBtn.MouseButton1Click:Connect(function()
                        currentOption = option
                        dropdownBtn.Text = option
                        isOpen = false
                        dropdownList.Visible = false
                        dropdownList.BackgroundTransparency = 1
                        if callback then callback(option) end
                        SavedData.Settings[name] = option
                        SaveData()
                    end)
                    
                    height = height + 36
                end
                
                dropdownList.Size = UDim2.new(1, 0, 0, height)
            end
            
            updateOptions()
            
            dropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownList.Visible = isOpen
                dropdownList.BackgroundTransparency = isOpen and 0 or 1
            end)
            
            if SavedData.Settings[name] then
                currentOption = SavedData.Settings[name]
                dropdownBtn.Text = currentOption
                if callback then callback(currentOption) end
            end
            
            return {
                SetValue = function(opt)
                    currentOption = opt
                    dropdownBtn.Text = opt
                    if callback then callback(opt) end
                end,
                GetValue = function() return currentOption end
            }
        end
        
        function categoryAPI:AddDivider(text)
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, -20, 0, 36)
            divider.BackgroundTransparency = 1
            divider.Parent = catContainer
            
            local dividerText = Instance.new("TextLabel")
            dividerText.Size = UDim2.new(1, 0, 1, 0)
            dividerText.BackgroundTransparency = 1
            dividerText.Text = text
            dividerText.TextColor3 = Config.Theme.Accent
            dividerText.TextSize = Config.Sizes.Small
            dividerText.Font = Config.Fonts.Bold
            dividerText.TextXAlignment = Enum.TextXAlignment.Left
            dividerText.Parent = divider
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 1, -6)
            line.BackgroundColor3 = Config.Theme.Border
            line.BorderSizePixel = 0
            line.Parent = divider
            
            return divider
        end
        
        return categoryAPI
    end
    
    -- ========== NOTIFICAÇÕES ==========
    local notifications = {}
    
    function LunarShell:Notify(title, message, type, duration, callback, confirmMode)
        type = type or "info"
        duration = duration or 3
        
        local notifFrame = Instance.new("Frame")
        notifFrame.Size = UDim2.new(0, 340, 0, 80)
        notifFrame.Position = UDim2.new(1, -360, 0, 20 + (#notifications * 90))
        notifFrame.BackgroundColor3 = Config.Theme.Surface
        notifFrame.BorderSizePixel = 0
        notifFrame.Parent = screenGui
        CreateCorner(notifFrame, 12)
        CreateStroke(notifFrame, 1)
        
        local icon = "📌"
        if type == "success" then icon = "✓"
        elseif type == "error" then icon = "✕"
        elseif type == "warning" then icon = "⚠"
        end
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -40, 0, 28)
        titleLabel.Position = UDim2.new(0, 40, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = icon .. "  " .. title
        titleLabel.TextColor3 = Config.Theme.Text
        titleLabel.TextSize = Config.Sizes.Medium
        titleLabel.Font = Config.Fonts.Bold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notifFrame
        
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, -40, 0, 36)
        messageLabel.Position = UDim2.new(0, 40, 0, 40)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message or ""
        messageLabel.TextColor3 = Config.Theme.TextSecondary
        messageLabel.TextSize = Config.Sizes.Small
        messageLabel.Font = Config.Fonts.Regular
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextWrapped = true
        messageLabel.Parent = notifFrame
        
        table.insert(notifications, notifFrame)
        
        if confirmMode then
            duration = 0
            local yesBtn = Instance.new("TextButton")
            yesBtn.Size = UDim2.new(0, 70, 0, 32)
            yesBtn.Position = UDim2.new(1, -160, 1, -40)
            yesBtn.BackgroundColor3 = Config.Theme.Success
            yesBtn.Text = "Sim"
            yesBtn.TextColor3 = Config.Theme.Text
            yesBtn.TextSize = Config.Sizes.Small
            yesBtn.Font = Config.Fonts.Medium
            yesBtn.BorderSizePixel = 0
            yesBtn.Parent = notifFrame
            CreateCorner(yesBtn, 6)
            
            local noBtn = Instance.new("TextButton")
            noBtn.Size = UDim2.new(0, 70, 0, 32)
            noBtn.Position = UDim2.new(1, -80, 1, -40)
            noBtn.BackgroundColor3 = Config.Theme.Danger
            noBtn.Text = "Não"
            noBtn.TextColor3 = Config.Theme.Text
            noBtn.TextSize = Config.Sizes.Small
            noBtn.Font = Config.Fonts.Medium
            noBtn.BorderSizePixel = 0
            noBtn.Parent = notifFrame
            CreateCorner(noBtn, 6)
            
            yesBtn.MouseButton1Click:Connect(function()
                if callback then callback(true) end
                notifFrame:Destroy()
                table.remove(notifications, table.find(notifications, notifFrame))
                for i, n in ipairs(notifications) do
                    Tween(n, {Position = UDim2.new(1, -360, 0, 20 + ((i-1) * 90))}, 0.2)
                end
            end)
            
            noBtn.MouseButton1Click:Connect(function()
                if callback then callback(false) end
                notifFrame:Destroy()
                table.remove(notifications, table.find(notifications, notifFrame))
                for i, n in ipairs(notifications) do
                    Tween(n, {Position = UDim2.new(1, -360, 0, 20 + ((i-1) * 90))}, 0.2)
                end
            end)
        end
        
        Tween(notifFrame, {Position = UDim2.new(1, -360, 0, 20 + ((#notifications-1) * 90))}, 0.3)
        
        if duration > 0 then
            task.spawn(function()
                task.wait(duration)
                Tween(notifFrame, {Position = UDim2.new(1, -340, 0, 20 + ((#notifications-1) * 90)), BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                notifFrame:Destroy()
                table.remove(notifications, table.find(notifications, notifFrame))
                for i, n in ipairs(notifications) do
                    Tween(n, {Position = UDim2.new(1, -360, 0, 20 + ((i-1) * 90))}, 0.2)
                end
            end)
        end
        
        return notifFrame
    end
    
    function LunarShell:Loading(message, duration, callback)
        return CreateLoadingScreen(screenGui, message, duration, callback)
    end
    
    -- ========== INICIALIZAÇÃO ==========
    local function ShowMainUI()
        mainFrame.Visible = true
        -- Selecionar primeira categoria
        if firstCategory and categories[firstCategory] then
            categories[firstCategory].Button.MouseButton1Click:Fire()
        end
        LunarShell:Loading("Inicializando LunarShell Hub...", 1.2, function()
            LunarShell:Notify("Bem-vindo", "LunarShell Hub carregado! Pressione " .. tostring(toggleKey):sub(12) .. " para ocultar", "success", 4)
        end)
    end
    
    if requireKey and not SavedData.KeyValidated then
        CreateKeyScreen(screenGui, ShowMainUI, validKeys)
    else
        ShowMainUI()
    end
    
    return {
        Category = LunarShell.Category,
        Notify = LunarShell.Notify,
        Loading = LunarShell.Loading,
        Window = mainFrame,
        ScreenGui = screenGui
    }
end

return LunarShell
