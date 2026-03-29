--[[
    LUNARSHELL HUB - Script Library (Versão Completa)
    Inclui:
    - Splash screen animada (logo, barra infinita, status)
    - Tela de key com salvamento em arquivo
    - Sistema de categorias (scripts, toggles, sliders, dropdowns)
    - Notificações e loading screen
    - Janela flutuante arrastável
    - Botões de minimizar, maximizar e fechar (com confirmação)
    - Tecla de atalho para mostrar/ocultar (padrão: P)
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
        Purple = Color3.fromRGB(169, 112, 255),
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

-- Sistema de salvamento
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
-- SPLASH SCREEN (estilo UNXHub)
-- ============================================

local function CreateSplashScreen(parent, options)
    options = options or {}
    local title = options.title or "LunarShell Hub"
    local logoAsset = options.logoAsset or "rbxassetid://73740010358428"
    local onComplete = options.onComplete or function() end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Config.Theme.Background
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = parent
    mainFrame.ZIndex = 10000

    CreateCorner(mainFrame, 14)
    CreateStroke(mainFrame, 1.5, Color3.fromRGB(38, 36, 52))

    -- Logo
    local logoImage = Instance.new("ImageLabel")
    logoImage.Size = UDim2.new(0, 115, 0, 115)
    logoImage.Position = UDim2.new(0.045, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = logoAsset
    logoImage.ImageColor3 = Config.Theme.Text
    logoImage.ImageTransparency = 1
    logoImage.ZIndex = 10001
    logoImage.Parent = mainFrame
    CreateCorner(logoImage, 12)
    CreateStroke(logoImage, 1, Color3.fromRGB(38, 36, 52))

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 0, 26)
    titleLabel.Position = UDim2.new(0.36, 0, 0.33, 0)
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.Font = Config.Fonts.Bold
    titleLabel.TextSize = 28
    titleLabel.TextTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 10001
    titleLabel.Parent = mainFrame

    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.6, 0, 0, 16)
    statusLabel.Position = UDim2.new(0.36, 0, 0.5, 0)
    statusLabel.AnchorPoint = Vector2.new(0, 0.5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Inicializando..."
    statusLabel.TextColor3 = Config.Theme.TextSecondary
    statusLabel.Font = Config.Fonts.Regular
    statusLabel.TextSize = 14
    statusLabel.TextTransparency = 1
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 10001
    statusLabel.Parent = mainFrame

    -- Container da barra
    local loaderContainer = Instance.new("Frame")
    loaderContainer.Size = UDim2.new(0.58, 0, 0, 6)
    loaderContainer.Position = UDim2.new(0.36, 0, 0.67, 0)
    loaderContainer.AnchorPoint = Vector2.new(0, 0.5)
    loaderContainer.BackgroundColor3 = Config.Theme.Surface
    loaderContainer.BackgroundTransparency = 1
    loaderContainer.ClipsDescendants = true
    loaderContainer.ZIndex = 10001
    loaderContainer.Parent = mainFrame
    CreateCorner(loaderContainer, 100)
    CreateStroke(loaderContainer, 1, Color3.fromRGB(38, 36, 52))

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0.3, 0, 1, 0)
    barFill.Position = UDim2.new(-0.3, 0, 0, 0)
    barFill.BackgroundColor3 = Config.Theme.Purple
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 10002
    barFill.Parent = loaderContainer
    CreateCorner(barFill, 100)

    local checkmark = Instance.new("ImageLabel")
    checkmark.Size = UDim2.new(0.6, 0, 0.6, 0)
    checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
    checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
    checkmark.BackgroundTransparency = 1
    checkmark.Image = "rbxassetid://11242915823"
    checkmark.ImageColor3 = Config.Theme.Text
    checkmark.ImageTransparency = 1
    checkmark.ZIndex = 10002
    checkmark.Parent = loaderContainer

    local errorIcon = Instance.new("ImageLabel")
    errorIcon.Size = UDim2.new(0.5, 0, 0.5, 0)
    errorIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    errorIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    errorIcon.BackgroundTransparency = 1
    errorIcon.Image = "rbxassetid://4988112250"
    errorIcon.ImageColor3 = Config.Theme.Text
    errorIcon.ImageTransparency = 1
    errorIcon.ZIndex = 10002
    errorIcon.Parent = loaderContainer

    -- Animar entrada
    Tween(mainFrame, {Size = UDim2.new(0, 420, 0, 160)}, 0.8)
    task.wait(0.8)
    Tween(logoImage, {ImageTransparency = 0}, 0.8)
    Tween(titleLabel, {TextTransparency = 0}, 0.8)
    Tween(statusLabel, {TextTransparency = 0}, 0.8)
    Tween(loaderContainer, {BackgroundTransparency = 0}, 0.8)
    Tween(loaderContainer.UIStroke, {Transparency = 0}, 0.8)

    -- Barra infinita
    barFill.Position = UDim2.new(-0.35, 0, 0, 0)
    local infiniteTween = TweenService:Create(barFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1), {Position = UDim2.new(1.35, 0, 0, 0)})
    infiniteTween:Play()

    local api = {
        Frame = mainFrame,
        StatusLabel = statusLabel,
        BarFill = barFill,
        InfiniteTween = infiniteTween,
        LoaderContainer = loaderContainer,
        Checkmark = checkmark,
        ErrorIcon = errorIcon,
        SetSuccess = function()
            infiniteTween:Cancel()
            Tween(barFill, {BackgroundTransparency = 1}, 0.3)
            Tween(loaderContainer, {Size = UDim2.new(0, 30, 0, 30), BackgroundColor3 = Config.Theme.Success}, 0.8)
            Tween(loaderContainer.UIStroke, {Color = Config.Theme.Success}, 0.5)
            task.wait(0.3)
            Tween(checkmark, {ImageTransparency = 0}, 0.5)
            statusLabel.Text = "Carregado!"
        end,
        SetError = function(errMsg)
            infiniteTween:Cancel()
            Tween(barFill, {BackgroundTransparency = 1}, 0.3)
            Tween(loaderContainer, {Size = UDim2.new(0, 30, 0, 30), BackgroundColor3 = Config.Theme.Danger}, 0.8)
            Tween(loaderContainer.UIStroke, {Color = Config.Theme.Danger}, 0.5)
            task.wait(0.3)
            Tween(errorIcon, {ImageTransparency = 0}, 0.5)
            statusLabel.Text = errMsg or "Falha ao carregar"
        end,
        Destroy = function()
            Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.6)
            task.wait(0.6)
            mainFrame:Destroy()
            if onComplete then onComplete() end
        end
    }
    return api
