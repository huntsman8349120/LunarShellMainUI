local TaskplusUI = {}

-- ================================
-- CONFIGURAÇÕES DO TEMA
-- ================================

TaskplusUI.Theme = {
    -- Cores Monocromáticas
    Background = Color3.fromRGB(18, 18, 18),
    Surface = Color3.fromRGB(30, 30, 30),
    SurfaceHover = Color3.fromRGB(45, 45, 45),
    SurfaceActive = Color3.fromRGB(55, 55, 55),
    Primary = Color3.fromRGB(100, 100, 100),
    PrimaryDark = Color3.fromRGB(70, 70, 70),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(170, 170, 170),
    TextMuted = Color3.fromRGB(120, 120, 120),
    Border = Color3.fromRGB(60, 60, 60),
    Success = Color3.fromRGB(80, 80, 80),
    Danger = Color3.fromRGB(120, 80, 80),
    Warning = Color3.fromRGB(120, 100, 80),
    
    -- Gradientes (para efeitos)
    Gradient = {
        Top = Color3.fromRGB(35, 35, 35),
        Bottom = Color3.fromRGB(25, 25, 25)
    }
}

TaskplusUI.Fonts = {
    Default = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Medium = Enum.Font.GothamMedium,
    Light = Enum.Font.GothamLight
}

TaskplusUI.Sizes = {
    Small = 11,
    Medium = 13,
    Large = 16,
    Title = 20,
    Huge = 24
}

-- ================================
-- UTILIDADES
-- ================================

local function createCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
    return corner
end

local function createStroke(frame, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or TaskplusUI.Theme.Border
    stroke.Parent = frame
    return stroke
end

local function createShadow(frame)
    local shadow = Instance.new("UIShadow")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.5
    shadow.Radius = 8
    shadow.Parent = frame
    return shadow
end

-- ================================
-- COMPONENTES BASE
-- ================================

-- Criar janela principal
function TaskplusUI:CreateWindow(title, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TaskplusUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size or UDim2.new(0, 800, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
    mainFrame.BackgroundColor3 = TaskplusUI.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    createCorner(mainFrame, 12)
    createStroke(mainFrame, 1)
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = TaskplusUI.Theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Taskplus"
    titleText.TextColor3 = TaskplusUI.Theme.Text
    titleText.TextSize = TaskplusUI.Sizes.Title
    titleText.Font = TaskplusUI.Fonts.Bold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 8)
    closeBtn.BackgroundColor3 = TaskplusUI.Theme.SurfaceHover
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = TaskplusUI.Theme.TextSecondary
    closeBtn.TextSize = 16
    closeBtn.Font = TaskplusUI.Fonts.Default
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    createCorner(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Container de conteúdo
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 1, -65)
    container.Position = UDim2.new(0, 20, 0, 55)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame
    
    return {
        Gui = screenGui,
        Frame = mainFrame,
        Container = container,
        Destroy = function() screenGui:Destroy() end
    }
end

-- ================================
-- BOTÕES
-- ================================

-- Botão padrão
function TaskplusUI:CreateButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 120, 0, 36)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Text = text or "Button"
    button.TextColor3 = TaskplusUI.Theme.Text
    button.TextSize = TaskplusUI.Sizes.Medium
    button.Font = TaskplusUI.Fonts.Medium
    button.BackgroundColor3 = TaskplusUI.Theme.Primary
    button.BorderSizePixel = 0
    button.Parent = parent
    
    createCorner(button, 6)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = TaskplusUI.Theme.PrimaryDark
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = TaskplusUI.Theme.Primary
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Botão outline (borda apenas)
function TaskplusUI:CreateOutlineButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 120, 0, 36)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Text = text or "Button"
    button.TextColor3 = TaskplusUI.Theme.Text
    button.TextSize = TaskplusUI.Sizes.Medium
    button.Font = TaskplusUI.Fonts.Medium
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Parent = parent
    
    createCorner(button, 6)
    createStroke(button, 1)
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.9
        button.BackgroundColor3 = TaskplusUI.Theme.SurfaceHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 1
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- ================================
-- TOGGLE (Switch)
-- ================================

function TaskplusUI:CreateToggle(parent, labelText, position, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Toggle"
    label.TextColor3 = TaskplusUI.Theme.Text
    label.TextSize = TaskplusUI.Sizes.Medium
    label.Font = TaskplusUI.Fonts.Default
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, 50, 0, 24)
    toggleContainer.Position = UDim2.new(1, -50, 0.5, -12)
    toggleContainer.BackgroundColor3 = defaultState and TaskplusUI.Theme.Primary or TaskplusUI.Theme.SurfaceHover
    toggleContainer.BorderSizePixel = 0
    toggleContainer.Parent = frame
    
    createCorner(toggleContainer, 12)
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 20, 0, 20)
    toggleKnob.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    toggleKnob.BackgroundColor3 = TaskplusUI.Theme.Text
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleContainer
    
    createCorner(toggleKnob, 10)
    
    local toggled = defaultState or false
    
    local function updateToggle(state)
        toggled = state
        toggleContainer.BackgroundColor3 = toggled and TaskplusUI.Theme.Primary or TaskplusUI.Theme.SurfaceHover
        toggleKnob.Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        if callback then callback(toggled) end
    end
    
    toggleContainer.MouseButton1Click:Connect(function()
        updateToggle(not toggled)
    end)
    
    return {
        SetState = updateToggle,
        GetState = function() return toggled end,
        Destroy = function() frame:Destroy() end
    }
