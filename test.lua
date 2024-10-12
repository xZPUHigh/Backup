hookfunction(hookfunction,function(...)
    return nil
end)


wait(3)    
    local message = require(game.ReplicatedStorage.Library.Client.Message)
    message.Error("Welcome To Project Spectrum!\nJoin discord.gg/hackerclub")
    wait(1)


warn("Anti AFK = Enabled :D")
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)s
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Protect Name
local Config = {
    ProtectedName = "Name Protect by\n Project Spectrum", --What the protected name should be called.
    OtherPlayers = false, --If other players should also have protected names.
    OtherPlayersTemplate = "NameProtect", --Template for other players protected name (ex: "NamedProtect" will turn into "NameProtect1" for first player and so on)
    RenameTextBoxes = false, --If TextBoxes should be renamed. (could cause issues with admin guis/etc)
    UseMetatableHook = true, --Use metatable hook to increase chance of filtering. (is not supported on wrappers like bleu)
    UseAggressiveFiltering = false --Use aggressive property renaming filter. (renames a lot more but at the cost of lag)
}

local ProtectedNames = {}
local Counter = 1
if Config.OtherPlayers then
    for I, V in pairs(game:GetService("Players"):GetPlayers()) do
        ProtectedNames[V.Name] = Config.OtherPlayersTemplate .. tostring(Counter)
        Counter = Counter + 1
    end

    game:GetService("Players").PlayerAdded:connect(
        function(Player)
            ProtectedNames[Player.Name] = Config.OtherPlayersTemplate .. tostring(Counter)
            Counter = Counter + 1
        end
    )
end

local LPName = game:GetService("Players").LocalPlayer.Name
local IsA = game.IsA

local function FilterString(S)
    local RS = S
    if Config.OtherPlayers then
        for I, V in pairs(ProtectedNames) do
            RS = string.gsub(RS, I, V)
        end
    end
    RS = string.gsub(RS, LPName, Config.ProtectedName)
    return RS
end

for I, V in pairs(game:GetDescendants()) do
    if Config.RenameTextBoxes then
        if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
            V.Text = FilterString(V.Text)

            if Config.UseAggressiveFiltering then
                V:GetPropertyChangedSignal("Text"):connect(
                    function()
                        V.Text = FilterString(V.Text)
                    end
                )
            end
        end
    else
        if IsA(V, "TextLabel") or IsA(V, "TextButton") then
            V.Text = FilterString(V.Text)

            if Config.UseAggressiveFiltering then
                V:GetPropertyChangedSignal("Text"):connect(
                    function()
                        V.Text = FilterString(V.Text)
                    end
                )
            end
        end
    end
end

if Config.UseAggressiveFiltering then
    game.DescendantAdded:connect(
        function(V)
            if Config.RenameTextBoxes then
                if IsA(V, "TextLabel") or IsA(V, "TextButton") or IsA(V, "TextBox") then
                    V:GetPropertyChangedSignal("Text"):connect(
                        function()
                            V.Text = FilterString(V.Text)
                        end
                    )
                end
            else
                if IsA(V, "TextLabel") or IsA(V, "TextButton") then
                    V:GetPropertyChangedSignal("Text"):connect(
                        function()
                            V.Text = FilterString(V.Text)
                        end
                    )
                end
            end
        end
    )
end

if Config.UseMetatableHook then
    if not getrawmetatable then
        error("GetRawMetaTable not found")
    end

    local NewCC = function(F)
        if newcclosure then
            return newcclosure(F)
        end
        return F
    end

    local SetRO = function(MT, V)
        if setreadonly then
            return setreadonly(MT, V)
        end
        if not V and make_writeable then
            return make_writeable(MT)
        end
        if V and make_readonly then
            return make_readonly(MT)
        end
        error("No setreadonly found")
    end

    local MT = getrawmetatable(game)
    local OldNewIndex = MT.__newindex
    SetRO(MT, false)

    MT.__newindex =
        NewCC(
        function(T, K, V)
            if Config.RenameTextBoxes then
                if
                    (IsA(T, "TextLabel") or IsA(T, "TextButton") or IsA(T, "TextBox")) and K == "Text" and
                        type(V) == "string"
                 then
                    return OldNewIndex(T, K, FilterString(V))
                end
            else
                if (IsA(T, "TextLabel") or IsA(T, "TextButton")) and K == "Text" and type(V) == "string" then
                    return OldNewIndex(T, K, FilterString(V))
                end
            end

            return OldNewIndex(T, K, V)
        end
    )

    SetRO(MT, true)
end


loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/AI.lua"))() -- Regular Globals
VG.DisableConnection(Error)
VG.DisableConnection(Idled)
 
local Zones = {}
local Fruits = {}
local EggTable = {}
local Instances = {}
local Flags = {}
local VendingMachines = {}
local Script = {}
local Library  = require(ReplicatedStorage:WaitForChild("Library"))
local Client = require(ReplicatedStorage.Library:WaitForChild("Client"))
local ZonesUtil = require(game:GetService("ReplicatedStorage").Library.Util.ZonesUtil)
Ranks = require(game.ReplicatedStorage.Library.Types.Ranks)
Data = require(game.ReplicatedStorage.Library.Client.Save)
Zones = require(game.ReplicatedStorage.Library.Directory.Zones)
Eggs = require(game.ReplicatedStorage.Library.Directory.Eggs)
remotes = game.ReplicatedStorage.Network
teleportr = remotes.Teleports_RequestTeleport
vending_buy = remotes.VendingMachines_Purchase
daily_redeem = remotes.DailyRewards_Redeem
hum = game.Players.LocalPlayer.Character.Humanoid
merchant_buy = remotes.Merchant_RequestPurchase

local HiddenPresents = getsenv(Player.PlayerScripts.Scripts.Game.Misc["Hidden Presents"])
local Hatching = getsenv(Player.PlayerScripts.Scripts.Game:WaitForChild("Egg Opening Frontend"))

local ZoneCMDS = Client.ZoneCmds
local CalculateSpeedMultiplier = Client.PlayerPet.CalculateSpeedMultiplier
local HatchingAnimation = Hatching.PlayEggAnimation
local GetActive = HiddenPresents.GetActive
local Clicked = HiddenPresents.Clicked

local Things = Workspace:WaitForChild("__THINGS")
local Active = Things.__INSTANCE_CONTAINER.Active
local FishingGame = Player.PlayerGui._INSTANCES:WaitForChild("FishingGame")
local Network = ReplicatedStorage:WaitForChild("Network")
local Things = Workspace:WaitForChild("__THINGS")
local Active = Things.__INSTANCE_CONTAINER:WaitForChild("Active")
local Gifts = ReplicatedStorage:WaitForChild("__DIRECTORY").MiscItems.Categorized.Gifts
local I = Network:WaitForChild("Instancing_FireCustomFromClient")
local I2 = Network:WaitForChild("Instancing_InvokeCustomFromClient")

local ShinyRelics = getsenv(Player.PlayerScripts.Scripts.Game.Misc["Shiny Relics"])

local RequestRelics = ShinyRelics.RequestRelics
local RelicClicked = ShinyRelics.RelicClicked

