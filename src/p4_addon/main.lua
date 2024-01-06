--------------------------------------------------------
-- [NPC Dialog Demo] Main
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        This file contains the main code for the addon.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/cuhHub/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Variables
-------------------------------
local dialog = NPCLibrary.createDialog(
    NPCLibrary.createDialogOption(
        "Hello!", -- trigger (string that activates this dialog option)

        { -- responses
            "Heya! How are you?",
            "Hello, how are you doing?"
        },

        { -- further dialog options
            NPCLibrary.createDialogOption(
                "I'm good.",

                {
                    "Don't care! Would you like a present?",
                    "Cool, I don't care. Would you like a present?"
                },

                AuroraFramework.libraries.miscellaneous.combineTables(
                    true,

                    NPCLibrary.createMultipleDialogOptionsWithSameTrigger(
                        {"Yes", "Yeah", "Sure", "Okay"},

                        {
                            "Here you go!"
                        },

                        nil,

                        ---@param dialogOption addon_libs_npc_dialog
                        ---@param ID integer
                        function(dialogOption, ID)
                            local player = AuroraFramework.services.playerService.getPlayerByPeerID(ID)
                            player:setItem(1, 10, false, 100, 100) -- fire extinguisher, slot 1
                        end
                    ),

                    NPCLibrary.createMultipleDialogOptionsWithSameTrigger(
                        {"No", "Pass", "Nah"},

                        {
                            "Idiot"
                        },

                        nil,

                        ---@param dialogOption addon_libs_npc_dialog
                        ---@param ID integer
                        function(dialogOption, ID)
                            local player = AuroraFramework.services.playerService.getPlayerByPeerID(ID)
                            player:ban()
                        end
                    )
                )
            )
        }
    )
)

-------------------------------
-- // Main
-------------------------------
-- clear chat
AuroraFramework.services.chatService.clear()

-- initialize npc library
NPCLibrary.init()

-- command that spawns npc at your position
AuroraFramework.services.commandService.create(function(player, args, command)
    local playerPos = player:getPosition()

    NPCLibrary.createNPC(
        "John", "Doe",
        45,
        NPCLibrary.enums.characterTypes.Civilian,
        playerPos,
        dialog,

        {
            "Sorry, I don't understand you.",
            "You're an idiot, try again."
        },

        {
            "Goodbye!",
            "See you!",
            "Bye!"
        }
    )
end, "spawn", {"s", "sp"})