end

-- ================================
-- SLIDER (Barra deslizante)
-- ================================

function TaskplusUI:CreateSlider(parent, labelText, position, size, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 250, 0, 50)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Slider"
    label.TextColor3 = TaskplusUI.Theme.Text
    label.TextSize = TaskplusUI.Sizes.Medium
    label.Font = TaskplusUI.Fonts.Default
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or 0)
    valueLabel.TextColor3 = TaskplusUI.Theme.Primary
    valueLabel.TextSize = TaskplusUI.Sizes.Medium
    valueLabel.Font = TaskplusUI.Fonts.Medium
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 0, 4)
    sliderTrack.Position = UDim2.new(0, 0, 1, -10)
    sliderTrack.BackgroundColor3 = TaskplusUI.Theme.SurfaceHover
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = frame
    
    createCorner(sliderTrack, 2)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = TaskplusUI.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    createCorner(sliderFill, 2)
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new(0, 0, 0, -4)
    sliderButton.BackgroundColor3 = TaskplusUI.Theme.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderTrack
    
    createCorner(sliderButton, 6)
    
    local value = default or min
    local dragging = false
    
    local function updateSlider(inputValue)
        local percent = (inputValue - min) / (max - min)
        percent = math.clamp(percent, 0, 1)
        
        local trackWidth = sliderTrack.AbsoluteSize.X
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -6, 0, -4)
        
        value = min + (percent * (max - min))
        valueLabel.Text = string.format("%.1f", value)
        
        if callback then callback(value) end
    end
    
    updateSlider(value)
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = input.Position.X - sliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / sliderTrack.AbsoluteSize.X, 0, 1)
            local newValue = min + (percent * (max - min))
            updateSlider(newValue)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderTrack.AbsolutePosition.X
            local percent = math.clamp(pos / sliderTrack.AbsoluteSize.X, 0, 1)
            local newValue = min + (percent * (max - min))
            updateSlider(newValue)
        end
    end)
    
    return {
        SetValue = updateSlider,
        GetValue = function() return value end,
        Destroy = function() frame:Destroy() end
    }
end

-- ================================
-- DROPDOWN (Menu suspenso)
-- ================================

function TaskplusUI:CreateDropdown(parent, labelText, position, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Dropdown"
    label.TextColor3 = TaskplusUI.Theme.TextSecondary
    label.TextSize = TaskplusUI.Sizes.Small
    label.Font = TaskplusUI.Fonts.Default
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, 0, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 20)
    dropdownBtn.BackgroundColor3 = TaskplusUI.Theme.Surface
    dropdownBtn.Text = default or "Select option"
    dropdownBtn.TextColor3 = TaskplusUI.Theme.Text
    dropdownBtn.TextSize = TaskplusUI.Sizes.Medium
    dropdownBtn.Font = TaskplusUI.Fonts.Default
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Parent = frame
    
    createCorner(dropdownBtn, 6)
    createStroke(dropdownBtn, 1)
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = TaskplusUI.Theme.Surface
    dropdownList.BackgroundTransparency = 1
    dropdownList.Visible = false
    dropdownList.Parent = dropdownBtn
    
    createCorner(dropdownList, 6)
    createStroke(dropdownList, 1)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = dropdownList
    
    local isOpen = false
    local currentOption = default or options[1]
    
    local function updateOptions()
        for _, child in ipairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local height = 0
        for _, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Text = option
            optBtn.TextColor3 = TaskplusUI.Theme.Text
            optBtn.TextSize = TaskplusUI.Sizes.Medium
            optBtn.Font = TaskplusUI.Fonts.Default
            optBtn.BackgroundColor3 = TaskplusUI.Theme.SurfaceHover
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
            
            height = height + 32
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
        UpdateOptions = function(newOptions)
            options = newOptions
            updateOptions()
        end,
        Destroy = function() frame:Destroy() end
    }
end

-- ================================
-- INPUT TEXT (Campo de texto)
-- ================================

