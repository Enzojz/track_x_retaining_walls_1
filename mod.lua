local trw = require "trw"

local parts = {
  ["start"] = trw.abutmentStart,
  ["end"] = trw.abutmentEnd,
  ["complete"] = trw.abutmentComplete
}

local halfParts = {
  ["start"] = trw.halfAbutmentStart,
  ["end"] = trw.halfAbutmentEnd,
  ["complete"] = trw.halfAbutmentComplete
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
            minorVersion = 1,
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

            for bridgeName, parts in ipairs(abutmentList) do
              local bridge = api.res.bridgeTypeRep.get(api.res.bridgeTypeRep.find(bridgeName .. ".lua"))
              for part, fn in ipairs(parts) do
                local newBridge = api.type.BridgeType.new()
                newBridge.name = bridge.name
                newBridge.icon = bridge.icon
                newBridge.yearFrom = 1800
                newBridge.yearTo = 1800
                newBridge.sidewalkHeight = -1
                newBridge.carriers = { 0, 1 }
                newBridge.speedLimit = bridge.speedLimit
                newBridge.pillarWidth = bridge.pillarWidth
                newBridge.pillarLen = bridge.pillarLen
                newBridge.pillarMinDist = bridge.pillarMinDist 
                newBridge.pillarMaxDist = bridge.pillarMaxDist 
                newBridge.pillarTargetDist = bridge.pillarTargetDist 
                newBridge.cost = bridge.cost
                newBridge.maintenanceCost = bridge.maintenanceCost
                newBridge.pillarGroundTexture = ""
                newBridge.pillarGroundTextureOffset = 2
                newBridge.updateScript.fileName = "config/bridge/trw." .. bridgeName
                newBridge.updateScript.params = { fn = fn }
    
                api.res.bridgeTypeRep.add(("%s_%s.lua"):format(bridgeName, part), newBridge, true)
              end
            end
        end
    }
end
