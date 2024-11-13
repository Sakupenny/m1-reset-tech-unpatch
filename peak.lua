repeat task.wait(3) until game:IsLoaded() -- bc all tsb animations load when u join and it might make the script think u dashed

if game.PlaceId ~= 10449761463 then
    return
end

local player = game.Players.LocalPlayer

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", newcclosure(function(instance, ...)
    local method = getnamecallmethod()

    if player and player.Character and (player.Character.FindFirstChild(player.Character, "Ragdoll") or player.Character.FindFirstChild(player.Character, "Freeze")) then
		return oldnamecall(instance, ...)
	end

    if method == "FireServer" and instance.Name == "Communicate" then
        local args = {...}
        if args[1]["Dash"] and (args[1]["Dash"] == Enum.KeyCode.A or args[1]["Dash"] == Enum.KeyCode.D) then
            return
        end
    end

    return oldnamecall(instance, ...)
end))

local UserInputService = game:GetService("UserInputService")
local wasd = {
	[Enum.KeyCode.W] = false,
	[Enum.KeyCode.A] = false,
	[Enum.KeyCode.S] = false,
	[Enum.KeyCode.D] = false,
}

local function isholdingall()
	for _, isHeld in pairs(wasd) do
		if isHeld then
			return true
		end
	end
end

UserInputService.InputBegan:Connect(function(input, typing)
	if typing then
		return
    end

	if wasd[input.KeyCode] ~= nil then
		wasd[input.KeyCode] = true
	end

	if input.KeyCode == Enum.KeyCode.Q and (wasd[Enum.KeyCode.W] or not isholdingall()) then
		local args = {
			[1] = {
				["Dash"] = Enum.KeyCode.W,
				["Key"] = Enum.KeyCode.Q,
				["Goal"] = "KeyPress"
			}
		}
		game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if wasd[input.KeyCode] ~= nil then
		wasd[input.KeyCode] = false
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then
		holdingW = false
	end
end)

local dashSounds = {
    right = {
        "rbxassetid://10481117236",
        "rbxassetid://199145433",
    },
    left = {
        "rbxassetid://10481117326",
        "rbxassetid://3706229543"
    }
}

local dashAnimations = {
    right = "rbxassetid://10480793962",
    left = "rbxassetid://10480796021"
}

local rightDashSound1 = Instance.new("Sound")
rightDashSound1.SoundId = dashSounds.right[1]
rightDashSound1.Volume = 0.8
rightDashSound1.Parent = game:GetService("RobloxReplicatedStorage")

local rightDashSound2 = Instance.new("Sound")
rightDashSound2.SoundId = dashSounds.right[2]
rightDashSound2.Volume = 0.1
rightDashSound2.Parent = game:GetService("RobloxReplicatedStorage")

local leftDashSound1 = Instance.new("Sound")
leftDashSound1.SoundId = dashSounds.left[1]
leftDashSound1.Volume = 0.8
leftDashSound1.Parent = game:GetService("RobloxReplicatedStorage")

local leftDashSound2 = Instance.new("Sound")
leftDashSound2.SoundId = dashSounds.left[2]
leftDashSound2.Volume = 0.1
leftDashSound2.Parent = game:GetService("RobloxReplicatedStorage")

local function onCharacterAdded()
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    task.wait(1)
    humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId == dashAnimations.right then
	    leftDashSound1:Play()
            leftDashSound2.TimePosition = 0.37
            leftDashSound2:Play()
        elseif track.Animation.AnimationId == dashAnimations.left then
            rightDashSound1:Play()
            rightDashSound2.TimePosition = 0.37
            rightDashSound2:Play()
        end
    end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded()
end

--[[
	Happy skidding! No idea why you would wanna skid this shit though
]]
