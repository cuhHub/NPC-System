--------------------------------------------------------
-- [NPC Dialog Demo] NPC Library - Internal
--------------------------------------------------------

--[[
    ----------------------------

    INFO:
        Contains internal library functions n stuff.

    CREDIT:
        Author: @cuh6_ (Discord)
        GitHub Repository: https://github.com/cuhHub/NPCDialogDemo
        Created: 04/01/2024

    ----------------------------
]]

-------------------------------
-- // Main
-------------------------------
-- Returns whether or not two strings are identical
---@param str1 string
---@param str2 string
NPCLibrary.internal.isIdentical = function(str1, str2)
    local newStr1 = NPCLibrary.internal.stripPunctuation(str1:lower())
    local newStr2 = NPCLibrary.internal.stripPunctuation(str2:lower())

    return newStr1:find(newStr2) or newStr2:find(newStr1)
end

-- Strip punctuation
---@param input string
NPCLibrary.internal.stripPunctuation = function(input)
    return input:gsub("%p", "")
end