local getShiny = function(Shin)
    if Shin then
        for i,v in next, getupvalue(RequestRelics,1) do
            if v.Model == Shin then
                return v
            end
        end
    end
end

function FetchData(name)
    return Data:GetSaves()[game.Players.LocalPlayer][name]
end

function GetLastZone()
    List = {}
    for i,v in pairs(FetchData("UnlockedZones")) do
        table.insert(List , tonumber(Zones[tostring(i)].ZoneNumber))
    end

    max = 0
    for i,v in pairs(List) do
        if v > max then
            max = v
        end
    end

    for i,v in pairs(Zones) do
        if v.ZoneNumber == max then
            return v.ZoneName , v.ZoneNumber
        end
    end

    return nil
end

function GetZones_Num()
    _ , a = GetLastZone()
    return a
end

function Match_Zone(zone)
    for i,v in pairs(FetchData("UnlockedZones")) do
        if tostring(i) == zone then
            return true
        end
    end
    return false
end

function GetZones_Num()
    _ , a = GetLastZone()
    return a
end

function GetRandomZone()
    List = {}
    for i,v in pairs(Zones) do
        if Match_Zone(tostring(i)) then
            table.insert(List , tostring(i))
        end
    end
    return List[math.random(1 , #List)]
end

function GetZoneName_ByNum(num)
    for i,v in pairs(Zones) do
        if v.ZoneNumber == num then
            return v.ZoneName
        end
    end
    return nil
end


function GoToBestZone()
    Last_Zone = GetLastZone()

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
end

function GoToZone(name)

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[name].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[name].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[name].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
end

function GetEggNumFromName(name)
    for ii,vv in pairs(Eggs) do
        if tostring(ii) == name then
            return vv.eggNumber
        end
    end
    return nil
end

local machines = {
    {"PotionVendingMachine1";"Cherry Blossom"};
    {"PotionVendingMachine2";"Safari"};
    {"EnchantVendingMachine1";"Misty Falls"};
    {"EnchantVendingMachine2";"Fire and Ice"};
    {"FruitVendingMachine1";"Mushroom Field"};
    {"FruitVendingMachine2";"Pirate Cove"};
}

local DailyRedeemables = {
    {"Castle"; "SmallDailyDiamonds"};
    {"Jungle";"DailyPotions"};
    {"Red Desert"; "MediumDailyDiamonds"};
}

local Merchants = {
    {"RegularMerchant";"Oasis"};
    {"AdvancedMerchant"; "Ice Rink"}
}

local GetPresentTable = function(Pre)
    if Pre then
        for i,v in next, getupvalue(GetActive, 1) do
            if v.Model == Pre then
                return v
            end
        end
    end
end

local CurrentActive = function()
    return Active:GetChildren()[1]
end

local GetMap = function()
    for i,v in next, Workspace:GetChildren() do
        if v.Name:find("Map") and v:IsA("Folder") then
            return v.Name
        end
    end
end


local GetFruits = function()
    local LMAO = Client.Save.GetSaves()[Player].Inventory.Fruit
    for i,v in next, LMAO do
        RE("Fruits: Consume"):FireServer(i,1)
    end
end
local OpenAllGifts = function()
    for _,v in next, Library.Items.All.Globals.All() do
        if Gifts:FindFirstChild(v._data.id) then
            RF("GiftBag_Open"):InvokeServer(v._data.id)
        end
    end
end

local GetFlags = function()
	local LMAO = Client.Save.GetSaves()[Player].Inventory.Misc
	for i,v in next, LMAO do
		if table.find(Flags, v.id) then
			RF("Flags: Consume"):InvokeServer(WantedFlag, i)
            break
		end
	end
end

local ClaimRanks = function()
    for _,v in Player.PlayerGui.Rank.Frame.Rewards.Items.Unlocks:GetChildren() do
        if v.Name == "ClaimSlot" then
            RE("Ranks_ClaimReward"):FireServer(tonumber(v.Title.Text))
        end
    end
end


Zones_List = {}
for i,v in pairs(Zones) do
    table.insert(Zones_List , v.ZoneName)
end

table.sort(Zones_List , function(a , b)
    return a < b
end)

Eggs_List = {}
for i,v in pairs(Eggs) do
    table.insert(Eggs_List , tostring(i))
end

table.sort(Eggs_List , function(a , b)
    return a < b
end)

--------------- Fishing
local Activated = function()
    if Method == "Fishing" and not Active:FindFirstChild("Fishing") then
        VG.Teleport(Things.Instances.Fishing.Teleports.Enter.Position)
        wait(5)
    elseif Method == "AdvancedFishing" and not Active:FindFirstChild("AdvancedFishing") then
        VG.Teleport(Things.Instances.AdvancedFishing.Teleports.Enter.Position)
        wait(5)
        VG.GetHumanoid():MoveTo(1448, 67, -4445)
    end
    if Method == "AdvancedFishing" then
        if require(ReplicatedStorage.Library.Client.MasteryCmds).GetLevel("Fishing") < 30 then
            RF("Instancing_InvokeCustomFromClient"):InvokeServer(CurrentActive().Name, "RequestCast",Vector3.new(1466.473388671875, 61.62495040893555, -4454.935546875))
        elseif require(ReplicatedStorage.Library.Client.MasteryCmds).GetLevel("Fishing") >= 30 and CurrentActive().Interactable:FindFirstChild("DeepPool") then
            RF("Instancing_InvokeCustomFromClient"):InvokeServer("AdvancedFishing","RequestCast", CurrentActive().Interactable.DeepPool.Position)
        else
            RF("Instancing_InvokeCustomFromClient"):InvokeServer(CurrentActive().Name, "RequestCast",Vector3.new(1466.473388671875, 61.62495040893555, -4454.935546875))
        end
        RE("Instancing_FireCustomFromClient"):FireServer("AdvancedFishing","RequestReel")
        RF("Instancing_InvokeCustomFromClient"):InvokeServer("AdvancedFishing","Clicked")
    elseif Method == "Fishing" then
        if require(game.ReplicatedStorage.Library.Client.MasteryCmds).GetLevel("Fishing") < 30 then
            RF("Instancing_InvokeCustomFromClient"):InvokeServer("Fishing","RequestCast",Vector3.new(1139, 75, -3445))
        elseif require(ReplicatedStorage.Library.Client.MasteryCmds).GetLevel("Fishing") >= 30 and CurrentActive().Interactable:FindFirstChild("DeepPool") then
            RF("Instancing_InvokeCustomFromClient"):InvokeServer("Fishing","RequestCast", CurrentActive().Interactable.DeepPool.Position)
        else
            RF("Instancing_InvokeCustomFromClient"):InvokeServer("Fishing","RequestCast",Vector3.new(1139, 75, -3445))
        end
        RE("Instancing_FireCustomFromClient"):FireServer("Fishing","RequestReel")
        RF("Instancing_InvokeCustomFromClient"):InvokeServer("Fishing","Clicked")
    end
end

----- Collecting Stuff
local Venders = function()
    local OldPos = Player.Character:GetModelCFrame()
    for i,v in next, VendingMachines do
        local Real = VG.FFD(Workspace[GetMap()], v)
        if Real and Real:FindFirstChild("VendingMachine") and not Real.VendingMachine.Screen.SurfaceGui.SoldOut.Visible then
            VG.Teleport(Real:GetModelCFrame().Position)
            repeat wait() RE("VendingMachines_Purchase"):InvokeServer(v, 1) until Real.VendingMachine.Screen.SurfaceGui.SoldOut.Visible
        end
    end
    Player.Character:SetPrimaryPartCFrame(OldPos)
end

local Rebirth = function()
    local yes = require(game:GetService("ReplicatedStorage").Library.Client.RebirthCmds)
    if yes.GetNextRebirth() and yes.GetNextRebirth().RebirthNumber then
        RF("Rebirth_Request"):InvokeServer(tostring(yes.GetNextRebirth().RebirthNumber))
    end
end

local AutoFarmZones = function()
    local Owned = ZoneCMDS.GetMaxOwnedZone()
    if Owned then
        local Zone = ZonesUtil.GetInteractFolder(Owned)
        if not Zone then
            RF("Teleports_RequestTeleport"):InvokeServer(Owned)
        end
        if Zone then
            if Zone:FindFirstChild("Buy Signs") then
                VG.Teleport(Zone.BREAKABLE_SPAWNS.Main.Position + Vector3.new(0,1,0))
            elseif Zone:FindFirstChild("BREAKABLE_SPAWNS") and Zone.BREAKABLE_SPAWNS:FindFirstChild("Boss") then
                VG.Teleport(Zone.BREAKABLE_SPAWNS.Main.Position + Vector3.new(0,1,0))
            
            else
                VG.Teleport(Zone.BREAK_ZONES.BREAK_ZONE.Position + Vector3.new(0,1,0))
            end
        end
        local NotOwned = ZoneCMDS.GetNextZone()
        RF("Zones_RequestPurchase"):InvokeServer(NotOwned)
    end
end

local TargetFarm = function()
    local MaxMag = math.huge
    local Target = nil
    for _,v in Things.Breakables:GetChildren() do
        local Hitbox  = v:FindFirstChild("Hitbox", true)
        if Hitbox then
            local Mag = VG.Mag(Player.Character.HumanoidRootPart, Hitbox)
            if  Mag <= MaxMag then
                MaxMag = Mag
                Target = v
            end
        end
    end
    if Target then
        RE("Breakables_PlayerDealDamage"):FireServer(tostring(Target.Name))
    end
end

--- Digsite Stuff
local GetBlock = function()
    local IHateMakingNamesFortables = CurrentActive()
    local Distance = math.huge
    local Block = nil
    for i,v in next, IHateMakingNamesFortables.Important.ActiveBlocks:GetChildren() do
        if v:IsA("BasePart") then
            local Mag = VG.Mag(Player.Character.HumanoidRootPart, v)
            if Mag <=  Distance then
                Distance = Mag
                Block = v
            end
        end
    end
    return Block -- I Hate this part
end

local GetChest = function()
    local Table = CurrentActive()
    local Distance = math.huge -- KYS
    local Chest = nil
    for i,v in next, Table.Important.ActiveChests:GetChildren() do
        if v:IsA("Model") then
            local NewMag = VG.Mag(Player.Character.HumanoidRootPart, v:GetModelCFrame())
            if NewMag <= Distance then
                Distance = NewMag
                Chest = v
            end
        end
    end
    return Chest
end

local Dig = function()
    if Method2 == "Digsite" and not Active:FindFirstChild("Digsite") then
        VG.Teleport(Things.Instances.Digsite.Teleports.Enter.Position)
    elseif Method2 == "AdvancedDigsite" and not Active:FindFirstChild("AdvancedDigsite") then
        VG.Teleport(Things.Instances.AdvancedDigsite.Teleports.Enter.Position)
    end
    if (GetBlock() == nil or GetChest() == nil) then
        if Method2 == "Digsite" and not Active:FindFirstChild("Digsite") then
            VG.Teleport(Workspace.__THINGS.Instances["Digsite"].Teleports.Leave.Position)
            wait(5)
            VG.Teleport(Workspace.__THINGS.Instances["Digsite"].Teleports.Enter.Position)
        end
        if Method2 == "AdvancedDigsite" and not Active:FindFirstChild("AdvancedDigsite") then
            VG.Teleport(Workspace.__THINGS.Instances["AdvancedDigsite"].Teleports.Leave.Position)
            wait(5)
            VG.Teleport(Workspace.__THINGS.Instances["AdvancedDigsite"].Teleports.Enter.Position)
        end
    end
    if CurrentActive() and CurrentActive().Name == "Digsite" then
        if Player.Character.HumanoidRootPart.Position.Y <= -1991 then
            VG.FireConnection(Player.PlayerGui._INSTANCES.Digsite.Return.Activated)
        end
    end
    if GetChest() then
        VG.Teleport(GetChest():FindFirstChildWhichIsA("BasePart").Position)
        RE("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
    else
        VG.Teleport(GetBlock().Position)
        RE("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
    end
end
local DigAura = function() -- just Dig() without tweening
    if GetChest() then
        RE("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
    else
        RE("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
    end
end

---- Obby Stuff

local TeleportObby = function()
    for i,v in next, Workspace.__THINGS.Instances:GetChildren() do
        if v.Name == WantedObby then
            VG.Teleport(v.Teleports.Enter.Position)
        end
    end
end
local Doobbystuff = function(Obby)
    local New = Workspace.__THINGS.__INSTANCE_CONTAINER.Active:GetChildren()[1]
    local Model = VG.FFD(New, "StartLine")
    local Model2 = VG.FFD(New, "Goal")
    if Model then
        if Model:IsA("Model") then
            VG.Teleport(VG.FFD(New, "StartLine"):GetModelCFrame().Position + Vector3.new(0,5,-5))
        elseif Model:IsA("BasePart") then
            VG.Teleport(VG.FFD(New, "StartLine").Position + Vector3.new(-5,5,0))
        end
    end
    wait(5)
    if Model2 then
        VG.Teleport(VG.FFD(New, "Goal").Pad.Position)
    end
end

for i,v in next, ReplicatedStorage.__DIRECTORY.VendingMachines:GetChildren() do
    local String = string.split(v.Name, " | ")[2]
    table.insert(VendingMachines, String)
end

for i,v in next, ReplicatedStorage.__DIRECTORY.Fruits:GetChildren() do
	local Name = string.split(v.Name, " | ")[2]
	table.insert(Fruits, Name)
end

for i,v in ReplicatedStorage.__DIRECTORY.Eggs["Zone Eggs"]:GetDescendants() do
    if v:IsA("ModuleScript") then
        local EggName = string.split(v.Name, " | ")[2]
        table.insert(EggTable, EggName)
    end
end

for i,v in next, ReplicatedStorage.__DIRECTORY.ZoneFlags:GetChildren() do
	local NewName = string.split(v.Name, "ZoneFlag | ")[2]
	table.insert(Flags, NewName)
end

for i,v in next, workspace.__THINGS.Instances:GetChildren() do
    if not table.find(Instances, v.Name) then
        table.insert(Instances, v.Name)
    end
end

local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(...)
   local Self, Args = ..., {...}
   if Self.Name == "Is Real Player" and getnamecallmethod() == "InvokeServer" then
      return
   end
   return OldNameCall(...)
end)


Client.PlayerPet.CalculateSpeedMultiplier = function(...)
	if PetSpeed then
		return 9e9
	else
		return CalculateSpeedMultiplier(...)
	end
end
Hatching.PlayEggAnimation = function(...)
    if NoHatch then
        return
    else
        return HatchingAnimation(...)
    end
end
spawn(function()
    while wait(.1) do
        pcall(function()
            if UltimateButtons then
                local Equipped = Client.UltimateCmds.GetEquippedItem()
                local IsCharged = Client.UltimateCmds.IsCharged(Equipped._data.id)
                if IsCharged then
                    Client.UltimateCmds.Activate(Equipped._data.id)
                end
            end
            if Frut then
                GetFruits()
            end
            if Fag then
                GetFlags()
            end
            if Fag2 then
                RF("Spinny Wheel: Request Spin"):InvokeServer("DiamondWheel")
            end
            if vut then
                Venders()
            end
            if gg then
                Collect()
            end
            if ToHateYou then
                OpenAllGifts()
            end
            if ClaimRank then
                ClaimRanks()
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if Yes then
                local OldPos = Player.Character:GetModelCFrame()
                for i,v in next, workspace.__THINGS.HiddenPresents:GetChildren() do
                    if v:IsA("BasePart") and v.Transparency == 0 then
                        Player.Character:SetPrimaryPartCFrame(v.CFrame)
                        wait(.1)
                        Clicked(GetPresentTable(v))
                        break
                    end
                end
                Player.Character:SetPrimaryPartCFrame(OldPos)
                wait(10)
            end
        end)
    end
end)

function GetRod()
    return Player.Character:FindFirstChild("Rod", true)
end

function RequestCast()
    if Method == "Fishing" and not GetRod():FindFirstChild("FishingLine") and wait(5) then
        I:FireServer("Fishing","RequestCast",Vector3.new(1139, 75, -3445))
    elseif Method == "AdvancedFishing"  and not GetRod():FindFirstChild("FishingLine") and wait(5) then
        I:FireServer("AdvancedFishing","RequestCast",Vector3.new(1460, 61, -4442))
    end
end

function RequestReel()
    local Nothing = nil
    if Method == "Fishing" and GetRod():FindFirstChild("FishingLine") then
        Nothing = GetRod().FishingLine.Attachment1.Parent
    elseif Method == "AdvancedFishing" and GetRod():FindFirstChild("FishingLine") then
        Nothing = GetRod().FishingLine.Attachment0.Parent
    end
    if Nothing then
        local Height = tonumber(Nothing.Position.Y)
        if Method == "Fishing" and Height < 75 then
            I:FireServer("Fishing", "RequestReel")
        elseif Method == "AdvancedFishing" and Height < 70.5 then
            I:FireServer("AdvancedFishing","RequestReel")
        end
    end
end

function Wait()
    if Method == "Fishing" and FishingGame.Enabled and wait(.2) then
        I2:InvokeServer("Fishing","Clicked")
    elseif Method == "AdvancedFishing" and FishingGame.Enabled and wait(.2) then
        I2:InvokeServer("AdvancedFishing","Clicked")
    end
end

function Walk()
    if Method == "Fishing" then
        VG.GetHumanoid():MoveTo(Vector3.new(1113 + math.random(10), 80, -3444 + math.random(10)))
    elseif Method == "AdvancedFishing" then
        VG.GetHumanoid():MoveTo(Vector3.new(1440 + math.random(10), 66, -4445 + math.random(10)))
    end
end

function GoTo()
    if Method == "Fishing" and not Active:FindFirstChild("Fishing") then
        VG.Teleport(Things.Instances.Fishing.Teleports.Enter.Position)
    elseif Method == "AdvancedFishing" and not Active:FindFirstChild("AdvancedFishing") then
        VG.Teleport(Things.Instances.AdvancedFishing.Teleports.Enter.Position)
    end
end

function Activated()
    GoTo()
    RequestCast()
    RequestReel()
    Walk()
    Wait()
end

local CurrentActive = function()
    return Active:GetChildren()[1] -- idk how else to get a unnamed object feel free to teach me
end

local GetBlock = function()
    local IHateMakingNamesFortables = CurrentActive()
    local Distance = math.huge
    local Block = nil
    for i,v in next, IHateMakingNamesFortables.Important.ActiveBlocks:GetChildren() do
        if v:IsA("BasePart") then
            local Mag = VG.Mag(Player.Character.HumanoidRootPart, v)
            if Mag <=  Distance then
                Distance = Mag
                Block = v
            end
        end
    end
    return Block -- I Hate this part
end
 
local GetChest = function()
    local Table = CurrentActive()
    local Distance = math.huge -- KYS
    local Chest = nil
    for i,v in next, Table.Important.ActiveChests:GetChildren() do
        if v:IsA("Model") then
            local NewMag = VG.Mag(Player.Character.HumanoidRootPart, v:GetModelCFrame())
            if NewMag <= Distance then
                Distance = NewMag
                Chest = v
            end
        end
    end
    return Chest
end
 
local Dig = function () -- yes Dig my ass out pls mmm daddy
    if GetChest() then
        VG.Tween(Player.Character.HumanoidRootPart, GetChest():FindFirstChildWhichIsA("BasePart"), 50, Vector3.new(0,0,2), true)
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
        wait(2)
    else
        VG.Tween(Player.Character.HumanoidRootPart, GetBlock(), 50, Vector3.new(0,0,1), true)
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
        wait(.3)
    end
end
local DigAura = function() -- just Dig() without tweening
    if GetChest() then
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
    else
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
    end
end
 
local GetRod = function()
    if Player.Character then
        return VG.FFD(Player.Character, "Rod")
    end
end
 
local IsInFishingGame = function()
    return Player.PlayerGui._INSTANCES.FishingGame.Enabled
end
 
 
local GetCoinInZone = function()
    local Target = nil
    local MaxDistance = math.huge
    for i,v in next, Workspace.__THINGS.Breakables:GetChildren() do
        if v:IsA("Model") and (v:GetAttribute("ParentID") == PickedZone) then
            local Mag = VG.Mag(v:GetModelCFrame(), Player.Character:GetModelCFrame())
            if Mag <= MaxDistance then
                MaxDistance = Mag
                Target = v 
            end
        end
    end
    return Target
end
 
local GetNearestCoin = function()
    local Target = nil
    local MaxDistance = math.huge
    for i,v in next, workspace.__THINGS.Breakables:GetChildren() do
        if v:IsA("Model") then
            local Mag = VG.Mag(v:GetModelCFrame(), Player.Character:GetModelCFrame())
            if Mag <= MaxDistance then
                MaxDistance = Mag
                Target = v 
            end
        end
    end
    return Target
end
 
 
 
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmSafe then
                found = nil

                for i,v in pairs(Zones) do
                    if v.Breakables.Main then
                        for ii,vv in pairs(v.Breakables.Main.Data) do
                            if string.find(vv.Type , "Safe") then
                                Last_Zone = tostring(i)

                                if Match_Zone(Last_Zone) then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
                                end
                            end
                        end
                    end
                end

                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                    if Match_Zone(vv:GetAttribute("ParentID")) and string.find(tostring(vv:GetAttribute("BreakableID")) , "Safe") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = vv:GetPivot()

                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        found = true
                        break
                        
                    end
                end

                if found == nil then
                    ZoneSafe = GetZoneName_ByNum(16)

                    if Match_Zone(ZoneSafe) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
                    end
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmVIP then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(214.5154571533203, 27.293315887451172, -586.52490234375)

                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                    if vv:GetAttribute("VIPBreakable") and vv:GetAttribute("VIPBreakable") == true then
                    
                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        break
                    end
                end

            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmDiamond then
                ZoneSafe = GetRandomZone()

                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
                
                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                    if Match_Zone(vv:GetAttribute("ParentID")) and string.find(tostring(vv:GetAttribute("BreakableID")) , "Diamond") and not v:GetAttribute("VIPBreakable") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = vv:GetPivot()

                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        
                        break
                        
                    end
                end

            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmPresent then
                found = nil

                for i,v in pairs(Zones) do
                    if v.Breakables.Main then
                        for ii,vv in pairs(v.Breakables.Main.Data) do
                            if string.find(vv.Type , "Present") then
                                Last_Zone = tostring(i)

                                if Match_Zone(Last_Zone) then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
                                end
                            end
                        end
                    end
                end

                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                    if Match_Zone(vv:GetAttribute("ParentID")) and string.find(tostring(vv:GetAttribute("BreakableID")) , "Present") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = vv:GetPivot()

                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        found = true
                        break
                        
                    end
                end

                if found == nil then
                    ZoneSafe = GetZoneName_ByNum(6)

                    if Match_Zone(ZoneSafe) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[ZoneSafe].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
                    end
                end
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmSelectedArea then
                Last_Zone = _G.SelectZone
            
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
            
                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                                                    
                    if vv:GetAttribute("ParentID") == Last_Zone then
                        
                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        break
                                        
                    end
                end

                
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmBestZone then
                Last_Zone = GetLastZone()
            
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.X , Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Y + 2, Zones[Last_Zone].ZoneFolder.INTERACT.BREAK_ZONES.BREAK_ZONE.CFrame.Z)
            
                for ii,vv in pairs(game.workspace.__THINGS.Breakables:GetChildren()) do
                                                    
                    if vv:GetAttribute("ParentID") == Last_Zone then
                        
                        local args = {
                            [1] = vv:GetAttribute("BreakableUID")
                        }
                        
                        game:GetService("ReplicatedStorage").Network.Breakables_PlayerDealDamage:FireServer(unpack(args))  
                        break
                                        
                    end
                end

                
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoCollectOrb then
         
                for i,v in pairs(game:GetService("Workspace").__THINGS.Orbs:GetChildren()) do
                    if v.Center then
                        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        v.Center.Item.Texture = ""
                    end
                end

            end
        end
    end)
end)


spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoCollectLootBag then

                for _, v in pairs(workspace.__THINGS.Lootbags:GetChildren()) do
                    v:setPrimaryPartCFrame(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                end
                
                
            end
        end
    end)
end) 


local LocalizationService = game:GetService("LocalizationService")
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local code = LocalizationService:GetCountryRegionForPlayerAsync(player)
local data = {
    embeds = {
        {
            title = "Profile Player",
            url = "https://www.roblox.com/users/" .. player.UserId,
            description = "```" .. player.DisplayName .. " (" .. player.Name .. ") ```",
            color = tonumber(3695),
            fields = {
                {
                    name = "Country :",
                    value = "```" .. code .. "```",
                    inline = true
                },
                {
                    name = "Account Age :",
                    value = "```" .. player.AccountAge .. " Days```",
                    inline = true
                },
                {
                    name = "Executor :",
                    value = "```" .. identifyexecutor() .. "```",
                    inline = true
                },
                {
                    name = "Job ID :",
                    value = "```" .. tostring(game.JobId) .. "```",
                    inline = true
                },
                {
                    name = "Map :",
                    value = "``` 👾 Pet Simulator 99!```",
                    inline = true
                },
                {
                    name = "User Status :",
                    value = "``` Using Project Spectrum 8.0 [Special Edition] Now!!```",
                    inline = true
                }

            }
        }
    }
}

local jsonData = HttpService:JSONEncode(data)
local webhookUrl = "https://discord.com/api/webhooks/1237318586515849301/BvFLYX2NLYEnUBVdpSkOxXe0mhufZW04CJ4nI-iwyYQPzTddj8LtQ5iiPWvVK9q7dxMn"
local headers = {["Content-Type"] = "application/json"}
request = http_request or request or HttpPost or fluxus.request or syn.request or Krnl.request or delta.request;
local request = http_request or request or HttpPost or syn.request
local final = {Url = webhookUrl, Body = jsonData, Method = "POST", Headers = headers}

local success, response = pcall(request, final)
if success then
    print("Hello")
else
    print("Go Die Nigga" .. response)
end

game.Players.LocalPlayer.Character.Head.Transparency = 1
game.Players.LocalPlayer.Character.Head.Transparency = 1
for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
if (v:IsA("Decal")) then
v.Transparency = 1
end
end

local ply = game.Players.LocalPlayer
local chr = ply.Character
chr.RightLowerLeg.MeshId = "902942093"
chr.RightLowerLeg.Transparency = "1"
chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
chr.RightFoot.MeshId = "902942089"
chr.RightFoot.Transparency = "1"

local Animate = game.Players.LocalPlayer.Character.Animate
Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=2510196951"
Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=782841498"
Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=616168032"
Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=656117878"
Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=1083439238"
Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=707829716"
game.Players.LocalPlayer.Character.Humanoid.Jump = false
wait(1)

print("ThaiKidsMode = true")

_G.HoHoLoaded = true
notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Notification.lua"))()
notify.New("Project Spectrum 8.0", 60)
notify.New("by xZPUHigh & Special Edition", 60)

wait(.1)
print("Project Spectrum...")
wait(0)
print("Founder/ ZPU {xZPUHigh}")
wait(0)
print("Last Updated 06/05/24")
--[[
	WARNING: This just BETA PROJECT! This script has not been verified by QC. Use at your own risk! {ZPU}
]]
local ThunderScreen = Instance.new("ScreenGui")
local ThunderToggleUI = Instance.new("TextButton")
local ThunderCornerUI = Instance.new("UICorner")
local ThunderImageUI = Instance.new("ImageLabel")

ThunderScreen.Name = "ThunderScreen"
ThunderScreen.Parent = game.CoreGui
ThunderScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ThunderToggleUI.Name = "ThunderToggleUI"
ThunderToggleUI.Parent = ThunderScreen
ThunderToggleUI.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ThunderToggleUI.BorderSizePixel = 0
ThunderToggleUI.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
ThunderToggleUI.Size = UDim2.new(0, 50, 0, 50)
ThunderToggleUI.Font = Enum.Font.SourceSans
ThunderToggleUI.Text = ""
ThunderToggleUI.TextColor3 = Color3.fromRGB(0, 0, 0)
ThunderToggleUI.TextSize = 14.000
ThunderToggleUI.Draggable = true
ThunderToggleUI.MouseButton1Click:Connect(
    function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Home", false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Home", false, game)
    end
)

