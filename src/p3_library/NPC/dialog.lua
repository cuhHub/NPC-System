--------------------------------------------------------
-- [NPC Dialog Demo] NPC Library - Dialog
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        Contains code for a NPC dialog system.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/Cuh4/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------
-- Create a dialog
---@param rootOption addon_libs_npc_dialogoption
---@return addon_libs_npc_dialog
NPCLibrary.createDialog = function(rootOption)
    ---@type addon_libs_npc_dialog
    return AuroraFramework.libraries.class.create(
        "NPCDialog",

        {
            ---@param self addon_libs_npc_dialog
            ---@param id integer
            ---@param message string
            talk = function(self, id, message)
                -- if this is the first time this id has interacted with this dialog, start at the first option
                local current = self:getCurrentOption(id)

                if not current then
                    self:setCurrentOption(id, self.properties.rootOption)
                    current = self:getCurrentOption(id) -- update variable
                end

                -- check if the dialog option has further options, if not, reset
                if #current.properties.furtherOptions <= 0 then
                    self:cancel(id)
                    return nil
                end

                -- find the closest match
                local match

                for _, option in pairs(current.properties.furtherOptions) do
                    -- message doesn't match dialog option trigger
                    if not option.properties.trigger:lower():find(message:lower()) then
                        goto continue
                    end

                    -- message matches dialog option trigger
                    match = option

                    ::continue::
                end

                -- return nothing if we couldnt find a match
                if not match then
                    return nil
                end

                -- update properties
                self:setCurrentOption(id, match)

                -- fire the event and return the dialog response
                match.events.triggered:fire(match, id)
                return match
            end,

            ---@param self addon_libs_npc_dialog
            ---@param id integer
            ---@param to addon_libs_npc_dialogoption
            setCurrentOption = function(self, id, to)
                self.properties.current[id] = to
            end,

            ---@param self addon_libs_npc_dialog
            ---@param id integer
            getCurrentOption = function(self, id)
                return self.properties.current[id]
            end,

            ---@param self addon_libs_npc_dialog
            ---@param id integer
            cancel = function(self, id)
                self.properties.current[id] = nil
            end
        },

        {
            rootOption = rootOption,
            current = {}
        }
    )
end

-- Create a dialog option
---@param trigger string
---@param responses table<integer, string>
---@param furtherOptions table<integer, addon_libs_npc_dialogoption>|nil
---@param callback fun(dialogOption: addon_libs_npc_dialogoption, id: integer)|nil
---@return addon_libs_npc_dialogoption
NPCLibrary.createDialogOption = function(trigger, responses, furtherOptions, callback)
    -- Create dialog option
    ---@type addon_libs_npc_dialogoption
    local dialogOption = AuroraFramework.libraries.class.create(
        "NPCDialogOption",

        {
            ---@param self addon_libs_npc_dialogoption
            getResponse = function(self)
                return AuroraFramework.libraries.miscellaneous.getRandomTableValue(self.properties.responses)
            end
        },

        {
            trigger = trigger,
            responses = responses,
            furtherOptions = furtherOptions or {}
        },

        {
            triggered = AuroraFramework.libraries.events.create("")
        }
    )

    -- Attach callback
    if callback then
        dialogOption.events.triggered:connect(callback)
    end

    -- Return the dialog option
    return dialogOption
end