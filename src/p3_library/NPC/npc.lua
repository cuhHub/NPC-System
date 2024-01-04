--------------------------------------------------------
-- [NPC Dialog Demo] NPC Library - Enums
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        Contains the main code for the NPC library.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/Cuh4/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Functions
-------------------------------
-- Handle NPCs
NPCLibrary.init = function()
    -- When a player leaves, cancel all active NPC dialogs with the player
    ---@param player af_services_player_player
    AuroraFramework.services.playerService.events.onLeave:connect(function(player)
        for _, npc in pairs(NPCLibrary.getAllNPCs()) do
            npc:cancel(player)
        end
    end)

    -- If a player gets too far from a NPC, cancel the dialog
    AuroraFramework.services.timerService.loop.create(0.05, function()
        for _, player in pairs(AuroraFramework.services.playerService.getAllPlayers()) do
            -- Get the player's position
            local playerPosition = player:getPosition()

            for _, NPC in pairs(NPCLibrary.getAllNPCs()) do
                -- Check if NPC is talking to this player
                if not NPC:isTalking(player) then
                    goto continue
                end

                -- Get the NPC's position
                local NPCPosition = NPC:getPosition()

                -- Get distance
                local distance = matrix.distance(NPCPosition, playerPosition)

                -- Player is too far, so cancel dialog
                if distance > NPCLibrary.settings.maxTalkingDistance then
                    NPC:cancel(player)
                end

                ::continue::
            end
        end
    end)
end

-- Create a NPC
---@param firstName string
---@param lastName string
---@param age integer
---@param characterType SWOutfitTypeEnum
---@param spawnPosition SWMatrix
---@param dialog addon_libs_npc_dialogoption
---@param confusionResponses table<integer, string>
---@param goodbyeResponses table<integer, string>
---@return addon_libs_npc_npc
NPCLibrary.createNPC = function(firstName, lastName, age, characterType, spawnPosition, dialog, confusionResponses, goodbyeResponses)
    -- Increment ID
    NPCLibrary.id = NPCLibrary.id + 1

    -- Create the NPC
    ---@type addon_libs_npc_npc
    local NPC = AuroraFramework.libraries.class.create(
        "NPC",

        {
            ---@param self addon_libs_npc_npc
            name = function(self)
                return ("%s %s (NPC)"):format(self.properties.firstName, self.properties.lastName)
            end,

            ---@param self addon_libs_npc_npc
            ---@param player af_services_player_player
            ---@param message string
            talk = function(self, player, message) 
                -- Get the current dialog option for this player
                local id = player.properties.peer_id
                local currentOption = self.properties.dialog:talk(id, message)

                -- Update property
                self.properties.talkingTo[id] = true

                -- Couldn't find a response, so send a confused message
                if not currentOption then
                    return AuroraFramework.services.chatService.sendMessage(
                        self:name(),
                        AuroraFramework.libraries.miscellaneous.getRandomTableValue(self.properties.confusionResponses),
                        player
                    )
                end

                -- Send the response
                local nextTriggers = {}

                for _, dialogOption in pairs(currentOption.properties.furtherOptions) do
                    table.insert(
                        nextTriggers,
                        "["..dialogOption.properties.trigger.."]"
                    )
                end

                AuroraFramework.services.chatService.sendMessage(
                    self:name(),
                    currentOption:getResponse().."\n"..table.concat(nextTriggers, " - "),
                    player
                )
            end,

            ---@param self addon_libs_npc_npc
            ---@param player af_services_player_player
            cancel = function(self, player)
                -- Check if the player is even being talked to
                if not self:isTalking(player) then
                    return
                end

                -- Get the player's ID
                local id = player.properties.peer_id

                -- Cancel the dialog for this player
                self.properties.dialog:cancel(id)

                -- Update property
                self.properties.talkingTo[id] = nil

                -- Send a goodbye message
                AuroraFramework.services.chatService.sendMessage(
                    self:name(),
                    AuroraFramework.libraries.miscellaneous.getRandomTableValue(self.properties.goodbyeResponses),
                    player
                )
            end,

            ---@param self addon_libs_npc_npc
            getPosition = function(self)
                return (server.getObjectPos(self.properties.object_id))
            end,

            ---@param self addon_libs_npc_npc
            ---@param newPosition SWMatrix
            teleport = function(self, newPosition)
                server.setObjectPos(self.properties.object_id, newPosition)
            end,

            ---@param self addon_libs_npc_npc
            spawn = function(self)
                local object_id, success = server.spawnCharacter(
                    self.properties.spawnPosition,
                    self.properties.characterType
                )

                if not success then
                    return
                end

                self.properties.object_id = object_id
            end,

            ---@param self addon_libs_npc_npc
            despawn = function(self)
                server.despawnObject(self.properties.object_id, true)
            end,

            ---@param self addon_libs_npc_npc
            ---@param player af_services_player_player
            isTalking = function(self, player)
                return self.properties.talkingTo[player.properties.peer_id] ~= nil
            end
        },

        {
            firstName = firstName,
            lastName = lastName,
            age = age,
            spawnPosition = spawnPosition,
            object_id = 0,
            characterType = characterType,
            dialog = NPCLibrary.createDialog(dialog),
            id = NPCLibrary.id,
            confusionResponses = confusionResponses,
            goodbyeResponses = goodbyeResponses,
            talkingTo = {}
        },

        nil,

        NPCLibrary.spawnedNPCs,
        NPCLibrary.id
    )

    -- Spawn the NPC
    NPC:spawn()

    -- Return
    return NPC
end

-- Get a NPC
---@param id integer
---@return addon_libs_npc_npc
NPCLibrary.getNPC = function(id)
    return NPCLibrary.spawnedNPCs[id]
end

-- Get all NPCs
---@return table<integer, addon_libs_npc_npc>
NPCLibrary.getAllNPCs = function()
    return NPCLibrary.spawnedNPCs
end

-- Remove a NPC
---@param id integer
NPCLibrary.removeNPC = function(id)
    -- Get the NPC
    local NPC = NPCLibrary.getNPC(id)

    if not NPC then
        return
    end

    -- Remove it from the list, and despawn the character
    NPC:despawn()
    NPCLibrary.spawnedNPCs[id] = nil
end