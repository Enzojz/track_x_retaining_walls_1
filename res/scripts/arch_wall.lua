return function(interval, maxHeight, params)
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
    local rDisp = minOffset - sp * 0.5 - 0.75
    local lDisp = maxOffset + sp * 0.5 + 0.75
    
    local width = params.railingWidth + 1
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
                id = "bridge/trw/arch_wall_top_right.mdl",
                transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, rDisp, -3, 1},
                rightRemoval = true
            },
            {
                id = "bridge/trw/arch_wall_top_left.mdl",
                transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, lDisp, -3, 1},
                leftRemoval = true
            },
            {
                id = "bridge/trw/arch_wall_inner_right.mdl",
                transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, rDisp, -3, 1},
                rightRemoval = true
            },
            {
                id = "bridge/trw/arch_wall_inner_left.mdl",
                transf = {xScale, 0, 0, 0, 0, 1, 0, 0, 0, 0, zScale, 0, x, lDisp, -3, 1},
                leftRemoval = true
            },
            {
                id = "bridge/trw/arch_wall_outer_right.mdl",
                transf = {xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, x, -yDisp + rDisp, -3, 1},
                rightRemoval = true
            },
            {
                id = "bridge/trw/arch_wall_outer_left.mdl",
                transf = {xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, x, yDisp + lDisp, -3, 1},
                leftRemoval = true
            }
        }
                            
        for k = 1, nPart do
            local yDisp = ref - (k - 1) * wPart
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
    return set, set, nSeg
end
