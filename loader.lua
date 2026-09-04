if not isfolder("InteliusHub") then
    makefolder("InteliusHub")
end
if not isfolder("InteliusHub/themes") then
    makefolder("InteliusHub/themes")
end

local themeUrl = "https://raw.githubusercontent.com/GAL-67/Intelius/main/Theme/InteliusTheme.json"
local themeContent = game:HttpGet(themeUrl)

writefile("InteliusHub/themes/InteliusTheme.json", themeContent)
writefile("InteliusHub/themes/default.txt", "InteliusTheme")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local HUB_NAME = "Intelius Hub"
local BASE_URL = "https://raw.githubusercontent.com/GAL-67/Intelius/main/allgames/"

local UNSUPPORTED_EXECUTORS = { "Solara", "Xeno" }

if identifyexecutor then
    local executorName = tostring(identifyexecutor()):lower()
    for _, unsupported in ipairs(UNSUPPORTED_EXECUTORS) do
        if executorName:find(unsupported:lower(), 1, true) then
            local player = game:GetService("Players").LocalPlayer
            if player then
                player:Kick(HUB_NAME .. " does not support " .. unsupported .. ". Please switch to a supported executor.")
            end
            return
        end
    end
end

local supportedGames = {
    [8818124] = "violence-district.lua",
    [33910482] = "anime-astral.lua",
}

local creatorId = game.CreatorId
local targetScript = supportedGames[creatorId]

if targetScript then
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(BASE_URL .. targetScript))()
        end)
        if not success then
            warn(HUB_NAME .. ": Failed to load script for creator ID " .. creatorId .. ": " .. tostring(err))
        end
    end)
else
    warn(HUB_NAME .. ": No script available for this game (Creator ID: " .. creatorId .. ")")
end
