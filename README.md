# AutoSellLoot
Automatically sells up to Rare quality items from your invertory, skips profession/quest related items being sold. Has the ability to restrict any item being sold to a vendor or remove previously restricted item via commands.

How does it work?
- Sells up to rare quality items to a vendor when opened
- Skips profession and quest related items

How to use the feature to restrict/remove items being sold?
- Use command /asid <itemID> ingame chat to restrict an item(ex: /asid 22796)
- Use command /removeid <itemID> ingame chat to remove already restricted items (ex: /removeid 22796)

The AddOn have buildin checkup if an item is already restricted from sell and prints out a message that the current item is being in restricted( for /asid) and if you want to remove an item from the restricted it prints item has been removed OR isn't in the restricted(for /removeid)

Saves ID's into SavedVariables system, so it will persist thru logouts.




To Do:
HR Mats
Callboard Quests.
