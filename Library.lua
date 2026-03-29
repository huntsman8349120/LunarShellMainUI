--[[
    TASKPLUS PRO UI LIBRARY
    Tema: Finance Dashboard - Monocromático Minimalista
    Estilo: Moderno, limpo, com animações suaves
    Funcionalidades:
    - Janela flutuante (arrastável)
    - Botões de minimizar, maximizar e fechar com confirmação
    - Sistema de abas/sections
    - Toggle, Slider, Input, Dropdown, Cards
    - Notificações personalizadas
    - Salvamento automático das configurações
    - Painel de informações (Discord, Server, Usuário)
    - Múltiplos temas (Dark, Light, Glass, Midnight)
    - Fonte Gladiola (ou similar)
    - Tecla de atalho para mostrar/ocultar (ex: "P")
--]]

local Taskplus = {}

-- ============================================
-- CONFIGURAÇÕES GLOBAIS
-- ============================================

local Config = {
    Theme = {
        -- Tema Dark (padrão)
        Dark = {
            Background = Color3.fromRGB(10, 10, 12),
            Surface = Color3.fromRGB(18, 18, 22),
            SurfaceHover = Color3.fromRGB(28, 28, 34),
            SurfaceActive = Color3.fromRGB(38, 38, 44),
            Primary = Color3.fromRGB(80, 80, 90),
            PrimaryDark = Color3.fromRGB(60, 60, 70),
            Text = Color3.fromRGB(245, 245, 250),
            TextSecondary = Color3.fromRGB(160, 160, 170),
            TextMuted = Color3.fromRGB(100, 100, 110),
            Border = Color3.fromRGB(45, 45, 55),
            Accent = Color3.fromRGB(100, 100, 120),
            Success = Color3.fromRGB(70, 90, 70),
            Danger = Color3.fromRGB(110, 80, 80),
        },
        -- Tema Light
        Light = {
            Background = Color3.fromRGB(245, 245, 250),
            Surface = Color3.fromRGB(255, 255, 255),
            SurfaceHover = Color3.fromRGB(235, 235, 240),
            SurfaceActive = Color3.fromRGB(225, 225, 230),
            Primary = Color3.fromRGB(100, 100, 110),
            PrimaryDark = Color3.fromRGB(80, 80, 90),
            Text = Color3.fromRGB(20, 20, 25),
            TextSecondary = Color3.fromRGB(80, 80, 90),
            TextMuted = Color3.fromRGB(120, 120, 130),
            Border = Color3.fromRGB(210, 210, 220),
            Accent = Color3.fromRGB(100, 100, 120),
            Success = Color3.fromRGB(70, 90, 70),
            Danger = Color3.fromRGB(110, 80, 80),
        },
        -- Tema Glass (vidro)
        Glass = {
            Background = Color3.fromRGB(0, 0, 0),
            Surface = Color3.fromRGB(30, 30, 40),
            SurfaceHover = Color3.fromRGB(40, 40, 50),
            SurfaceActive = Color3.fromRGB(50, 50, 60),
            Primary = Color3.fromRGB(100, 100, 120),
            PrimaryDark = Color3.fromRGB(80, 80, 100),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 210),
            TextMuted = Color3.fromRGB(140, 140, 150),
            Border = Color3.fromRGB(60, 60, 80),
            Accent = Color3.fromRGB(120, 120, 140),
            Success = Color3.fromRGB(70, 90, 70),
            Danger = Color3.fromRGB(110, 80, 80),
        },
        -- Tema Midnight
        Midnight = {
            Background = Color3.fromRGB(5, 5, 15),
            Surface = Color3.fromRGB(15, 15, 25),
            SurfaceHover = Color3.fromRGB(25, 25, 35),
            SurfaceActive = Color3.fromRGB(35, 35, 45),
            Primary = Color3.fromRGB(70, 70, 100),
            PrimaryDark = Color3.fromRGB(50, 50, 80),
            Text = Color3.fromRGB(220, 220, 250),
            TextSecondary = Color3.fromRGB(140, 140, 180),
            TextMuted = Color3.fromRGB(80, 80, 110),
            Border = Color3.fromRGB(40, 40, 60),
            Accent = Color3.fromRGB(90, 90, 130),
            Success = Color3.fromRGB(60, 80, 60),
            Danger = Color3.fromRGB(100, 70, 70),
        }
    },
    CurrentTheme = "Dark",  -- Dark, Light, Glass, Midnight
    Fonts = {
        Regular = Enum.Font.Gotham,
        Medium = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
        Gladiola = Enum.Font.Gotham,  -- Gladiola não tem no Roblox, usando Gotham
    },
    Sizes = {
        Small = 12,
        Medium = 14,
        Large = 18,
        Title = 24,
        Huge = 32,
    },
    Animations = {
        Speed = 0.2,
    },
    Settings = {
        ToggleKey = Enum.KeyCode.P,  -- Tecla para mostrar/ocultar
        SaveEnabled = true,
        AutoSave = true,
    }
}

