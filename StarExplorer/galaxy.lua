local Galaxy = {}

local lSystemPressure = require("enums.SystemPressure")
local lSpecialResource = require("enums.SpecialResource")
local lGameMath = require("gamemath")
local lPoliticalSystem = require("enums.PoliticalSystem")
local lStarSystemNames = require("enums.StarSystemNames")
local lSize = require("enums.Size")
local lTechLevel = require("enums.TechLevel")
local const = require("const")

local cGalaxyWidth = 50
local cGalaxyHeight = 50
local cMinDistance = 7
local cCloseDistance = 13

function Galaxy:NewSector() 
    local lSector = setmetatable({}, Sector)
    lSector.StarSystems = setmetatable({}, StarSystem)

    -- we place a seed planet
    table.insert(lSector.StarSystems, self:NewStarSystem(math.random(cGalaxyWidth*-1, cGalaxyWidth), math.random(cGalaxyHeight*-1, cGalaxyHeight)))

    local lCount = 1;
    while (lCount <= const.cStarCount) do
        local lX = math.random(cGalaxyWidth*-1, cGalaxyWidth)
        local lY = math.random(cGalaxyHeight*-1, cGalaxyHeight)
        
        local lCloseFound = false;
        local lTooClose = false;

        for lExistingStarSystemIndex = 1, #lSector.StarSystems do
            local lExistX =  lSector.StarSystems[lExistingStarSystemIndex].x
            local lExistY =  lSector.StarSystems[lExistingStarSystemIndex].y
            
            if lGameMath.CalculateDistance(lX, lY, lExistX, lExistY) < cMinDistance then
                lTooClose = true;
                break -- try again
            end

            if not lCloseFound and lGameMath.CalculateDistance(lX, lY, lExistX, lExistY) < cCloseDistance then
                lCloseFound = true;
            end
        end
        if lCloseFound and not lTooClose then
            table.insert(lSector.StarSystems, self:NewStarSystem(lX, lY))
            lCount = lCount + 1
        end
    end
    return lSector
end

-- this allows us to quickly pull random keys without rebuilding the key list numerous times
local lPoliticalSystemOrder = {
    "Anarchy", "Capitalist", "Communist", "Confederacy", "Corporate",
    "Cybernetic", "Democracy", "Dictatorship", "Fascist", "Feudal",
    "Military", "Monarchy", "Pacifist", "Socialist", "Satori",
    "Technocracy", "Theocracy"
}

local lTechLevelOrder = {
    "PreAgriculture", "Agriculture", "Medieval", "Renaissance", "EarlyIndustrial", "Industrial", "PostIndustrial", "HiTech", "Unavailable"
}

function Galaxy:NewStarSystem(AX, AY)
    lStarSystem = setmetatable({}, StarSytem)

    lStarSystem.SystemPressure = lGameMath.RandomObjectFromTable(lSystemPressure, 10, 1)
    lStarSystem.PoliticalSystem = lGameMath.RandomObjectFromDictionary(lPoliticalSystem, lPoliticalSystemOrder, 100, lPoliticalSystem.Democracy)
    lStarSystem.Name = lGameMath.ExtractRandomObjectFromTable(lStarSystemNames).Name
    lStarSystem.Size = lGameMath.RandomObjectFromTable(lSize, 50, 3)
    -- this previously had limiting characteristics based on pol system.  I may implement that,
    -- but I see it as an invalid perspective and unnecessary complexity.
    lStarSystem.TechLevel = lGameMath.RandomObjectFromDictionary(lTechLevel, lTechLevelOrder, 70, lTechLevel.Industrial)
    lStarSystem.SpecialResource = lGameMath.RandomObjectFromTable(lSpecialResource, 5, 1)

    lStarSystem.x = AX 
    lStarSystem.y = AY 

    return lStarSystem
end

function Galaxy:NewPlanet(StarSystem)
    local lPlanet

    return lPanet
end

function Galaxy:NewMoon(Planet)
    local lMoon

    return lMoon
end

return Galaxy
