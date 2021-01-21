function data()
    return {
        guiInit = function()
            api.cmd.sendCommand(
                api.cmd.make.sendScriptEvent("trw.lua", "__abutment__", "registe", {
                    ["arch_bridge.lua"] =
                    {
                        "arch_bridge_start.lua",
                        "arch_bridge_end.lua",
                        "arch_bridge_complete.lua"
                    },
                    ["arch_col.lua"] =
                    {
                        "arch_col_start.lua",
                        "arch_col_end.lua",
                        "arch_col_complete.lua"
                    },
                    ["concrete_col.lua"] =
                    {
                        "concrete_col_start.lua",
                        "concrete_col_end.lua",
                        "concrete_col_complete.lua"
                    },
                    ["half_arch_bridge.lua"] =
                    {
                        "half_arch_bridge_start.lua",
                        "half_arch_bridge_end.lua",
                        "half_arch_bridge_complete.lua"
                    },
                    ["half_arch_col.lua"] =
                    {
                        "half_arch_col_start.lua",
                        "half_arch_col_end.lua",
                        "half_arch_col_complete.lua"
                    },
                    ["half_concrete_col.lua"] =
                    {
                        "half_concrete_col_start.lua",
                        "half_concrete_col_end.lua",
                        "half_concrete_col_complete.lua"
                    }
                })
        )
        end,
    }
end
