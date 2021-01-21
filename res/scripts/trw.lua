local normal = function(set, setAbutment, nSeg, interval)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
                elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
                else
                    table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local abutmentStart = function(set, setAbutment, nSeg, interval, i)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(i == 1 and s == 1 and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local abutmentEnd = function(set, setAbutment, nSeg, interval, i, params)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(i == #params.railingIntervals and s == nSeg and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local abutmentComplete = function(set, setAbutment, nSeg, interval, i, params)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(((i == 1 and s == 1) or (i == #params.railingIntervals and s == nSeg)) and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local half = function(set, setAbutment, nSeg, interval)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            elseif e.rightRemoval then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local halfAbutmentStart = function(set, setAbutment, nSeg, interval, i)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(i == 1 and s == 1 and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            elseif e.rightRemoval then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local halfAbutmentEnd = function(set, setAbutment, nSeg, interval, i, params)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(i == #params.railingIntervals and s == nSeg and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            elseif e.rightRemoval then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end

local halfAbutmentComplete = function(set, setAbutment, nSeg, interval, i, params)
    local rs = {}
    for s = 1, nSeg do
        local seth = {}
        for _, e in ipairs(((i == 1 and s == 1) or (i == #params.railingIntervals and s == nSeg)) and setAbutment(s) or set(s)) do
            if e.rightCollision and (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
            elseif e.leftCollision and (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
            elseif e.rightRemoval then
            else
                table.insert(seth, e)
            end
        end
        table.insert(rs, seth)
    end
    return rs
end


local updateFn = function(gen, abutment)
    return function(params)
        local result = {
            railingModels = {},
            pillarModels = {}
        }
        
        for _, _ in ipairs(params.pillarHeights) do
            table.insert(result.pillarModels, {{}})
        end
        
        local maxHeight = math.max(15, table.unpack(params.pillarHeights)) + 5
        
        for i, interval in ipairs(params.railingIntervals) do
            local set, setAbutment, nSeg = gen(interval, maxHeight, params)
            table.insert(result.railingModels, abutment(set, setAbutment, nSeg, interval, i, params))
        end
        
        return result
    end
end

return {
    updateFn = updateFn,
    abutmentStart = abutmentStart,
    abutmentEnd = abutmentEnd,
    abutmentComplete = abutmentComplete,
    normal = normal,
    halfAbutmentStart = halfAbutmentStart,
    halfAbutmentEnd = halfAbutmentEnd,
    halfAbutmentComplete = halfAbutmentComplete,
    half = half
}
