local parts = {
    ["start"] = "abutmentStart",
    ["end"] = "abutmentEnd",
    ["complete"] = "abutmentComplete"
}

local halfParts = {
    ["start"] = "halfAbutmentStart",
    ["end"] = "halfAbutmentEnd",
    ["complete"] = "halfAbutmentComplete"
}

local abutmentList = {
    ["arch_bridge"] = parts,
    ["arch_col"] = parts,
    ["concrete_col"] = parts,
    ["half_arch_bridge"] = halfParts,
    ["half_arch_col"] = halfParts,
    ["half_concrete_col"] = halfParts
}

function data()
    return {
        info = {
            minorVersion = 3,
            severityAdd = "NONE",
            severityRemove = "WARNING",
            name = _("NAME"),
            description = _("DESC"),
            authors = {
                {
                    name = "Enzojz",
                    role = "CREATOR",
                    text = "Modelling, Scripting",
                    steamProfile = "enzojz",
                    tfnetId = 27218,
                }
            },
            tags = {
                "Bridge",
                "Europe",
                "Track",
                "Street"
            },
        },
        postRunFn = function(settings, params)
            for bridgeName, parts in pairs(abutmentList) do
                local bridge = api.res.bridgeTypeRep.get(api.res.bridgeTypeRep.find(bridgeName .. ".lua"))
                for part, fn in pairs(parts) do
                    local newBridge = api.type.BridgeType.new()
                    newBridge.name = bridge.name
                    newBridge.icon = bridge.icon
                    newBridge.yearFrom = 1800
                    newBridge.yearTo = 1800
                    newBridge.sidewalkHeight = -1
                    newBridge.carriers = {0, 1}
                    newBridge.speedLimit = bridge.speedLimit
                    newBridge.pillarWidth = bridge.pillarWidth
                    newBridge.pillarLen = bridge.pillarLen
                    newBridge.pillarMinDist = bridge.pillarMinDist
                    newBridge.pillarMaxDist = bridge.pillarMaxDist
                    newBridge.pillarTargetDist = bridge.pillarTargetDist
                    newBridge.cost = bridge.cost
                    newBridge.maintenanceCost = bridge.maintenanceCost
                    newBridge.pillarGroundTexture = bridge.pillarGroundTexture
                    newBridge.pillarGroundTextureOffset = bridge.pillarGroundTextureOffset
                    newBridge.updateScript.fileName = "config/bridge/trw." .. bridgeName
                    newBridge.updateScript.params = {fn = fn}
                    local newBridgeName = ("%s_%s.lua"):format(bridgeName, part)
                    api.res.bridgeTypeRep.add(newBridgeName, newBridge, true)
                    api.res.bridgeTypeRep.setVisible(api.res.bridgeTypeRep.find(newBridgeName), false)
                end
            end
        end
    }
end
