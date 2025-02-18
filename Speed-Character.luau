local Player = game.Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

humanoid.JumpPower = 100
humanoid.WalkSpeed = 95