function TaskplusUI:CreateInput(parent, placeholder, position, size, callback)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 250, 0, 40)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 1, 0)
    input.PlaceholderText = placeholder or "Type here..."
    input.Text = ""
    input.TextColor3 = TaskplusUI.Theme.Text
    input.PlaceholderColor3 = TaskplusUI.Theme.TextMuted
    input.TextSize = TaskplusUI.Sizes.Medium
    input.Font = TaskplusUI.Fonts.Default
    input.BackgroundColor3 = TaskplusUI.Theme.Surface
    input.BorderSizePixel = 0
    input.Parent = frame
    
    createCorner(input, 6)
    createStroke(input, 1)
    
    input:GetPropertyChangedSignal("Text"):Connect(function()
        if callback then callback(input.Text) end
    end)
    
    return {
        SetText = function(text) input.Text = text end,
        GetText = function() return input.Text end,
        Destroy = function() frame:Destroy() end
    }
end

-- ================================
-- NOTIFICAÇÃO (Toast)
-- ================================

function TaskplusUI:Notify(title, message, duration)
    local screenGui = game:GetService("CoreGui"):FindFirstChild("TaskplusUI")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TaskplusUI"
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 20)
    notification.BackgroundColor3 = TaskplusUI.Theme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    createCorner(notification, 8)
    createStroke(notification, 1)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = TaskplusUI.Theme.Text
    titleLabel.TextSize = TaskplusUI.Sizes.Medium
    titleLabel.Font = TaskplusUI.Fonts.Bold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = TaskplusUI.Theme.TextSecondary
    messageLabel.TextSize = TaskplusUI.Sizes.Small
    messageLabel.Font = TaskplusUI.Fonts.Default
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    duration = duration or 3
    
    task.spawn(function()
        for i = 1, 20 do
            notification.Position = UDim2.new(1, -320 + (i * 2), 0, 20)
            task.wait(0.02)
        end
        task.wait(duration)
        for i = 1, 20 do
            notification.Position = UDim2.new(1, -300 + (i * 10), 0, 20)
            notification.BackgroundTransparency = i / 20
            task.wait(0.02)
        end
        notification:Destroy()
    end)
end

-- ================================
-- SEPARADOR
-- ================================

function TaskplusUI:CreateSeparator(parent, position, width)
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(width or 1, 0, 0, 1)
    separator.Position = position or UDim2.new(0, 0, 0, 0)
    separator.BackgroundColor3 = TaskplusUI.Theme.Border
    separator.BorderSizePixel = 0
    separator.Parent = parent
    return separator
end

-- ================================
-- CARD (Container estilizado)
-- ================================

function TaskplusUI:CreateCard(parent, position, size, title)
    local card = Instance.new("Frame")
    card.Size = size or UDim2.new(0, 300, 0, 200)
    card.Position = position or UDim2.new(0, 0, 0, 0)
    card.BackgroundColor3 = TaskplusUI.Theme.Surface
    card.BorderSizePixel = 0
    card.Parent = parent
    
    createCorner(card, 8)
    createStroke(card, 1)
    
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = TaskplusUI.Theme.Text
        titleLabel.TextSize = TaskplusUI.Sizes.Medium
        titleLabel.Font = TaskplusUI.Fonts.Bold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = card
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -20, 1, -50)
        contentFrame.Position = UDim2.new(0, 10, 0, 45)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = card
        
        return {
            Frame = card,
            Container = contentFrame,
            Destroy = function() card:Destroy() end
        }
    end
    
    return {
        Frame = card,
        Container = card,
        Destroy = function() card:Destroy() end
    }
end

-- ================================
-- TAB SYSTEM (Sistema de abas)
-- ================================

function TaskplusUI:CreateTabSystem(parent, position, tabs)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.Position = position or UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = container
    
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 1, -50)
    contentArea.Position = UDim2.new(0, 0, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = container
    
    local activeTab = nil
    local tabButtons = {}
    
    local function switchTab(tabName)
        if activeTab then
            activeTab.Content.Visible = false
            if tabButtons[activeTab.Name] then
                tabButtons[activeTab.Name].BackgroundTransparency = 1
            end
        end
        
        activeTab = tabs[tabName]
        if activeTab then
            activeTab.Content.Visible = true
            if tabButtons[tabName] then
                tabButtons[tabName].BackgroundTransparency = 0.9
                tabButtons[tabName].BackgroundColor3 = TaskplusUI.Theme.Surface
            end
        end
    end
    
    local xPos = 0
    for name, tab in pairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.Position = UDim2.new(0, xPos, 0, 0)
        tabBtn.Text = name
        tabBtn.TextColor3 = TaskplusUI.Theme.Text
        tabBtn.TextSize = TaskplusUI.Sizes.Medium
        tabBtn.Font = TaskplusUI.Fonts.Medium
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabBar
        
        tab.Content = Instance.new("Frame")
        tab.Content.Size = UDim2.new(1, 0, 1, 0)
        tab.Content.BackgroundTransparency = 1
        tab.Content.Visible = false
        tab.Content.Parent = contentArea
        
        tabBtn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
        
        tabButtons[name] = tabBtn
        xPos = xPos + 105
        
        if not activeTab then
            switchTab(name)
        end
    end
    
    return {
        SwitchTab = switchTab,
        Container = container
    }
end

-- ================================
-- EXPORTAR BIBLIOTECA
-- ================================

return TaskplusUI
