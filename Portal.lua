local RunService = game:GetService('RunService');
local UserInputService = game:GetService('UserInputService');
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Aircraft = game.Workspace:FindFirstChild(Player.Name .. " Aircraft")

local Portals_Red = {}
local Portals_Blue = {}
local radius = 4

local Portal_Red_Pos = (Character and Character:FindFirstChild("HumanoidRootPart")) and Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
local Portal_Blue_Pos = Portal_Red_Pos + Vector3.new(0, 0, 15)

if Aircraft then
    local Last_Red = 15
    local Last_Blue = 15

    for _, Part in pairs(Aircraft:GetDescendants()) do
        if Part:IsA("BasePart") then
            local redValue = math.floor(Part.Color.R * 255)
            local blueValue = math.floor(Part.Color.B * 255)

            if math.abs(redValue - Last_Red) <= 10 then
                table.insert(Portals_Red, Part)
                Last_Red = math.clamp(Last_Red + 15, 0, 255)
            end

            if math.abs(blueValue - Last_Blue) <= 10 then
                table.insert(Portals_Blue, Part)
                Last_Blue = math.clamp(Last_Blue + 15, 0, 255)
            end
        end
    end

    for _, Part in ipairs(Portals_Red) do
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = Part
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 10
        bodyGyro.P = 5000

        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Parent = Part
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.D = 10
        bodyPosition.P = 1500
    end

    for _, Part in ipairs(Portals_Blue) do
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = Part
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 10
        bodyGyro.P = 1000

        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Parent = Part
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.D = 10
        bodyPosition.P = 1500
    end
end

local C = 0

local function teleportPlayer(destination)
    if teleportCooldown then return end
    teleportCooldown = true

    local character = Player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(destination)
        end
    end

    task.wait(1)
    teleportCooldown = false
end

for _, Part in ipairs(Portals_Red) do
    Part.Touched:Connect(function(hit)
        if hit.Parent == Character then
            teleportPlayer(Portal_Blue_Pos + Vector3.new(0, 5, 0))
        end
    end)
end

for _, Part in ipairs(Portals_Blue) do
    Part.Touched:Connect(function(hit)
        if hit.Parent == Character then
            teleportPlayer(Portal_Red_Pos + Vector3.new(0, 5, 0))
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if input.KeyCode == Enum.KeyCode.Q then
        Portal_Red_Pos = hrp.Position
    elseif input.KeyCode == Enum.KeyCode.E then
        Portal_Blue_Pos = hrp.Position
    end
end)

RunService.RenderStepped:Connect(function()
    C += 0.25

    for i, Part in ipairs(Portals_Red) do
        local BodyPosition = Part:FindFirstChildOfClass("BodyPosition")
        local BodyGyro = Part:FindFirstChildOfClass("BodyGyro")

        if BodyPosition and BodyGyro then
            local angle = ((i + C) / #Portals_Red) * math.pi * 2
            local offsetX = math.cos(angle) * radius
            local offsetY = (math.sin(angle) * radius) * 1.3

            BodyPosition.Position = Portal_Red_Pos + Vector3.new(offsetX, offsetY + 5, 0)
            BodyGyro.CFrame = CFrame.lookAt(Part.Position, Portal_Red_Pos)
        end
    end

    for i, Part in ipairs(Portals_Blue) do
        local BodyPosition = Part:FindFirstChildOfClass("BodyPosition")
        local BodyGyro = Part:FindFirstChildOfClass("BodyGyro")

        if BodyPosition and BodyGyro then
            local angle = ((i + C) / #Portals_Blue) * math.pi * 2
            local offsetX = math.cos(angle) * radius
            local offsetY = (math.sin(angle) * radius) * 1.3

            BodyPosition.Position = Portal_Blue_Pos + Vector3.new(offsetX, offsetY + 5, 0)
            BodyGyro.CFrame = CFrame.lookAt(Part.Position, Portal_Blue_Pos)
        end
    end
end)