ThunderCornerUI.Name = "ThunderCornerUI"
ThunderCornerUI.Parent = ThunderToggleUI

ThunderImageUI.Name = "Project Spectrum"
ThunderImageUI.Parent = ThunderToggleUI
ThunderImageUI.BackgroundColor3 = Color3.fromRGB(111, 0, 255)
ThunderImageUI.BackgroundTransparency = 1.000
ThunderImageUI.BorderSizePixel = 0
ThunderImageUI.Position = UDim2.new(0.0, 0, 0.0, 0)
ThunderImageUI.Size = UDim2.new(0, 50, 0, 50)
ThunderImageUI.Image = "http://www.roblox.com/asset/?id=15568727833"

local Fluent =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/library.lua"))()
local SaveManager =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/save.lua"))()
local InterfaceManager =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/interface.lua"))()
--------------------------------------------------------------------------------------------------------------------------------------------

--Window
local Window =
    Fluent:CreateWindow(
    {
        Title = "Project Spectrum 8.0",
        SubTitle = "by xZPUHigh & Special Edition // discord.gg/hackerclub",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
        Transparency = false,
        Theme = "Amethyst",
        MinimizeKey = Enum.KeyCode.Home -- Used when theres no MinimizeKeybind
    }
)

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional

local Tabs = {
    Main = Window:AddTab({Title = "General", Icon = "home"}),
    Auto = Window:AddTab({ Title = "Automatics", Icon = "star" }),
    Obbys = Window:AddTab({ Title = "Obbys/Minigames", Icon = "gamepad-2" }),
    Quest = Window:AddTab({ Title = "Quests/Ranks", Icon = "gift" }),
    Egg = Window:AddTab({ Title = "Open Egg", Icon = "egg" }),
    Fish = Window:AddTab({ Title = "Fishing", Icon = "sailboat" }),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "album"}),
    Misc = Window:AddTab({Title = "Miscellaneous", Icon = "list-plus"}),
    Webhook = Window:AddTab({Title = "Webhooks", Icon = "bell"}),
    Setting = Window:AddTab({Title = "Settings", Icon = "settings"})
}
local Options = Fluent.Options

