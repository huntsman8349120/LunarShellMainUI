local Library = {}

local TweenService = game:GetService("TweenService")

-- 🎨 TEMA MONOCROMÁTICO
local Theme = {
    Background = Color3.fromRGB(210, 190, 160),
    Surface = Color3.fromRGB(230, 210, 180),
    SurfaceDark = Color3.fromRGB(180, 160, 130),

    Text = Color3.fromRGB(40, 35, 30),
    TextLight = Color3.fromRGB(90, 80, 70),

    Border = Color3.fromRGB(120, 100, 80),
}

local function Tween(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.15), props):Play()
end

local function Corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = obj
end

local function Stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Theme.Border
    s.Thickness = 1
    s.Transparency = 0.4
    s.Parent = obj
end

-- 🚀 INIT
function Library:Init(title)
    local gui = Instance.new("ScreenGui", game.CoreGui)

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 800, 0, 500)
    main.Position = UDim2.new(0.5,-400,0.5,-250)
    main.BackgroundColor3 = Theme.Background
    main.Parent = gui
    Corner(main, 8)

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0,180,1,0)
    sidebar.BackgroundColor3 = Theme.SurfaceDark
    sidebar.Parent = main
    Corner(sidebar, 8)

    local layout = Instance.new("UIListLayout", sidebar)
    layout.Padding = UDim.new(0,5)

    -- CONTENT
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,-180,1,0)
    content.Position = UDim2.new(0,180,0,0)
    content.BackgroundTransparency = 1
    content.Parent = main

    local pages = {}

    function Library:Category(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,35)
        btn.Text = " "..name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Theme.Surface
        btn.TextColor3 = Theme.Text
        btn.Parent = sidebar
        Corner(btn,6)
        Stroke(btn)

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1,0,1,0)
        page.Visible = false
        page.BackgroundTransparency = 1
        page.Parent = content

        pages[name] = {btn=btn,page=page}

        btn.MouseEnter:Connect(function()
            Tween(btn,{BackgroundColor3 = Theme.SurfaceDark})
        end)

        btn.MouseLeave:Connect(function()
            if not page.Visible then
                Tween(btn,{BackgroundColor3 = Theme.Surface})
            end
        end)

        btn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages) do
                p.page.Visible = false
                p.btn.BackgroundColor3 = Theme.Surface
            end

            page.Visible = true
            btn.BackgroundColor3 = Theme.SurfaceDark
        end)

        local api = {}

        function api:AddButton(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0,200,0,40)
            b.Position = UDim2.new(0,20,0,20)
            b.Text = text
            b.BackgroundColor3 = Theme.Surface
            b.TextColor3 = Theme.Text
            b.Parent = page
            Corner(b,6)
            Stroke(b)

            b.MouseEnter:Connect(function()
                Tween(b,{BackgroundColor3 = Theme.SurfaceDark})
            end)

            b.MouseLeave:Connect(function()
                Tween(b,{BackgroundColor3 = Theme.Surface})
            end)

            b.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)
        end

        return api
    end

    return Library
end

return Library
