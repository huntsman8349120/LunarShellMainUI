--[[
    TASKPLUS UI LIBRARY
    Tema: Finance Dashboard - Monocromático Minimalista
    Estilo: Limpo, moderno, preto e branco
    Modo de usar: local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/huntsman8349120/EclipseShellUI/main/ModernLibrary"))()
    
    Criado por: Taskplus
    Versão: 2.0
--]]

local TaskplusUI = {}

-- ============================================
-- CONFIGURAÇÕES GLOBAIS
-- ============================================

local Config = {
    Theme = {
        -- Paleta Monocromática Minimalista
        Background = Color3.fromRGB(13, 13, 13),      -- Preto quase absoluto
        Surface = Color3.fromRGB(23, 23, 23),         -- Cinza escuro
        SurfaceHover = Color3.fromRGB(35, 35, 35),    -- Cinza médio
        SurfaceActive = Color3.fromRGB(45, 45, 45),   -- Cinza claro
        Primary = Color3.fromRGB(90, 90, 90),         -- Cinza médio
        PrimaryDark = Color3.fromRGB(70, 70, 70),
        Text = Color3.fromRGB(255, 255, 255),         -- Branco puro
        TextSecondary = Color3.fromRGB(160, 160, 160),-- Cinza claro
        TextMuted = Color3.fromRGB(100, 100, 100),    -- Cinza médio
        Border = Color3.fromRGB(45, 45, 45),          -- Borda sutil
        Accent = Color3.fromRGB(120, 120, 120),       -- Destaque minimalista
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Medium = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
    },
    Sizes = {
        XSmall = 10,
        Small = 12,
        Medium = 14,
        Large = 18,
        XLarge = 24,
        Title = 28,
    },
    Animations = {
        Speed = 0.2,
    }
}

-- ============================================
-- UTILITÁRIOS INTERNOS
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

local function CreateShadow(frame, size)
    local shadow = Instance.new("UIShadow")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.4
    shadow.Radius = size or 8
    shadow.Parent = frame
    return shadow
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or Config.Animations.Speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- ============================================
-- FUNÇÃO PRINCIPAL
-- ============================================