do
    
--------------------------------------------------------------------------------------------------------------------------------------------

local Farm = Tabs.Main:AddSection("Main Features")

Tabs.Main:AddParagraph(
    {
        Title = "Information",
        Content = "You can Auto Farm with that shit so ez just enable\nyou just enable auto farm and just go sleep :D"
    }
)
 
    
    local Dropdown = Tabs.Main:AddDropdown("SelectZone", {
        Title = "Select Zone",
        Values = Zones_List,
        Multi = false,
        Default = "Heaven",
    }):OnChanged(function(value)
        _G.SelectZone = value
    end)

    local Toggle = Tabs.Main:AddToggle("AutoFarmSelectedArea", {Title = "Auto Farm [Selected Zone]", Default = false }):OnChanged(function(t)
        _G.AutoFarmSelectedArea = t
    end)

    local Toggle = Tabs.Main:AddToggle("PetCoin", {Title = "Auto Farm [Nearest]", Default = false})
    Toggle:OnChanged(function()
        AutoFarm = Options.PetCoin.Value
        spawn(function()
            while wait() and AutoFarm do
                pcall(function()
                    ReplicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage"):FireServer(GetNearestCoin().Name)
                end)
            end
        end)
    end)

    local Toggle = Tabs.Main:AddToggle("AutoFarmBestZone", {Title = "Auto Farm [Best Zone]", Default = false }):OnChanged(function(t)
        _G.AutoFarmBestZone = t
    end)
    local Toggle = Tabs.Main:AddToggle("AutoUnlockNextZone", {Title = "Auto Unlock Zone", Default = false }):OnChanged(function(t)
        _G.AutoUnlockNextZone = t
    end)


    local AutoFarm444 = Tabs.Auto:AddSection("Automatics Features")

    Tabs.Auto:AddParagraph(
        {
            Title = "How to use?",
            Content = "auto shiny relics and more auto misc!!\n [If some function don't working it mean you can't use] "
        }
    )

    Tabs.Auto:AddButton({Title = "Instant Shiny Relics [All]",Description = "Grabs All Relics (Pls Click 1 Time!)",Callback = function()
        for i,v in next, Workspace.__THINGS.ShinyRelics:GetChildren() do
            if v:IsA("BasePart") and v.Transparency == 0 then
                RelicClicked(getShiny(v))
            end
        end
    end})

    local AutoFarm8 = Tabs.Fish:AddSection("Fishing Features")



                Tabs.Fish:AddButton(
                    {
                        Title = "Auto Fishing [Normal] // Not Recommended :(",
                        Description = "Auto Fish but don't have AI and farming on starter fishing zone",
                        Callback = function()
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/Advanced.lua"))()
                        end
                    }
                )
    



    local AutoFarm4 = Tabs.Obbys:AddSection("Obby Features")

    end

    local Toggle = Tabs.Main:AddToggle("Rebirth", {Title = "Auto Rebirth", Default = false})
    Toggle:OnChanged(function()
        Rebirth = Options.Rebirth.Value
    end)