end

-- ============================================
-- TELA DE KEY (com salvamento em arquivo)
-- ============================================

local function CreateKeyScreen(parent, options, onSuccess)
    options = options or {}
    local validKeys = options.validKeys or {"LUNAR2024", "SHELL2024"}
    local keyFilePath = options.keyFilePath or "lunarshell/cache/savedkey.lua"
    local getKeyUrl = options.getKeyUrl or "https://discord.gg/lunarshell"

    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(1, 0, 1, 0)
    keyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyFrame.BackgroundTransparency = 0.85
    keyFrame.BorderSizePixel = 0
    keyFrame.Parent = parent
    keyFrame.ZIndex = 200

    local centerFrame = Instance.new("Frame")
    centerFrame.Size = UDim2.new(0, 340, 0, 280)
    centerFrame.Position = UDim2.new(0.5, -170, 0.5, -140)
    centerFrame.BackgroundColor3 = Config.Theme.Surface
    centerFrame.BorderSizePixel = 0
    centerFrame.Parent = keyFrame
    CreateCorner(centerFrame, 16)
    CreateStroke(centerFrame, 1)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🔑 Chave Necessária"
    title.TextColor3 = Config.Theme.Text
    title.TextSize = Config.Sizes.Huge
    title.Font = Config.Fonts.Bold
    title.Parent = centerFrame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0.8, 0, 0, 36)
    keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    keyInput.BackgroundColor3 = Config.Theme.Background
    keyInput.TextColor3 = Config.Theme.Text
    keyInput.PlaceholderText = "Digite a chave aqui..."
    keyInput.PlaceholderColor3 = Config.Theme.TextMuted
    keyInput.Font = Config.Fonts.Regular
    keyInput.TextSize = Config.Sizes.Medium
    keyInput.Parent = centerFrame
    CreateCorner(keyInput, 8)
    CreateStroke(keyInput, 1)

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0, 130, 0, 36)
    getKeyBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    getKeyBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    getKeyBtn.Text = "Obter Chave"
    getKeyBtn.TextColor3 = Config.Theme.Text
    getKeyBtn.Font = Config.Fonts.Medium
    getKeyBtn.TextSize = Config.Sizes.Small
    getKeyBtn.Parent = centerFrame
    CreateCorner(getKeyBtn, 8)
    getKeyBtn.MouseButton1Click:Connect(function()
        setclipboard(getKeyUrl)
        getKeyBtn.Text = "Copiado!"
        task.wait(1)
        getKeyBtn.Text = "Obter Chave"
    end)

    local checkKeyBtn = Instance.new("TextButton")
    checkKeyBtn.Size = UDim2.new(0, 130, 0, 36)
    checkKeyBtn.Position = UDim2.new(0.6, 0, 0.7, 0)
    checkKeyBtn.BackgroundColor3 = Config.Theme.Purple
    checkKeyBtn.Text = "Verificar"
    checkKeyBtn.TextColor3 = Config.Theme.Text
    checkKeyBtn.Font = Config.Fonts.Bold
    checkKeyBtn.TextSize = Config.Sizes.Small
    checkKeyBtn.Parent = centerFrame
    CreateCorner(checkKeyBtn, 8)

    local errorMsg = Instance.new("TextLabel")
    errorMsg.Size = UDim2.new(1, -40, 0, 20)
    errorMsg.Position = UDim2.new(0, 20, 0, 0.85)
    errorMsg.BackgroundTransparency = 1
    errorMsg.Text = ""
    errorMsg.TextColor3 = Config.Theme.Danger
    errorMsg.TextSize = Config.Sizes.Small
    errorMsg.Font = Config.Fonts.Regular
    errorMsg.Parent = centerFrame

    local function validateKey(inputKey)
        for _, valid in ipairs(validKeys) do
            if string.upper(inputKey) == string.upper(valid) then
                return true
            end
        end
        return false
    end

    -- Carregar chave salva
    if isfile(keyFilePath) then
        local saved = readfile(keyFilePath)
        if validateKey(saved) then
            SavedData.KeyValidated = true
            SaveData()
            keyFrame:Destroy()
            if onSuccess then onSuccess() end
            return
        end
    end

    checkKeyBtn.MouseButton1Click:Connect(function()
        local inputKey = keyInput.Text
        if validateKey(inputKey) then
            local folder = keyFilePath:match("(.*)/")
            if folder and not isfolder(folder) then
                makefolder(folder)
            end
            writefile(keyFilePath, inputKey)
            SavedData.KeyValidated = true
            SaveData()
            Tween(keyFrame, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            keyFrame:Destroy()
            if onSuccess then onSuccess() end
        else
            errorMsg.Text = "❌ Chave inválida!"
            Tween(errorMsg, {TextTransparency = 0}, 0.2)
            keyInput.Text = ""
            task.wait(2)
            Tween(errorMsg, {TextTransparency = 1}, 0.3)
        end
    end)

    return keyFrame
end

-- ============================================
-- LOADING SCREEN (genérica)
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
-- FUNÇÃO PRINCIPAL
-- ============================================

function LunarShell:Init(options)
    options = options or {}
    local title = options.Title or "LunarShell Hub"
    local toggleKey = options.ToggleKey or Config.Settings.ToggleKey
    local requireKey = options.RequireKey or false
    local validKeys = options.ValidKeys or {"LUNAR2024", "SHELL2024", "FREE2024"}
    local keyFilePath = options.KeyFilePath or "lunarshell/cache/savedkey.lua"
    local getKeyUrl = options.GetKeyUrl or "https://discord.gg/lunarshell"
    local splashLogo = options.SplashLogo or "rbxassetid://73740010358428"
    local onLoadCallback = options.OnLoad or function() end

    LoadData()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LunarShellHub"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false

    -- Criar splash screen
    local splash = CreateSplashScreen(screenGui, {
        title = title,
        logoAsset = splashLogo,
        onComplete = function()
            mainFrame.Visible = true
        end
    })

    -- Janela principal (inicialmente invisível)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = options.Size or UDim2.new(0, 900, 0, 580)
    mainFrame.Position = UDim2.new(0.5, -450, 0.5, -290)
    mainFrame.BackgroundColor3 = Config.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    CreateCorner(mainFrame, 16)
    CreateStroke(mainFrame, 1)
    mainFrame.Visible = false

    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = Config.Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    CreateCorner(titleBar, 16)

    -- Botões
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -48, 0.5, -14)
    closeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Config.Theme.TextSecondary
    closeBtn.TextSize = 14
    closeBtn.Font = Config.Fonts.Regular
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    CreateCorner(closeBtn, 14)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -88, 0.5, -14)
    minimizeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Config.Theme.TextSecondary
    minimizeBtn.TextSize = 14
    minimizeBtn.Font = Config.Fonts.Regular
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    CreateCorner(minimizeBtn, 14)

    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Size = UDim2.new(0, 28, 0, 28)
    maximizeBtn.Position = UDim2.new(1, -128, 0.5, -14)
    maximizeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    maximizeBtn.Text = "□"
    maximizeBtn.TextColor3 = Config.Theme.TextSecondary
    maximizeBtn.TextSize = 14
    maximizeBtn.Font = Config.Fonts.Regular
    maximizeBtn.BorderSizePixel = 0
    maximizeBtn.Parent = titleBar
    CreateCorner(maximizeBtn, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 250, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🌙 " .. title
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.TextSize = Config.Sizes.Medium
    titleLabel.Font = Config.Fonts.Bold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -24, 1, -68)
    contentArea.Position = UDim2.new(0, 12, 0, 56)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    -- Sidebar
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentArea
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.ScrollBarThickness = 2

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)

    -- Workarea
    local workarea = Instance.new("ScrollingFrame")
    workarea.Size = UDim2.new(1, -220, 1, 0)
    workarea.Position = UDim2.new(0, 220, 0, 0)
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

    -- Estado da janela
    local isMinimized = false
    local isMaximized = false
    local savedPos = mainFrame.Position
    local savedSize = mainFrame.Size

    -- Fechar com confirmação centralizada
    closeBtn.MouseButton1Click:Connect(function()
        local confirmOverlay = Instance.new("Frame")
        confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
        confirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        confirmOverlay.BackgroundTransparency = 0.7
        confirmOverlay.BorderSizePixel = 0
        confirmOverlay.Parent = screenGui
        confirmOverlay.ZIndex = 300

        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0, 300, 0, 160)
        confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
        confirmFrame.BackgroundColor3 = Config.Theme.Surface
        confirmFrame.BorderSizePixel = 0
        confirmFrame.Parent = confirmOverlay
        CreateCorner(confirmFrame, 12)
        CreateStroke(confirmFrame, 1)

        local confirmTitle = Instance.new("TextLabel")
        confirmTitle.Size = UDim2.new(1, 0, 0, 40)
        confirmTitle.Position = UDim2.new(0, 0, 0, 10)
        confirmTitle.BackgroundTransparency = 1
        confirmTitle.Text = "⚠️ Fechar Hub"
        confirmTitle.TextColor3 = Config.Theme.Text
        confirmTitle.TextSize = Config.Sizes.Medium
        confirmTitle.Font = Config.Fonts.Bold
        confirmTitle.Parent = confirmFrame

        local confirmMsg = Instance.new("TextLabel")
        confirmMsg.Size = UDim2.new(1, -20, 0, 40)
        confirmMsg.Position = UDim2.new(0, 10, 0, 50)
        confirmMsg.BackgroundTransparency = 1
        confirmMsg.Text = "Tem certeza que deseja fechar?"
        confirmMsg.TextColor3 = Config.Theme.TextSecondary
        confirmMsg.TextSize = Config.Sizes.Small
        confirmMsg.Font = Config.Fonts.Regular
        confirmMsg.TextWrapped = true
        confirmMsg.Parent = confirmFrame

        local yesBtn = Instance.new("TextButton")
        yesBtn.Size = UDim2.new(0, 100, 0, 36)
        yesBtn.Position = UDim2.new(0.5, -110, 1, -48)
        yesBtn.BackgroundColor3 = Config.Theme.Success
        yesBtn.Text = "Sim"
        yesBtn.TextColor3 = Config.Theme.Text
        yesBtn.TextSize = Config.Sizes.Small
        yesBtn.Font = Config.Fonts.Medium
        yesBtn.BorderSizePixel = 0
        yesBtn.Parent = confirmFrame
        CreateCorner(yesBtn, 6)

        local noBtn = Instance.new("TextButton")
        noBtn.Size = UDim2.new(0, 100, 0, 36)
        noBtn.Position = UDim2.new(0.5, 10, 1, -48)
        noBtn.BackgroundColor3 = Config.Theme.Danger
        noBtn.Text = "Não"
        noBtn.TextColor3 = Config.Theme.Text
        noBtn.TextSize = Config.Sizes.Small
        noBtn.Font = Config.Fonts.Medium
        noBtn.BorderSizePixel = 0
        noBtn.Parent = confirmFrame
        CreateCorner(noBtn, 6)

        yesBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

        noBtn.MouseButton1Click:Connect(function()
            confirmOverlay:Destroy()
        end)
    end)

    -- Minimizar
    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            Tween(mainFrame, {Size = savedSize, Position = savedPos}, 0.3)
            isMinimized = false
        else
            savedPos = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 50), Position = UDim2.new(0.5, -200, 0.5, -25)}, 0.3)
            isMinimized = true
        end
    end)

    -- Maximizar/Restaurar
    maximizeBtn.MouseButton1Click:Connect(function()
        if isMaximized then
            Tween(mainFrame, {Size = savedSize, Position = savedPos}, 0.3)
            maximizeBtn.Text = "□"
            isMaximized = false
        else
            savedPos = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20)}, 0.3)
            maximizeBtn.Text = "❐"
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
    local currentCategory = nil

    function LunarShell:Category(name, icon)
        local catBtn = Instance.new("TextButton")
        catBtn.Size = UDim2.new(1, -12, 0, 42)
        catBtn.Position = UDim2.new(0, 6, 0, 0)
        catBtn.BackgroundColor3 = Config.Theme.Surface
        catBtn.Text = "  " .. (icon or "◆") .. "  " .. name
        catBtn.TextColor3 = Config.Theme.TextSecondary
        catBtn.TextSize = Config.Sizes.Small
        catBtn.Font = Config.Fonts.Medium
        catBtn.TextXAlignment = Enum.TextXAlignment.Left
        catBtn.BorderSizePixel = 0
        catBtn.Parent = sidebar
        CreateCorner(catBtn, 8)

        local catContainer = Instance.new("Frame")
        catContainer.Size = UDim2.new(1, 0, 0, 0)
        catContainer.BackgroundTransparency = 1
        catContainer.Parent = workarea
        catContainer.Visible = false
        catContainer.AutomaticSize = Enum.AutomaticSize.Y

        local catLayout = Instance.new("UIListLayout")
        catLayout.Parent = catContainer
        catLayout.SortOrder = Enum.SortOrder.LayoutOrder
        catLayout.Padding = UDim.new(0, 10)
        catLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        categories[name] = {
            Button = catBtn,
            Container = catContainer
        }

        catBtn.MouseButton1Click:Connect(function()
            for _, cat in pairs(categories) do
                cat.Button.BackgroundColor3 = Config.Theme.Surface
                cat.Button.TextColor3 = Config.Theme.TextSecondary
                cat.Container.Visible = false
            end
            catBtn.BackgroundColor3 = Config.Theme.Primary
            catBtn.TextColor3 = Config.Theme.Text
            catContainer.Visible = true
            currentCategory = name
        end)

        if not currentCategory then
            task.spawn(function()
                task.wait(0.1)
                catBtn:Click()
            end)
        end

        local categoryAPI = {}

        function categoryAPI:AddScript(name, description, callback)
            local scriptCard = Instance.new("Frame")
            scriptCard.Size = UDim2.new(1, -20, 0, 0)
            scriptCard.BackgroundColor3 = Config.Theme.Surface
            scriptCard.Parent = catContainer
            scriptCard.AutomaticSize = Enum.AutomaticSize.Y
            CreateCorner(scriptCard, 10)
            CreateStroke(scriptCard, 1)

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -24, 0, 28)
            titleLabel.Position = UDim2.new(0, 12, 0, 10)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "📜  " .. name
            titleLabel.TextColor3 = Config.Theme.Text
            titleLabel.TextSize = Config.Sizes.Medium
            titleLabel.Font = Config.Fonts.Bold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = scriptCard

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -24, 0, 36)
            descLabel.Position = UDim2.new(0, 12, 0, 40)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = description or "Sem descrição"
            descLabel.TextColor3 = Config.Theme.TextSecondary
            descLabel.TextSize = Config.Sizes.Small
            descLabel.Font = Config.Fonts.Regular
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextWrapped = true
            descLabel.Parent = scriptCard

            local executeBtn = Instance.new("TextButton")
            executeBtn.Size = UDim2.new(0, 100, 0, 32)
            executeBtn.Position = UDim2.new(1, -112, 1, -42)
            executeBtn.Text = "▶ EXECUTAR"
            executeBtn.TextColor3 = Config.Theme.Text
            executeBtn.TextSize = Config.Sizes.Small
            executeBtn.Font = Config.Fonts.Medium
            executeBtn.BackgroundColor3 = Config.Theme.Success
            executeBtn.BorderSizePixel = 0
            executeBtn.Parent = scriptCard
            CreateCorner(executeBtn, 6)

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
                        LunarShell:Notify("Erro", "Falha ao executar script: " .. tostring(err), "error", 3)
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
            frame.Size = UDim2.new(1, -20, 0, 48)
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

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 48, 0, 24)
            toggleBtn.Position = UDim2.new(1, -60, 0.5, -12)
            toggleBtn.BackgroundColor3 = defaultState and Config.Theme.Success or Config.Theme.SurfaceHover
            toggleBtn.Text = ""
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Parent = frame
            CreateCorner(toggleBtn, 12)

            local toggleKnob = Instance.new("Frame")
            toggleKnob.Size = UDim2.new(0, 20, 0, 20)
            toggleKnob.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            toggleKnob.BackgroundColor3 = Config.Theme.Text
            toggleKnob.BorderSizePixel = 0
            toggleKnob.Parent = toggleBtn
            CreateCorner(toggleKnob, 10)

            local toggled = defaultState or false

            local function updateToggle(state)
                toggled = state
                Tween(toggleBtn, {BackgroundColor3 = toggled and Config.Theme.Success or Config.Theme.SurfaceHover}, 0.2)
                Tween(toggleKnob, {Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                if callback then callback(toggled) end
                SavedData.ScriptsState[name] = toggled
                SaveData()
            end

            toggleBtn.MouseButton1Click:Connect(function()
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
            frame.Size = UDim2.new(1, -20, 0, 70)
            frame.BackgroundColor3 = Config.Theme.Surface
            frame.Parent = catContainer
            CreateCorner(frame, 10)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Config.Theme.Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 60, 0, 24)
            valueLabel.Position = UDim2.new(1, -72, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or 0)
            valueLabel.TextColor3 = Config.Theme.Accent
            valueLabel.TextSize = Config.Sizes.Small
            valueLabel.Font = Config.Fonts.Medium
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = frame

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 1, -20)
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

            local knob = Instance.new("TextButton")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = UDim2.new(0, -7, 0, -5)
            knob.BackgroundColor3 = Config.Theme.Text
            knob.BorderSizePixel = 0
            knob.Text = ""
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
            knob.InputEnded:Connect(function()
                dragging = false
            end)

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
            frame.Size = UDim2.new(1, -20, 0, 70)
            frame.BackgroundColor3 = Config.Theme.Surface
            frame.Parent = catContainer
            CreateCorner(frame, 10)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Config.Theme.Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame

            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, -24, 0, 32)
            dropdownBtn.Position = UDim2.new(0, 12, 1, -40)
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
                    optBtn.Size = UDim2.new(1, 0, 0, 32)
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

                    height = height + 34
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
            divider.Size = UDim2.new(1, -20, 0, 32)
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
            line.Position = UDim2.new(0, 0, 1, -4)
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
        notifFrame.Size = UDim2.new(0, 320, 0, 70)
        notifFrame.Position = UDim2.new(1, -340, 0, 20 + (#notifications * 80))
        notifFrame.BackgroundColor3 = Config.Theme.Surface
        notifFrame.BorderSizePixel = 0
        notifFrame.Parent = screenGui
        CreateCorner(notifFrame, 10)
        CreateStroke(notifFrame, 1)

        local icon = "📌"
        if type == "success" then icon = "✓"
        elseif type == "error" then icon = "✕"
        elseif type == "warning" then icon = "⚠"
        end

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -40, 0, 24)
        titleLabel.Position = UDim2.new(0, 40, 0, 8)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = icon .. "  " .. title
        titleLabel.TextColor3 = Config.Theme.Text
        titleLabel.TextSize = Config.Sizes.Medium
        titleLabel.Font = Config.Fonts.Bold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notifFrame

        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, -40, 0, 30)
        messageLabel.Position = UDim2.new(0, 40, 0, 34)
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
            yesBtn.Size = UDim2.new(0, 60, 0, 28)
            yesBtn.Position = UDim2.new(1, -140, 1, -36)
            yesBtn.BackgroundColor3 = Config.Theme.Success
            yesBtn.Text = "Sim"
            yesBtn.TextColor3 = Config.Theme.Text
            yesBtn.TextSize = Config.Sizes.Small
            yesBtn.Font = Config.Fonts.Medium
            yesBtn.BorderSizePixel = 0
            yesBtn.Parent = notifFrame
            CreateCorner(yesBtn, 6)

            local noBtn = Instance.new("TextButton")
            noBtn.Size = UDim2.new(0, 60, 0, 28)
            noBtn.Position = UDim2.new(1, -70, 1, -36)
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
                    Tween(n, {Position = UDim2.new(1, -340, 0, 20 + ((i-1) * 80))}, 0.2)
                end
            end)

            noBtn.MouseButton1Click:Connect(function()
                if callback then callback(false) end
                notifFrame:Destroy()
                table.remove(notifications, table.find(notifications, notifFrame))
                for i, n in ipairs(notifications) do
                    Tween(n, {Position = UDim2.new(1, -340, 0, 20 + ((i-1) * 80))}, 0.2)
                end
            end)
        end

        Tween(notifFrame, {Position = UDim2.new(1, -340, 0, 20 + ((#notifications-1) * 80))}, 0.3)

        if duration > 0 then
            task.spawn(function()
                task.wait(duration)
                Tween(notifFrame, {Position = UDim2.new(1, -320, 0, 20 + ((#notifications-1) * 80)), BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                notifFrame:Destroy()
                table.remove(notifications, table.find(notifications, notifFrame))
                for i, n in ipairs(notifications) do
                    Tween(n, {Position = UDim2.new(1, -340, 0, 20 + ((i-1) * 80))}, 0.2)
                end
            end)
        end

        return notifFrame
    end

    function LunarShell:Loading(message, duration, callback)
        return CreateLoadingScreen(screenGui, message, duration, callback)
    end

    -- ========== INICIALIZAÇÃO COM SPLASH E KEY ==========
    local function AfterKey()
        splash:SetSuccess()
        task.wait(0.5)
        splash:Destroy()
        mainFrame.Visible = true
        onLoadCallback()
    end

    if requireKey then
        local keyValid = false
        if isfile(keyFilePath) then
            local savedKey = readfile(keyFilePath)
            for _, k in ipairs(validKeys) do
                if string.upper(savedKey) == string.upper(k) then
                    keyValid = true
                    break
                end
            end
        end
        if keyValid then
            AfterKey()
        else
            CreateKeyScreen(screenGui, {
                validKeys = validKeys,
                keyFilePath = keyFilePath,
                getKeyUrl = getKeyUrl,
            }, AfterKey)
        end
    else
        task.wait(0.8)
        AfterKey()
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
