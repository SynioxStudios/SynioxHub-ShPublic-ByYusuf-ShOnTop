local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketPlaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

local webhook_url = "https://discord.com/api/webhooks/1466412734232133738/bIgEHq2mu9baS2vlrQTPc96_sVoqh5w5Tb1eEaFsCECyIJ5RzfYWJD_BFDw5IApWwN7O"

local function formatNumber(value)
    if not value or value == "N/A" then return "0" end
    local suffixes = {"", "k", "M", "B", "T", "Qa", "Qi"}
    local i = 1
    local tempValue = tonumber(value) or 0
    while tempValue >= 1000 and i < #suffixes do
        tempValue = tempValue / 1000
        i = i + 1
    end
    return i == 1 and string.format("%0.f", tempValue) or string.format("%.1f%s", tempValue, suffixes[i])
end

local function getStats()
    local leaderstats = player:FindFirstChild("leaderstats")
    local durabilityVal = (leaderstats and leaderstats:FindFirstChild("Durability")) or player:FindFirstChild("Durability")
    local agilityVal = (leaderstats and leaderstats:FindFirstChild("Agility")) or player:FindFirstChild("Agility")
    
    return {
        strength = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0,
        rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0,
        kills = leaderstats and leaderstats:FindFirstChild("Kills") and leaderstats.Kills.Value or 0,
        durability = durabilityVal and durabilityVal.Value or 0,
        agility = agilityVal and agilityVal.Value or 0
    }
end

local function sendWebhook()
    local rawStats = getStats()
    local executorName = (identifyexecutor and identifyexecutor()) or "Unknown"
    local gameName = MarketPlaceService:GetProductInfo(game.PlaceId).Name

    local logData = {
        ["embeds"] = {{
            ["title"] = "🚀 Syniox Hub - Script Executed",
            ["color"] = 0,
            ["fields"] = {
                {["name"] = "👤 User Information", ["value"] = "Name: **" .. player.Name .. "**\nID: **" .. player.UserId .. "**", ["inline"] = false},
                {["name"] = "🎮 Game Information", ["value"] = "Game: **" .. gameName .. "**\nID: **" .. game.PlaceId .. "**", ["inline"] = false},
                {["name"] = "💀 Total Kills", ["value"] = "**" .. tostring(rawStats.kills) .. " (" .. formatNumber(rawStats.kills) .. ")**", ["inline"] = false},
                {["name"] = "💪 Strength", ["value"] = "**" .. tostring(rawStats.strength) .. " (" .. formatNumber(rawStats.strength) .. ")**", ["inline"] = true},
                {["name"] = "♻️ Rebirths", ["value"] = "**" .. tostring(rawStats.rebirths) .. " (" .. formatNumber(rawStats.rebirths) .. ")**", ["inline"] = true},
                {["name"] = "🛡️ Durability", ["value"] = "**" .. tostring(rawStats.durability) .. " (" .. formatNumber(rawStats.durability) .. ")**", ["inline"] = true},
                {["name"] = "⚡ Agility", ["value"] = "**" .. tostring(rawStats.agility) .. " (" .. formatNumber(rawStats.agility) .. ")**", ["inline"] = true},
                {["name"] = "⚙️ Executor", ["value"] = "**" .. executorName .. "**", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Syniox Studios Log System • 2026"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local requestFunc = (syn and syn.request) or http_request or request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = webhook_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(logData)
            })
        end)
    end
end

task.spawn(sendWebhook)

loadstring(game:HttpGet("https://raw.githubusercontent.com/SynioxStudios/SynioxHub-ByYusuf-SHHUBOnTop/refs/heads/main/SHHub.lua"))()