local function Init()
    local self = {}
    
    -- ============================================
    -- CRIAR JANELA PRINCIPAL
    -- ============================================
    
    function self:CreateWindow(title, size)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TaskplusUI"
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ResetOnSpawn = false
        
        -- Container principal
        local container = Instance.new("Frame")
        container.Size = size or UDim2.new(0, 850, 0, 600)
        container.Position = UDim2.new(0.5, -425, 0.5, -300)
        container.BackgroundColor3 = Config.Theme.Background
        container.BorderSizePixel = 0
        container.Parent = screenGui
        CreateCorner(container, 16)
        CreateStroke(container, 1)
        
        -- Barra de título minimalista
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 52)
        titleBar.BackgroundColor3 = Config.Theme.Surface
        titleBar.BorderSizePixel = 0
        titleBar.Parent = container
        CreateCorner(titleBar, 16)
        
        -- Logo/Ícone
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 40, 1, 0)
        icon.Position = UDim2.new(0, 16, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "◆"
        icon.TextColor3 = Config.Theme.Accent
        icon.TextSize = 24
        icon.Font = Config.Fonts.Regular
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.Parent = titleBar
        
        -- Título
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0, 200, 1, 0)
        titleLabel.Position = UDim2.new(0, 56, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "taskplus"
        titleLabel.TextColor3 = Config.Theme.Text
        titleLabel.TextSize = Config.Sizes.Medium
        titleLabel.Font = Config.Fonts.Medium
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar
        
        -- Subtítulo (versão)
        local version = Instance.new("TextLabel")
        version.Size = UDim2.new(0, 100, 1, 0)
        version.Position = UDim2.new(0, 210, 0, 0)
        version.BackgroundTransparency = 1
        version.Text = "v2.0"
        version.TextColor3 = Config.Theme.TextMuted
        version.TextSize = Config.Sizes.XSmall
        version.Font = Config.Fonts.Regular
        version.TextXAlignment = Enum.TextXAlignment.Left
        version.Parent = titleBar
        
        -- Botão fechar minimalista
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 36, 0, 36)
        closeBtn.Position = UDim2.new(1, -48, 0.5, -18)
        closeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Config.Theme.TextSecondary
        closeBtn.TextSize = 16
        closeBtn.Font = Config.Fonts.Regular
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = titleBar
        CreateCorner(closeBtn, 8)
        
        closeBtn.MouseEnter:Connect(function()
            Tween(closeBtn, {BackgroundColor3 = Config.Theme.SurfaceActive}, 0.1)
        end)
        closeBtn.MouseLeave:Connect(function()
            Tween(closeBtn, {BackgroundColor3 = Config.Theme.SurfaceHover}, 0.1)
        end)
        closeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        -- Área de conteúdo principal
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, -32, 1, -76)
        contentArea.Position = UDim2.new(0, 16, 0, 60)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = container
        
        -- Retornar objeto da janela
        return {
            Gui = screenGui,
            Container = contentArea,
            Frame = container,
            Destroy = function() screenGui:Destroy() end
        }
    end
    
    -- ============================================
    -- BOTÃO MINIMALISTA
    -- ============================================
    
    function self:CreateButton(parent, text, position, size, callback)
        local button = Instance.new("TextButton")
        button.Size = size or UDim2.new(0, 140, 0, 40)
        button.Position = position or UDim2.new(0, 0, 0, 0)
        button.Text = text
        button.TextColor3 = Config.Theme.Text
        button.TextSize = Config.Sizes.Medium
        button.Font = Config.Fonts.Medium
        button.BackgroundColor3 = Config.Theme.Surface
        button.BorderSizePixel = 0
        button.Parent = parent
        CreateCorner(button, 8)
        
        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundColor3 = Config.Theme.SurfaceHover}, 0.15)
        end)
        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundColor3 = Config.Theme.Surface}, 0.15)
        end)
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end
    
    -- ============================================
    -- BOTÃO OUTLINE (Borda apenas)
    -- ============================================
    
    function self:CreateOutlineButton(parent, text, position, size, callback)
        local button = Instance.new("TextButton")
        button.Size = size or UDim2.new(0, 140, 0, 40)
        button.Position = position or UDim2.new(0, 0, 0, 0)
        button.Text = text
        button.TextColor3 = Config.Theme.Text
        button.TextSize = Config.Sizes.Medium
        button.Font = Config.Fonts.Medium
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Parent = parent
        CreateCorner(button, 8)
        CreateStroke(button, 1)
        
        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundTransparency = 0.9, BackgroundColor3 = Config.Theme.Surface}, 0.15)
        end)
        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundTransparency = 1}, 0.15)
        end)
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end
    
    -- ============================================
    -- TOGGLE MODERNO
    -- ============================================
    
    function self:CreateToggle(parent, labelText, position, defaultState, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 220, 0, 36)
        frame.Position = position or UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 160, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Config.Theme.TextSecondary
        label.TextSize = Config.Sizes.Small
        label.Font = Config.Fonts.Regular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 44, 0, 22)
        toggleBg.Position = UDim2.new(1, -44, 0.5, -11)
        toggleBg.BackgroundColor3 = defaultState and Config.Theme.Accent or Config.Theme.SurfaceHover
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = frame
        CreateCorner(toggleBg, 11)
        
        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 18, 0, 18)
        toggleKnob.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        toggleKnob.BackgroundColor3 = Config.Theme.Text
        toggleKnob.BorderSizePixel = 0
        toggleKnob.Parent = toggleBg
        CreateCorner(toggleKnob, 9)
        
        local toggled = defaultState or false
        
        local function updateToggle(state)
            toggled = state
            Tween(toggleBg, {BackgroundColor3 = toggled and Config.Theme.Accent or Config.Theme.SurfaceHover}, 0.2)
            Tween(toggleKnob, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)
            if callback then callback(toggled) end
        end
        
        toggleBg.MouseButton1Click:Connect(function()
            updateToggle(not toggled)
        end)
        
        return {
            SetState = updateToggle,
            GetState = function() return toggled end
        }
    end
    
    -- ============================================
    -- SLIDER MINIMALISTA
    -- ============================================
    
    function self:CreateSlider(parent, labelText, position, size, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = size or UDim2.new(0, 280, 0, 50)
        frame.Position = position or UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Config.Theme.TextSecondary
        label.TextSize = Config.Sizes.Small
        label.Font = Config.Fonts.Regular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -50, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default or 0)
        valueLabel.TextColor3 = Config.Theme.Accent
        valueLabel.TextSize = Config.Sizes.Small
        valueLabel.Font = Config.Fonts.Medium
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 3)
        track.Position = UDim2.new(0, 0, 1, -12)
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
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = UDim2.new(0, -6, 0, -4.5)
        knob.BackgroundColor3 = Config.Theme.Text
        knob.BorderSizePixel = 0
        knob.Parent = track
        CreateCorner(knob, 6)
        
        local value = default or min
        local dragging = false
        
        local function updateSlider(inputValue)
            local percent = (inputValue - min) / (max - min)
            percent = math.clamp(percent, 0, 1)
            
            local trackWidth = track.AbsoluteSize.X
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -6, 0, -4.5)
            
            value = min + (percent * (max - min))
            valueLabel.Text = string.format("%.0f", value)
            
            if callback then callback(value) end
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
        
        return {
            SetValue = updateSlider,
            GetValue = function() return value end
        }
    end
    
    -- ============================================
    -- INPUT MODERNO
    -- ============================================
    
    function self:CreateInput(parent, placeholder, position, size, callback)
        local frame = Instance.new("Frame")
        frame.Size = size or UDim2.new(0, 280, 0, 42)
        frame.Position = position or UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(1, 0, 1, 0)
        input.PlaceholderText = placeholder or "Digite aqui..."
        input.Text = ""
        input.TextColor3 = Config.Theme.Text
        input.PlaceholderColor3 = Config.Theme.TextMuted
        input.TextSize = Config.Sizes.Small
        input.Font = Config.Fonts.Regular
        input.BackgroundColor3 = Config.Theme.Surface
        input.BorderSizePixel = 0
        input.Parent = frame
        CreateCorner(input, 8)
        CreateStroke(input, 1)
        
        input:GetPropertyChangedSignal("Text"):Connect(function()
            if callback then callback(input.Text) end
        end)
        
        return {
            SetText = function(text) input.Text = text end,
            GetText = function() return input.Text end
        }
    end
    
    -- ============================================
    -- DROPDOWN MINIMALISTA
    -- ============================================
    
    function self:CreateDropdown(parent, labelText, position, options, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 220, 0, 50)
        frame.Position = position or UDim2.new(0, 0, 0, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Config.Theme.TextSecondary
        label.TextSize = Config.Sizes.XSmall
        label.Font = Config.Fonts.Regular
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(1, 0, 0, 32)
        dropdownBtn.Position = UDim2.new(0, 0, 0, 18)
        dropdownBtn.BackgroundColor3 = Config.Theme.Surface
        dropdownBtn.Text = default or options[1]
        dropdownBtn.TextColor3 = Config.Theme.Text
        dropdownBtn.TextSize = Config.Sizes.Small
        dropdownBtn.Font = Config.Fonts.Regular
        dropdownBtn.BorderSizePixel = 0
        dropdownBtn.Parent = frame
        CreateCorner(dropdownBtn, 6)
        CreateStroke(dropdownBtn, 1)
        
        local dropdownList = Instance.new("Frame")
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownList.Position = UDim2.new(0, 0, 1, 4)
        dropdownList.BackgroundColor3 = Config.Theme.Surface
        dropdownList.BackgroundTransparency = 1
        dropdownList.Visible = false
        dropdownList.Parent = dropdownBtn
        CreateCorner(dropdownList, 6)
        CreateStroke(dropdownList, 1)
        
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
        
        return {
            SetValue = function(option)
                currentOption = option
                dropdownBtn.Text = option
                if callback then callback(option) end
            end,
            GetValue = function() return currentOption end,
            UpdateOptions = updateOptions
        }
    end
    
    -- ============================================
    -- CARD MINIMALISTA
    -- ============================================
    
    function self:CreateCard(parent, position, size, title)
        local card = Instance.new("Frame")
        card.Size = size or UDim2.new(0, 280, 0, 160)
        card.Position = position or UDim2.new(0, 0, 0, 0)
        card.BackgroundColor3 = Config.Theme.Surface
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
            titleLabel.Size = UDim2.new(1, 0, 0, 24)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Config.Theme.Text
            titleLabel.TextSize = Config.Sizes.Medium
            titleLabel.Font = Config.Fonts.Medium
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = container
            
            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, 0, 1, -32)
            contentFrame.Position = UDim2.new(0, 0, 0, 28)
            contentFrame.BackgroundTransparency = 1
            contentFrame.Parent = container
            
            return { Frame = card, Container = contentFrame, Destroy = function() card:Destroy() end }
        end
        
        return { Frame = card, Container = container, Destroy = function() card:Destroy() end }
    end
    
    -- ============================================
    -- SEPARADOR
    -- ============================================
    
    function self:CreateSeparator(parent, position, width)
        local sep = Instance.new("Frame")
        sep.Size = UDim2.new(width or 1, 0, 0, 1)
        sep.Position = position or UDim2.new(0, 0, 0, 0)
        sep.BackgroundColor3 = Config.Theme.Border
        sep.BorderSizePixel = 0
        sep.Parent = parent
        return sep
    end
    
    -- ============================================
    -- NOTIFICAÇÃO (TOAST)
    -- ============================================
    
    function self:Notify(title, message, duration)
        local screenGui = game:GetService("CoreGui"):FindFirstChild("TaskplusUI")
        if not screenGui then
            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "TaskplusUI"
            screenGui.Parent = game:GetService("CoreGui")
        end
        
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 320, 0, 70)
        notification.Position = UDim2.new(1, -340, 0, 20)
        notification.BackgroundColor3 = Config.Theme.Surface
        notification.BorderSizePixel = 0
        notification.Parent = screenGui
        CreateCorner(notification, 10)
        CreateStroke(notification, 1)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 24)
        titleLabel.Position = UDim2.new(0, 12, 0, 8)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "Notificação"
        titleLabel.TextColor3 = Config.Theme.Text
        titleLabel.TextSize = Config.Sizes.Medium
        titleLabel.Font = Config.Fonts.Medium
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification
        
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, -20, 0, 30)
        messageLabel.Position = UDim2.new(0, 12, 0, 34)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message or ""
        messageLabel.TextColor3 = Config.Theme.TextSecondary
        messageLabel.TextSize = Config.Sizes.Small
        messageLabel.Font = Config.Fonts.Regular
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextWrapped = true
        messageLabel.Parent = notification
        
        duration = duration or 3
        
        task.spawn(function()
            Tween(notification, {Position = UDim2.new(1, -340, 0, 20)}, 0.3)
            task.wait(duration)
            Tween(notification, {Position = UDim2.new(1, -320, 0, 20), BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            notification:Destroy()
        end)
    end
    
    -- ============================================
    -- SISTEMA DE ABAS
    -- ============================================
    
    function self:CreateTabSystem(parent, position, tabs)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Position = position or UDim2.new(0, 0, 0, 0)
        container.BackgroundTransparency = 1
        container.Parent = parent
        
        local tabBar = Instance.new("Frame")
        tabBar.Size = UDim2.new(1, 0, 0, 44)
        tabBar.BackgroundTransparency = 1
        tabBar.Parent = container
        
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, 0, 1, -52)
        contentArea.Position = UDim2.new(0, 0, 0, 48)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = container
        
        local activeTab = nil
        local tabButtons = {}
        
        local function switchTab(tabName)
            if activeTab then
                activeTab.Content.Visible = false
                if tabButtons[activeTab.Name] then
                    tabButtons[activeTab.Name].BackgroundColor3 = Config.Theme.Background
                end
            end
            
            activeTab = tabs[tabName]
            if activeTab then
                activeTab.Content.Visible = true
                if tabButtons[tabName] then
                    tabButtons[tabName].BackgroundColor3 = Config.Theme.Surface
                end
            end
        end
        
        local xPos = 0
        for name, tab in pairs(tabs) do
            local tabBtn = Instance.new("TextButton")
            tabBtn.Size = UDim2.new(0, 100, 1, 0)
            tabBtn.Position = UDim2.new(0, xPos, 0, 0)
            tabBtn.Text = name
            tabBtn.TextColor3 = Config.Theme.Text
            tabBtn.TextSize = Config.Sizes.Small
            tabBtn.Font = Config.Fonts.Medium
            tabBtn.BackgroundTransparency = 1
            tabBtn.BorderSizePixel = 0
            tabBtn.Parent = tabBar
            CreateCorner(tabBtn, 6)
            
            tab.Content = Instance.new("Frame")
            tab.Content.Size = UDim2.new(1, 0, 1, 0)
            tab.Content.BackgroundTransparency = 1
            tab.Content.Visible = false
            tab.Content.Parent = contentArea
            
            tabBtn.MouseButton1Click:Connect(function()
                switchTab(name)
            end)
            
            tabButtons[name] = tabBtn
            xPos = xPos + 108
            
            if not activeTab then
                switchTab(name)
            end
        end
        
        return { SwitchTab = switchTab, Container = container }
    end
    
    return self
end

-- ============================================
-- EXPORTA A LIBRARY COM SUPORTE A PARÂMETRO
-- ============================================

return function(advancedMode)
    local ui = Init()
    if advancedMode then
        ui.AdvancedMode = true
        print("[Taskplus] Modo avançado ativado")
    end
    return ui
end
