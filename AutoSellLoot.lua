-- AutoSellItems.lua

-- Define the saved variables table
AutoSellItems = AutoSellItems or {}
AutoSellItems.excludedItemIDs = AutoSellItems.excludedItemIDs or {}

-- Predefined list of item IDs to exclude from being sold
local predefinedExcludedItemIDs = {
    22795,  -- Example item ID to exclude
    -- Add more item IDs as needed
}

-- Initialize excluded item IDs with predefined values
for _, itemID in ipairs(predefinedExcludedItemIDs) do
    AutoSellItems.excludedItemIDs[itemID] = true
end

-- List of item name tags to exclude from being sold
local excludeNames = {
    "Thunderfury",    -- Example name tag to exclude
    "Legendary",      -- Add more name tags as needed		
}

-- Function to check if an item name contains an exclusion tag
local function IsItemExcluded(itemName)
    for _, nameTag in ipairs(excludeNames) do
        if string.find(itemName:lower(), nameTag:lower()) then
            return true
        end
    end
    return false
end

-- Function to check if an item ID is excluded
local function IsItemIDExcluded(itemID)
    return AutoSellItems.excludedItemIDs[itemID] ~= nil
end

-- Function to check if an item is a profession item
local function IsProfessionItem(itemID)
    local itemType = select(6, GetItemInfo(itemID))
    return itemType == "Trade Goods" or itemType == "Recipe" or itemType == "Glyph"
end

-- Function to check if an item is a quest item
local function IsQuestItem(bag, slot)
    local isQuestItem = select(12, GetContainerItemInfo(bag, slot)) -- 12th return value indicates if it's a quest item
    return isQuestItem
end

-- Function to add an item ID to the exclusion list
local function AddItemIDToExclusion(itemID)
    if not IsItemIDExcluded(itemID) then
        AutoSellItems.excludedItemIDs[itemID] = true
        print("Item ID " .. itemID .. " has been added to the exclusion list.")
    else
        print("Item ID " .. itemID .. " is already in the exclusion list.")
    end
end

-- Slash command to handle /asid
SLASH_ASID1 = "/asid"
SlashCmdList["ASID"] = function(msg)
    local itemID = tonumber(msg)
    if itemID then
        AddItemIDToExclusion(itemID)
    else
        print("Please provide a valid item ID.")
    end
end

-- Function to remove an item ID from the exclusion list
local function RemoveItemIDFromExclusion(itemID)
    if IsItemIDExcluded(itemID) then
        AutoSellItems.excludedItemIDs[itemID] = nil
        print("Item ID " .. itemID .. " has been removed from the exclusion list.")
    else
        print("Item ID " .. itemID .. " is not in the exclusion list.")
    end
end

-- Slash command to handle /removeid
SLASH_REMOVEID1 = "/removeid"
SlashCmdList["REMOVEID"] = function(msg)
    local itemID = tonumber(msg)
    if itemID then
        RemoveItemIDFromExclusion(itemID)
    else
        print("Please provide a valid item ID.")
    end
end

-- Main addon frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("PLAYER_LOGOUT")

frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        -- Iterate through the player's bag slots (0-4 represent the backpack and bags)
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local itemLink = GetContainerItemLink(bag, slot)
                
                -- Check if there is an item in the slot
                if itemLink then
                    local itemName, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
                    local itemID = GetContainerItemID(bag, slot)
                    local _, itemCount = GetContainerItemInfo(bag, slot)
                    
                    -- Exclude items that match exclusion criteria: by name, ID, profession, or if it is a quest item
                    if not IsItemExcluded(itemName)
                        and not IsItemIDExcluded(itemID)
                        and not IsProfessionItem(itemID)
                        and not IsQuestItem(bag, slot)  -- Exclude quest items
                        and (itemRarity == 0 or itemRarity == 1 or itemRarity == 2 or itemRarity == 3)
                        and itemSellPrice > 0 then
                        
                        UseContainerItem(bag, slot)
                        print("Sold " .. itemLink .. " for " .. GetCoinTextureString(itemSellPrice * itemCount))
                    end
                end
            end
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Save excluded item IDs to persistent storage
        -- This part is handled automatically by the SavedVariables system
    end
end)

-- Load excluded item IDs when the addon is initialized
-- This is handled automatically by the SavedVariables system
