-- Quick script for Transport Fever 2 Bridges
-- Copyright Enzojz 2020
-- Please study it and write your own code, it's easy to understand :)
-- For more information about the format required by the game visite:
-- https://www.transportfever.net/lexicon/index.php?entry/288-raw-bridge-data/
local concreteWall = require "concrete_wall_fence"
local trw = require "trw"
function data()
    return {
        name = _("CONCRETE_WALL_FENCE"),
        
        yearFrom = 1920,
        yearTo = 0,
        
        carriers = {"RAIL", "ROAD"},
        
        speedLimit = 100,
        
        pillarLen = 0.5,
        
        pillarMinDist = 45.0,
        pillarMaxDist = 9999.0,
        pillarTargetDist = 50.0,
        
        cost = 200.0,
        noParallelStripSubdivision = true,
        ignoreWaterCollision = true,
        autoGeneration = false,
        updateFn = trw.updateFn(concreteWall, trw.normal)
    }
end
