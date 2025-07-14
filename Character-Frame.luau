-- This was Deleted but recovered. this made in 2024 or 2025 before update plane crazy uis
local RunService = game:GetService('RunService');
local Players = game:GetService('Players');
local Player = Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
local aircraft = game.Workspace:FindFirstChild(Player.Name .. " Aircraft")

local scaleFactor = 1
character:ScaleTo(10)

local bodyPartColors = {
    ["Head"] = Color3.fromRGB(200, 200, 200),
    ["Torso"] = Color3.fromRGB(201, 200, 200),
    ["Left Arm"] = Color3.fromRGB(201, 201, 200),
    ["Right Arm"] = Color3.fromRGB(201, 201, 201),
    ["Left Leg"] = Color3.fromRGB(202, 200, 200),
    ["Right Leg"] = Color3.fromRGB(202, 202, 200)
}

if isR15 then
    bodyPartColors = {
        ["Head"] = Color3.fromRGB(255, 0, 0),
        ["UpperTorso"] = Color3.fromRGB(255, 1, 0),
        ["LowerTorso"] = Color3.fromRGB(255, 2, 0),
        ["LeftUpperArm"] = Color3.fromRGB(255, 3, 0),
        ["LeftLowerArm"] = Color3.fromRGB(255, 4, 0),
        ["RightUpperArm"] = Color3.fromRGB(255, 5, 0),
        ["RightLowerArm"] = Color3.fromRGB(255, 6, 0),
        ["LeftUpperLeg"] = Color3.fromRGB(255, 7, 0),
        ["LeftLowerLeg"] = Color3.fromRGB(255, 8, 0),
        ["RightUpperLeg"] = Color3.fromRGB(255, 9, 0),
        ["RightLowerLeg"] = Color3.fromRGB(255, 10, 0)
    }
end

local linkedParts = {}

for _, part in ipairs(aircraft:GetDescendants()) do
    if part:IsA("BasePart") then
        part.CanCollide = false
    end
end

for bodyPartName, bodyColor in pairs(bodyPartColors) do
    local bodyPart = character:FindFirstChild(bodyPartName)
    if bodyPart then
        for _, aircraftPart in ipairs(aircraft:GetDescendants()) do
            if aircraftPart:IsA("BasePart") and aircraftPart.Color == bodyColor then
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyPosition.D = 10
                bodyPosition.P = 500
                bodyPosition.Parent = aircraftPart

                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.D = 10
                bodyGyro.P = 500
                bodyGyro.Parent = aircraftPart

                linkedParts[bodyPart] = {
                    part = aircraftPart,
                    bodyPos = bodyPosition,
                    bodyGyro = bodyGyro
                }
            end
        end
    else
        warn("Body part not found:", bodyPartName)
    end
end

while true do
    for bodyPart, data in pairs(linkedParts) do
        if bodyPart and data.part and data.bodyPos and data.bodyGyro then
            data.bodyPos.Position = bodyPart.Position * scaleFactor
            data.bodyGyro.CFrame = bodyPart.CFrame
        end
    end
    task.wait(0.05)
end
