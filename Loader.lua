local EmojiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoraTaiSen/Screen/refs/heads/main/sinonlib.lua"))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")

-- Wait for the game to fully load and character to be added
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
end

-- Wait for the player to join a team
local function waitForTeamJoin()
    while not LocalPlayer.Team do
        task.wait(1)  -- Check every second if the player has joined a team
    end
end

-- Call the function to wait for team join
waitForTeamJoin()

task.wait(5)
local UserInputService = game:GetService("UserInputService")

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.DisplayOrder = 100

-- Logo
local logoImage = Instance.new("ImageLabel")
logoImage.Parent = screenGui
logoImage.Size = UDim2.new(0, 100, 0, 100)
logoImage.Position = UDim2.new(0.5, -50, 0, 10)
logoImage.BackgroundTransparency = 1
logoImage.Image = "rbxassetid://18675236797" -- Replace with your image asset ID
logoImage.ScaleType = Enum.ScaleType.Fit

-- Text label for FPS, time, moon status, and level
local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0.5, -150, 0, 120)
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0
textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

-- Frame as background
local frame = Instance.new("Frame")
local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

frame.Parent = screenGui
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(-0.694346309, 0, -0.293398231, 0)
frame.Size = UDim2.new(2.18968058, 0, 2.13707471, 0)
frame.ZIndex = 0

uiAspectRatioConstraint.Parent = frame
uiAspectRatioConstraint.AspectRatio = 2.127


local frameCount = 0
local lastUpdate = tick()

-- Variable to track the visibility state
local isVisible = true

-- Toggle the visibility of the UI when the "K" key is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.K then
        isVisible = not isVisible  -- Toggle visibility
        screenGui.Enabled = isVisible  -- Show/hide the ScreenGui (FPS and time display)
    end
end)


local moonCheckLabel = Instance.new("TextLabel")
moonCheckLabel.Parent = screenGui
moonCheckLabel.Size = UDim2.new(0, 300, 0, 40)
moonCheckLabel.Position = UDim2.new(0.5, -150, 0, 190)
moonCheckLabel.Font = Enum.Font.FredokaOne
moonCheckLabel.TextScaled = true
moonCheckLabel.BackgroundTransparency = 1
moonCheckLabel.TextStrokeTransparency = 0
moonCheckLabel.TextColor3 = Color3.fromRGB(0, 255, 255)

-- Stats check UI
local statsCheckLabel = Instance.new("TextLabel")
statsCheckLabel.Parent = screenGui
statsCheckLabel.Size = UDim2.new(0, 300, 0, 50)
statsCheckLabel.Position = UDim2.new(0.5, -150, 0, 230)
statsCheckLabel.Font = Enum.Font.FredokaOne
statsCheckLabel.TextScaled = true
statsCheckLabel.BackgroundTransparency = 1
statsCheckLabel.TextStrokeTransparency = 0
statsCheckLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

-- Race check UI
local raceCheckLabel = Instance.new("TextLabel")
raceCheckLabel.Parent = screenGui
raceCheckLabel.Size = UDim2.new(0, 300, 0, 40)
raceCheckLabel.Position = UDim2.new(0.5, -150, 0, 280)
raceCheckLabel.Font = Enum.Font.FredokaOne
raceCheckLabel.TextScaled = true
raceCheckLabel.BackgroundTransparency = 1
raceCheckLabel.TextStrokeTransparency = 0
raceCheckLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Playtime label
local playTimeLabel = Instance.new("TextLabel")
playTimeLabel.Parent = screenGui
playTimeLabel.Size = UDim2.new(0, 300, 0, 40)
playTimeLabel.Position = UDim2.new(0.5, -150, 0, 330)
playTimeLabel.Font = Enum.Font.FredokaOne
playTimeLabel.TextScaled = true
playTimeLabel.BackgroundTransparency = 1
playTimeLabel.TextStrokeTransparency = 0
playTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Additional functionality like updating FPS, time, or stats can be added below
local joinTime = tick()
local frameCount, lastUpdate = 0, tick()
local isVisible = true

-- Update Playtime Function
local function updatePlayTime()
    local elapsedTime = tick() - joinTime  -- Calculate elapsed time since joining
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = math.floor(elapsedTime % 60)
    -- Update playtime label with the elapsed time
    playTimeLabel.Text = string.format("⏳ Playtime: %02d:%02d:%02d", hours, minutes, seconds)
