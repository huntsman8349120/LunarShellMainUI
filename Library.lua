local TaskplusUI = {}

-- ============================================
-- CONFIGURAÇÕES
-- ============================================

local Config = {
    Theme = {
        Background = Color3.fromRGB(13, 13, 13),
        Surface = Color3.fromRGB(23, 23, 23),
        SurfaceHover = Color3.fromRGB(35, 35, 35),
        SurfaceActive = Color3.fromRGB(45, 45, 45),
        Primary = Color3.fromRGB(90, 90, 90),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 160, 160),
        TextMuted = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(120, 120, 120),
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Medium = Enum.Font.GothamMedium,
        Bold = Enum.Font.GothamBold,
    },
    Sizes = {
        Small = 12,
        Medium = 14,
        Large = 18,
        Title = 24,
    }
}

-- ============================================
-- UTILIDADES
-- ============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
    return corner
end

local function CreateStroke(frame, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = Config.Theme.Border
    stroke.Parent = frame
    return stroke
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- ============================================
-- MÉTODOS PRINCIPAIS
-- ============================================

function TaskplusUI:CreateWindow(title, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TaskplusUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size or UDim2.new(0, 850, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
    mainFrame.BackgroundColor3 = Config.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    CreateCorner(mainFrame, 12)
    CreateStroke(mainFrame, 1)
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = Config.Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    CreateCorner(titleBar, 12)
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "taskplus"
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.TextSize = Config.Sizes.Medium
    titleLabel.Font = Config.Fonts.Medium
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -44, 0.5, -16)
    closeBtn.BackgroundColor3 = Config.Theme.SurfaceHover
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Config.Theme.TextSecondary
    closeBtn.TextSize = 16
    closeBtn.Font = Config.Fonts.Regular
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    CreateCorner(closeBtn, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -32, 1, -72)
    contentArea.Position = UDim2.new(0, 16, 0, 56)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    return {
        Gui = screenGui,
        Frame = mainFrame,
        Container = contentArea,
        Destroy = function() screenGui:Destroy() end
    }
end

function TaskplusUI:CreateButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 140, 0, 38)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Text = text
    button.TextColor3 = Config.Theme.Text
    button.TextSize = Config.Sizes.Small
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

function TaskplusUI:CreateToggle(parent, labelText, position, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 36)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
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

function TaskplusUI:CreateSlider(parent, labelText, position, size, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 280, 0, 50)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
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

function TaskplusUI:CreateInput(parent, placeholder, position, size, callback)
    local input = Instance.new("TextBox")
    input.Size = size or UDim2.new(0, 260, 0, 38)
    input.Position = position or UDim2.new(0, 0, 0, 0)
    input.PlaceholderText = placeholder or "Digite aqui..."
    input.Text = ""
    input.TextColor3 = Config.Theme.Text
    input.PlaceholderColor3 = Config.Theme.TextMuted
    input.TextSize = Config.Sizes.Small
    input.Font = Config.Fonts.Regular
    input.BackgroundColor3 = Config.Theme.Surface
    input.BorderSizePixel = 0
    input.Parent = parent
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

function TaskplusUI:CreateCard(parent, position, size, title)
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
        
        return { Frame = card, Container = contentFrame }
    end
    
    return { Frame = card, Container = container }
end

function TaskplusUI:CreateSeparator(parent, position)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = position or UDim2.new(0, 0, 0, 0)
    sep.BackgroundColor3 = Config.Theme.Border
    sep.BorderSizePixel = 0
    sep.Parent = parent
    return sep
end

function TaskplusUI:Notify(title, message, duration)
    local screenGui = game:GetService("CoreGui"):FindFirstChild("TaskplusUI")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TaskplusUI"
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 70)
    notification.Position = UDim2.new(1, -320, 0, 20)
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
        task.wait(duration)
        Tween(notification, {Position = UDim2.new(1, -300, 0, 20), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- ============================================
-- EXPORTAR
-- ============================================

return TaskplusUI
