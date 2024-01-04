--------------------------------------------------------
-- [NPC Dialog Demo] Main
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        This file contains the main code for the addon.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/Cuh4/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Variables
-------------------------------
local dialog = NPCLibrary.createDialogOption(
    "Hello",

    {
        "Heya! How are you?",
        "Hi! How are you?",
        "Yoo! How are you?"
    },

    {
        NPCLibrary.createDialogOption(
            "I'm good",

            {
                "Awesome to hear! Goodbye!",
                "No."
            },

            nil,

            function(dialogOption, id)
                mainLogger:send("final dialog triggered")
            end
        )
    }
)

-------------------------------
-- // Main
-------------------------------
-- initialize npc library
NPCLibrary.init()

-- get names
local names = { -- thx chatgpt
    {"Bob", "Jenkins"},
    {"Sam", "Roberts"},
    {"Emily", "Smith"},
    {"John", "Davis"},
    {"Lily", "Johnson"},
    {"Charlie", "Anderson"},
    {"Sophia", "Brown"},
    {"David", "Miller"},
    {"Olivia", "Wilson"},
    {"Daniel", "Taylor"}
}

-- command that spawns npc at your position
AuroraFramework.services.commandService.create(function(command, args, player)
    local playerPos = player:getPosition()

    local firstName, lastName = table.unpack(
        AuroraFramework.libraries.miscellaneous.getRandomTableValue(names)
    )

    NPCLibrary.createNPC(
        firstName, lastName,
        math.random(1, 60),
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
end, "spawn", {"s", "sp"}, false, "spawn npc", false, true)