end
spawn(function()
    while wait(1) do  -- Update every 1 second
        updatePlayTime()
    end
end)

-- Update Stats and Race Function
local function formatNumber(number)
    if number >= 1000000000 then  -- Billion
        return string.format("%.1fB", number / 1000000000)
    elseif number >= 1000000 then  -- Million
        return string.format("%.1fM", number / 1000000)
    elseif number >= 1000 then  -- Thousand
        return string.format("%.1fK", number / 1000)
    else  -- If less than 1000
        return tostring(number)
    end
end

local function updateStatsAndRace()
    local level = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    local beli = LocalPlayer:WaitForChild("Data"):WaitForChild("Beli").Value
    local fragments = LocalPlayer:WaitForChild("Data"):WaitForChild("Fragments").Value
    local race = LocalPlayer:WaitForChild("Data"):WaitForChild("Race").Value

    -- Update the stats and Race with emojis, using the formatNumber function
    statsCheckLabel.Text = string.format("%s Level: %d \n| 💰 Beli: %s | 💎 Fragments: %s|", 
        EmojiLib:getEmoji("star"), level, formatNumber(beli), formatNumber(fragments))
    raceCheckLabel.Text = string.format("%s Race: %s", EmojiLib:getEmoji("rocket"), tostring(race))
end
spawn(function()
    while wait(1) do  -- Update every 1 second
        updateStatsAndRace()
    end
end)

-- Update Moon Status Function
local function updateMoonStatus()
    local moonTextureId = game:GetService("Lighting").Sky.MoonTextureId
    if moonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
        moonCheckLabel.Text = "Moon Status: 🌕 100%"
    elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
        moonCheckLabel.Text = "Moon Status: 🌖 75%"
    elseif moonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
        moonCheckLabel.Text = "Moon Status: 🌗 50%"
    elseif moonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
        moonCheckLabel.Text = "Moon Status: 🌘 25%"
    elseif moonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
        moonCheckLabel.Text = "Moon Status: 🌑 15%"
    else
        moonCheckLabel.Text = "Moon Status: 🌒 0%"
    end
end

spawn(function()
    while wait(1) do  -- Update every 1 second
        updateMoonStatus()
    end
end)

getgenv().Fpscap = getgenv().Fpscap or 15  -- Default FPS cap value is 15

RunService.RenderStepped:Connect(function()
    if not isVisible then return end

    frameCount = frameCount + 1
    local now = tick()

    if now - lastUpdate >= 1 then
        local fps = frameCount / (now - lastUpdate)
        frameCount = 0
        lastUpdate = now

        local cappedFPS = math.min(fps, getgenv().Fpscap)
        local userName = LocalPlayer.Name
        local timeString = os.date("%H:%M:%S")
        textLabel.Text = string.format("😊 %s\n🎮 FPS: %d\n⏰ Time: %s", userName, math.floor(cappedFPS), timeString)
    end
end)
local function updateFrameColor()
    -- Ensure the variable name is correctly referenced and check for its value
    if getgenv().Farme == "transparent" then
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.5  -- Semi-transparent black
    elseif getgenv().Farme == "black" then
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    else
        -- Default case if no valid value
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 1  -- Fully opaque
    end
end
updateFrameColor()

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 50, 0, 50)  -- Set the size to 50x50 for a small round button
toggleButton.Position = UDim2.new(0, 10, 1, -60)  -- Positioned near the bottom-left corner (10px from the left, 60px from the bottom)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Set button color to red
toggleButton.Text = ""  -- Remove text
toggleButton.TextTransparency = 1  -- Ensure the button has no text

-- Add a circle shape to the button
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)  -- Fully round the corners of the button
corner.Parent = toggleButton

-- Add an image to the button (logo)
local logo = Instance.new("ImageLabel")
logo.Parent = toggleButton
logo.Size = UDim2.new(1, 0, 1, 0)  -- Cover the whole button with the logo
logo.Position = UDim2.new(0, 0, 0, 0)  -- Position it at the top-left corner of the button
logo.Image = "rbxassetid://18675335801"  -- Set the logo image

-- Initialize visibility state
local isVisible = true

-- Toggle visibility when the button is clicked
toggleButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible  -- Toggle visibility
    screenGui.Enabled = isVisible  -- Show/hide the ScreenGui (FPS and time display)
end)


