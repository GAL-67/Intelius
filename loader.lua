-- Intelius Hub Loader
-- Includes executor compatibility check before loading the game script.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local HUB_NAME = "Intelius Hub"
local BASE_URL = "https://raw.githubusercontent.com/GAL-67/Intelius/main/allgames/"

-- List of unsupported executors (case-insensitive)
local UNSUPPORTED_EXECUTORS = { "Solara", "Xeno" }

-- Check executor compatibility
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

-- Map of creator IDs to their respective script files
local supportedGames = {
    [8818124] = "violence-district.lua",
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
