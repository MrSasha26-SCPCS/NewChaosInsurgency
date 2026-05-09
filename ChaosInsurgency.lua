local Vector3 = CS.UnityEngine.Vector3
local TransitionManager = CS.TransitionManager
local UIManager = CS.UIManager
local PlayerUtilities = CS.PlayerUtilities
local GameObject = CS.UnityEngine.GameObject
local Color = CS.UnityEngine.Color
local Random = CS.UnityEngine.Random

local function toTable(g)
    local myTable = {}
    for i, key in pairs(g) do
        table.insert(myTable, key)
    end
    return myTable
end

local function getLen(tableda)
    local len = 0
    for _ in pairs(tableda) do
        len = len + 1
    end
    return len
end

---@class ChaosInsurgency:CS.Akequ.Base.PlayerClass
ChaosInsurgency = {}

function ChaosInsurgency:Init()
    self.main.player:InitHealth(CS.Config.GetInt("chaosInsurgency_health", 130), Color(0, 0.65, 0, 1), "Chaos Insurgency")
    self.main.player:SetHitbox(Vector3(0.8, 1.8, 0.8), Vector3.zero)
    if self.main.player.isLocalPlayer then
        self.main.player:PlayBellSound(1)
        UIManager.SetMobileButtons({ "Move", "Rotate", "Pause", "PlayerList", "Interact", "Jump", "Run",
            "Inventory", "Voice", "Crouch" })
        TransitionManager.ShowClass("#006000",
            "Повстанец Хаоса",
            "Уничтожьте <color=red>SCP</color>.\nПомогите персоналу <color=orange>класса-Д</color> выбраться.\nЛиквидируйте остальных вооружённых лиц.",
            "Chaos Insurgency", "CIIcon")
        PlayerUtilities.SetVoiceChat(PlayerUtilities.CreateValueTuple("SCP", true), PlayerUtilities.CreateValueTuple("3D", true))
    end
    self.main.playerModel = self.main.player:SpawnHumanoidModel("ply_chaosInsurgency")
    self.main.playerModel.transform.localPosition = Vector3(0, -0.83, 0)
    PlayerUtilities.SpawnHitboxes(self.main.player, self.main.playerModel)

    if self.main.player.isServer then
        local points = self.main.player:GetSpawnPoints("chaosSpawn")
        local keys = points.Keys
        local vals = points.Values

        keys = toTable(keys)
        vals = toTable(vals)

        local i = math.random(1, getLen(keys))
            
        self.main.player:Teleport(keys[i].position + Vector3(0, 1.25, 0), vals[i])
        
        self.main.player:GiveItem("AK12")
        self.main.player:GiveItem("FirstAid")
        self.main.player:GiveItem("BreakingCard")
        self.main.player:GiveItem("FlashGrenade")
        self.main.player:GiveItem("Cuffer")
        self.main.player:GiveItem("Ammo.A545x39")
        self.main.player:GiveItem("Ammo.A545x39")
        self.main.player:GiveItem("Ammo.A545x39")   
    end
    self.main.player:SetSpeed(2.5, 5, 1.1)
    self.main.player:SetJumpPower(3.5)
end

function ChaosInsurgency:GetSpectatorBone()
    return "DeathCam"
end
function ChaosInsurgency:OnStop()
    if self.main.playerModel ~= nil then
        local ragdoll = PlayerUtilities.SpawnRagdoll(self.main.player, self.main.playerModel)
        GameObject.Destroy(self.main.playerModel)
    else
        local ragdoll = PlayerUtilities.SpawnRagdoll(self.main.player, "ply_chaosInsurgency_ragdoll")
    end
end

function ChaosInsurgency:OnOpenInventory()
    return true
end

function ChaosInsurgency:IgnoreSCP()
    return true
end
function ChaosInsurgency:GetName()
    return "Chaos Insurgency"
end
function ChaosInsurgency:GetTeamID()
    return "ClassD"
end
function ChaosInsurgency:GetClassColor()
    return "006000"
end
return ChaosInsurgency