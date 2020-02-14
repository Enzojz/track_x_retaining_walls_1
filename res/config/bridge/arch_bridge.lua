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
                            id = "trw/brick_fence_right.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp - 0.25, 0, 1}
                        },
                        {
                            id = "trw/brick_fence_left.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp + 0.25, 0, 1}
                        },
                        {
                            id = "trw/arch_col_top.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp, -3, 1}
                        },
                        {
                            id = "trw/arch_col_top.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp, -3, 1}
                        },
                        {
                            id = "trw/arch_col_bottom.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, rDisp, -3, 1}
                        },
                        {
                            id = "trw/arch_col_bottom.mdl",
                            transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, lDisp, -3, 1}
                        }
                    }
                               
                    for k = 1, nPart do
                        
                        table.insert(set,
                        {
                            id = "trw/arch_col_top_inner.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, 1, 0, x, ref - (k - 1) * wPart, -3, 1}
                        })
                        
                        table.insert(set,
                        {
                            id = "trw/arch_col_bottom_inner.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, zScale, 0, x, ref - (k - 1) * wPart, -3, 1}
                        })

                        table.insert(set,
                        {
                            id = "trw/brick_plane.mdl",
                            transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, 1, 0, x, ref - (k - 1) * wPart, 0, 1}
                        })

                        if (#interval.lanes > 0) then
                            if (n == 1) then
                                table.insert(set,
                                    {
                                        id = "trw/brick_front_face.mdl",
                                        transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, ref - (k - 1) * wPart, 0, 1}
                                    })
                            end
                            if (n == nSeg) then
                                table.insert(set,
                                    {
                                        id = "trw/brick_back_face.mdl",
                                        transf = {xScale, 0, 0, 0, 0, wScale, 0, 0, 0, 0, maxHeight, 0, x, ref - (k - 1) * wPart, 0, 1}
                                    })
                            end
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
