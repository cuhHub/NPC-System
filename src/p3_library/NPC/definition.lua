--------------------------------------------------------
-- [NPC Dialog Demo] NPC Library - Definition
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        Defines the NPC library.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/cuhHub/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------
NPCLibrary = {
    enums = {},
    internal = {},
    spawnedNPCs = {}, ---@type table<integer, addon_libs_npc_npc>
    id = 0,

    settings = {
        maxTalkingDistance = 5
    }
}