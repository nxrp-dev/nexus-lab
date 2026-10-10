local GameMath = {}

function GameMath.RandomObjectFromTable(ATable, APercentage, ADefault)
    -- Validate inputs
    if type(ATable) ~= "table" or #ATable == 0 then
        error("ATable must be a non-empty table")
    end
    
    if type(APercentage) ~= "number" or APercentage < 0 then
        error("APercentage must be a non-negative number")
    end
    
    if type(ADefault) ~= "number" or ADefault < 1 or ADefault > #ATable then
        error("ADefault must be a valid index in ATable")
    end

    local lIndex = math.random(0, 100); 
    if (lIndex <= APercentage) then
        return ATable[math.random(1, #ATable)]
    else
        return ATable[ADefault]
    end
end

function GameMath.RandomObjectFromDictionary(ATable, AOrder, APercentage, ADefault)
    -- Validate inputs
    if type(ATable) ~= "table" or #AOrder == 0 then
        error("ATable must be a non-empty table witha valid index array")
    end

    if type(APercentage) ~= "number" or APercentage < 0 then
        error("APercentage must be a non-negative number")
    end
    
    local lIndex = math.random(0, 100); 
    if (lIndex <= APercentage) then
        return ATable[AOrder[math.random(1, #AOrder)]]
    else
        if type(ADefault) == "string" then
            return ATable[ADefault]
        else
            return ADefault
        end
    end
end

function GameMath.ExtractRandomObjectFromTable(ATable)
    local lIndex = math.random(1, #ATable);
    local lRecord = ATable[lIndex];
    table.remove(ATable, lIndex);
    return lRecord;
end

function GameMath.CalculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

return GameMath