--------------------------------------------------------
-- [NPC Dialog Demo] Addon Intellisense
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        This file provides intellisense for classes in this addon.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/Cuh4/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Lua LSP Diagnostics
-------------------------------
---@diagnostic disable missing-return

-------------------------------
-- // Main
-------------------------------
-- // NPC Library
---@class addon_libs_npc_npc: af_libs_class_class
_ = {
    __name__ = "NPC",

    properties = {
        firstName = "",
        lastName = "",
        age = 0,
        spawnPosition = matrix.translation(0, 0, 0),
        object_id = 0,
        characterType = nil, ---@type SWOutfitTypeEnum
        dialog = nil, ---@type addon_libs_npc_dialog
        id = 0,
        confusionResponses = {}, ---@type table<integer, string>
        goodbyeResponses = {}, ---@type table<integer, string>
        talkingTo = {} ---@type table<integer, af_services_player_player>
    },

    ---@param self addon_libs_npc_npc
    ---@return string
    name = function(self) end,

    ---@param self addon_libs_npc_npc
    ---@param player af_services_player_player
    ---@param message string
    ---@return string
    talk = function(self, player, message) end,

    ---@param self addon_libs_npc_npc
    ---@param player af_services_player_player
    ---@param silentGoodbye boolean|nil
    cancel = function(self, player, silentGoodbye) end,

    ---@param self addon_libs_npc_npc
    ---@return SWMatrix
    getPosition = function(self) end,

    ---@param self addon_libs_npc_npc
    ---@param newPosition SWMatrix
    teleport = function(self, newPosition) end,

    ---@param self addon_libs_npc_npc
    spawn = function(self) end,

    ---@param self addon_libs_npc_npc
    despawn = function(self) end,

    ---@param self addon_libs_npc_npc
    ---@param player af_services_player_player
    ---@return boolean
    isTalking = function(self, player) end
}

---@class addon_libs_npc_dialog: af_libs_class_class
_ = {
    __name__ = "NPCDialog",

    properties = {
        rootOption = nil, ---@type addon_libs_npc_dialogoption
        current = {} ---@type table<integer, addon_libs_npc_dialogoption> the current dialog option for an ID
    },

    ---@param self addon_libs_npc_dialog
    ---@param id integer
    ---@param message string
    ---@return addon_libs_npc_dialogoption, boolean
    talk = function(self, id, message) end,

    ---@param self addon_libs_npc_dialog
    ---@param id integer
    ---@param to addon_libs_npc_dialogoption
    setCurrentOption = function(self, id, to) end,
    
    ---@param self addon_libs_npc_dialog
    ---@param id integer
    ---@return addon_libs_npc_dialogoption
    getCurrentOption = function(self, id) end,

    ---@param self addon_libs_npc_dialog
    ---@param id integer
    cancel = function(self, id) end,
}

---@class addon_libs_npc_dialogoption: af_libs_class_class
_ = {
    __name__ = "NPCDialogOption",

    properties = {
        trigger = "",
        responses = {}, ---@type table<integer, string>
        furtherOptions = {}, ---@type table<integer, addon_libs_npc_dialogoption>
    },

    events = {
        triggered = nil ---@type af_libs_event_event
    },

    ---@param self addon_libs_npc_dialogoption
    ---@return string
    getResponse = function(self) end
}