-- Dados salvos
local SavedData = {
    Theme = "Dark",
    WindowPosition = nil,
    WindowSize = nil,
    CustomSettings = {}
}

-- ============================================
-- UTILIDADES
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function GetCurrentTheme()
    return Config.Theme[Config.CurrentTheme]
end

local function CreateCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = frame
    return corner
end

local function CreateStroke(frame, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or GetCurrentTheme().Border
    stroke.Parent = frame
    return stroke
end

local function CreateShadow(frame, size)
    local shadow = Instance.new("UIShadow")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.3
    shadow.Radius = size or 12
    shadow.Parent = frame
    return shadow
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or Config.Animations.Speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Sistema de salvamento simples (usando _G para persistência)
local function SaveData()
    if not Config.Settings.SaveEnabled then return end
    _G.TaskplusSavedData = {
        Theme = Config.CurrentTheme,
        Settings = SavedData.CustomSettings
    }
end

local function LoadData()
    if _G.TaskplusSavedData then
        Config.CurrentTheme = _G.TaskplusSavedData.Theme or "Dark"
        SavedData.CustomSettings = _G.TaskplusSavedData.Settings or {}
    end
end

-- ============================================
-- FUNÇÃO PRINCIPAL
-- ============================================

function Taskplus:Init(title, options)
    options = options or {}
    local toggleKey = options.ToggleKey or Config.Settings.ToggleKey
    local theme = options.Theme or Config.CurrentTheme
    
    Config.CurrentTheme = theme
    LoadData()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TaskplusPro"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    
    -- Tela escura de fundo (para modals)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    
    -- Janela principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = options.Size or UDim2.new(0, 900, 0, 620)
    mainFrame.Position = options.Position or UDim2.new(0.5, -450, 0.5, -310)
    mainFrame.BackgroundColor3 = GetCurrentTheme().Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    CreateCorner(mainFrame, 18)
    CreateStroke(mainFrame, 1)
    CreateShadow(mainFrame, 16)
    
    -- ========== BARRA DE TÍTULO COM BOTÕES ==========
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 52)
    titleBar.BackgroundColor3 = GetCurrentTheme().Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    CreateCorner(titleBar, 18)
    
    -- Botões estilo macOS (minimizar, maximizar, fechar)
    local buttonsBar = Instance.new("Frame")
    buttonsBar.Size = UDim2.new(0, 90, 1, 0)
    buttonsBar.Position = UDim2.new(0, 16, 0, 0)
    buttonsBar.BackgroundTransparency = 1
    buttonsBar.Parent = titleBar
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(0, 0, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = GetCurrentTheme().TextSecondary
    closeBtn.TextSize = 14
    closeBtn.Font = Config.Fonts.Regular
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = buttonsBar
    CreateCorner(closeBtn, 14)
    
    -- Botão Minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(0, 34, 0.5, -14)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = GetCurrentTheme().TextSecondary
    minimizeBtn.TextSize = 16
    minimizeBtn.Font = Config.Fonts.Regular
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonsBar
    CreateCorner(minimizeBtn, 14)
    
    -- Botão Maximizar/Restaurar
    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Size = UDim2.new(0, 28, 0, 28)
    maximizeBtn.Position = UDim2.new(0, 68, 0.5, -14)
    maximizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    maximizeBtn.Text = "□"
    maximizeBtn.TextColor3 = GetCurrentTheme().TextSecondary
    maximizeBtn.TextSize = 14
    maximizeBtn.Font = Config.Fonts.Regular
    maximizeBtn.BorderSizePixel = 0
    maximizeBtn.Parent = buttonsBar
    CreateCorner(maximizeBtn, 14)
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 300, 1, 0)
    titleLabel.Position = UDim2.new(0.5, -150, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "taskplus pro"
    titleLabel.TextColor3 = GetCurrentTheme().Text
    titleLabel.TextSize = Config.Sizes.Medium
    titleLabel.Font = Config.Fonts.Gladiola
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = titleBar
    
    -- Área de conteúdo principal
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -32, 1, -76)
    contentArea.Position = UDim2.new(0, 16, 0, 60)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- ========== SIDEBAR ==========
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.new(0, 220, 1, 0)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentArea
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.ScrollBarThickness = 2
    sidebar.ScrollBarImageColor3 = GetCurrentTheme().TextMuted
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 4)
    
    -- ========== ÁREA DE TRABALHO ==========
    local workarea = Instance.new("Frame")
    workarea.Size = UDim2.new(1, -240, 1, 0)
    workarea.Position = UDim2.new(0, 240, 0, 0)
    workarea.BackgroundTransparency = 1
    workarea.Parent = contentArea
    
    local workareaScrolling = Instance.new("ScrollingFrame")
    workareaScrolling.Size = UDim2.new(1, 0, 1, 0)
    workareaScrolling.BackgroundTransparency = 1
    workareaScrolling.BorderSizePixel = 0
    workareaScrolling.Parent = workarea
    workareaScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    workareaScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    workareaScrolling.ScrollBarThickness = 4
    
    local workareaLayout = Instance.new("UIListLayout")
    workareaLayout.Parent = workareaScrolling
    workareaLayout.SortOrder = Enum.SortOrder.LayoutOrder
    workareaLayout.Padding = UDim.new(0, 12)
    workareaLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- ========== SISTEMA DE DRAG (janela flutuante) ==========
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
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
    
    -- ========== FUNÇÕES DA JANELA ==========
    local isMinimized = false
    local isMaximized = false
    local savedPosition = mainFrame.Position
    local savedSize = mainFrame.Size
    
    -- Fechar com confirmação
    closeBtn.MouseButton1Click:Connect(function()
        Taskplus:Notify("Fechar", "Tem certeza que deseja fechar?", "warning", 0, function(confirmed)
            if confirmed then
                screenGui:Destroy()
            end
        end, true) -- true = modo confirmação
    end)
    
    -- Minimizar
    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            Tween(mainFrame, {Size = savedSize, Position = savedPosition}, 0.3)
            minimizeBtn.Text = "─"
            isMinimized = false
        else
            savedPosition = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 60), Position = UDim2.new(0.5, -200, 0.5, -30)}, 0.3)
            minimizeBtn.Text = "□"
            isMinimized = true
        end
    end)
    
    -- Maximizar/Restaurar
    local function toggleMaximize()
        if isMaximized then
            Tween(mainFrame, {Size = savedSize, Position = savedPosition}, 0.3)
            maximizeBtn.Text = "□"
            isMaximized = false
        else
            savedPosition = mainFrame.Position
            savedSize = mainFrame.Size
            Tween(mainFrame, {Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20)}, 0.3)
            maximizeBtn.Text = "❐"
            isMaximized = true
        end
    end
    maximizeBtn.MouseButton1Click:Connect(toggleMaximize)
    
    -- Tecla para mostrar/ocultar
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == toggleKey then
            if visible then
                Tween(mainFrame, {Position = mainFrame.Position + UDim2.new(0, 0, 2, 0), BackgroundTransparency = 1}, 0.3)
                visible = false
            else
                Tween(mainFrame, {Position = savedPosition, BackgroundTransparency = 0}, 0.3)
                visible = true
            end
        end
    end)
    
    -- ========== SISTEMA DE ABAS/SECTIONS ==========
    local sections = {}
    local currentSection = nil
    
    function Taskplus:Section(name, icon)
        local sectionBtn = Instance.new("TextButton")
        sectionBtn.Size = UDim2.new(1, -16, 0, 44)
        sectionBtn.Position = UDim2.new(0, 8, 0, 0)
        sectionBtn.BackgroundColor3 = GetCurrentTheme().Surface
        sectionBtn.Text = "  " .. (icon or "◆") .. "  " .. name
        sectionBtn.TextColor3 = GetCurrentTheme().TextSecondary
        sectionBtn.TextSize = Config.Sizes.Small
        sectionBtn.Font = Config.Fonts.Medium
        sectionBtn.TextXAlignment = Enum.TextXAlignment.Left
        sectionBtn.BorderSizePixel = 0
        sectionBtn.Parent = sidebar
        CreateCorner(sectionBtn, 10)
        
        -- Container da seção na área de trabalho
        local sectionContainer = Instance.new("Frame")
        sectionContainer.Size = UDim2.new(1, 0, 0, 0)
        sectionContainer.BackgroundTransparency = 1
        sectionContainer.Parent = workareaScrolling
        sectionContainer.Visible = false
        sectionContainer.AutomaticSize = Enum.AutomaticSize.Y
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Parent = sectionContainer
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 12)
        sectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        sections[name] = {
            Button = sectionBtn,
            Container = sectionContainer
        }
        
        sectionBtn.MouseButton1Click:Connect(function()
            for _, sec in pairs(sections) do
                sec.Button.BackgroundColor3 = GetCurrentTheme().Surface
                sec.Button.TextColor3 = GetCurrentTheme().TextSecondary
                sec.Container.Visible = false
            end
            sectionBtn.BackgroundColor3 = GetCurrentTheme().Primary
            sectionBtn.TextColor3 = GetCurrentTheme().Text
            sectionContainer.Visible = true
            
            -- Ajustar altura do container
            task.wait(0.05)
            local totalHeight = 0
            for _, child in ipairs(sectionContainer:GetChildren()) do
                if child:IsA("Frame") and child.AutomaticSize == Enum.AutomaticSize.Y then
                    totalHeight = totalHeight + child.AbsoluteSize.Y + 12
                end
            end
            sectionContainer.Size = UDim2.new(1, 0, 0, totalHeight)
        end)
        
        if not currentSection then
            sectionBtn.MouseButton1Click:Fire()
        end
        
        local sectionAPI = {}
        
        function sectionAPI:Divider(title)
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, -32, 0, 40)
            divider.BackgroundTransparency = 1
            divider.Parent = sectionContainer
            divider.LayoutOrder = 999
            
            local dividerText = Instance.new("TextLabel")
            dividerText.Size = UDim2.new(1, 0, 1, 0)
            dividerText.BackgroundTransparency = 1
            dividerText.Text = title
            dividerText.TextColor3 = GetCurrentTheme().Accent
            dividerText.TextSize = Config.Sizes.Medium
            dividerText.Font = Config.Fonts.Bold
            dividerText.TextXAlignment = Enum.TextXAlignment.Left
            dividerText.Parent = divider
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 1, -4)
            line.BackgroundColor3 = GetCurrentTheme().Border
            line.BorderSizePixel = 0
            line.Parent = divider
            
            return divider
        end
        
        function sectionAPI:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -32, 0, 48)
            btn.BackgroundColor3 = GetCurrentTheme().Surface
            btn.Text = text
            btn.TextColor3 = GetCurrentTheme().Text
            btn.TextSize = Config.Sizes.Medium
            btn.Font = Config.Fonts.Medium
            btn.BorderSizePixel = 0
            btn.Parent = sectionContainer
            CreateCorner(btn, 10)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = GetCurrentTheme().SurfaceHover}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = GetCurrentTheme().Surface}, 0.15)
            end)
            
            if callback then
                btn.MouseButton1Click:Connect(callback)
            end
            
            return btn
        end
        
        function sectionAPI:Toggle(text, defaultState, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -32, 0, 48)
            frame.BackgroundColor3 = GetCurrentTheme().Surface
            frame.Parent = sectionContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 200, 1, 0)
            label.Position = UDim2.new(0, 16, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = GetCurrentTheme().Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 48, 0, 24)
            toggleBg.Position = UDim2.new(1, -64, 0.5, -12)
            toggleBg.BackgroundColor3 = defaultState and GetCurrentTheme().Accent or GetCurrentTheme().SurfaceHover
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = frame
            CreateCorner(toggleBg, 12)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Size = UDim2.new(0, 20, 0, 20)
            toggleKnob.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            toggleKnob.BackgroundColor3 = GetCurrentTheme().Text
            toggleKnob.BorderSizePixel = 0
            toggleKnob.Parent = toggleBg
            CreateCorner(toggleKnob, 10)
            
            local toggled = defaultState or false
            
            local function updateToggle(state)
                toggled = state
                Tween(toggleBg, {BackgroundColor3 = toggled and GetCurrentTheme().Accent or GetCurrentTheme().SurfaceHover}, 0.2)
                Tween(toggleKnob, {Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                if callback then callback(toggled) end
                
                -- Salvar estado
                if Config.Settings.AutoSave then
                    SavedData.CustomSettings[text] = toggled
                    SaveData()
                end
            end
            
            toggleBg.MouseButton1Click:Connect(function()
                updateToggle(not toggled)
            end)
            
            -- Carregar estado salvo
            if SavedData.CustomSettings[text] ~= nil then
                updateToggle(SavedData.CustomSettings[text])
            end
            
            return {
                SetState = updateToggle,
                GetState = function() return toggled end
            }
        end
        
        function sectionAPI:Slider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -32, 0, 70)
            frame.BackgroundColor3 = GetCurrentTheme().Surface
            frame.Parent = sectionContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = GetCurrentTheme().Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 60, 0, 24)
            valueLabel.Position = UDim2.new(1, -72, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or 0)
            valueLabel.TextColor3 = GetCurrentTheme().Accent
            valueLabel.TextSize = Config.Sizes.Small
            valueLabel.Font = Config.Fonts.Medium
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = frame
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 1, -20)
            track.BackgroundColor3 = GetCurrentTheme().SurfaceHover
            track.BorderSizePixel = 0
            track.Parent = frame
            CreateCorner(track, 2)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = GetCurrentTheme().Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            CreateCorner(fill, 2)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = UDim2.new(0, -7, 0, -5)
            knob.BackgroundColor3 = GetCurrentTheme().Text
            knob.BorderSizePixel = 0
            knob.Parent = track
            CreateCorner(knob, 7)
            
            local value = default or min
            local dragging = false
            
            local function updateSlider(inputValue)
                local percent = (inputValue - min) / (max - min)
                percent = math.clamp(percent, 0, 1)
                local trackWidth = track.AbsoluteSize.X
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -7, 0, -5)
                value = min + (percent * (max - min))
                valueLabel.Text = string.format("%.1f", value)
                if callback then callback(value) end
                
                if Config.Settings.AutoSave then
                    SavedData.CustomSettings[text] = value
                    SaveData()
                end
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
            
            if SavedData.CustomSettings[text] ~= nil then
                updateSlider(SavedData.CustomSettings[text])
            end
            
            return {
                SetValue = updateSlider,
                GetValue = function() return value end
            }
        end
        
        function sectionAPI:Input(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -32, 0, 70)
            frame.BackgroundColor3 = GetCurrentTheme().Surface
            frame.Parent = sectionContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = GetCurrentTheme().Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(1, -24, 0, 32)
            input.Position = UDim2.new(0, 12, 1, -40)
            input.PlaceholderText = placeholder or "Digite aqui..."
            input.Text = ""
            input.TextColor3 = GetCurrentTheme().Text
            input.PlaceholderColor3 = GetCurrentTheme().TextMuted
            input.TextSize = Config.Sizes.Small
            input.Font = Config.Fonts.Regular
            input.BackgroundColor3 = GetCurrentTheme().SurfaceHover
            input.BorderSizePixel = 0
            input.Parent = frame
            CreateCorner(input, 8)
            
            input:GetPropertyChangedSignal("Text"):Connect(function()
                if callback then callback(input.Text) end
                if Config.Settings.AutoSave then
                    SavedData.CustomSettings[text] = input.Text
                    SaveData()
                end
            end)
            
            if SavedData.CustomSettings[text] then
                input.Text = SavedData.CustomSettings[text]
            end
            
            return {
                SetText = function(t) input.Text = t end,
                GetText = function() return input.Text end
            }
        end
        
        function sectionAPI:Card(title, contentCallback)
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, -32, 0, 0)
            card.BackgroundColor3 = GetCurrentTheme().Surface
            card.Parent = sectionContainer
            card.AutomaticSize = Enum.AutomaticSize.Y
            CreateCorner(card, 12)
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -24, 0, 40)
            titleLabel.Position = UDim2.new(0, 12, 0, 8)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = GetCurrentTheme().Text
            titleLabel.TextSize = Config.Sizes.Medium
            titleLabel.Font = Config.Fonts.Bold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = card
            
            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, -24, 0, 0)
            content.Position = UDim2.new(0, 12, 0, 48)
            content.BackgroundTransparency = 1
            content.Parent = card
            content.AutomaticSize = Enum.AutomaticSize.Y
            
            if contentCallback then
                contentCallback(content)
            end
            
            -- Ajustar altura do card
            task.wait(0.05)
            local contentHeight = 0
            for _, child in ipairs(content:GetChildren()) do
                if child:IsA("Frame") then
                    contentHeight = contentHeight + child.AbsoluteSize.Y + 8
                end
            end
            content.Size = UDim2.new(1, -24, 0, contentHeight)
            card.Size = UDim2.new(1, -32, 0, contentHeight + 56)
            
            return card
        end
        
        function sectionAPI:Dropdown(text, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -32, 0, 70)
            frame.BackgroundColor3 = GetCurrentTheme().Surface
            frame.Parent = sectionContainer
            CreateCorner(frame, 10)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -16, 0, 24)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = GetCurrentTheme().Text
            label.TextSize = Config.Sizes.Medium
            label.Font = Config.Fonts.Regular
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, -24, 0, 32)
            dropdownBtn.Position = UDim2.new(0, 12, 1, -40)
            dropdownBtn.BackgroundColor3 = GetCurrentTheme().SurfaceHover
            dropdownBtn.Text = default or options[1]
            dropdownBtn.TextColor3 = GetCurrentTheme().Text
            dropdownBtn.TextSize = Config.Sizes.Small
            dropdownBtn.Font = Config.Fonts.Regular
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Parent = frame
            CreateCorner(dropdownBtn, 8)
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Position = UDim2.new(0, 0, 1, 4)
            dropdownList.BackgroundColor3 = GetCurrentTheme().Surface
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
                    optBtn.TextColor3 = GetCurrentTheme().Text
                    optBtn.TextSize = Config.Sizes.Small
                    optBtn.Font = Config.Fonts.Regular
                    optBtn.BackgroundColor3 = GetCurrentTheme().SurfaceHover
                    optBtn.BorderSizePixel = 0
                    optBtn.Parent = dropdownList
                    
                    optBtn.MouseButton1Click:Connect(function()
                        currentOption = option
                        dropdownBtn.Text = option
                        isOpen = false
                        dropdownList.Visible = false
                        dropdownList.BackgroundTransparency = 1
                        if callback then callback(option) end
                        
                        if Config.Settings.AutoSave then
                            SavedData.CustomSettings[text] = option
                            SaveData()
                        end
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
            
            if SavedData.CustomSettings[text] then
                currentOption = SavedData.CustomSettings[text]
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
        
        return sectionAPI
    end
    
    -- ========== SISTEMA DE NOTIFICAÇÕES ==========
    local notifications = {}
    
    function Taskplus:Notify(title, message, type, duration, callback, confirmMode)
        type = type or "info"
        duration = duration or 3
        
        local notifFrame = Instance.new("Frame")
        notifFrame.Size = UDim2.new(0, 320, 0, 70)
        notifFrame.Position = UDim2.new(1, -340, 0, 20 + (#notifications * 80))
        notifFrame.BackgroundColor3 = GetCurrentTheme().Surface
        notifFrame.BorderSizePixel = 0
        notifFrame.Parent = screenGui
        CreateCorner(notifFrame, 10)
        CreateStroke(notifFrame, 1)
        
        table.insert(notifications, notifFrame)
        
        -- Ícone baseado no tipo
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
        titleLabel.TextColor3 = GetCurrentTheme().Text
        titleLabel.TextSize = Config.Sizes.Medium
        titleLabel.Font = Config.Fonts.Bold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notifFrame
        
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, -40, 0, 30)
        messageLabel.Position = UDim2.new(0, 40, 0, 34)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message or ""
        messageLabel.TextColor3 = GetCurrentTheme().TextSecondary
        messageLabel.TextSize = Config.Sizes.Small
        messageLabel.Font = Config.Fonts.Regular
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextWrapped = true
        messageLabel.Parent = notifFrame
        
        -- Botões de confirmação
        if confirmMode then
            duration = 0
            local yesBtn = Instance.new("TextButton")
            yesBtn.Size = UDim2.new(0, 60, 0, 28)
            yesBtn.Position = UDim2.new(1, -140, 1, -36)
            yesBtn.BackgroundColor3 = GetCurrentTheme().Success
            yesBtn.Text = "Sim"
            yesBtn.TextColor3 = GetCurrentTheme().Text
            yesBtn.TextSize = Config.Sizes.Small
            yesBtn.Font = Config.Fonts.Medium
            yesBtn.BorderSizePixel = 0
            yesBtn.Parent = notifFrame
            CreateCorner(yesBtn, 6)
            
            local noBtn = Instance.new("TextButton")
            noBtn.Size = UDim2.new(0, 60, 0, 28)
            noBtn.Position = UDim2.new(1, -70, 1, -36)
            noBtn.BackgroundColor3 = GetCurrentTheme().Danger
            noBtn.Text = "Não"
            noBtn.TextColor3 = GetCurrentTheme().Text
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
    
    -- ========== PAINEL DE INFORMAÇÕES ==========
    function Taskplus:InfoPanel(parent, serverInfo, userInfo, discordInfo)
        local panel = Taskplus:CreateCard(parent, 0, 0, 400, 0, "📊  Informações")
        
        local content = panel.Container
        
        -- Informações do Servidor
        local serverTitle = Instance.new("TextLabel")
        serverTitle.Size = UDim2.new(1, 0, 0, 24)
        serverTitle.BackgroundTransparency = 1
        serverTitle.Text = "🖥️  Servidor"
        serverTitle.TextColor3 = GetCurrentTheme().Accent
        serverTitle.TextSize = Config.Sizes.Medium
        serverTitle.Font = Config.Fonts.Bold
        serverTitle.TextXAlignment = Enum.TextXAlignment.Left
        serverTitle.Parent = content
        
        local serverText = Instance.new("TextLabel")
        serverText.Size = UDim2.new(1, 0, 0, 60)
        serverText.BackgroundTransparency = 1
        serverText.Text = serverInfo or "Nome: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\nID: " .. game.PlaceId .. "\nJogadores: " .. #game:GetService("Players"):GetPlayers()
        serverText.TextColor3 = GetCurrentTheme().TextSecondary
        serverText.TextSize = Config.Sizes.Small
        serverText.Font = Config.Fonts.Regular
        serverText.TextXAlignment = Enum.TextXAlignment.Left
        serverText.TextWrapped = true
        serverText.Parent = content
        
        -- Informações do Usuário
        local userTitle = Instance.new("TextLabel")
        userTitle.Size = UDim2.new(1, 0, 0, 24)
        userTitle.Position = UDim2.new(0, 0, 0, 84)
        userTitle.BackgroundTransparency = 1
        userTitle.Text = "👤  Usuário"
        userTitle.TextColor3 = GetCurrentTheme().Accent
        userTitle.TextSize = Config.Sizes.Medium
        userTitle.Font = Config.Fonts.Bold
        userTitle.TextXAlignment = Enum.TextXAlignment.Left
        userTitle.Parent = content
        
        local userText = Instance.new("TextLabel")
        userText.Size = UDim2.new(1, 0, 0, 40)
        userText.Position = UDim2.new(0, 0, 0, 108)
        userText.BackgroundTransparency = 1
        userText.Text = userInfo or "Nome: " .. game:GetService("Players").LocalPlayer.Name .. "\nID: " .. game:GetService("Players").LocalPlayer.UserId
        userText.TextColor3 = GetCurrentTheme().TextSecondary
        userText.TextSize = Config.Sizes.Small
        userText.Font = Config.Fonts.Regular
        userText.TextXAlignment = Enum.TextXAlignment.Left
        userText.TextWrapped = true
        userText.Parent = content
        
        -- Discord
        local discordTitle = Instance.new("TextLabel")
        discordTitle.Size = UDim2.new(1, 0, 0, 24)
        discordTitle.Position = UDim2.new(0, 0, 0, 152)
        discordTitle.BackgroundTransparency = 1
        discordTitle.Text = "💬  Discord"
        discordTitle.TextColor3 = GetCurrentTheme().Accent
        discordTitle.TextSize = Config.Sizes.Medium
        discordTitle.Font = Config.Fonts.Bold
        discordTitle.TextXAlignment = Enum.TextXAlignment.Left
        discordTitle.Parent = content
        
        local discordText = Instance.new("TextLabel")
        discordText.Size = UDim2.new(1, 0, 0, 40)
        discordText.Position = UDim2.new(0, 0, 0, 176)
        discordText.BackgroundTransparency = 1
        discordText.Text = discordInfo or "discord.gg/taskplus\n@taskplus_dev"
        discordText.TextColor3 = GetCurrentTheme().TextSecondary
        discordText.TextSize = Config.Sizes.Small
        discordText.Font = Config.Fonts.Regular
        discordText.TextXAlignment = Enum.TextXAlignment.Left
        discordText.TextWrapped = true
        discordText.Parent = content
        
        -- Botão de copiar convite
        local copyBtn = Taskplus:CreateButton(content, "Copiar Convite", 0, 220, 120, 32, function()
            Taskplus:Notify("Discord", "Link copiado!", "success", 2)
            setclipboard("discord.gg/taskplus")
        end)
        
        return panel
    end
    
    -- ========== TROCAR TEMA ==========
    function Taskplus:SetTheme(themeName)
        if Config.Theme[themeName] then
            Config.CurrentTheme = themeName
            SaveData()
            
            -- Atualizar cores dos elementos (simplificado)
            Taskplus:Notify("Tema", "Tema alterado para " .. themeName, "success", 2)
        end
    end
    
    function Taskplus:GetCurrentTheme()
        return Config.CurrentTheme
    end
    
    -- ========== UTILITÁRIOS ==========
    function Taskplus:CreateButton(parent, text, x, y, width, height, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, width or 120, 0, height or 36)
        btn.Position = UDim2.new(0, x or 0, 0, y or 0)
        btn.Text = text
        btn.TextColor3 = GetCurrentTheme().Text
        btn.TextSize = Config.Sizes.Small
        btn.Font = Config.Fonts.Medium
        btn.BackgroundColor3 = GetCurrentTheme().Surface
        btn.BorderSizePixel = 0
        btn.Parent = parent
        CreateCorner(btn, 8)
        
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = GetCurrentTheme().SurfaceHover}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = GetCurrentTheme().Surface}, 0.15)
        end)
        
        if callback then
            btn.MouseButton1Click:Connect(callback)
        end
        
        return btn
    end
    
    function Taskplus:CreateCard(parent, x, y, width, height, title)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, width or 300, 0, height or 160)
        card.Position = UDim2.new(0, x or 0, 0, y or 0)
        card.BackgroundColor3 = GetCurrentTheme().Surface
        card.BorderSizePixel = 0
        card.Parent = parent
        CreateCorner(card, 12)
        CreateStroke(card, 1)
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -24, 1, -24)
        container.Position = UDim2.new(0, 12, 0, 12)
        container.BackgroundTransparency = 1
        container.Parent = card
        
        if title then
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, 0, 0, 28)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = GetCurrentTheme().Text
            titleLabel.TextSize = Config.Sizes.Medium
            titleLabel.Font = Config.Fonts.Bold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = container
            
            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, 0, 1, -36)
            contentFrame.Position = UDim2.new(0, 0, 0, 32)
            contentFrame.BackgroundTransparency = 1
            contentFrame.Parent = container
            
            return { Frame = card, Container = contentFrame }
        end
        
        return { Frame = card, Container = container }
    end
    
    function Taskplus:CreateSeparator(parent, x, y, width)
        local sep = Instance.new("Frame")
        sep.Size = UDim2.new(width or 1, 0, 0, 1)
        sep.Position = UDim2.new(0, x or 0, 0, y or 0)
        sep.BackgroundColor3 = GetCurrentTheme().Border
        sep.BorderSizePixel = 0
        sep.Parent = parent
        return sep
    end
    
    -- ========== EXPORTAR API ==========
    return {
        Section = Taskplus.Section,
        Notify = Taskplus.Notify,
        InfoPanel = Taskplus.InfoPanel,
        SetTheme = Taskplus.SetTheme,
        GetCurrentTheme = Taskplus.GetCurrentTheme,
        CreateButton = Taskplus.CreateButton,
        CreateCard = Taskplus.CreateCard,
        CreateSeparator = Taskplus.CreateSeparator,
        Window = {
            ToggleMaximize = toggleMaximize,
            Close = function() screenGui:Destroy() end,
            Minimize = function()
                if isMinimized then
                    Tween(mainFrame, {Size = savedSize, Position = savedPosition}, 0.3)
                    minimizeBtn.Text = "─"
                    isMinimized = false
                else
                    savedPosition = mainFrame.Position
                    savedSize = mainFrame.Size
                    Tween(mainFrame, {Size = UDim2.new(0, 400, 0, 60), Position = UDim2.new(0.5, -200, 0.5, -30)}, 0.3)
                    minimizeBtn.Text = "□"
                    isMinimized = true
                end
            end,
            Restore = function()
                if isMinimized then
                    Tween(mainFrame, {Size = savedSize, Position = savedPosition}, 0.3)
                    minimizeBtn.Text = "─"
                    isMinimized = false
                end
                if isMaximized then
                    Tween(mainFrame, {Size = savedSize, Position = savedPosition}, 0.3)
                    maximizeBtn.Text = "□"
                    isMaximized = false
                end
            end
        },
        MainFrame = mainFrame,
        ScreenGui = screenGui
    }
end

return Taskplus
