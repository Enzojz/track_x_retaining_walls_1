-- Quick script for Transport Fever 2 Bridges
-- Copyright Enzojz 2020
-- Please study it and write your own code, it's easy to understand :)
-- For more information about the format required by the game visite:
-- https://www.transportfever.net/lexicon/index.php?entry/288-raw-bridge-data/
function data()
    return {
        name = _("ARCH_BRIDGE"),
        
        yearFrom = 0,
        yearTo = 0,
        
        carriers = {"RAIL", "ROAD"},
        
        speedLimit = 60,
        
        pillarLen = 0.5,
        
        pillarMinDist = 45.0,
        pillarMaxDist = 9999.0,
        pillarTargetDist = 50.0,
        
        cost = 200.0,
        
        noParallelStripSubdivision = true,
        ignoreWaterCollision = true,
        
        updateFn = function(params)
            local result = {
                railingModels = {},
                pillarModels = {}
            }
            
            for _, height in ipairs(params.pillarHeights) do
                table.insert(result.pillarModels, {{}})
            end
            
            local maxHeight = math.max(15, table.unpack(params.pillarHeights)) + 5
            
            for i, interval in ipairs(params.railingIntervals) do
                local nSeg = math.floor((interval.length) / 5)
                if nSeg < 1 then nSeg = 1 end
                local lSeg = interval.length / nSeg
                local minOffset = interval.lanes[1].offset
                local maxOffset = interval.lanes[#interval.lanes].offset
                
                local xScale = lSeg / 5
                local zScale = maxHeight - 3
                local sp = params.railingWidth - (maxOffset - minOffset)
                local rDisp = minOffset - sp * 0.5 - 0.75
                local lDisp = maxOffset + sp * 0.5 + 0.75
                
                local width = params.railingWidth + 0.5
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
                            id = "bridge/trw/brick_fence_right.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp - 0.25, 0, 1},
                        },
                        {
                            id = "bridge/trw/brick_fence_left.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp + 0.25, 0, 1}
                        },
                        {
                            id = "bridge/trw/arch_col_top.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp, -3, 1},
                        },
                        {
                            id = "bridge/trw/arch_col_top.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp, -3, 1}
                        },
                        {
                            id = "bridge/trw/arch_col_bottom.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, rDisp, -3, 1},
                        },
                        {
                            id = "bridge/trw/arch_col_bottom.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, lDisp, -3, 1}
                        }
                    }
                    
                    if (interval.lanes[1].type == 2 or interval.lanes[1].type == 3) then
                        set[1] = false
                    end
                    
                    if (interval.lanes[#interval.lanes].type == 1 or interval.lanes[#interval.lanes].type == 3) then
                        set[2] = false
                    end

                    for i = #set, 1, -1 do
                        if (not set[i]) then
                            table.remove(set, i)
                        end
                    end

                    for k = 1, nPart do
                        local yDisp = ref - (k - 1) * wPart
                        table.insert(set, {
                            id = "bridge/trw/arch_col_top_inner.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, 1, 0, x, yDisp, -3, 1}
                        })
                        
                        table.insert(set, {
                            id = "bridge/trw/arch_col_bottom_inner.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, zScale, 0, x, yDisp, -3, 1}
                        })
                        
                        table.insert(set, {
                            id = "bridge/trw/brick_surface.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, 1, 0, x, yDisp, 0, 1}
                        })
                        
                        if (n == 1) then
                            table.insert(set, {
                                id = "bridge/trw/brick_front.mdl",
                                transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, yDisp, 0, 1}
                            })
                        end
                        if (n == nSeg) then
                            table.insert(set, {
                                id = "bridge/trw/brick_back.mdl",
                                transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, yDisp, 0, 1}
                            })
                        end
                    end
                    return set
                end
                
                local rs = {}
                for s = 1, nSeg do
                    table.insert(rs, set(s))
                end
                table.insert(result.railingModels, rs)
            end
            
            return result
        end
    }
end