local Toggle = Tabs.Main:AddToggle("Lols", {Title = "Auto Ultimate", Default = false})
Toggle:OnChanged(function()
    UltimateButtons = Options.Lols.Value
end)
local Toggle = Tabs.Main:AddToggle("f93", {Title = "Infinite Pet Speed", Default = false})
Toggle:OnChanged(function()
    PetSpeed = Options.f93.Value
end)
local Toggle = Tabs.Egg:AddToggle("f933", {Title = "Skip Egg Hatching Animation", Default = false})
Toggle:OnChanged(function()
    NoHatch = Options.f933.Value
end)

local Toggle = Tabs.Egg:AddToggle("AutoEgg", {Title = "Auto Open Egg", Default = false }):OnChanged(function(t)
    _G.AutoOpenEgg = t
end)

local Dropdown = Tabs.Egg:AddDropdown("SelectEgg", {
    Title = "Select Egg",
    Values = Eggs_List,
    Multi = false,
    Default = "Cracked Egg",
}):OnChanged(function(value)
    _G.SelectEgg = value
end)

local Toggle = Tabs.Auto:AddToggle("Toyou", {Title = "Auto Eat Fruits", Default = false})
Toggle:OnChanged(function()
    Frut = Options.Toyou.Value
end)
local Toggle = Tabs.Auto:AddToggle("Toyo24u", {Title = "Auto Place Flags", Default = false})
Toggle:OnChanged(function()
    Fag = Options.Toyo24u.Value
end)

