-- Include EmojiLib
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
        wait(1)  -- Check every second if the player has joined a team
    end
end

-- Call the function to wait for team join
waitForTeamJoin()

-- After joining a team, wait for 5 seconds and then load the screen
wait(5)

-- Create the main ScreenGui for the FPS, time, moon, and level display
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.DisplayOrder = 100
local logoImage = Instance.new("ImageLabel")
logoImage.Parent = screenGui
logoImage.Size = UDim2.new(0, 100, 0, 100) -- Adjust size as needed
logoImage.Position = UDim2.new(0.5, -50, 0, 10) -- Positioned at the top of the screen
logoImage.BackgroundTransparency = 1 -- Make background transparent
logoImage.Image = "rbxassetid://18675236797" -- Replace LOGO_ASSET_ID with your image asset ID
logoImage.ScaleType = Enum.ScaleType.Fit -- Ensure the image fits the frame

-- Create the text label for FPS, time, moon status, and level display
local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 300, 0, 50)  -- Adjusted height for FPS and time
textLabel.Position = UDim2.new(0.5, -150, 0, 120)  -- Centered horizontally, positioned below the logo
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0
textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

-- Create a secondary ScreenGui for the background frame (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create a frame to display as the background
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(-0.694346309, 0, -0.293398231, 0)
Frame.Size = UDim2.new(2.18968058, 0, 2.13707471, 0)
Frame.ZIndex = 0

-- Add aspect ratio constraint to maintain frame aspect ratio
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Parent = Frame
UIAspectRatioConstraint.AspectRatio = 2.127

local frameCount = 0
local lastUpdate = tick()

local isVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.K then
        isVisible = not isVisible  -- Toggle visibility
        screenGui.Enabled = isVisible  -- Show/hide the ScreenGui (FPS and time display)
        ScreenGui.Enabled = isVisible  -- Show/hide the background ScreenGui
    end
end)

-- Moon check UI
local moonCheckLabel = Instance.new("TextLabel")
moonCheckLabel.Parent = screenGui
moonCheckLabel.Size = UDim2.new(0, 300, 0, 40)  -- Adjusted height for moon status
moonCheckLabel.Position = UDim2.new(0.5, -150, 0, 180)  -- Positioned below FPS/Time
moonCheckLabel.Font = Enum.Font.FredokaOne
moonCheckLabel.TextScaled = true
moonCheckLabel.BackgroundTransparency = 1
moonCheckLabel.TextStrokeTransparency = 0
moonCheckLabel.TextColor3 = Color3.fromRGB(0, 255, 255)  -- Set text color to white

-- Level, Beli, Fragments, and Race check UI
local statsCheckLabel = Instance.new("TextLabel")
statsCheckLabel.Parent = screenGui
statsCheckLabel.Size = UDim2.new(0, 300, 0, 50)  -- Adjusted size for stats
statsCheckLabel.Position = UDim2.new(0.5, -150, 0, 230)  -- Positioned below moon status
statsCheckLabel.Font = Enum.Font.FredokaOne
statsCheckLabel.TextScaled = true
statsCheckLabel.BackgroundTransparency = 1
statsCheckLabel.TextStrokeTransparency = 0
statsCheckLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Set text color to white

-- Race check UI
local raceCheckLabel = Instance.new("TextLabel")
raceCheckLabel.Parent = screenGui
raceCheckLabel.Size = UDim2.new(0, 300, 0, 40)  -- Adjusted size for Race
raceCheckLabel.Position = UDim2.new(0.5, -150, 0, 280)  -- Positioned below stats
raceCheckLabel.Font = Enum.Font.FredokaOne
raceCheckLabel.TextScaled = true
raceCheckLabel.BackgroundTransparency = 1
raceCheckLabel.TextStrokeTransparency = 0
raceCheckLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Set text color to white

local playTimeLabel = Instance.new("TextLabel")
playTimeLabel.Parent = screenGui
playTimeLabel.Size = UDim2.new(0, 300, 0, 40)  -- Adjusted size for playtime label
playTimeLabel.Position = UDim2.new(0.5, -150, 0, 330)  -- Positioned below Race check
playTimeLabel.Font = Enum.Font.FredokaOne
playTimeLabel.TextScaled = true
playTimeLabel.BackgroundTransparency = 1
playTimeLabel.TextStrokeTransparency = 0
playTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text color

