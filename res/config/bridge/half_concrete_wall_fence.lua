-- Quick script for Transport Fever 2 Bridges
-- Copyright Enzojz 2020
-- Please study it and write your own code, it's easy to understand :)
-- For more information about the format required by the game visite:
-- https://www.transportfever.net/lexicon/index.php?entry/288-raw-bridge-data/
function data()
    return {
        name = _("HALF_CONCRETE_WALL_FENCE"),
        
        yearFrom = 1920,
        yearTo = 0,
        
        carriers = {"RAIL", "ROAD"},
        
        speedLimit = 100,
        
        pillarLen = 0.5,
        
        pillarMinDist = 45.0,
        pillarMaxDist = 9999.0,
        pillarTargetDist = 50.0,
        
        cost = 200.0,
        
        updateFn = function(params)
            local result = {
                railingModels = {},
                pillarModels = {}
            }
            
            for _, height in ipairs(params.pillarHeights) do
                table.insert(result.pillarModels, {{}})
            end
            
            local maxHeight = math.max(0, table.unpack(params.pillarHeights)) + 5
            
            for i, interval in ipairs(params.railingIntervals) do
                local nSeg = math.floor((interval.length) / 5)
                if nSeg < 1 then nSeg = 1 end
                local lSeg = interval.length / nSeg
                
                local minOffset = interval.lanes[1].offset
                local maxOffset = interval.lanes[#interval.lanes].offset
                
                local xScale = lSeg / 5
                local sp = params.railingWidth - (maxOffset - minOffset)
                local rDisp = minOffset - sp * 0.5 - 1
                local lDisp = maxOffset + sp * 0.5 + 1
                
                local width = params.railingWidth + 1.5
                local midOffset = (maxOffset + minOffset) * 0.5
                local nPart = math.floor(width / 5 + 1)
                if (nPart < 1) then nPart = 1 end
                local wPart = width / nPart
                local wScale = wPart / 5
                local ref = midOffset + (width * 0.5)
                
                local set = function(n)
                    local x = (n - 1) * lSeg
                    local set = {
                        {
                            id = "bridge/trw/concrete_fence.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp, 0, 1},
                            remove = true
                        },
                        {
                            id = "bridge/trw/concrete_fence.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp, 0, 1}
                        },
                        {
                            id = "bridge/trw/concrete_wall.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, maxHeight, 0, x, rDisp, -maxHeight, 1},
                            remove = true
                        },
                        {
                            id = "bridge/trw/concrete_wall.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, maxHeight, 0, x, lDisp, -maxHeight, 1}
                        }
                    }
                    
                    for k = 1, nPart do
                        local yDisp = ref - (k - 1) * wPart
                        table.insert(set, {
                            id = "bridge/trw/concrete_surface.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, 1, 0, x, yDisp, 0, 1}
                        })
                        
                        if (n == 1) then
                            table.insert(set, {
                                id = "bridge/trw/concrete_front.mdl",
                                transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, yDisp, 0, 1}
                            })
                        end
                        if (n == nSeg) then
                            table.insert(set, {
                                id = "bridge/trw/concrete_back.mdl",
                                transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, yDisp, 0, 1}
                            })
                        end
                    end
                    
                    return set
                end
                
                local rs = {}
                for s = 1, nSeg do
                    local seth = {}
                    for _, e in ipairs(set(s)) do
                        if not e.remove then
                            table.insert(seth, e)
                        end
                    end
                    table.insert(rs, seth)
                end
                table.insert(result.railingModels, rs)
            end
            
            return result
        end
    }
end
