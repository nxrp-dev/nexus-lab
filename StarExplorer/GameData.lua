local GameData = {}

local galaxy = require("galaxy")
local gamemath = require("gamemath")
local const = require("const")

GameData.SectorMap = {}
GameData.Player = {}
GameData.Ship = {}
GameData.CurrentSystem = {}

function GameData.NewGame() 
    GameData.SectorMap = galaxy:NewSector()

    GameData.CurrentSystem = GameData.SectorMap.StarSystems[math.random(1, const.cStarCount)]
end

function GameData.SaveGame() 

end

function GameData.LoadGame()

end

--[[local GameData.Player = {}
GameData.Player.__index = GameData.Player

-- Constructor
function GameData.Player:Create(AID, ASkills)
    local lInstance = setmetatable({}, GameData.Player)
    lInstance.Skills = ASkills or
    {
        Engineer = 3,
        Pilot = 3,
        Fighter = 3,
        Trader = 3
    }

    lInstance.int = AID or 0
    lInstance.PersonClass = 0

    return lInstance
end

function GameData.Ship:Create() 
    local lInstance = setmetatable({}, GameData.Ship)
--    instance.x = x or 0
--    instance.y = y or 0
    return lInstance
end
]]
return GameData