-- Lưu thời gian khi người chơi gia nhập server
local joinTime = tick()

-- Hàm cập nhật thời gian chơi
local function updatePlayTime()
    local elapsedTime = tick() - joinTime  -- Tính thời gian trôi qua từ khi gia nhập server
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = math.floor(elapsedTime % 60)
    -- Cập nhật nhãn playtime với thời gian đã trôi qua
    playTimeLabel.Text = string.format("⏳ Playtime: %02d:%02d:%02d", hours, minutes, seconds)
end

-- Cập nhật thời gian chơi mỗi giây
spawn(function()
    while wait(1) do  -- Cập nhật mỗi giây
        updatePlayTime()
    end
end)

-- Function to update Level, Beli, Fragments, and Race
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
    local jobID = game.JobId  -- Get the server JobId
    local teleportScript = string.format('game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", "%s")', jobID)

    -- Update the stats and Race with emojis, using the formatNumber function
    statsCheckLabel.Text = string.format("%s Level: %d | 💰 Beli: %s | 💎 Fragments: %s", 
        EmojiLib:getEmoji("star"), level, formatNumber(beli), formatNumber(fragments))
    raceCheckLabel.Text = string.format("%s Race: %s", EmojiLib:getEmoji("rocket"), tostring(race))

    -- Update the label with the teleportation script
    teleportScriptLabel.Text = teleportScript  -- This will display the script on the label
end

-- Function to copy the script to the clipboard
local function copyScriptToClipboard()
    local teleportScript = teleportScriptLabel.Text  -- Get the text from the label
    setclipboard(teleportScript)  -- Copy it to the clipboard (Roblox built-in function)
end

spawn(function()
    while wait(1) do  -- Update every 1 second
        updateStatsAndRace()
    end
end)

-- Event when the script label is clicked to copy the script
teleportScriptLabel.MouseButton1Click:Connect(function()
    copyScriptToClipboard()  -- Copy the script to clipboard when the label is clicked
end)



-- FPS and time update loop
getgenv().Fpscap = getgenv().Fpscap or 15  -- Nếu getgenv().Fpscap trống hoặc chưa được thiết lập, gán giá trị mặc định là 15

-- FPS và thời gian cập nhật
RunService.RenderStepped:Connect(function()
    if not isVisible then return end  -- Bỏ qua tính toán FPS nếu UI bị ẩn
    
    frameCount = frameCount + 1
    local now = tick()

    if now - lastUpdate >= 1 then
        local fps = frameCount / (now - lastUpdate)
        frameCount = 0
        lastUpdate = now

        -- Giới hạn FPS theo giá trị được thiết lập trong getgenv().Fpscap
        local cappedFPS = math.min(fps, tonumber(getgenv().Fpscap) or 15)  -- Sử dụng giá trị mặc định 15 nếu getgenv().Fpscap trống hoặc không phải số

        local userName = LocalPlayer.Name
        local timeString = os.date("%H:%M:%S")  -- Định dạng thời gian là HH:MM:SS
        textLabel.Text = string.format("%s %s\n🎮 FPS: %d\n⏰ Time: %s", EmojiLib:getEmoji("smile"), userName, math.floor(cappedFPS), timeString)
    end
end)

-- Moon check function
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

-- Update moon status in a loop
spawn(function()
    while wait(1) do  -- Check every 1 second
        updateMoonStatus()
    end
end)

-- Update the level in a loop
spawn(function()
    while wait(1) do  -- Check every 1 second
        CheckLevel()
    end
end)

-- Set the global variable for the frame color

-- Function to update the Frame color based on getgenv().Farme value
local function updateFrameColor()
    if getgenv().Farme == "transparent" then
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BackgroundTransparency = 0.5  -- Màu đen với độ trong suốt (mờ)
    elseif getgenv().Farme == "black" then
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    else
        -- Default color nếu không có giá trị phù hợp
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Frame.BackgroundTransparency = 1
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
    ScreenGui.Enabled = isVisible  -- Show/hide the background ScreenGui
end)

-- Ensure the toggle button itself is not hidden
