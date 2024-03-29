--------------------------------------------------------
-- [NPC Dialog Demo] NPC Library - Dialog
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        Contains code for a NPC dialog system.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/cuhHub/NPCDialogDemo
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
                    -- set current dialog option
                    self:setCurrentOption(id, self.properties.rootOption)
                    current = self:getCurrentOption(id) -- update variable

                    -- return dialog option
                    current.events.triggered:fire(current, id)
                    return current, false
                end

                -- check if the dialog option has further options, if not, reset
                if #current.properties.furtherOptions <= 0 then
                    self:cancel(id)
                    return nil, true
                end

                -- find the closest match
                local match

                for _, option in pairs(current.properties.furtherOptions) do
                    -- message doesn't match dialog option trigger
                    if not NPCLibrary.internal.isIdentical(option.properties.trigger, message) then
                        goto continue
                    end

                    -- message matches dialog option trigger
                    match = option

                    ::continue::
                end

                -- return nothing if we couldnt find a match
                if not match then
                    return nil, false
                end

                -- update properties
                self:setCurrentOption(id, match)

                -- check if the match has any further options, if not, reset too
                if #match.properties.furtherOptions <= 0 then
                    self:cancel(id)
                end

                -- fire the event and return the dialog response
                match.events.triggered:fire(match, id)
                return match, self:getCurrentOption(id) == nil
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

-- Create multiple dialog options with the same trigger
---@param triggers table<integer, string>
---@param responses table<integer, string>
---@param furtherOptions table<integer, addon_libs_npc_dialogoption>|nil
---@param callback fun(dialogOption: addon_libs_npc_dialogoption, id: integer)|nil
---@return addon_libs_npc_dialogoption
NPCLibrary.createMultipleDialogOptionsWithSameTrigger = function(triggers, responses, furtherOptions, callback)
    local dialogOptions = {}

    for _, trigger in pairs(triggers) do
        table.insert(
            dialogOptions,
            NPCLibrary.createDialogOption(
                trigger,
                responses,
                furtherOptions,
                callback
            )
        )
    end

    return dialogOptions
end