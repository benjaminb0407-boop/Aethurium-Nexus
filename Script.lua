local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LPlr = Players.LocalPlayer
local Cam = workspace.CurrentCamera

getgenv().Aimbot, getgenv().Esp = false, false
getgenv().Smooth = 0.25

local Orion = loadstring(game:HttpGet("https://githubusercontent.com"))()
local W = Orion:MakeWindow({Name = "Aetherium", HidePremium = true, SaveConfig = false})
local KTab = W:MakeTab({Name = "Key System"})
local KeyInput = ""

local function GetClosest()
    local Target, Shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LPlr and p.Character and p.Character:FindFirstChild("Head") and p.Team ~= LPlr.Team then
            local Pos, OnScreen = Cam:WorldToViewportPoint(p.Character.Head.Position)
            local Dist = (Vector2.new(Pos.X, Pos.Y) - UserInputService:GetMouseLocation()).Magnitude
            if OnScreen and Dist < Shortest then Target, Shortest = p, Dist end
        end
    end
    return Target
end

local function LoadHub()
    local Main = Orion:MakeWindow({Name = "Nexus Suite", HidePremium = true, SaveConfig = false})
    local Tab = Main:MakeTab({Name = "Combat"})
    Tab:AddToggle({Name = "Aimbot Assist", Default = false, Callback = function(v) getgenv().Aimbot = v end})
    Tab:AddToggle({Name = "Wall ESP", Default = false, Callback = function(v) getgenv().Esp = v end})
    Orion:Init()

    -- Universal Draggable Minimize Button
    local UI = Instance.new("ScreenGui", CoreGui:FindFirstChild("RobloxGui") or CoreGui)
    local Btn = Instance.new("TextButton", UI)
    Btn.Size, Btn.Position, Btn.Text, Btn.Draggable, Btn.Active = UDim2.new(0,60,0,30), UDim2.new(0.05,0,0.2,0), "MENU", true, true
    
    local Visible = true
    Btn.MouseButton1Click:Connect(function()
        Visible = not Visible
        local Target = CoreGui:FindFirstChild("Orion")
        if Target then Target.Enabled = Visible end
    end)

    RunService.RenderStepped:Connect(function()
        if getgenv().Aimbot and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsKeyDown(Enum.KeyCode.E)) then
            local T = GetClosest()
            if T then Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, T.Character.Head.Position), getgenv().Smooth) end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LPlr and p.Character then
                local Highlight = p.Character:FindFirstChildOfClass("Highlight")
                if getgenv().Esp and p.Team ~= LPlr.Team and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not Highlight then
                        Highlight = Instance.new("Highlight", p.Character)
                        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                    Highlight.Enabled = true
                elseif Highlight then Highlight.Enabled = false end
            end
        end
    end)
end

KTab:AddTextbox({Name = "Enter Passkey", Default = "", TextDisappear = false, Callback = function(v) KeyInput = v end})
KTab:AddButton({Name = "Copy Key URL", Callback = function() if setclipboard then setclipboard("https://pastebin.com") end end})
KTab:AddButton({Name = "Verify", Callback = function()
    if KeyInput == "ACCESS-KEY" then Orion:Destroy() task.wait(0.2) LoadHub() end
end})
Orion:Init()
