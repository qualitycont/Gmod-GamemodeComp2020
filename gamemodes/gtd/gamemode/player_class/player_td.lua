DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

local function _checkAndGetClass(ply)
    local managerclass = GAMEMODE.ClassManager.GetAll()[ply:GetTDClass()]
    if not managerclass then
        ply:SetTDClass("none")
        managerclass = GAMEMODE.ClassManager.GetAll()["none"]
    end
    return managerclass
end

function PLAYER:SetupDataTables()
    self.Player:NetworkVar( "Int", 0, "Money" )
    self.Player:NetworkVar( "Bool", 0, "CanBuild" )
    self.Player:NetworkVar( "String", 0, "TDClass")
    if SERVER then
        self.Player:SetMoney(0)
        self.Player:SetCanBuild(true)
        self.Player:SetTDClass("none")
    end
end

local WeaponLoadout = {
    "weapon_fists",
    "weapon_crowbar"
}

function PLAYER:Loadout()
    local class = _checkAndGetClass(self.Player)

    for _, weapon in pairs( WeaponLoadout ) do
        self.Player:Give( weapon )
    end

    for _, v in pairs(class.Weapons) do
        self.Player:Give(v)
    end
    if class.Loadout then
        class.Loadout(self.Player)
    end
end

function PLAYER:Spawn()
    local class = _checkAndGetClass(self.Player)
    if class.Spawn then class.Spawn(self.Player) end
end

function PLAYER:SetModel()
    local class = _checkAndGetClass(self.Player)
	local cl_playermodel = class.Model
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	self.Player:SetModel( modelname )

end

player_manager.RegisterClass( "player_td", PLAYER, "player_default")