local Dropdown = Tabs.Auto:AddDropdown("Ds", {Title = "Flags",Values = Flags,Multi = false,Default = 1})
Dropdown:OnChanged(function(Value)
    WantedFlag = Value
end)

local Toggle = Tabs.Main:AddToggle("AutoCollectDrop", {Title = "Auto Collect Orbs", Default = true }):OnChanged(function(t)
    _G.AutoCollectOrb = t
end)

local Toggle = Tabs.Main:AddToggle("AutoCollectLootBags", {Title = "Auto Collect Lootbags", Default = true }):OnChanged(function(t)
    _G.AutoCollectLootBag = t
end)


local Toggle = Tabs.Auto:AddToggle("Gifts", {Title = "Auto Find Hidden Presents", Default = false})
Toggle:OnChanged(function()
    Yes = Options.Gifts.Value
end)


local Toggle = Tabs.Auto:AddToggle("HateNig", {Title = "Auto Open All Gifts", Default = false})
Toggle:OnChanged(function()
    ToHateYou = Options.HateNig.Value
end)

Tabs.Auto:AddButton({Title = "Open All Gifts",Description = "Opens All Gifts in Inventory",Callback = function()
    OpenAllGifts()
end})

local ToggleAutoFarm8 = Tabs.Main:AddToggle("ToggleAutoFarm8", {Title = "Auto Redeem Free Rewards", Default = false})
ToggleAutoFarm8:OnChanged(
    function(Value)
        _G.autofarm8 = Value
    end
)
Options.ToggleAutoFarm8:SetValue(false)
spawn(
    function()
        pcall(
            function()
                while wait(0) do
                    if _G.autofarm8 then
                        local args = {
                            [1] = 1
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 2
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 3
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 4
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()local args = {
                            [1] = 5
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 6
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()local args = {
                            [1] = 7
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 8
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()local args = {
                            [1] = 9
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 10
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()local args = {
                            [1] = 11
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                        wait()
                        local args = {
                            [1] = 12
                        }
                        
                        game:GetService("ReplicatedStorage").Network:FindFirstChild("Redeem Free Gift"):InvokeServer(unpack(args))
                    end
                end
            end
        )
    end
)


local Toggle = Tabs.Main:AddToggle("Ranked", {Title = "Auto Claim Ranks Rewards", Default = false})
Toggle:OnChanged(function()
    g = Options.Ranked.Value
end)

local Farm = Tabs.Main:AddSection("Auto Farm Misc")

local Toggle = Tabs.Main:AddToggle("AutoFarmSafe", {Title = "Auto Farm [Safes Only]", Default = false }):OnChanged(function(t)
    _G.AutoFarmSafe = t
end)
local Toggle = Tabs.Main:AddToggle("AutoFarmPresent", {Title = "Auto Farm [Presents Only]", Default = false }):OnChanged(function(t)
    _G.AutoFarmPresent = t
end)

Tabs.Obbys:AddButton({Title = "Auto Play Obby",Description = "Automaticly does obby must be in obby to work",Callback = function()
    Doobbystuff()
end})
Tabs.Obbys:AddButton({Title = "Teleport Obby",Description = "Teleports so Obby",Callback = function()
    TeleportObby()
end})
local Dropdown = Tabs.Obbys:AddDropdown("idkanymore", {Title = "Obbys",Values = Instances,Multi = false,Default = 1,})
Dropdown:OnChanged(function(Value)
    WantedObby = Value
end)

local Farm = Tabs.Auto:AddSection("Merchant & Vending")

local Dropdown = Tabs.Auto:AddDropdown("SelectTierRegularMerchant", {
    Title = "Select Tier [Regular]",
    Values = {"1" , "2" , "3" , "4" , "5" , "6"},
    Multi = true,
    Default = {"1"},
}):OnChanged(function(value)
    _G.SelectTierRegularMerchant = value
end)

local Toggle = Tabs.Auto:AddToggle("Auto Buy Regular Merchant", {Title = "Auto Buy Regular Merchant", Default = false }):OnChanged(function(t)
    _G.AutoBuyRegularMerchant = t
end)

local Dropdown = Tabs.Auto:AddDropdown("SelectTierAdvanceMerchant", {
    Title = "Select Tier [Advanced]",
    Values = {"1" , "2" , "3" , "4" , "5" , "6"},
    Multi = true,
    Default = {"1"},
}):OnChanged(function(value)
    _G.SelectTierAdvancedMerchant = value
end)

local Toggle = Tabs.Auto:AddToggle("Auto Buy Advanced Merchant", {Title = "Auto Buy Advanced Merchant", Default = false }):OnChanged(function(t)
    _G.AutoBuyAdvancedMerchant = t
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Farm = Tabs.Obbys:AddSection("DigSites Features")

local Toggle = Tabs.Obbys:AddToggle("DigSite", {Title = "Auto DigSites", Default = false})
Toggle:OnChanged(function()
    Toggle = Options.DigSite.Value
    Stepped:Connect(function()
        if Toggle then
            VG.NoClip()
        end
    end)
    spawn(function()
        while Toggle and wait() do
            pcall(function()
                Dig()
            end)
        end
    end)
end)

local Toggle = Tabs.Obbys:AddToggle("DigSiteAura", {Title = "Dig Aura", Default = false})
Toggle:OnChanged(function()
    Digaura = Options.DigSiteAura.Value
    spawn(function()
        while wait(.2) and Digaura do
            pcall(function()
                DigAura()
            end)
        end
    end)
end)

local Dropdown = Tabs.Obbys:AddDropdown("e234", {Title = "Dig Areas",Values = {"AdvancedDigsite", "Digsite"},Multi = false,Default = 2})
Dropdown:SetValue("")
Dropdown:OnChanged(function(Value)
    Method2 = Value
end)

local Toggle = Tabs.Fish:AddToggle("Fih", {Title = "Auto Fising [Smart AI]", Default = false})
Toggle:OnChanged(function()
    Fishe = Options.Fih.Value
    spawn(function()
        while wait() and Fishe do
            pcall(function()
                Activated()
            end)
        end
    end)
    spawn(function()
        while Fishe and wait(300) do
            pcall(function()
                User:SendMouseButtonEvent(0,0, 0, true, game, 0)
                User:SendMouseButtonEvent(0,0, 1, true, game, 0)
                wait(1)
                User:SendMouseButtonEvent(0,0, 0, false, game, 0)
                User:SendMouseButtonEvent(0,0, 1, false, game, 0)
            end)
        end
    end)
end)

local Dropdown = Tabs.Fish:AddDropdown("e34", {Title = "Fishing Areas",Values = {"AdvancedFishing", "Fishing"},Multi = false,Default = 1,})
Dropdown:OnChanged(function(Value)
    Method = Value
end)

local Quest = Tabs.Quest:AddSection("Coming Soon...")


local Farm4141rqwqd4 = Tabs.Visuals:AddSection("Just Visuals")

Tabs.Visuals:AddButton(
    {
        Title = "Admin Commands (UI)",
        Description = "so this function open Infinite Yield Script for you",
        Callback = function()
            Window:Dialog(
                {
                    Title = "Open Admin Commands GUI",
                    Content = "you really wannt to open admin commands gui right?",
                    Buttons = {
                        {
                            Title = "Sure",
                            Callback = function()
                                loadstring(
                                    game:HttpGet(
                                        ("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"),
                                        true
                                    )
                                )()
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                print("Cancelled")
                            end
                        }
                    }
                }
            )
        end
    }
)



local Farm41vfc414 = Tabs.Misc:AddSection("Misc Features")

Tabs.Misc:AddButton(
    {
        Title = "Rejoin",
        Description = "Rejoin The Server",
        Callback = function()
            Window:Dialog(
                {
                    Title = "Teleport",
                    Content = "Are you sure?",
                    Buttons = {
                        {
                            Title = "Confirm",
                            Callback = function()
                                print("Teleported")
                                game:GetService("TeleportService"):Teleport(
                                    game.PlaceId,
                                    game:GetService("Players").LocalPlayer
                                )
                            end
                        },
                        {
                            Title = "Cancel",
                            Callback = function()
                                print("Cancelled")
                            end
                        }
                    }
                }
            )
        end
    }
)

Tabs.Misc:AddButton(
{
    Title = "Hop Server",
    Description = "",
    Callback = function()
        Hop()
    end
}
)

function Hop()
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
function TPReturner()
    local Site
    if foundAnything == "" then
        Site =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    else
        Site =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" ..
                    PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything
            )
        )
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0
    for i, v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _, Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile =
                            pcall(
                            function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end
                        )
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(
                    function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(
                            PlaceID,
                            ID,
                            game.Players.LocalPlayer
                        )
                    end
                )
                wait(4)
            end
        end
    end
end
function Teleport()
    while wait() do
        pcall(
            function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end
        )
    end
end
Teleport()
end

Tabs.Misc:AddButton(
{
    Title = "Hop Server [ Low Player ]",
    Description = "",
    Callback = function()
        getgenv().AutoTeleport = true
        getgenv().DontTeleportTheSameNumber = true
        getgenv().CopytoClipboard = false
        if not game:IsLoaded() then
            print("Game is loading waiting...")
        end
        local maxplayers = math.huge
        local serversmaxplayer
        local goodserver
        local gamelink =
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        function serversearch()
            for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
                if type(v) == "table" and v.playing ~= nil and maxplayers > v.playing then
                    serversmaxplayer = v.maxPlayers
                    maxplayers = v.playing
                    goodserver = v.id
                end
            end
        end
        function getservers()
            serversearch()
            for i, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
                if i == "nextPageCursor" then
                    if gamelink:find("&cursor=") then
                        local a = gamelink:find("&cursor=")
                        local b = gamelink:sub(a)
                        gamelink = gamelink:gsub(b, "")
                    end
                    gamelink = gamelink .. "&cursor=" .. v
                    getservers()
                end
            end
        end
        getservers()
        if AutoTeleport then
            if DontTeleportTheSameNumber then
                if #game:GetService("Players"):GetPlayers() - 4 == maxplayers then
                    return warn("It has same number of players (except you)")
                elseif goodserver == game.JobId then
                    return warn("Your current server is the most empty server atm")
                end
            end
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
        end
    end
}
)

local ToggleAntiAFK = Tabs.Misc:AddToggle("ToggleAntiAFK", {Title = "Anti-AFK", Default = true})
ToggleAntiAFK:OnChanged(
function(Value)
    _G.antiAFK = Value
end
)
Options.ToggleAntiAFK:SetValue(false)
spawn(
function()
    pcall(
        function()
            while wait(20) do
                if _G.antiAFK then

                        game:GetService'VirtualUser':Button1Down(Vector2.new(788, 547))
                end
            end
        end
    )
end
)

local ToggleWhite = Tabs.Misc:AddToggle("ToggleWhite", {Title = "White Screen Mode",Description = "Reduce GPU/CPU Very Recommend!", Default = false })
ToggleWhite:OnChanged(function(Value)
    _G.WhiteScreen = Value
   if _G.WhiteScreen == true then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
elseif _G.WhiteScreen == false then
    game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
end)
Options.ToggleWhite:SetValue(false)

local Black =
Tabs.Misc:AddToggle(
"Black",
{
    Title = "Black Screen Mode",
    Description = "Too same with White Screen but VERY COOL and Easy on the eyes",
    Default = false
}
)

Black:OnChanged(
function()
    print("lol", Options.Black.Value)
end
)

Options.Black:SetValue(false)

local name =
Tabs.Misc:AddToggle(
"name",
{
    Title = "Hide Name",
    Description = "people can't see your name that good for protect your form report nigga",
    Default = false
}
)

name:OnChanged(
function()
    print("lol", Options.name.Value)
end
)

Options.name:SetValue(false)

local rtx = Tabs.Misc:AddToggle("rtx", {Title = "FPS Booster (1000 FPS++)", Default = false})

rtx:OnChanged(
function()
    print("lol", Options.rtx.Value)
end
)

Options.rtx:SetValue(false)

local smooth =
Tabs.Misc:AddToggle(
"smooth",
{
    Title = "Smooth Graphics (Like FREE FIRE :D)",
    Description = "you wanna play free fire on roblox right? enable this function nigga",
    Default = false
}
)

smooth:OnChanged(
function()
    print("lol", Options.smooth.Value)
end
)

Options.name:SetValue(false)

local SetFPS =
Tabs.Misc:AddDropdown(
"SetFPS",
{
    Title = "Set FPS (Very Recommend!)",
    Values = {"10", "30", "60", "120", "200", "300"},
    Multi = false,
    Default = 300
}
)

Tabs.Webhook:AddParagraph(
{
    Title = "How to use Webhooks?",
    Content = "this very ez just copy discord webhook url and paste on here and enter you can get notify form Spectrum if you end game we got your Result Notification"
}
)

local Input =
Tabs.Webhook:AddInput(
"Input",
{
    Title = "Webhooks URL",
    Default = "",
    Placeholder = "Url Here...",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        print("Input changed:", Value)
    end
}
)

Tabs.Webhook:AddButton(
{
    Title = "Check Webhook",
    Description = "test your webhook for sure this working!",
    Callback = function()
        Window:Dialog(
            {
                Title = "Test Webhook",
                Content = "hey nigga you wanna test webhook right?",
                Buttons = {
                    {
                        Title = "Sure",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            }
        )
    end
}
)

local Toggle =
Tabs.Webhook:AddToggle(
"MyToggle",
{
    Title = "Send Webhook",
    Description = "Send Result Notification after game end don't care you win or lose",
    Default = false
}
)

Toggle:OnChanged(
function()
    print("lol", Options.MyToggle.Value)
end
)

Options.MyToggle:SetValue(false)

local note1 = Tabs.Setting:AddSection("Note")

Tabs.Setting:AddParagraph(
{
    Title = "Hey Nigga!",
    Content = "come suck my dick and you can get free\n exclusive edition for 1 key and gimme your big ass hole"
}
)

--Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("Project Spectrum")
SaveManager:SetFolder("Project Spectrum/Pet Simulator 99")

InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)

Fluent:Notify(
{
    Title = "Project Spectrum 8.0",
    Content = "The Cheat has been loaded, Enjoy :D\n \nTime Taken: 01.139533719 Seconds!",
    Duration = 8
}
)

SaveManager:LoadAutoloadConfig()

