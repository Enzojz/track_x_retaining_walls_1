-- Quick script for Transport Fever 2 Bridges
-- Copyright Enzojz 2020

function data()
    return {
        name = _("Wall bridge"),
        
        yearFrom = 0,
        yearTo = 0,
        
        carriers = {"RAIL"},
        
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
                local zScale = maxHeight - 3
                local yScale = zScale / 12
                local yDisp = -0.35 * yScale + 0.35
                local sp = params.railingWidth - (maxOffset - minOffset)
                local rDisp = minOffset - sp * 0.5 - 0.25
                local lDisp = maxOffset + sp * 0.5 + 0.25
                
                local set = function(n)
                    local x = (n - 1) * lSeg
                    local set = {
                        {
                            id = "tor/arch_wall_top_right.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp, -3, 1}
                        },
                        {
                            id = "tor/arch_wall_top_left.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp, -3, 1}
                        },
                        {
                            id = "tor/arch_wall_inner_right.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, rDisp, -3, 1}
                        },
                        {
                            id = "tor/arch_wall_inner_left.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, lDisp, -3, 1}
                        },
                        {
                            id = "tor/arch_wall_outer_right.mdl",
                            transf = {xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, x, -yDisp + rDisp, -3, 1}
                        },
                        {
                            id = "tor/arch_wall_outer_left.mdl",
                            transf = {xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, x, yDisp + lDisp, -3, 1}
                        }
                    }
                                        
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
