-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSM.L = {}



do
	local locale = GetLocale()
	if locale == "enUS" or locale == "enGB" then
		TSM.L["%d Groups"] = "%d Groups"
		TSM.L["%d Items"] = "%d Items"
		TSM.L["%d Operations"] = "%d Operations"
		TSM.L["%d Posted Auctions"] = "%d Posted Auctions"
		TSM.L["%d Sold Auctions"] = "%d Sold Auctions"
		TSM.L["%d auctions"] = "%d auctions"
		TSM.L["%d of %d"] = "%d of %d"
		TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Selected (%d |4Item:Items;)"
		TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bags, %s bank, %s AH, %s mail)"
		TSM.L["%s (%s player, %s alts, %s AH)"] = "%s (%s player, %s alts, %s AH)"
		TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s player, %s alts, %s guild, %s AH)"
		TSM.L["%s (%s profit)"] = "%s (%s profit)"
		TSM.L["%s Crafts"] = "%s Crafts"
		TSM.L["%s Operations"] = "%s Operations"
		TSM.L["%s ago"] = "%s ago"
		TSM.L["%s group is already up to date."] = "%s group is already up to date."
		TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
		TSM.L["%s in guild vault"] = "%s in guild vault"
		TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s is a valid custom price but %s is an invalid item."
		TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s is a valid custom price but did not give a value for %s."
		TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s is not a valid custom price and gave the following error: %s"
		TSM.L["%s operation"] = "%s operation"
		TSM.L["%s operations"] = "%s operations"
		TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
		TSM.L["%s removed."] = "%s removed."
		TSM.L["%s sent you %s"] = "%s sent you %s"
		TSM.L["%s sent you %s and %s"] = "%s sent you %s and %s"
		TSM.L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
		TSM.L["%s sent you a message: %s"] = "%s sent you a message: %s"
		TSM.L["%s total"] = "%s total"
		TSM.L["%sDrag%s to move this button"] = "%sDrag%s to move this button"
		TSM.L["%sLeft-Click%s to open the main window"] = "%sLeft-Click%s to open the main window"
		TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."
		TSM.L["(%d/500 Characters)"] = "(%d/500 Characters)"
		TSM.L["(max %d)"] = "(max %d)"
		TSM.L["(max 5000)"] = "(max 5000)"
		TSM.L["(min %d - max %d)"] = "(min %d - max %d)"
		TSM.L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
		TSM.L["(minimum 0 - maximum 20)"] = "(minimum 0 - maximum 20)"
		TSM.L["(minimum 0 - maximum 2000)"] = "(minimum 0 - maximum 2000)"
		TSM.L["(minimum 0 - maximum 905)"] = "(minimum 0 - maximum 905)"
		TSM.L["(minimum 0.5 - maximum 10)"] = "(minimum 0.5 - maximum 10)"
		TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Shows this help listing"
		TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - opens the main TSM window."
		TSM.L["1 Group"] = "1 Group"
		TSM.L["1 Item"] = "1 Item"
		TSM.L["12 hr"] = "12 hr"
		TSM.L["2 hr"] = "2 hr"
		TSM.L["24 hr"] = "24 hr"
		TSM.L["48 hr"] = "48 hr"
		TSM.L["8 hr"] = "8 hr"
		TSM.L["A custom price of %s for %s evaluates to %s."] = "A custom price of %s for %s evaluates to %s."
		TSM.L["A maximum of 1 convert() function is allowed."] = "A maximum of 1 convert() function is allowed."
		TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
		TSM.L["A profile with this name already exists."] = "A profile with this name already exists."
		TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
		TSM.L["ADD %d ITEMS"] = "ADD %d ITEMS"
		TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
		TSM.L["ADD OPERATION"] = "ADD OPERATION"
		TSM.L["ADD TO MAIL"] = "ADD TO MAIL"
		TSM.L["AH"] = "AH"
		TSM.L["AH (Crafting)"] = "AH (Crafting)"
		TSM.L["AH (Disenchanting)"] = "AH (Disenchanting)"
		TSM.L["AH BUSY"] = "AH BUSY"
		TSM.L["AH Frame Options"] = "AH Frame Options"
		TSM.L["AHDB Minimum Bid"] = "AHDB Minimum Bid"
		TSM.L["AHDB Minimum Buyout"] = "AHDB Minimum Buyout"
		TSM.L["AMOUNT"] = "AMOUNT"
		TSM.L["APPLY FILTERS"] = "APPLY FILTERS"
		TSM.L["AUCTION DETAILS"] = "AUCTION DETAILS"
		TSM.L["Above max expires."] = "Above max expires."
		TSM.L["Above max price. Not posting."] = "Above max price. Not posting."
		TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
		TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
		TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
		TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
		TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
		TSM.L["Account Syncing"] = "Account Syncing"
		TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
		TSM.L["Accounting"] = "Accounting"
		TSM.L["Accounting Tooltips"] = "Accounting Tooltips"
		TSM.L["Activity Type"] = "Activity Type"
		TSM.L["Add / Remove Items"] = "Add / Remove Items"
		TSM.L["Add Player"] = "Add Player"
		TSM.L["Add Subject / Description"] = "Add Subject / Description"
		TSM.L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
		TSM.L["Added %s to %s."] = "Added %s to %s."
		TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
		TSM.L["Additional error suppressed"] = "Additional error suppressed"
		TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
		TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
		TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
		TSM.L["Advanced Item Search"] = "Advanced Item Search"
		TSM.L["Advanced Options"] = "Advanced Options"
		TSM.L["Alarm Clock"] = "Alarm Clock"
		TSM.L["All Auctions"] = "All Auctions"
		TSM.L["All Characters and Guilds"] = "All Characters and Guilds"
		TSM.L["All Item Classes"] = "All Item Classes"
		TSM.L["All Professions"] = "All Professions"
		TSM.L["All Subclasses"] = "All Subclasses"
		TSM.L["Allow partial stack?"] = "Allow partial stack?"
		TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
		TSM.L["Alts"] = "Alts"
		TSM.L["Alts AH"] = "Alts AH"
		TSM.L["Amount"] = "Amount"
		TSM.L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
		TSM.L["Apply operation to group:"] = "Apply operation to group:"
		TSM.L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
		TSM.L["Are you sure you want to delete this group?"] = "Are you sure you want to delete this group?"
		TSM.L["Are you sure you want to delete this operation?"] = "Are you sure you want to delete this operation?"
		TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
		TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
		TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
		TSM.L["Auction"] = "Auction"
		TSM.L["Auction Bid"] = "Auction Bid"
		TSM.L["Auction Buyout"] = "Auction Buyout"
		TSM.L["Auction Duration"] = "Auction Duration"
		TSM.L["Auction House Cut"] = "Auction House Cut"
		TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
		TSM.L["Auction Window Close"] = "Auction Window Close"
		TSM.L["Auction Window Open"] = "Auction Window Open"
		TSM.L["Auction has been bid on."] = "Auction has been bid on."
		TSM.L["Auctionator - Auction Value"] = "Auctionator - Auction Value"
		TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Appraiser"
		TSM.L["Auctioneer - Market Value"] = "Auctioneer - Market Value"
		TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Minimum Buyout"
		TSM.L["Auctioning"] = "Auctioning"
		TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
		TSM.L["Auctioning Log"] = "Auctioning Log"
		TSM.L["Auctioning Operation"] = "Auctioning Operation"
		TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
		TSM.L["Auctions"] = "Auctions"
		TSM.L["Auto Quest Complete"] = "Auto Quest Complete"
		TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
		TSM.L["Average Prices:"] = "Average Prices:"
		TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
		TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
		TSM.L["Avg Buy Price"] = "Avg Buy Price"
		TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
		TSM.L["Avg Sell Price"] = "Avg Sell Price"
		TSM.L["BACK"] = "BACK"
		TSM.L["BACK TO LIST"] = "BACK TO LIST"
		TSM.L["BBG 14-Day Price"] = "BBG 14-Day Price"
		TSM.L["BBG 3-Day Price"] = "BBG 3-Day Price"
		TSM.L["BBG Global Mean"] = "BBG Global Mean"
		TSM.L["BBG Global Median"] = "BBG Global Median"
		TSM.L["BID"] = "BID"
		TSM.L["BUSY"] = "BUSY"
		TSM.L["BUY"] = "BUY"
		TSM.L["BUY GROUPS"] = "BUY GROUPS"
		TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
		TSM.L["BUYOUT"] = "BUYOUT"
		TSM.L["BUYS"] = "BUYS"
		TSM.L["Back to List"] = "Back to List"
		TSM.L["Bag"] = "Bag"
		TSM.L["Bags"] = "Bags"
		TSM.L["Banks"] = "Banks"
		TSM.L["Base Group"] = "Base Group"
		TSM.L["Base Item"] = "Base Item"
		TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."
		TSM.L["Below custom price:"] = "Below custom price:"
		TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
		TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
		TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
		TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
		TSM.L["Bid %d / %d"] = "Bid %d / %d"
		TSM.L["Bid (item)"] = "Bid (item)"
		TSM.L["Bid (stack)"] = "Bid (stack)"
		TSM.L["Bid Price"] = "Bid Price"
		TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
		TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
		TSM.L["Bidding Auction"] = "Bidding Auction"
		TSM.L["Blacklisted players:"] = "Blacklisted players:"
		TSM.L["Bought"] = "Bought"
		TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
		TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
		TSM.L["Bound Actions"] = "Bound Actions"
		TSM.L["Buy"] = "Buy"
		TSM.L["Buy %d / %d"] = "Buy %d / %d"
		TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
		TSM.L["Buy Options"] = "Buy Options"
		TSM.L["Buy from AH"] = "Buy from AH"
		TSM.L["Buy from Vendor"] = "Buy from Vendor"
		TSM.L["Buyer/Seller"] = "Buyer/Seller"
		TSM.L["Buyout (item)"] = "Buyout (item)"
		TSM.L["Buyout (stack)"] = "Buyout (stack)"
		TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
		TSM.L["Buyout Price"] = "Buyout Price"
		TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
		TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
		TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
		TSM.L["CANCELS"] = "CANCELS"
		TSM.L["CHARACTER"] = "CHARACTER"
		TSM.L["CLEAR DATA"] = "CLEAR DATA"
		TSM.L["COD"] = "COD"
		TSM.L["CONTACTS"] = "CONTACTS"
		TSM.L["CRAFT"] = "CRAFT"
		TSM.L["CRAFT ALL"] = "CRAFT ALL"
		TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
		TSM.L["CRAFTER"] = "CRAFTER"
		TSM.L["CRAFTING"] = "CRAFTING"
		TSM.L["CREATE MACRO"] = "CREATE MACRO"
		TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
		TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
		TSM.L["CUSTOM POST"] = "CUSTOM POST"
		TSM.L["Can't load TSM tooltip while in combat"] = "Can't load TSM tooltip while in combat"
		TSM.L["Cancel Scan"] = "Cancel Scan"
		TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
		TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
		TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
		TSM.L["Canceling"] = "Canceling"
		TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
		TSM.L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
		TSM.L["Canceling Settings"] = "Canceling Settings"
		TSM.L["Canceling all auctions."] = "Canceling all auctions."
		TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
		TSM.L["Canceling disabled."] = "Canceling disabled."
		TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
		TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
		TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
		TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
		TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
		TSM.L["Cancelled"] = "Cancelled"
		TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
		TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
		TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
		TSM.L["Cash Register"] = "Cash Register"
		TSM.L["Character"] = "Character"
		TSM.L["Chat Tab"] = "Chat Tab"
		TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
		TSM.L["Clear"] = "Clear"
		TSM.L["Clear All"] = "Clear All"
		TSM.L["Clear Filters"] = "Clear Filters"
		TSM.L["Clear Old Data"] = "Clear Old Data"
		TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
		TSM.L["Clear Queue"] = "Clear Queue"
		TSM.L["Clear Selection"] = "Clear Selection"
		TSM.L["Coins (%s)"] = "Coins (%s)"
		TSM.L["Collapse All Groups"] = "Collapse All Groups"
		TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
		TSM.L["Combining..."] = "Combining..."
		TSM.L["Completed full AH scan (%d auctions)!"] = "Completed full AH scan (%d auctions)!"
		TSM.L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
		TSM.L["Confirm"] = "Confirm"
		TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
		TSM.L["Confirming %d / %d"] = "Confirming %d / %d"
		TSM.L["Connected to %s"] = "Connected to %s"
		TSM.L["Connecting to %s"] = "Connecting to %s"
		TSM.L["Contacts Menu"] = "Contacts Menu"
		TSM.L["Cooldown"] = "Cooldown"
		TSM.L["Cooldowns"] = "Cooldowns"
		TSM.L["Cost"] = "Cost"
		TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
		TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Could not find profile '%s'. Possible profiles: '%s'"
		TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
		TSM.L["Craft"] = "Craft"
		TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
		TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
		TSM.L["Craft All"] = "Craft All"
		TSM.L["Craft Name"] = "Craft Name"
		TSM.L["Craft value method:"] = "Craft value method:"
		TSM.L["Crafting"] = "Crafting"
		TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
		TSM.L["Crafting Cost"] = "Crafting Cost"
		TSM.L["Crafting Queue"] = "Crafting Queue"
		TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
		TSM.L["Crafts"] = "Crafts"
		TSM.L["Crafts %d"] = "Crafts %d"
		TSM.L["Create New Operation"] = "Create New Operation"
		TSM.L["Create Profession Group"] = "Create Profession Group"
		TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
		TSM.L["Crystals"] = "Crystals"
		TSM.L["Current Profiles"] = "Current Profiles"
		TSM.L["Custom Price"] = "Custom Price"
		TSM.L["Custom Price Source"] = "Custom Price Source"
		TSM.L["Custom Sources"] = "Custom Sources"
		TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
		TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
		TSM.L["DOWN"] = "DOWN"
		TSM.L["Database Sources"] = "Database Sources"
		TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
		TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
		TSM.L["Default Price"] = "Default Price"
		TSM.L["Default Price Configuration"] = "Default Price Configuration"
		TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
		TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
		TSM.L["Delete this record?"] = "Delete this record?"
		TSM.L["Deposit"] = "Deposit"
		TSM.L["Deposit Cost"] = "Deposit Cost"
		TSM.L["Deposit Price"] = "Deposit Price"
		TSM.L["Deselect All Groups"] = "Deselect All Groups"
		TSM.L["Deselect All Items"] = "Deselect All Items"
		TSM.L["Destroy Next"] = "Destroy Next"
		TSM.L["Destroy Value"] = "Destroy Value"
		TSM.L["Destroy Value Source"] = "Destroy Value Source"
		TSM.L["Destroying"] = "Destroying"
		TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
		TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
		TSM.L["Destroying..."] = "Destroying..."
		TSM.L["Details"] = "Details"
		TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
		TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
		TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
		TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
		TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
		TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
		TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
		TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
		TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
		TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
		TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
		TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
		TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
		TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
		TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
		TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
		TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
		TSM.L["Disenchant Search"] = "Disenchant Search"
		TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
		TSM.L["Disenchant Value"] = "Disenchant Value"
		TSM.L["Disenchanting Options"] = "Disenchanting Options"
		TSM.L["Display Operation Names"] = "Display Operation Names"
		TSM.L["Display auctioning values"] = "Display auctioning values"
		TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
		TSM.L["Display crafting cost"] = "Display crafting cost"
		TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
		TSM.L["Display disenchant value"] = "Display disenchant value"
		TSM.L["Display expired auctions"] = "Display expired auctions"
		TSM.L["Display group name"] = "Display group name"
		TSM.L["Display historical price"] = "Display historical price"
		TSM.L["Display market value"] = "Display market value"
		TSM.L["Display mill value"] = "Display mill value"
		TSM.L["Display min buyout"] = "Display min buyout"
		TSM.L["Display prospect value"] = "Display prospect value"
		TSM.L["Display purchase info"] = "Display purchase info"
		TSM.L["Display region historical price"] = "Display region historical price"
		TSM.L["Display region market value avg"] = "Display region market value avg"
		TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
		TSM.L["Display region sale avg"] = "Display region sale avg"
		TSM.L["Display region sale rate"] = "Display region sale rate"
		TSM.L["Display region sold per day"] = "Display region sold per day"
		TSM.L["Display sale info"] = "Display sale info"
		TSM.L["Display sale rate"] = "Display sale rate"
		TSM.L["Display shopping max price"] = "Display shopping max price"
		TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
		TSM.L["Display transform value"] = "Display transform value"
		TSM.L["Display vendor buy price"] = "Display vendor buy price"
		TSM.L["Display vendor sell price"] = "Display vendor sell price"
		TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
		TSM.L["Don't Post Items"] = "Don't Post Items"
		TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
		TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
		TSM.L["Done Canceling"] = "Done Canceling"
		TSM.L["Done Posting"] = "Done Posting"
		TSM.L["Done Scanning"] = "Done Scanning"
		TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
		TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
		TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
		TSM.L["Duplicate"] = "Duplicate"
		TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
		TSM.L["Dust"] = "Dust"
		TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
		TSM.L["ENCHANT"] = "ENCHANT"
		TSM.L["ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."] = "ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."
		TSM.L["ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."] = "ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."
		TSM.L["ERROR: The auction house must be open in order to do a scan."] = "ERROR: The auction house must be open in order to do a scan."
		TSM.L["EXPENSES"] = "EXPENSES"
		TSM.L["EXPIRES"] = "EXPIRES"
		TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
		TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
		TSM.L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
		TSM.L["Empty price string."] = "Empty price string."
		TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
		TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
		TSM.L["Enable buying?"] = "Enable buying?"
		TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
		TSM.L["Enable restock?"] = "Enable restock?"
		TSM.L["Enable selling?"] = "Enable selling?"
		TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
		TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
		TSM.L["Enchant Vellum"] = "Enchant Vellum"
		TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
		TSM.L["Enter Filter"] = "Enter Filter"
		TSM.L["Enter Keyword"] = "Enter Keyword"
		TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
		TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
		TSM.L["Enter player name"] = "Enter player name"
		TSM.L["Essences"] = "Essences"
		TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
		TSM.L["Estimated Cost:"] = "Estimated Cost:"
		TSM.L["Estimated Profit:"] = "Estimated Profit:"
		TSM.L["Estimated deliver time"] = "Estimated deliver time"
		TSM.L["Exact Match Only?"] = "Exact Match Only?"
		TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
		TSM.L["Expand All Groups"] = "Expand All Groups"
		TSM.L["Expenses"] = "Expenses"
		TSM.L["Expirations"] = "Expirations"
		TSM.L["Expired"] = "Expired"
		TSM.L["Expired Auctions"] = "Expired Auctions"
		TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
		TSM.L["Expires"] = "Expires"
		TSM.L["Expiring Mails"] = "Expiring Mails"
		TSM.L["Exploration"] = "Exploration"
		TSM.L["Export"] = "Export"
		TSM.L["Export List"] = "Export List"
		TSM.L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
		TSM.L["Failed Auctions"] = "Failed Auctions"
		TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
		TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
		TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
		TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
		TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
		TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
		TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
		TSM.L["Failed to send profile."] = "Failed to send profile."
		TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
		TSM.L["Favorite Scans"] = "Favorite Scans"
		TSM.L["Favorite Searches"] = "Favorite Searches"
		TSM.L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
		TSM.L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
		TSM.L["Filter Items"] = "Filter Items"
		TSM.L["Filter Shopping"] = "Filter Shopping"
		TSM.L["Filter by Keyword"] = "Filter by Keyword"
		TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
		TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
		TSM.L["Fishing Reel In"] = "Fishing Reel In"
		TSM.L["Forget Character"] = "Forget Character"
		TSM.L["Found auction sound"] = "Found auction sound"
		TSM.L["Friends"] = "Friends"
		TSM.L["From"] = "From"
		TSM.L["Full"] = "Full"
		TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
		TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
		TSM.L["GVault"] = "GVault"
		TSM.L["Garrison"] = "Garrison"
		TSM.L["Gathering"] = "Gathering"
		TSM.L["Gathering Search"] = "Gathering Search"
		TSM.L["General Options"] = "General Options"
		TSM.L["Get from Bank"] = "Get from Bank"
		TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
		TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
		TSM.L["Gold"] = "Gold"
		TSM.L["Gold Earned:"] = "Gold Earned:"
		TSM.L["Gold Spent:"] = "Gold Spent:"
		TSM.L["Great Deals Search"] = "Great Deals Search"
		TSM.L["Group Management"] = "Group Management"
		TSM.L["Group Operations"] = "Group Operations"
		TSM.L["Group Settings"] = "Group Settings"
		TSM.L["Group already exists."] = "Group already exists."
		TSM.L["Grouped Items"] = "Grouped Items"
		TSM.L["Groups"] = "Groups"
		TSM.L["Guild"] = "Guild"
		TSM.L["Guild Bank"] = "Guild Bank"
		TSM.L["Have"] = "Have"
		TSM.L["Have Materials"] = "Have Materials"
		TSM.L["Have Skill Up"] = "Have Skill Up"
		TSM.L["Hide Description"] = "Hide Description"
		TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
		TSM.L["Hide minimap icon"] = "Hide minimap icon"
		TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
		TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
		TSM.L["High Bidder"] = "High Bidder"
		TSM.L["Historical Price"] = "Historical Price"
		TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
		TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
		TSM.L["Hr"] = "Hr"
		TSM.L["Hrs"] = "Hrs"
		TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
		TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
		TSM.L["IMPORT"] = "IMPORT"
		TSM.L["ITEM CLASS"] = "ITEM CLASS"
		TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
		TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
		TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
		TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
		TSM.L["ITEMS"] = "ITEMS"
		TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
		TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
		TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"
		TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
		TSM.L["Ignore Characters"] = "Ignore Characters"
		TSM.L["Ignore Guilds"] = "Ignore Guilds"
		TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
		TSM.L["Ignore item variations?"] = "Ignore item variations?"
		TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
		TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
		TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
		TSM.L["Ignored Items"] = "Ignored Items"
		TSM.L["Import"] = "Import"
		TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
		TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
		TSM.L["Imported Items"] = "Imported Items"
		TSM.L["Inbox Settings"] = "Inbox Settings"
		TSM.L["Include Attached Operations"] = "Include Attached Operations"
		TSM.L["Include operations?"] = "Include operations?"
		TSM.L["Include soulbound items"] = "Include soulbound items"
		TSM.L["Information"] = "Information"
		TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
		TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
		TSM.L["Invalid custom price."] = "Invalid custom price."
		TSM.L["Invalid function."] = "Invalid function."
		TSM.L["Invalid gold value."] = "Invalid gold value."
		TSM.L["Invalid group name."] = "Invalid group name."
		TSM.L["Invalid import string."] = "Invalid import string."
		TSM.L["Invalid item link."] = "Invalid item link."
		TSM.L["Invalid operation name."] = "Invalid operation name."
		TSM.L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
		TSM.L["Invalid parameter to price source."] = "Invalid parameter to price source."
		TSM.L["Invalid player name."] = "Invalid player name."
		TSM.L["Invalid price source in convert."] = "Invalid price source in convert."
		TSM.L["Invalid price source."] = "Invalid price source."
		TSM.L["Invalid search filter"] = "Invalid search filter"
		TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
		TSM.L["Invalid word: '%s'"] = "Invalid word: '%s'"
		TSM.L["Inventory"] = "Inventory"
		TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
		TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
		TSM.L["Inventory Options"] = "Inventory Options"
		TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
		TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
		TSM.L["Item"] = "Item"
		TSM.L["Item Level"] = "Item Level"
		TSM.L["Item Name"] = "Item Name"
		TSM.L["Item Quality"] = "Item Quality"
		TSM.L["Item Value"] = "Item Value"
		TSM.L["Item links may only be used as parameters to price sources."] = "Item links may only be used as parameters to price sources."
		TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
		TSM.L["Items"] = "Items"
		TSM.L["Items in Bags"] = "Items in Bags"
		TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
		TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
		TSM.L["Keep posted:"] = "Keep posted:"
		TSM.L["Keep quantity:"] = "Keep quantity:"
		TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
		TSM.L["Keep this amount:"] = "Keep this amount:"
		TSM.L["Keeping %d."] = "Keeping %d."
		TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
		TSM.L["LAST 30 DAYS"] = "LAST 30 DAYS"
		TSM.L["LAST 7 DAYS"] = "LAST 7 DAYS"
		TSM.L["LIMIT"] = "LIMIT"
		TSM.L["Last 14 Days"] = "Last 14 Days"
		TSM.L["Last 3 Days"] = "Last 3 Days"
		TSM.L["Last 30 Days"] = "Last 30 Days"
		TSM.L["Last 60 Days"] = "Last 60 Days"
		TSM.L["Last 7 Days"] = "Last 7 Days"
		TSM.L["Last Data Update:"] = "Last Data Update:"
		TSM.L["Last Purchased"] = "Last Purchased"
		TSM.L["Last Sold"] = "Last Sold"
		TSM.L["Level Up"] = "Level Up"
		TSM.L["Link to Another Operation"] = "Link to Another Operation"
		TSM.L["List"] = "List"
		TSM.L["List materials in tooltip"] = "List materials in tooltip"
		TSM.L["Loading Mails..."] = "Loading Mails..."
		TSM.L["Loading..."] = "Loading..."
		TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."
		TSM.L["Loop detected in the following custom price:"] = "Loop detected in the following custom price:"
		TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
		TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
		TSM.L["MAX"] = "MAX"
		TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
		TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
		TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
		TSM.L["MOVE"] = "MOVE"
		TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
		TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
		TSM.L["MOVING"] = "MOVING"
		TSM.L["Macro Setup"] = "Macro Setup"
		TSM.L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
		TSM.L["Mail"] = "Mail"
		TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
		TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
		TSM.L["Mail to %s"] = "Mail to %s"
		TSM.L["Mailing"] = "Mailing"
		TSM.L["Mailing Options"] = "Mailing Options"
		TSM.L["Mailing all to %s."] = "Mailing all to %s."
		TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
		TSM.L["Main Settings"] = "Main Settings"
		TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
		TSM.L["Management Options"] = "Management Options"
		TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
		TSM.L["Map Ping"] = "Map Ping"
		TSM.L["Market Value"] = "Market Value"
		TSM.L["Market Value Price Source"] = "Market Value Price Source"
		TSM.L["Market Value Source"] = "Market Value Source"
		TSM.L["Mat Cost"] = "Mat Cost"
		TSM.L["Mat Price"] = "Mat Price"
		TSM.L["Match stack size?"] = "Match stack size?"
		TSM.L["Match whitelisted players"] = "Match whitelisted players"
		TSM.L["Material Name"] = "Material Name"
		TSM.L["Materials"] = "Materials"
		TSM.L["Materials to Gather"] = "Materials to Gather"
		TSM.L["Max Sell Price"] = "Max Sell Price"
		TSM.L["Max Shopping Price"] = "Max Shopping Price"
		TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
		TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
		TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
		TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
		TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
		TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
		TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
		TSM.L["Maximum quantity:"] = "Maximum quantity:"
		TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
		TSM.L["Mill Value"] = "Mill Value"
		TSM.L["Min"] = "Min"
		TSM.L["Min Buyout"] = "Min Buyout"
		TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
		TSM.L["Minimum Days Old"] = "Minimum Days Old"
		TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
		TSM.L["Minimum expires:"] = "Minimum expires:"
		TSM.L["Minimum profit:"] = "Minimum profit:"
		TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
		TSM.L["Misplaced comma"] = "Misplaced comma"
		TSM.L["Missing Materials"] = "Missing Materials"
		TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
		TSM.L["Modifiers:"] = "Modifiers:"
		TSM.L["Money Frame Open"] = "Money Frame Open"
		TSM.L["Money Transfer"] = "Money Transfer"
		TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
		TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
		TSM.L["Move already grouped items?"] = "Move already grouped items?"
		TSM.L["Moving"] = "Moving"
		TSM.L["Multiple Items"] = "Multiple Items"
		TSM.L["My Auctions"] = "My Auctions"
		TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
		TSM.L["NEED MATS"] = "NEED MATS"
		TSM.L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
		TSM.L["NO ITEMS"] = "NO ITEMS"
		TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
		TSM.L["NOT OPEN"] = "NOT OPEN"
		TSM.L["NPC"] = "NPC"
		TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
		TSM.L["New Group"] = "New Group"
		TSM.L["New Operation"] = "New Operation"
		TSM.L["No Attachments"] = "No Attachments"
		TSM.L["No Crafts"] = "No Crafts"
		TSM.L["No Data"] = "No Data"
		TSM.L["No Materials to Gather"] = "No Materials to Gather"
		TSM.L["No Operation Selected"] = "No Operation Selected"
		TSM.L["No Profession Opened"] = "No Profession Opened"
		TSM.L["No Profession Selected"] = "No Profession Selected"
		TSM.L["No Sound"] = "No Sound"
		TSM.L["No group selected"] = "No group selected"
		TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
		TSM.L["No posting."] = "No posting."
		TSM.L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
		TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
		TSM.L["None"] = "None"
		TSM.L["None (Always Show)"] = "None (Always Show)"
		TSM.L["None Selected"] = "None Selected"
		TSM.L["Normal"] = "Normal"
		TSM.L["Not Connected"] = "Not Connected"
		TSM.L["Not Scanned"] = "Not Scanned"
		TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
		TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
		TSM.L["Not canceling."] = "Not canceling."
		TSM.L["Not enough items in bags."] = "Not enough items in bags."
		TSM.L["Nothing to move."] = "Nothing to move."
		TSM.L["Number Owned"] = "Number Owned"
		TSM.L["OPEN"] = "OPEN"
		TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
		TSM.L["Offline"] = "Offline"
		TSM.L["On Cooldown"] = "On Cooldown"
		TSM.L["Only show craftable"] = "Only show craftable"
		TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
		TSM.L["Open Mail"] = "Open Mail"
		TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
		TSM.L["Open Task List"] = "Open Task List"
		TSM.L["Operation"] = "Operation"
		TSM.L["Operations"] = "Operations"
		TSM.L["Other Character"] = "Other Character"
		TSM.L["Other Settings"] = "Other Settings"
		TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
		TSM.L["Override default craft value method?"] = "Override default craft value method?"
		TSM.L["Override parent operations"] = "Override parent operations"
		TSM.L["POST"] = "POST"
		TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
		TSM.L["POST SELECTED"] = "POST SELECTED"
		TSM.L["POSTAGE"] = "POSTAGE"
		TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
		TSM.L["PROFESSION"] = "PROFESSION"
		TSM.L["PROFIT"] = "PROFIT"
		TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
		TSM.L["Parent Items"] = "Parent Items"
		TSM.L["Past 7 Days"] = "Past 7 Days"
		TSM.L["Past Day"] = "Past Day"
		TSM.L["Past Month"] = "Past Month"
		TSM.L["Past Year"] = "Past Year"
		TSM.L["Paste string here"] = "Paste string here"
		TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
		TSM.L["Per Item"] = "Per Item"
		TSM.L["Per Stack"] = "Per Stack"
		TSM.L["Per Unit"] = "Per Unit"
		TSM.L["Player Gold"] = "Player Gold"
		TSM.L["Player Invite Accept"] = "Player Invite Accept"
		TSM.L["Please select a group to export"] = "Please select a group to export"
		TSM.L["Post Scan"] = "Post Scan"
		TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
		TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
		TSM.L["Post at Normal Price"] = "Post at Normal Price"
		TSM.L["Postage"] = "Postage"
		TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
		TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
		TSM.L["Posting"] = "Posting"
		TSM.L["Posting %d / %d"] = "Posting %d / %d"
		TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
		TSM.L["Posting Settings"] = "Posting Settings"
		TSM.L["Posting at normal price."] = "Posting at normal price."
		TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
		TSM.L["Posting at your current price."] = "Posting at your current price."
		TSM.L["Posting disabled."] = "Posting disabled."
		TSM.L["Posts"] = "Posts"
		TSM.L["Potential"] = "Potential"
		TSM.L["Price Per Item"] = "Price Per Item"
		TSM.L["Price Settings"] = "Price Settings"
		TSM.L["Price Variables"] = "Price Variables"
		TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
		TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
		TSM.L["Processing scan results..."] = "Processing scan results..."
		TSM.L["Profession Filters"] = "Profession Filters"
		TSM.L["Profession Info"] = "Profession Info"
		TSM.L["Profession loading..."] = "Profession loading..."
		TSM.L["Professions Used In"] = "Professions Used In"
		TSM.L["Profile changed to '%s'."] = "Profile changed to '%s'."
		TSM.L["Profiles"] = "Profiles"
		TSM.L["Profit"] = "Profit"
		TSM.L["Prospect Value"] = "Prospect Value"
		TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
		TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
		TSM.L["Purchases"] = "Purchases"
		TSM.L["Purchasing Auction"] = "Purchasing Auction"
		TSM.L["QUEUE"] = "QUEUE"
		TSM.L["Qty"] = "Qty"
		TSM.L["Quantity Bought:"] = "Quantity Bought:"
		TSM.L["Quantity Sold:"] = "Quantity Sold:"
		TSM.L["Quantity to move:"] = "Quantity to move:"
		TSM.L["Quest Added"] = "Quest Added"
		TSM.L["Quest Completed"] = "Quest Completed"
		TSM.L["Quest Objectives Complete"] = "Quest Objectives Complete"
		TSM.L["Quick Sell Options"] = "Quick Sell Options"
		TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
		TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
		TSM.L["RECIPIENT"] = "RECIPIENT"
		TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
		TSM.L["REPAIR"] = "REPAIR"
		TSM.L["REPLY"] = "REPLY"
		TSM.L["REPORT SPAM"] = "REPORT SPAM"
		TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
		TSM.L["RESCAN"] = "RESCAN"
		TSM.L["RESET"] = "RESET"
		TSM.L["RESTART"] = "RESTART"
		TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
		TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
		TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
		TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
		TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
		TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
		TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
		TSM.L["Raid Warning"] = "Raid Warning"
		TSM.L["Read More"] = "Read More"
		TSM.L["Ready Check"] = "Ready Check"
		TSM.L["Ready to Cancel"] = "Ready to Cancel"
		TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
		TSM.L["Recent Scans"] = "Recent Scans"
		TSM.L["Recent Searches"] = "Recent Searches"
		TSM.L["Recently Mailed"] = "Recently Mailed"
		TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
		TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
		TSM.L["Region Historical Price"] = "Region Historical Price"
		TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
		TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
		TSM.L["Region Sale Avg"] = "Region Sale Avg"
		TSM.L["Region Sale Rate"] = "Region Sale Rate"
		TSM.L["Reload"] = "Reload"
		TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
		TSM.L["Rename"] = "Rename"
		TSM.L["Rename Profile"] = "Rename Profile"
		TSM.L["Repair Bill"] = "Repair Bill"
		TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
		TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
		TSM.L["Required Level"] = "Required Level"
		TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
		TSM.L["Resale"] = "Resale"
		TSM.L["Reset All"] = "Reset All"
		TSM.L["Reset Filters"] = "Reset Filters"
		TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
		TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
		TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
		TSM.L["Restock Settings"] = "Restock Settings"
		TSM.L["Restock help for %s:"] = "Restock help for %s:"
		TSM.L["Restock quantity:"] = "Restock quantity:"
		TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
		TSM.L["Restocking to %d."] = "Restocking to %d."
		TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
		TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
		TSM.L["Resume Scan"] = "Resume Scan"
		TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
		TSM.L["Revenue"] = "Revenue"
		TSM.L["Round normal price"] = "Round normal price"
		TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
		TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
		TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
		TSM.L["SALE DATA"] = "SALE DATA"
		TSM.L["SALES"] = "SALES"
		TSM.L["SCAN ALL"] = "SCAN ALL"
		TSM.L["SCANNING"] = "SCANNING"
		TSM.L["SELL ALL"] = "SELL ALL"
		TSM.L["SELL BOES"] = "SELL BOES"
		TSM.L["SELL GROUPS"] = "SELL GROUPS"
		TSM.L["SELL TRASH"] = "SELL TRASH"
		TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
		TSM.L["SEND GOLD"] = "SEND GOLD"
		TSM.L["SEND MAIL"] = "SEND MAIL"
		TSM.L["SENDING"] = "SENDING"
		TSM.L["SENDING..."] = "SENDING..."
		TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
		TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
		TSM.L["SKIP"] = "SKIP"
		TSM.L["SOURCE %d"] = "SOURCE %d"
		TSM.L["SOURCES"] = "SOURCES"
		TSM.L["STOP"] = "STOP"
		TSM.L["SUBJECT"] = "SUBJECT"
		TSM.L["Sale"] = "Sale"
		TSM.L["Sale Price"] = "Sale Price"
		TSM.L["Sale Rate"] = "Sale Rate"
		TSM.L["Sales"] = "Sales"
		TSM.L["Sales Summary"] = "Sales Summary"
		TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
		TSM.L["Scan Paused"] = "Scan Paused"
		TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
		TSM.L["Scanning is %d%% complete"] = "Scanning is %d%% complete"
		TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
		TSM.L["Search"] = "Search"
		TSM.L["Search Bags"] = "Search Bags"
		TSM.L["Search Groups"] = "Search Groups"
		TSM.L["Search Inbox"] = "Search Inbox"
		TSM.L["Search Operations"] = "Search Operations"
		TSM.L["Search Patterns"] = "Search Patterns"
		TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
		TSM.L["Search Vendor"] = "Search Vendor"
		TSM.L["Select Action"] = "Select Action"
		TSM.L["Select All Groups"] = "Select All Groups"
		TSM.L["Select All Items"] = "Select All Items"
		TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
		TSM.L["Select Duration"] = "Select Duration"
		TSM.L["Select Items to Add"] = "Select Items to Add"
		TSM.L["Select Items to Remove"] = "Select Items to Remove"
		TSM.L["Select Operation"] = "Select Operation"
		TSM.L["Select a Source"] = "Select a Source"
		TSM.L["Select crafter"] = "Select crafter"
		TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
		TSM.L["Select operation"] = "Select operation"
		TSM.L["Select professions"] = "Select professions"
		TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
		TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
		TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
		TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
		TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
		TSM.L["Selected Groups"] = "Selected Groups"
		TSM.L["Selected Operations"] = "Selected Operations"
		TSM.L["Sell"] = "Sell"
		TSM.L["Sell Options"] = "Sell Options"
		TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
		TSM.L["Sell to Vendor"] = "Sell to Vendor"
		TSM.L["Seller"] = "Seller"
		TSM.L["Selling soulbound items."] = "Selling soulbound items."
		TSM.L["Send"] = "Send"
		TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
		TSM.L["Send Money"] = "Send Money"
		TSM.L["Send Profile"] = "Send Profile"
		TSM.L["Send grouped items individually"] = "Send grouped items individually"
		TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
		TSM.L["Sending %s to %s"] = "Sending %s to %s"
		TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
		TSM.L["Sending Settings"] = "Sending Settings"
		TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
		TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
		TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
		TSM.L["Set Normal Price:"] = "Set Normal Price:"
		TSM.L["Set auction duration to:"] = "Set auction duration to:"
		TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
		TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
		TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
		TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
		TSM.L["Set minimum profit?"] = "Set minimum profit?"
		TSM.L["Set move quantity?"] = "Set move quantity?"
		TSM.L["Set post cap to:"] = "Set post cap to:"
		TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
		TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
		TSM.L["Set stack size?"] = "Set stack size?"
		TSM.L["Setup"] = "Setup"
		TSM.L["Shards"] = "Shards"
		TSM.L["Shopping"] = "Shopping"
		TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
		TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
		TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
		TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
		TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
		TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
		TSM.L["Show Description"] = "Show Description"
		TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
		TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
		TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
		TSM.L["Show material cost"] = "Show material cost"
		TSM.L["Show on Modifier"] = "Show on Modifier"
		TSM.L["Showing %d Mail"] = "Showing %d Mail"
		TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
		TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
		TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
		TSM.L["Simple"] = "Simple"
		TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
		TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
		TSM.L["Slash Commands:"] = "Slash Commands:"
		TSM.L["Sniper"] = "Sniper"
		TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
		TSM.L["Sniper Options"] = "Sniper Options"
		TSM.L["Sniper Settings"] = "Sniper Settings"
		TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
		TSM.L["Sold"] = "Sold"
		TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
		TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
		TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
		TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
		TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
		TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
		TSM.L["Source"] = "Source"
		TSM.L["Sources"] = "Sources"
		TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
		TSM.L["Stack"] = "Stack"
		TSM.L["Stack / Quantity"] = "Stack / Quantity"
		TSM.L["Stack size multiple:"] = "Stack size multiple:"
		TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
		TSM.L["Starting Scan..."] = "Starting Scan..."
		TSM.L["Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."] = "Starting full AH scan. Please note that this scan may cause your game client to lag or crash. This scan generally takes 1-2 minutes."
		TSM.L["Stop Scan"] = "Stop Scan"
		TSM.L["Store operations globally"] = "Store operations globally"
		TSM.L["Subject"] = "Subject"
		TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
		TSM.L["Switch to %s"] = "Switch to %s"
		TSM.L["Switch to WoW UI"] = "Switch to WoW UI"
		TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
		TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
		TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
		TSM.L["Sync Status"] = "Sync Status"
		TSM.L["TAKE ALL"] = "TAKE ALL"
		TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
		TSM.L["TIME FRAME"] = "TIME FRAME"
		TSM.L["TINKER"] = "TINKER"
		TSM.L["TSM Banking"] = "TSM Banking"
		TSM.L["TSM Crafting"] = "TSM Crafting"
		TSM.L["TSM Destroying"] = "TSM Destroying"
		TSM.L["TSM Mailing"] = "TSM Mailing"
		TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
		TSM.L["TSM Vendoring"] = "TSM Vendoring"
		TSM.L["TSM Version Info:"] = "TSM Version Info:"
		TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
		TSM.L["TSM does not have recent AuctionDB data. You can run '/tsm scan' to manually scan the AH."] = "TSM does not have recent AuctionDB data. You can run '/tsm scan' to manually scan the AH."
		TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
		TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
		TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
		TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
		TSM.L["TSM4"] = "TSM4"
		TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
		TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
		TSM.L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
		TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
		TSM.L["TUJ Global Median"] = "TUJ Global Median"
		TSM.L["Take Attachments"] = "Take Attachments"
		TSM.L["Target Character"] = "Target Character"
		TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
		TSM.L["Text (%s)"] = "Text (%s)"
		TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
		TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
		TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
		TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
		TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
		TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
		TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
		TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
		TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
		TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
		TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
		TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
		TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
		TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
		TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
		TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
		TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
		TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
		TSM.L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
		TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
		TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
		TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
		TSM.L["Time"] = "Time"
		TSM.L["Time Format"] = "Time Format"
		TSM.L["Time Frame"] = "Time Frame"
		TSM.L["Tooltip Price Format"] = "Tooltip Price Format"
		TSM.L["Tooltip Settings"] = "Tooltip Settings"
		TSM.L["Top Buyers:"] = "Top Buyers:"
		TSM.L["Top Item:"] = "Top Item:"
		TSM.L["Top Sellers:"] = "Top Sellers:"
		TSM.L["Total"] = "Total"
		TSM.L["Total Gold"] = "Total Gold"
		TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
		TSM.L["Total Gold Earned:"] = "Total Gold Earned:"
		TSM.L["Total Gold Spent:"] = "Total Gold Spent:"
		TSM.L["Total Price"] = "Total Price"
		TSM.L["Total Profit:"] = "Total Profit:"
		TSM.L["Total Value"] = "Total Value"
		TSM.L["Total Value of All Items"] = "Total Value of All Items"
		TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
		TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
		TSM.L["Transform Value"] = "Transform Value"
		TSM.L["Twitter Integration"] = "Twitter Integration"
		TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
		TSM.L["Type"] = "Type"
		TSM.L["Type Something"] = "Type Something"
		TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
		TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
		TSM.L["Unbalanced parentheses."] = "Unbalanced parentheses."
		TSM.L["Undercut amount:"] = "Undercut amount:"
		TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
		TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
		TSM.L["Undercutting competition."] = "Undercutting competition."
		TSM.L["Ungrouped Items"] = "Ungrouped Items"
		TSM.L["Unknown Item"] = "Unknown Item"
		TSM.L["Unwrap Gift"] = "Unwrap Gift"
		TSM.L["Up"] = "Up"
		TSM.L["Up to date"] = "Up to date"
		TSM.L["Updating"] = "Updating"
		TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Usage: /tsm price <ItemLink> <Price String>"
		TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
		TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
		TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
		TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
		TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
		TSM.L["ValueSources"] = "ValueSources"
		TSM.L["Variable Name"] = "Variable Name"
		TSM.L["Vendor"] = "Vendor"
		TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
		TSM.L["Vendor Search"] = "Vendor Search"
		TSM.L["Vendor Sell"] = "Vendor Sell"
		TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
		TSM.L["Vendoring"] = "Vendoring"
		TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
		TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
		TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
		TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
		TSM.L["Warehousing"] = "Warehousing"
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
		TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
		TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
		TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
		TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
		TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
		TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
		TSM.L["When above maximum:"] = "When above maximum:"
		TSM.L["When below minimum:"] = "When below minimum:"
		TSM.L["Whitelist"] = "Whitelist"
		TSM.L["Whitelisted Players"] = "Whitelisted Players"
		TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
		TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
		TSM.L["You cannot use %s as part of this custom price."] = "You cannot use %s as part of this custom price."
		TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
		TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
		TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
		TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
		TSM.L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
		TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
		TSM.L["You've been undercut."] = "You've been undercut."
		TSM.L["Your Buyout"] = "Your Buyout"
		TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
		TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
		TSM.L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
		TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
		TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
		TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
		TSM.L["ilvl"] = "ilvl"
		TSM.L["of"] = "of"
		TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
		TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
		TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
		TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
		TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
	elseif locale == "deDE" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Gruppe:Gruppen; ausgewählt (%d |4Item:Items;)"
TSM.L["%d auctions"] = "%d Auktionen"
TSM.L["%d Groups"] = "%d Gruppen"
TSM.L["%d Items"] = "%d Items"
TSM.L["%d of %d"] = "%d von %d"
TSM.L["%d Operations"] = "%d Operationen"
TSM.L["%d Posted Auctions"] = "%d gelistete Auktionen"
TSM.L["%d Sold Auctions"] = "%d verkaufte Auktionen"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s Taschen, %s Bank, %s AH, %s Post)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s Spieler, %s Twinks, %s Gilde, %s AH)"
TSM.L["%s (%s profit)"] = "%s (%s Gewinn)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
TSM.L["%s ago"] = "vor %s"
TSM.L["%s Crafts"] = "%s Rezepte"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
TSM.L["%s in guild vault"] = "%s im Gildentresor"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s ist ein gültiger eigener Preis, aber %s ist ein ungültiges Item."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s ist ein gültiger eigener Preis, ergibt aber keinen Wert für %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' ist eine ungültige Operation! Die minimale Wiederauffüllungsmenge von %d ist höher als die maximale Wiederauffüllungsmenge von %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s ist kein gültiger eigener Preis und führte zu folgendem Fehler: %s"
--[[Translation missing --]]
TSM.L["%s Operations"] = "%s Operations"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s entfernt."
TSM.L["%s sent you %s"] = "%s hat dir %s gesendet"
TSM.L["%s sent you %s and %s"] = "%s sendet dir %s und %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s hat dir eine Nachnahmegebühr von %s für %s gesendet"
TSM.L["%s sent you a message: %s"] = "%s hat dir eine Nachricht gesendet: %s"
TSM.L["%s total"] = "%s Gesamt"
TSM.L["%sDrag%s to move this button"] = "%sZiehen%s, um diesen Button zu verschieben"
TSM.L["%sLeft-Click%s to open the main window"] = "%sLinksklick%s, um das Hauptfenster zu öffnen"
TSM.L["(%d/500 Characters)"] = "(%d/500 Zeichen)"
TSM.L["(max %d)"] = "(max %d)"
TSM.L["(max 5000)"] = "(max 5000)"
TSM.L["(min %d - max %d)"] = "(%d bis %d)"
TSM.L["(min 0 - max 10000)"] = "(0 bis 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(0 bis 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(0 bis 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(0 bis 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(0.5 bis 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Zeigt diese Hilfeliste an"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - Öffnet das TSM-Hauptfenster."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000WICHTIG:|r Beim letzten Versuch von TSM_Accounting die Daten für diesen Server zu speichern, waren diese zu umfangreich für, woraufhin alte Datenteile automatisch verworfen wurden, um andere zu speichernde Variablen vor Beschädigung zu schützen. Die letzten %s der Einkaufsdaten wurden gerettet."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000WICHTIG:|r Die neuesten, via TSM_Accounting abgerufenen Daten für diesen Realm sind zu groß und können von WoW nicht verarbeitet werden, demzufolge wurden alte Daten teilweise entfernt, um eine Beschädigung der gespeicherten Variablen zu verhindern. Die letzten %s der Verkaufsdaten sind weiterhin verfügbar."
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Linksklick|r, um ein Item für diese Sitzung zu ignorieren. Halte |cffffd839Umschalt|r gedrückt, um es dauerhaft zu ignorieren. In den Vendoring-Einstellungen kann das permanente Ignorieren von Items rückgängig gemacht werden."
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Linksklick|r, um ein Item für diese Sitzung zu ignorieren."
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Umschalt+Linksklick|r, um es dauerhaft zu ignorieren."
TSM.L["1 Group"] = "1 Gruppe"
TSM.L["1 Item"] = "1 Item"
TSM.L["12 hr"] = "12 Std"
TSM.L["24 hr"] = "24 Std"
TSM.L["48 hr"] = "48 Std"
TSM.L["A custom price of %s for %s evaluates to %s."] = "Ein eigener Preis von %s für %s ergibt %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Es ist maximal 1 convert() Funktion erlaubt."
--[[Translation missing --]]
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
--[[Translation missing --]]
TSM.L["A profile with this name already exists."] = "A profile with this name already exists."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "Ein Scan wird bereits durchgeführt. Bitte beende diesen Scan, bevor du einen weiteren startest."
TSM.L["Above max expires."] = "Über max Abläufe."
TSM.L["Above max price. Not posting."] = "Über Maximum. Erstelle keine Auktion."
TSM.L["Above max price. Posting at max price."] = "Über Maximum. Nutze Höchstpreis."
TSM.L["Above max price. Posting at min price."] = "Über Maximum. Nutze Mindestpreis."
TSM.L["Above max price. Posting at normal price."] = "Über Maximum. Nutze Normalpreis."
TSM.L["Accepting these item(s) will cost"] = "Der Kauf dieser Items kostet"
TSM.L["Accepting this item will cost"] = "Der Kauf dieses Items kostet"
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account-Sync entfernt. Bitte entferne den Account-Sync auch auf dem anderen Account."
TSM.L["Account Syncing"] = "Account-Sync"
TSM.L["Accounting"] = "Accounting"
TSM.L["Accounting Tooltips"] = "Accounting-Tooltips"
TSM.L["Activity Type"] = "Aktivitätstyp"
TSM.L["ADD %d ITEMS"] = "%d ITEMS HINZUFÜGEN"
TSM.L["Add / Remove Items"] = "Items hinzufügen / entfernen"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "NEUE EIGENE PREISQUELLE HINZUFÜGEN"
TSM.L["ADD OPERATION"] = "HINZUFÜGEN"
TSM.L["Add Player"] = "Spieler hinzufügen"
TSM.L["Add Subject / Description"] = "Betreff / Beschreibung hinzufügen"
TSM.L["Add Subject / Description (Optional)"] = "Betreff / Beschreibung hinzufügen (optional)"
TSM.L["ADD TO MAIL"] = "ZUR MAIL HINZUFÜGEN"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
TSM.L["Added %s to %s."] = "Die Operation %s wurde zur Gruppe %s hinzugefügt."
TSM.L["Additional error suppressed"] = "Zusätzlicher Fehler unterdrückt"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Lege fest, wie die Gruppen von dieser Operation auktioniert werden sollen."
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Lege fest, wie die Gruppen von dieser Operation abgebrochen werden sollen."
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Lege fest, wie die Gruppen von dieser Operation preislich behandelt werden sollen."
TSM.L["Advanced Item Search"] = "Erweiterte Itemsuche"
TSM.L["Advanced Options"] = "Erweiterte Optionen"
TSM.L["AH"] = "AH"
TSM.L["AH (Crafting)"] = "AH (Herstellen)"
TSM.L["AH (Disenchanting)"] = "AH (Entzaubern)"
TSM.L["AH BUSY"] = "AH BESCHÄFTIGT"
TSM.L["AH Frame Options"] = "Optionen für das AH-Fenster"
TSM.L["Alarm Clock"] = "Wecker"
TSM.L["All Auctions"] = "Alle Auktionen"
TSM.L["All Characters and Guilds"] = "Alle Charaktere und Gilden"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
TSM.L["All Professions"] = "Alle Berufe"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
TSM.L["Allow partial stack?"] = "Teilstapel zulassen?"
TSM.L["Alt Guild Bank"] = "Twink Gildenbank"
TSM.L["Alts"] = "Twinks"
TSM.L["Alts AH"] = "Twinks AH"
TSM.L["Amount"] = "Betrag"
TSM.L["AMOUNT"] = "BETRAG"
TSM.L["Amount of Bag Space to Keep Free"] = "Anzahl der Taschenplätze, die leer bleiben sollen"
TSM.L["APPLY FILTERS"] = "FILTER ANWENDEN"
TSM.L["Apply operation to group:"] = "Operation anwenden auf die Gruppe:"
TSM.L["Are you sure you want to clear old accounting data?"] = "Bist du sicher, dass du alle Accounting-Daten löschen möchtest?"
TSM.L["Are you sure you want to delete this group?"] = "Willst du diese Gruppe wirklich löschen?"
TSM.L["Are you sure you want to delete this operation?"] = "Diese Operation wirklich löschen?"
TSM.L["Are you sure you want to reset all operation settings?"] = "Bist du sicher, dass du alle Operationseinstellungen zurücksetzen möchtest?"
TSM.L["At above max price and not undercut."] = "Zum Höchstpreis aber nicht unterbieten."
TSM.L["At normal price and not undercut."] = "Zum Normalpreis aber nicht unterbieten."
TSM.L["Auction"] = "Auktion"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
TSM.L["AUCTION DETAILS"] = "AUKTIONSDETAILS"
TSM.L["Auction Duration"] = "Auktionslaufzeit"
TSM.L["Auction has been bid on."] = "Auf die Auktion wurde geboten."
TSM.L["Auction House Cut"] = "Auktionshausgebühr"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "Auktionsfenster schließen"
TSM.L["Auction Window Open"] = "Auktionsfenster öffnen"
TSM.L["Auctionator - Auction Value"] = "Auctionator - Auktionswert"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Appraiser"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - Marktwert"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Mindestsofortkauf"
TSM.L["Auctioning"] = "Auctioning"
TSM.L["Auctioning Log"] = "Auctioning-Protokoll"
TSM.L["Auctioning Operation"] = "Auctioning-Operation"
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning-Button 'EINSTELLEN'/'ABBRECHEN'"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "Aukts"
TSM.L["Auto Quest Complete"] = "Auto-Quest abgeschlossen"
TSM.L["Average Earned Per Day:"] = "Durchschnittlich verdient pro Tag:"
TSM.L["Average Prices:"] = "Durchschnittspreise:"
TSM.L["Average Profit Per Day:"] = "Durchschnittlicher Gewinn pro Tag:"
TSM.L["Average Spent Per Day:"] = "Durchschnittliche Ausgaben pro Tag:"
TSM.L["Avg Buy Price"] = "Ø Kaufpreis"
TSM.L["Avg Resale Profit"] = "Ø Wiederverkaufsgewinn"
TSM.L["Avg Sell Price"] = "Ø Verkaufspreis"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
TSM.L["BACK TO LIST"] = "ZURÜCK ZUR LISTE"
TSM.L["Back to List"] = "Zurück zur Liste"
TSM.L["Bag"] = "Tasche"
TSM.L["Bags"] = "Tasche"
TSM.L["Banks"] = "Bank"
TSM.L["Base Group"] = "Basisgruppe"
TSM.L["Base Item"] = "Grund-Item"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Deine aktuell verfügbaren Preisquellen, sortiert nach Modul. Das %sSchlüsselwort|r benutzt man in der Regel in einem Feld mit eigener Preisangabe."
TSM.L["Below custom price:"] = "Unter eigenem Preis:"
TSM.L["Below min price. Posting at max price."] = "Unter Minimum. Nutze Höchstpreis."
TSM.L["Below min price. Posting at min price."] = "Unter Minimum. Nutze Mindestpreis."
TSM.L["Below min price. Posting at normal price."] = "Unter Minimum. Nutze Normalpreis."
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Erstelle Profile mit unterschiedlichen Sets von Gruppen."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
TSM.L["Bid %d / %d"] = "Bieten %d / %d"
TSM.L["Bid (item)"] = "Gebot (Item)"
TSM.L["Bid (stack)"] = "Gebot (Stapel)"
TSM.L["Bid Price"] = "Gebotspreis"
TSM.L["Bid Sniper Paused"] = "Gebot-Sniper pausiert"
TSM.L["Bid Sniper Running"] = "Gebot-Sniper läuft"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
TSM.L["Blacklisted players:"] = "Spieler auf schwarzer Liste:"
TSM.L["Bought"] = "Gekauft"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
TSM.L["Bought %sx%d for %s from %s"] = "%sx%d gekauft für %s von %s"
TSM.L["Bound Actions"] = "Gebundene Aktionen"
TSM.L["BUSY"] = "BESCHÄFTIGT"
TSM.L["BUY"] = "KAUFEN"
TSM.L["Buy"] = "Kaufen"
TSM.L["Buy %d / %d"] = "Kaufe %d / %d"
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Kaufe %d / %d (Bestätige %d / %d)"
TSM.L["Buy from AH"] = "Im AH kaufen"
TSM.L["Buy from Vendor"] = "Vom Händler kaufen"
TSM.L["BUY GROUPS"] = "GRUPPEN KAUFEN"
TSM.L["Buy Options"] = "Kaufoptionen"
TSM.L["BUYBACK ALL"] = "ALLES ZURÜCKKAUFEN"
TSM.L["Buyer/Seller"] = "Käufer/Verkäufer"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
TSM.L["Buyout (item)"] = "Sofortkauf (Item)"
TSM.L["Buyout (stack)"] = "Sofortkauf (Stapel)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
TSM.L["Buyout Price"] = "Sofortkauf"
TSM.L["Buyout Sniper Paused"] = "Sofortkauf-Sniper pausiert"
TSM.L["Buyout Sniper Running"] = "Sofortkauf-Sniper läuft"
TSM.L["BUYS"] = "EINKÄUFE"
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Standardmäßig enthält diese Gruppe alle Items, die keiner Gruppe zugeordnet sind. Du kannst diese Gruppe weder ändern noch löschen."
TSM.L["Cancel auctions with bids"] = "Auktionen mit Geboten abbrechen"
TSM.L["Cancel Scan"] = "Scan abbrechen"
TSM.L["Cancel to repost higher?"] = "Abbrechen, um Auktion mit höherem Preis zu erstellen?"
TSM.L["Cancel undercut auctions?"] = "Unterbotene Auktionen abbrechen?"
TSM.L["Canceling"] = "Abbrechen"
TSM.L["Canceling %d / %d"] = "Abbrechen %d / %d"
TSM.L["Canceling %d Auctions..."] = "Breche %d Auktionen ab..."
TSM.L["Canceling all auctions."] = "Breche alle Auktionen ab."
TSM.L["Canceling auction which you've undercut."] = "Breche Auktionen ab, bei denen du unterboten wurdest."
TSM.L["Canceling disabled."] = "Abbrechen deaktiviert."
TSM.L["Canceling Settings"] = "Abbruchseinstellungen"
TSM.L["Canceling to repost at higher price."] = "Breche ab, um zum höheren Preis zu erstellen."
TSM.L["Canceling to repost at reset price."] = "Abbrechen, um zum Reset-Preis wieder einzustellen."
TSM.L["Canceling to repost higher."] = "Breche ab, um zum höheren Preis zu erstellen."
TSM.L["Canceling undercut auctions and to repost higher."] = "Breche unterbotene Auktionen ab um sie zu einem höheren Preis zu listen."
TSM.L["Canceling undercut auctions."] = "Breche unterbotene Auktionen ab."
TSM.L["Cancelled"] = "Abgebrochen"
TSM.L["Cancelled auction of %sx%d"] = "Abgebrochene Auktion von %sx%d"
TSM.L["Cancelled Since Last Sale"] = "Abgebrochen seit letztem Verkauf"
TSM.L["CANCELS"] = "ABGEBROCHENE"
TSM.L["Cannot repair from the guild bank!"] = "Kann nicht aus der Gildenbank repariert werden!"
TSM.L["Can't load TSM tooltip while in combat"] = "TSM-Tooltip kann während eines Kampfes nicht geladen werden"
TSM.L["Cash Register"] = "Registrierkasse"
TSM.L["CHARACTER"] = "CHARAKTER"
TSM.L["Character"] = "Charakter"
TSM.L["Chat Tab"] = "Chat-Tab"
TSM.L["Cheapest auction below min price."] = "Billigste Auktion unter Mindestpreis."
TSM.L["Clear"] = "Leeren"
TSM.L["Clear All"] = "Alles leeren"
TSM.L["CLEAR DATA"] = "DATEN LÖSCHEN"
TSM.L["Clear Filters"] = "Filter leeren"
TSM.L["Clear Old Data"] = "Alte Daten löschen"
TSM.L["Clear Old Data Confirmation"] = "Löschen alter Daten bestätigen"
TSM.L["Clear Queue"] = "Leeren"
TSM.L["Clear Selection"] = "Auswahl aufheben"
TSM.L["COD"] = "Nachnahme"
TSM.L["Coins (%s)"] = "Münzen (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
TSM.L["Combine Partial Stacks"] = "Geteilte Bündel verbinden"
TSM.L["Combining..."] = "Kombinieren..."
TSM.L["Configuration Scroll Wheel"] = "Mausrad-Konfiguration"
TSM.L["Confirm"] = "Bestätigen"
TSM.L["Confirm Complete Sound"] = "Sound, wenn die Bestätigung fertig ist"
TSM.L["Confirming %d / %d"] = "Bestätige %d / %d"
TSM.L["Connected to %s"] = "Verbunden mit %s ß"
TSM.L["Connecting to %s"] = "Verbinde zu %s"
TSM.L["CONTACTS"] = "KONTAKTE"
TSM.L["Contacts Menu"] = "Kontakte"
TSM.L["Cooldown"] = "Abklingzeit"
TSM.L["Cooldowns"] = "Abklingzeiten"
TSM.L["Cost"] = "Kosten"
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Makro konnte nicht erstellt werden, da du bereits zu viele hast. Lösche ein vorhandenes Makro und versuche es erneut."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Profil '%s' konnte nicht gefunden werden. Mögliche Profile: '%s'"
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Items konnten nicht verkaufen werden, da kein freier Taschenplatz verfügbar ist, um ein Stapel aufzuteilen."
TSM.L["Craft"] = "Herst"
TSM.L["CRAFT"] = "HERSTELLEN"
TSM.L["Craft (Unprofitable)"] = "Herstellen (unprofitabel)"
TSM.L["Craft (When Profitable)"] = "Herstellen (wenn profitabel)"
TSM.L["Craft All"] = "Alle herstellen"
TSM.L["CRAFT ALL"] = "ALLE HERSTELLEN"
TSM.L["Craft Name"] = "Rezeptname"
TSM.L["CRAFT NEXT"] = "NÄCHSTES HERSTELLEN"
TSM.L["Craft value method:"] = "Methode zur Ermittlung des Marktwertes:"
TSM.L["CRAFTER"] = "HERSTELLER"
TSM.L["CRAFTING"] = "HERSTELLEN"
TSM.L["Crafting"] = "Herstellen"
TSM.L["Crafting Cost"] = "Herst Kosten"
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting-Button 'NÄCHTES HERSTELLEN'"
TSM.L["Crafting Queue"] = "Herstellungswarteschlange"
TSM.L["Crafting Tooltips"] = "Herstellungsstooltips"
TSM.L["Crafts"] = "Rezepte"
TSM.L["Crafts %d"] = "Stellt %d her"
TSM.L["CREATE MACRO"] = "MAKRO ERSTELLEN"
TSM.L["Create New Operation"] = "Neue Operation erstellen"
TSM.L["CREATE NEW PROFILE"] = "NEUES PROFIL ERSTELLEN"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "Kristalle"
TSM.L["Current Profiles"] = "Aktuelle Profile"
TSM.L["CURRENT SEARCH"] = "AKTUELLE SUCHE"
TSM.L["CUSTOM POST"] = "EIGENES ERSTELLEN"
TSM.L["Custom Price"] = "Eigener Preis"
TSM.L["Custom Price Source"] = "Eigene Preisquelle"
TSM.L["Custom Sources"] = "Eigene Quellen"
TSM.L["Database Sources"] = "Datenbankquellen"
TSM.L["Default Craft Value Method:"] = "Standardmethode zur Ermittlung des Marktwertes:"
TSM.L["Default Material Cost Method:"] = "Standardmethode für Materialkosten:"
TSM.L["Default Price"] = "Standardpreis"
TSM.L["Default Price Configuration"] = "Konfiguration von Standardpreisen"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
TSM.L["Delete Profile Confirmation"] = "Löschen des Profils bestätigen"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
TSM.L["Deposit"] = "Anzahlung"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
TSM.L["DEPOSIT REAGENTS"] = "REAGENZIEN EINLAGERN"
TSM.L["Deselect All Groups"] = "Alle Gruppen abwählen"
TSM.L["Deselect All Items"] = "Alle Items abwählen"
TSM.L["Destroy Next"] = "Nächstes zerstören"
TSM.L["Destroy Value"] = "Zerstörungswert"
TSM.L["Destroy Value Source"] = "Zerstörungswertquelle"
TSM.L["Destroying"] = "Destroying"
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying-Button 'NÄCHSTES ZERSTÖREN'"
TSM.L["Destroying Tooltips"] = "Destroying-Tooltips"
TSM.L["Destroying..."] = "Zerstören..."
TSM.L["Details"] = "Details"
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Schwellenwert zum Abbrechen einer Auktion, um sie neu zu erstellen (%s), ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Höchstpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Höchstpreis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Mindestpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein normaler Preis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein normaler Preis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht abgebrochen, weil dein Unterbieten (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Die Auktion von %s wurde nicht erstellt, weil Blizzard nicht alle notwendigen Informationen dafür bereitgestellt hat. Versuche es später noch einmal."
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Auktion für %s wurde nicht erstellt, da der Besitzer der günstigsten Auktion (%s) sowohl auf der schwarzen als auch auf der weißen Liste steht, was nicht erlaubt ist. Passe deine Einstellungen an, um dieses Problem zu beheben."
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Auktion für %s wurde nicht erstellt, weil du oder einer deiner Twinks (%s) auf der schwarzen Liste steht, was nicht erlaubt ist. Entferne diesen Charakter aus deiner schwarzen Liste."
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Höchstpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Höchstpreis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Mindestpreis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein normaler Preis (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein normaler Preis (%s) niedriger ist als dein Mindestpreis (%s). Überprüfe deine Einstellungen."
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Die Auktion von %s wurde nicht erstellt, weil dein Unterbieten (%s) ungültig ist. Überprüfe deine Einstellungen."
TSM.L["Disable invalid price warnings"] = "Warnungen über ungültige Preise deaktivieren"
TSM.L["Disenchant Search"] = "Entzauberungssuche"
TSM.L["DISENCHANT SEARCH"] = "ENTZAUBERUNGSSUCHE"
TSM.L["Disenchant Search Options"] = "Optionen für die Entzauberungssuche"
TSM.L["Disenchant Value"] = "Entzauberungswert"
TSM.L["Disenchanting Options"] = "Entzauberungsoptionen"
TSM.L["Display auctioning values"] = "Auctioning-Werte anzeigen"
TSM.L["Display cancelled since last sale"] = "Auktionen anzeigen, die seit dem letzten Verkauf abgebrochen wurden"
TSM.L["Display crafting cost"] = "Herstellungskosten anzeigen"
TSM.L["Display detailed destroy info"] = "Detaillierte Destroying-Informationen anzeigen"
TSM.L["Display disenchant value"] = "Entzauberungswert anzeigen"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
TSM.L["Display group name"] = "Gruppennamen anzeigen"
TSM.L["Display historical price"] = "Historischen Preis anzeigen"
TSM.L["Display market value"] = "Marktwert anzeigen"
TSM.L["Display mill value"] = "Mahlenwert anzeigen"
TSM.L["Display min buyout"] = "Mindestsofortkaufpreis anzeigen"
TSM.L["Display Operation Names"] = "Operationsnamen anzeigen"
TSM.L["Display prospect value"] = "Sondierungswert anzeigen"
TSM.L["Display purchase info"] = "Einkaufsinformationen anzeigen"
TSM.L["Display region historical price"] = "Regionalen historischen Preis anzeigen"
TSM.L["Display region market value avg"] = "Regionalen Durchschnitt des Marktwerts anzeigen"
TSM.L["Display region min buyout avg"] = "Regionalen Durchschnitt des Mindestsofortkaufpreises anzeigen"
TSM.L["Display region sale avg"] = "Regionalen Durchschnitt des Verkaufspreises anzeigen"
TSM.L["Display region sale rate"] = "Regionale Verkaufsrate anzeigen"
TSM.L["Display region sold per day"] = "Regionalen Durchschnitt täglicher Verkäufe anzeigen"
TSM.L["Display sale info"] = "Verkaufsinformationen anzeigen"
TSM.L["Display sale rate"] = "Verkaufsrate anzeigen"
TSM.L["Display shopping max price"] = "Maximalen Einkaufspreis anzeigen"
TSM.L["Display total money recieved in chat?"] = "Gesamtmenge des erhaltenen Goldes im Chat anzeigen?"
TSM.L["Display transform value"] = "Transformierungswert anzeigen"
TSM.L["Display vendor buy price"] = "Händlereinkaufpreis anzeigen"
TSM.L["Display vendor sell price"] = "Händlerverkaufpreis anzeigen"
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Dadurch werden auch alle Untergruppen entfernt, die mit dieser Gruppe verbunden sind."
TSM.L["Done Canceling"] = "Abbrechen abgeschlossen"
TSM.L["Done Posting"] = "Erfolgreich Auktion erstellt"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
TSM.L["Done Scanning"] = "Scannen erledigt"
TSM.L["Don't post after this many expires:"] = "Keine Auktionserstellung nach so vielen abgelaufenen Auktionen:"
TSM.L["Don't Post Items"] = "Keine Items auktionieren"
TSM.L["Don't prompt to record trades"] = "Keine Rückfrage zur Protokollierung von Handelsaktivitäten"
TSM.L["DOWN"] = "Runter"
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Füge weitere Items ein (%d/%d Items)"
TSM.L["Drag Item(s) Into Box"] = "Ziehe Items in dieses Feld"
TSM.L["Duplicate"] = "Kopieren"
TSM.L["Duplicate Profile Confirmation"] = "Profil-Kopie Bestätigen"
TSM.L["Dust"] = "Staub"
TSM.L["Elevate your gold-making!"] = "Beschleunige dein Gold-Einkommen!"
TSM.L["Embed TSM tooltips"] = "TSM-Tooltip in den Standard-Tooltip integrieren"
TSM.L["EMPTY BAGS"] = "TASCHE LEEREN"
TSM.L["Empty parentheses are not allowed"] = "Leere Klammern sind nicht erlaubt"
TSM.L["Empty price string."] = "Leerer Preistext."
TSM.L["Enable automatic stack combination"] = "Automatisches Zusammenführen von Stapeln aktivieren"
TSM.L["Enable buying?"] = "Kaufen aktivieren?"
TSM.L["Enable inbox chat messages"] = "Posteingang-Chatnachrichten aktivieren"
TSM.L["Enable restock?"] = "Wiederauffüllen aktivieren?"
TSM.L["Enable selling?"] = "Verkaufen aktivieren?"
TSM.L["Enable sending chat messages"] = "Senden-Chatnachrichten aktivieren"
TSM.L["Enable TSM Tooltips"] = "TSM-Tooltips aktivieren"
TSM.L["Enable tweet enhancement"] = "Tweet-Erweiterung aktivieren"
TSM.L["Enchant Vellum"] = "Pergament verzaubern"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
TSM.L["Enter a name for the new profile"] = "Trage einen Namen für das neue Profil ein"
TSM.L["Enter Filter"] = "Filter eintragen"
TSM.L["Enter Keyword"] = "Suchbegriff eingeben"
TSM.L["Enter name of logged-in character from other account"] = "Trage den Namen eines anderen angemeldeten Charakters ein"
TSM.L["Enter player name"] = "Spielername eintragen"
TSM.L["Essences"] = "Essenzen"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Verbindung mit %s wird hergestellt. Achte darauf, dass dieser Charaktername im anderen Account angegeben ist."
TSM.L["Estimated Cost:"] = "Geschätzte Kosten:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
TSM.L["Estimated Profit:"] = "Geschätzter Gewinn:"
TSM.L["Exact Match Only?"] = "Nur exakte Übereinstimmung?"
TSM.L["Exclude crafts with cooldowns"] = "Rezepte mit Abklingzeiten ausschließen"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
TSM.L["Expenses"] = "Ausgaben"
TSM.L["EXPENSES"] = "AUSGABEN"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
TSM.L["Expired"] = "Abgelaufen"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
TSM.L["Expired Since Last Sale"] = "Abgelaufen seit letztem Verkauf"
TSM.L["Expires"] = "Läuft ab"
TSM.L["EXPIRES"] = "ABGELAUFENE"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "Erkundung"
TSM.L["Export"] = "Export"
TSM.L["Export List"] = "Exportliste"
TSM.L["Failed Auctions"] = "Gescheiterte Auktionen"
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Fehlgeschlagen seit letztem Verkauf (Abgelaufen/Abgebrochen)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
TSM.L["Failed to bid on auction of %s."] = "Fehler beim Bieten auf Auktion von %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
TSM.L["Failed to buy auction of %s."] = "Fehler beim Kaufen der Auktion von %s."
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Eine Auktion für %s konnte nicht gefunden werden und wurde aus den Ergebnissen entfernt."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
TSM.L["Favorite Scans"] = "Favorisierte Scans"
TSM.L["Favorite Searches"] = "Favorisierte Suchanfragen"
TSM.L["Filter Auctions by Duration"] = "Auktionen anhand ihrer Laufzeit filtern"
TSM.L["Filter Auctions by Keyword"] = "Auktionen nach Suchwort filtern"
TSM.L["Filter by Keyword"] = "Nach Suchwort filtern"
TSM.L["FILTER BY KEYWORD"] = "NACH SUCHWORT FILTERN"
TSM.L["Filter group item lists based on the following price source"] = "Gruppierte Itemlisten anhand folgender Preisquelle filtern:"
TSM.L["Filter Items"] = "Items filtern"
TSM.L["Filter Shopping"] = "Shopping filtern"
TSM.L["Finding Selected Auction"] = "Suche ausgewählte Auktion"
TSM.L["Fishing Reel In"] = "Angelrolle"
TSM.L["Forget Character"] = "Charakter vergessen"
TSM.L["Found auction sound"] = "Sound, wenn eine Auktion gefunden wurde"
TSM.L["Friends"] = "Freunde"
TSM.L["From"] = "Von"
TSM.L["Full"] = "Vollständig"
TSM.L["Garrison"] = "Garnison"
TSM.L["Gathering"] = "Sammeln"
TSM.L["Gathering Search"] = "Sammelsuche"
TSM.L["General Options"] = "Allgemeine Optionen"
TSM.L["Get from Bank"] = "Aus Bank nehmen"
TSM.L["Get from Guild Bank"] = "Aus Gildenbank nehmen"
TSM.L["Global Operation Confirmation"] = "Globale Bestätigung für Operationen"
TSM.L["Gold"] = "Gold"
TSM.L["Gold Earned:"] = "Gold bekommen:"
TSM.L["GOLD ON HAND"] = "VERFÜGBARES GOLD"
TSM.L["Gold Spent:"] = "Gold ausgegeben:"
TSM.L["GREAT DEALS SEARCH"] = "SCHNÄPPCHENSUCHE"
TSM.L["Group already exists."] = "Gruppe besteht bereits."
TSM.L["Group Management"] = "Gruppenverwaltung"
TSM.L["Group Operations"] = "Gruppenoperationen"
TSM.L["Group Settings"] = "Gruppeneinstellungen"
TSM.L["Grouped Items"] = "Gruppierte Items"
TSM.L["Groups"] = "Gruppen"
TSM.L["Guild"] = "Gilde"
TSM.L["Guild Bank"] = "Gildenbank"
TSM.L["GVault"] = "GTresor"
TSM.L["Have"] = "Haben"
TSM.L["Have Materials"] = "Materialien verfügbar"
TSM.L["Have Skill Up"] = "Kann die Berufsstufe erhöhen"
TSM.L["Hide auctions with bids"] = "Auktionen mit Geboten nicht anzeigen"
TSM.L["Hide Description"] = "Beschreibung ausblenden"
TSM.L["Hide minimap icon"] = "Minikartensymbol ausblenden"
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Verberge das TSM Banking Interface. Tippe '/tsm bankui' um es erneut zu öffnen."
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Die TSM Aufgabenliste wird ausgeblendet. Tippe '/tsm tasklist', um sie erneut zu öffnen."
TSM.L["High Bidder"] = "Höchstbietender"
TSM.L["Historical Price"] = "Historischerpreis"
TSM.L["Hold ALT to repair from the guild bank."] = "Halte ALT und auf Kosten der Gildenbank zu reparieren."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
TSM.L["Hr"] = "Std"
TSM.L["Hrs"] = "Std"
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Ich habe soeben [%s]x%d für %s gekauft! %s #TSM4 #warcraft"
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Ich habe soeben [%s] für %s verkauft! %s #TSM4 #warcraft"
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Wenn du einen anderen Spieler nicht unterbieten möchtest, kannst du ihn zu deiner weißen Liste hinzufügen. TSM wird diesen Spieler nicht unterbieten. Hinweis: Wenn ein Spieler aus deiner weißen Liste mit deinem Sofortkaufpreis übereinstimmt, aber ein niedrigeres Gebot aufführt, wird TSM weiterhin davon ausgehen, dass er dich unterbieten will."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Wenn du mehrere Profile mit diesen Operationen eingerichtet hast, wird das Aktivieren dieser Einstellung dazu führen, dass so gut wie alle Operationen des aktuellen Profils unwiderruflich verloren gehen. Willst du wirklich fortfahren?"
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Wenn du die Twitter-Integration von WoW hast, wird TSM einen Share-Link zu den erweiterten Nachrichten beim Verkauf/Einkauf von Auktionen hinzufügen sowie alle URLs mit einem TSM-Link ersetzen."
TSM.L["Ignore Auctions Below Min"] = "Auktionen unter Minimum ignorieren"
TSM.L["Ignore auctions by duration?"] = "Auktionen anhand ihrer Laufzeit ignorieren?"
TSM.L["Ignore Characters"] = "Charaktere ignorieren"
TSM.L["Ignore Guilds"] = "Gilden ignorieren"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
TSM.L["Ignore operation on characters:"] = "Operation ignorieren bei den Charakteren:"
TSM.L["Ignore operation on faction-realms:"] = "Operation ignorieren auf den Fraktionsrealms:"
TSM.L["Ignored Cooldowns"] = "Ignorierte Abklingzeiten"
TSM.L["Ignored Items"] = "Ignorierte Items"
TSM.L["ilvl"] = "ilvl"
TSM.L["Import"] = "Importieren"
TSM.L["IMPORT"] = "IMPORTIEREN"
TSM.L["Import %d Items and %s Operations?"] = "Sollen %d Items und %s Operationen importiert werden?"
TSM.L["Import Groups & Operations"] = "Gruppen & Operationen importieren"
TSM.L["Imported Items"] = "Importierte Items"
TSM.L["Inbox Settings"] = "Posteingang-Einstellungen"
TSM.L["Include Attached Operations"] = "Zugewiesene Operationen einbeziehen"
TSM.L["Include operations?"] = "Operationen einbeziehen?"
TSM.L["Include soulbound items"] = "Seelengebundene Items einbeziehen"
TSM.L["Information"] = "Informationen"
TSM.L["Invalid custom price entered."] = "Ungültiger eigener Preis eingegeben."
TSM.L["Invalid custom price source for %s. %s"] = "Ungültige eigene Preisquelle für %s. %s"
TSM.L["Invalid custom price."] = "Ungültiger eigener Preis."
TSM.L["Invalid function."] = "Ungültige Funktion."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
TSM.L["Invalid group name."] = "Ungültiger Gruppenname."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "Ungültiger Item-Link."
TSM.L["Invalid operation name."] = "Ungültiger Operationsname."
TSM.L["Invalid operator at end of custom price."] = "Ungültiger Operator am Ende des eigenen Preises."
TSM.L["Invalid parameter to price source."] = "Ungültiger Parameter für Preisquelle."
TSM.L["Invalid player name."] = "Ungültiger Spielername."
TSM.L["Invalid price source in convert."] = "Ungültige Preisquelle in Formel."
TSM.L["Invalid price source."] = "Ungültige Preisquelle"
TSM.L["Invalid search filter"] = "Ungültiges Suchwort"
TSM.L["Invalid seller data returned by server."] = "Ungültige Daten zum Verkäufer vom Server gemeldet."
TSM.L["Invalid word: '%s'"] = "Ungültiges Wort: '%s'"
TSM.L["Inventory"] = "Inventar"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
TSM.L["Inventory / Mailing"] = "Inventar / Mailing"
TSM.L["Inventory Options"] = "Inventaroptionen"
TSM.L["Inventory Tooltip Format"] = "Anzeigeformat des Inventars im Tooltip"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "Item"
TSM.L["ITEM CLASS"] = "GEGENSTANDSKLASSE"
TSM.L["Item Level"] = "Item Level"
TSM.L["ITEM LEVEL RANGE"] = "BEREICH DER ITEMSTUFE"
TSM.L["Item links may only be used as parameters to price sources."] = "Item-Links dürfen nur als Parameter für Preisquellen verwendet werden."
TSM.L["Item Name"] = "Name des Items"
TSM.L["Item Quality"] = "Item Qualität"
TSM.L["ITEM SEARCH"] = "ITEM SUCHE"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
TSM.L["ITEM SUBCLASS"] = "GEGENSTAND UNTERKATEGORIE"
TSM.L["Item Value"] = "Item Wert"
TSM.L["Item/Group is invalid (see chat)."] = "Gegenstand/Gruppe ist ungültig (siehe Chat)."
TSM.L["ITEMS"] = "ITEMS"
TSM.L["Items"] = "Items"
TSM.L["Items in Bags"] = "Items in der Tasche"
TSM.L["Keep in bags quantity:"] = "In der Tasche zu behaltene Menge:"
TSM.L["Keep in bank quantity:"] = "In der Bank zu behaltene Menge:"
TSM.L["Keep posted:"] = "Auktionen behalten:"
TSM.L["Keep quantity:"] = "Anzahl behalten:"
TSM.L["Keep this amount in bags:"] = "Diese Anzahl in den Taschen behalten:"
TSM.L["Keep this amount:"] = "Diese Anzahl behalten:"
TSM.L["Keeping %d."] = "Behalte %d."
TSM.L["Keeping undercut auctions posted."] = "Behalte unterbotene Auktionen."
TSM.L["Last 14 Days"] = "Letzten 14 Tage"
TSM.L["Last 3 Days"] = "Letzten 3 Tage"
TSM.L["Last 30 Days"] = "Letzten 30 Tage"
TSM.L["LAST 30 DAYS"] = "LETZTEN 30 TAGE"
TSM.L["Last 60 Days"] = "Letzten 60 Tage"
TSM.L["Last 7 Days"] = "Letzten 7 Tage"
TSM.L["LAST 7 DAYS"] = "LETZTEN 7 TAGE"
TSM.L["Last Data Update:"] = "Letztes Datenupdate:"
TSM.L["Last Purchased"] = "Letzter Einkauf"
TSM.L["Last Sold"] = "Letzter Verkauf"
TSM.L["Level Up"] = "Stufe aufgestiegen"
TSM.L["LIMIT"] = "LIMIT"
TSM.L["Link to Another Operation"] = "Verbinde mit einer anderen Operation"
TSM.L["List"] = "Liste"
TSM.L["List materials in tooltip"] = "Materialien im Tooltip auflisten"
TSM.L["Loading Mails..."] = "Lade Mails..."
TSM.L["Loading..."] = "Laden..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Es scheint so, als wäre TradeSkillMaster auf einen Fehler gestoßen. Du kannst dem Autor dabei helfen, diesen Fehler zu beheben, indem du die folgenden Anweisungen befolgst."
TSM.L["Loop detected in the following custom price:"] = "Schleife im folgenden eigenen Preis entdeckt:"
TSM.L["Lowest auction by whitelisted player."] = "Günstigste Auktion von Spieler aus weißer Liste."
TSM.L["Macro created and scroll wheel bound!"] = "Makro erstellt und mit Mausrad verbunden!"
TSM.L["Macro Setup"] = "Makro-Setup"
TSM.L["Mail"] = "Briefk"
TSM.L["Mail Disenchantables"] = "Entzauberbare Items versenden"
TSM.L["Mail Disenchantables Max Quality"] = "Entzauberbare Items versenden mit maximaler Qualität:"
TSM.L["MAIL SELECTED GROUPS"] = "AN AUSGEWÄHLTE GRUPPEN SENDEN"
TSM.L["Mail to %s"] = "Post an %s"
TSM.L["Mailing"] = "Mailing"
TSM.L["Mailing all to %s."] = "Sende alles an %s."
TSM.L["Mailing Options"] = "Mailing-Optionen"
TSM.L["Mailing up to %d to %s."] = "Sende bis zu %d an %s."
TSM.L["Main Settings"] = "Grundeinstellungen"
TSM.L["Make Cash On Delivery?"] = "Mit Nachnahmegebühr?"
TSM.L["Management Options"] = "Verwaltungsoptionen"
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Viele häufig verwendete Aktionen in TSM können in ein Makro umgewandelt und an dein Mausrad gebunden werden. Benutze dazu die folgenden Optionen."
TSM.L["Map Ping"] = "Klick auf Minimap"
TSM.L["Market Value"] = "Marktwert"
TSM.L["Market Value Price Source"] = "Marktwert-Preisquelle"
TSM.L["Market Value Source"] = "Marktwertquelle"
TSM.L["Mat Cost"] = "Mat Kosten"
TSM.L["Mat Price"] = "Mat Preis"
TSM.L["Match stack size?"] = "Nur mit Angeboten gleicher Stackgröße konkurrieren?"
TSM.L["Match whitelisted players"] = "Spieler aus der weißen Liste überprüfen"
TSM.L["Material Name"] = "Materialname"
TSM.L["Materials"] = "Materialien"
TSM.L["Materials to Gather"] = "Zu sammelnde Materialien"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
TSM.L["MAX EXPIRES TO BANK"] = "MAX ABLÄUFE ZUR BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
TSM.L["Max Shopping Price"] = "Maximaler Einkaufspreis"
TSM.L["Maximum amount already posted."] = "Maximale Anzahl von Auktionen bereits erstellt."
TSM.L["Maximum Auction Price (Per Item)"] = "Maximaler Auktionspreis (pro Item)"
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximaler Zerstörungswert (Trage '0c' ein, um es zu deaktivieren)"
TSM.L["Maximum disenchant level:"] = "Maximale Entzauberungsstufe:"
TSM.L["Maximum Disenchant Quality"] = "Maximale Entzauberungsqualität:"
TSM.L["Maximum disenchant search percentage:"] = "Maximaler Prozentsatz der Entzauberungssuche:"
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximaler Marktwert (Trage '0c' ein, um es zu deaktivieren)"
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMALMENGE ZUM KAUFEN:"
TSM.L["Maximum quantity:"] = "Maximale Menge:"
TSM.L["Maximum restock quantity:"] = "Maximale Wiederauffüllungsmenge:"
TSM.L["Mill Value"] = "Mahlenwert"
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
TSM.L["Min Buyout"] = "Min Sofortkaufpreis"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Preise"
TSM.L["Minimum Days Old"] = "Mindestens folgende Tage alt"
TSM.L["Minimum disenchant level:"] = "Minimale Entzauberungsstufe:"
TSM.L["Minimum expires:"] = "Minimum abgelaufene Items:"
TSM.L["Minimum profit:"] = "Mindestgewinn"
TSM.L["MINIMUM RARITY"] = "MINIMALE RARITÄT"
TSM.L["Minimum restock quantity:"] = "Minimale Wiederauffüllungsmenge:"
TSM.L["Misplaced comma"] = "Falsch gesetztes Komma"
TSM.L["Missing Materials"] = "Fehlende Materialien"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "Modifikatoren:"
TSM.L["Money Frame Open"] = "Geldfenster öffnen"
TSM.L["Money Transfer"] = "Geldtransfer"
TSM.L["Most Profitable Item:"] = "Ertragreichstes Item:"
TSM.L["MOVE"] = "BEWEGEN"
TSM.L["Move already grouped items?"] = "Bereits gruppierte Items verschieben?"
TSM.L["Move Quantity Settings"] = "Einstellungen für das Verschieben von Mengen"
TSM.L["MOVE TO BAGS"] = "IN TASCHE SCHIEBEN"
TSM.L["MOVE TO BANK"] = "IN BANK SCHIEBEN"
TSM.L["MOVING"] = "BEWEGEN"
TSM.L["Moving"] = "Bewegen"
TSM.L["Multiple Items"] = "Mehrere Gegenstände"
TSM.L["My Auctions"] = "Meine Auktionen"
TSM.L["My Auctions 'CANCEL' Button"] = "Meine Auktionen-Button 'ABBRECHEN'"
TSM.L["Neat Stacks only?"] = "Nur gleichmäßige Stapel?"
TSM.L["NEED MATS"] = "KEINE MATS"
TSM.L["New Group"] = "Neue Gruppe"
TSM.L["New Operation"] = "Neue Operation"
TSM.L["NEWS AND INFORMATION"] = "NEWS UND INFORMATIONEN"
TSM.L["No Attachments"] = "Keine Anhänge"
TSM.L["No Crafts"] = "Keine Rezepte"
TSM.L["No Data"] = "Keine Daten"
TSM.L["No group selected"] = "Keine Gruppe ausgewählt"
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Kein Gegenstand spezifiziert. Nutze: /tsm restock_help [ITEM_LINK]"
TSM.L["NO ITEMS"] = "KEINE ITEMS"
TSM.L["No Materials to Gather"] = "Keine zu sammelnden Materialien"
TSM.L["No Operation Selected"] = "Keine Operation ausgewählt"
TSM.L["No posting."] = "Keine Auktion erstellen."
TSM.L["No Profession Opened"] = "Keinen Beruf geöffnet"
TSM.L["No Profession Selected"] = "Keinen Beruf ausgewählt"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Kein Profil angegeben. Mögliche Profile: '%s'"
TSM.L["No recent AuctionDB scan data found."] = "Keine aktuellen AuctionDB Scan-Daten gefunden."
TSM.L["No Sound"] = "Kein Sound"
TSM.L["None"] = "Nichts"
TSM.L["None (Always Show)"] = "Keine (immer zeigen)"
TSM.L["None Selected"] = "Nichts ausgewählt"
TSM.L["NONGROUP TO BANK"] = "NICHT-GRUPPIERT ZUR BANK"
TSM.L["Normal"] = "Normal"
TSM.L["Not canceling auction at reset price."] = "Wird nicht abgebrochen, Auktion bei Reset-Preis."
TSM.L["Not canceling auction below min price."] = "Wird nicht abgebrochen, Auktion unter Mindestpreis."
TSM.L["Not canceling."] = "Wird nicht abgebrochen."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
TSM.L["Not enough items in bags."] = "Nicht genügend Gegenstände in den Taschen."
TSM.L["NOT OPEN"] = "AUFSUCHEN"
TSM.L["Not Scanned"] = "Nicht gescannt"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
TSM.L["NPC"] = "NPC"
TSM.L["Number Owned"] = "Anzahl in Besitz"
TSM.L["of"] = "von"
TSM.L["Offline"] = "Offline"
TSM.L["On Cooldown"] = "Auf Abklingzeit"
TSM.L["Only show craftable"] = "Nur herstellbare Items"
TSM.L["Only show items with disenchant value above custom price"] = "Nur Items mit einem Entzauberungswert über dem eigenen Preis anzeigen"
TSM.L["OPEN"] = "ÖFFNEN"
TSM.L["OPEN ALL MAIL"] = "ALLE MAILS ÖFFNEN"
TSM.L["Open Mail"] = "Mail öffnen"
TSM.L["Open Mail Complete Sound"] = "Sound, wenn das Öffnen der Mails fertig ist"
TSM.L["Open Task List"] = "Aufgabenliste öffnen"
TSM.L["Operation"] = "Operation"
TSM.L["Operations"] = "Operationen"
TSM.L["Other Character"] = "Anderer Charakter"
TSM.L["Other Settings"] = "Sonstige Einstellungen"
TSM.L["Other Shopping Searches"] = "Sonstige Suchfunktionen"
TSM.L["Override default craft value method?"] = "Die Standardmethode zur Ermittlung des Marktwertes überschreiben?"
TSM.L["Override parent operations"] = "Übergeordnete Operationen überschreiben"
TSM.L["Parent Items"] = "Übergeordnete Gegenstände"
TSM.L["Past 7 Days"] = "Letzen 7 Tage"
TSM.L["Past Day"] = "Letzter Tag"
TSM.L["Past Month"] = "Letzter Monat"
TSM.L["Past Year"] = "Letztes Jahr"
TSM.L["Paste string here"] = "Zeichenfolge hier einfügen"
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Füge deine Import-Zeichenfolge in das Feld unten ein und klicke auf 'IMPORTIEREN'. Du kannst alles importieren, von komma-getrennten Itemlisten bis hin zu ganzen Gruppen & Operationen."
TSM.L["Per Item"] = "Pro Item"
TSM.L["Per Stack"] = "Pro Stapel"
TSM.L["Per Unit"] = "Pro EInheit"
TSM.L["Player Gold"] = "Spielergold"
TSM.L["Player Invite Accept"] = "Spielereinladung akzeptieren"
TSM.L["Please select a group to export"] = "Bitte eine Gruppe für den Export auswählen"
TSM.L["POST"] = "EINSTELLEN"
TSM.L["Post at Maximum Price"] = "Zum Höchstpreis erstellen"
TSM.L["Post at Minimum Price"] = "Zum Mindestpreis erstellen"
TSM.L["Post at Normal Price"] = "Zum Normalpreis erstellen"
TSM.L["POST CAP TO BAGS"] = "HÖCHSTMENGE IN TASCHE SCHIEBEN"
TSM.L["Post Scan"] = "Einstellungsscan"
TSM.L["POST SELECTED"] = "AUSGEWÄHLTES EINSTELLEN"
TSM.L["POSTAGE"] = "VERSANDKOSTEN"
TSM.L["Postage"] = "Versandkosten"
TSM.L["Posted at whitelisted player's price."] = "Zum Preis des Spielers aus weißer Liste gelistet."
TSM.L["Posted Auctions %s:"] = "Gelistete Auktionen %s:"
TSM.L["Posting"] = "Auktionserstellung"
TSM.L["Posting %d / %d"] = "Erstelle Auktion %d / %d"
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Erstelle %d Stapel von %d für %d Stunden."
TSM.L["Posting at normal price."] = "Erstelle zum Normalpreis."
TSM.L["Posting at whitelisted player's price."] = "Erstelle zum Preis des Spielers aus der weißen Liste."
TSM.L["Posting at your current price."] = "Erstelle zu deinem aktuellen Preis."
TSM.L["Posting disabled."] = "Auktion erstellen deaktiviert."
TSM.L["Posting Settings"] = "Einstellungen für Auktionserstellungen"
TSM.L["Posts"] = "Angebote"
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
TSM.L["Price Settings"] = "Einstellungen für Preise"
TSM.L["PRICE SOURCE"] = "PREISQUELLE"
TSM.L["Price source with name '%s' already exists."] = "Die Preisquelle mit dem Namen '%s' existiert bereits."
TSM.L["Price Variables"] = "Preisvariablen"
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Preisvariablen ermöglichen es dir, anspruchsvollere eigene Preise innerhalb des Addons zu erstellen. Du kannst diese neuen Variablen auf die gleiche Weise wie die internen Preisquellen wie z. B. 'vendorsell' und 'vendorbuy' verwenden."
TSM.L["PROFESSION"] = "BERUF"
TSM.L["Profession Filters"] = "Berufsfilter"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
TSM.L["Profession loading..."] = "Lade Beruf..."
TSM.L["Professions Used In"] = "Relevant für die Berufe"
TSM.L["Profile changed to '%s'."] = "Profil wurde auf '%s' geändert."
TSM.L["Profiles"] = "Profile"
TSM.L["PROFIT"] = "GEWINN"
TSM.L["Profit"] = "Gewinn"
TSM.L["Prospect Value"] = "Sondierungswert"
TSM.L["PURCHASE DATA"] = "KAUFDATEN"
TSM.L["Purchased (Min/Avg/Max Price)"] = "Gekauft (Min/Ø/Max Preis)"
TSM.L["Purchased (Total Price)"] = "Gekauft (Gesamtpreis)"
TSM.L["Purchases"] = "Einkäufe"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
TSM.L["Qty"] = "Anz"
TSM.L["Quantity Bought:"] = "Anzahl gekauft:"
TSM.L["Quantity Sold:"] = "Anzahl verkauft:"
TSM.L["Quantity to move:"] = "Anzahl zum bewegen:"
TSM.L["Quest Added"] = "Quest hinzugefügt"
TSM.L["Quest Completed"] = "Quest abgeschlossen"
TSM.L["Quest Objectives Complete"] = "Questziel erreicht"
TSM.L["QUEUE"] = "EINREIHEN"
TSM.L["Quick Sell Options"] = "Schnellverkauf-Optionen"
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Überschuss an entzauberbaren Items an Charakter senden"
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Goldüberschuss (begrenzt auf eine bestimmte Menge) an Charakter senden"
TSM.L["Raid Warning"] = "Schlachtzugwarnung"
TSM.L["Read More"] = "Mehr lesen"
TSM.L["Ready Check"] = "Bereitschaftscheck"
TSM.L["Ready to Cancel"] = "Bereit zum Abbrechen"
TSM.L["Realm Data Tooltips"] = "Realm-Daten-Tooltips"
TSM.L["Recent Scans"] = "Scanverlauf"
TSM.L["Recent Searches"] = "Suchverlauf"
TSM.L["Recently Mailed"] = "Kürzlich kontaktiert"
TSM.L["RECIPIENT"] = "EMPFÄNGER"
TSM.L["Region Avg Daily Sold"] = "Regionaler Ø täglicher Verkäufe"
TSM.L["Region Data Tooltips"] = "Regional-Daten-Tooltips"
TSM.L["Region Historical Price"] = "Regionaler historischer Preis"
TSM.L["Region Market Value Avg"] = "Regionaler Marktwert Ø"
TSM.L["Region Min Buyout Avg"] = "Regionaler Min Sofortkauf Ø"
TSM.L["Region Sale Avg"] = "Regionaler Verkaufs Ø"
TSM.L["Region Sale Rate"] = "Regionale Verkaufsrate"
TSM.L["Reload"] = "Neuladen"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
TSM.L["Removed a total of %s old records."] = "Es wurden insgesamt %s alte Daten entfernt."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
TSM.L["REPAIR"] = "REPARIEREN"
TSM.L["Repair Bill"] = "Reparaturrechnung"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
TSM.L["REPLY"] = "ANTWORTEN"
TSM.L["REPORT SPAM"] = "SPAM MELDEN"
TSM.L["Repost Higher Threshold"] = "Erneute Auktionen mit höherem Schwellenwert erstellen:"
TSM.L["Required Level"] = "Erforderliche Stufe"
TSM.L["REQUIRED LEVEL RANGE"] = "ERFORDERLICHER STUFENBEREICH"
TSM.L["Requires TSM Desktop Application"] = "Benötigt TSM Desktop Application"
TSM.L["Resale"] = "Wiederverkauf"
TSM.L["RESCAN"] = "NEU SCANNEN"
TSM.L["RESET"] = "ZURÜCKSETZEN"
TSM.L["Reset All"] = "Leeren"
TSM.L["Reset Filters"] = "Filter leeren"
TSM.L["Reset Profile Confirmation"] = "Bestätigung zum Zurücksetzen des Profils"
TSM.L["RESTART"] = "NEU STARTEN"
TSM.L["Restart Delay (minutes)"] = "Neustartverzögerung (Minuten)"
TSM.L["RESTOCK BAGS"] = "TASCHE NEU AUFFÜLLEN"
TSM.L["Restock help for %s:"] = "Wiederauffüllungshilfe für %s:"
TSM.L["Restock Quantity Settings"] = "Einstellungen für die Wiederauffüllungsmenge"
TSM.L["Restock quantity:"] = "Wiederauffüllungsmenge:"
TSM.L["RESTOCK SELECTED GROUPS"] = "GEWÄHLTE GRUPPEN NEU AUFFÜLLEN"
TSM.L["Restock Settings"] = "Einstellungen für die Wiederauffüllung"
TSM.L["Restock target to max quantity?"] = "Bis zur Höchstmenge wieder auffüllen?"
TSM.L["Restocking to %d."] = "Fülle auf %d wieder auf."
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Fülle bis zu %d (min. auf %d) mit einem Mindestgewinn wieder auf."
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Fülle bis zu %d (min. auf %d) ohne Mindestgewinn wieder auf."
TSM.L["RESTORE BAGS"] = "TASCHE WIEDERHERSTELLEN"
TSM.L["Resume Scan"] = "Scan fortführen"
TSM.L["Retrying %d auction(s) which failed."] = "Wiederhole %d gescheiterte Auktion(en)."
TSM.L["Revenue"] = "Einnahmen"
TSM.L["Round normal price"] = "Normalen Preis runden"
TSM.L["RUN ADVANCED ITEM SEARCH"] = "ERWEITERTE GEGENSTANDSUCHE AUSFÜHREN"
TSM.L["Run Bid Sniper"] = "Gebot-Sniper starten"
TSM.L["Run Buyout Sniper"] = "Sofortkauf-Sniper starten"
TSM.L["RUN CANCEL SCAN"] = "Starte Abbruchsscan"
TSM.L["RUN POST SCAN"] = "Starte Einstellungsscan"
TSM.L["RUN SHOPPING SCAN"] = "STARTE KAUFSUCHE"
TSM.L["Running Sniper Scan"] = "Sniper-Scan läuft"
TSM.L["Sale"] = "Verkauf"
TSM.L["SALE DATA"] = "VERKAUFSDATEN"
TSM.L["Sale Price"] = "Verkaufspreis"
TSM.L["Sale Rate"] = "Verkaufsrate"
TSM.L["Sales"] = "Umsatz"
TSM.L["SALES"] = "VERKÄUFE"
TSM.L["Sales Summary"] = "Verkaufszusammenfassung"
TSM.L["SCAN ALL"] = "ALLE SCANNEN"
TSM.L["Scan Complete Sound"] = "Sound, wenn der Scan fertig ist"
TSM.L["Scan Paused"] = "Scan pausiert"
TSM.L["SCANNING"] = "SCANNEN"
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanne %d / %d (Seite %d / %d)"
TSM.L["Scroll wheel direction:"] = "Richtung des Mausrades:"
TSM.L["Search"] = "Suche"
TSM.L["Search Bags"] = "Taschen durchsuchen"
TSM.L["Search Groups"] = "Gruppen durchsuchen"
TSM.L["Search Inbox"] = "Posteingang durchsuchen"
TSM.L["Search Operations"] = "Operationen durchsuchen"
TSM.L["Search Patterns"] = "Rezepte durchsuchen"
TSM.L["Search Usable Items Only?"] = "Nur benutzbare Gegenstände suchen?"
TSM.L["Search Vendor"] = "Händlersuche"
TSM.L["Select a Source"] = "Wähle eine Quelle"
TSM.L["Select Action"] = "Aktion auswählen"
TSM.L["Select All Groups"] = "Alle Gruppen auswählen"
TSM.L["Select All Items"] = "Alle Items auswählen"
TSM.L["Select Auction to Cancel"] = "Wähle eine Auktion zum abbrechen"
TSM.L["Select crafter"] = "Handwerker auswählen"
TSM.L["Select custom price sources to include in item tooltips"] = "Wähle eigene Preisquellen aus, um diese in den Tooltips der Items zu integrieren"
TSM.L["Select Duration"] = "Laufzeit auswählen"
TSM.L["Select Items to Add"] = "Wähle Items zum Hinzufügen aus"
TSM.L["Select Items to Remove"] = "Wähle Items zum Entfernen aus"
TSM.L["Select Operation"] = "Operation auswählen"
TSM.L["Select professions"] = "Berufe auswählen"
TSM.L["Select which accounting information to display in item tooltips."] = "Lege fest, welche Accounting-Informationen im Tooltip eines Items angezeigt werden sollen."
TSM.L["Select which auctioning information to display in item tooltips."] = "Lege fest, welche Auctioning-Informationen im Tooltip eines Items angezeigt werden sollen."
TSM.L["Select which crafting information to display in item tooltips."] = "Lege fest, welche Herstellungsinformationen im Tooltip eines Items angezeigt werden sollen."
TSM.L["Select which destroying information to display in item tooltips."] = "Lege fest, welche Destroying-Informationen im Tooltip eines Items angezeigt werden sollen."
TSM.L["Select which shopping information to display in item tooltips."] = "Lege fest, welche Shopping-Informationen im Tooltip eines Items angezeigt werden sollen."
TSM.L["Selected Groups"] = "Ausgewählte Gruppen"
TSM.L["Selected Operations"] = "Ausgewählte Operationen"
TSM.L["Sell"] = "Verkaufen"
TSM.L["SELL ALL"] = "ALLES VERKAUFEN"
TSM.L["SELL BOES"] = "Verkaufe BOES"
TSM.L["SELL GROUPS"] = "GRUPPEN VERKAUFEN"
TSM.L["Sell Options"] = "Verkaufs Optionen"
TSM.L["Sell soulbound items?"] = "Seelengebundene Items verkaufen?"
TSM.L["Sell to Vendor"] = "An Händler verkaufen"
TSM.L["SELL TRASH"] = "MÜLL VERKAUFEN"
TSM.L["Seller"] = "Verkäufer"
TSM.L["Selling soulbound items."] = "Verkaufe seelengebundene Items."
TSM.L["Send"] = "Senden"
TSM.L["SEND DISENCHANTABLES"] = "ENTZAUBERBARE ITEMS SENDEN"
TSM.L["Send Excess Gold to Banker"] = "Goldüberschuss an Banker senden"
TSM.L["SEND GOLD"] = "GOLD SENDEN"
TSM.L["Send grouped items individually"] = "Gruppierte Items einzeln versenden"
TSM.L["SEND MAIL"] = "MAIL SENDEN"
TSM.L["Send Money"] = "Gold senden"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
TSM.L["SENDING"] = "SENDEN"
TSM.L["Sending %s individually to %s"] = "Sende %s einzeln an %s"
TSM.L["Sending %s to %s"] = "Sende %s an %s"
TSM.L["Sending %s to %s with a COD of %s"] = "Sende %s an %s mit einer Nachnahmegebühr von %s"
TSM.L["Sending Settings"] = "Senden-Einstellungen"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
TSM.L["SENDING..."] = "SENDEN..."
TSM.L["Set auction duration to:"] = "Voreingestellte Auktionslaufzeit wählen"
TSM.L["Set bid as percentage of buyout:"] = "Gebot als Prozentsatz des Sofortkaufpreises:"
TSM.L["Set keep in bags quantity?"] = "In der Tasche zu behaltene Menge setzen?"
TSM.L["Set keep in bank quantity?"] = "In der Bank zu behaltene Menge setzen?"
TSM.L["Set Maximum Price:"] = "Höchstpreis setzen:"
TSM.L["Set maximum quantity?"] = "Maximale Menge setzen?"
TSM.L["Set Minimum Price:"] = "Mindestpreis setzen:"
TSM.L["Set minimum profit?"] = "Mindestgewinn setzen?"
TSM.L["Set move quantity?"] = "Zu verschiebende Menge setzen?"
TSM.L["Set Normal Price:"] = "Normalpreis setzen:"
TSM.L["Set post cap to:"] = "Maximale Auktionserstellungen:"
TSM.L["Set posted stack size to:"] = "Stapelgröße des Angebots setzen auf:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
TSM.L["Setup"] = "Setup"
TSM.L["SETUP ACCOUNT SYNC"] = "ACCOUNT SYNC EINSTELLEN"
TSM.L["Shards"] = "Splitter"
TSM.L["Shopping"] = "Shopping"
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping-Button 'SOFORTKAUF'"
TSM.L["Shopping for auctions including those above the max price."] = "Kaufe Auktionen ein, einschließlich solcher über dem Höchstpreis."
TSM.L["Shopping for auctions with a max price set."] = "Kaufe Auktionen mit einem festgelegten Höchstpreis ein."
TSM.L["Shopping for even stacks including those above the max price"] = "Kaufe gleichmäßige Stapel ein, einschließlich solcher über dem Höchstpreis."
TSM.L["Shopping for even stacks with a max price set."] = "Kaufe gleichmäßige Stapel mit einem festgelegten Höchstpreis ein."
TSM.L["Shopping Tooltips"] = "Shopping-Tooltips"
TSM.L["SHORTFALL TO BAGS"] = "FEHLMENGE ZUR TASCHE"
TSM.L["Show auctions above max price?"] = "Auktionen über dem Höchstpreis anzeigen?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
TSM.L["Show Description"] = "Zeige Beschreibung"
TSM.L["Show Destroying frame automatically"] = "Destroying-Fenster automatisch anzeigen"
TSM.L["Show material cost"] = "Materialkosten anzeigen"
TSM.L["Show on Modifier"] = "Beim Drücken folgender Zusatztaste anzeigen"
TSM.L["Showing %d Mail"] = "Zeige %d Sendung an"
TSM.L["Showing %d of %d Mail"] = "Zeige %d von %d Post"
TSM.L["Showing %d of %d Mails"] = "Zeige %d von %d Mails an"
TSM.L["Showing all %d Mails"] = "Zeige alle %d Mails an"
TSM.L["Simple"] = "Einfach"
TSM.L["SKIP"] = "NÄCHSTE"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
TSM.L["Skipped: No assigned operation"] = "Übersprungen: Keine Operation zugewiesen"
TSM.L["Slash Commands:"] = "Slash-Befehle:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper-Button 'SOFORTKAUF'"
TSM.L["Sniper Options"] = "Sniper-Optionen"
TSM.L["Sniper Settings"] = "Sniper-Einstellungen"
TSM.L["Sniping items below a max price"] = "Suche gezielt Items unter einem Höchstpreis"
TSM.L["Sold"] = "Verkauft"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
TSM.L["Sold %s worth of items."] = "Items im Wert von %s verkauft."
TSM.L["Sold (Min/Avg/Max Price)"] = "Verkauft (Min/Ø/Max Preis)"
TSM.L["Sold (Total Price)"] = "Verkauft (Gesamtpreis)"
TSM.L["Sold [%s]x%d for %s to %s"] = "Verkauft [%s]x%d für %s an %s"
TSM.L["Sold Auctions %s:"] = "Auktionen verkauft: %s"
TSM.L["Source"] = "Quelle"
TSM.L["SOURCE %d"] = "QUELLE %d"
TSM.L["SOURCES"] = "QUELLEN"
TSM.L["Sources"] = "Quellen"
TSM.L["Sources to include for restock:"] = "Einzubeziehende Quellen zum Auffüllen:"
TSM.L["Stack"] = "Stapel"
TSM.L["Stack / Quantity"] = "Stapel / Anzahl"
TSM.L["Stack size multiple:"] = "Stapelgröße mehrfach:"
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Klicke auf einen der Buttons oben, um einen Sofortkauf- oder Gebot-Sniper zu starten."
TSM.L["Starting Scan..."] = "Starte Scan..."
TSM.L["STOP"] = "STOP"
TSM.L["Store operations globally"] = "Operationen global speichern"
TSM.L["Subject"] = "Betreff"
TSM.L["SUBJECT"] = "BETREFF"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
TSM.L["Switch to %s"] = "Zum %s wechseln"
TSM.L["Switch to WoW UI"] = "Zum WoW UI"
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync-Setup-Fehler: Der angegebene Spieler ist auf dem anderen Account gerade offline."
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync-Setup-Fehler: Dieser Charakter gehört bereits zu einem bekannten Account."
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync-Setup-Fehler: Du hast nicht den Charakter auf dem anderen Account, sondern den Namen des aktuellen Charakters eingegeben."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
TSM.L["TAKE ALL"] = "ALLES NEHMEN"
TSM.L["Take Attachments"] = "Anhänge nehmen"
TSM.L["Target Character"] = "Zielcharakter"
TSM.L["TARGET SHORTFALL TO BAGS"] = "ZIELFEHLMENGE ZUR TASCHE"
TSM.L["Tasks Added to Task List"] = "Aufgabe wurde zur Aufgabenliste hinzugefügt"
TSM.L["Text (%s)"] = "Text (%s)"
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "Der Canlearn-Filter wurde ignoriert, da das Addon CanIMogIt nicht gefunden wurde."
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "Die Ermittlung des Marktwertes für dieses Item ergab keinen gültigen Preis, verwendete Methode: (%s)"
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "Die Preisquelle 'disenchant' wurde mit der allgemeineren Preisquelle 'destroy' ersetzt. Bitte aktualisiere deine eigenen Preise."
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "Der errechnete Mindestgewinn (%s) ist kein gültiger Wert für dieses Item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "Der Name darf NUR Buchstaben enthalten. Leerzeichen, Zahlen oder Sonderzeichen sind nicht erlaubt."
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "Die einzureihende Menge (%d) ist kleiner als die minimale Wiederauffüllungsmenge (%d)."
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "Die angewandte Operation auf dieses Item ist ungültig! Die minimale Wiederauffüllungsmenge von %d ist höher als die maximale Wiederauffüllungsmenge von %d."
TSM.L["The player \"%s\" is already on your whitelist."] = "Der Spieler \"%s\" ist bereits auf deiner weißen Liste."
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "Der Gewinn für dieses Item (%s) ist kleiner als der Mindestgewinn (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "Der Unlearned-Filter wurde ignoriert, da das Addon CanIMogIt nicht gefunden wurde."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Dies ist kein gültiger Profilname. Profilnamen müssen mindestens 1 Zeichen lang sein und dürfen keine @-Zeichen enthalten."
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "Dieses Item hat keine Herstellungskosten. Überprüfe, ob all seine Materialien Materialpreise haben."
TSM.L["This item is not in a TSM group."] = "Dieser Gegenstand ist in keiner TSM Gruppe."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
TSM.L["This looks like an exported operation and not a custom price."] = "Dies sieht aus wie eine exportierte Operation und nicht wie ein eigener Preis."
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "Kopiere die Einstellungen von Profil '%s' in dein derzeit aktiviertes Profil?"
TSM.L["This will permanently delete the '%s' profile."] = "Dies wird das Profil '%s‘ dauerhaft löschen."
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Dieser Vorgang wird alle Gruppen und Operationen (sofern nicht global gespeichert) zurücksetzen, um sie aus diesem Profil zu tilgen."
TSM.L["Time"] = "Zeit"
TSM.L["Time Format"] = "Zeitformat"
TSM.L["Time Frame"] = "Zeitraum"
TSM.L["TIME FRAME"] = "ZEITRAUM"
TSM.L["TINKER"] = "BASTELN"
TSM.L["Tooltip Price Format"] = "Preisformat im Tooltip"
TSM.L["Tooltip Settings"] = "Tooltip-Einstellungen"
TSM.L["Top Buyers:"] = "Top Käufe:"
TSM.L["Top Item:"] = "Top Item:"
TSM.L["Top Sellers:"] = "Top Verkäufe:"
TSM.L["Total"] = "Anz"
TSM.L["Total Gold"] = "Summe Gold"
TSM.L["Total Gold Collected: %s"] = "Summe Gold abgeholt: %s"
TSM.L["Total Gold Earned:"] = "Summe Gold verdient:"
TSM.L["Total Gold Spent:"] = "Summe Gold ausgegeben:"
TSM.L["Total Price"] = "Gesamtpreis"
TSM.L["Total Profit:"] = "Gesamter Gewinn:"
TSM.L["Total Value"] = "Gesamtwert"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
TSM.L["Track Sales / Purchases via trade"] = "Verkäufe / Einkäufe via Handel protokollieren"
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
TSM.L["Transform Value"] = "Transformierungswert"
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
TSM.L["TSM Crafting"] = "TSM Crafting"
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM konnte einige Auktionen nicht scannen. Bitte starte den Scan erneut."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM fehlen wichtige Informationen aus der TSM-Desktop-App. Bitte stell sicher, dass die TSM-Desktop-App läuft und ordnungsgemäß konfiguriert ist."
TSM.L["TSM Mailing"] = "TSM Mailing"
TSM.L["TSM TASK LIST"] = "TSM AUFGABENLISTE"
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "TSM-Versionsinfo:"
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting hat festgestellt, dass du gerade %s %s gegen %s getauscht hast. Möchtest du, dass Accounting eine Aufzeichnung dieses Handels speichert?"
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
TSM.L["TUJ 3-Day Price"] = "TUJ 3-Tage-Preis"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "Twitter-Integration"
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration wurde nicht aktiviert"
TSM.L["Type"] = "Typ"
TSM.L["Type Something"] = "Schreibe etwas"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "Ungleichmäßige Klammerung."
TSM.L["Undercut amount:"] = "Unterbietungsbetrag:"
TSM.L["Undercut by whitelisted player."] = "Unterboten von Spieler aus weißer Liste."
TSM.L["Undercutting blacklisted player."] = "Unterbiete Spieler aus schwarzer Liste."
TSM.L["Undercutting competition."] = "Unterbiete Wettbewerber."
TSM.L["Ungrouped Items"] = "Nicht gruppierte Items"
TSM.L["Unknown Item"] = "Unbekanntes Item"
TSM.L["Unwrap Gift"] = "Geschenk auspacken"
TSM.L["Up"] = "Hoch"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
TSM.L["UPDATE EXISTING MACRO"] = "VORHANDENES MAKRO AKTUALISIEREN"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Benutzung: /tsm price <ItemLink> <Preistext>"
TSM.L["Use smart average for purchase price"] = "Intelligenten Durchschnitt für den Einkaufspreis verwenden"
TSM.L["Use the field below to search the auction house by filter"] = "Über folgendes Eingabefeld kannst du das AH anhand eines Suchworts filtern"
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Wähle aus der Liste links die Gruppen und Operationen, die du exportieren willst."
TSM.L["VALUE PRICE SOURCE"] = "WERTPREISQUELLE"
TSM.L["ValueSources"] = "ValueSources"
TSM.L["Variable Name"] = "Variablenname"
TSM.L["Vendor"] = "Verkäufer"
TSM.L["Vendor Buy Price"] = "Händler Kaufpreis"
TSM.L["Vendor Search"] = "Händlersuche"
TSM.L["VENDOR SEARCH"] = "HÄNDLERSUCHE"
TSM.L["Vendor Sell"] = "Händlerverkauf"
TSM.L["Vendor Sell Price"] = "Händler Verkaufspreis"
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring-Button 'ALLES VERKAUFEN'"
TSM.L["View ignored items in the Destroying options."] = "Ignorierte Items sind in den Destroying-Optionen zu finden."
TSM.L["Warehousing"] = "Warehousing"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe."
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils bis zu %d Einheiten eines Items in dieser Gruppe. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist, oder jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Taschen > Bank/GBank ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe und lässt jeweils %d Einheiten eines Items zurück, wenn Bank/GBank > Taschen ist. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe."
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing verschiebt jeweils alle Einheiten eines Items in dieser Gruppe. Das Wiederauffüllen stellt sicher, dass %d Items in deinen Taschen bleiben."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNUNG: Das Makro war zu lang und wurde deshalb von WoW auf eine passende Größe gekürzt."
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNUNG: Dein Mindestpreis für %s ist kleiner als der Händlerverkaufspreis (inklusive AH-Gebühren). Erwäge, deinen Mindestpreis zu erhöhen oder das Item beim Händler zu verkaufen."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
TSM.L["When above maximum:"] = "Wenn über Höchstpreis:"
TSM.L["When below minimum:"] = "Wenn unter Mindestpreis:"
TSM.L["Whitelist"] = "Weiße Liste"
TSM.L["Whitelisted Players"] = "Spieler auf der weißen Liste"
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "Die Menge dieses Items entspricht bereits der maximalen Wiederauffüllungsmenge. Du hast %d und die maximale Wiederauffüllungsmenge ist %d"
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Du kannst die Optionen unten benutzen, um veraltete Daten zu löschen. Es wird empfohlen, veraltete Daten gelegentlich zu löschen, damit das Accounting-Modul problemlos funktioniert. Wähle die Anzahl vergangener Tage, die entfernt werden sollen, und klicke dann auf '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "Du kannst %s nicht als Teil dieses eigenen Preises verwenden."
TSM.L["You cannot use %s within convert() as part of this custom price."] = "Du kannst %s innerhalb von convert() nicht als Teil dieses eigenen Preises verwenden."
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Du brauchst \"%s\" nicht hinzufügen. Twinks kommen automatisch auf die weiße Liste."
TSM.L["You don't know how to craft this item."] = "Du weißt nicht, wie man dieses Item herstellt."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Du musst dein UI neu laden, um diese Einstellungen wirksam werden zu lassen. Jetzt neu laden?"
TSM.L["You won an auction for %sx%d for %s"] = "Du hast die Auktion %sx%d mit %s gewonnen"
TSM.L["Your auction has not been undercut."] = "Deine Auktion wurde nicht unterboten."
TSM.L["Your auction of %s expired"] = "Deine Auktion von %s ist ausgelaufen."
TSM.L["Your auction of %s has sold for %s!"] = "Deine Auktion %s wurde für %s verkauft!"
TSM.L["Your Buyout"] = "Dein Sofortkaufpreis"
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Deine Methode zur Marktwertermittlung von '%s' war ungültig und wurde auf den Standardwert zurückgesetzt. Details: %s"
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Deine Standardmethode zur Marktwertermittlung war ungültig und wurde auf den Standardwert zurückgesetzt. Details: %s"
TSM.L["Your task list is currently empty."] = "Deine Aufgabenliste ist aktuell leer."
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Ein Bug seitens Blizzard hat dazu geführt, dass das AH nicht mehr funktioniert (du wurdest in eine andere Phase verschoben). Bitte schließe und öffne erneut das AH und starte den Sniper neu."
TSM.L["You've been undercut."] = "Du wurdest unterboten."
	elseif locale == "esES" then
TSM.L = TSM.L or {}
--[[Translation missing --]]
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Selected (%d |4Item:Items;)"
TSM.L["%d auctions"] = "%d subastas"
TSM.L["%d Groups"] = "%d Grupos"
TSM.L["%d Items"] = "%d Objetos"
TSM.L["%d of %d"] = "%d de %d"
TSM.L["%d Operations"] = "%d Operaciones"
TSM.L["%d Posted Auctions"] = "%d Subastas Publicadas"
TSM.L["%d Sold Auctions"] = "%d Subastas Vendidas"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bolsas, %s banco, %s casa de subastas, %s correo)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s jugador, %s alters, %s hermandad, %s casa de subastas)"
TSM.L["%s (%s profit)"] = "%s (%s de beneficio)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
TSM.L["%s ago"] = "hace %s"
TSM.L["%s Crafts"] = "%s Creados"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
TSM.L["%s in guild vault"] = "%s en la cámara de hermandad"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s es un precio personalizado válido pero %s es un objeto no válido."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s es un precio personalizado válido pero no dio ningún valor para %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "¡'%s' es una operación inválida! Reabastecer (Mín.) %d es mayor que Reabastecer (Máx.) %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s es un precio personalizado no válido que provocó el siguiente error: %s"
TSM.L["%s Operations"] = "%s Operaciones"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s borrado."
TSM.L["%s sent you %s"] = "%s te ha enviado %s"
TSM.L["%s sent you %s and %s"] = "%s te ha enviado %s y %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s te ha enviado un correo a contrarreembolso de %s por %s"
TSM.L["%s sent you a message: %s"] = "%s te ha enviado un mensaje: %s"
TSM.L["%s total"] = "%s total"
TSM.L["%sDrag%s to move this button"] = "%sDrag%s para mover este botón"
TSM.L["%sLeft-Click%s to open the main window"] = "%sLeft-Click%s para abrir la ventana principal"
--[[Translation missing --]]
TSM.L["(%d/500 Characters)"] = "(%d/500 Characters)"
--[[Translation missing --]]
TSM.L["(max %d)"] = "(max %d)"
TSM.L["(max 5000)"] = "(max 5000)"
--[[Translation missing --]]
TSM.L["(min %d - max %d)"] = "(min %d - max %d)"
--[[Translation missing --]]
TSM.L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(mínimo 0 - máxima 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(mínimo 0 - máximo 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(mínimo 0 - máximo 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(mínimo 0,5 - máximo 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Muestra este listado de ayuda."
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - Abre la ventana principal de TSM."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
TSM.L["1 Group"] = "1 Grupo"
--[[Translation missing --]]
TSM.L["1 Item"] = "1 Item"
TSM.L["12 hr"] = "12 hr"
TSM.L["24 hr"] = "24 hr"
TSM.L["48 hr"] = "48 hr"
TSM.L["A custom price of %s for %s evaluates to %s."] = "Un precio personalizado de %s para %s se estima en %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Sólo se permite una única función convert()."
--[[Translation missing --]]
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
--[[Translation missing --]]
TSM.L["A profile with this name already exists."] = "A profile with this name already exists."
--[[Translation missing --]]
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
--[[Translation missing --]]
TSM.L["Above max expires."] = "Above max expires."
--[[Translation missing --]]
TSM.L["Above max price. Not posting."] = "Above max price. Not posting."
--[[Translation missing --]]
TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
TSM.L["Account Syncing"] = "Sincronizar Cuentas"
TSM.L["Accounting"] = "Contabilidad"
--[[Translation missing --]]
TSM.L["Accounting Tooltips"] = "Accounting Tooltips"
TSM.L["Activity Type"] = "Tipo de actividad"
--[[Translation missing --]]
TSM.L["ADD %d ITEMS"] = "ADD %d ITEMS"
TSM.L["Add / Remove Items"] = "Añadir / Eliminar Articulo"
--[[Translation missing --]]
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
TSM.L["ADD OPERATION"] = "AÑADIR OPERACIÓN"
TSM.L["Add Player"] = "Añadir jugador"
--[[Translation missing --]]
TSM.L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
TSM.L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
TSM.L["ADD TO MAIL"] = "AÑADIR AL CORREO"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "Error adicional suprimido"
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
--[[Translation missing --]]
TSM.L["Advanced Item Search"] = "Advanced Item Search"
--[[Translation missing --]]
TSM.L["Advanced Options"] = "Advanced Options"
TSM.L["AH"] = "Casa de Subastas"
--[[Translation missing --]]
TSM.L["AH (Crafting)"] = "AH (Crafting)"
--[[Translation missing --]]
TSM.L["AH (Disenchanting)"] = "AH (Disenchanting)"
--[[Translation missing --]]
TSM.L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
TSM.L["AH Frame Options"] = "AH Frame Options"
TSM.L["Alarm Clock"] = "Alarma"
TSM.L["All Auctions"] = "Todas las subastas"
TSM.L["All Characters and Guilds"] = "Todos los personajes y hermandades"
TSM.L["All Item Classes"] = "Todos los tipos de artículos"
TSM.L["All Professions"] = "Todas las profesiones"
TSM.L["All Subclasses"] = "Todas las subclases"
--[[Translation missing --]]
TSM.L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
--[[Translation missing --]]
TSM.L["Alts"] = "Alts"
--[[Translation missing --]]
TSM.L["Alts AH"] = "Alts AH"
TSM.L["Amount"] = "Cantidad"
TSM.L["AMOUNT"] = "IMPORTE"
--[[Translation missing --]]
TSM.L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
TSM.L["APPLY FILTERS"] = "APLICAR FILTROS"
--[[Translation missing --]]
TSM.L["Apply operation to group:"] = "Apply operation to group:"
--[[Translation missing --]]
TSM.L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
TSM.L["Are you sure you want to delete this group?"] = "¿Seguro que quieres borrar este grupo?"
TSM.L["Are you sure you want to delete this operation?"] = "¿Seguro que quieres borrar esta operación?"
--[[Translation missing --]]
TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
TSM.L["Auction"] = "Subasta"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
TSM.L["AUCTION DETAILS"] = "DETALLES DE SUBASTA"
TSM.L["Auction Duration"] = "Duración de subasta"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "Cerrar Ventana de Subasta"
TSM.L["Auction Window Open"] = "Abrir Ventana de Subasta"
TSM.L["Auctionator - Auction Value"] = "Auctionator - Valor de la subasta"
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Valor de mercado"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Tasador"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - Valor de Mercado"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Precio de compra mínimo"
--[[Translation missing --]]
TSM.L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
TSM.L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
TSM.L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "Subastas"
TSM.L["Auto Quest Complete"] = "Autocompletar Misiones"
--[[Translation missing --]]
TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
TSM.L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
--[[Translation missing --]]
TSM.L["Avg Buy Price"] = "Avg Buy Price"
--[[Translation missing --]]
TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
--[[Translation missing --]]
TSM.L["Avg Sell Price"] = "Avg Sell Price"
TSM.L["BACK"] = "ATRÁS"
--[[Translation missing --]]
TSM.L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
TSM.L["Back to List"] = "Back to List"
TSM.L["Bag"] = "Bolsa"
TSM.L["Bags"] = "Bolsas"
TSM.L["Banks"] = "Bancos"
TSM.L["Base Group"] = "Grupo base"
--[[Translation missing --]]
TSM.L["Base Item"] = "Base Item"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Aquí se muestran las listas de precios disponibles por módulos. Se muestra como %skey|r Lo que puedes escribir en las casillas de precios."
--[[Translation missing --]]
TSM.L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
--[[Translation missing --]]
TSM.L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
TSM.L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
TSM.L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
TSM.L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
TSM.L["Blacklisted players:"] = "Blacklisted players:"
TSM.L["Bought"] = "Comprado"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
TSM.L["Bound Actions"] = "Bound Actions"
TSM.L["BUSY"] = "OCUPADO"
TSM.L["BUY"] = "COMPRA"
TSM.L["Buy"] = "Compra"
TSM.L["Buy %d / %d"] = "Compra %d / %d"
--[[Translation missing --]]
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
TSM.L["Buy from AH"] = "Buy from AH"
TSM.L["Buy from Vendor"] = "Comprar al Vendedor"
--[[Translation missing --]]
TSM.L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
TSM.L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
TSM.L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
TSM.L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
TSM.L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
TSM.L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
TSM.L["BUYS"] = "BUYS"
--[[Translation missing --]]
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
TSM.L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
TSM.L["Canceling"] = "Cancelando"
--[[Translation missing --]]
TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
TSM.L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
TSM.L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
TSM.L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
TSM.L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
TSM.L["Cancelled"] = "Cancelado"
--[[Translation missing --]]
TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
TSM.L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
TSM.L["Can't load TSM tooltip while in combat"] = "No se puede cargar la información del TSM mientras estás en combate"
TSM.L["Cash Register"] = "Caja registradora"
TSM.L["CHARACTER"] = "PERSONAJE"
TSM.L["Character"] = "Personaje"
TSM.L["Chat Tab"] = "Pestaña de Chat"
--[[Translation missing --]]
TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
TSM.L["Clear"] = "Restablecer"
TSM.L["Clear All"] = "Limpiar todo"
TSM.L["CLEAR DATA"] = "BORRAR DATOS"
TSM.L["Clear Filters"] = "Borrar Filtros"
TSM.L["Clear Old Data"] = "Borrar datos antiguos"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
TSM.L["Clear Queue"] = "Clear Queue"
TSM.L["Clear Selection"] = "Restablecer Selección"
--[[Translation missing --]]
TSM.L["COD"] = "COD"
TSM.L["Coins (%s)"] = "Monedas (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
TSM.L["Combining..."] = "Combining..."
--[[Translation missing --]]
TSM.L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
TSM.L["Confirm"] = "Confirmar"
--[[Translation missing --]]
TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
TSM.L["Confirming %d / %d"] = "Confirming %d / %d"
TSM.L["Connected to %s"] = "Conectado con %s"
--[[Translation missing --]]
TSM.L["Connecting to %s"] = "Connecting to %s"
TSM.L["CONTACTS"] = "CONTACTOS"
--[[Translation missing --]]
TSM.L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
TSM.L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
TSM.L["Cooldowns"] = "Cooldowns"
TSM.L["Cost"] = "Precio"
--[[Translation missing --]]
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "No se pudo encontrar el perfil \"%s\". Sugerencias: \"%s\""
--[[Translation missing --]]
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
TSM.L["Craft"] = "Craft"
--[[Translation missing --]]
TSM.L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
TSM.L["Craft All"] = "Craft All"
--[[Translation missing --]]
TSM.L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
TSM.L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
TSM.L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
TSM.L["Crafts"] = "Crafts"
--[[Translation missing --]]
TSM.L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
TSM.L["CREATE MACRO"] = "CREATE MACRO"
TSM.L["Create New Operation"] = "Crear Nueva Operación"
--[[Translation missing --]]
TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "Cristales"
--[[Translation missing --]]
TSM.L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
TSM.L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
TSM.L["Custom Price"] = "Custom Price"
TSM.L["Custom Price Source"] = "Fuente de Precio Personalizado"
--[[Translation missing --]]
TSM.L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
TSM.L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
TSM.L["Default Price"] = "Default Price"
--[[Translation missing --]]
TSM.L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "Desmarcar Todos los Grupos"
--[[Translation missing --]]
TSM.L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
TSM.L["Destroy Next"] = "Destroy Next"
TSM.L["Destroy Value"] = "Valor de Destrucción"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
TSM.L["Destroying"] = "Destroying"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
TSM.L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
TSM.L["Details"] = "Details"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
TSM.L["Display market value"] = "Display market value"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
TSM.L["Display min buyout"] = "Mostrar compra mínima"
--[[Translation missing --]]
TSM.L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
TSM.L["Display sale info"] = "Mostrar información de venta"
TSM.L["Display sale rate"] = "Mostrar tasa de venta"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
TSM.L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
TSM.L["Done Scanning"] = "Escaneo realizado"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
TSM.L["DOWN"] = "ABAJO"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
TSM.L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "Polvo"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
TSM.L["Empty parentheses are not allowed"] = "Paréntesis vacíos no permitidos"
TSM.L["Empty price string."] = "Cadena de precio vacía."
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
TSM.L["Enable buying?"] = "¿Habilitar la compra?"
TSM.L["Enable inbox chat messages"] = "Habilitar los mensajes de chat de la bandeja de entrada"
TSM.L["Enable restock?"] = "¿Habilitar el reponer?"
TSM.L["Enable selling?"] = "¿Habilitar venta?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
TSM.L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
TSM.L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
TSM.L["Enter player name"] = "Enter player name"
TSM.L["Essences"] = "Esencias"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establecimiendo conexión con %s. Asegúrate de que has introducido el nombre de este personaje en la otra cuenta."
--[[Translation missing --]]
TSM.L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
TSM.L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
TSM.L["Expenses"] = "Gastos"
TSM.L["EXPENSES"] = "GASTOS"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
--[[Translation missing --]]
TSM.L["Expired"] = "Expired"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
TSM.L["Expires"] = "Vence"
--[[Translation missing --]]
TSM.L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "Exploración"
--[[Translation missing --]]
TSM.L["Export"] = "Export"
--[[Translation missing --]]
TSM.L["Export List"] = "Export List"
--[[Translation missing --]]
TSM.L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
TSM.L["Favorite Searches"] = "Favorite Searches"
--[[Translation missing --]]
TSM.L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
TSM.L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
--[[Translation missing --]]
TSM.L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
TSM.L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
--[[Translation missing --]]
TSM.L["Filter Items"] = "Filter Items"
--[[Translation missing --]]
TSM.L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
TSM.L["Fishing Reel In"] = "Pesca - recoger el sedal"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
TSM.L["Friends"] = "Friends"
--[[Translation missing --]]
TSM.L["From"] = "From"
TSM.L["Full"] = "Completo"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "Opciones Generales"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
--[[Translation missing --]]
TSM.L["Gold"] = "Gold"
--[[Translation missing --]]
TSM.L["Gold Earned:"] = "Gold Earned:"
--[[Translation missing --]]
TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
--[[Translation missing --]]
TSM.L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
TSM.L["Group already exists."] = "Group already exists."
TSM.L["Group Management"] = "Administrar Grupo"
--[[Translation missing --]]
TSM.L["Group Operations"] = "Group Operations"
--[[Translation missing --]]
TSM.L["Group Settings"] = "Group Settings"
--[[Translation missing --]]
TSM.L["Grouped Items"] = "Grouped Items"
TSM.L["Groups"] = "Grupos"
--[[Translation missing --]]
TSM.L["Guild"] = "Guild"
--[[Translation missing --]]
TSM.L["Guild Bank"] = "Guild Bank"
TSM.L["GVault"] = "Cámara Herm."
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
TSM.L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
TSM.L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
TSM.L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Si tienes otros Perfiles configurados con diferentes Operaciones, activar esto hará que todas las Operaciones salvo la del Perfil actual se pierdan de manera irreversible. ¿Seguro que quieres continuar?"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
TSM.L["Ignore Characters"] = "Ignore Characters"
TSM.L["Ignore Guilds"] = "Ignorar Hermandades"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
TSM.L["Ignored Items"] = "Ignored Items"
TSM.L["ilvl"] = "ilvl"
TSM.L["Import"] = "Importar"
TSM.L["IMPORT"] = "IMPORTAR"
TSM.L["Import %d Items and %s Operations?"] = "Importar %d Artículos y %s Operaciones"
TSM.L["Import Groups & Operations"] = "Importar Grupos y Operaciones"
TSM.L["Imported Items"] = "Importar Artículos"
TSM.L["Inbox Settings"] = "Configuración de la bandeja de entrada"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
TSM.L["Information"] = "Information"
--[[Translation missing --]]
TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
TSM.L["Invalid custom price."] = "Precio Personalizado no válido."
TSM.L["Invalid function."] = "Función no válida."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
TSM.L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "Enlace a objeto no válido."
--[[Translation missing --]]
TSM.L["Invalid operation name."] = "Invalid operation name."
TSM.L["Invalid operator at end of custom price."] = "Operador no válido al final del precio personalizado."
TSM.L["Invalid parameter to price source."] = "Parámetro no válido para fuente de precio."
--[[Translation missing --]]
TSM.L["Invalid player name."] = "Invalid player name."
TSM.L["Invalid price source in convert."] = "Fuente de precio en conversión no válida."
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
TSM.L["Invalid word: '%s'"] = "Palabra no válida: \"%s\""
--[[Translation missing --]]
TSM.L["Inventory"] = "Inventory"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
TSM.L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "Objeto"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
TSM.L["Item Level"] = "Item Level"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
TSM.L["Item links may only be used as parameters to price sources."] = "Los enlaces de objetos sólo pueden ser utilizados como parámetros para Fuentes de Precio."
TSM.L["Item Name"] = "Nombre de Objeto"
--[[Translation missing --]]
TSM.L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
TSM.L["Item Value"] = "Item Value"
--[[Translation missing --]]
TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
TSM.L["ITEMS"] = "ITEMS"
TSM.L["Items"] = "Objetos"
--[[Translation missing --]]
TSM.L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
TSM.L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
TSM.L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
TSM.L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
TSM.L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
TSM.L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
TSM.L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
TSM.L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
TSM.L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
TSM.L["LAST 7 DAYS"] = "LAST 7 DAYS"
--[[Translation missing --]]
TSM.L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
TSM.L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
TSM.L["Last Sold"] = "Last Sold"
--[[Translation missing --]]
TSM.L["Level Up"] = "Level Up"
--[[Translation missing --]]
TSM.L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
TSM.L["List"] = "List"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
TSM.L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
TSM.L["Loading..."] = "Loading..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Parece que TradeSkillMaster ha encontrado un error. Por favor, ayudar al autor corregir este error, siga las instrucciones que se muestran."
TSM.L["Loop detected in the following custom price:"] = "Reduncia cíclica detectada en el precio personalizado seguido:"
--[[Translation missing --]]
TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
TSM.L["Macro created and scroll wheel bound!"] = "Macro creado y rueda de desplazamiento enlazada!"
TSM.L["Macro Setup"] = "Configuración de macro."
TSM.L["Mail"] = "Correo"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
TSM.L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
TSM.L["Management Options"] = "Management Options"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
TSM.L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
TSM.L["Market Value"] = "Market Value"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
--[[Translation missing --]]
TSM.L["Materials"] = "Materials"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
TSM.L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
TSM.L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
TSM.L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
TSM.L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
TSM.L["Misplaced comma"] = "Coma fuera de lugar."
--[[Translation missing --]]
TSM.L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "Modificado."
--[[Translation missing --]]
TSM.L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
TSM.L["MOVE"] = "MOVE"
--[[Translation missing --]]
TSM.L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
TSM.L["MOVING"] = "MOVING"
--[[Translation missing --]]
TSM.L["Moving"] = "Moving"
--[[Translation missing --]]
TSM.L["Multiple Items"] = "Multiple Items"
--[[Translation missing --]]
TSM.L["My Auctions"] = "My Auctions"
--[[Translation missing --]]
TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
TSM.L["New Group"] = "Nuevo Grupo"
TSM.L["New Operation"] = "Nueva operación"
--[[Translation missing --]]
TSM.L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
TSM.L["No Data"] = "No Data"
--[[Translation missing --]]
TSM.L["No group selected"] = "No group selected"
--[[Translation missing --]]
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
TSM.L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
TSM.L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
TSM.L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
--[[Translation missing --]]
TSM.L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
TSM.L["No Profession Selected"] = "No Profession Selected"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Perfil no especificado. Perfiles posibles: '%s'"
--[[Translation missing --]]
TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
TSM.L["No Sound"] = "Sin sonido"
TSM.L["None"] = "Ninguno"
TSM.L["None (Always Show)"] = "Ninguno (Mostrar siempre)"
--[[Translation missing --]]
TSM.L["None Selected"] = "None Selected"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
TSM.L["Normal"] = "Normal"
--[[Translation missing --]]
TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
TSM.L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
TSM.L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
TSM.L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
TSM.L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
TSM.L["NPC"] = "NPC"
--[[Translation missing --]]
TSM.L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
TSM.L["of"] = "of"
TSM.L["Offline"] = "Desconectado"
--[[Translation missing --]]
TSM.L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
TSM.L["OPEN"] = "OPEN"
--[[Translation missing --]]
TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
--[[Translation missing --]]
TSM.L["Operation"] = "Operation"
TSM.L["Operations"] = "Operaciones"
--[[Translation missing --]]
TSM.L["Other Character"] = "Other Character"
--[[Translation missing --]]
TSM.L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
TSM.L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
TSM.L["Past Day"] = "Past Day"
--[[Translation missing --]]
TSM.L["Past Month"] = "Past Month"
--[[Translation missing --]]
TSM.L["Past Year"] = "Past Year"
--[[Translation missing --]]
TSM.L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
TSM.L["Per Item"] = "Per Item"
--[[Translation missing --]]
TSM.L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
TSM.L["Per Unit"] = "Per Unit"
TSM.L["Player Gold"] = "Oro de personaje"
TSM.L["Player Invite Accept"] = "Aceptar invitación de jugador."
--[[Translation missing --]]
TSM.L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
--[[Translation missing --]]
TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
TSM.L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
TSM.L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
TSM.L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
TSM.L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
TSM.L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
TSM.L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
TSM.L["Professions Used In"] = "Professions Used In"
TSM.L["Profile changed to '%s'."] = "Perfil cambiado a '%s'."
TSM.L["Profiles"] = "Perfiles"
--[[Translation missing --]]
TSM.L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
TSM.L["Profit"] = "Profit"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
TSM.L["Purchases"] = "Purchases"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
TSM.L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
TSM.L["Quantity to move:"] = "Quantity to move:"
TSM.L["Quest Added"] = "Misión añadida."
TSM.L["Quest Completed"] = "Misión completada"
TSM.L["Quest Objectives Complete"] = "Objetivos de misión completados."
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
TSM.L["Raid Warning"] = "Alerta de Raid"
--[[Translation missing --]]
TSM.L["Read More"] = "Read More"
--[[Translation missing --]]
TSM.L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
TSM.L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
TSM.L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
TSM.L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
TSM.L["Reload"] = "Reload"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
TSM.L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
TSM.L["REPLY"] = "REPLY"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
TSM.L["Required Level"] = "Required Level"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
TSM.L["Resale"] = "Resale"
--[[Translation missing --]]
TSM.L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
TSM.L["RESET"] = "RESET"
--[[Translation missing --]]
TSM.L["Reset All"] = "Reset All"
--[[Translation missing --]]
TSM.L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
TSM.L["RESTART"] = "RESTART"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
TSM.L["Sale"] = "Sale"
--[[Translation missing --]]
TSM.L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
TSM.L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
TSM.L["Sales"] = "Sales"
--[[Translation missing --]]
TSM.L["SALES"] = "SALES"
--[[Translation missing --]]
TSM.L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
TSM.L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
TSM.L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
TSM.L["Search"] = "Search"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
TSM.L["Search Groups"] = "Search Groups"
TSM.L["Search Inbox"] = "Buscar en la bandeja de entrada"
--[[Translation missing --]]
TSM.L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
TSM.L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
TSM.L["Select Action"] = "Select Action"
TSM.L["Select All Groups"] = "Seleccionar todos los Grupos"
--[[Translation missing --]]
TSM.L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
TSM.L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
TSM.L["Select Duration"] = "Select Duration"
--[[Translation missing --]]
TSM.L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
TSM.L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
TSM.L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
TSM.L["Select professions"] = "Select professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
TSM.L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
TSM.L["Sell"] = "Sell"
--[[Translation missing --]]
TSM.L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
TSM.L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
TSM.L["Sell to Vendor"] = "Vender al Vendedor"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
TSM.L["Seller"] = "Seller"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
TSM.L["Send"] = "Send"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
TSM.L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
TSM.L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
TSM.L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
TSM.L["Send Money"] = "Send Money"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
TSM.L["SENDING"] = "SENDING"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
TSM.L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
TSM.L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "Fragmentos"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
TSM.L["Show Description"] = "Show Description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
TSM.L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
TSM.L["Simple"] = "Sencillo."
--[[Translation missing --]]
TSM.L["SKIP"] = "SKIP"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
TSM.L["Slash Commands:"] = "Comandos de barra:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
--[[Translation missing --]]
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
TSM.L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
TSM.L["Sold"] = "Sold"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
TSM.L["Sources"] = "Fuentes"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
TSM.L["Stack"] = "Stack"
--[[Translation missing --]]
TSM.L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
TSM.L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
TSM.L["STOP"] = "STOP"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
TSM.L["Subject"] = "Subject"
--[[Translation missing --]]
TSM.L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
--[[Translation missing --]]
TSM.L["Switch to WoW UI"] = "Switch to WoW UI"
--[[Translation missing --]]
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
TSM.L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
TSM.L["Target Character"] = "Target Character"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
TSM.L["Text (%s)"] = "Texto (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "El nombre SOLO puede contener letras. No puede contener espacios, números o caracteres especiales."
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Este no es un nombre de perfil válido. Los nombres de perfil tienen que tener ser al menos un carácter de longitud y no pueden tener '@'."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
TSM.L["This looks like an exported operation and not a custom price."] = "Esto parece una operación exportada y no un precio personalizado."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
TSM.L["Time"] = "Time"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
--[[Translation missing --]]
TSM.L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
TSM.L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
TSM.L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
TSM.L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
TSM.L["Top Sellers:"] = "Top Sellers:"
TSM.L["Total"] = "Total"
--[[Translation missing --]]
TSM.L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
TSM.L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
TSM.L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
TSM.L["Total Price"] = "Total Price"
--[[Translation missing --]]
TSM.L["Total Profit:"] = "Total Profit:"
TSM.L["Total Value"] = "Valor total"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
TSM.L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "TSM Versión Info:"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
TSM.L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "Integración de Twitter"
--[[Translation missing --]]
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
--[[Translation missing --]]
TSM.L["Type Something"] = "Type Something"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "Paréntesis no balanceados."
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
TSM.L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
TSM.L["Unknown Item"] = "Unknown Item"
TSM.L["Unwrap Gift"] = "Abrir regalo"
TSM.L["Up"] = "Arriba"
TSM.L["Up to date"] = "A día de hoy"
--[[Translation missing --]]
TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
TSM.L["Updating"] = "Actualizando"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Uso: / tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
TSM.L["Vendor"] = "Vendor"
--[[Translation missing --]]
TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
TSM.L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
TSM.L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
TSM.L["When below minimum:"] = "When below minimum:"
TSM.L["Whitelist"] = "Lista blanca"
TSM.L["Whitelisted Players"] = "Jugadores de la lista blanca"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "No se puede utilizar %s como parte de este precio personalizado."
--[[Translation missing --]]
TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Debes volver a cargar la interfaz de usuario para esta configuración surta efecto. ¿Actualizar ahora?"
TSM.L["You won an auction for %sx%d for %s"] = "Has ganado el artículo %sx%d en subasta por %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
TSM.L["Your auction of %s has sold for %s!"] = "Tu subasta %s ha sido vendida por %s!"
--[[Translation missing --]]
TSM.L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
TSM.L["You've been undercut."] = "You've been undercut."
	elseif locale == "esMX" then
TSM.L = TSM.L or {}
--[[Translation missing --]]
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Selected (%d |4Item:Items;)"
TSM.L["%d auctions"] = "%d subastas"
TSM.L["%d Groups"] = "%d Grupos"
TSM.L["%d Items"] = "%d Objetos"
TSM.L["%d of %d"] = "%d de %d"
TSM.L["%d Operations"] = "%d Operaciones"
TSM.L["%d Posted Auctions"] = "%d Subastas publicadas"
TSM.L["%d Sold Auctions"] = "%d Subastas vendidas"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s Bolsas, %s Banco, %s Casa de subastas, %s Correo)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s Jugador, %s Alters, %s Hermandad, %s Casa de subastas)"
--[[Translation missing --]]
TSM.L["%s (%s profit)"] = "%s (%s profit)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
--[[Translation missing --]]
TSM.L["%s ago"] = "%s ago"
TSM.L["%s Crafts"] = "%s Creaciones"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
TSM.L["%s in guild vault"] = "%s en cámara de la Hermandad"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s es un precio válido, pero %s no es un objeto válido."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s es un precio válido pero no dio un valor para %s."
--[[Translation missing --]]
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s no es un precio válido y dio el siguiente error: %s"
TSM.L["%s Operations"] = "%s Operaciones"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s eliminado."
TSM.L["%s sent you %s"] = "%s enviado a ti %s"
--[[Translation missing --]]
TSM.L["%s sent you %s and %s"] = "%s sent you %s and %s"
--[[Translation missing --]]
TSM.L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
TSM.L["%s sent you a message: %s"] = "%s mandarte un mensaje : %s"
TSM.L["%s total"] = "%s total"
TSM.L["%sDrag%s to move this button"] = "%sArrastra%s para mover este botón"
TSM.L["%sLeft-Click%s to open the main window"] = "%sClick Izquierdo%s para abrir la ventana principal"
TSM.L["(%d/500 Characters)"] = "(%d/500 Personajes)"
TSM.L["(max %d)"] = "(máx %d)"
TSM.L["(max 5000)"] = "(máx 5000)"
TSM.L["(min %d - max %d)"] = "(mín %d - máx %d)"
TSM.L["(min 0 - max 10000)"] = "(mín 0 - máx 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(mínimo 0 - máximo 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(mínimo 0 - máximo 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(mínimo 0 - máximo 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(mínimo 0,5 - máximo 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Muestra este listado de ayuda."
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - Abre la ventana principal de TSM."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
TSM.L["1 Group"] = "1 Grupo"
TSM.L["1 Item"] = "1 Objeto"
TSM.L["12 hr"] = "12 horas"
TSM.L["24 hr"] = "24 horas"
TSM.L["48 hr"] = "48 horas"
TSM.L["A custom price of %s for %s evaluates to %s."] = "Un precio personalizado de %s para %s se estima en %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Sólo se permite una única función convert()."
--[[Translation missing --]]
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
--[[Translation missing --]]
TSM.L["A profile with this name already exists."] = "A profile with this name already exists."
--[[Translation missing --]]
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
--[[Translation missing --]]
TSM.L["Above max expires."] = "Above max expires."
--[[Translation missing --]]
TSM.L["Above max price. Not posting."] = "Above max price. Not posting."
--[[Translation missing --]]
TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
TSM.L["Account Syncing"] = "Sincronizar Cuentas"
--[[Translation missing --]]
TSM.L["Accounting"] = "Accounting"
--[[Translation missing --]]
TSM.L["Accounting Tooltips"] = "Accounting Tooltips"
--[[Translation missing --]]
TSM.L["Activity Type"] = "Activity Type"
TSM.L["ADD %d ITEMS"] = "AGREGAR %d OBJETOS"
TSM.L["Add / Remove Items"] = "Agregar / Eliminar Objetos"
--[[Translation missing --]]
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
TSM.L["ADD OPERATION"] = "AGREGAR OPERACIÓN"
--[[Translation missing --]]
TSM.L["Add Player"] = "Add Player"
--[[Translation missing --]]
TSM.L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
TSM.L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
--[[Translation missing --]]
TSM.L["ADD TO MAIL"] = "ADD TO MAIL"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "Error Adicional Suprimido"
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
--[[Translation missing --]]
TSM.L["Advanced Item Search"] = "Advanced Item Search"
TSM.L["Advanced Options"] = "Opciones avanzadas"
TSM.L["AH"] = "Casa de Subastas"
--[[Translation missing --]]
TSM.L["AH (Crafting)"] = "AH (Crafting)"
TSM.L["AH (Disenchanting)"] = "Casa de subastas (Desencantando)"
--[[Translation missing --]]
TSM.L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
TSM.L["AH Frame Options"] = "AH Frame Options"
TSM.L["Alarm Clock"] = "Alarma"
TSM.L["All Auctions"] = "Todas las subastas"
TSM.L["All Characters and Guilds"] = "Todos los personajes y hermandades"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
TSM.L["All Professions"] = "Todas las profesiones"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
--[[Translation missing --]]
TSM.L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
--[[Translation missing --]]
TSM.L["Alts"] = "Alts"
--[[Translation missing --]]
TSM.L["Alts AH"] = "Alts AH"
--[[Translation missing --]]
TSM.L["Amount"] = "Amount"
--[[Translation missing --]]
TSM.L["AMOUNT"] = "AMOUNT"
--[[Translation missing --]]
TSM.L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
--[[Translation missing --]]
TSM.L["APPLY FILTERS"] = "APPLY FILTERS"
--[[Translation missing --]]
TSM.L["Apply operation to group:"] = "Apply operation to group:"
--[[Translation missing --]]
TSM.L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
TSM.L["Are you sure you want to delete this group?"] = "¿Seguro que quieres eliminar el grupo seleccionado?"
TSM.L["Are you sure you want to delete this operation?"] = "¿Seguro que quieres eliminar esta operación?"
--[[Translation missing --]]
TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
TSM.L["Auction"] = "Subasta"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
TSM.L["AUCTION DETAILS"] = "DETALLES DE LA SUBASTA"
TSM.L["Auction Duration"] = "Duración de la subasta"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "Cerrar Ventana de Subasta"
TSM.L["Auction Window Open"] = "Abrir Ventana de Subasta"
TSM.L["Auctionator - Auction Value"] = "Subastador - Valor de la subasta"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Subastador - Valuador"
TSM.L["Auctioneer - Market Value"] = "Subastador - Valor de mercado"
TSM.L["Auctioneer - Minimum Buyout"] = "Subastador - Precio mínimo de compra"
--[[Translation missing --]]
TSM.L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
TSM.L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
TSM.L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "Subastas"
TSM.L["Auto Quest Complete"] = "Auto misión Completa"
--[[Translation missing --]]
TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
TSM.L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
TSM.L["Avg Buy Price"] = "Precio medio de compra"
--[[Translation missing --]]
TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
TSM.L["Avg Sell Price"] = "Precio medio de venta"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
--[[Translation missing --]]
TSM.L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
TSM.L["Back to List"] = "Back to List"
TSM.L["Bag"] = "Bolsa"
TSM.L["Bags"] = "Bolsas"
TSM.L["Banks"] = "Bancos"
--[[Translation missing --]]
TSM.L["Base Group"] = "Base Group"
--[[Translation missing --]]
TSM.L["Base Item"] = "Base Item"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "A continuación se encuentran las fuentes de precios actualmente disponibles organizadas por módulo. El %skey|r es lo que escribirías en un cuadro de precio personalizado."
--[[Translation missing --]]
TSM.L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
--[[Translation missing --]]
TSM.L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
TSM.L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
TSM.L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
TSM.L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
TSM.L["Blacklisted players:"] = "Blacklisted players:"
--[[Translation missing --]]
TSM.L["Bought"] = "Bought"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
TSM.L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
TSM.L["BUSY"] = "BUSY"
--[[Translation missing --]]
TSM.L["BUY"] = "BUY"
--[[Translation missing --]]
TSM.L["Buy"] = "Buy"
--[[Translation missing --]]
TSM.L["Buy %d / %d"] = "Buy %d / %d"
--[[Translation missing --]]
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
TSM.L["Buy from AH"] = "Buy from AH"
TSM.L["Buy from Vendor"] = "Comprar al Vendedor"
--[[Translation missing --]]
TSM.L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
TSM.L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
TSM.L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
TSM.L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
TSM.L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
TSM.L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
TSM.L["BUYS"] = "BUYS"
--[[Translation missing --]]
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
TSM.L["Cancel Scan"] = "Cancelar escaneo"
--[[Translation missing --]]
TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
TSM.L["Canceling"] = "Cancelando"
--[[Translation missing --]]
TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
TSM.L["Canceling %d Auctions..."] = "Cancelando %d Subastas..."
TSM.L["Canceling all auctions."] = "Cancelando todas las subastas."
--[[Translation missing --]]
TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
TSM.L["Canceling disabled."] = "Canceling disabled."
TSM.L["Canceling Settings"] = "Cancelando ajustes"
--[[Translation missing --]]
TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
TSM.L["Cancelled"] = "Cancelado"
--[[Translation missing --]]
TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
TSM.L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
TSM.L["Can't load TSM tooltip while in combat"] = "No se puede cargar la descripción emergente de TSM mientras se está en combate"
TSM.L["Cash Register"] = "Caja registradora"
TSM.L["CHARACTER"] = "PERSONAJE"
TSM.L["Character"] = "Personaje"
TSM.L["Chat Tab"] = "Pestaña de Chat"
--[[Translation missing --]]
TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
TSM.L["Clear"] = "Limpiar"
TSM.L["Clear All"] = "Borrar todo"
TSM.L["CLEAR DATA"] = "Borrar data"
TSM.L["Clear Filters"] = "Filtros de borrado"
--[[Translation missing --]]
TSM.L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
TSM.L["Clear Queue"] = "Clear Queue"
TSM.L["Clear Selection"] = "Limpiar Seleccion"
--[[Translation missing --]]
TSM.L["COD"] = "COD"
TSM.L["Coins (%s)"] = "Monedas (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
TSM.L["Combining..."] = "Combinando..."
TSM.L["Configuration Scroll Wheel"] = "Configuración de la rueda del ratón"
TSM.L["Confirm"] = "Confirmar"
--[[Translation missing --]]
TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
TSM.L["Confirming %d / %d"] = "Confirmando %d / %d"
TSM.L["Connected to %s"] = "Conectado a %s"
TSM.L["Connecting to %s"] = "Conectando a %s"
--[[Translation missing --]]
TSM.L["CONTACTS"] = "CONTACTS"
--[[Translation missing --]]
TSM.L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
TSM.L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
TSM.L["Cooldowns"] = "Cooldowns"
--[[Translation missing --]]
TSM.L["Cost"] = "Cost"
--[[Translation missing --]]
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "No se pudo encontrar el perfil '%s'. Posibles perfiles: '%s'"
--[[Translation missing --]]
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
TSM.L["Craft"] = "Craft"
--[[Translation missing --]]
TSM.L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
TSM.L["Craft All"] = "Craft All"
--[[Translation missing --]]
TSM.L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
TSM.L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
TSM.L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
TSM.L["Crafts"] = "Crafts"
--[[Translation missing --]]
TSM.L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
TSM.L["CREATE MACRO"] = "CREATE MACRO"
TSM.L["Create New Operation"] = "Crear Nueva Operación"
--[[Translation missing --]]
TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "Cristales"
--[[Translation missing --]]
TSM.L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
TSM.L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
TSM.L["Custom Price"] = "Custom Price"
TSM.L["Custom Price Source"] = "Fuente de Precio Personalizado"
--[[Translation missing --]]
TSM.L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
TSM.L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
TSM.L["Default Price"] = "Default Price"
--[[Translation missing --]]
TSM.L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "Desmarcar Todos los Grupos"
--[[Translation missing --]]
TSM.L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
TSM.L["Destroy Next"] = "Destroy Next"
TSM.L["Destroy Value"] = "Borrar Valor"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
TSM.L["Destroying"] = "Destroying"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
TSM.L["Destroying..."] = "Destroying..."
TSM.L["Details"] = "Detalles"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
TSM.L["Display market value"] = "Display market value"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
--[[Translation missing --]]
TSM.L["Display min buyout"] = "Display min buyout"
--[[Translation missing --]]
TSM.L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
TSM.L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
TSM.L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
TSM.L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
TSM.L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
TSM.L["DOWN"] = "DOWN"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
TSM.L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "Polvo"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
TSM.L["Empty parentheses are not allowed"] = "Los paréntesis vacíos no están permitidos"
TSM.L["Empty price string."] = "Cadena de precio vacía."
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
TSM.L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
TSM.L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
TSM.L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
TSM.L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
TSM.L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
TSM.L["Enter player name"] = "Enter player name"
TSM.L["Essences"] = "Esencias"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Estableciendo conexión a %s. Asegúrate de haber ingresado el nombre de este personaje en la otra cuenta."
--[[Translation missing --]]
TSM.L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
TSM.L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
TSM.L["Expenses"] = "Expenses"
--[[Translation missing --]]
TSM.L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
--[[Translation missing --]]
TSM.L["Expired"] = "Expired"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
--[[Translation missing --]]
TSM.L["Expires"] = "Expires"
--[[Translation missing --]]
TSM.L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "Exploración"
TSM.L["Export"] = "Exportar"
TSM.L["Export List"] = "Lista de Exportacion"
TSM.L["Failed Auctions"] = "Subastas Fallidas"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
TSM.L["Favorite Searches"] = "Favorite Searches"
--[[Translation missing --]]
TSM.L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
TSM.L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
TSM.L["Filter by Keyword"] = "Filtrar por Palabra clave"
TSM.L["FILTER BY KEYWORD"] = "FILTRAR POR PALABRA CLAVE"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
TSM.L["Filter Items"] = "Filtrar objetos"
TSM.L["Filter Shopping"] = "Filtro de compras"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
TSM.L["Fishing Reel In"] = "Pesca - recoger el sedal"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
TSM.L["Friends"] = "Amigos"
TSM.L["From"] = "De"
TSM.L["Full"] = "Completo"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "Opciones Generales"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
TSM.L["Gold"] = "Oro"
--[[Translation missing --]]
TSM.L["Gold Earned:"] = "Gold Earned:"
TSM.L["GOLD ON HAND"] = "ORO DISPONIBLE"
--[[Translation missing --]]
TSM.L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
TSM.L["Group already exists."] = "Group already exists."
TSM.L["Group Management"] = "Administrar Grupo"
TSM.L["Group Operations"] = "Operaciones del Grupo"
TSM.L["Group Settings"] = "Configuraciones del Grupo"
--[[Translation missing --]]
TSM.L["Grouped Items"] = "Grouped Items"
TSM.L["Groups"] = "Grupos"
TSM.L["Guild"] = "Hermandad"
TSM.L["Guild Bank"] = "Banco de Hermandad"
TSM.L["GVault"] = "Cámara Herm."
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
TSM.L["Hide Description"] = "Ocultar descripcion"
TSM.L["Hide minimap icon"] = "Ocultar icono en Minimapa"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
TSM.L["Historical Price"] = "Precio Historico"
--[[Translation missing --]]
TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Si tienes múltiples perfiles configurados con operaciones, habilitar esto hará que todas las operaciones, excepto las del perfil actual, se pierdan irreversiblemente. Estás seguro de que quieres continuar?"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
TSM.L["Ignore Characters"] = "Ignorar Personaje"
TSM.L["Ignore Guilds"] = "Ignorar Hermandades"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
TSM.L["Ignored Items"] = "Ignored Items"
TSM.L["ilvl"] = "Nivel de objeto"
TSM.L["Import"] = "Importar"
TSM.L["IMPORT"] = "IMPORTAR"
--[[Translation missing --]]
TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
TSM.L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
TSM.L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
TSM.L["Information"] = "Informacion"
--[[Translation missing --]]
TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
TSM.L["Invalid custom price."] = "Precio personalizado no válido"
TSM.L["Invalid function."] = "Función inválida."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
TSM.L["Invalid group name."] = "Nombre de grupo invalido."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "Enlace de Objeto inválido."
TSM.L["Invalid operation name."] = "Nombre de operacion invalido."
TSM.L["Invalid operator at end of custom price."] = "Operador inválido al final del precio personalizado."
TSM.L["Invalid parameter to price source."] = "Parámetro no válido para la fuente de precio."
--[[Translation missing --]]
TSM.L["Invalid player name."] = "Invalid player name."
TSM.L["Invalid price source in convert."] = "Fuente de precio inválida en convertir."
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
TSM.L["Invalid word: '%s'"] = "Palabra inválida: '%s'"
TSM.L["Inventory"] = "Inventario"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
TSM.L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "Objeto"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
TSM.L["Item Level"] = "Item Level"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
TSM.L["Item links may only be used as parameters to price sources."] = "Los enlaces de objetos solo se pueden usar como parámetros para las fuentes de precios."
TSM.L["Item Name"] = "Nombre de Objeto"
--[[Translation missing --]]
TSM.L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
TSM.L["Item Value"] = "Item Value"
--[[Translation missing --]]
TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
TSM.L["ITEMS"] = "OBJETOS"
TSM.L["Items"] = "Objetos"
TSM.L["Items in Bags"] = "Objetos en Bolsas"
--[[Translation missing --]]
TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
TSM.L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
TSM.L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
TSM.L["Last 14 Days"] = "Ultimos 14 Dias"
TSM.L["Last 3 Days"] = "Ultimos 3 Dias"
TSM.L["Last 30 Days"] = "Ultimos 30 Dias"
TSM.L["LAST 30 DAYS"] = "ULTIMOS 30 DIAS"
TSM.L["Last 60 Days"] = "Ultimos 60 Dias"
TSM.L["Last 7 Days"] = "Ultimos 7 Dias"
TSM.L["LAST 7 DAYS"] = "ULTIMOS 7 DIAS"
--[[Translation missing --]]
TSM.L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
TSM.L["Last Purchased"] = "Last Purchased"
TSM.L["Last Sold"] = "Ultima venta"
TSM.L["Level Up"] = "Subida de Nivel"
TSM.L["LIMIT"] = "LIMITE"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
TSM.L["List"] = "Lista"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
TSM.L["Loading Mails..."] = "Cargando Mensajes..."
TSM.L["Loading..."] = "Cargando..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Parece que TradeSkillMaster ha encontrado un error. Por favor, ayuda el autor solucionar este error, siguiendo las instrucciones que se muestran."
TSM.L["Loop detected in the following custom price:"] = "bucle detectado en el siguiente precio personalizado:"
--[[Translation missing --]]
TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
TSM.L["Macro created and scroll wheel bound!"] = "¡Macro creada y rueda de desplazamiento enlazada!"
TSM.L["Macro Setup"] = "Configuración de macro."
TSM.L["Mail"] = "Correo"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
TSM.L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
TSM.L["Management Options"] = "Management Options"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
TSM.L["Map Ping"] = "Ping en Mapa"
TSM.L["Market Value"] = "Valor del Mercado"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
TSM.L["Materials"] = "Materiales"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
TSM.L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
TSM.L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
TSM.L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
TSM.L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
TSM.L["Misplaced comma"] = "Coma fuera de lugar"
--[[Translation missing --]]
TSM.L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "Modificadores:"
TSM.L["Money Frame Open"] = "Marco de dinero abierto"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
TSM.L["MOVE"] = "MOVER"
--[[Translation missing --]]
TSM.L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
TSM.L["MOVING"] = "MOVING"
--[[Translation missing --]]
TSM.L["Moving"] = "Moving"
--[[Translation missing --]]
TSM.L["Multiple Items"] = "Multiple Items"
--[[Translation missing --]]
TSM.L["My Auctions"] = "My Auctions"
--[[Translation missing --]]
TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
TSM.L["New Group"] = "Nuevo grupo"
TSM.L["New Operation"] = "Nueva Operación"
--[[Translation missing --]]
TSM.L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
TSM.L["No Data"] = "Sin Datos"
--[[Translation missing --]]
TSM.L["No group selected"] = "No group selected"
--[[Translation missing --]]
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
TSM.L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
TSM.L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
TSM.L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
--[[Translation missing --]]
TSM.L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
TSM.L["No Profession Selected"] = "No Profession Selected"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Sin perfil especificado. Posibles perfiles: '%s'"
--[[Translation missing --]]
TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
TSM.L["No Sound"] = "Sin sonido"
TSM.L["None"] = "Ninguno"
TSM.L["None (Always Show)"] = "Ninguno (Mostrar siempre)"
TSM.L["None Selected"] = "Sin Seleccion"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
TSM.L["Normal"] = "Normal"
--[[Translation missing --]]
TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
TSM.L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
TSM.L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
TSM.L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
TSM.L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
TSM.L["NPC"] = "NPC"
--[[Translation missing --]]
TSM.L["Number Owned"] = "Number Owned"
TSM.L["of"] = "de"
TSM.L["Offline"] = "Desconectado"
--[[Translation missing --]]
TSM.L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
TSM.L["OPEN"] = "ABRIR"
--[[Translation missing --]]
TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
TSM.L["Operation"] = "Operacion"
TSM.L["Operations"] = "Operaciones"
--[[Translation missing --]]
TSM.L["Other Character"] = "Other Character"
--[[Translation missing --]]
TSM.L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
TSM.L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
TSM.L["Past Day"] = "Past Day"
--[[Translation missing --]]
TSM.L["Past Month"] = "Past Month"
--[[Translation missing --]]
TSM.L["Past Year"] = "Past Year"
--[[Translation missing --]]
TSM.L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
TSM.L["Per Item"] = "Por Objeto"
--[[Translation missing --]]
TSM.L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
TSM.L["Per Unit"] = "Per Unit"
TSM.L["Player Gold"] = "Oro de Personaje."
TSM.L["Player Invite Accept"] = "Aceptar invitación de jugador."
--[[Translation missing --]]
TSM.L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
--[[Translation missing --]]
TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
TSM.L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
TSM.L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
TSM.L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
TSM.L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
TSM.L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
TSM.L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
TSM.L["Professions Used In"] = "Professions Used In"
TSM.L["Profile changed to '%s'."] = "Perfil cambiado a '%s'."
TSM.L["Profiles"] = "Perfiles"
--[[Translation missing --]]
TSM.L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
TSM.L["Profit"] = "Profit"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
TSM.L["Purchases"] = "Purchases"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
TSM.L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
TSM.L["Quantity to move:"] = "Quantity to move:"
TSM.L["Quest Added"] = "Misión Agregada"
TSM.L["Quest Completed"] = "Misión Completada"
TSM.L["Quest Objectives Complete"] = "Objetivos de misión completados."
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
TSM.L["Raid Warning"] = "Alerta de Banda"
--[[Translation missing --]]
TSM.L["Read More"] = "Read More"
TSM.L["Ready Check"] = "Comprobación de listo"
--[[Translation missing --]]
TSM.L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
TSM.L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
TSM.L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
TSM.L["Reload"] = "Reload"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
TSM.L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
TSM.L["REPLY"] = "REPLY"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
TSM.L["Required Level"] = "Required Level"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
TSM.L["Resale"] = "Resale"
--[[Translation missing --]]
TSM.L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
TSM.L["RESET"] = "RESET"
--[[Translation missing --]]
TSM.L["Reset All"] = "Reset All"
--[[Translation missing --]]
TSM.L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
TSM.L["RESTART"] = "RESTART"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
TSM.L["Sale"] = "Sale"
--[[Translation missing --]]
TSM.L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
TSM.L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
TSM.L["Sales"] = "Sales"
--[[Translation missing --]]
TSM.L["SALES"] = "SALES"
--[[Translation missing --]]
TSM.L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
TSM.L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
TSM.L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
TSM.L["Search"] = "Search"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
TSM.L["Search Groups"] = "Search Groups"
--[[Translation missing --]]
TSM.L["Search Inbox"] = "Search Inbox"
--[[Translation missing --]]
TSM.L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
TSM.L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
TSM.L["Select Action"] = "Select Action"
TSM.L["Select All Groups"] = "Seleccionar todos los grupos"
--[[Translation missing --]]
TSM.L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
TSM.L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
TSM.L["Select Duration"] = "Select Duration"
--[[Translation missing --]]
TSM.L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
TSM.L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
TSM.L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
TSM.L["Select professions"] = "Select professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
TSM.L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
TSM.L["Sell"] = "Sell"
--[[Translation missing --]]
TSM.L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
TSM.L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
TSM.L["Sell to Vendor"] = "Vender al vendedor"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
TSM.L["Seller"] = "Seller"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
TSM.L["Send"] = "Send"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
TSM.L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
TSM.L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
TSM.L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
TSM.L["Send Money"] = "Send Money"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
TSM.L["SENDING"] = "SENDING"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
TSM.L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
TSM.L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "Fragmentos"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
TSM.L["Show Description"] = "Show Description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
TSM.L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
TSM.L["Simple"] = "Sencillo"
--[[Translation missing --]]
TSM.L["SKIP"] = "SKIP"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
TSM.L["Slash Commands:"] = "Comandos de Diagonal:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
--[[Translation missing --]]
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
TSM.L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
TSM.L["Sold"] = "Sold"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
TSM.L["Sources"] = "Fuentes"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
TSM.L["Stack"] = "Stack"
--[[Translation missing --]]
TSM.L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
TSM.L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
TSM.L["STOP"] = "STOP"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
TSM.L["Subject"] = "Subject"
--[[Translation missing --]]
TSM.L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
--[[Translation missing --]]
TSM.L["Switch to WoW UI"] = "Switch to WoW UI"
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Error de configuración de sincronización: el jugador especificado en la otra cuenta no está en línea."
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Error de configuración de sincronización: este personaje ya es parte de una cuenta enlazada."
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Error de configuración de sincronización: ingresó el nombre del personaje actual y no el personaje de la otra cuenta."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
TSM.L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
TSM.L["Target Character"] = "Target Character"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
TSM.L["Text (%s)"] = "Texto (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "La fuente de precio 'disenchant' ha sido reemplazada por la fuente más general 'destroy'. Por favor actualice sus precios personalizados."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "El nombre SÓLO puede contener letras. Sin espacios, números o caracteres especiales."
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Este no es un nombre de perfil válido. Los nombres de perfil deben tener al menos un carácter y no contener caracteres '@'."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
TSM.L["This looks like an exported operation and not a custom price."] = "Esto parece una operación exportada y no un precio personalizado."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
TSM.L["Time"] = "Time"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
--[[Translation missing --]]
TSM.L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
TSM.L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
TSM.L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
TSM.L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
TSM.L["Top Sellers:"] = "Top Sellers:"
TSM.L["Total"] = "Total"
--[[Translation missing --]]
TSM.L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
TSM.L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
TSM.L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
TSM.L["Total Price"] = "Total Price"
--[[Translation missing --]]
TSM.L["Total Profit:"] = "Total Profit:"
TSM.L["Total Value"] = "Valor total"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
TSM.L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "Información de la versión de TSM:"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
TSM.L["TUJ 3-Day Price"] = "TUJ Precio de 3 días"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "Integración de Twitter"
--[[Translation missing --]]
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
--[[Translation missing --]]
TSM.L["Type Something"] = "Type Something"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "Paréntesis desequilibrado."
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
TSM.L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
TSM.L["Unknown Item"] = "Unknown Item"
TSM.L["Unwrap Gift"] = "Desenvolver el regalo"
TSM.L["Up"] = "Arriba"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
--[[Translation missing --]]
TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Uso: /tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
TSM.L["Vendor"] = "Vendedor"
--[[Translation missing --]]
TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
TSM.L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "ADVERTENCIA: La macro era demasiado larga, por lo que WoW lo recorto para que cupiera."
--[[Translation missing --]]
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
TSM.L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
TSM.L["When below minimum:"] = "When below minimum:"
--[[Translation missing --]]
TSM.L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
TSM.L["Whitelisted Players"] = "Whitelisted Players"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "No puede usar %s  como parte de este precio personalizado."
TSM.L["You cannot use %s within convert() as part of this custom price."] = "No puede usar %s  dentro de convert() como parte de este precio personalizado."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Debe volver a cargar su Interfaz para que esta configuración surta efecto. Recargar ahora?"
TSM.L["You won an auction for %sx%d for %s"] = "Ganaste una subasta por %sx%d por %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
TSM.L["Your auction of %s has sold for %s!"] = "¡Tu subasta de %s se ha vendido por %s!"
--[[Translation missing --]]
TSM.L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
TSM.L["You've been undercut."] = "You've been undercut."
	elseif locale == "frFR" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Sélectionné (%d |4Item:Items;)"
TSM.L["%d auctions"] = "%d enchères"
TSM.L["%d Groups"] = "%d Groupes"
TSM.L["%d Items"] = "%d Objets"
TSM.L["%d of %d"] = "%d de %d"
TSM.L["%d Operations"] = "%d Opérations"
TSM.L["%d Posted Auctions"] = "%d Enchères publiées"
TSM.L["%d Sold Auctions"] = "%d Enchères vendues"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s sacs, %s banque, %s HV, %s courrier)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s joueur, %s alts, %s guilde, %s AH)"
TSM.L["%s (%s profit)"] = "%s (%s gain)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
TSM.L["%s ago"] = "%s depuis"
TSM.L["%s Crafts"] = "%s Artisanat"
TSM.L["%s group updated with %d items and %d materials."] = "Groupe %s mis à jour avec %d articles et %d matériaux."
TSM.L["%s in guild vault"] = "%s dans la banque de guilde"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s est un prix personnalisé valide mais %s est un objet invalide."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s est un prix personnalisé valide mais ne donne aucune valeur pour %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' c'est une opération invalide! Le stock minimum de %d est plus élevé que le stock maximum de %d"
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s est un prix personnalisé invalide car il affiche cette erreur : %s"
TSM.L["%s Operations"] = "%s Opérations"
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s avait auparavant le nombre maximal d'opérations, donc supprimé %s."
TSM.L["%s removed."] = "%s supprimé."
TSM.L["%s sent you %s"] = "%s vous a envoyé %s"
TSM.L["%s sent you %s and %s"] = "%s vous a envoyé %s et %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s vous a envoyé un courrier C.R. de %s pour %s"
TSM.L["%s sent you a message: %s"] = "%s vous a envoyé un message %s"
TSM.L["%s total"] = "%s au total"
TSM.L["%sDrag%s to move this button"] = "%sFaites glisser%s pour déplacer ce bouton"
TSM.L["%sLeft-Click%s to open the main window"] = "%sClic gauche%s pour ouvrir la fenêtre principale"
TSM.L["(%d/500 Characters)"] = "(%d/500 Personnages)"
TSM.L["(max %d)"] = "(max %d)"
TSM.L["(max 5000)"] = "(max 5000)"
TSM.L["(min %d - max %d)"] = "(min %d - max %d)"
TSM.L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(minimum 0 - maximum 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(minimum 0 - maximum 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(minimum 0 - maximum 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(minimum 0.5 - maximum 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Afficher cette liste d'aide"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - Ouvrir la fenêtre principale de TSM."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r Lors de la dernière sauvegarde de TSM_Accounting dans ce royaume, WoW était trop volumineux pour être traité, de sorte que les anciennes données étaient automatiquement supprimées afin d'éviter toute corruption des variables sauvegardées. Les derniers %s de données d’achat ont été préservés."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r Lors de la dernière sauvegarde de TSM_Accounting dans ce royaume, WoW était trop volumineux pour être traité, de sorte que les anciennes données étaient automatiquement supprimées afin d'éviter toute corruption des variables sauvegardées. Les derniers %s des données de vente ont été préservés."
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Clic gauche|r pour ignorer un élément de cette session. Maintenir |cffffd839Shift|r pour ignorer de manière permanente. Vous pouvez supprimer des éléments ignorés de façon permanente dans les paramètres de vente."
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Clic gauche|r pour ignorer un élément de cette session."
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Clic gauche|r pour ignorer un élément de façon permanente."
TSM.L["1 Group"] = "1 Groupe"
TSM.L["1 Item"] = "1 Objet"
TSM.L["12 hr"] = "12 h"
TSM.L["24 hr"] = "24 h"
TSM.L["48 hr"] = "48 h"
TSM.L["A custom price of %s for %s evaluates to %s."] = "Un prix personnalisé de %s pour %s évalué à %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Un maximum d'une fonction convert() est autorisé."
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "Un profil portant ce nom existe déjà sur le compte cible. Renommez-le d'abord et réessayez."
TSM.L["A profile with this name already exists."] = "Un profil portant ce nom existe déjà."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "Un scan est en cours actuellement. Arrêtez le scan avant d'en démarrer un nouveau."
TSM.L["Above max expires."] = "Prix maxi ci-dessus."
TSM.L["Above max price. Not posting."] = "Prix maxi ci-dessus. Enchère non créée."
TSM.L["Above max price. Posting at max price."] = "Prix maxi ci-dessus. Créer enchère au prix max."
TSM.L["Above max price. Posting at min price."] = "Prix maxi ci-dessus. Créer enchère au prix min."
TSM.L["Above max price. Posting at normal price."] = "Prix maxi ci-dessus. Créer enchère au prix normal."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "La synchronisation de compte a été supprimée. Supprimez également la synchronisation de compte de l'autre compte."
TSM.L["Account Syncing"] = "Synchronisation de compte"
TSM.L["Accounting"] = "Accounting"
TSM.L["Accounting Tooltips"] = "Info-bulles d'Accounting"
TSM.L["Activity Type"] = "Type d'activité"
TSM.L["ADD %d ITEMS"] = "AJOUTER %d ARTICLES"
TSM.L["Add / Remove Items"] = "Ajouter / Supprimer des articles"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "AJOUTER UNE NOUVELLE SOURCE DE PRIX PERSONNALISÉS"
TSM.L["ADD OPERATION"] = "AJOUTER L'OPÉRATION"
TSM.L["Add Player"] = "Ajouter un joueur"
TSM.L["Add Subject / Description"] = "Ajouter un sujet / Description"
TSM.L["Add Subject / Description (Optional)"] = "Ajouter un sujet / une description (facultatif)"
TSM.L["ADD TO MAIL"] = "AJOUTER AU MAIL"
TSM.L["Added '%s' profile which was received from %s."] = "Le profil '%s' ajouté a été reçu de %s."
TSM.L["Added %s to %s."] = "Ajout de %s à %s."
TSM.L["Additional error suppressed"] = "Erreur(s) additionelle(s) supprimée(s)"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Ajustez les paramètres ci-dessous pour définir le mode de vente aux enchères des groupes liés à cette opération."
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Ajustez les paramètres ci-dessous pour définir le mode d'annulation des groupes liés à cette opération."
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Ajustez les paramètres ci-dessous pour définir le prix des groupes liés à cette opération."
TSM.L["Advanced Item Search"] = "Recherche avancée d'objet"
TSM.L["Advanced Options"] = "Options avancées"
TSM.L["AH"] = "HV"
TSM.L["AH (Crafting)"] = "HV (Artisanale)"
TSM.L["AH (Disenchanting)"] = "HV (Désenchantement)"
TSM.L["AH BUSY"] = "HV OCCUPÉE"
TSM.L["AH Frame Options"] = "HV Panneau des options"
TSM.L["Alarm Clock"] = "Alarme"
TSM.L["All Auctions"] = "Toutes les enchères"
TSM.L["All Characters and Guilds"] = "Tous les personnages et Guildes"
TSM.L["All Item Classes"] = "Toutes les classes d'objets"
TSM.L["All Professions"] = "Tous les métiers"
TSM.L["All Subclasses"] = "Toutes les sous-classes"
TSM.L["Allow partial stack?"] = "Autoriser les piles partielles ?"
TSM.L["Alt Guild Bank"] = "Banque de guilde du reroll"
TSM.L["Alts"] = "Reroll"
TSM.L["Alts AH"] = "AH des rerolls"
TSM.L["Amount"] = "Montant"
TSM.L["AMOUNT"] = "MONTANT"
TSM.L["Amount of Bag Space to Keep Free"] = "Quantité d'espace de sac à garder libre"
TSM.L["APPLY FILTERS"] = "APPLIQUER LES FILTRES"
TSM.L["Apply operation to group:"] = "Appliquer l'opération au groupe:"
TSM.L["Are you sure you want to clear old accounting data?"] = "Êtes-vous sûr de vouloir effacer les anciennes données d'accounting?"
TSM.L["Are you sure you want to delete this group?"] = "Êtes-vous sûr de vouloir supprimer ce groupe?"
TSM.L["Are you sure you want to delete this operation?"] = "Êtes-vous sûr de vouloir supprimer cette opération?"
TSM.L["Are you sure you want to reset all operation settings?"] = "Êtes-vous sûr de vouloir réinitialiser tous les paramètres de fonctionnement?"
TSM.L["At above max price and not undercut."] = "Au-dessus du prix max et pas en dessous."
TSM.L["At normal price and not undercut."] = "Au prix normal et non pas en dessous."
TSM.L["Auction"] = "Enchères"
TSM.L["Auction Bid"] = "offre de l’enchère"
TSM.L["Auction Buyout"] = "Achat aux enchères"
TSM.L["AUCTION DETAILS"] = "DÉTAILS DE L’ENCHÈRE"
TSM.L["Auction Duration"] = "Durée de l'enchère"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
TSM.L["Auction House Cut"] = "Hotel de vente coupée"
TSM.L["Auction Sale Sound"] = "Son de la mise en enchères"
TSM.L["Auction Window Close"] = "Fermer la fenêtre d’enchère"
TSM.L["Auction Window Open"] = "Ouvrir la fenêtre d’enchère"
TSM.L["Auctionator - Auction Value"] = "Auctionator - Valeur de l'enchère"
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Valeur marchande"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Expertise"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - Valeur du marché"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Achat minimum"
TSM.L["Auctioning"] = "Mise aux Enchères"
TSM.L["Auctioning Log"] = "Historique des mises aux enchères"
TSM.L["Auctioning Operation"] = "Opération de vente aux enchères"
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Mise aux enchères bouton 'POST' / 'ANNULER'"
TSM.L["Auctioning Tooltips"] = "Info-bulles des enchères"
TSM.L["Auctions"] = "Enchères"
TSM.L["Auto Quest Complete"] = "Rendre les quêtes automatiquement"
TSM.L["Average Earned Per Day:"] = "Moyenne gagnée par jour:"
TSM.L["Average Prices:"] = "Prix moyens:"
TSM.L["Average Profit Per Day:"] = "Bénéfice moyen par jour:"
TSM.L["Average Spent Per Day:"] = "Moyenne des dépenses par jour:"
TSM.L["Avg Buy Price"] = "Prix d'achat moyen"
TSM.L["Avg Resale Profit"] = "Bénéfice moyen de revente"
TSM.L["Avg Sell Price"] = "Prix de vente moyen"
TSM.L["BACK"] = "RETOUR"
TSM.L["BACK TO LIST"] = "RETOUR À LA LISTE"
TSM.L["Back to List"] = "Retour à la liste"
TSM.L["Bag"] = "Sac"
TSM.L["Bags"] = "Sacs"
TSM.L["Banks"] = "Banques"
TSM.L["Base Group"] = "Groupe par défaut"
TSM.L["Base Item"] = "Élément de base"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Ci-dessous sont organisées les source de prix disponibles par module. La %skey|r serait ce que vous taperiez dans un champ de prix personnalisé."
TSM.L["Below custom price:"] = "En dessous du prix personnalisé:"
TSM.L["Below min price. Posting at max price."] = "En dessous du prix min. Posté au prix max."
TSM.L["Below min price. Posting at min price."] = "En dessous du prix min. posté au prix min."
TSM.L["Below min price. Posting at normal price."] = "En dessous du prix min. Posté au prix normal."
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Ci-dessous, vous pouvez gérer vos profils, ce qui vous permet d’avoir des ensembles de groupes entièrement différents."
TSM.L["BID"] = "OFFRE"
TSM.L["Bid %d / %d"] = "Offre %d / %d"
TSM.L["Bid (item)"] = "Offre (acticle)"
TSM.L["Bid (stack)"] = "Offre (pile)"
TSM.L["Bid Price"] = "Prix de l'offre"
TSM.L["Bid Sniper Paused"] = "Sniper d'enchères en pause"
TSM.L["Bid Sniper Running"] = "Sniper d'enchères démarré"
TSM.L["Bidding Auction"] = "Offre aux enchères"
TSM.L["Blacklisted players:"] = "Joueurs sur la liste noire:"
TSM.L["Bought"] = "Acheté"
TSM.L["Bought %d of %s from %s for %s"] = "A acheté %d de %s à %s pour %s"
TSM.L["Bought %sx%d for %s from %s"] = "A acheté %sx%d pour %s à %s"
TSM.L["Bound Actions"] = "Actions liées"
TSM.L["BUSY"] = "OCCUPÉE"
TSM.L["BUY"] = "ACHETER"
TSM.L["Buy"] = "Acheter"
TSM.L["Buy %d / %d"] = "Achetez %d / %d"
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Achetez %d  /%d (Confirmant %d / %d)"
TSM.L["Buy from AH"] = "Acheter à HV"
TSM.L["Buy from Vendor"] = "Acheter au marchand"
TSM.L["BUY GROUPS"] = "ACHETER LES GROUPES"
TSM.L["Buy Options"] = "Options d'achat"
TSM.L["BUYBACK ALL"] = "TOUT ACHETER"
TSM.L["Buyer/Seller"] = "Acheteur/Vendeur"
TSM.L["BUYOUT"] = "ACHETER"
TSM.L["Buyout (item)"] = "Acheter (item)"
TSM.L["Buyout (stack)"] = "Acheter (pile)"
TSM.L["Buyout Confirmation Alert"] = "Alerte de confirmation de rachat"
TSM.L["Buyout Price"] = "Prix de rachat"
TSM.L["Buyout Sniper Paused"] = "Sniper de rachat en pause"
TSM.L["Buyout Sniper Running"] = "Sniper en cours d'exécution"
TSM.L["BUYS"] = "ACHETER"
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Par défaut, ce groupe héberge tous les éléments non affectés à un groupe. Vous ne pouvez pas modifier ou supprimer ce groupe."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
TSM.L["Cancel Scan"] = "Annuler le scan"
TSM.L["Cancel to repost higher?"] = "Annuler pour recréer plus haut?"
TSM.L["Cancel undercut auctions?"] = "Annuler les enchères sous-coté?"
TSM.L["Canceling"] = "Annuler"
TSM.L["Canceling %d / %d"] = "Annulation %d / %d"
TSM.L["Canceling %d Auctions..."] = "Annulation des %d enchères ..."
TSM.L["Canceling all auctions."] = "Annuler toutes les enchères."
TSM.L["Canceling auction which you've undercut."] = "Annulation d'enchères que vous avez sous-cotées."
TSM.L["Canceling disabled."] = "Annulation désactivée."
TSM.L["Canceling Settings"] = "Annuler les paramètres"
TSM.L["Canceling to repost at higher price."] = "Annuler pour recréer à un prix plus élevé."
TSM.L["Canceling to repost at reset price."] = "Annuler pour recréer au prix initial."
TSM.L["Canceling to repost higher."] = "Annuler pour recréer plus haut."
TSM.L["Canceling undercut auctions and to repost higher."] = "Annuler les enchères en sous-traitance et recréer plus haut."
TSM.L["Canceling undercut auctions."] = "Annuler des enchères sous-coté."
TSM.L["Cancelled"] = "Annulé"
TSM.L["Cancelled auction of %sx%d"] = "Annuler la vente aux enchères de %sx%d"
TSM.L["Cancelled Since Last Sale"] = "Annulé depuis la dernière vente"
TSM.L["CANCELS"] = "ANNULE"
TSM.L["Cannot repair from the guild bank!"] = "Impossible de réparer depuis la banque de guilde!"
TSM.L["Can't load TSM tooltip while in combat"] = "Ne pas charger l'infobulle TSM pendant le combat"
TSM.L["Cash Register"] = "Caisse"
TSM.L["CHARACTER"] = "PERSONNAGE"
TSM.L["Character"] = "Personnage"
TSM.L["Chat Tab"] = "Onglet Chat"
TSM.L["Cheapest auction below min price."] = "Meilleure enchère en dessous du prix minimum."
TSM.L["Clear"] = "Effacer"
TSM.L["Clear All"] = "Tout effacer"
TSM.L["CLEAR DATA"] = "EFFACER LES DONNÉES"
TSM.L["Clear Filters"] = "Effacer les filtres"
TSM.L["Clear Old Data"] = "Effacer les anciennes données"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
TSM.L["Clear Queue"] = "Effacer la file d'attente"
TSM.L["Clear Selection"] = "Effacer la sélection"
TSM.L["COD"] = "C.R."
TSM.L["Coins (%s)"] = "Pièces (%s)"
TSM.L["Collapse All Groups"] = "Réduire tous les groupes"
TSM.L["Combine Partial Stacks"] = "Combiner des piles partielles"
--[[Translation missing --]]
TSM.L["Combining..."] = "Combining..."
TSM.L["Configuration Scroll Wheel"] = "configuration de la molette de défilement"
TSM.L["Confirm"] = "Confirmer"
TSM.L["Confirm Complete Sound"] = "Confirmer le son complet"
TSM.L["Confirming %d / %d"] = "Confirmation de %d / %d"
TSM.L["Connected to %s"] = "Connecté à %s"
TSM.L["Connecting to %s"] = "Connexion à %s"
TSM.L["CONTACTS"] = "CONTACTS"
TSM.L["Contacts Menu"] = "Menu des contacts"
TSM.L["Cooldown"] = "Cooldown"
TSM.L["Cooldowns"] = "Cooldowns"
TSM.L["Cost"] = "Coût"
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Impossible de créer une macro car vous en avez déjà trop. Supprimez l'une de vos macros existantes et réessayez."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Profil '%s' introuvable. Profils possibles: '%s'"
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Impossible de vendre des articles en raison du manque d'espace libre dans votre sac pour séparer une pile d'articles."
TSM.L["Craft"] = "Artisanat"
TSM.L["CRAFT"] = "ARTISANAT"
TSM.L["Craft (Unprofitable)"] = "Artisanat (non rentable)"
TSM.L["Craft (When Profitable)"] = "Artisanat (rentable)"
TSM.L["Craft All"] = "Fabriquer tout"
TSM.L["CRAFT ALL"] = "FABRIQUER TOUT"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
TSM.L["CRAFT NEXT"] = "FABRIQUER LE SUIVANT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
TSM.L["CRAFTER"] = "ARTISAN"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Fabriquer avec le bouton 'FABRIQUER LE SUIVANT'"
TSM.L["Crafting Queue"] = "File d'attente d'artisanat"
TSM.L["Crafting Tooltips"] = "Info-bulles d’artisanat"
TSM.L["Crafts"] = "Artisanat"
TSM.L["Crafts %d"] = "Artisanat %d"
TSM.L["CREATE MACRO"] = "CRÉER MACRO"
TSM.L["Create New Operation"] = "Créer  une Nouvelle Opération"
TSM.L["CREATE NEW PROFILE"] = "CRÉER UN NOUVEAU PROFIL"
TSM.L["Create Profession Group"] = "Créer un groupe de professions"
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Source de prix personnalisée créée: |cff99ffff%s|r"
TSM.L["Crystals"] = "Cristaux"
TSM.L["Current Profiles"] = "Profils actuels"
TSM.L["CURRENT SEARCH"] = "RECHERCHE ACTUELLE"
TSM.L["CUSTOM POST"] = "MISE AUX ENCHÈRES PERSONNALISÉ"
TSM.L["Custom Price"] = "Prix personnalisé"
TSM.L["Custom Price Source"] = "Source de prix spécifique"
TSM.L["Custom Sources"] = "Source personnalisé"
TSM.L["Database Sources"] = "Sources de la base de données"
TSM.L["Default Craft Value Method:"] = "Méthode de valeur de l'artisanat par défaut:"
TSM.L["Default Material Cost Method:"] = "Méthode de coût des matériaux par défaut:"
TSM.L["Default Price"] = "Prix par défaut"
TSM.L["Default Price Configuration"] = "Configuration des prix par défaut"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
TSM.L["Delete this record?"] = "Supprimer cet enregistrement ?"
TSM.L["Deposit"] = "Dépôt"
TSM.L["Deposit Cost"] = "Coût du dépôt"
TSM.L["Deposit Price"] = "Prix du dépôt"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "Déselectionner tous les groupes"
TSM.L["Deselect All Items"] = "Désélectionner tous les objets"
TSM.L["Destroy Next"] = "Détruire le suivant"
TSM.L["Destroy Value"] = "Détruire Valeur"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
TSM.L["Destroying"] = "Détruire"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
TSM.L["Destroying Tooltips"] = "Info-bulle de destruction"
TSM.L["Destroying..."] = "Destruction..."
--[[Translation missing --]]
TSM.L["Details"] = "Details"
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "N'a pas annulé %s car votre seuil d'annulation pour remettre aux enchères (%s) n'est pas valide. Vérifiez vos paramètres."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
TSM.L["Display market value"] = "Afficher la valeur du marché"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
TSM.L["Display min buyout"] = "Afficher le prix de rachat min"
--[[Translation missing --]]
TSM.L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
TSM.L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
TSM.L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
TSM.L["Display vendor buy price"] = "Afficher le prix d'achat du vendeur"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
TSM.L["Done Scanning"] = "Faire le scan"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
TSM.L["DOWN"] = "DOWN"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
TSM.L["Duplicate"] = "Dupliqué"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "Poussière"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
TSM.L["EMPTY BAGS"] = "SACS VIDES"
TSM.L["Empty parentheses are not allowed"] = "Les parenthèses vides ne sont pas autorisées"
TSM.L["Empty price string."] = "Chaine de prix vide."
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
TSM.L["Enable buying?"] = "Permettre l'achat ?"
--[[Translation missing --]]
TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
TSM.L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
TSM.L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
TSM.L["Enter Filter"] = "Entrer un filtre"
TSM.L["Enter Keyword"] = "Entrer un mot-clé"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
TSM.L["Enter player name"] = "Entrer le nom d'un joueur"
TSM.L["Essences"] = "Essences"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Connexion en cours avec %s. Assurez-vous d'avoir bien entré le nom de ce personnage sur l'autre compte."
TSM.L["Estimated Cost:"] = "Coût estimé :"
TSM.L["Estimated deliver time"] = "Temps de livraison estimé"
TSM.L["Estimated Profit:"] = "Bénéfice estimé :"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
TSM.L["Expenses"] = "Frais"
TSM.L["EXPENSES"] = "FRAIS"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
TSM.L["Expired"] = "Expiré"
TSM.L["Expired Auctions"] = "Enchères expirées"
TSM.L["Expired Since Last Sale"] = "Expiré depuis la dernière vente"
TSM.L["Expires"] = "Expire"
TSM.L["EXPIRES"] = "EXPIRE"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "Exploration"
--[[Translation missing --]]
TSM.L["Export"] = "Export"
--[[Translation missing --]]
TSM.L["Export List"] = "Export List"
TSM.L["Failed Auctions"] = "Enchères échouées"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
TSM.L["Failed to buy auction of %s."] = "Échec de l'achat de l'enchère de %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
TSM.L["Favorite Scans"] = "Scans favoris"
TSM.L["Favorite Searches"] = "Recherches favorites"
TSM.L["Filter Auctions by Duration"] = "Filtrer les enchères par durée"
TSM.L["Filter Auctions by Keyword"] = "Filtrer les enchères par mot-clé"
TSM.L["Filter by Keyword"] = "Filtrer par mot-clé"
TSM.L["FILTER BY KEYWORD"] = "FILTRER PAR MOT-CLÉ"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
TSM.L["Filter Items"] = "Filtrer les objets"
--[[Translation missing --]]
TSM.L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
--[[Translation missing --]]
TSM.L["Fishing Reel In"] = "Fishing Reel In"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
TSM.L["Friends"] = "Amis"
--[[Translation missing --]]
TSM.L["From"] = "From"
TSM.L["Full"] = "Plein"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "Options générales"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
TSM.L["Gold"] = "Or"
TSM.L["Gold Earned:"] = "Or gagné :"
--[[Translation missing --]]
TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
TSM.L["Gold Spent:"] = "Or dépensé :"
TSM.L["GREAT DEALS SEARCH"] = "RECHERCHE DE BONNES AFFAIRES"
TSM.L["Group already exists."] = "Le groupe existe déjà."
TSM.L["Group Management"] = "Gestion des groupes"
TSM.L["Group Operations"] = "Opérations de groupe"
TSM.L["Group Settings"] = "Paramètres de groupe"
TSM.L["Grouped Items"] = "Objets groupés"
TSM.L["Groups"] = "Groupes"
TSM.L["Guild"] = "Guilde"
TSM.L["Guild Bank"] = "Banque de guilde"
TSM.L["GVault"] = "BanqueDeGuilde"
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
TSM.L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
TSM.L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
TSM.L["Historical Price"] = "Historique des prix"
TSM.L["Hold ALT to repair from the guild bank."] = "Maintenir ALT pour réparer à partir d'une banque de guilde."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Je viens de vendre [%s] pour %s ! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
--[[Translation missing --]]
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
TSM.L["Ignore Auctions Below Min"] = "Ignorer les enchères sous le minimum"
TSM.L["Ignore auctions by duration?"] = "Ignorer les enchères par durée ?"
TSM.L["Ignore Characters"] = "Ignorer les personnages"
TSM.L["Ignore Guilds"] = "Ignorer les guildes"
TSM.L["Ignore item variations?"] = "Ignorer les variations de l'objet ?"
TSM.L["Ignore operation on characters:"] = "Ignorer l'opération sur les personnages :"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
TSM.L["Ignored Cooldowns"] = "Temps de recharge ignorés"
TSM.L["Ignored Items"] = "Objets ignorés"
TSM.L["ilvl"] = "ilvl"
--[[Translation missing --]]
TSM.L["Import"] = "Import"
--[[Translation missing --]]
TSM.L["IMPORT"] = "IMPORT"
--[[Translation missing --]]
TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
TSM.L["Imported Items"] = "Objets importés"
--[[Translation missing --]]
TSM.L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
TSM.L["Information"] = "Information"
TSM.L["Invalid custom price entered."] = "Prix personnalisé renseigné invalide."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
TSM.L["Invalid custom price."] = "Prix spécifique invalide."
TSM.L["Invalid function."] = "Fonction invalide."
TSM.L["Invalid gold value."] = "Valeur d'or invalide."
TSM.L["Invalid group name."] = "Nom de groupe invalide."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "Lien de l'objet invalide."
TSM.L["Invalid operation name."] = "Nom d'opération invalide."
--[[Translation missing --]]
TSM.L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
TSM.L["Invalid parameter to price source."] = "Paramètre invalide dans la formule du prix"
TSM.L["Invalid player name."] = "Nom de joueur invalide."
--[[Translation missing --]]
TSM.L["Invalid price source in convert."] = "Invalid price source in convert."
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
TSM.L["Invalid search filter"] = "Filtre de recherche invalide"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
TSM.L["Invalid word: '%s'"] = "Mot invalide: '%s'"
TSM.L["Inventory"] = "Inventaire"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
TSM.L["Inventory Options"] = "Options de l'inventaire"
TSM.L["Inventory Tooltip Format"] = "Format de l'info-bulle de l'inventaire"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "Objet"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
TSM.L["Item Level"] = "Niveau de l'objet"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Item links may only be used as parameters to price sources."] = "Item links may only be used as parameters to price sources."
TSM.L["Item Name"] = "Nom de l'objet"
TSM.L["Item Quality"] = "Qualité de l'objet"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
TSM.L["Item Value"] = "Valeur de l'objet"
TSM.L["Item/Group is invalid (see chat)."] = "L'Objet/Groupe est invalide (voir le tchat)."
TSM.L["ITEMS"] = "OBJETS"
TSM.L["Items"] = "Objets"
TSM.L["Items in Bags"] = "Objets dans les sacs"
TSM.L["Keep in bags quantity:"] = "Quantité gardée dans les sacs :"
TSM.L["Keep in bank quantity:"] = "Quantité gardée dans la banque :"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
TSM.L["Keep quantity:"] = "Quantité gardée:"
TSM.L["Keep this amount in bags:"] = "Garder ce montant dans les sacs :"
TSM.L["Keep this amount:"] = "Garder ce montant :"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
TSM.L["Last 14 Days"] = "14 derniers jours"
TSM.L["Last 3 Days"] = "3 derniers jours"
TSM.L["Last 30 Days"] = "30 derniers jours"
TSM.L["LAST 30 DAYS"] = "30 DERNIERS JOURS"
TSM.L["Last 60 Days"] = "60 derniers jours"
TSM.L["Last 7 Days"] = "7 derniers jours"
TSM.L["LAST 7 DAYS"] = "7 DERNIERS JOURS"
TSM.L["Last Data Update:"] = "Dernière MAJ des données :"
TSM.L["Last Purchased"] = "Dernier acheté"
TSM.L["Last Sold"] = "Dernier vendu"
TSM.L["Level Up"] = "Niveau supérieur"
--[[Translation missing --]]
TSM.L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
TSM.L["List"] = "List"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
TSM.L["Loading Mails..."] = "Chargement du courrier..."
TSM.L["Loading..."] = "Chargement..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Il semblerait que TradeSkillMaster ai rencontré une erreur. Merci d'aider les développeurs à la corriger en suivant les instructions affichées."
TSM.L["Loop detected in the following custom price:"] = "Boucle détectée pour le prix spécifique suivant :"
TSM.L["Lowest auction by whitelisted player."] = "Dernière enchère par joueur autorisé."
--[[Translation missing --]]
TSM.L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
TSM.L["Macro Setup"] = "Configuration de la Macro"
TSM.L["Mail"] = "Mail"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
TSM.L["Main Settings"] = "Paramètres principaux"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
TSM.L["Management Options"] = "Management Options"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
TSM.L["Map Ping"] = "Map Ping"
TSM.L["Market Value"] = "Valeur marchande"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
TSM.L["Materials"] = "Matériaux"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
TSM.L["Max Buy Price"] = "Prix d'achat max"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
TSM.L["Max Sell Price"] = "Prix de vente max"
TSM.L["Max Shopping Price"] = "Prix d'achat max"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "QUANTITÉ MAXIMALE À ACHETER :"
TSM.L["Maximum quantity:"] = "Quantité maximum :"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
TSM.L["Min"] = "Min"
TSM.L["Min Buy Price"] = "Prix d'achat min"
TSM.L["Min Buyout"] = "Prix de rachat min"
TSM.L["Min Sell Price"] = "Prix de vente min"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
TSM.L["Minimum profit:"] = "Bénéfice minimum :"
TSM.L["MINIMUM RARITY"] = "RARETÉ MINIMUM"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
TSM.L["Misplaced comma"] = "Virgule mal placée"
TSM.L["Missing Materials"] = "Matériaux manquants"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "Modificateurs:"
--[[Translation missing --]]
TSM.L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
TSM.L["MOVE"] = "DEPLACER"
TSM.L["Move already grouped items?"] = "Déplacer les objets déjà groupés ?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
TSM.L["MOVE TO BAGS"] = "DEPLACER VERS LES SACS"
TSM.L["MOVE TO BANK"] = "DEPLACER VERS LA BANQUE"
TSM.L["MOVING"] = "EN DÉPLACEMENT"
TSM.L["Moving"] = "En déplacement"
TSM.L["Multiple Items"] = "Plusieurs objets"
TSM.L["My Auctions"] = "Mes Enchères"
TSM.L["My Auctions 'CANCEL' Button"] = "Bouton \"ANNULER\" de mes enchères"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
TSM.L["New Group"] = "Nouveau groupe"
TSM.L["New Operation"] = "Nouvelle opération"
TSM.L["NEWS AND INFORMATION"] = "NOUVELLES ET INFORMATION"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
TSM.L["No Data"] = "Aucune donnée"
TSM.L["No group selected"] = "Aucun groupe sélectionné"
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Aucun objet spécifié. Usage : /tsm restock_help [ITEM_LINK]"
TSM.L["NO ITEMS"] = "AUCUN OBJET"
TSM.L["No Materials to Gather"] = "Pas de matériaux à rassembler"
TSM.L["No Operation Selected"] = "Aucune opération sélectionnée"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
TSM.L["No Profession Opened"] = "Aucun métier ouvert"
TSM.L["No Profession Selected"] = "Aucun métier sélectionné"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Aucun profil spécifié. Profils possibles : '%s'"
TSM.L["No recent AuctionDB scan data found."] = "Pas de scan AuctionDB récent trouvé."
TSM.L["No Sound"] = "Pas de son"
TSM.L["None"] = "Rien"
TSM.L["None (Always Show)"] = "Aucun (toujours afficher)"
TSM.L["None Selected"] = "Aucun sélectionné"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
TSM.L["Normal"] = "Normal"
TSM.L["Not canceling auction at reset price."] = "Ne pas annuler les enchères sous le prix de réinitialisation."
TSM.L["Not canceling auction below min price."] = "Ne pas annuler les enchères sous le prix minimal."
TSM.L["Not canceling."] = "Ne pas annuler."
TSM.L["Not Connected"] = "Non connecté"
TSM.L["Not enough items in bags."] = "Pas assez d'objets dans les sacs."
TSM.L["NOT OPEN"] = "FERMÉ"
TSM.L["Not Scanned"] = "Non scanné"
TSM.L["Nothing to move."] = "Rien à déplacer."
--[[Translation missing --]]
TSM.L["NPC"] = "NPC"
TSM.L["Number Owned"] = "Nombre possédé"
--[[Translation missing --]]
TSM.L["of"] = "of"
TSM.L["Offline"] = "Hors ligne"
TSM.L["On Cooldown"] = "Sur le temps de recharge"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
TSM.L["OPEN"] = "OUVERT"
TSM.L["OPEN ALL MAIL"] = "TOUT OUVRIR"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
TSM.L["Operation"] = "Opération"
TSM.L["Operations"] = "Opérations"
TSM.L["Other Character"] = "Autre personnage"
TSM.L["Other Settings"] = "Autres paramètres"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
TSM.L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
TSM.L["Past Day"] = "Past Day"
--[[Translation missing --]]
TSM.L["Past Month"] = "Past Month"
--[[Translation missing --]]
TSM.L["Past Year"] = "Past Year"
TSM.L["Paste string here"] = "Coller du texte ici"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
TSM.L["Per Item"] = "Par objet"
TSM.L["Per Stack"] = "Par pile"
TSM.L["Per Unit"] = "Par unité"
TSM.L["Player Gold"] = "Or du joueur"
--[[Translation missing --]]
TSM.L["Player Invite Accept"] = "Player Invite Accept"
TSM.L["Please select a group to export"] = "Veuillez sélectionner un groupe à exporter"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
TSM.L["Post at Maximum Price"] = "Poster au prix maximum"
TSM.L["Post at Minimum Price"] = "Poster au prix minimum"
TSM.L["Post at Normal Price"] = "Poster au prix normal"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
TSM.L["Post Scan"] = "Poster le scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
TSM.L["Price Per Item"] = "Prix par objet"
--[[Translation missing --]]
TSM.L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
TSM.L["PROFESSION"] = "MÉTIER"
TSM.L["Profession Filters"] = "Filtres de métier"
TSM.L["Profession Info"] = "Info de métier"
TSM.L["Profession loading..."] = "Chargement de métier..."
TSM.L["Professions Used In"] = "Métiers utilisés dans"
--[[Translation missing --]]
TSM.L["Profile changed to '%s'."] = "Profile changed to '%s'."
TSM.L["Profiles"] = "Profils"
TSM.L["PROFIT"] = "BENEFICE"
TSM.L["Profit"] = "Bénéfice"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
TSM.L["PURCHASE DATA"] = "DONNÉES D'ACHAT"
TSM.L["Purchased (Min/Avg/Max Price)"] = "Acheté (Prix Min/Moyen/Max)"
TSM.L["Purchased (Total Price)"] = "Acheté (Prix total)"
TSM.L["Purchases"] = "Achats"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
TSM.L["Quantity Sold:"] = "quantité vendue :"
TSM.L["Quantity to move:"] = "Quantité à déplacer :"
TSM.L["Quest Added"] = "Quête ajoutée"
TSM.L["Quest Completed"] = "Quête terminée"
--[[Translation missing --]]
TSM.L["Quest Objectives Complete"] = "Quest Objectives Complete"
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
TSM.L["Raid Warning"] = "Alerte de Raid"
TSM.L["Read More"] = "Lire plus"
--[[Translation missing --]]
TSM.L["Ready Check"] = "Ready Check"
TSM.L["Ready to Cancel"] = "PRÊT À ANNULER"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
TSM.L["Recent Scans"] = "Scans récents"
TSM.L["Recent Searches"] = "Recherches récentes"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
TSM.L["Reload"] = "Recharger"
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "SUPPRIMER %d |4OBJET:OBJETS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
TSM.L["Rename"] = "Renommer"
TSM.L["Rename Profile"] = "Renommer le profil"
TSM.L["REPAIR"] = "RÉPARER"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
TSM.L["REPLY"] = "RÉPONDRE"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
TSM.L["Required Level"] = "Niveau requis"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
TSM.L["Resale"] = "Revendre"
TSM.L["RESCAN"] = "RESCANNER"
TSM.L["RESET"] = "RÉINITIALISER"
TSM.L["Reset All"] = "Tout réinitialiser"
TSM.L["Reset Filters"] = "Réinitialiser les filtres"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
TSM.L["RESTART"] = "REDÉMARRER"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
TSM.L["RUN ADVANCED ITEM SEARCH"] = "LANCER LA RECHERCHE AVANCÉE D'OBJETS"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
TSM.L["Run Buyout Sniper"] = "Lancer le sniper de rachat"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
TSM.L["Sale"] = "Vente"
TSM.L["SALE DATA"] = "DONNÉES DE VENTE"
TSM.L["Sale Price"] = "Prix de vente"
TSM.L["Sale Rate"] = "Taux de vente"
TSM.L["Sales"] = "Ventes"
TSM.L["SALES"] = "VENTES"
TSM.L["Sales Summary"] = "Résumé des ventes"
TSM.L["SCAN ALL"] = "TOUT SCANNER"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
TSM.L["SCANNING"] = "SCAN EN COURS"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
TSM.L["Search"] = "Recherche"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
TSM.L["Search Groups"] = "Chercher les groupes"
--[[Translation missing --]]
TSM.L["Search Inbox"] = "Search Inbox"
--[[Translation missing --]]
TSM.L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
TSM.L["Search Usable Items Only?"] = "Chercher les objets utilisables seulement ?"
TSM.L["Search Vendor"] = "Sélectionner un vendeur"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
TSM.L["Select Action"] = "Sélectionner une action"
TSM.L["Select All Groups"] = "Sélectionner tous les groupes"
TSM.L["Select All Items"] = "Sélectionner tous les objets"
TSM.L["Select Auction to Cancel"] = "Sélectionner une enchère à annuler"
TSM.L["Select crafter"] = "Sélectionnez artisan"
TSM.L["Select custom price sources to include in item tooltips"] = "Sélectionner des sources de prix personnalisées à inclure dans les info-bulles des articles"
TSM.L["Select Duration"] = "Sélectionnez la durée"
TSM.L["Select Items to Add"] = "Sélectionner les éléments à ajouter"
TSM.L["Select Items to Remove"] = "Sélectionnez les éléments à supprimer"
TSM.L["Select Operation"] = "Sélectionnez l'opération"
TSM.L["Select professions"] = "Sélectionnez des professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
TSM.L["Selected Groups"] = "Groupes sélectionnés"
TSM.L["Selected Operations"] = "Opérations sélectionnées"
TSM.L["Sell"] = "Vendre"
TSM.L["SELL ALL"] = "Tout vendre"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
TSM.L["Sell Options"] = "Options de vente"
TSM.L["Sell soulbound items?"] = "Vendre des objets liés?"
TSM.L["Sell to Vendor"] = "Vendre au vendeur"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
TSM.L["Seller"] = "Vendeur"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
TSM.L["Send"] = "Envoyer"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
TSM.L["SEND GOLD"] = "ENVOYER OR"
TSM.L["Send grouped items individually"] = "Envoyer individuellement les objets groupés"
TSM.L["SEND MAIL"] = "ENVOYER COURRIER"
TSM.L["Send Money"] = "Envoyer argent"
TSM.L["Send Profile"] = "Envoyer profil"
TSM.L["SENDING"] = "ENVOI"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
TSM.L["Sending %s to %s"] = "Envoi %s à %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
TSM.L["Sending Settings"] = "Paramètres d'envoi"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
TSM.L["SENDING..."] = "ENVOI..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "Eclats"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
TSM.L["Show Description"] = "Montrer la description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
TSM.L["Show material cost"] = "Montrer le coût du matériel"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
TSM.L["Simple"] = "Simple"
TSM.L["SKIP"] = "PASSER"
TSM.L["Skip Import confirmation?"] = "Passer la confirmation d'import ?"
TSM.L["Skipped: No assigned operation"] = "Passé : Aucune opération assignée"
TSM.L["Slash Commands:"] = "Commandes Slash:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
TSM.L["Sniper 'BUYOUT' Button"] = "Bouton 'RACHAT' du sniper"
TSM.L["Sniper Options"] = "Options du sniper"
TSM.L["Sniper Settings"] = "Paramètres du sniper"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
TSM.L["Sold"] = "Vendu"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
TSM.L["Sold (Min/Avg/Max Price)"] = "Vendu (Prix Min/Moyen/Max)"
TSM.L["Sold (Total Price)"] = "Vendu (prix total)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
TSM.L["Sold Auctions %s:"] = "Enchères vendues %s :"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
TSM.L["Sources"] = "Sources"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
TSM.L["Stack"] = "Pile"
TSM.L["Stack / Quantity"] = "Pile / Quantité"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
TSM.L["Starting Scan..."] = "Début du scan ..."
TSM.L["STOP"] = "ARRÊTER"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
TSM.L["Subject"] = "Sujet"
TSM.L["SUBJECT"] = "SUJET"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
TSM.L["Switch to WoW UI"] = "Revenir sur l'IU de WoW"
--[[Translation missing --]]
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
TSM.L["TAKE ALL"] = "PRENDRE TOUT"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
TSM.L["Target Character"] = "Personnage sélectionné"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
TSM.L["Text (%s)"] = "Texte (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
--[[Translation missing --]]
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
TSM.L["This item is not in a TSM group."] = "Cet objet n'est pas dans un groupe TSM"
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
TSM.L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
TSM.L["Time"] = "Temps"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
TSM.L["Tooltip Price Format"] = "Format du prix dans l'info-bulle"
TSM.L["Tooltip Settings"] = "Paramètre de l'info-bulle"
TSM.L["Top Buyers:"] = "Top acheteurs:"
TSM.L["Top Item:"] = "Meilleur objet :"
TSM.L["Top Sellers:"] = "Top vendeurs :"
TSM.L["Total"] = "Total"
TSM.L["Total Gold"] = "Total d'Or"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
TSM.L["Total Gold Earned:"] = "Total d'Or gagnés :"
TSM.L["Total Gold Spent:"] = "Total d'Or dépensés :"
TSM.L["Total Price"] = "Prix total"
TSM.L["Total Profit:"] = "Profit total:"
TSM.L["Total Value"] = "Valeur totale"
TSM.L["Total Value of All Items"] = "Valeur totale de tous les objets"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
TSM.L["Transform Value"] = "Valeur de transformation"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM a échoué à scanner quelques ventes. Veuillez relancer le scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM ne parvient pas à accéder à d'importantes informations de l'application de bureau TSM Desktop. Assurez-vous s'il vous plaît que TSM Desktop fonctionne et soit correctement configuré."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "Informations sur la version de TSM :"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
TSM.L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "Intégration Twitter"
TSM.L["Twitter Integration Not Enabled"] = "Intégration Twitter désactivée"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
TSM.L["Type Something"] = "Écrire quelque chose"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
--[[Translation missing --]]
TSM.L["Unbalanced parentheses."] = "Unbalanced parentheses."
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
TSM.L["Ungrouped Items"] = "Objets non-groupés"
TSM.L["Unknown Item"] = "Objet inconnu"
TSM.L["Unwrap Gift"] = "Déballer le cadeau"
--[[Translation missing --]]
TSM.L["Up"] = "Up"
TSM.L["Up to date"] = "À jour"
TSM.L["UPDATE EXISTING MACRO"] = "METTRE A JOUR LA MACRO EXISTANTE"
TSM.L["Updating"] = "Mise à jour"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Conseil d'utilisation: /tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
TSM.L["Vendor"] = "Vendeur"
TSM.L["Vendor Buy Price"] = "Prix d'achat au vendeur"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
TSM.L["Vendor Sell"] = "vendre au marchant"
TSM.L["Vendor Sell Price"] = "Prix de vente au marchant"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "ATTENTION : La macro est trop longue, elle a donc été tronquée par défaut par WoW"
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "ATTENTION : Votre prix minimum pour %s est en dessous du prix de vente au marchant (frais de dépot inclus). Envisagez d'augmenter votre prix minimum, ou vendez l'objet."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
TSM.L["When above maximum:"] = "Lorsqu'au-dessus du maximum :"
TSM.L["When below minimum:"] = "Lorsqu'en-dessous du minimum :"
TSM.L["Whitelist"] = "Liste blanche"
TSM.L["Whitelisted Players"] = "Joueurs autorisés"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "Vous ne pouvez pas utiliser %s comme prix spécifique."
--[[Translation missing --]]
TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
TSM.L["You don't know how to craft this item."] = "Vous ne savez pas fabriquer cet objet."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Vous devez recharger votre UI pour que ces paramètres soient pris en compte. Recharger maintenant ?"
TSM.L["You won an auction for %sx%d for %s"] = "Vous avez gagné une enchère pour %sx%d pour %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
TSM.L["Your auction of %s expired"] = "Votre mise aux enchères de %s est expirée."
TSM.L["Your auction of %s has sold for %s!"] = "Votre mise aux enchères de %s a été vendue pour %s !"
TSM.L["Your Buyout"] = "Votre rachat"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
TSM.L["Your task list is currently empty."] = "Votre liste de tâche est actuellement vide."
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Vous avez été mis en phase, ce qui a amené l'HV à cesser de fonctionner en raison d'un bug sur le layering de Blizzard. Veuillez fermer et rouvrir HV, puis redémarrer Sniper."
TSM.L["You've been undercut."] = "Vous avez été coupé."
	elseif locale == "itIT" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Gruppo:Gruppi; Selezionati (%d |4Oggetto:Oggetti;)"
TSM.L["%d auctions"] = "%d aste"
TSM.L["%d Groups"] = "%d Gruppi"
TSM.L["%d Items"] = "%d Oggetti"
TSM.L["%d of %d"] = "%d di %d"
TSM.L["%d Operations"] = "%d Operazioni"
TSM.L["%d Posted Auctions"] = "%d Aste Pubblicate"
TSM.L["%d Sold Auctions"] = "%d Aste Vendute"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s borse, %s banca, %s CdA, %s posta)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s giocatore, %s alts, %s gilda, %s CdA)"
TSM.L["%s (%s profit)"] = "%s (%s profitto)"
TSM.L["%s |4operation:operations;"] = "%s |4operazione:operazioni;"
TSM.L["%s ago"] = "%s fa"
--[[Translation missing --]]
TSM.L["%s Crafts"] = "%s Crafts"
TSM.L["%s group updated with %d items and %d materials."] = "%s gruppo aggiornato con %d voci e %d materiali."
TSM.L["%s in guild vault"] = "%s nella banca di gilda"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s è un valido prezzo personalizzato ma %s non è un oggetto valido."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s è un valido prezzo personalizzato ma non ha dato un valore per %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' è un'operazione non valida! Il rifornimento minimo di %d è superiore al rifornimento massimo di %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s non è un valido prezzo personalizzato ed ha restituito il seguente errore: %s"
TSM.L["%s Operations"] = "%s Operazioni"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s rimosso."
TSM.L["%s sent you %s"] = "%s ti ha mandato %s"
TSM.L["%s sent you %s and %s"] = "%s ti ha mandato %s e %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s ti ha mandato un PAC di %s per %s"
TSM.L["%s sent you a message: %s"] = "%s ti ha inviato un messaggio: %s"
TSM.L["%s total"] = "%s totale"
TSM.L["%sDrag%s to move this button"] = "%sTrascina%s per spostare questo pulsante"
TSM.L["%sLeft-Click%s to open the main window"] = "%sClic-Sinistro%s per aprire la finestra principale"
TSM.L["(%d/500 Characters)"] = "(%d/500 Caratteri)"
TSM.L["(max %d)"] = "(max %d)"
TSM.L["(max 5000)"] = "(max 5000)"
TSM.L["(min %d - max %d)"] = "(min %d - max %d)"
TSM.L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(minimo 0 - massimo 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(minimo 0 - massimo 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(minimo 0 - massimo 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(minimo 0.5 - massimo 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Mostra questa lista d'aiuto"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - apre la finestra principale di TSM"
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
TSM.L["1 Group"] = "1 Gruppo"
TSM.L["1 Item"] = "1 Oggetto"
TSM.L["12 hr"] = "12 h"
TSM.L["24 hr"] = "24 h"
TSM.L["48 hr"] = "48 h"
TSM.L["A custom price of %s for %s evaluates to %s."] = "Un prezzo personalizzato di %s per %s valutati in %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Un massimo di una funzione convert() è consentita."
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "Un profilo con quel nome esiste già nell'account di destinazione. Rinominalo e riprova."
TSM.L["A profile with this name already exists."] = "Esiste già un profilo con questo nome."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "Una scansione è già in corso. Interrompere la scansione prima di avviarne un'altra."
TSM.L["Above max expires."] = "Sopra la massima scadenza."
TSM.L["Above max price. Not posting."] = "Sopra il prezzo massimo Non pubblicare."
--[[Translation missing --]]
TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
TSM.L["Account Syncing"] = "Sincronizzazione Account"
--[[Translation missing --]]
TSM.L["Accounting"] = "Accounting"
--[[Translation missing --]]
TSM.L["Accounting Tooltips"] = "Accounting Tooltips"
--[[Translation missing --]]
TSM.L["Activity Type"] = "Activity Type"
--[[Translation missing --]]
TSM.L["ADD %d ITEMS"] = "ADD %d ITEMS"
--[[Translation missing --]]
TSM.L["Add / Remove Items"] = "Add / Remove Items"
--[[Translation missing --]]
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ADD OPERATION"] = "ADD OPERATION"
--[[Translation missing --]]
TSM.L["Add Player"] = "Add Player"
--[[Translation missing --]]
TSM.L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
TSM.L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
--[[Translation missing --]]
TSM.L["ADD TO MAIL"] = "ADD TO MAIL"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "Errore addizionale soppresso"
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
--[[Translation missing --]]
TSM.L["Advanced Item Search"] = "Advanced Item Search"
--[[Translation missing --]]
TSM.L["Advanced Options"] = "Advanced Options"
TSM.L["AH"] = "CdA"
--[[Translation missing --]]
TSM.L["AH (Crafting)"] = "AH (Crafting)"
--[[Translation missing --]]
TSM.L["AH (Disenchanting)"] = "AH (Disenchanting)"
--[[Translation missing --]]
TSM.L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
TSM.L["AH Frame Options"] = "AH Frame Options"
TSM.L["Alarm Clock"] = "Sveglia"
--[[Translation missing --]]
TSM.L["All Auctions"] = "All Auctions"
--[[Translation missing --]]
TSM.L["All Characters and Guilds"] = "All Characters and Guilds"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
--[[Translation missing --]]
TSM.L["All Professions"] = "All Professions"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
--[[Translation missing --]]
TSM.L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
--[[Translation missing --]]
TSM.L["Alts"] = "Alts"
--[[Translation missing --]]
TSM.L["Alts AH"] = "Alts AH"
--[[Translation missing --]]
TSM.L["Amount"] = "Amount"
--[[Translation missing --]]
TSM.L["AMOUNT"] = "AMOUNT"
--[[Translation missing --]]
TSM.L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
--[[Translation missing --]]
TSM.L["APPLY FILTERS"] = "APPLY FILTERS"
--[[Translation missing --]]
TSM.L["Apply operation to group:"] = "Apply operation to group:"
--[[Translation missing --]]
TSM.L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
TSM.L["Are you sure you want to delete this group?"] = "Sei sicuro di voler eliminare questo gruppo?"
TSM.L["Are you sure you want to delete this operation?"] = "Sei sicuro di voler eliminare questa operazione?"
--[[Translation missing --]]
TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
--[[Translation missing --]]
TSM.L["Auction"] = "Auction"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
--[[Translation missing --]]
TSM.L["AUCTION DETAILS"] = "AUCTION DETAILS"
--[[Translation missing --]]
TSM.L["Auction Duration"] = "Auction Duration"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
--[[Translation missing --]]
TSM.L["Auction Window Close"] = "Auction Window Close"
--[[Translation missing --]]
TSM.L["Auction Window Open"] = "Auction Window Open"
TSM.L["Auctionator - Auction Value"] = "Auctionator - Valore d'Asta"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Valutatore"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - Valore di Mercato"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Acquisto Minimo"
--[[Translation missing --]]
TSM.L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
TSM.L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
TSM.L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "Aste"
--[[Translation missing --]]
TSM.L["Auto Quest Complete"] = "Auto Quest Complete"
--[[Translation missing --]]
TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
TSM.L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
--[[Translation missing --]]
TSM.L["Avg Buy Price"] = "Avg Buy Price"
--[[Translation missing --]]
TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
--[[Translation missing --]]
TSM.L["Avg Sell Price"] = "Avg Sell Price"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
--[[Translation missing --]]
TSM.L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
TSM.L["Back to List"] = "Back to List"
--[[Translation missing --]]
TSM.L["Bag"] = "Bag"
TSM.L["Bags"] = "Borse"
--[[Translation missing --]]
TSM.L["Banks"] = "Banks"
--[[Translation missing --]]
TSM.L["Base Group"] = "Base Group"
--[[Translation missing --]]
TSM.L["Base Item"] = "Base Item"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Di seguito sono elencate le fonti di prezzo attualmente disponibili organizzate per modulo. La %skey|r è ciò che dovrai digitare in un campo prezzo personalizzato."
--[[Translation missing --]]
TSM.L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
--[[Translation missing --]]
TSM.L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
TSM.L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
TSM.L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
TSM.L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
TSM.L["Blacklisted players:"] = "Blacklisted players:"
--[[Translation missing --]]
TSM.L["Bought"] = "Bought"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
TSM.L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
TSM.L["BUSY"] = "BUSY"
--[[Translation missing --]]
TSM.L["BUY"] = "BUY"
--[[Translation missing --]]
TSM.L["Buy"] = "Buy"
--[[Translation missing --]]
TSM.L["Buy %d / %d"] = "Buy %d / %d"
--[[Translation missing --]]
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
TSM.L["Buy from AH"] = "Buy from AH"
TSM.L["Buy from Vendor"] = "Compra dal Mercante"
--[[Translation missing --]]
TSM.L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
TSM.L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
TSM.L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
TSM.L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
TSM.L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
TSM.L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
TSM.L["BUYS"] = "BUYS"
--[[Translation missing --]]
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
TSM.L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
--[[Translation missing --]]
TSM.L["Canceling"] = "Canceling"
--[[Translation missing --]]
TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
TSM.L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
TSM.L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
TSM.L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
TSM.L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
--[[Translation missing --]]
TSM.L["Cancelled"] = "Cancelled"
--[[Translation missing --]]
TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
TSM.L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
TSM.L["Can't load TSM tooltip while in combat"] = "Impossibile caricare il tooltip di TSM in combattimento"
TSM.L["Cash Register"] = "Registratore di Cassa"
--[[Translation missing --]]
TSM.L["CHARACTER"] = "CHARACTER"
--[[Translation missing --]]
TSM.L["Character"] = "Character"
TSM.L["Chat Tab"] = "Scheda di Chat"
--[[Translation missing --]]
TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
TSM.L["Clear"] = "Azzera"
--[[Translation missing --]]
TSM.L["Clear All"] = "Clear All"
--[[Translation missing --]]
TSM.L["CLEAR DATA"] = "CLEAR DATA"
--[[Translation missing --]]
TSM.L["Clear Filters"] = "Clear Filters"
--[[Translation missing --]]
TSM.L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
TSM.L["Clear Queue"] = "Clear Queue"
TSM.L["Clear Selection"] = "Azzera Selezione"
--[[Translation missing --]]
TSM.L["COD"] = "COD"
TSM.L["Coins (%s)"] = "Monete (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
TSM.L["Combining..."] = "Combining..."
--[[Translation missing --]]
TSM.L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
--[[Translation missing --]]
TSM.L["Confirm"] = "Confirm"
--[[Translation missing --]]
TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
TSM.L["Confirming %d / %d"] = "Confirming %d / %d"
TSM.L["Connected to %s"] = "Collegato a %s"
--[[Translation missing --]]
TSM.L["Connecting to %s"] = "Connecting to %s"
--[[Translation missing --]]
TSM.L["CONTACTS"] = "CONTACTS"
--[[Translation missing --]]
TSM.L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
TSM.L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
TSM.L["Cooldowns"] = "Cooldowns"
--[[Translation missing --]]
TSM.L["Cost"] = "Cost"
--[[Translation missing --]]
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Impossibile trovare il profilo '%s'. Possibile profilo: '%s'"
--[[Translation missing --]]
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
TSM.L["Craft"] = "Craft"
--[[Translation missing --]]
TSM.L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
TSM.L["Craft All"] = "Craft All"
--[[Translation missing --]]
TSM.L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
TSM.L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
TSM.L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
TSM.L["Crafts"] = "Crafts"
--[[Translation missing --]]
TSM.L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
TSM.L["CREATE MACRO"] = "CREATE MACRO"
TSM.L["Create New Operation"] = "Crea Nuova Operazione"
--[[Translation missing --]]
TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "Cristalli"
--[[Translation missing --]]
TSM.L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
TSM.L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
TSM.L["Custom Price"] = "Custom Price"
--[[Translation missing --]]
TSM.L["Custom Price Source"] = "Custom Price Source"
--[[Translation missing --]]
TSM.L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
TSM.L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
TSM.L["Default Price"] = "Default Price"
--[[Translation missing --]]
TSM.L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "Deseleziona Tutti i Gruppi"
--[[Translation missing --]]
TSM.L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
TSM.L["Destroy Next"] = "Destroy Next"
--[[Translation missing --]]
TSM.L["Destroy Value"] = "Destroy Value"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
TSM.L["Destroying"] = "Destroying"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
TSM.L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
TSM.L["Details"] = "Details"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
TSM.L["Display market value"] = "Display market value"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
--[[Translation missing --]]
TSM.L["Display min buyout"] = "Display min buyout"
--[[Translation missing --]]
TSM.L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
TSM.L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
TSM.L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
TSM.L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
TSM.L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
TSM.L["DOWN"] = "DOWN"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
TSM.L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "Polvere"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
--[[Translation missing --]]
TSM.L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
TSM.L["Empty price string."] = "Stringa del prezzo vuota."
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
TSM.L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
TSM.L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
TSM.L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
TSM.L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
TSM.L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
TSM.L["Enter player name"] = "Enter player name"
TSM.L["Essences"] = "Essenze"
--[[Translation missing --]]
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
--[[Translation missing --]]
TSM.L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
TSM.L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
TSM.L["Expenses"] = "Expenses"
--[[Translation missing --]]
TSM.L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
--[[Translation missing --]]
TSM.L["Expired"] = "Expired"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
--[[Translation missing --]]
TSM.L["Expires"] = "Expires"
--[[Translation missing --]]
TSM.L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
--[[Translation missing --]]
TSM.L["Exploration"] = "Exploration"
--[[Translation missing --]]
TSM.L["Export"] = "Export"
--[[Translation missing --]]
TSM.L["Export List"] = "Export List"
--[[Translation missing --]]
TSM.L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
TSM.L["Favorite Searches"] = "Favorite Searches"
--[[Translation missing --]]
TSM.L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
TSM.L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
--[[Translation missing --]]
TSM.L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
TSM.L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
--[[Translation missing --]]
TSM.L["Filter Items"] = "Filter Items"
--[[Translation missing --]]
TSM.L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
--[[Translation missing --]]
TSM.L["Fishing Reel In"] = "Fishing Reel In"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
TSM.L["Friends"] = "Friends"
--[[Translation missing --]]
TSM.L["From"] = "From"
--[[Translation missing --]]
TSM.L["Full"] = "Full"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "Opzioni Generale"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
--[[Translation missing --]]
TSM.L["Gold"] = "Gold"
--[[Translation missing --]]
TSM.L["Gold Earned:"] = "Gold Earned:"
--[[Translation missing --]]
TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
--[[Translation missing --]]
TSM.L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
TSM.L["Group already exists."] = "Group already exists."
--[[Translation missing --]]
TSM.L["Group Management"] = "Group Management"
--[[Translation missing --]]
TSM.L["Group Operations"] = "Group Operations"
--[[Translation missing --]]
TSM.L["Group Settings"] = "Group Settings"
--[[Translation missing --]]
TSM.L["Grouped Items"] = "Grouped Items"
--[[Translation missing --]]
TSM.L["Groups"] = "Groups"
--[[Translation missing --]]
TSM.L["Guild"] = "Guild"
--[[Translation missing --]]
TSM.L["Guild Bank"] = "Guild Bank"
--[[Translation missing --]]
TSM.L["GVault"] = "GVault"
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
TSM.L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
TSM.L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
TSM.L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
--[[Translation missing --]]
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
TSM.L["Ignore Characters"] = "Ignore Characters"
--[[Translation missing --]]
TSM.L["Ignore Guilds"] = "Ignore Guilds"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
TSM.L["Ignored Items"] = "Ignored Items"
--[[Translation missing --]]
TSM.L["ilvl"] = "ilvl"
--[[Translation missing --]]
TSM.L["Import"] = "Import"
--[[Translation missing --]]
TSM.L["IMPORT"] = "IMPORT"
--[[Translation missing --]]
TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
TSM.L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
TSM.L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
TSM.L["Information"] = "Information"
--[[Translation missing --]]
TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
--[[Translation missing --]]
TSM.L["Invalid custom price."] = "Invalid custom price."
--[[Translation missing --]]
TSM.L["Invalid function."] = "Invalid function."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
TSM.L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
--[[Translation missing --]]
TSM.L["Invalid item link."] = "Invalid item link."
--[[Translation missing --]]
TSM.L["Invalid operation name."] = "Invalid operation name."
--[[Translation missing --]]
TSM.L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
--[[Translation missing --]]
TSM.L["Invalid parameter to price source."] = "Invalid parameter to price source."
--[[Translation missing --]]
TSM.L["Invalid player name."] = "Invalid player name."
--[[Translation missing --]]
TSM.L["Invalid price source in convert."] = "Invalid price source in convert."
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
--[[Translation missing --]]
TSM.L["Invalid word: '%s'"] = "Invalid word: '%s'"
--[[Translation missing --]]
TSM.L["Inventory"] = "Inventory"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
TSM.L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
--[[Translation missing --]]
TSM.L["Item"] = "Item"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
TSM.L["Item Level"] = "Item Level"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Item links may only be used as parameters to price sources."] = "Item links may only be used as parameters to price sources."
--[[Translation missing --]]
TSM.L["Item Name"] = "Item Name"
--[[Translation missing --]]
TSM.L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
TSM.L["Item Value"] = "Item Value"
--[[Translation missing --]]
TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
TSM.L["ITEMS"] = "ITEMS"
--[[Translation missing --]]
TSM.L["Items"] = "Items"
--[[Translation missing --]]
TSM.L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
TSM.L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
TSM.L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
TSM.L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
TSM.L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
TSM.L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
TSM.L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
TSM.L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
TSM.L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
TSM.L["LAST 7 DAYS"] = "LAST 7 DAYS"
--[[Translation missing --]]
TSM.L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
TSM.L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
TSM.L["Last Sold"] = "Last Sold"
--[[Translation missing --]]
TSM.L["Level Up"] = "Level Up"
--[[Translation missing --]]
TSM.L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
TSM.L["List"] = "List"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
TSM.L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
TSM.L["Loading..."] = "Loading..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Sembra che TradeSkillMaster abbia riscontrato un errore. Aiuta l'autore a riparare l'errore seguendo le istruzioni mostrate."
--[[Translation missing --]]
TSM.L["Loop detected in the following custom price:"] = "Loop detected in the following custom price:"
--[[Translation missing --]]
TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
--[[Translation missing --]]
TSM.L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
--[[Translation missing --]]
TSM.L["Macro Setup"] = "Macro Setup"
--[[Translation missing --]]
TSM.L["Mail"] = "Mail"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
TSM.L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
TSM.L["Management Options"] = "Management Options"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
TSM.L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
TSM.L["Market Value"] = "Market Value"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
--[[Translation missing --]]
TSM.L["Materials"] = "Materials"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
TSM.L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
TSM.L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
TSM.L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
TSM.L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
--[[Translation missing --]]
TSM.L["Misplaced comma"] = "Misplaced comma"
--[[Translation missing --]]
TSM.L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
--[[Translation missing --]]
TSM.L["Modifiers:"] = "Modifiers:"
--[[Translation missing --]]
TSM.L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
TSM.L["MOVE"] = "MOVE"
--[[Translation missing --]]
TSM.L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
TSM.L["MOVING"] = "MOVING"
--[[Translation missing --]]
TSM.L["Moving"] = "Moving"
--[[Translation missing --]]
TSM.L["Multiple Items"] = "Multiple Items"
--[[Translation missing --]]
TSM.L["My Auctions"] = "My Auctions"
--[[Translation missing --]]
TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
--[[Translation missing --]]
TSM.L["New Group"] = "New Group"
--[[Translation missing --]]
TSM.L["New Operation"] = "New Operation"
--[[Translation missing --]]
TSM.L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
TSM.L["No Data"] = "No Data"
--[[Translation missing --]]
TSM.L["No group selected"] = "No group selected"
--[[Translation missing --]]
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
TSM.L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
TSM.L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
TSM.L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
--[[Translation missing --]]
TSM.L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
TSM.L["No Profession Selected"] = "No Profession Selected"
--[[Translation missing --]]
TSM.L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
--[[Translation missing --]]
TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
--[[Translation missing --]]
TSM.L["No Sound"] = "No Sound"
--[[Translation missing --]]
TSM.L["None"] = "None"
--[[Translation missing --]]
TSM.L["None (Always Show)"] = "None (Always Show)"
--[[Translation missing --]]
TSM.L["None Selected"] = "None Selected"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
TSM.L["Normal"] = "Normal"
--[[Translation missing --]]
TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
TSM.L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
TSM.L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
TSM.L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
TSM.L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
TSM.L["NPC"] = "NPC"
--[[Translation missing --]]
TSM.L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
TSM.L["of"] = "of"
--[[Translation missing --]]
TSM.L["Offline"] = "Offline"
--[[Translation missing --]]
TSM.L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
TSM.L["OPEN"] = "OPEN"
--[[Translation missing --]]
TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
--[[Translation missing --]]
TSM.L["Operation"] = "Operation"
--[[Translation missing --]]
TSM.L["Operations"] = "Operations"
--[[Translation missing --]]
TSM.L["Other Character"] = "Other Character"
--[[Translation missing --]]
TSM.L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
TSM.L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
TSM.L["Past Day"] = "Past Day"
--[[Translation missing --]]
TSM.L["Past Month"] = "Past Month"
--[[Translation missing --]]
TSM.L["Past Year"] = "Past Year"
--[[Translation missing --]]
TSM.L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
TSM.L["Per Item"] = "Per Item"
--[[Translation missing --]]
TSM.L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
TSM.L["Per Unit"] = "Per Unit"
--[[Translation missing --]]
TSM.L["Player Gold"] = "Player Gold"
--[[Translation missing --]]
TSM.L["Player Invite Accept"] = "Player Invite Accept"
--[[Translation missing --]]
TSM.L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
--[[Translation missing --]]
TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
TSM.L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
TSM.L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
TSM.L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
TSM.L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
TSM.L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
TSM.L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
TSM.L["Professions Used In"] = "Professions Used In"
--[[Translation missing --]]
TSM.L["Profile changed to '%s'."] = "Profile changed to '%s'."
--[[Translation missing --]]
TSM.L["Profiles"] = "Profiles"
--[[Translation missing --]]
TSM.L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
TSM.L["Profit"] = "Profit"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
TSM.L["Purchases"] = "Purchases"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
TSM.L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
TSM.L["Quantity to move:"] = "Quantity to move:"
--[[Translation missing --]]
TSM.L["Quest Added"] = "Quest Added"
--[[Translation missing --]]
TSM.L["Quest Completed"] = "Quest Completed"
--[[Translation missing --]]
TSM.L["Quest Objectives Complete"] = "Quest Objectives Complete"
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
--[[Translation missing --]]
TSM.L["Raid Warning"] = "Raid Warning"
--[[Translation missing --]]
TSM.L["Read More"] = "Read More"
--[[Translation missing --]]
TSM.L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
TSM.L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
TSM.L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
TSM.L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
TSM.L["Reload"] = "Reload"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
TSM.L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
TSM.L["REPLY"] = "REPLY"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
TSM.L["Required Level"] = "Required Level"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
TSM.L["Resale"] = "Resale"
--[[Translation missing --]]
TSM.L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
TSM.L["RESET"] = "RESET"
--[[Translation missing --]]
TSM.L["Reset All"] = "Reset All"
--[[Translation missing --]]
TSM.L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
TSM.L["RESTART"] = "RESTART"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
TSM.L["Sale"] = "Sale"
--[[Translation missing --]]
TSM.L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
TSM.L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
TSM.L["Sales"] = "Sales"
--[[Translation missing --]]
TSM.L["SALES"] = "SALES"
--[[Translation missing --]]
TSM.L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
TSM.L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
TSM.L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
TSM.L["Search"] = "Search"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
TSM.L["Search Groups"] = "Search Groups"
--[[Translation missing --]]
TSM.L["Search Inbox"] = "Search Inbox"
--[[Translation missing --]]
TSM.L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
TSM.L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
TSM.L["Select Action"] = "Select Action"
--[[Translation missing --]]
TSM.L["Select All Groups"] = "Select All Groups"
--[[Translation missing --]]
TSM.L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
TSM.L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
TSM.L["Select Duration"] = "Select Duration"
--[[Translation missing --]]
TSM.L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
TSM.L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
TSM.L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
TSM.L["Select professions"] = "Select professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
TSM.L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
TSM.L["Sell"] = "Sell"
--[[Translation missing --]]
TSM.L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
TSM.L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
--[[Translation missing --]]
TSM.L["Sell to Vendor"] = "Sell to Vendor"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
TSM.L["Seller"] = "Seller"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
TSM.L["Send"] = "Send"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
TSM.L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
TSM.L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
TSM.L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
TSM.L["Send Money"] = "Send Money"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
TSM.L["SENDING"] = "SENDING"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
TSM.L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
TSM.L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "Frammenti"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
TSM.L["Show Description"] = "Show Description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
TSM.L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
--[[Translation missing --]]
TSM.L["Simple"] = "Simple"
--[[Translation missing --]]
TSM.L["SKIP"] = "SKIP"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
TSM.L["Slash Commands:"] = "Comandi Slash:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
--[[Translation missing --]]
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
TSM.L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
TSM.L["Sold"] = "Sold"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
--[[Translation missing --]]
TSM.L["Sources"] = "Sources"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
TSM.L["Stack"] = "Stack"
--[[Translation missing --]]
TSM.L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
TSM.L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
TSM.L["STOP"] = "STOP"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
TSM.L["Subject"] = "Subject"
--[[Translation missing --]]
TSM.L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
--[[Translation missing --]]
TSM.L["Switch to WoW UI"] = "Switch to WoW UI"
--[[Translation missing --]]
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
TSM.L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
TSM.L["Target Character"] = "Target Character"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
--[[Translation missing --]]
TSM.L["Text (%s)"] = "Text (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
--[[Translation missing --]]
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "The name can ONLY contain letters. No spaces, numbers, or special characters."
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
TSM.L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
TSM.L["Time"] = "Time"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
--[[Translation missing --]]
TSM.L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
TSM.L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
TSM.L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
TSM.L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
TSM.L["Top Sellers:"] = "Top Sellers:"
--[[Translation missing --]]
TSM.L["Total"] = "Total"
--[[Translation missing --]]
TSM.L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
TSM.L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
TSM.L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
TSM.L["Total Price"] = "Total Price"
--[[Translation missing --]]
TSM.L["Total Profit:"] = "Total Profit:"
--[[Translation missing --]]
TSM.L["Total Value"] = "Total Value"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
TSM.L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
--[[Translation missing --]]
TSM.L["TSM Version Info:"] = "TSM Version Info:"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
TSM.L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
--[[Translation missing --]]
TSM.L["Twitter Integration"] = "Twitter Integration"
--[[Translation missing --]]
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
--[[Translation missing --]]
TSM.L["Type Something"] = "Type Something"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
--[[Translation missing --]]
TSM.L["Unbalanced parentheses."] = "Unbalanced parentheses."
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
TSM.L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
TSM.L["Unknown Item"] = "Unknown Item"
--[[Translation missing --]]
TSM.L["Unwrap Gift"] = "Unwrap Gift"
--[[Translation missing --]]
TSM.L["Up"] = "Up"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
--[[Translation missing --]]
TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
--[[Translation missing --]]
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Usage: /tsm price <ItemLink> <Price String>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
TSM.L["Vendor"] = "Vendor"
--[[Translation missing --]]
TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
TSM.L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
TSM.L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
TSM.L["When below minimum:"] = "When below minimum:"
--[[Translation missing --]]
TSM.L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
TSM.L["Whitelisted Players"] = "Whitelisted Players"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "Non puoi usare %s come prezzo personalizzato."
--[[Translation missing --]]
TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
--[[Translation missing --]]
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
--[[Translation missing --]]
TSM.L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
--[[Translation missing --]]
TSM.L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
--[[Translation missing --]]
TSM.L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
TSM.L["You've been undercut."] = "You've been undercut."
	elseif locale == "koKR" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4그룹:Groups; 선택됨 (%d |4아이템:Items;)"
TSM.L["%d auctions"] = "%d 경매"
TSM.L["%d Groups"] = "%d 그룹"
TSM.L["%d Items"] = "%d 아이템"
TSM.L["%d of %d"] = "%d 의 %d"
TSM.L["%d Operations"] = "%d 작업"
TSM.L["%d Posted Auctions"] = "%d 등록중인 경매"
TSM.L["%d Sold Auctions"] = "%d 판매된 경매"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s 가방, %s 은행, %s 경매장, %s 우편)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s 플레이어, %s 부캐, %s 길드, %s 경매장)"
TSM.L["%s (%s profit)"] = "%s (%s 이익)"
TSM.L["%s |4operation:operations;"] = "%s |4작업:operations;"
TSM.L["%s ago"] = "%s 이전"
TSM.L["%s Crafts"] = "%s 제작"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
TSM.L["%s in guild vault"] = "%s 길드창고"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s은(는) 유효한 사용자 가격이지만 %s은(는) 유효하지 않은 아이템입니다."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s은(는) 유효한 사용자 가격이지만 %s에 대한 가격은 없습니다."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' 은(는) 잘못된 작업입니다! 최소 보충 수량(%d)이 최대 보충 수량(%d)보다 큽니다."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s은(는) 유효하지 않은 사용자 가격이므로 에러가 발생하였습니다. %s"
TSM.L["%s Operations"] = "%s 작업"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s 삭제됨"
--[[Translation missing --]]
TSM.L["%s sent you %s"] = "%s sent you %s"
--[[Translation missing --]]
TSM.L["%s sent you %s and %s"] = "%s sent you %s and %s"
--[[Translation missing --]]
TSM.L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
--[[Translation missing --]]
TSM.L["%s sent you a message: %s"] = "%s sent you a message: %s"
TSM.L["%s total"] = "총 %s"
TSM.L["%sDrag%s to move this button"] = "%s드레그%s : 미니맵 아이콘 이동"
TSM.L["%sLeft-Click%s to open the main window"] = "%s좌클릭%s : 설정창 열기"
TSM.L["(%d/500 Characters)"] = "(%d/500 캐릭터)"
TSM.L["(max %d)"] = "(최대 %d)"
TSM.L["(max 5000)"] = "(최대 5000)"
TSM.L["(min %d - max %d)"] = "(최소 %d - 최대 %d)"
TSM.L["(min 0 - max 10000)"] = "(최소 0 - 최대 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(최소 0 - 최대 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(최소 0 - 최대 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(최소 0 - 최대 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(최소 0.5 - 최대 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - 도움말 목록을 보여줍니다."
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - TSM 창을 엽니다."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000중요:|r TSM_회계 영역의 데이터를 저장합니다. 저장된 변수의 손상을 막기위해 기존 자료가 자동으로 제거되었습니다. 구매 데이터의 마지막 %s 이(가) 보존되었습니다."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000중요:|r TSM_회계 영역의 데이터를 저장합니다. 저장된 변수의 손상을 막기위해 기존 자료가 자동으로 제거되었습니다. 판매 데이터의 마지막 %s 이(가) 보존되었습니다."
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839좌클릭|r 이 세션의 항목을 무시. Hold |cffffd839쉬프트|r 영구적으로 무시. Vendoring 설정에서 영구 무시 항목을 제거 할 수 있습니다."
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839좌클릭|r 이 세션의 항목을 무시."
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839쉬프트+좌클릭|r 영구적으로 무시."
TSM.L["1 Group"] = "1 그룹"
TSM.L["1 Item"] = "1 아이템"
TSM.L["12 hr"] = "12 시간"
TSM.L["24 hr"] = "24 시간"
TSM.L["48 hr"] = "48 시간"
TSM.L["A custom price of %s for %s evaluates to %s."] = "사용자 가격 %s인 %s의 평가 가치는 %s입니다."
TSM.L["A maximum of 1 convert() function is allowed."] = "convert() 함수가 허용하는 최대치는 1입니다."
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "해당 이름의 프로필이 대상 계정에 이미 있습니다. 먼저 이름을 변경하고 다시 시도하십시오."
TSM.L["A profile with this name already exists."] = "해당 이름의 프로필이 대상 계정에 이미 있습니다."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "검사가 이미 진행 중입니다. 다른 검사를 시작하려면 기존 검사를 중지하십시오."
TSM.L["Above max expires."] = "유효 기간 초과."
--[[Translation missing --]]
TSM.L["Above max price. Not posting."] = "Above max price. Not posting."
--[[Translation missing --]]
TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
TSM.L["Account Syncing"] = "계정 동기화"
TSM.L["Accounting"] = "회계"
TSM.L["Accounting Tooltips"] = "회계 툴팁"
TSM.L["Activity Type"] = "활동 유형"
TSM.L["ADD %d ITEMS"] = "%d 아이템 추가"
TSM.L["Add / Remove Items"] = "아이템 추가/삭제"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "임의 가격 추가"
TSM.L["ADD OPERATION"] = "작업 추가"
TSM.L["Add Player"] = "플레이어 추가"
TSM.L["Add Subject / Description"] = "제목 / 설명 추가"
TSM.L["Add Subject / Description (Optional)"] = "제목 / 설명 (부가) 추가"
TSM.L["ADD TO MAIL"] = "메일 추가"
TSM.L["Added '%s' profile which was received from %s."] = "%s 에게 받은 '%s' 프로필이 추가되었습니다."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "추가적인 오류 표시 안 함"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "경매 방식을 설정하려면 아래 설정을 조정하십시오."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
TSM.L["Advanced Item Search"] = "고급 아이템 검색"
TSM.L["Advanced Options"] = "고급 옵션"
TSM.L["AH"] = "경매장"
TSM.L["AH (Crafting)"] = "경매 (제작)"
TSM.L["AH (Disenchanting)"] = "경매 (마력추출)"
--[[Translation missing --]]
TSM.L["AH BUSY"] = "AH BUSY"
TSM.L["AH Frame Options"] = "경매 프레임 옵션"
TSM.L["Alarm Clock"] = "알람 시계"
TSM.L["All Auctions"] = "전체 경매"
TSM.L["All Characters and Guilds"] = "모든 캐릭터와 길드"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
--[[Translation missing --]]
TSM.L["All Professions"] = "All Professions"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
--[[Translation missing --]]
TSM.L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
TSM.L["Alts"] = "부캐"
TSM.L["Alts AH"] = "부캐 경매장"
TSM.L["Amount"] = "양"
TSM.L["AMOUNT"] = "양"
TSM.L["Amount of Bag Space to Keep Free"] = "남겨둘 가방 공간"
TSM.L["APPLY FILTERS"] = "필터 적용"
TSM.L["Apply operation to group:"] = "작업을 그룹에 적용:"
TSM.L["Are you sure you want to clear old accounting data?"] = "오래된 회계 데이타를 삭제하시겠습니까?"
TSM.L["Are you sure you want to delete this group?"] = "정말로 선택된 그룹을 지우시겠습니까?"
TSM.L["Are you sure you want to delete this operation?"] = "정말로 선택된 작업을 지우시겠습니까?"
--[[Translation missing --]]
TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
--[[Translation missing --]]
TSM.L["Auction"] = "Auction"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
--[[Translation missing --]]
TSM.L["AUCTION DETAILS"] = "AUCTION DETAILS"
--[[Translation missing --]]
TSM.L["Auction Duration"] = "Auction Duration"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "경매장 창 종료음"
TSM.L["Auction Window Open"] = "경매장 창 종료음"
TSM.L["Auctionator - Auction Value"] = "Auctionator - 경매가"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer -  감정인"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - 시장가"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - 최소 구매가"
--[[Translation missing --]]
TSM.L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
TSM.L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
TSM.L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "경매"
TSM.L["Auto Quest Complete"] = "자동 퀘스트 완료음"
--[[Translation missing --]]
TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
TSM.L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
--[[Translation missing --]]
TSM.L["Avg Buy Price"] = "Avg Buy Price"
--[[Translation missing --]]
TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
--[[Translation missing --]]
TSM.L["Avg Sell Price"] = "Avg Sell Price"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
--[[Translation missing --]]
TSM.L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
TSM.L["Back to List"] = "Back to List"
--[[Translation missing --]]
TSM.L["Bag"] = "Bag"
TSM.L["Bags"] = "가방"
--[[Translation missing --]]
TSM.L["Banks"] = "Banks"
--[[Translation missing --]]
TSM.L["Base Group"] = "Base Group"
--[[Translation missing --]]
TSM.L["Base Item"] = "Base Item"
--[[Translation missing --]]
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."
--[[Translation missing --]]
TSM.L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
--[[Translation missing --]]
TSM.L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
TSM.L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
TSM.L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
TSM.L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
TSM.L["Blacklisted players:"] = "차단된 플레이어:"
--[[Translation missing --]]
TSM.L["Bought"] = "Bought"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
TSM.L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
TSM.L["BUSY"] = "BUSY"
--[[Translation missing --]]
TSM.L["BUY"] = "BUY"
--[[Translation missing --]]
TSM.L["Buy"] = "Buy"
--[[Translation missing --]]
TSM.L["Buy %d / %d"] = "Buy %d / %d"
--[[Translation missing --]]
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
TSM.L["Buy from AH"] = "Buy from AH"
TSM.L["Buy from Vendor"] = "상인에게 구매"
--[[Translation missing --]]
TSM.L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
TSM.L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
TSM.L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
TSM.L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
TSM.L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
TSM.L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
TSM.L["BUYS"] = "BUYS"
--[[Translation missing --]]
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
TSM.L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
--[[Translation missing --]]
TSM.L["Canceling"] = "Canceling"
--[[Translation missing --]]
TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
TSM.L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
TSM.L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
TSM.L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
TSM.L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
--[[Translation missing --]]
TSM.L["Cancelled"] = "Cancelled"
--[[Translation missing --]]
TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
TSM.L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
TSM.L["Can't load TSM tooltip while in combat"] = "전투 중에는 TSM 툴팁을 불러올 수 없습니다."
TSM.L["Cash Register"] = "금전 등록기음"
--[[Translation missing --]]
TSM.L["CHARACTER"] = "CHARACTER"
--[[Translation missing --]]
TSM.L["Character"] = "Character"
TSM.L["Chat Tab"] = "채팅 탭"
--[[Translation missing --]]
TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
TSM.L["Clear"] = "해제"
--[[Translation missing --]]
TSM.L["Clear All"] = "Clear All"
--[[Translation missing --]]
TSM.L["CLEAR DATA"] = "CLEAR DATA"
--[[Translation missing --]]
TSM.L["Clear Filters"] = "Clear Filters"
--[[Translation missing --]]
TSM.L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
TSM.L["Clear Queue"] = "Clear Queue"
TSM.L["Clear Selection"] = "선택 해제"
--[[Translation missing --]]
TSM.L["COD"] = "COD"
TSM.L["Coins (%s)"] = "동전 (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
TSM.L["Combining..."] = "Combining..."
--[[Translation missing --]]
TSM.L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
--[[Translation missing --]]
TSM.L["Confirm"] = "Confirm"
--[[Translation missing --]]
TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
TSM.L["Confirming %d / %d"] = "Confirming %d / %d"
--[[Translation missing --]]
TSM.L["Connected to %s"] = "Connected to %s"
--[[Translation missing --]]
TSM.L["Connecting to %s"] = "Connecting to %s"
--[[Translation missing --]]
TSM.L["CONTACTS"] = "CONTACTS"
--[[Translation missing --]]
TSM.L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
TSM.L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
TSM.L["Cooldowns"] = "Cooldowns"
--[[Translation missing --]]
TSM.L["Cost"] = "Cost"
--[[Translation missing --]]
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
--[[Translation missing --]]
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Could not find profile '%s'. Possible profiles: '%s'"
--[[Translation missing --]]
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
TSM.L["Craft"] = "Craft"
--[[Translation missing --]]
TSM.L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
TSM.L["Craft All"] = "Craft All"
--[[Translation missing --]]
TSM.L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
TSM.L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
TSM.L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
TSM.L["Crafts"] = "Crafts"
--[[Translation missing --]]
TSM.L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
TSM.L["CREATE MACRO"] = "CREATE MACRO"
TSM.L["Create New Operation"] = "새 작업 생성"
--[[Translation missing --]]
TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "수정"
--[[Translation missing --]]
TSM.L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
TSM.L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
TSM.L["Custom Price"] = "Custom Price"
TSM.L["Custom Price Source"] = "사용자 가격 출처"
--[[Translation missing --]]
TSM.L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
TSM.L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
TSM.L["Default Price"] = "Default Price"
--[[Translation missing --]]
TSM.L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "모든 그룹 해제"
--[[Translation missing --]]
TSM.L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
TSM.L["Destroy Next"] = "Destroy Next"
--[[Translation missing --]]
TSM.L["Destroy Value"] = "Destroy Value"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
TSM.L["Destroying"] = "Destroying"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
TSM.L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
TSM.L["Details"] = "Details"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
TSM.L["Display market value"] = "Display market value"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
--[[Translation missing --]]
TSM.L["Display min buyout"] = "Display min buyout"
TSM.L["Display Operation Names"] = "작업 이름 표시"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
TSM.L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
TSM.L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
TSM.L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
TSM.L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
TSM.L["DOWN"] = "DOWN"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
TSM.L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "가루(티끌)"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
--[[Translation missing --]]
TSM.L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
TSM.L["Empty price string."] = "빈 가격 문자열."
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
TSM.L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
TSM.L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
TSM.L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
TSM.L["Enable TSM Tooltips"] = "TSM 툴팁 사용"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
TSM.L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
TSM.L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
TSM.L["Enter player name"] = "플레이어 이름 입력"
TSM.L["Essences"] = "정수"
--[[Translation missing --]]
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
--[[Translation missing --]]
TSM.L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
TSM.L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
TSM.L["Expenses"] = "Expenses"
--[[Translation missing --]]
TSM.L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
--[[Translation missing --]]
TSM.L["Expired"] = "Expired"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
--[[Translation missing --]]
TSM.L["Expires"] = "Expires"
--[[Translation missing --]]
TSM.L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "폭발음"
TSM.L["Export"] = "내보내기"
--[[Translation missing --]]
TSM.L["Export List"] = "Export List"
--[[Translation missing --]]
TSM.L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
TSM.L["Favorite Searches"] = "Favorite Searches"
--[[Translation missing --]]
TSM.L["Filter Auctions by Duration"] = "Filter Auctions by Duration"
--[[Translation missing --]]
TSM.L["Filter Auctions by Keyword"] = "Filter Auctions by Keyword"
--[[Translation missing --]]
TSM.L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
TSM.L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
--[[Translation missing --]]
TSM.L["Filter Items"] = "Filter Items"
--[[Translation missing --]]
TSM.L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
TSM.L["Fishing Reel In"] = "낚시 릴 스피닝음"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
TSM.L["Friends"] = "Friends"
--[[Translation missing --]]
TSM.L["From"] = "From"
TSM.L["Full"] = "가득참"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "일반 옵션"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
TSM.L["Gold"] = "골드"
TSM.L["Gold Earned:"] = "번 골드:"
--[[Translation missing --]]
TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
TSM.L["Gold Spent:"] = "쓴 골드:"
--[[Translation missing --]]
TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
TSM.L["Group already exists."] = "Group already exists."
TSM.L["Group Management"] = "그룹 관리"
--[[Translation missing --]]
TSM.L["Group Operations"] = "Group Operations"
--[[Translation missing --]]
TSM.L["Group Settings"] = "Group Settings"
--[[Translation missing --]]
TSM.L["Grouped Items"] = "Grouped Items"
TSM.L["Groups"] = "그룹"
--[[Translation missing --]]
TSM.L["Guild"] = "Guild"
--[[Translation missing --]]
TSM.L["Guild Bank"] = "Guild Bank"
--[[Translation missing --]]
TSM.L["GVault"] = "GVault"
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
TSM.L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
TSM.L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
TSM.L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "다중 프로파일이 작업과 연결되어 있을 때 사용하면 모든 프로파일에 적용되지만 현재 프로파일의 작업은 복구 불가능한 손실이 발생합니다. 계속 하시겠습니까?"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
TSM.L["Ignore Characters"] = "Ignore Characters"
TSM.L["Ignore Guilds"] = "길드 제외시키기"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
TSM.L["Ignored Items"] = "Ignored Items"
--[[Translation missing --]]
TSM.L["ilvl"] = "ilvl"
TSM.L["Import"] = "가져오기"
TSM.L["IMPORT"] = "가져오기"
--[[Translation missing --]]
TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
TSM.L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
TSM.L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
TSM.L["Information"] = "정보"
--[[Translation missing --]]
TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
TSM.L["Invalid custom price."] = "잘못된 사용자 가격입니다."
TSM.L["Invalid function."] = "잘못된 함수입니다."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
TSM.L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "잘못된 아이템 링크입니다."
--[[Translation missing --]]
TSM.L["Invalid operation name."] = "Invalid operation name."
--[[Translation missing --]]
TSM.L["Invalid operator at end of custom price."] = "Invalid operator at end of custom price."
--[[Translation missing --]]
TSM.L["Invalid parameter to price source."] = "Invalid parameter to price source."
TSM.L["Invalid player name."] = "잘못된 플레이어 이름입니다."
TSM.L["Invalid price source in convert."] = "잘못된 가격 출처입니다."
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
TSM.L["Invalid word: '%s'"] = "잘못된 단어: '%s'"
--[[Translation missing --]]
TSM.L["Inventory"] = "Inventory"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
TSM.L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "아이템"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
TSM.L["Item Level"] = "Item Level"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
TSM.L["Item links may only be used as parameters to price sources."] = "아이템 링크는 가격 출처에 대한 매개 변수로만 사용할 수 있습니다."
TSM.L["Item Name"] = "아이템 이름"
--[[Translation missing --]]
TSM.L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
TSM.L["Item Value"] = "Item Value"
--[[Translation missing --]]
TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
TSM.L["ITEMS"] = "ITEMS"
TSM.L["Items"] = "아이템"
--[[Translation missing --]]
TSM.L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
TSM.L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
TSM.L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
TSM.L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
TSM.L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
TSM.L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
TSM.L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
TSM.L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
TSM.L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
TSM.L["LAST 7 DAYS"] = "LAST 7 DAYS"
--[[Translation missing --]]
TSM.L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
TSM.L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
TSM.L["Last Sold"] = "Last Sold"
TSM.L["Level Up"] = "레벨 업"
--[[Translation missing --]]
TSM.L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
TSM.L["List"] = "List"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
TSM.L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
TSM.L["Loading..."] = "Loading..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "TradeSkillMaster에 에러가 발생한 것 같습니다. 아래 표시된 안내에 따라 제작자가 에러를 수정할 수 있도록 도움을 주시기 바랍니다."
--[[Translation missing --]]
TSM.L["Loop detected in the following custom price:"] = "Loop detected in the following custom price:"
--[[Translation missing --]]
TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
--[[Translation missing --]]
TSM.L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
TSM.L["Macro Setup"] = "매크로 설정"
TSM.L["Mail"] = "우편"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
TSM.L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
TSM.L["Management Options"] = "관리 옵션"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
TSM.L["Map Ping"] = "미니맵 표시음(ping)"
--[[Translation missing --]]
TSM.L["Market Value"] = "Market Value"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
--[[Translation missing --]]
TSM.L["Materials"] = "Materials"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
TSM.L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
TSM.L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
TSM.L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
TSM.L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
TSM.L["Misplaced comma"] = "콤마의 위치가 잘못됐습니다."
--[[Translation missing --]]
TSM.L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
--[[Translation missing --]]
TSM.L["Modifiers:"] = "Modifiers:"
TSM.L["Money Frame Open"] = "머니프레임 오픈음"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
TSM.L["MOVE"] = "MOVE"
--[[Translation missing --]]
TSM.L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
TSM.L["MOVING"] = "MOVING"
--[[Translation missing --]]
TSM.L["Moving"] = "Moving"
--[[Translation missing --]]
TSM.L["Multiple Items"] = "Multiple Items"
--[[Translation missing --]]
TSM.L["My Auctions"] = "My Auctions"
--[[Translation missing --]]
TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
TSM.L["New Group"] = "새 그룹"
TSM.L["New Operation"] = "새 작업"
TSM.L["NEWS AND INFORMATION"] = "뉴스 및 정보"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
TSM.L["No Data"] = "데이터 없음"
--[[Translation missing --]]
TSM.L["No group selected"] = "No group selected"
--[[Translation missing --]]
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
TSM.L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
TSM.L["No Materials to Gather"] = "No Materials to Gather"
TSM.L["No Operation Selected"] = "선택한 작업 없음"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
--[[Translation missing --]]
TSM.L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
TSM.L["No Profession Selected"] = "No Profession Selected"
--[[Translation missing --]]
TSM.L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
--[[Translation missing --]]
TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
TSM.L["No Sound"] = "소리 없음"
TSM.L["None"] = "없음"
TSM.L["None (Always Show)"] = "없음 (항상 표시)"
--[[Translation missing --]]
TSM.L["None Selected"] = "None Selected"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
TSM.L["Normal"] = "Normal"
--[[Translation missing --]]
TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
TSM.L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
TSM.L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
TSM.L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
TSM.L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
TSM.L["NPC"] = "NPC"
--[[Translation missing --]]
TSM.L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
TSM.L["of"] = "of"
--[[Translation missing --]]
TSM.L["Offline"] = "Offline"
--[[Translation missing --]]
TSM.L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
TSM.L["OPEN"] = "OPEN"
--[[Translation missing --]]
TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
TSM.L["Operation"] = "작업"
TSM.L["Operations"] = "작업"
--[[Translation missing --]]
TSM.L["Other Character"] = "Other Character"
TSM.L["Other Settings"] = "기타 설정"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
TSM.L["Past 7 Days"] = "지난 주"
TSM.L["Past Day"] = "지난 날"
TSM.L["Past Month"] = "지난 달"
TSM.L["Past Year"] = "지난 해"
--[[Translation missing --]]
TSM.L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
TSM.L["Per Item"] = "Per Item"
--[[Translation missing --]]
TSM.L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
TSM.L["Per Unit"] = "Per Unit"
TSM.L["Player Gold"] = "플레이어 골드"
TSM.L["Player Invite Accept"] = "초대 효과음"
--[[Translation missing --]]
TSM.L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
--[[Translation missing --]]
TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
TSM.L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
TSM.L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
TSM.L["Price Settings"] = "가격 설정"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
TSM.L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
TSM.L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
TSM.L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
TSM.L["Professions Used In"] = "Professions Used In"
--[[Translation missing --]]
TSM.L["Profile changed to '%s'."] = "Profile changed to '%s'."
TSM.L["Profiles"] = "프로파일"
--[[Translation missing --]]
TSM.L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
TSM.L["Profit"] = "Profit"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
TSM.L["Purchases"] = "Purchases"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
TSM.L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
TSM.L["Quantity to move:"] = "Quantity to move:"
TSM.L["Quest Added"] = "퀘스트 추가음"
TSM.L["Quest Completed"] = "퀘스트 완료음"
TSM.L["Quest Objectives Complete"] = "퀘스트 물건 수집완료음"
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
TSM.L["Raid Warning"] = "공격대 경보음"
--[[Translation missing --]]
TSM.L["Read More"] = "Read More"
TSM.L["Ready Check"] = "준비완료 확인음"
--[[Translation missing --]]
TSM.L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
TSM.L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
TSM.L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
TSM.L["Reload"] = "Reload"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
TSM.L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
TSM.L["REPLY"] = "REPLY"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
TSM.L["Required Level"] = "Required Level"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
TSM.L["Resale"] = "Resale"
--[[Translation missing --]]
TSM.L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
TSM.L["RESET"] = "RESET"
--[[Translation missing --]]
TSM.L["Reset All"] = "Reset All"
--[[Translation missing --]]
TSM.L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
TSM.L["RESTART"] = "RESTART"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
TSM.L["Sale"] = "Sale"
--[[Translation missing --]]
TSM.L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
TSM.L["Sale Rate"] = "Sale Rate"
TSM.L["Sales"] = "판매"
TSM.L["SALES"] = "판매"
TSM.L["Sales Summary"] = "판매 요약"
--[[Translation missing --]]
TSM.L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
TSM.L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
TSM.L["Search"] = "Search"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
TSM.L["Search Groups"] = "Search Groups"
--[[Translation missing --]]
TSM.L["Search Inbox"] = "Search Inbox"
TSM.L["Search Operations"] = "작업 검색"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
TSM.L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
TSM.L["Select Action"] = "Select Action"
TSM.L["Select All Groups"] = "모든 그룹 선택"
--[[Translation missing --]]
TSM.L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
TSM.L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
--[[Translation missing --]]
TSM.L["Select Duration"] = "Select Duration"
--[[Translation missing --]]
TSM.L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
TSM.L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
TSM.L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
TSM.L["Select professions"] = "Select professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
TSM.L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
TSM.L["Sell"] = "Sell"
--[[Translation missing --]]
TSM.L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
TSM.L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
TSM.L["Sell to Vendor"] = "상인에게 판매"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
TSM.L["Seller"] = "Seller"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
TSM.L["Send"] = "Send"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
TSM.L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
TSM.L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
TSM.L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
TSM.L["Send Money"] = "Send Money"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
TSM.L["SENDING"] = "SENDING"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
TSM.L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
TSM.L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "조각(파편)"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
TSM.L["Show Description"] = "Show Description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
TSM.L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
TSM.L["Simple"] = "단순히"
--[[Translation missing --]]
TSM.L["SKIP"] = "SKIP"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
TSM.L["Slash Commands:"] = "슬래시 명령어:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
--[[Translation missing --]]
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
TSM.L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
TSM.L["Sold"] = "Sold"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
TSM.L["Sources"] = "출처"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
TSM.L["Stack"] = "Stack"
--[[Translation missing --]]
TSM.L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
TSM.L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
TSM.L["STOP"] = "STOP"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
TSM.L["Subject"] = "Subject"
--[[Translation missing --]]
TSM.L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
--[[Translation missing --]]
TSM.L["Switch to WoW UI"] = "Switch to WoW UI"
--[[Translation missing --]]
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
TSM.L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
TSM.L["Target Character"] = "Target Character"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
TSM.L["Text (%s)"] = "문자 (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "이름은 오직 문자만 기입가능합니다. 띄어스기, 숫자, 특수문자 불가"
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
TSM.L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
TSM.L["Time"] = "Time"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
TSM.L["Tooltip Price Format"] = "툴팁 가격 형식"
TSM.L["Tooltip Settings"] = "툴팁 설정"
--[[Translation missing --]]
TSM.L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
TSM.L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
TSM.L["Top Sellers:"] = "Top Sellers:"
TSM.L["Total"] = "총"
TSM.L["Total Gold"] = "총 골드"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
TSM.L["Total Gold Earned:"] = "번 총 골드:"
TSM.L["Total Gold Spent:"] = "쓴 총 골드:"
TSM.L["Total Price"] = "총 가격"
--[[Translation missing --]]
TSM.L["Total Profit:"] = "Total Profit:"
TSM.L["Total Value"] = "총 가치"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
TSM.L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM 데스크톱 애플리케이션에서 중요한 정보가 빠졌습니다. TSM 데스크톱 애플리케이션이 실행 중이며 제대로 구성되어 있는지 확인해 주세요."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "TSM 버전 정보:"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
TSM.L["TUJ 3-Day Price"] = "TUJ 3일간 가격"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "트위터 통합"
--[[Translation missing --]]
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
--[[Translation missing --]]
TSM.L["Type Something"] = "Type Something"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "잘못된 괄호 사용."
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
TSM.L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
TSM.L["Unknown Item"] = "Unknown Item"
TSM.L["Unwrap Gift"] = "선물포장지 오픈음"
TSM.L["Up"] = "위로"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
--[[Translation missing --]]
TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "사용법: /tsm 가격 <아이템 링크> <가격 문자열>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
TSM.L["Vendor"] = "Vendor"
--[[Translation missing --]]
TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
TSM.L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "경고: 매크로가 너무 깁니다, 적당한 길이로 조정할것"
--[[Translation missing --]]
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
TSM.L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
TSM.L["When below minimum:"] = "When below minimum:"
--[[Translation missing --]]
TSM.L["Whitelist"] = "Whitelist"
TSM.L["Whitelisted Players"] = "허용된 플레이어"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "이 사용자 가격의 일부분으로 %s|1을;를; 사용할 수 없습니다."
--[[Translation missing --]]
TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "당신의 UI를 다시 불러와야 설정이 적용됩니다. 다시 불러옵니까?"
--[[Translation missing --]]
TSM.L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
TSM.L["Your auction of %s has sold for %s!"] = "당신의 경매물품 %s (이)가 %s 에 판매되었습니다!"
--[[Translation missing --]]
TSM.L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
TSM.L["You've been undercut."] = "You've been undercut."
	elseif locale == "ptBR" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Grupo:Grupos; Selecionado (%d |4Item:Itens;)"
TSM.L["%d auctions"] = "%d leilões"
TSM.L["%d Groups"] = "%d Grupos"
TSM.L["%d Items"] = "%d Itens"
TSM.L["%d of %d"] = "%d de %d"
TSM.L["%d Operations"] = "%d Operações"
TSM.L["%d Posted Auctions"] = "%d Leilões Postados"
TSM.L["%d Sold Auctions"] = "%d Leilões Vendidos"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s bolsas, %s banco, %s CdL, %s correio)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s jogador, %s alts, %s guilda, %s CdL)"
TSM.L["%s (%s profit)"] = "%s (%s lucro)"
TSM.L["%s |4operation:operations;"] = "%s |4operação:operações;"
TSM.L["%s ago"] = "%s atrás"
TSM.L["%s Crafts"] = "%s Criações"
TSM.L["%s group updated with %d items and %d materials."] = "Grupo %s atualizado com %d itens e %d materiais."
TSM.L["%s in guild vault"] = "%s no banco da guilda"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s é um preço personalizado válido mas %s é um item inválido."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s é um preço personalizado válido mas deu um valor para %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' é uma operação inválida! O reabastecimento mínimo de %d é maior que o reabastecimento máximo de %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s não é um preço personalizado válido e deu o seguinte erro: %s"
TSM.L["%s Operations"] = "%s Operações"
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s antes tinha o número máximo de operações, então removemos %s."
TSM.L["%s removed."] = "%s removido."
TSM.L["%s sent you %s"] = "%s lhe enviou %s"
TSM.L["%s sent you %s and %s"] = "%s lhe enviou %s e %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s lhe enviou uma Carta a Cobrar de %s por %s"
TSM.L["%s sent you a message: %s"] = "%s lhe enviou uma mensagem: %s"
TSM.L["%s total"] = "%s total"
TSM.L["%sDrag%s to move this button"] = "%sArraste%s para mover este botão"
TSM.L["%sLeft-Click%s to open the main window"] = "%sClique-Esquerdo%s para abrir a janela principal"
TSM.L["(%d/500 Characters)"] = "(%d/500 Caracteres)"
TSM.L["(max %d)"] = "(máximo %d)"
TSM.L["(max 5000)"] = "(máximo 5000)"
TSM.L["(min %d - max %d)"] = "(mínimo %d - máximo %d)"
TSM.L["(min 0 - max 10000)"] = "(mínimo 0 - máximo 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(mínimo 0 - máximo 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(mínimo 0 - máximo 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(mínimo 0 - máximo 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(mínimo 0.5 - máximo 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - Mostra esta lista de ajuda"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - abre a janela principal do TSM."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANTE:|r Quando o TSM_Accounting salvou os dados para este reino pela última vez, eles eram muito grandes para o WoW processar, então os dados antigos foram automaticamente cortados para evitar a corrupção das variáveis salvas. Os últimos %s de dados de compras foram preservados."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANTE:|r Quando o TSM_Accounting salvou os dados para este reino pela última vez, eles eram muito grandes para o WoW processar, então os dados antigos foram automaticamente cortados para evitar a corrupção das variáveis salvas. Os últimos %s de dados de vendas foram preservados."
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Clique com o botão esquerdo|r para ignorar este item nesta seção. Segure |cffffd839Shift|r para ignorá-lo permanentemente. Você pode remover itens ignorados permanentemente nas configurações de Venda."
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Clique com o botão esquerdo|r para ignorar um item nesta sessão."
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift + Clique com o botão esquerdo|r para ignorar isto permanentemente."
TSM.L["1 Group"] = "1 Grupo"
TSM.L["1 Item"] = "1 Item"
TSM.L["12 hr"] = "12hs"
TSM.L["24 hr"] = "24hs"
TSM.L["48 hr"] = "48hs"
TSM.L["A custom price of %s for %s evaluates to %s."] = "O preço personalizado de %s para %s calcula %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "É permitida no máximo 1 função convert()."
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "Um perfil com este nome já existe na conta alvo. Renomeie-o primeiro e tente novamente."
TSM.L["A profile with this name already exists."] = "Um perfil com este nome já existe."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "Um escaneamento está em progresso atualmente. Por favor, pare este escaneamento antes de iniciar outro."
TSM.L["Above max expires."] = "Acima do limite de expiração."
TSM.L["Above max price. Not posting."] = "Acima do preço máximo. Não será postado."
TSM.L["Above max price. Posting at max price."] = "Acima do preço máximo. Postando no preço máximo."
TSM.L["Above max price. Posting at min price."] = "Acima do preço máximo. Postando no preço mínimo."
TSM.L["Above max price. Posting at normal price."] = "Acima do preço máximo. Postando no preço normal."
TSM.L["Accepting these item(s) will cost"] = "Aceitar estes itens custará"
TSM.L["Accepting this item will cost"] = "Aceitar este item custará"
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Sincronização de conta removida. Por favor, remova a sincronização da outra conta também."
TSM.L["Account Syncing"] = "Sincronização da Conta"
TSM.L["Accounting"] = "Contabilidade"
TSM.L["Accounting Tooltips"] = "Tooltips de Contabilidade"
TSM.L["Activity Type"] = "Atividade"
TSM.L["ADD %d ITEMS"] = "ADICIONAR %d ITENS"
TSM.L["Add / Remove Items"] = "Adiciona / Remove Itens"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADICIONAR UMA NOVA FONTE DE PREÇO PERSONALIZADO"
TSM.L["ADD OPERATION"] = "ADICIONAR OPERAÇÃO"
TSM.L["Add Player"] = "Adicionar Jogador"
TSM.L["Add Subject / Description"] = "Adicionar Assunto / Descrição"
TSM.L["Add Subject / Description (Optional)"] = "Adicionar Assunto / Descrição (Opcional)"
TSM.L["ADD TO MAIL"] = "ADICIONAR À CARTA"
TSM.L["Added '%s' profile which was received from %s."] = "O Perfil '%s', recebido de %s, foi adicionado."
TSM.L["Added %s to %s."] = "%s adicionado a %s."
TSM.L["Additional error suppressed"] = "Erro adicional suprimido"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Ajuste as configurações abaixo para definir como os grupos ligados à esta operação serão postados."
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Ajuste as configurações abaixo para definir como os grupos ligados à esta operação serão cancelados."
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Ajuste as configurações abaixo para definir como os preços dos grupos ligados à esta operação serão definidos."
TSM.L["Advanced Item Search"] = "Busca Avançada de Item"
TSM.L["Advanced Options"] = "Opções Avançadas"
TSM.L["AH"] = "CdL"
TSM.L["AH (Crafting)"] = "CdL (Criação)"
TSM.L["AH (Disenchanting)"] = "CdL (Desencantamento)"
TSM.L["AH BUSY"] = "CdL OCUPADA"
TSM.L["AH Frame Options"] = "Opções da Janela de CdL"
TSM.L["Alarm Clock"] = "Despertador"
TSM.L["All Auctions"] = "Todos os Leilões"
TSM.L["All Characters and Guilds"] = "Todos os Personagens e Guildas"
TSM.L["All Item Classes"] = "Todas as Classes de Item"
TSM.L["All Professions"] = "Todas as Profissões"
TSM.L["All Subclasses"] = "Todas as Subclasses"
TSM.L["Allow partial stack?"] = "Permitir lote parcial?"
TSM.L["Alt Guild Bank"] = "Banco de Guilda do Alt"
TSM.L["Alts"] = "Alts"
TSM.L["Alts AH"] = "Alts CdL"
TSM.L["Amount"] = "Quantidade"
TSM.L["AMOUNT"] = "QUANTIDADE"
TSM.L["Amount of Bag Space to Keep Free"] = "Quantidade de espaços da Bolsa para manter vazio"
TSM.L["APPLY FILTERS"] = "APLICAR FILTROS"
TSM.L["Apply operation to group:"] = "Aplicar operação ao grupo:"
TSM.L["Are you sure you want to clear old accounting data?"] = "Você tem certeza que quer excluir seus dados antigos de contabilidade?"
TSM.L["Are you sure you want to delete this group?"] = "Você tem certeza que quer excluir esse grupo?"
TSM.L["Are you sure you want to delete this operation?"] = "Você tem certeza que você quer excluir essa operação?"
TSM.L["Are you sure you want to reset all operation settings?"] = "Você tem certeza que quer redefinir todas as configurações da operação?"
TSM.L["At above max price and not undercut."] = "Acima do preço máximo e sem corte de preço."
TSM.L["At normal price and not undercut."] = "No preço normal e sem corte de preço."
TSM.L["Auction"] = "Leilão"
TSM.L["Auction Bid"] = "Lance do Leilão"
TSM.L["Auction Buyout"] = "Arremate do Leilão"
TSM.L["AUCTION DETAILS"] = "DETALHES DO LEILÃO"
TSM.L["Auction Duration"] = "Duração do Leilão"
TSM.L["Auction has been bid on."] = "O Leilão tem um lance."
TSM.L["Auction House Cut"] = "Desconto da Casa de Leilão"
TSM.L["Auction Sale Sound"] = "Som de Venda de Leilão"
TSM.L["Auction Window Close"] = "Fechar Janela de Leilão"
TSM.L["Auction Window Open"] = "Abrir Janela de Leilão"
TSM.L["Auctionator - Auction Value"] = "Auctionator - Valor de Leilão"
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Preço de Mercado"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Avaliador"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - Valor de Mercado"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - Arremate Mínimo"
TSM.L["Auctioning"] = "Postagem"
TSM.L["Auctioning Log"] = "Registro de Postagem"
TSM.L["Auctioning Operation"] = "Operação de Postagem"
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Botão 'POSTAR'/'CANCELAR' em Postagem"
TSM.L["Auctioning Tooltips"] = "Tooltips de Postagem"
TSM.L["Auctions"] = "Leilões"
TSM.L["Auto Quest Complete"] = "Busca Automática Concluída"
TSM.L["Average Earned Per Day:"] = "Média de Ganhos Por Dia:"
TSM.L["Average Prices:"] = "Preços Médios:"
TSM.L["Average Profit Per Day:"] = "Média de Lucro Por Dia:"
TSM.L["Average Spent Per Day:"] = "Média de Gastos Por Dia:"
TSM.L["Avg Buy Price"] = "Média de Preço de Compra"
TSM.L["Avg Resale Profit"] = "Média de Lucro de Revenda"
TSM.L["Avg Sell Price"] = "Média de Preço de Venda"
TSM.L["BACK"] = "VOLTAR"
TSM.L["BACK TO LIST"] = "VOLTAR PARA A LISTA"
TSM.L["Back to List"] = "Voltar para a Lista"
TSM.L["Bag"] = "Bolsa"
TSM.L["Bags"] = "Bolsas"
TSM.L["Banks"] = "Bancos"
TSM.L["Base Group"] = "Grupo Base"
TSM.L["Base Item"] = "Item Base"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Abaixo estão suas fontes de preços atualmente disponíveis e organizadas por módulo. O %skey|r é o que você digitaria em uma caixa de preço personalizado."
TSM.L["Below custom price:"] = "Abaixo do preço personalizado:"
TSM.L["Below min price. Posting at max price."] = "Abaixo do preço mínimo. Postando no preço máximo."
TSM.L["Below min price. Posting at min price."] = "Abaixo do preço mínimo. Postando no preço mínimo."
TSM.L["Below min price. Posting at normal price."] = "Abaixo do preço mínimo. Postando no preço normal."
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Abaixo você pode gerenciar seus perfis, o que permite que tenha um conjunto totalmente diferente de grupos."
TSM.L["BID"] = "LANCE"
TSM.L["Bid %d / %d"] = "Lance %d / %d"
TSM.L["Bid (item)"] = "Lance (item)"
TSM.L["Bid (stack)"] = "Lance (lote)"
TSM.L["Bid Price"] = "Preço de Lance"
TSM.L["Bid Sniper Paused"] = "Sniper de Lances Interrompido"
TSM.L["Bid Sniper Running"] = "Sniper de Lances Rodando"
TSM.L["Bidding Auction"] = "Dando Lance no Leilão"
TSM.L["Blacklisted players:"] = "Jogadores na lista negra:"
TSM.L["Bought"] = "Comprado"
TSM.L["Bought %d of %s from %s for %s"] = "Comprou %d de %s de %s por %s"
TSM.L["Bought %sx%d for %s from %s"] = "Comprou %sx%d por %s de %s"
TSM.L["Bound Actions"] = "Ações Vinculadas"
TSM.L["BUSY"] = "OCUPADO"
TSM.L["BUY"] = "COMPRAR"
TSM.L["Buy"] = "Comprar"
TSM.L["Buy %d / %d"] = "Comprar %d / %d"
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Comprar %d / %d (Confirmando %d / %d)"
TSM.L["Buy from AH"] = "Comprar da CdL"
TSM.L["Buy from Vendor"] = "Comprar do Comerciante"
TSM.L["BUY GROUPS"] = "COMPRAR GRUPOS"
TSM.L["Buy Options"] = "Opções de Compra"
TSM.L["BUYBACK ALL"] = "COMPRAR TUDO DE VOLTA"
TSM.L["Buyer/Seller"] = "Personagem"
TSM.L["BUYOUT"] = "ARREMATE"
TSM.L["Buyout (item)"] = "Arremate (item)"
TSM.L["Buyout (stack)"] = "Arremate (lote)"
TSM.L["Buyout Confirmation Alert"] = "Alerta de Confirmação de Arremate"
TSM.L["Buyout Price"] = "Preço de Arremate"
TSM.L["Buyout Sniper Paused"] = "Sniper de Arremate Interrompido"
TSM.L["Buyout Sniper Running"] = "Sniper de Arremate Rodando"
TSM.L["BUYS"] = "COMPRAS"
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "Por padrão, este grupo armazena todos os itens que não estão atribuídos à um grupo. Você não pode modificar ou excluir este grupo."
TSM.L["Cancel auctions with bids"] = "Cancelar leilões com lances"
TSM.L["Cancel Scan"] = "Escanear para Cancelamento"
TSM.L["Cancel to repost higher?"] = "Cancelar para repostar mais caro?"
TSM.L["Cancel undercut auctions?"] = "Cancelar leilões com preços cortados?"
TSM.L["Canceling"] = "Cancelando"
TSM.L["Canceling %d / %d"] = "Cancelando %d / %d"
TSM.L["Canceling %d Auctions..."] = "Cancelando %d Leilões..."
TSM.L["Canceling all auctions."] = "Cancelando todos os leilões."
TSM.L["Canceling auction which you've undercut."] = "Cancelando leilão que você fez o corte de preço."
TSM.L["Canceling disabled."] = "Cancelamento desabilitado."
TSM.L["Canceling Settings"] = "Configurações de Cancelamento"
TSM.L["Canceling to repost at higher price."] = "Cancelando para repostar por preço mais alto."
TSM.L["Canceling to repost at reset price."] = "Cancelando para repostar a preço de reset."
TSM.L["Canceling to repost higher."] = "Cancelando para repostar mais caro."
TSM.L["Canceling undercut auctions and to repost higher."] = "Cancelando leilões com preços cortados para postar mais alto."
TSM.L["Canceling undercut auctions."] = "Cancelando leilões com preços cortados."
TSM.L["Cancelled"] = "Cancelado"
TSM.L["Cancelled auction of %sx%d"] = "Leilão cancelado de %sx%d"
TSM.L["Cancelled Since Last Sale"] = "Cancelados Desde a Última Venda"
TSM.L["CANCELS"] = "CANCELADOS"
TSM.L["Cannot repair from the guild bank!"] = "Não pode reparar usando o banco de guilda!"
TSM.L["Can't load TSM tooltip while in combat"] = "Não é possível carregar as tooltips do TSM enquanto em combate"
TSM.L["Cash Register"] = "Caixa Registradora"
TSM.L["CHARACTER"] = "PERSONAGEM"
TSM.L["Character"] = "Personagem"
TSM.L["Chat Tab"] = "Aba de Bate-Papo"
TSM.L["Cheapest auction below min price."] = "Leilão mais barato abaixo do preço mínimo."
TSM.L["Clear"] = "Limpar"
TSM.L["Clear All"] = "Limpar Tudo"
TSM.L["CLEAR DATA"] = "LIMPAR DADOS"
TSM.L["Clear Filters"] = "Limpar Filtros"
TSM.L["Clear Old Data"] = "Limpeza de Dados Antigos"
TSM.L["Clear Old Data Confirmation"] = "Confirmação da Limpeza de Dados Antigos"
TSM.L["Clear Queue"] = "Limpar Fila"
TSM.L["Clear Selection"] = "Limpar Seleção"
TSM.L["COD"] = "Carta a Cobrar"
TSM.L["Coins (%s)"] = "Moedas (%s)"
TSM.L["Collapse All Groups"] = "Recolher Todos os Grupos"
TSM.L["Combine Partial Stacks"] = "Combinar Lotes Parciais"
TSM.L["Combining..."] = "Combinando..."
TSM.L["Configuration Scroll Wheel"] = "Configuração da Roda do Mouse"
TSM.L["Confirm"] = "Confirmar"
TSM.L["Confirm Complete Sound"] = "Som de Confirmação Completo"
TSM.L["Confirming %d / %d"] = "Confirmando %d / %d"
TSM.L["Connected to %s"] = "Conectado a %s"
TSM.L["Connecting to %s"] = "Conectandoa %s"
TSM.L["CONTACTS"] = "CONTATOS"
TSM.L["Contacts Menu"] = "Menu de Contatos"
TSM.L["Cooldown"] = "Recarga"
TSM.L["Cooldowns"] = "Recargas"
TSM.L["Cost"] = "Custo"
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Não foi possível criar a macro pois você já possui várias. Exclua uma de suas macros existentes e tente novamente."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Não foi possível encontrar o perfil '%s'. Possíveis perfis: '%s'"
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Não foi possível vender os itens por não haver espaço de bolsa disponível para separar os lotes de itens."
TSM.L["Craft"] = "Cria"
TSM.L["CRAFT"] = "CRIAR"
TSM.L["Craft (Unprofitable)"] = "Criar (Sem lucro)"
TSM.L["Craft (When Profitable)"] = "Criar (Quando existir Lucro)"
TSM.L["Craft All"] = "Criar Todos"
TSM.L["CRAFT ALL"] = "CRIAR TODOS"
TSM.L["Craft Name"] = "Nome do Item"
TSM.L["CRAFT NEXT"] = "CRIAR PRÓXIMO"
TSM.L["Craft value method:"] = "Método de valor da criação:"
TSM.L["CRAFTER"] = "CRIADOR"
TSM.L["CRAFTING"] = "CRIAÇÃO"
TSM.L["Crafting"] = "Criação"
TSM.L["Crafting Cost"] = "Custo de Criação"
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Botão 'CRIAR PRÓXIMO' em Criação"
TSM.L["Crafting Queue"] = "Fila de Criação"
TSM.L["Crafting Tooltips"] = "Tooltips de Criação"
TSM.L["Crafts"] = "Criações"
TSM.L["Crafts %d"] = "Criações %d"
TSM.L["CREATE MACRO"] = "CRIAR MACRO"
TSM.L["Create New Operation"] = "Criar Nova Operação"
TSM.L["CREATE NEW PROFILE"] = "CRIAR NOVO PERFIL"
TSM.L["Create Profession Group"] = "Criar Grupo de Profissão"
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Fonte de preço personalizada criada: |cff99ffff%s|r"
TSM.L["Crystals"] = "Cristais"
TSM.L["Current Profiles"] = "Perfis Atuais"
TSM.L["CURRENT SEARCH"] = "BUSCA ATUAL"
TSM.L["CUSTOM POST"] = "POSTAR PERSONALIZADO"
TSM.L["Custom Price"] = "Preço Personalizado"
TSM.L["Custom Price Source"] = "Fonte de Preço Personalizado"
TSM.L["Custom Sources"] = "Fontes Personalizadas"
TSM.L["Database Sources"] = "Fontes da Base de Dados"
TSM.L["Default Craft Value Method:"] = "Método de Valor de Criação Padrão:"
TSM.L["Default Material Cost Method:"] = "Método de Valor de Material Padrão:"
TSM.L["Default Price"] = "Preço Padrão"
TSM.L["Default Price Configuration"] = "Configuração de Preço Padrão"
TSM.L["Define what priority Gathering gives certain sources."] = "Defina qual a prioridade de Coleta dá à certas fontes."
TSM.L["Delete Profile Confirmation"] = "Confirmação de Exclusão de Perfil"
TSM.L["Delete this record?"] = "Apagar este registro?"
TSM.L["Deposit"] = "Depósito"
TSM.L["Deposit Cost"] = "Custo de Depósito"
TSM.L["Deposit Price"] = "Preço de Depósito"
TSM.L["DEPOSIT REAGENTS"] = "DEPOSITAR REAGENTES"
TSM.L["Deselect All Groups"] = "Desselecionar Todos os Grupos"
TSM.L["Deselect All Items"] = "Desselecionar Todos os Itens"
TSM.L["Destroy Next"] = "Destruir Próximo"
TSM.L["Destroy Value"] = "Valor de Destruição"
TSM.L["Destroy Value Source"] = "Fonte do Valor de Destruição"
TSM.L["Destroying"] = "Destruição"
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Botão 'DESTRUIR PRÓXIMO' em Destruição"
TSM.L["Destroying Tooltips"] = "Tooltips de Destruição"
TSM.L["Destroying..."] = "Destruindo..."
TSM.L["Details"] = "Detalhes"
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu limite de cancelar para repostar (%s) é invalido. Confira suas configurações."
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Não cancelou %s porque preço máximo (%s) é inválido. Confira suas configurações."
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Não cancelou %s porque seu preço máximo (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu preço mínimo (%s) é inválido. Confira suas configurações."
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu preço normal (%s) é inválido. Confira suas configurações."
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Não cancelou %s porque seu preço normal (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Não cancelou %s porque seu corte de preço (%s) é inválido. Confira suas configurações."
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Não postou %s porque a Blizzard não dispôs toda a informação necessária para isso. Tente novamente depois."
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Não postou %s porque o dono do leilão mais baixo (%s) está tanto na lista negra quanto na lista de permissão, o que não é permitido. Ajuste suas configurações para corrigir o problema."
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Não postou %s porque um de seus alts (%s) está na lista negra, o que não é permitido. Remova este personagem de sua lista negra."
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço máximo (%s) é inválido. Confira suas configurações."
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Não postou %s porque o seu preço máximo (%s) é menor que seu preço mínimo (%s). Confira suas configurações."
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço mínimo (%s) é inválido. Confira suas configurações."
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Não postou %s porque o seu preço normal (%s) é inválido. Confira suas configurações."
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Não postou %s porque o seu preço normal (%s) é  menor que seu preço mínimo (%s). Confira suas configurações."
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Não postou %s porque seu corte de preço (%s) é inválido. Confira suas configurações."
TSM.L["Disable invalid price warnings"] = "Desabilitar alertas de preço inválido"
TSM.L["Disenchant Search"] = "Busca para Desencantamento"
TSM.L["DISENCHANT SEARCH"] = "BUSCA PARA DESENCANTAMENTO"
TSM.L["Disenchant Search Options"] = "Opções da Busca para Desencantamento"
TSM.L["Disenchant Value"] = "Valor de Desencantamento"
TSM.L["Disenchanting Options"] = "Opções de Desencantamento"
TSM.L["Display auctioning values"] = "Exibir valores de postagem no leilão"
TSM.L["Display cancelled since last sale"] = "Exibir cancelamentos desde a última venda"
TSM.L["Display crafting cost"] = "Exibir custo de criação"
TSM.L["Display detailed destroy info"] = "Exibir informação detalhada de destruição"
TSM.L["Display disenchant value"] = "Exibir valor de desencantamento"
TSM.L["Display expired auctions"] = "Exibir leilões expirados"
TSM.L["Display group name"] = "Exibir nome do grupo"
TSM.L["Display historical price"] = "Exibir preço histórico"
TSM.L["Display market value"] = "Exibir valor de mercado"
TSM.L["Display mill value"] = "Exibir preço de trituração"
TSM.L["Display min buyout"] = "Exibir arremate mínimo"
TSM.L["Display Operation Names"] = "Exibir Nomes das Operações"
TSM.L["Display prospect value"] = "Exibir valores de prospecção"
TSM.L["Display purchase info"] = "Exibir informações de compra"
TSM.L["Display region historical price"] = "Exibir preço histórico da região"
TSM.L["Display region market value avg"] = "Exibir preço médio de mercado da região"
TSM.L["Display region min buyout avg"] = "Exibir média de arremate mínimo da região"
TSM.L["Display region sale avg"] = "Exibir média de vendas na região"
TSM.L["Display region sale rate"] = "Exibir taxa de venda na região"
TSM.L["Display region sold per day"] = "Exibir número de vendas diárias na região"
TSM.L["Display sale info"] = "Exibir informações de venda"
TSM.L["Display sale rate"] = "Exibir taxa de venda"
TSM.L["Display shopping max price"] = "Exibir preço máximo de compra"
TSM.L["Display total money recieved in chat?"] = "Exibir o valor total de dinheiro recebido no chat?"
TSM.L["Display transform value"] = "Exibir valor de transformação"
TSM.L["Display vendor buy price"] = "Exibir valor de compra no comerciante"
TSM.L["Display vendor sell price"] = "Exibir valor de venda no vendedor"
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Fazer isso também removerá qualquer subgrupo ligado à este grupo."
TSM.L["Done Canceling"] = "Cancelamento Finalizado"
TSM.L["Done Posting"] = "Postagem Finalizada"
TSM.L["Done rebuilding item cache."] = "Reconstrução de cache de itens concluída."
TSM.L["Done Scanning"] = "Escaneamento Finalizado"
TSM.L["Don't post after this many expires:"] = "Não postar após esta quantidade de expirações:"
TSM.L["Don't Post Items"] = "Não Postar Itens"
TSM.L["Don't prompt to record trades"] = "Não abrir janela para armazenar trocas"
TSM.L["DOWN"] = "ABAIXO"
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Arrastar Itens Adicionais (%d/%d Itens)"
TSM.L["Drag Item(s) Into Box"] = "Arraste Item(ns) para Dentro da Caixa"
TSM.L["Duplicate"] = "Duplicar"
TSM.L["Duplicate Profile Confirmation"] = "Confirmação de Duplicação de Perfil"
TSM.L["Dust"] = "Pó"
TSM.L["Elevate your gold-making!"] = "Eleve seus Ganhos de Ouro!"
TSM.L["Embed TSM tooltips"] = "Anexar Tooltips do TSM"
TSM.L["EMPTY BAGS"] = "ESVAZIAR BOLSAS"
TSM.L["Empty parentheses are not allowed"] = "Parênteses vazios não são permitidos"
TSM.L["Empty price string."] = "Preço vazio"
TSM.L["Enable automatic stack combination"] = "Habilitar combinação automática de lotes"
TSM.L["Enable buying?"] = "Habilitar compra?"
TSM.L["Enable inbox chat messages"] = "Habilitar mensagens da caixa de entrada no chat"
TSM.L["Enable restock?"] = "Habilitar reestoque?"
TSM.L["Enable selling?"] = "Habilitar venda?"
TSM.L["Enable sending chat messages"] = "Habilitar mensagens de envio no chat"
TSM.L["Enable TSM Tooltips"] = "Habilitar Tooltips do TSM"
TSM.L["Enable tweet enhancement"] = "Habilitar melhoria de tweet"
TSM.L["Enchant Vellum"] = "Encantar Velino"
TSM.L["Ensure both characters are online and try again."] = "Certifique-se que ambos os personagens estejam online e tente novamente."
TSM.L["Enter a name for the new profile"] = "Defina um nome para o novo perfil"
TSM.L["Enter Filter"] = "Digite o Filtro"
TSM.L["Enter Keyword"] = "Digite a Palavra-chave"
TSM.L["Enter name of logged-in character from other account"] = "Digite o nome de um personagem logado de outra conta"
TSM.L["Enter player name"] = "Digite o nome do jogador"
TSM.L["Essences"] = "Essências"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Estabelecendo conexão com %s. Certifique-se de ter inserido o nome deste personagem na outra conta."
TSM.L["Estimated Cost:"] = "Custo Estimado:"
TSM.L["Estimated deliver time"] = "Tempo estimado de entrega"
TSM.L["Estimated Profit:"] = "Lucro Estimado:"
TSM.L["Exact Match Only?"] = "Apenas Correspondência Exata?"
TSM.L["Exclude crafts with cooldowns"] = "Excluir criações com recargas"
TSM.L["Expand All Groups"] = "Expandir Todos os Grupos"
TSM.L["Expenses"] = "Gastos"
TSM.L["EXPENSES"] = "GASTOS"
TSM.L["Expirations"] = "Expirações"
TSM.L["Expired"] = "Expirado"
TSM.L["Expired Auctions"] = "Leilões Expirados"
TSM.L["Expired Since Last Sale"] = "Expirados Desde a Última Venda"
TSM.L["Expires"] = "Expirados"
TSM.L["EXPIRES"] = "EXPIRADOS"
TSM.L["Expires Since Last Sale"] = "Expirados Desde a Última Venda"
TSM.L["Expiring Mails"] = "Cartas Expirando"
TSM.L["Exploration"] = "Exploração"
TSM.L["Export"] = "Exportar"
TSM.L["Export List"] = "Exportar Lista"
TSM.L["Failed Auctions"] = "Leilões Retornados"
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Leilões Retornados Desde a Última Venda (Expirado/Cancelado)"
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Falha ao dar lance no leilão de %s (x%s) por %s."
TSM.L["Failed to bid on auction of %s."] = "Falha ao dar lance no leilão de %s."
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Falha ao comprar o leilão de %s (x%s) por %s."
TSM.L["Failed to buy auction of %s."] = "Falha ao arrematar o leilão de %s."
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Falha ao encontrar o leilão de %s, removendo dos resultados."
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Falha ao postar %sx%d pois o item não existe mais nas suas bolsas."
TSM.L["Failed to send profile."] = "Falha ao enviar perfil."
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Falha ao enviar perfil. Certifique-se que ambos os personagens estejam online e tente novamente."
TSM.L["Favorite Scans"] = "Escaneamentos Favoritos"
TSM.L["Favorite Searches"] = "Buscas Favoritas"
TSM.L["Filter Auctions by Duration"] = "Filtrar Leilões por Duração"
TSM.L["Filter Auctions by Keyword"] = "Filtrar Leilões por Palavra-chave"
TSM.L["Filter by Keyword"] = "Filtrar por Palavra-chave"
TSM.L["FILTER BY KEYWORD"] = "FILTRAR POR PALAVRA-CHAVE"
TSM.L["Filter group item lists based on the following price source"] = "Filtrar as listas de itens agrupados baseado na seguinte fonte de preços"
TSM.L["Filter Items"] = "Filtrar Itens"
TSM.L["Filter Shopping"] = "Filtrar Compra"
TSM.L["Finding Selected Auction"] = "Encontrando o Leilão Selecionado"
TSM.L["Fishing Reel In"] = "Puxão do Molinete de Pesca"
TSM.L["Forget Character"] = "Esquecer Personagem"
TSM.L["Found auction sound"] = "Som de leilão encontrado"
TSM.L["Friends"] = "Amigos"
TSM.L["From"] = "De"
TSM.L["Full"] = "Completo"
TSM.L["Garrison"] = "Guarnição"
TSM.L["Gathering"] = "Coleta"
TSM.L["Gathering Search"] = "Busca para Coleta"
TSM.L["General Options"] = "Opções Gerais"
TSM.L["Get from Bank"] = "Pegar do Banco"
TSM.L["Get from Guild Bank"] = "Pegar do Banco de Guilda"
TSM.L["Global Operation Confirmation"] = "Confirmação de Operação Global"
TSM.L["Gold"] = "Ouro"
TSM.L["Gold Earned:"] = "Ouro Ganho:"
TSM.L["GOLD ON HAND"] = "OURO EM MÃOS"
TSM.L["Gold Spent:"] = "Ouro Gasto:"
TSM.L["GREAT DEALS SEARCH"] = "BUSCA DE PECHINCHAS"
TSM.L["Group already exists."] = "Grupo já existe."
TSM.L["Group Management"] = "Gerenciamento de Grupo"
TSM.L["Group Operations"] = "Operações do Grupo"
TSM.L["Group Settings"] = "Configurações do Grupo"
TSM.L["Grouped Items"] = "Itens Agrupados"
TSM.L["Groups"] = "Grupos"
TSM.L["Guild"] = "Guilda"
TSM.L["Guild Bank"] = "Banco de Guilda"
TSM.L["GVault"] = "Cofre da Guilda"
TSM.L["Have"] = "Possui"
TSM.L["Have Materials"] = "Possui Materiais"
TSM.L["Have Skill Up"] = "Aumenta Perícia"
TSM.L["Hide auctions with bids"] = "Ocultar leilões com lances"
TSM.L["Hide Description"] = "Ocultar Descrição"
TSM.L["Hide minimap icon"] = "Ocultar ícone no mini-mapa"
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Ocultando a UI do Módulo de Armazenamento do TSM. Digite '/tsm bankui' para reabri-la."
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Ocultando a UI da Lista de Tarefas do TSM. Digite '/tsm tasklist' para reabri-la."
TSM.L["High Bidder"] = "Lance mais Alto"
TSM.L["Historical Price"] = "Preço Histórico"
TSM.L["Hold ALT to repair from the guild bank."] = "Segure ALT para reparar usando o banco de guilda."
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Segure shift para mover os itens para o grupo pai ao invés de removê-los."
TSM.L["Hr"] = "H"
TSM.L["Hrs"] = "Hs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Acabei de vender [%s] por %s! %s #TSM4 #warcraft"
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Se você não quer cortar os preços de outro jogador, você pode adicioná-lo à sua lista de permissões e o TSM não irá cortar seus preços. Note que se alguém de sua lista de permissões igualar seu arremate porém com um valor de lance menor, o TSM ainda considerará que eles estão cortando seu preço."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Se você tiver múltiplos perfis configurados com operações, habilitar isto fará com que todas as operações, exceto as do perfil atual, sejam irreversivelmente perdidas. Você tem certeza que quer continuar?"
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Se você tem a Integração do WoW com o Twitter habilitada, o TSM irá adicionar um link de compartilhamento para suas mensagens melhoradas de venda / compra, assim como substituir as URLs com um link do TSM."
TSM.L["Ignore Auctions Below Min"] = "Ignorar Leilões Abaixo do Mínimo"
TSM.L["Ignore auctions by duration?"] = "Ignorar Leilões por duração?"
TSM.L["Ignore Characters"] = "Ignorar Personagens"
TSM.L["Ignore Guilds"] = "Ignorar Guildas"
TSM.L["Ignore item variations?"] = "Ignorar variação de itens?"
TSM.L["Ignore operation on characters:"] = "Ignorar operação nos personagens:"
TSM.L["Ignore operation on faction-realms:"] = "Ignorar operação nas facções - reinos:"
TSM.L["Ignored Cooldowns"] = "Recargas Ignoradas"
TSM.L["Ignored Items"] = "Itens Ignorados"
TSM.L["ilvl"] = "nvli"
TSM.L["Import"] = "Importar"
TSM.L["IMPORT"] = "IMPORTAR"
TSM.L["Import %d Items and %s Operations?"] = "Importar %d Itens e %s Operações?"
TSM.L["Import Groups & Operations"] = "Importar Grupos & Operações"
TSM.L["Imported Items"] = "Itens Importados"
TSM.L["Inbox Settings"] = "Configurações da Caixa de Entrada"
TSM.L["Include Attached Operations"] = "Incluir Operações Anexadas"
TSM.L["Include operations?"] = "Incluir operações?"
TSM.L["Include soulbound items"] = "Incluir itens vinculados"
TSM.L["Information"] = "Informação"
TSM.L["Invalid custom price entered."] = "O preço personalizado inserido é inválido."
TSM.L["Invalid custom price source for %s. %s"] = "Fonte de preço personalizado para %s é inválida. %s"
TSM.L["Invalid custom price."] = "Preço personalizado inválido."
TSM.L["Invalid function."] = "Função inválida."
TSM.L["Invalid gold value."] = "Valor em ouro inválido."
TSM.L["Invalid group name."] = "Nome de grupo inválido."
TSM.L["Invalid import string."] = "Código de importação inválido."
TSM.L["Invalid item link."] = "Link inválido de item."
TSM.L["Invalid operation name."] = "Nome de operação inválido."
TSM.L["Invalid operator at end of custom price."] = "Operador inválido no final do preço personalizado."
TSM.L["Invalid parameter to price source."] = "Parâmetro inválido para fonte de preço;"
TSM.L["Invalid player name."] = "Nome de jogador inválido."
TSM.L["Invalid price source in convert."] = "Fonte de preço de conversão inválido."
TSM.L["Invalid price source."] = "Fonte de preço inválida."
TSM.L["Invalid search filter"] = "Filtro de busca inválido"
TSM.L["Invalid seller data returned by server."] = "Informação de vendedor inválida retornada pelo servidor."
TSM.L["Invalid word: '%s'"] = "Palavra inválida: '%s'"
TSM.L["Inventory"] = "Inventário"
TSM.L["Inventory / Gold Graph"] = "Inventário / Gráfico de Ouro"
TSM.L["Inventory / Mailing"] = "Inventário / Correio"
TSM.L["Inventory Options"] = "Opções de Inventário"
TSM.L["Inventory Tooltip Format"] = "Formato da Tooltip de Inventário"
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "Aparentemente você copiou manualmente as variáveis salvas entre contas, o que pode fazer com que a sincronização automática do TSM não funcione. Você precisará desfazer isto, e/ou deletar as variáveis salvas do TradeSkillMaster em ambas as contas (com o WoW fechado) para corrigir isto."
TSM.L["Item"] = "Item"
TSM.L["ITEM CLASS"] = "CATEGORIA DO ITEM"
TSM.L["Item Level"] = "Nível de Item"
TSM.L["ITEM LEVEL RANGE"] = "FAIXA DE NÍVEL DE ITEM"
TSM.L["Item links may only be used as parameters to price sources."] = "Os links de itens só podem ser usados como parâmetros para fontes de preço."
TSM.L["Item Name"] = "Nome do Item"
TSM.L["Item Quality"] = "Qualidade do Item"
TSM.L["ITEM SEARCH"] = "BUSCA DE ITEM"
TSM.L["ITEM SELECTION"] = "SELEÇÃO DE ITEM"
TSM.L["ITEM SUBCLASS"] = "SUBCATEGORIA DO ITEM"
TSM.L["Item Value"] = "Valor do Item"
TSM.L["Item/Group is invalid (see chat)."] = "O Item/Grupo é inválido (veja o chat)."
TSM.L["ITEMS"] = "ITENS"
TSM.L["Items"] = "Itens"
TSM.L["Items in Bags"] = "Itens nas Bolsas"
TSM.L["Keep in bags quantity:"] = "Quantidade a manter nas bolsas:"
TSM.L["Keep in bank quantity:"] = "Quantidade a manter no banco:"
TSM.L["Keep posted:"] = "Quantidade a manter postado:"
TSM.L["Keep quantity:"] = "Quantidade a manter:"
TSM.L["Keep this amount in bags:"] = "Manter esta quantidade nas bolsas:"
TSM.L["Keep this amount:"] = "Manter esta quantidade:"
TSM.L["Keeping %d."] = "Mantendo %d."
TSM.L["Keeping undercut auctions posted."] = "Manter leilões com preços cortados postados."
TSM.L["Last 14 Days"] = "Últimos 14 Dias"
TSM.L["Last 3 Days"] = "Últimos 3 Dias"
TSM.L["Last 30 Days"] = "Últimos 30 Dias"
TSM.L["LAST 30 DAYS"] = "ÚLTIMOS 20 DIAS"
TSM.L["Last 60 Days"] = "Últimos 60 Dias"
TSM.L["Last 7 Days"] = "Últimos 7 Dias"
TSM.L["LAST 7 DAYS"] = "ÚLTIMOS 7 DIAS"
TSM.L["Last Data Update:"] = "Última Atualização de Dados:"
TSM.L["Last Purchased"] = "Comprado pela Última Vez"
TSM.L["Last Sold"] = "Vendido pela Última Vez"
TSM.L["Level Up"] = "Subir de Nível"
TSM.L["LIMIT"] = "LIMITE"
TSM.L["Link to Another Operation"] = "Vincular à Outra Operação"
TSM.L["List"] = "Listar"
TSM.L["List materials in tooltip"] = "Listar materiais na tooltip"
TSM.L["Loading Mails..."] = "Carregando Mensagens..."
TSM.L["Loading..."] = "Carregando..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Parece que o TradeSkillMaster encontrou um erro. Por favor, ajude o autor a corrigir este erro seguindo as instruções exibidas."
TSM.L["Loop detected in the following custom price:"] = "Repetição detectada no seguinte preço personalizado:"
TSM.L["Lowest auction by whitelisted player."] = "Leilão mais baixo pertence a jogador da lista de permissões."
TSM.L["Macro created and scroll wheel bound!"] = "Macro criada e atribuída ao botão de rolagem!"
TSM.L["Macro Setup"] = "Configuração de Macro"
TSM.L["Mail"] = "Correio"
TSM.L["Mail Disenchantables"] = "Enviar Desencantáveis"
TSM.L["Mail Disenchantables Max Quality"] = "Qualidade Máxima para Envio de Desencantáveis"
TSM.L["MAIL SELECTED GROUPS"] = "ENVIAR GRUPOS SELECIONADOS"
TSM.L["Mail to %s"] = "Envio para %s"
TSM.L["Mailing"] = "Correio"
TSM.L["Mailing all to %s."] = "Enviando tudo para %s."
TSM.L["Mailing Options"] = "Operações de Correio"
TSM.L["Mailing up to %d to %s."] = "Enviando até %d para %s."
TSM.L["Main Settings"] = "Configurações Principais"
TSM.L["Make Cash On Delivery?"] = "Enviar Carta a Cobrar?"
TSM.L["Management Options"] = "Opções de Gerenciamento"
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Várias tarefas constantemente usadas no TSM podem ser adicionadas à uma macro e vinculadas ao botão de rolagem de seu mouse. Use as opções abaixo para ajustar esta macro e vinculá-la."
TSM.L["Map Ping"] = "Mapeamento"
TSM.L["Market Value"] = "Valor de Mercado"
TSM.L["Market Value Price Source"] = "Fonte de Preço de Valor de Mercado"
TSM.L["Market Value Source"] = "Fonte de Valor de Mercado"
TSM.L["Mat Cost"] = "Custo do Material"
TSM.L["Mat Price"] = "Preço do Material"
TSM.L["Match stack size?"] = "Igualar tamanho de lote?"
TSM.L["Match whitelisted players"] = "Igualar jogadores da lista de permissões"
TSM.L["Material Name"] = "Nome do Material"
TSM.L["Materials"] = "Materiais"
TSM.L["Materials to Gather"] = "Materiais a Coletar"
TSM.L["MAX"] = "MÁX"
TSM.L["Max Buy Price"] = "Preço Máximo de Compra"
TSM.L["MAX EXPIRES TO BANK"] = "LIMITE DE EXPIRADOS PARA O BANCO"
TSM.L["Max Sell Price"] = "Preço Máximo de Venda"
TSM.L["Max Shopping Price"] = "Preço Máximo de Compra"
TSM.L["Maximum amount already posted."] = "Quantidade máxima já postada."
TSM.L["Maximum Auction Price (Per Item)"] = "Preço Máximo por Leilão (Por Item)"
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Valor Máximo para Destruição (Digite '0c' para desabilitar)"
TSM.L["Maximum disenchant level:"] = "Nível máximo para desencantamento:"
TSM.L["Maximum Disenchant Quality"] = "Qualidade Máxima para Desencantamento"
TSM.L["Maximum disenchant search percentage:"] = "Porcentagem máxima para busca de desencantamento:"
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Valor de Mercado Máximo (Digite '0c' para desabilitar)"
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "QUANTIDADE MÁXIMA A COMPRAR:"
TSM.L["Maximum quantity:"] = "Quantidade máxima:"
TSM.L["Maximum restock quantity:"] = "Quantidade máxima de restoque:"
TSM.L["Mill Value"] = "Valor de Trituração"
TSM.L["Min"] = "Mínimo"
TSM.L["Min Buy Price"] = "Preço Mínimo de Compra"
TSM.L["Min Buyout"] = "Arremate Mínimo"
TSM.L["Min Sell Price"] = "Preço Mínimo de Venda"
TSM.L["Min/Normal/Max Prices"] = "Preços Mínimo/Normal/Máximo"
TSM.L["Minimum Days Old"] = "Mínimo de Dias de Existência"
TSM.L["Minimum disenchant level:"] = "Nível mínimo para desencantamento:"
TSM.L["Minimum expires:"] = "Mínimo de expirados:"
TSM.L["Minimum profit:"] = "Lucro mínimo:"
TSM.L["MINIMUM RARITY"] = "RARIDADE MÍNIMA"
TSM.L["Minimum restock quantity:"] = "Quantidade mínima para restoque:"
TSM.L["Misplaced comma"] = "Vírgula mal colocada"
TSM.L["Missing Materials"] = "Faltam Materiais"
TSM.L["Missing operator between sets of parenthesis"] = "Falta o operador entre os conjuntos de parênteses"
TSM.L["Modifiers:"] = "Modificadores:"
TSM.L["Money Frame Open"] = "Abre Quadro de Dinheiro"
TSM.L["Money Transfer"] = "Transferência de Dinheiro"
TSM.L["Most Profitable Item:"] = "Item Mais Lucrativo:"
TSM.L["MOVE"] = "MOVER"
TSM.L["Move already grouped items?"] = "Mover itens já agrupados?"
TSM.L["Move Quantity Settings"] = "Configurações de Quantidade a Mover"
TSM.L["MOVE TO BAGS"] = "MOVER PARA BOLSAS"
TSM.L["MOVE TO BANK"] = "MOVER PARA BANCO"
TSM.L["MOVING"] = "MOVENDO"
TSM.L["Moving"] = "Movendo"
TSM.L["Multiple Items"] = "Múltiplos Itens"
TSM.L["My Auctions"] = "Meus Leilões"
TSM.L["My Auctions 'CANCEL' Button"] = "Botão 'CANCELAR' em Meus Leilões"
TSM.L["Neat Stacks only?"] = "Apenas Lotes Ajustados?"
TSM.L["NEED MATS"] = "PRECISA DE MATERIAIS"
TSM.L["New Group"] = "Novo grupo"
TSM.L["New Operation"] = "Nova Operação"
TSM.L["NEWS AND INFORMATION"] = "NOVIDADES E INFORMAÇÃO"
TSM.L["No Attachments"] = "Nenhum Anexo"
TSM.L["No Crafts"] = "Nenhuma Criação"
TSM.L["No Data"] = "Nenhum Dado"
TSM.L["No group selected"] = "Nenhum grupo selecionado"
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Nenhum item especificado. Uso /tsm restock_help [LINK_DO_ITEM]"
TSM.L["NO ITEMS"] = "SEM ITENS"
TSM.L["No Materials to Gather"] = "Nenhum Material a Coletar"
TSM.L["No Operation Selected"] = "Nenhuma Operação Selecionada"
TSM.L["No posting."] = "Não postará."
TSM.L["No Profession Opened"] = "Nenhuma Profissão Aberta"
TSM.L["No Profession Selected"] = "Nenhuma Profissão Selecionada"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Nenhum perfil especificado. Possíveis perfis: '%s'"
TSM.L["No recent AuctionDB scan data found."] = "Nenhum dado recente de escaneamento do AuctionDB encontrado."
TSM.L["No Sound"] = "Sem Som"
TSM.L["None"] = "Nenhum"
TSM.L["None (Always Show)"] = "Nenhum (Exibir Sempre)"
TSM.L["None Selected"] = "Nada Selecionado"
TSM.L["NONGROUP TO BANK"] = "NÃO AGRUPADOS PARA BANCO"
TSM.L["Normal"] = "Normal"
TSM.L["Not canceling auction at reset price."] = "Não cancelando leilão ao preço de reset."
TSM.L["Not canceling auction below min price."] = "Não cancelando leilão abaixo do preço mínimo."
TSM.L["Not canceling."] = "Não cancelando."
TSM.L["Not Connected"] = "Não Conectado"
TSM.L["Not enough items in bags."] = "Não há itens suficientes nas bolsas."
TSM.L["NOT OPEN"] = "NÃO ABERTO"
TSM.L["Not Scanned"] = "Não escaneado"
TSM.L["Nothing to move."] = "Nada a mover."
TSM.L["NPC"] = "PNJ"
TSM.L["Number Owned"] = "Quantidade à Disposição"
TSM.L["of"] = "de"
TSM.L["Offline"] = "Desconectado"
TSM.L["On Cooldown"] = "Em Recarga"
TSM.L["Only show craftable"] = "Exibir apenas criáveis"
TSM.L["Only show items with disenchant value above custom price"] = "Apenas exibir itens com valor para desencantamento acima do preço personalizado"
TSM.L["OPEN"] = "ABRIR"
TSM.L["OPEN ALL MAIL"] = "ABRIR TODAS CARTAS"
TSM.L["Open Mail"] = "Abrir Carta"
TSM.L["Open Mail Complete Sound"] = "Som de Abertura de Cartas Completo"
TSM.L["Open Task List"] = "Abrir Lista de Tarefas"
TSM.L["Operation"] = "Operação"
TSM.L["Operations"] = "Operações"
TSM.L["Other Character"] = "Outro Personagem"
TSM.L["Other Settings"] = "Outras Configurações"
TSM.L["Other Shopping Searches"] = "Outras Opções de Compra"
TSM.L["Override default craft value method?"] = "Substituir o método de valor de criação padrão?"
TSM.L["Override parent operations"] = "Substituir operação pai"
TSM.L["Parent Items"] = "Itens Pai"
TSM.L["Past 7 Days"] = "Últimos 7 Dias"
TSM.L["Past Day"] = "Último Dia"
TSM.L["Past Month"] = "Mês Passado"
TSM.L["Past Year"] = "Ano Passado"
TSM.L["Paste string here"] = "Cole o código aqui"
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Cole seu código de importação no campo abaixo e então clique em 'IMPORTAR'. Você por importar de uma lista de itens (separados por vírgula, por favor) a estruturas completas de grupo & operações."
TSM.L["Per Item"] = "Por Item"
TSM.L["Per Stack"] = "Por Lote"
TSM.L["Per Unit"] = "Por Unidade"
TSM.L["Player Gold"] = "Ouro do Jogador"
TSM.L["Player Invite Accept"] = "Convite de Jogador Aceito"
TSM.L["Please select a group to export"] = "Por favor, selecione um grupo para exportar"
TSM.L["POST"] = "POSTAR"
TSM.L["Post at Maximum Price"] = "Postar pelo Valor Máximo"
TSM.L["Post at Minimum Price"] = "Postar pelo Valor Mínimo"
TSM.L["Post at Normal Price"] = "Postar pelo Preço Normal"
TSM.L["POST CAP TO BAGS"] = "LIMITE DE POSTAGEM PARA AS BAGS"
TSM.L["Post Scan"] = "Escanear para Venda"
TSM.L["POST SELECTED"] = "POSTAR SELECIONADO"
TSM.L["POSTAGE"] = "POSTAGEM"
TSM.L["Postage"] = "Postagem"
TSM.L["Posted at whitelisted player's price."] = "Postado ao preço de jogador da lista de permitidos."
TSM.L["Posted Auctions %s:"] = "Leilões Postados %s:"
TSM.L["Posting"] = "Postando"
TSM.L["Posting %d / %d"] = "Postando %d / %d"
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Postando %d lote(s) de %d por %d horas."
TSM.L["Posting at normal price."] = "Postando no preço normal."
TSM.L["Posting at whitelisted player's price."] = "Postando no preço do jogador da lista de permissões."
TSM.L["Posting at your current price."] = "Postando no seu preço atual."
TSM.L["Posting disabled."] = "Postagem desabilitada."
TSM.L["Posting Settings"] = "Configurações de Postagem"
TSM.L["Posts"] = "Postagens"
TSM.L["Potential"] = "Potencial"
TSM.L["Price Per Item"] = "Preço Por Item"
TSM.L["Price Settings"] = "Configurações de Preço"
TSM.L["PRICE SOURCE"] = "FONTE DE PREÇO"
TSM.L["Price source with name '%s' already exists."] = "A fonte de preço com o nome '%s' já existe."
TSM.L["Price Variables"] = "Variáveis de Preço"
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "As Variáveis de Preço permitem que você crie mais preços personalizados para uso no addon. Você poderá usar estas novas variáveis da mesma forma que você pode utilizar fontes de preço padrão como 'vendorsell' e 'vendorbuy',"
TSM.L["PROFESSION"] = "PROFISSÃO"
TSM.L["Profession Filters"] = "Filtros de Profissão"
TSM.L["Profession Info"] = "Info de Profissão"
TSM.L["Profession loading..."] = "Carregando profissão..."
TSM.L["Professions Used In"] = "Usado nas Profissões"
TSM.L["Profile changed to '%s'."] = "Perfil alterado para '%s'."
TSM.L["Profiles"] = "Perfis"
TSM.L["PROFIT"] = "LUCRO"
TSM.L["Profit"] = "Lucro"
TSM.L["Prospect Value"] = "Valor de Prospecção"
TSM.L["PURCHASE DATA"] = "DADOS DE COMPRA"
TSM.L["Purchased (Min/Avg/Max Price)"] = "Comprado (Preço Mínimo/Médio/Máximo)"
TSM.L["Purchased (Total Price)"] = "Comprado (Preço Total)"
TSM.L["Purchases"] = "Compras"
TSM.L["Purchasing Auction"] = "Comprando Leilão"
TSM.L["Qty"] = "Qtde"
TSM.L["Quantity Bought:"] = "Quantidade Comprada:"
TSM.L["Quantity Sold:"] = "Quantidade Vendida:"
TSM.L["Quantity to move:"] = "Quantidade a mover:"
TSM.L["Quest Added"] = "Missão Recebida"
TSM.L["Quest Completed"] = "Missão Concluída."
TSM.L["Quest Objectives Complete"] = "Objetivos da Missão Completos"
TSM.L["QUEUE"] = "FILA"
TSM.L["Quick Sell Options"] = "Opções de Venda Rápida"
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Envie rapidamente todos os itens desencantáveis em excesso para um personagem"
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Envie rapidamente todo o ouro em excesso (limitado à uma certa quantidade) para um personagem"
TSM.L["Raid Warning"] = "Aviso de Raide"
TSM.L["Read More"] = "Ler Mais"
TSM.L["Ready Check"] = "Todos Prontos?"
TSM.L["Ready to Cancel"] = "Pronto para Cancelar"
TSM.L["Realm Data Tooltips"] = "Tooltips de Dados do Reino"
TSM.L["Recent Scans"] = "Escaneamentos Recentes"
TSM.L["Recent Searches"] = "Buscas Recentes"
TSM.L["Recently Mailed"] = "Enviado Recentemente"
TSM.L["RECIPIENT"] = "PARA"
TSM.L["Region Avg Daily Sold"] = "Média de Vendidos Diariamente na Região"
TSM.L["Region Data Tooltips"] = "Tooltips de Dados da Região"
TSM.L["Region Historical Price"] = "Preço Histórico da Região"
TSM.L["Region Market Value Avg"] = "Média de Valor de Mercado da Região"
TSM.L["Region Min Buyout Avg"] = "Média Regional de Arremate Mínimo"
TSM.L["Region Sale Avg"] = "Média de Vendas da Região"
TSM.L["Region Sale Rate"] = "Taxa de Vendas na Região"
TSM.L["Reload"] = "Recarregar"
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVER %d |4ITEM:ITENS;"
TSM.L["Removed a total of %s old records."] = "Um total de %s  dados antigos foram removidos."
TSM.L["Rename"] = "Renomear"
TSM.L["Rename Profile"] = "Renomear Perfil"
TSM.L["REPAIR"] = "REPARAR"
TSM.L["Repair Bill"] = "Conta de Reparo"
TSM.L["Replace duplicate operations?"] = "Substituir operações duplicadas?"
TSM.L["REPLY"] = "RESPONDER"
TSM.L["REPORT SPAM"] = "REPORTAR SPAM"
TSM.L["Repost Higher Threshold"] = "Repostar no Limite mais Alto"
TSM.L["Required Level"] = "Nível Necessário"
TSM.L["REQUIRED LEVEL RANGE"] = "LIMITE DE NÍVEL NECESSÁRIO"
TSM.L["Requires TSM Desktop Application"] = "Requer o App para Desktop do TSM"
TSM.L["Resale"] = "Revenda"
TSM.L["RESCAN"] = "REESCANEAR"
TSM.L["RESET"] = "RESETAR"
TSM.L["Reset All"] = "Resetar Tudo"
TSM.L["Reset Filters"] = "Resetar Filtros"
TSM.L["Reset Profile Confirmation"] = "Confirmação do Reset de Perfil"
TSM.L["RESTART"] = "REINICIAR"
TSM.L["Restart Delay (minutes)"] = "Atraso de Reinício (minutos)"
TSM.L["RESTOCK BAGS"] = "RESTOCAR BOLSAS"
TSM.L["Restock help for %s:"] = "Ajuda de restoque para %s:"
TSM.L["Restock Quantity Settings"] = "Configurações da Quantidade de Restoque"
TSM.L["Restock quantity:"] = "Quantidade para Restoque:"
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCAR GRUPOS SELECIONADOS"
TSM.L["Restock Settings"] = "Configurações de Restoque"
TSM.L["Restock target to max quantity?"] = "Restocar alvo para quantidade máxima?"
TSM.L["Restocking to %d."] = "Restocando para %d."
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocando para um máximo de %d (mínimo de %d) com um lucro mínimo."
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocando para um máximo de %d (mínimo de %d) sem lucro mínimo."
TSM.L["RESTORE BAGS"] = "RESTAURAR BOLSAS"
TSM.L["Resume Scan"] = "Continuar Escaneamento"
TSM.L["Retrying %d auction(s) which failed."] = "Tentando novamente %d leilão(ões) que falharam."
TSM.L["Revenue"] = "Receita"
TSM.L["Round normal price"] = "Arrendondar preço normal"
TSM.L["RUN ADVANCED ITEM SEARCH"] = "EXECUTAR BUSCA AVANÇADA DE ITEM"
TSM.L["Run Bid Sniper"] = "Executar Sniper de Lance"
TSM.L["Run Buyout Sniper"] = "Executar Sniper de Arremate"
TSM.L["RUN CANCEL SCAN"] = "ESCANEAR P/ CANCELAMENTO"
TSM.L["RUN POST SCAN"] = "ESCANEAR P/ VENDA"
TSM.L["RUN SHOPPING SCAN"] = "ESCANEAR PARA COMPRA"
TSM.L["Running Sniper Scan"] = "Executando Escaneamento Sniper"
TSM.L["Sale"] = "Venda"
TSM.L["SALE DATA"] = "DADOS DE VENDA"
TSM.L["Sale Price"] = "Preço de Venda"
TSM.L["Sale Rate"] = "Taxa de Venda"
TSM.L["Sales"] = "Vendas"
TSM.L["SALES"] = "VENDAS"
TSM.L["Sales Summary"] = "Resumo das Vendas"
TSM.L["SCAN ALL"] = "ESCANEAR TUDO"
TSM.L["Scan Complete Sound"] = "Som de Escaneamento Completo"
TSM.L["Scan Paused"] = "Escaneamento Pausado"
TSM.L["SCANNING"] = "ESCANEANDO"
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Escaneando %d / %d (Página %d / %d)"
TSM.L["Scroll wheel direction:"] = "Direção da roda do mouse:"
TSM.L["Search"] = "Buscar"
TSM.L["Search Bags"] = "Buscar nas Bolsas"
TSM.L["Search Groups"] = "Buscar Grupos"
TSM.L["Search Inbox"] = "Buscar Caixa de Entrada"
TSM.L["Search Operations"] = "Buscar Operações"
TSM.L["Search Patterns"] = "Buscar Padrões"
TSM.L["Search Usable Items Only?"] = "Buscar Apenas Itens Usáveis?"
TSM.L["Search Vendor"] = "Buscar no Comerciante"
TSM.L["Select a Source"] = "Selecione uma Fonte"
TSM.L["Select Action"] = "Selecione a Ação"
TSM.L["Select All Groups"] = "Selecionar todos os grupos"
TSM.L["Select All Items"] = "Selecionar Todos os Itens"
TSM.L["Select Auction to Cancel"] = "Selecione o Leilão a Cancelar"
TSM.L["Select crafter"] = "Selecione o personagem"
TSM.L["Select custom price sources to include in item tooltips"] = "Selecione uma fonte de preço personalizado para incluir nas tooltips de itens"
TSM.L["Select Duration"] = "Selecione a Duração"
TSM.L["Select Items to Add"] = "Selecione Itens a Adicionar"
TSM.L["Select Items to Remove"] = "Selecione Itens a Remover"
TSM.L["Select Operation"] = "Selecionar Operações"
TSM.L["Select professions"] = "Selecionar profissões"
TSM.L["Select which accounting information to display in item tooltips."] = "Selecione quais informações de contabilidade você quer exibir nas tooltips de um item."
TSM.L["Select which auctioning information to display in item tooltips."] = "Selecione quais informações de leilão você quer exibir nas tooltips de um item."
TSM.L["Select which crafting information to display in item tooltips."] = "Selecione quais informações de criação você quer exibir nas tooltips de um item."
TSM.L["Select which destroying information to display in item tooltips."] = "Selecione quais informações de destruilçai você quer exibir nas tooltips de um item."
TSM.L["Select which shopping information to display in item tooltips."] = "Selecione quais informações de compras você quer exibir nas tooltips de um item."
TSM.L["Selected Groups"] = "Grupos Selecionados"
TSM.L["Selected Operations"] = "Operações Selecionadas"
TSM.L["Sell"] = "Venda"
TSM.L["SELL ALL"] = "VENDER TUDO"
TSM.L["SELL BOES"] = "VENDER NÃO VINCULADOS"
TSM.L["SELL GROUPS"] = "VENDER GRUPOS"
TSM.L["Sell Options"] = "Opções de Venda"
TSM.L["Sell soulbound items?"] = "Vender itens vinculados?"
TSM.L["Sell to Vendor"] = "Vender para Comerciante"
TSM.L["SELL TRASH"] = "VENDER LIXO"
TSM.L["Seller"] = "Vendedor"
TSM.L["Selling soulbound items."] = "Vendendo itens vinculados."
TSM.L["Send"] = "Enviar"
TSM.L["SEND DISENCHANTABLES"] = "ENVIAR DESENCANTÁVEIS"
TSM.L["Send Excess Gold to Banker"] = "Enviar Excesso de Ouro para Alt Banco"
TSM.L["SEND GOLD"] = "ENVIAR OURO"
TSM.L["Send grouped items individually"] = "Enviar itens agrupados individualmente"
TSM.L["SEND MAIL"] = "ENVIAR CARTA"
TSM.L["Send Money"] = "Enviar Dinheiro"
TSM.L["Send Profile"] = "Enviar Perfil"
TSM.L["SENDING"] = "ENVIANDO"
TSM.L["Sending %s individually to %s"] = "Enviando %s individualmente para %s"
TSM.L["Sending %s to %s"] = "Enviando %s para %s"
TSM.L["Sending %s to %s with a COD of %s"] = "Enviando %s para %s com uma CaC de %s"
TSM.L["Sending Settings"] = "Configurações de Envio"
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Enviando seu perfil '%s' para %s. Por favor, mantenha ambos personagens conectados até isto ser completado. Isto levará aproximadamente: %s"
TSM.L["SENDING..."] = "ENVIANDO..."
TSM.L["Set auction duration to:"] = "Definir a duração do leilão para:"
TSM.L["Set bid as percentage of buyout:"] = "Definir lance como porcentagem do arremate:"
TSM.L["Set keep in bags quantity?"] = "Definir quantidade a manter nas bolsas?"
TSM.L["Set keep in bank quantity?"] = "Definir quantidade a manter no banco?"
TSM.L["Set Maximum Price:"] = "Definir Preço Máximo:"
TSM.L["Set maximum quantity?"] = "Definir quantidade máxima?"
TSM.L["Set Minimum Price:"] = "Definir Preço Mínimo:"
TSM.L["Set minimum profit?"] = "Definir lucro mínimo?"
TSM.L["Set move quantity?"] = "Definir quantidade a mover?"
TSM.L["Set Normal Price:"] = "Definir preço Normal:"
TSM.L["Set post cap to:"] = "Definir limite de postagem em:"
TSM.L["Set posted stack size to:"] = "Definir o tamanho do lote postado em:"
TSM.L["Set stack size for restock?"] = "Definir tamanho de lote para restoque?"
TSM.L["Set stack size?"] = "Definir tamanho de lote?"
TSM.L["Setup"] = "Configuração"
TSM.L["SETUP ACCOUNT SYNC"] = "AJUSTAR SINCRONIZAÇÃO DE CONTAS"
TSM.L["Shards"] = "Estilhaço"
TSM.L["Shopping"] = "Comprar"
TSM.L["Shopping 'BUYOUT' Button"] = "Botão 'ARREMATAR' em Comprar"
TSM.L["Shopping for auctions including those above the max price."] = "Comprando leilões, incluindo aqueles acima do preço máximo."
TSM.L["Shopping for auctions with a max price set."] = "Comprando leilões com um preço máximo definido."
TSM.L["Shopping for even stacks including those above the max price"] = "Comprando lotes ajustados, incluindo aqueles acima do preço"
TSM.L["Shopping for even stacks with a max price set."] = "Comprando lotes ajustados com um preço máximo definido."
TSM.L["Shopping Tooltips"] = "Tooltips de Compras"
TSM.L["SHORTFALL TO BAGS"] = "REPOSIÇÕES PARA BOLSAS"
TSM.L["Show auctions above max price?"] = "Exibir leilões acima do preço?"
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Exibir confirmação de arremate se o preço está acima do preço de alerta"
TSM.L["Show Description"] = "Exibir Descrição"
TSM.L["Show Destroying frame automatically"] = "Exibir janela de Destruição automaticamente"
TSM.L["Show material cost"] = "Exibir custo de material"
TSM.L["Show on Modifier"] = "Exibir no Modificador"
TSM.L["Showing %d Mail"] = "Exibindo %d Carta"
TSM.L["Showing %d of %d Mail"] = "Exibindo %d de %d Carta"
TSM.L["Showing %d of %d Mails"] = "Exibindo %d de %d Cartas"
TSM.L["Showing all %d Mails"] = "Exibindo todas %d Cartas"
TSM.L["Simple"] = "Simples"
TSM.L["SKIP"] = "PULAR"
TSM.L["Skip Import confirmation?"] = "Pular confirmação de Importação?"
TSM.L["Skipped: No assigned operation"] = "Ignorado: Nenhuma operação atribuída"
TSM.L["Slash Commands:"] = "Comandos de barra:"
TSM.L["Sniper"] = "Sniper"
TSM.L["Sniper 'BUYOUT' Button"] = "Botão 'ARREMATAR' em Sniper"
TSM.L["Sniper Options"] = "Opções do Sniper"
TSM.L["Sniper Settings"] = "Configurações do Sniper"
TSM.L["Sniping items below a max price"] = "Executando Snipe em itens abaixo de um preço máximo"
TSM.L["Sold"] = "Vendido"
TSM.L["Sold %d of %s to %s for %s"] = "Vendeu %d de %s para %s por %s"
TSM.L["Sold %s worth of items."] = "Vendeu %s em itens."
TSM.L["Sold (Min/Avg/Max Price)"] = "Vendido (Preço Mínimo/Médio/Máximo)"
TSM.L["Sold (Total Price)"] = "Vendido (Preço Total)"
TSM.L["Sold [%s]x%d for %s to %s"] = "Vendeu [%s]x%d por %s para %s"
TSM.L["Sold Auctions %s:"] = "Leilões Vendidos %s:"
TSM.L["Source"] = "Fonte"
TSM.L["SOURCE %d"] = "FONTE %d"
TSM.L["SOURCES"] = "FONTES"
TSM.L["Sources"] = "Fontes"
TSM.L["Sources to include for restock:"] = "Fontes à incluir no restoque:"
TSM.L["Stack"] = "Lote"
TSM.L["Stack / Quantity"] = "Lote / Quantidade"
TSM.L["Stack size multiple:"] = "Múltiplo para tamanho do lote:"
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Comece escaneamento sniper de 'Arremate' ou 'Lance' usando os botões acima."
TSM.L["Starting Scan..."] = "Começando escaneamento..."
TSM.L["STOP"] = "PARAR"
TSM.L["Store operations globally"] = "Armazenar operações globalmente"
TSM.L["Subject"] = "Assunto"
TSM.L["SUBJECT"] = "ASSUNTO"
TSM.L["Successfully sent your '%s' profile to %s!"] = "Perfil '%s' enviado com sucesso para %s!"
TSM.L["Switch to %s"] = "Mudar para %s"
TSM.L["Switch to WoW UI"] = "IU do WoW"
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Erro de Configuração de Sincronização: o jogador especificado na outra conta não está atualmente online."
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Erro de Configuração de Sincronização: Este personagem já é parte de uma conta conhecida."
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Erro de configuração de sincronização: você inseriu o nome do personagem atual e não o personagem da outra conta."
TSM.L["Sync Status"] = "Status de Sincronização"
TSM.L["TAKE ALL"] = "PEGAR TUDO"
TSM.L["Take Attachments"] = "Pegar Anexos"
TSM.L["Target Character"] = "Personagem Alvo"
TSM.L["TARGET SHORTFALL TO BAGS"] = "REPOSIÇÕES PARA BOLSAS DE ALVOS"
TSM.L["Tasks Added to Task List"] = "Tarefas Adicionadas à Lista de Tarefas"
TSM.L["Text (%s)"] = "Texto (%s)"
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "O filtro canlearn foi ignorado porque o addon CanIMogit não foi encontrado."
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "O 'Método de Valor de Criação' (%s)  não retornou um valor para este item."
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "A fonte de preços 'disenchant' foi substituída pela fonte de preço mais geral, 'destroy'. Por favor, atualize seus preços personalizados."
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "O lucro mínimo (%s) não avaliou um preço válido para este item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "O nome só pode conter APENAS letras. Sem espaços, números ou caracteres especiais."
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "A quantidade que será enfileirada (%d) é menor que a quantidade mínima de restoque (%d)."
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "A operação aplicada à este item é inválida! O restoque mínimo de %d é maior que o restoque máximo de %d."
TSM.L["The player \"%s\" is already on your whitelist."] = "O jogador \"%s\" já está em sua lista de permissões."
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "O lucro deste item (%s) está abaixo do lucro mínimo (%s)."
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "O nome do vendedor para o leilão de %s não foi recuperado pelo servidor. Pulando este item."
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "O TradeSkillMaster_AppHelper está instalado, mas não está habilitado. O TSM o reabilitou e requer um recarregamento."
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "O filtro 'unlearned' foi ignorado porque o addon CanIMogIt não foi encontrado."
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "Existe um preço de criação e valor de item criado, mas o TSM não foi capaz de calcular um lucro. Isso não deve acontecer!"
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "Não há uma operação de Criação aplicada ao grupo TSM deste item (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Este não é um nome de perfil válido. Os nomes de perfil devem ter pelo menos um caractere e não podem conter caracteres '@'."
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "Este item não possui um custo de criação. Certifique-se de que todos os materiais possuam valor de material."
TSM.L["This item is not in a TSM group."] = "Este item não está em um grupo do TSM."
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "Este item será adicionado à fila quando você restocar seu grupo. Caso isto não aconteça, faça um post nos fóruns do TSM com uma screenshot da tooltip do item, configurações de operação e suas configurações gerais de Criação."
TSM.L["This looks like an exported operation and not a custom price."] = "Isto parece uma operação exportada e não um preço personalizado."
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "Isto copiará as configurações de '%s\" dentro do seu ativo atualmente."
TSM.L["This will permanently delete the '%s' profile."] = "Isto excluirá permanentemente o perfil '%s'."
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Isto irá redefinir todos os grupos e operações (se estas não estiverem armazenadas globalmente), e limpá-las deste perfil."
TSM.L["Time"] = "Quando"
TSM.L["Time Format"] = "Formato de Hora"
TSM.L["Time Frame"] = "Período"
TSM.L["TIME FRAME"] = "PERÍODO"
TSM.L["TINKER"] = "INSTALAR"
TSM.L["Tooltip Price Format"] = "Formato de Preço da Tooltip"
TSM.L["Tooltip Settings"] = "Configurações de Tooltip"
TSM.L["Top Buyers:"] = "Top Compradores:"
TSM.L["Top Item:"] = "Top Item:"
TSM.L["Top Sellers:"] = "Top Vendedores:"
TSM.L["Total"] = "Total"
TSM.L["Total Gold"] = "Ouro Total"
TSM.L["Total Gold Collected: %s"] = "Ouro Total Coletado: %s"
TSM.L["Total Gold Earned:"] = "Total de Ouro Ganho:"
TSM.L["Total Gold Spent:"] = "Total de Ouro Gasto:"
TSM.L["Total Price"] = "Preço Total"
TSM.L["Total Profit:"] = "Total de Lucro:"
TSM.L["Total Value"] = "Valor Total"
TSM.L["Total Value of All Items"] = "Valor Total de Todos os Itens"
TSM.L["Track Sales / Purchases via trade"] = "Acompanhar Vendas / Compras via janela de troca"
TSM.L["TradeSkillMaster Info"] = "Info do TradeSkillMaster"
TSM.L["Transform Value"] = "Valor de Transformação"
TSM.L["TSM Banking"] = "TSM Armazenamento"
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "O TSM pode sincronizar automaticamente dados entre múltiplas contas. Você também pode enviar seu perfil atual para contas conectadas para rapidamente enviar grupos e operações para outras contas."
TSM.L["TSM Crafting"] = "TSM Criação"
TSM.L["TSM Destroying"] = "TSM Destruição"
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "O TSM atualmente não possui nenhum dado de AuctionDB para seu reino. Recomendamos o download do App de Desktop do TSM de |cff99ffffhttp://tradeskillmaster.com|r para automaticamente atualizar seus dados do AuctionDB (e fazer backup automático de suas configurações do TSM)"
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "O TSM falhou em escanear alguns leilões. Por favor, execute-o novamente."
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "O TSM está atualmente reconstruindo seu cache de itens, o que pode causar alguma queda de QPS e fazer com que o TSM não esteja totalmente funcional até que este processo seja completado. Isso é normal e geralmente leva menos de um minuto."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM está notando a ausência de algumas informações importantes  do App de Desktop do TSM. Por favor, certifique-se que o App de Desktop do TSM esteja rodando e esteja corretamente configurado."
TSM.L["TSM Mailing"] = "TSM Correio"
TSM.L["TSM TASK LIST"] = "TSM LISTA DE TAREFAS"
TSM.L["TSM Vendoring"] = "TSM Comerciante"
TSM.L["TSM Version Info:"] = "Informações da versão TSM:"
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "O TSM_Accounting detectou que você trocou %s %s por %s. Você gostaria que a Contabilidade armazenasse o registro destra troca?"
TSM.L["TSM4"] = "TSM4"
TSM.L["TUJ 14-Day Price"] = "TUJ - Preço de 14 Dias"
TSM.L["TUJ 3-Day Price"] = "TUJ - Preço de 3 Dias"
TSM.L["TUJ Global Mean"] = "TUJ - Média Global"
TSM.L["TUJ Global Median"] = "TUJ - Mediana Global"
TSM.L["Twitter Integration"] = "Integração com Twitter"
TSM.L["Twitter Integration Not Enabled"] = "Integração com Twitter Não Habilitada"
TSM.L["Type"] = "Tipo"
TSM.L["Type Something"] = "Digite Algo"
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Não foi possível processar a importação porque o grupo alvo (%s) não existe mais. Por favor, tente novamente."
TSM.L["Unbalanced parentheses."] = "Parênteses errados."
TSM.L["Undercut amount:"] = "Valor de corte:"
TSM.L["Undercut by whitelisted player."] = "Preço cortado por jogador na lista de permissões."
TSM.L["Undercutting blacklisted player."] = "Preço cortado por jogador na lista negra."
TSM.L["Undercutting competition."] = "Cortando preço da concorrência."
TSM.L["Ungrouped Items"] = "Itens Desagrupados"
TSM.L["Unknown Item"] = "Item Desconhecido"
TSM.L["Unwrap Gift"] = "Desembrulhar Presente"
TSM.L["Up"] = "Acima"
TSM.L["Up to date"] = "Atualizado"
TSM.L["UPDATE EXISTING MACRO"] = "ATUALIZAR MACRO EXISTENTE"
TSM.L["Updating"] = "Atualizando"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Uso: /tsm price <Link Item> <Fonte de Preço>"
TSM.L["Use smart average for purchase price"] = "Usar média inteligente para preço de compra"
TSM.L["Use the field below to search the auction house by filter"] = "Use o campo abaixo para procurar na casa de leilões por filtro"
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use a lista da esquerda para selecionar grupos & operações para as quais gostaria de criar códigos de exportação."
TSM.L["VALUE PRICE SOURCE"] = "FONTE DE VALOR"
TSM.L["ValueSources"] = "Fontes de Valor"
TSM.L["Variable Name"] = "Nome da Variável"
TSM.L["Vendor"] = "Comerciante"
TSM.L["Vendor Buy Price"] = "Preço de Compra do Comerciante"
TSM.L["Vendor Search"] = "Busca no Comerciante"
TSM.L["VENDOR SEARCH"] = "BUSCA PARA COMERCIANTE"
TSM.L["Vendor Sell"] = "Venda no Comerciante"
TSM.L["Vendor Sell Price"] = "Preço de Venda do Comerciante"
TSM.L["Vendoring 'SELL ALL' Button"] = "Botão 'VENDER TUDO' em Comerciante"
TSM.L["View ignored items in the Destroying options."] = "Visualize itens ignorados nas opções de Destruição."
TSM.L["Warehousing"] = "Armazenamento"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco e %d de cada item quando gbanco/banco > bolsas."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco e %d de cada item quando gbanco/banco > bolsas. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo."
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Armazenamento irá mover um máximo de %d de cada item neste grupo. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco, %d de cada item quando banco/gbanco > bolsas."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco, %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando bolsas > banco/gbanco. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo, mantendo %d de cada item quando banco/gbanco > bolsas. Restoque irá manter %d itens em suas bolsas."
TSM.L["Warehousing will move all of the items in this group."] = "Armazenamento irá mover todos os itens neste grupo."
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Armazenamento irá mover todos os itens neste grupo. Restoque irá manter %d itens em suas bolsas."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "AVISO: A macro era muito longa, então foi reduzida para ser ajustada pelo WoW."
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "AVISO: Seu preço mínimo para %s está abaixo do seu valor de venda ao Comerciante (com o corte da CdL levado em consideração). Considere aumentar seu preço mínimo ou vendê-lo ao Comerciante."
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Bem-vindo(a) ao TSM4! Todos os módulos antigos do TSM3 (ex.: Crafting, Shopping, etc) agora são vinculados ao addon principal do TSM, então você precisa apenas do TSM e TSM_AppHelper instalados. O TSM desabilitou os módulos antigos e requer recarreamento."
TSM.L["When above maximum:"] = "Quando acima do máximo:"
TSM.L["When below minimum:"] = "Quando abaixo do mínimo:"
TSM.L["Whitelist"] = "Lista de Permissões"
TSM.L["Whitelisted Players"] = "Jogadores na Lista de Permissões"
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "Você já possui a sua quantidade máxima de restoque deste item. Você tem %d e a quantidade máxima para restoque é %d"
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Você pode utilizar a opção abaixo para limpar dados antigos. É recomendado excluir dados antigos ocasionalmente para manter o módulo de contabilidade rodando normalmente. Selecione o mínimo de dias para remover, e então clique em '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "Você não pode usar %s como parte desse preço personalizado."
TSM.L["You cannot use %s within convert() as part of this custom price."] = "Você não pode usar %s dentro do convert() como parte deste preço personalizado."
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Você não precisa adicionar \"%s\", alts são adicionados à Lista de Permissões automaticamente."
TSM.L["You don't know how to craft this item."] = "Você não sabe como criar este item."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Você deve atualizar sua UI para que essas mudanças sejam aplicadas. Atualizar agora?"
TSM.L["You won an auction for %sx%d for %s"] = "Você ganhou um leilão de %sx%d por %s"
TSM.L["Your auction has not been undercut."] = "Seu leilão não teve o preço cortado."
TSM.L["Your auction of %s expired"] = "Seu leilão de %s expirou"
TSM.L["Your auction of %s has sold for %s!"] = "Seu leilão %s foi vendido por %s!"
TSM.L["Your Buyout"] = "Seu Arremate"
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Seu método de valor de criação para '%s' era inválido então ele retornou o valor padrão. Detalhes: %s"
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Seu método de valor de criação padrão era inválido então ele retornou o padrão. Detalhes: %s"
TSM.L["Your task list is currently empty."] = "Sua lista de tarefas está atualmente vazia."
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Você foi faseado, o que fez com que a CdL parasse de funcionar devido à um erro no lado dos servidores Blizzards. Por favor, feche e reabra a janela da CdL e reinicie o Sniper."
TSM.L["You've been undercut."] = "Seu preço foi cortado."
	elseif locale == "ruRU" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "Выбрано: группы %d, предметы %d"
TSM.L["%d auctions"] = "лоты: %d"
TSM.L["%d Groups"] = "%d Группы"
TSM.L["%d Items"] = "%d Предметы"
TSM.L["%d of %d"] = "%d по %d"
TSM.L["%d Operations"] = "Операции: %d"
TSM.L["%d Posted Auctions"] = "Активные лоты: %d"
TSM.L["%d Sold Auctions"] = "Проданные лоты: %d"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s сумки, %s банк, %s аукцион, %s почта)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s игрок, %s альты, %s гильдия, %s аукцион)"
TSM.L["%s (%s profit)"] = "%s (%s прибыль)"
TSM.L["%s |4operation:operations;"] = "%s |4действие:действия;"
TSM.L["%s ago"] = "%s назад"
TSM.L["%s Crafts"] = "%s Создать"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
TSM.L["%s in guild vault"] = "%s в банке гильдии"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s корректная индивидуальная цена, но %s некорректный предмет."
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s корректная индивидуальная цена, но не дает стоимость для %s."
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "%s недопустимая команда! Мин. пополнение %d больше, чем макс. %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s некорректная индивидуальная цена, ошибка: %s"
--[[Translation missing --]]
TSM.L["%s Operations"] = "%s Operations"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s удалено."
TSM.L["%s sent you %s"] = "%s отправил вам %s"
TSM.L["%s sent you %s and %s"] = "%s отправил вам %s и %s"
TSM.L["%s sent you a COD of %s for %s"] = "%s отправить наложенным платежом %s для %s"
TSM.L["%s sent you a message: %s"] = "%s отправил вам сообщение: %s"
TSM.L["%s total"] = "всего %s"
TSM.L["%sDrag%s to move this button"] = "%sЗажмите%s чтобы переместить эту кнопку"
TSM.L["%sLeft-Click%s to open the main window"] = "%sЛКМ%s для открытия главного окна"
TSM.L["(%d/500 Characters)"] = "%d / 500 символов"
TSM.L["(max %d)"] = "(макс. %d)"
TSM.L["(max 5000)"] = "(макс. 5000)"
TSM.L["(min %d - max %d)"] = "(мин. %d – макс. %d)"
TSM.L["(min 0 - max 10000)"] = "(мин 0 - макс 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(минимум 0 - максимум 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(минимум 0 - максимум 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(минимум 0 - максимум 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(минимум 0.5 - максимум 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r — Команда покажет справку"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r — Команда откроет окно TSM."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r Когда TSM Accounting сохранял данные для этого сервера, их оказалось слишком много для обработки, поэтому старые данные были стёрты, что бы не повредить переменные. Сохранены последние данные о покупке %s."
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r Когда TSM Accounting сохранял данные для этого сервера, их оказалось слишком много для обработки, поэтому старые данные были стёрты, что бы не повредить переменные. Сохранены последние данные о продаже %s."
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839ЛКМ|r — игнорировать предмет в этой сессии. |cffffd839Shift+ЛКМ|r — игнорировать всегда. Удалить предмет из списка игнора можно в настройках на вкладке Vendoring."
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839ЛКМ|r что бы игнорировать предмет в этой сессии."
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift+ЛКМ|r чтобы игнорировать всегда."
TSM.L["1 Group"] = "1 Группа"
TSM.L["1 Item"] = "1 Предмет"
TSM.L["12 hr"] = "12 ч."
TSM.L["24 hr"] = "24 ч."
TSM.L["48 hr"] = "48 ч."
TSM.L["A custom price of %s for %s evaluates to %s."] = "Индивидуальная цена %s для %s оценивается в %s."
TSM.L["A maximum of 1 convert() function is allowed."] = "Допускается максимум 1 функция convert()."
--[[Translation missing --]]
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
TSM.L["A profile with this name already exists."] = "Профиль с таким именем уже существует."
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "Сканирование уже идёт. Остановите его, прежде чем начать новое."
TSM.L["Above max expires."] = "Превышены попытки выставить."
TSM.L["Above max price. Not posting."] = "Выше макс. Не выставляем."
TSM.L["Above max price. Posting at max price."] = "Выше макс. Ставим по макс. цене."
TSM.L["Above max price. Posting at min price."] = "Выше макс. Ставим по мин. цене."
TSM.L["Above max price. Posting at normal price."] = "Выше макс. Ставим по норм. цене."
TSM.L["Accepting these item(s) will cost"] = "Принять эти предметы будет стоить"
TSM.L["Accepting this item will cost"] = "Принять этот предмет будет стоить"
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Синхронизация аккаунта отключена. Отключите синхронизацию и на другом аккаунте."
TSM.L["Account Syncing"] = "Синхронизация аккаунта"
TSM.L["Accounting"] = "Статистика"
TSM.L["Accounting Tooltips"] = "Подсказки с вашей статистикой"
TSM.L["Activity Type"] = "Вид деятельности"
TSM.L["ADD %d ITEMS"] = "Добавить предметы: %d"
TSM.L["Add / Remove Items"] = "Список предметов"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "Добавить индивидуальный источник цен"
TSM.L["ADD OPERATION"] = "Операция"
TSM.L["Add Player"] = "Добавить игрока"
TSM.L["Add Subject / Description"] = "Тема и описание"
TSM.L["Add Subject / Description (Optional)"] = "Добавить тему и описание письма"
TSM.L["ADD TO MAIL"] = "Добавить к письму"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "Вывод дополнительных ошибок отключен"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Так предметы в группах, связанных с операцией, будут выставлены на аукцион."
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Условия отмены аукционов для предметов в группах, связанных с операцией."
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Установите алгоритмы расчёта цен для предметов в группах, связанных с операцией."
TSM.L["Advanced Item Search"] = "Расширенный поиск"
TSM.L["Advanced Options"] = "Расширенные настройки"
TSM.L["AH"] = "Аукцион"
TSM.L["AH (Crafting)"] = "Аук (Создание)"
TSM.L["AH (Disenchanting)"] = "Аукцион (Распыление)"
TSM.L["AH BUSY"] = "Аук занят"
TSM.L["AH Frame Options"] = "Настройки окна аукциона"
TSM.L["Alarm Clock"] = "Бyдильник"
TSM.L["All Auctions"] = "Все лоты на аукционе"
TSM.L["All Characters and Guilds"] = "Персонажи и гильдии"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
TSM.L["All Professions"] = "Все профессии"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
TSM.L["Allow partial stack?"] = "Выставлять неполные стаки?"
TSM.L["Alt Guild Bank"] = "Банк гильдии альтов"
TSM.L["Alts"] = "Альты"
TSM.L["Alts AH"] = "Аукционы альтов"
TSM.L["Amount"] = "Сумма"
TSM.L["AMOUNT"] = "СУММА"
TSM.L["Amount of Bag Space to Keep Free"] = "Оставлять свободных ячеек в сумках"
TSM.L["APPLY FILTERS"] = "Применить фильтры"
TSM.L["Apply operation to group:"] = "Применить операцию к группе:"
TSM.L["Are you sure you want to clear old accounting data?"] = "Очистить старые данные вашей статистики?"
TSM.L["Are you sure you want to delete this group?"] = "Удалить эту группу?"
TSM.L["Are you sure you want to delete this operation?"] = "Удалить эту операцию?"
TSM.L["Are you sure you want to reset all operation settings?"] = "Сбросить все настройки операции?"
TSM.L["At above max price and not undercut."] = "При превышении макс. цены и не перебит."
TSM.L["At normal price and not undercut."] = "По нормальной цене и не перебит."
TSM.L["Auction"] = "Аукцион"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
TSM.L["AUCTION DETAILS"] = "Детали аукциона"
TSM.L["Auction Duration"] = "Длительность"
TSM.L["Auction has been bid on."] = "Аукцион был объявлен."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "Закрыть окно аукциона"
TSM.L["Auction Window Open"] = "Открыть окно аукциона"
TSM.L["Auctionator - Auction Value"] = "Auctionator - рыночная стоимость"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - Apprаiser"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - рыночная стoимость"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - минимальный выкуп"
TSM.L["Auctioning"] = "Аукцион"
TSM.L["Auctioning Log"] = "Результаты сканирования"
TSM.L["Auctioning Operation"] = "Операции аукциона"
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Кнопки «Выставить» и «Отменить» на аукционе"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "Лоты"
TSM.L["Auto Quest Complete"] = "Автоматически завершающееся задание"
TSM.L["Average Earned Per Day:"] = "Средний заработок в день:"
TSM.L["Average Prices:"] = "Средняя цена:"
TSM.L["Average Profit Per Day:"] = "Средняя прибыль в день:"
TSM.L["Average Spent Per Day:"] = "Средние расходы в день:"
TSM.L["Avg Buy Price"] = "Ср. цена покупки"
TSM.L["Avg Resale Profit"] = "Ср. доход c перепродажи"
TSM.L["Avg Sell Price"] = "Ср. цена продажи"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
TSM.L["BACK TO LIST"] = "Вернуться к списку"
TSM.L["Back to List"] = "Вернуться к списку"
TSM.L["Bag"] = "Сумка"
TSM.L["Bags"] = "Сумки"
TSM.L["Banks"] = "Банки"
TSM.L["Base Group"] = "Базовая группа"
TSM.L["Base Item"] = "Базовый предмет"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Ниже показаны доступные источники цен. %skey|r  - это то, что вы должны ввести в поле индивидуальной цены."
TSM.L["Below custom price:"] = "Ниже индивидуальной цены:"
TSM.L["Below min price. Posting at max price."] = "Ниже мин. Ставим по макс. цене."
TSM.L["Below min price. Posting at min price."] = "Ниже мин. Ставим по мин. цене."
TSM.L["Below min price. Posting at normal price."] = "Ниже мин. Ставим по норм. цене."
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Ниже настройки ваших профилей. Они позволят вам иметь разные наборы групп."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
TSM.L["Bid %d / %d"] = "Ставка %d / %d"
TSM.L["Bid (item)"] = "Ставка (шт)"
TSM.L["Bid (stack)"] = "Ставка (стак)"
TSM.L["Bid Price"] = "Цена ставки"
TSM.L["Bid Sniper Paused"] = "Ставка «Снайпер» на паузе"
TSM.L["Bid Sniper Running"] = "Запущен «Снайпер» по ставкам"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
TSM.L["Blacklisted players:"] = "Игроки в черном списке:"
TSM.L["Bought"] = "Купил"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
TSM.L["Bought %sx%d for %s from %s"] = "Купил %sx%d для %s от %s"
TSM.L["Bound Actions"] = "Связанные действия"
TSM.L["BUSY"] = "Занят"
TSM.L["BUY"] = "Купить"
TSM.L["Buy"] = "Купить"
TSM.L["Buy %d / %d"] = "Купить %d / %d"
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Покупка %d / %d (Подтверждение %d / %d)"
TSM.L["Buy from AH"] = "Купить на аукционе"
TSM.L["Buy from Vendor"] = "Купить у торговца"
TSM.L["BUY GROUPS"] = "Купить группы"
TSM.L["Buy Options"] = "Настройки покупки"
TSM.L["BUYBACK ALL"] = "Выкупить всё"
TSM.L["Buyer/Seller"] = "Покупатель/Продавец"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
TSM.L["Buyout (item)"] = "Выкуп (шт)"
TSM.L["Buyout (stack)"] = "Выкуп (стак)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
TSM.L["Buyout Price"] = "Цена выкупа"
TSM.L["Buyout Sniper Paused"] = "Выкуп «Снайпер» на паузе"
TSM.L["Buyout Sniper Running"] = "Запущен «Снайпер» на выкуп"
TSM.L["BUYS"] = "Покупки"
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "В эту группу по умолчанию входят все предметы, которые вы не добавили в другие группы. Эту группу нельзя изменить или удалить."
TSM.L["Cancel auctions with bids"] = "Отменять аукционы со ставками"
TSM.L["Cancel Scan"] = "Отменить скан."
TSM.L["Cancel to repost higher?"] = "Отменять для повышения цены?"
TSM.L["Cancel undercut auctions?"] = "Отменять перебитые аукционы?"
TSM.L["Canceling"] = "Отмена"
TSM.L["Canceling %d / %d"] = "Отмена %d / %d"
TSM.L["Canceling %d Auctions..."] = "Отмена лотов: %d..."
TSM.L["Canceling all auctions."] = "Отмена всех аукционов."
TSM.L["Canceling auction which you've undercut."] = "Отмена лота, который вы перебили."
TSM.L["Canceling disabled."] = "Отмена отключена."
TSM.L["Canceling Settings"] = "Настройки отмены аукциона"
TSM.L["Canceling to repost at higher price."] = "Отмена для повышения цены."
TSM.L["Canceling to repost at reset price."] = "Отмена для выставления по сниженной цене."
TSM.L["Canceling to repost higher."] = "Отмена для повышения цены."
TSM.L["Canceling undercut auctions and to repost higher."] = "Отмена сбитых лотов и повышение цены."
TSM.L["Canceling undercut auctions."] = "Отмена сбитых лотов."
TSM.L["Cancelled"] = "Отменен"
TSM.L["Cancelled auction of %sx%d"] = "Отмена лота %sx%d"
TSM.L["Cancelled Since Last Sale"] = "Отменено с последней продажи"
TSM.L["CANCELS"] = "Отменённые"
TSM.L["Cannot repair from the guild bank!"] = "Невозможно починиться за счёт гильдии!"
TSM.L["Can't load TSM tooltip while in combat"] = "Нельзя вывести подсказку TSM в бою"
TSM.L["Cash Register"] = "Сумма зарегистрирована"
TSM.L["CHARACTER"] = "ПЕРСОНАЖ"
TSM.L["Character"] = "Персонаж"
TSM.L["Chat Tab"] = "Вкладка чата"
TSM.L["Cheapest auction below min price."] = "Самый дешевый лот ниже мин. цены."
TSM.L["Clear"] = "Очистить"
TSM.L["Clear All"] = "Очистить все"
TSM.L["CLEAR DATA"] = "Очистить данные"
TSM.L["Clear Filters"] = "Очистить"
TSM.L["Clear Old Data"] = "Очистить старые данные"
TSM.L["Clear Old Data Confirmation"] = "Подтверждение очистки старых данных"
TSM.L["Clear Queue"] = "Очистить"
TSM.L["Clear Selection"] = "Очистить выбранное"
TSM.L["COD"] = "наложенный платеж"
TSM.L["Coins (%s)"] = "Монеты (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
TSM.L["Combine Partial Stacks"] = "Объединить неполные стаки"
TSM.L["Combining..."] = "Объединение..."
TSM.L["Configuration Scroll Wheel"] = "Настройка колеса мыши"
TSM.L["Confirm"] = "Подтвердить"
TSM.L["Confirm Complete Sound"] = "Звук окончания подтверждения"
TSM.L["Confirming %d / %d"] = "Подтверждение %d / %d"
TSM.L["Connected to %s"] = "Подключен к %s"
TSM.L["Connecting to %s"] = "Подключение к %s"
TSM.L["CONTACTS"] = "Контакты"
TSM.L["Contacts Menu"] = "Список контактов"
TSM.L["Cooldown"] = "Кулдаун"
TSM.L["Cooldowns"] = "Кулдауны"
TSM.L["Cost"] = "Цена"
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Макрос не создан, потому что их уже слишком много. Удалите один из них и попробуйте снова."
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Профиль '%s' не найден. Доступные профили: '%s'"
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Не могу продать товары из-за отсутствия места в сумках для разделения стака."
TSM.L["Craft"] = "Создать"
TSM.L["CRAFT"] = "Создать"
TSM.L["Craft (Unprofitable)"] = "Создать (Невыгодный)"
TSM.L["Craft (When Profitable)"] = "Создать (Когда выгодно)"
TSM.L["Craft All"] = "Создать всё"
TSM.L["CRAFT ALL"] = "Создать всё"
TSM.L["Craft Name"] = "Название рецепта"
TSM.L["CRAFT NEXT"] = "Создать след."
TSM.L["Craft value method:"] = "Метод расчета стоимости крафта:"
TSM.L["CRAFTER"] = "СОЗДАТЕЛЬ"
TSM.L["CRAFTING"] = "КРАФТ"
TSM.L["Crafting"] = "Крафт"
TSM.L["Crafting Cost"] = "Стоимость создания"
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Кнопка «Создать след.»"
TSM.L["Crafting Queue"] = "Очередь производства"
TSM.L["Crafting Tooltips"] = "Подсказки об изготовлении предметов"
TSM.L["Crafts"] = "Рецепты"
TSM.L["Crafts %d"] = "Создать %d за раз"
TSM.L["CREATE MACRO"] = "Создать макрос"
TSM.L["Create New Operation"] = "Создать новую операцию"
TSM.L["CREATE NEW PROFILE"] = "Создать новый профиль"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "Кристаллы"
TSM.L["Current Profiles"] = "Ваши профили"
TSM.L["CURRENT SEARCH"] = "ТЕКУЩИЙ ПОИСК"
TSM.L["CUSTOM POST"] = "Пользовательское сообщение"
TSM.L["Custom Price"] = "Индивидуальная цена"
TSM.L["Custom Price Source"] = "Индивидуальный источник цен"
TSM.L["Custom Sources"] = "Индивидуальный источник"
TSM.L["Database Sources"] = "Показ источников данных в подсказке"
TSM.L["Default Craft Value Method:"] = "Метод расчёта стоимости крафта по умолчанию:"
TSM.L["Default Material Cost Method:"] = "Метод расчёта стоимости материалов по умолчанию:"
TSM.L["Default Price"] = "Стандартная цена"
TSM.L["Default Price Configuration"] = "Конфигурация цены по умолчанию"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
TSM.L["Delete Profile Confirmation"] = "Подтвердите удаление профиля"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
TSM.L["DEPOSIT REAGENTS"] = "Сложить реагенты"
TSM.L["Deselect All Groups"] = "Снять выделение"
TSM.L["Deselect All Items"] = "Снять выделение"
TSM.L["Destroy Next"] = "Уничтожить следующее"
TSM.L["Destroy Value"] = "Стоимость уничтожения"
TSM.L["Destroy Value Source"] = "Источник стоимости уничтожения"
TSM.L["Destroying"] = "Уничтожение"
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Кнопка «Уничтожить следующее»"
TSM.L["Destroying Tooltips"] = "Подсказки уничтожения"
TSM.L["Destroying..."] = "Уничтожение..."
TSM.L["Details"] = "Детали"
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Лот %s не отменен. Потому что ваш порог для отмены аукциона (%s) не корректен. Проверьте настройки."
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша максимальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не отменен. Ваша максимальная цена (%s) ниже минимальной цены (%s). Проверьте настройки."
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша минимальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша нормальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не отменен. Ваша нормальная цена (%s) ниже минимальной цены (%s). Проверьте настройки."
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Лот %s не отменен. Ваша цена сбивания (%s) не верна. Проверьте настройки."
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Лот %s не выставлен. Blizzard не предоставила для этого нужную информацию. Попробуйте позже."
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Лот %s не выставлен. Владелец лота (%s) с самой низкой ценой находится в вашем черном и белом списке одновременно, так быть не должно. Измените настройки, чтобы исправить эту проблему."
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Лот %s не выставлен. Вы или ваш альт (%s) находитесь в черном списке, так быть не должно. Удалите персонажа из черного списка."
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша максимальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не выставлен. Ваша максимальная цена (%s) ниже, вашей минимальной цены (%s). Проверьте настройки."
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша минимальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша нормальная цена (%s) не верна. Проверьте настройки."
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Лот %s не выставлен. Ваша нормальная цена (%s) ниже, вашей минимальной цены (%s). Проверьте настройки."
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Лот %s не выставлен. Ваша цена сбития (%s) не верна. Проверьте настройки."
TSM.L["Disable invalid price warnings"] = "Отключить предупреждения о неверной цене"
TSM.L["Disenchant Search"] = "Поиск для распыления"
TSM.L["DISENCHANT SEARCH"] = "Поиск для распыления"
TSM.L["Disenchant Search Options"] = "Настройки поиска предметов для распыления"
TSM.L["Disenchant Value"] = "Стоимость распыления"
TSM.L["Disenchanting Options"] = "Настройки распыления"
TSM.L["Display auctioning values"] = "Показать цены на аукционе"
TSM.L["Display cancelled since last sale"] = "Показать сколько раз отменено после последней продажи"
TSM.L["Display crafting cost"] = "Показать стоимость создания"
TSM.L["Display detailed destroy info"] = "Показать подробности уничтожения"
TSM.L["Display disenchant value"] = "Показать стоимость распыления"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
TSM.L["Display group name"] = "Показать имя группы"
TSM.L["Display historical price"] = "Показать историческую цену"
TSM.L["Display market value"] = "Показать рыночную стоимость"
TSM.L["Display mill value"] = "Показать стоимость измельчения"
TSM.L["Display min buyout"] = "Показать минимальную цену"
TSM.L["Display Operation Names"] = "Показать имена операций"
TSM.L["Display prospect value"] = "Показать стоимость просеивания"
TSM.L["Display purchase info"] = "Показать информацию о покупках"
TSM.L["Display region historical price"] = "Показать историческую цену по региону"
TSM.L["Display region market value avg"] = "Показать ср. рыночную стоимость по региону"
TSM.L["Display region min buyout avg"] = "Показать ср. минимальную цену по региону"
TSM.L["Display region sale avg"] = "Показать ср. цену продажи по региону"
TSM.L["Display region sale rate"] = "Показать шанс продажи по региону"
TSM.L["Display region sold per day"] = "Показать статистику ежедневных продаж по региону"
TSM.L["Display sale info"] = "Показать информацию о продажах"
TSM.L["Display sale rate"] = "Показать шанс продажи"
TSM.L["Display shopping max price"] = "Показать максимальную цену покупки"
TSM.L["Display total money recieved in chat?"] = "Показывать общую сумму полученных денег в чат?"
TSM.L["Display transform value"] = "Показать стоимость трансформации (например разделки рыбы)"
TSM.L["Display vendor buy price"] = "Показать цену покупки у торговца"
TSM.L["Display vendor sell price"] = "Показать цену продажи торговцу"
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Вместе с группой вы удалите все её подгруппы."
TSM.L["Done Canceling"] = "Лоты сняты с аукциона"
TSM.L["Done Posting"] = "Лоты выставлены"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
TSM.L["Done Scanning"] = "Сканирование закончено"
TSM.L["Don't post after this many expires:"] = "Количество попыток выставить лот:"
TSM.L["Don't Post Items"] = "Не выставлять"
TSM.L["Don't prompt to record trades"] = "Не предлагать записывать сделки"
TSM.L["DOWN"] = "Вниз"
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Предметы: %d / %d"
TSM.L["Drag Item(s) Into Box"] = "Перетащите предметы сюда"
TSM.L["Duplicate"] = "Скопировать"
TSM.L["Duplicate Profile Confirmation"] = "Подтвердите копирование данных"
TSM.L["Dust"] = "Пыль"
TSM.L["Elevate your gold-making!"] = "Прокачай свои доходы!"
TSM.L["Embed TSM tooltips"] = "Встроить TSM в стандартную подсказку"
TSM.L["EMPTY BAGS"] = "ПУСТЫЕ СУМКИ"
TSM.L["Empty parentheses are not allowed"] = "Не допускаются пустые скобки"
TSM.L["Empty price string."] = "Пустая строка цены"
TSM.L["Enable automatic stack combination"] = "Включить автоматическое создание стака"
TSM.L["Enable buying?"] = "Включить покупки?"
TSM.L["Enable inbox chat messages"] = "Уведомлять о входящих в чате"
TSM.L["Enable restock?"] = "Включить пополнение запасов?"
TSM.L["Enable selling?"] = "Включить продажи?"
TSM.L["Enable sending chat messages"] = "Включить сообщения в чат об исходящих"
TSM.L["Enable TSM Tooltips"] = "Показывать подсказки TSM"
TSM.L["Enable tweet enhancement"] = "Включить поддержку твитов"
TSM.L["Enchant Vellum"] = "Материал для свитка наложения чар"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
TSM.L["Enter a name for the new profile"] = "Введите имя нового профиля"
TSM.L["Enter Filter"] = "Строка поиска"
TSM.L["Enter Keyword"] = "Поиск"
TSM.L["Enter name of logged-in character from other account"] = "Введите имя персонажа от другого аккаунта"
TSM.L["Enter player name"] = "Введите имя игрока"
TSM.L["Essences"] = "Эссенции"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Установка соединения с %s. Убедитесь, что вы ввели имя этого персонажа на другой учётной записи."
TSM.L["Estimated Cost:"] = "Примерная стоимость:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
TSM.L["Estimated Profit:"] = "Планируемая прибыль:"
TSM.L["Exact Match Only?"] = "Только точное соответствие?"
TSM.L["Exclude crafts with cooldowns"] = "Исключить крафты с кулдауном"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
TSM.L["Expenses"] = "Расходы"
TSM.L["EXPENSES"] = "РАСХОДЫ"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
TSM.L["Expired"] = "Истёк"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
TSM.L["Expired Since Last Sale"] = "Истёкший с момента последней продажи"
TSM.L["Expires"] = "Истёкшие"
TSM.L["EXPIRES"] = "Истёкшие"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
TSM.L["Exploration"] = "Исследование"
TSM.L["Export"] = "Экспорт"
TSM.L["Export List"] = "Экспорт"
TSM.L["Failed Auctions"] = "Неудавшиеся"
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Последние неудачные продажи (Истёкшие/Отмененные)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
TSM.L["Failed to bid on auction of %s."] = "Не удалось сделать ставку на %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
TSM.L["Failed to buy auction of %s."] = "Не удалось купить лот %s."
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Не удалось найти лот %s, поэтому он исключен из результатов."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
TSM.L["Favorite Scans"] = "Избранные сканирования"
TSM.L["Favorite Searches"] = "Избранные запросы"
TSM.L["Filter Auctions by Duration"] = "Фильтр по длительности"
TSM.L["Filter Auctions by Keyword"] = "Фильтр по ключевым словам"
TSM.L["Filter by Keyword"] = "Поиск по ключевым словам"
TSM.L["FILTER BY KEYWORD"] = "Поиск по ключевым словам"
TSM.L["Filter group item lists based on the following price source"] = "Фильтровать списки групп предметов на основе следующего источника цен"
TSM.L["Filter Items"] = "Поиск по предметам"
TSM.L["Filter Shopping"] = "Поиск на аукционе"
TSM.L["Finding Selected Auction"] = "Поиск выбранного лота"
TSM.L["Fishing Reel In"] = "Звук рыболовной катушки"
TSM.L["Forget Character"] = "Забыть персонажа"
TSM.L["Found auction sound"] = "Звук найденного лота"
TSM.L["Friends"] = "Друзья"
TSM.L["From"] = "От"
TSM.L["Full"] = "Полный"
TSM.L["Garrison"] = "Гарнизон"
TSM.L["Gathering"] = "Сбор"
TSM.L["Gathering Search"] = "Поиск"
TSM.L["General Options"] = "Основные настройки"
TSM.L["Get from Bank"] = "Забрать из банка"
TSM.L["Get from Guild Bank"] = "Забрать из банка гильдии"
TSM.L["Global Operation Confirmation"] = "Сделать операции глобальными?"
TSM.L["Gold"] = "Золото"
TSM.L["Gold Earned:"] = "Золота получено:"
TSM.L["GOLD ON HAND"] = "ЗОЛОТО ПЕРСОНАЖА"
TSM.L["Gold Spent:"] = "Золота потрачено:"
TSM.L["GREAT DEALS SEARCH"] = "Поиск выгодных предложений"
TSM.L["Group already exists."] = "Группа уже существует."
TSM.L["Group Management"] = "Менеджер групп"
TSM.L["Group Operations"] = "Операции группы"
TSM.L["Group Settings"] = "Настройки группы"
TSM.L["Grouped Items"] = "Предметы в группе"
TSM.L["Groups"] = "Группы"
TSM.L["Guild"] = "Гильдия"
TSM.L["Guild Bank"] = "Банк гильдии"
TSM.L["GVault"] = "Гильдбанк"
TSM.L["Have"] = "Есть"
TSM.L["Have Materials"] = "Есть материалы"
TSM.L["Have Skill Up"] = "Повышают уровень"
TSM.L["Hide auctions with bids"] = "Скрыть лоты со ставками"
TSM.L["Hide Description"] = "Скрыть описание"
TSM.L["Hide minimap icon"] = "Скрыть значок на миникарте"
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Скрыть TSM Banking UI. Напишите /tsm bankui в чат, чтобы открыть снова."
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Скрыть TSM Task List UI. Напишите /tsm tasklist в чат, чтобы открыть снова."
TSM.L["High Bidder"] = "Покупатель"
TSM.L["Historical Price"] = "Историческая цена"
TSM.L["Hold ALT to repair from the guild bank."] = "Удерживайте ALT для починки за счёт гильдии"
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
TSM.L["Hr"] = "Час"
TSM.L["Hrs"] = "Часов"
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "Я только что купил [%s]x%d за %s! %s #TSM4 #warcraft"
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "Я только что продал [%s] за %s! %s #TSM4 #warcraft"
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "Не хотите сбивать цены других игроков? Вы можете добавить их в белый список и TSM не будет сбивать их цены. Помните: если кто-то из списка выставит лот с вашей ценой выкупа, но меньшей ставкой, TSM всё равно будет сбивать цену такого лота."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "Включив эту функцию, вы удалите операции всех своих профилей кроме текущего. С этого момента операции будут одинаковы для всех профилей. Уверены что хотите продолжить?"
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "Если у вас установлена интеграция WoW с Twitter, TSM добавит к публикации дополнение в сообщения о продаже / покупке, а также заменит URL-адреса ссылкой TSM."
TSM.L["Ignore Auctions Below Min"] = "Игнорировать аукционы ниже минимума"
TSM.L["Ignore auctions by duration?"] = "Игнорировать по длительности?"
TSM.L["Ignore Characters"] = "Игнорировать персонажей"
TSM.L["Ignore Guilds"] = "Игнорировать гильдии"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
TSM.L["Ignore operation on characters:"] = "Игнор. операцию на персонажах:"
TSM.L["Ignore operation on faction-realms:"] = "Игнор. для фракции/сервера:"
TSM.L["Ignored Cooldowns"] = "Игнорировать кулдауны"
TSM.L["Ignored Items"] = "Игнорируемые предметы"
TSM.L["ilvl"] = "ilvl"
TSM.L["Import"] = "Импорт"
TSM.L["IMPORT"] = "Импорт"
TSM.L["Import %d Items and %s Operations?"] = "Импортировать предметы: %d, операции: %s."
TSM.L["Import Groups & Operations"] = "Импорт групп и операций"
TSM.L["Imported Items"] = "Импортированные предметы"
TSM.L["Inbox Settings"] = "Настройки входящих"
TSM.L["Include Attached Operations"] = "Экспорт вместе со связанными операциями"
TSM.L["Include operations?"] = "Включить операции?"
TSM.L["Include soulbound items"] = "Включить связанные предметы"
TSM.L["Information"] = "Информация"
TSM.L["Invalid custom price entered."] = "Введена неверная индивидуальная цена."
TSM.L["Invalid custom price source for %s. %s"] = "Неверный источник индивидуальной цены для %s. %s"
TSM.L["Invalid custom price."] = "Недопустимая индивидуальная цена."
TSM.L["Invalid function."] = "Недопустимая функция."
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
TSM.L["Invalid group name."] = "Неверное название группы."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "Недопустимая ссылка на предмет."
TSM.L["Invalid operation name."] = "Неверное название операции."
TSM.L["Invalid operator at end of custom price."] = "Некорректный оператор в конце индивидуальной цены."
TSM.L["Invalid parameter to price source."] = "Некорректный параметр в источнике цены."
TSM.L["Invalid player name."] = "Неверное имя игрока."
TSM.L["Invalid price source in convert."] = "Недопустимая цена источника при преобразовании."
TSM.L["Invalid price source."] = "Неверный источник цены."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
TSM.L["Invalid seller data returned by server."] = "Сервер вернул неверные данные о продавце."
TSM.L["Invalid word: '%s'"] = "Недопустимое слово: '%s'"
TSM.L["Inventory"] = "Инвентарь"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
TSM.L["Inventory / Mailing"] = "Инвентарь/Почта"
TSM.L["Inventory Options"] = "Настройки инвентаря"
TSM.L["Inventory Tooltip Format"] = "Формат инвентаря в подсказке"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "Предмет"
TSM.L["ITEM CLASS"] = "Категория предметов"
TSM.L["Item Level"] = "Уровень предмета"
TSM.L["ITEM LEVEL RANGE"] = "Диапазон уровней предметов"
TSM.L["Item links may only be used as parameters to price sources."] = "Ссылка на предмет может быть использована только как параметр для цены источника."
TSM.L["Item Name"] = "Название предмета"
TSM.L["Item Quality"] = "Качество предмета"
TSM.L["ITEM SEARCH"] = "Поиск предмета"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
TSM.L["ITEM SUBCLASS"] = "Подкатегория предметов"
TSM.L["Item Value"] = "Цена предмета"
TSM.L["Item/Group is invalid (see chat)."] = "Предмет/Группа не верна (см. чат)."
TSM.L["ITEMS"] = "Предметы"
TSM.L["Items"] = "Предметы"
TSM.L["Items in Bags"] = "Предметы в сумках"
TSM.L["Keep in bags quantity:"] = "Оставлять в сумках:"
TSM.L["Keep in bank quantity:"] = "Оставлять в банке:"
TSM.L["Keep posted:"] = "Оставить выставленным:"
TSM.L["Keep quantity:"] = "Сколько оставлять:"
TSM.L["Keep this amount in bags:"] = "Оставить в сумках:"
TSM.L["Keep this amount:"] = "Сколько оставлять:"
TSM.L["Keeping %d."] = "Оставляем %d."
TSM.L["Keeping undercut auctions posted."] = "Оставляем перебитые лоты."
TSM.L["Last 14 Days"] = "Последние 14 дней"
TSM.L["Last 3 Days"] = "Последние 3 дня"
TSM.L["Last 30 Days"] = "Последние 30 дней"
TSM.L["LAST 30 DAYS"] = "ПОСЛЕДНИЕ 30 ДНЕЙ"
TSM.L["Last 60 Days"] = "Последние 60 дней"
TSM.L["Last 7 Days"] = "Последние 7 дней"
TSM.L["LAST 7 DAYS"] = "ПОСЛЕДНИЕ 7 ДНЕЙ"
TSM.L["Last Data Update:"] = "Обновление данных:"
TSM.L["Last Purchased"] = "Последняя покупка"
TSM.L["Last Sold"] = "Последняя продажа"
TSM.L["Level Up"] = "Новый уровень"
TSM.L["LIMIT"] = "ЛИМИТ"
TSM.L["Link to Another Operation"] = "Ссылка на другую операцию"
TSM.L["List"] = "Список"
TSM.L["List materials in tooltip"] = "Показать список материалов"
TSM.L["Loading Mails..."] = "Загрузка почты..."
TSM.L["Loading..."] = "Загрузка..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "Кажется, в TradeSkillMaster произошла ошибка. Пожалуйста, помогите автору проекта её исправить. Следуйте инструкциям ниже."
TSM.L["Loop detected in the following custom price:"] = "В индивидуальной цене обнаружен цикл:"
TSM.L["Lowest auction by whitelisted player."] = "Наименьший лот у игрока из белого списка."
TSM.L["Macro created and scroll wheel bound!"] = "Макрос создан и привязан к колесу мыши!"
TSM.L["Macro Setup"] = "Настройки макросов"
TSM.L["Mail"] = "Почта"
TSM.L["Mail Disenchantables"] = "Отправка распыляемых предметов"
TSM.L["Mail Disenchantables Max Quality"] = "Макс. качество распыляемых предметов для отправки"
TSM.L["MAIL SELECTED GROUPS"] = "Отправить выбранные группы"
TSM.L["Mail to %s"] = "Письмо %s"
TSM.L["Mailing"] = "Отправка"
TSM.L["Mailing all to %s."] = "Отправка всего %s."
TSM.L["Mailing Options"] = "Настройки почты"
TSM.L["Mailing up to %d to %s."] = "Отправка от %d до %s."
TSM.L["Main Settings"] = "Настройки"
TSM.L["Make Cash On Delivery?"] = "Наложенный платёж"
TSM.L["Management Options"] = "Дополнительные настройки"
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Многие часто используемые действия в TSM можно привязать к прокрутке колеса мыши с помощью макросов. Используйте настройки ниже, чтобы экономить время."
TSM.L["Map Ping"] = "Звук пингования по карте"
TSM.L["Market Value"] = "Рыночная стоимость"
TSM.L["Market Value Price Source"] = "Источник «рыночной стоимости»"
TSM.L["Market Value Source"] = "Источник «рыночной стоимости»"
TSM.L["Mat Cost"] = "Цена мат."
TSM.L["Mat Price"] = "Цена мат."
TSM.L["Match stack size?"] = "Точное совпадение размера стака"
TSM.L["Match whitelisted players"] = "Использовать белый список игроков"
TSM.L["Material Name"] = "Название материала"
TSM.L["Materials"] = "Материалы"
TSM.L["Materials to Gather"] = "Материалы для сбора"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
TSM.L["MAX EXPIRES TO BANK"] = "Макс. истёкшие в банк"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
TSM.L["Max Shopping Price"] = "Макс. закупочная цена"
TSM.L["Maximum amount already posted."] = "Макс. количество уже выставлено."
TSM.L["Maximum Auction Price (Per Item)"] = "Максимальная цена лота (за шт)"
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Макс. стоимость уничтожения (введите \"0c\" для отключения)"
TSM.L["Maximum disenchant level:"] = "Макс. уровень для распыления:"
TSM.L["Maximum Disenchant Quality"] = "Макс. качество для распыления"
TSM.L["Maximum disenchant search percentage:"] = "Макс. процент поиска для распыления:"
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Макс. рыночная стоимость (Впишите '0с' что бы отключить)"
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "Максимальное количество для покупки:"
TSM.L["Maximum quantity:"] = "Максимальное количество:"
TSM.L["Maximum restock quantity:"] = "Макс. пополнение запасов:"
TSM.L["Mill Value"] = "Стоимость измельчения"
TSM.L["Min"] = "Мин"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
TSM.L["Min Buyout"] = "Минимальная цена"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
TSM.L["Min/Normal/Max Prices"] = "Мин./Норм./Макс. цена"
TSM.L["Minimum Days Old"] = "Минимум дней"
TSM.L["Minimum disenchant level:"] = "Мин. уровень для распыления:"
TSM.L["Minimum expires:"] = "Минимальный срок действия:"
TSM.L["Minimum profit:"] = "Минимальная прибыль:"
TSM.L["MINIMUM RARITY"] = "Минимальное качество"
TSM.L["Minimum restock quantity:"] = "Мин. пополнение запасов:"
TSM.L["Misplaced comma"] = "Запятая не в том месте"
TSM.L["Missing Materials"] = "Не хватает материалов"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "Модификаторы:"
TSM.L["Money Frame Open"] = "Открытие фрейма с монетами"
TSM.L["Money Transfer"] = "Перевод денег"
TSM.L["Most Profitable Item:"] = "Самый выгодный предмет:"
TSM.L["MOVE"] = "Переместить"
TSM.L["Move already grouped items?"] = "Переместить уже сгруппированное?"
TSM.L["Move Quantity Settings"] = "Настройки перемещения"
TSM.L["MOVE TO BAGS"] = "Положить в сумки"
TSM.L["MOVE TO BANK"] = "Положить в банк"
TSM.L["MOVING"] = "Перемещение"
TSM.L["Moving"] = "Перемещение"
TSM.L["Multiple Items"] = "Разные предметы"
TSM.L["My Auctions"] = "Мои лоты"
TSM.L["My Auctions 'CANCEL' Button"] = "Кнопка «Отмена» моих лотов"
TSM.L["Neat Stacks only?"] = "Только полные стаки?"
TSM.L["NEED MATS"] = "Нужны мат."
TSM.L["New Group"] = "Новая группа"
TSM.L["New Operation"] = "Новая операция"
TSM.L["NEWS AND INFORMATION"] = "Новости и информация"
TSM.L["No Attachments"] = "Нет вложений"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
TSM.L["No Data"] = "Нет данных"
TSM.L["No group selected"] = "Выберите группу"
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "Не указан предмет. Введите: /tsm restock_help [ITEM_LINK]"
TSM.L["NO ITEMS"] = "Нет предметов"
TSM.L["No Materials to Gather"] = "Список сбора материалов пуст"
TSM.L["No Operation Selected"] = "Выберите операцию"
TSM.L["No posting."] = "Нет лотов на аукционе"
TSM.L["No Profession Opened"] = "Профессия не открыта"
TSM.L["No Profession Selected"] = "Выберите профессию"
TSM.L["No profile specified. Possible profiles: '%s'"] = "Не выбран профиль. Возможные профили: '%s'"
TSM.L["No recent AuctionDB scan data found."] = "Нет последних данных сканирования AuctionDB."
TSM.L["No Sound"] = "Без звука"
TSM.L["None"] = "Нет"
TSM.L["None (Always Show)"] = "Нет (всегда отображать)"
TSM.L["None Selected"] = "Ничего не выбрано"
TSM.L["NONGROUP TO BANK"] = "Без группы в банк"
TSM.L["Normal"] = "Обычный"
TSM.L["Not canceling auction at reset price."] = "Не отменять лот для сброса цены."
TSM.L["Not canceling auction below min price."] = "Не отменять лот ниже минимальной цены."
TSM.L["Not canceling."] = "Не отменяется."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
TSM.L["Not enough items in bags."] = "Не хватает предметов в сумках."
TSM.L["NOT OPEN"] = "Не открыто"
TSM.L["Not Scanned"] = "Не сканировано"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
TSM.L["NPC"] = "НПС"
TSM.L["Number Owned"] = "Имеется"
TSM.L["of"] = "по"
TSM.L["Offline"] = "Оффлайн"
TSM.L["On Cooldown"] = "Восстанавливается"
TSM.L["Only show craftable"] = "Есть материалы"
TSM.L["Only show items with disenchant value above custom price"] = "Показывать предметы только где стоимость распыления выше индивидуальной цены"
TSM.L["OPEN"] = "Открыть"
TSM.L["OPEN ALL MAIL"] = "Открыть все письма"
TSM.L["Open Mail"] = "Открыть письмо"
TSM.L["Open Mail Complete Sound"] = "Звук после открытия всех писем"
TSM.L["Open Task List"] = "Открыть список задач"
TSM.L["Operation"] = "Операция"
TSM.L["Operations"] = "Операции"
TSM.L["Other Character"] = "Другой персонаж"
TSM.L["Other Settings"] = "Другие настройки"
TSM.L["Other Shopping Searches"] = "Другие варианты поиска"
TSM.L["Override default craft value method?"] = "Свой метод расчёта стоимости:"
TSM.L["Override parent operations"] = "Отменить родительские операции"
TSM.L["Parent Items"] = "Предметы родительской группы"
TSM.L["Past 7 Days"] = "За последние 7 дней"
TSM.L["Past Day"] = "За последний день"
TSM.L["Past Month"] = "За последний месяц"
TSM.L["Past Year"] = "За последний год"
TSM.L["Paste string here"] = "Вставьте «строку импорта» сюда"
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Вставьте «строку импорта» в поле и нажмите «Импорт». Предметы в строке разделяются запятой. Вы можете импортировать целые структуры групп и операций."
TSM.L["Per Item"] = "За шт"
TSM.L["Per Stack"] = "За стак"
TSM.L["Per Unit"] = "За единицу"
TSM.L["Player Gold"] = "Золото игрока"
TSM.L["Player Invite Accept"] = "Игрок принял приглашение"
TSM.L["Please select a group to export"] = "Выберите группу для экспорта"
TSM.L["POST"] = "Выставить"
TSM.L["Post at Maximum Price"] = "Выставить по максимальной цене"
TSM.L["Post at Minimum Price"] = "Выставить по минимальной цене"
TSM.L["Post at Normal Price"] = "Выставить по норм. цене"
TSM.L["POST CAP TO BAGS"] = "Заполнить сумки"
TSM.L["Post Scan"] = "Скан. для продажи"
TSM.L["POST SELECTED"] = "Выставить выбранное"
TSM.L["POSTAGE"] = "Почтовый сбор"
TSM.L["Postage"] = "Почтовый сбор"
TSM.L["Posted at whitelisted player's price."] = "Выставить по цене игрока из белого списка."
TSM.L["Posted Auctions %s:"] = "Активные лоты %s:"
TSM.L["Posting"] = "Продажа"
TSM.L["Posting %d / %d"] = "Выставить %d / %d"
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Выставить стаки: %d по %d на %d ч."
TSM.L["Posting at normal price."] = "Выставить по нормальной цене."
TSM.L["Posting at whitelisted player's price."] = "Выставить по цене игрока из белого списка."
TSM.L["Posting at your current price."] = "Выставить по текущей цене."
TSM.L["Posting disabled."] = "Выставление отключено."
TSM.L["Posting Settings"] = "Параметры продажи"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
TSM.L["Potential"] = "Потенциал"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
TSM.L["Price Settings"] = "Настройки цены"
TSM.L["PRICE SOURCE"] = "ИСТОЧНИК ЦЕН"
TSM.L["Price source with name '%s' already exists."] = "Источник цены с названием \"%s\" уже существует."
TSM.L["Price Variables"] = "Переменная цены"
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Переменные позволяют создавать продвинутые индивидуальные цены. Вы сможете использовать эти переменные так же, как и встроенные источники цен, такие как «vendorsell» и «vendorbuy»."
TSM.L["PROFESSION"] = "ПРОФЕССИЯ"
TSM.L["Profession Filters"] = "Фильтр рецептов"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
TSM.L["Profession loading..."] = "Профессия загружается..."
TSM.L["Professions Used In"] = "Используется в профессиях"
TSM.L["Profile changed to '%s'."] = "Профиль изменён на '%s'."
TSM.L["Profiles"] = "Профили"
TSM.L["PROFIT"] = "ПРИБЫЛЬ"
TSM.L["Profit"] = "Прибыль"
TSM.L["Prospect Value"] = "Стоимость просеивания"
TSM.L["PURCHASE DATA"] = "Данные о покупке"
TSM.L["Purchased (Min/Avg/Max Price)"] = "Куплено (Мин./Ср./Макс. цена)"
TSM.L["Purchased (Total Price)"] = "Куплено (Общая цена)"
TSM.L["Purchases"] = "Покупки"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
TSM.L["Qty"] = "Кол."
TSM.L["Quantity Bought:"] = "Сколько куплено:"
TSM.L["Quantity Sold:"] = "Сколько продано:"
TSM.L["Quantity to move:"] = "Кол-во перемещаемого:"
TSM.L["Quest Added"] = "Добавлено задание"
TSM.L["Quest Completed"] = "Задание выполнено"
TSM.L["Quest Objectives Complete"] = "Цели задания выполнены"
TSM.L["QUEUE"] = "В очередь"
TSM.L["Quick Sell Options"] = "Настройки быстрой продажи"
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Быстрая отправка лишних предметов, которые можно распылить"
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Быстрая отправка лишнего золота сверх указанного в поле лимита"
TSM.L["Raid Warning"] = "Предупреждение рейда"
TSM.L["Read More"] = "Подробнее"
TSM.L["Ready Check"] = "Проверка готовности"
TSM.L["Ready to Cancel"] = "Готово для отмены"
TSM.L["Realm Data Tooltips"] = "Данные сервера"
TSM.L["Recent Scans"] = "Недавние сканирования"
TSM.L["Recent Searches"] = "Последние поисковые запросы"
TSM.L["Recently Mailed"] = "Последние получ."
TSM.L["RECIPIENT"] = "ПОЛУЧАТЕЛЬ"
TSM.L["Region Avg Daily Sold"] = "Ежедневно покупают по региону"
TSM.L["Region Data Tooltips"] = "Данные региона"
TSM.L["Region Historical Price"] = "Историческая цена по региону"
TSM.L["Region Market Value Avg"] = "Ср. рыночная стоимость по региону"
TSM.L["Region Min Buyout Avg"] = "Ср. минимальная цена по региону"
TSM.L["Region Sale Avg"] = "Ср. цена продажи по региону"
TSM.L["Region Sale Rate"] = "Шанс продажи по региону"
TSM.L["Reload"] = "Перезагрузить"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
TSM.L["Removed a total of %s old records."] = "Удалено старых записей: %s"
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
TSM.L["REPAIR"] = "Ремонт"
TSM.L["Repair Bill"] = "Счёт за ремонт"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
TSM.L["REPLY"] = "Повтор"
TSM.L["REPORT SPAM"] = "Жалоба на спам"
TSM.L["Repost Higher Threshold"] = "Порог для выставления дороже:"
TSM.L["Required Level"] = "Требуемый уровень"
TSM.L["REQUIRED LEVEL RANGE"] = "Диапазон требуемых уровней"
TSM.L["Requires TSM Desktop Application"] = "Требуется TSM Desktop Application"
TSM.L["Resale"] = "Перепродажа"
TSM.L["RESCAN"] = "Пересканировать"
TSM.L["RESET"] = "Сброс"
TSM.L["Reset All"] = "Сбросить всё"
TSM.L["Reset Filters"] = "Сбросить"
TSM.L["Reset Profile Confirmation"] = "Сбросить подтверждение профиля"
TSM.L["RESTART"] = "Перезапуск"
TSM.L["Restart Delay (minutes)"] = "Время перезагрузки (в минутах)"
TSM.L["RESTOCK BAGS"] = "Пополнить сумки"
TSM.L["Restock help for %s:"] = "Помощь в пополнении запасов %s:"
TSM.L["Restock Quantity Settings"] = "Настройки пополнения запасов"
TSM.L["Restock quantity:"] = "Пополнение запасов:"
TSM.L["RESTOCK SELECTED GROUPS"] = "Пополнить запасы предметов из выбранных групп"
TSM.L["Restock Settings"] = "Настройки пополнения запасов"
TSM.L["Restock target to max quantity?"] = "Пополнить до макс. количества?"
TSM.L["Restocking to %d."] = "Пополнить до %d."
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Пополнить до макс. из %d (мин. %d) с мин. прибылью."
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Пополнить до макс. из %d (мин. %d) без мин. прибыли."
TSM.L["RESTORE BAGS"] = "Заполнить сумки"
TSM.L["Resume Scan"] = "Продолжить скан."
TSM.L["Retrying %d auction(s) which failed."] = "Снова пробуем выставить лот %d."
TSM.L["Revenue"] = "Доходы"
TSM.L["Round normal price"] = "Округление нормальной цены"
TSM.L["RUN ADVANCED ITEM SEARCH"] = "Запустить расширенный поиск"
TSM.L["Run Bid Sniper"] = "«Снайпер» по ставкам"
TSM.L["Run Buyout Sniper"] = "«Снайпер» на выкуп"
TSM.L["RUN CANCEL SCAN"] = "Сканировать на отмену"
TSM.L["RUN POST SCAN"] = "Сканировать для продажи"
TSM.L["RUN SHOPPING SCAN"] = "Сканировать для покупки"
TSM.L["Running Sniper Scan"] = "Запущено сканирование «Снайпер»"
TSM.L["Sale"] = "Продажа"
TSM.L["SALE DATA"] = "Данные о продаже"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
TSM.L["Sale Rate"] = "Шанс продажи"
TSM.L["Sales"] = "Продажи"
TSM.L["SALES"] = "Продажи"
TSM.L["Sales Summary"] = "Сводка продаж"
TSM.L["SCAN ALL"] = "Сканировать все"
TSM.L["Scan Complete Sound"] = "Звук окончания сканирования"
TSM.L["Scan Paused"] = "Сканирование на паузе"
TSM.L["SCANNING"] = "Сканирование"
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Сканирование %d / %d (Страница %d / %d)"
TSM.L["Scroll wheel direction:"] = "Направление колеса мыши:"
TSM.L["Search"] = "Поиск"
TSM.L["Search Bags"] = "Искать в сумках"
TSM.L["Search Groups"] = "Поиск группы"
TSM.L["Search Inbox"] = "Поиск в почте"
TSM.L["Search Operations"] = "Поиск операции"
TSM.L["Search Patterns"] = "Поиск по рецептам"
TSM.L["Search Usable Items Only?"] = "Искать только используемые предметы?"
TSM.L["Search Vendor"] = "Поиск у торговца"
TSM.L["Select a Source"] = "Выберите источник"
TSM.L["Select Action"] = "Выберите действие"
TSM.L["Select All Groups"] = "Выбрать все группы"
TSM.L["Select All Items"] = "Выбрать всё"
TSM.L["Select Auction to Cancel"] = "Выберите лот для отмены"
TSM.L["Select crafter"] = "Выберите крафтера"
TSM.L["Select custom price sources to include in item tooltips"] = "Выберите источник пользовательской цены для показа в подсказке"
TSM.L["Select Duration"] = "Выбрать длительность"
TSM.L["Select Items to Add"] = "Выберите предметы для добавления"
TSM.L["Select Items to Remove"] = "Выберите предметы для удаления"
TSM.L["Select Operation"] = "Выбрать операцию"
TSM.L["Select professions"] = "Выбрать профессии"
TSM.L["Select which accounting information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
TSM.L["Select which auctioning information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
TSM.L["Select which crafting information to display in item tooltips."] = "Выберите, какую информацию об изготовлении показывать в подсказке предмета."
TSM.L["Select which destroying information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
TSM.L["Select which shopping information to display in item tooltips."] = "Выберите, какую информацию показывать в подсказке предмета."
TSM.L["Selected Groups"] = "Выбранные группы"
TSM.L["Selected Operations"] = "Выбранные операции"
TSM.L["Sell"] = "Продать"
TSM.L["SELL ALL"] = "Продать всё"
TSM.L["SELL BOES"] = "Продать BoE"
TSM.L["SELL GROUPS"] = "Продать группы"
TSM.L["Sell Options"] = "Настройки продажи"
TSM.L["Sell soulbound items?"] = "Продавать персональные предметы"
TSM.L["Sell to Vendor"] = "Продать торговцу"
TSM.L["SELL TRASH"] = "Продать хлам"
TSM.L["Seller"] = "Продавец"
TSM.L["Selling soulbound items."] = "Продажа персональных предметов."
TSM.L["Send"] = "Отправка"
TSM.L["SEND DISENCHANTABLES"] = "Отправить распыляемое"
TSM.L["Send Excess Gold to Banker"] = "Отправка лишнего золота"
TSM.L["SEND GOLD"] = "Отправить золото"
TSM.L["Send grouped items individually"] = "Отправлять сгруппированные предметы поштучно"
TSM.L["SEND MAIL"] = "Отправить"
TSM.L["Send Money"] = "Отправить деньги"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
TSM.L["SENDING"] = "Отправка"
TSM.L["Sending %s individually to %s"] = "Отправка %s поштучно для %s"
TSM.L["Sending %s to %s"] = "Отправка %s для %s"
TSM.L["Sending %s to %s with a COD of %s"] = "Отправка %s для %s с наложенным платежом %s"
TSM.L["Sending Settings"] = "Настройки отправки"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
TSM.L["SENDING..."] = "Отправка..."
TSM.L["Set auction duration to:"] = "Длительность аукциона:"
TSM.L["Set bid as percentage of buyout:"] = "Ставка в процентах от цены выкупа:"
TSM.L["Set keep in bags quantity?"] = "Сколько оставить в сумках?"
TSM.L["Set keep in bank quantity?"] = "Сколько оставить в банке?"
TSM.L["Set Maximum Price:"] = "Максимальная цена:"
TSM.L["Set maximum quantity?"] = "Установить макс. количество?"
TSM.L["Set Minimum Price:"] = "Минимальная цена:"
TSM.L["Set minimum profit?"] = "Установить мин. прибыль?"
TSM.L["Set move quantity?"] = "Установить сколько перемещать?"
TSM.L["Set Normal Price:"] = "Укажите нормальную цену:"
TSM.L["Set post cap to:"] = "Сколько лотов выставлять:"
TSM.L["Set posted stack size to:"] = "Установить размер стака:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
TSM.L["Setup"] = "Настройка"
TSM.L["SETUP ACCOUNT SYNC"] = "Синхронизировать аккаунт"
TSM.L["Shards"] = "Осколки"
TSM.L["Shopping"] = "Покупка"
TSM.L["Shopping 'BUYOUT' Button"] = "Кнопка «Выкупить» при покупке"
TSM.L["Shopping for auctions including those above the max price."] = "Покупка лотов с ценой, выше максимальной."
TSM.L["Shopping for auctions with a max price set."] = "Покупка лотов с максимальной ценой."
TSM.L["Shopping for even stacks including those above the max price"] = "Покупка полных стаков с ценой, выше максимальной"
TSM.L["Shopping for even stacks with a max price set."] = "Покупка полных стаков с максимальной ценой."
TSM.L["Shopping Tooltips"] = "Подсказки о покупке"
TSM.L["SHORTFALL TO BAGS"] = "Недостаточно в сумках"
TSM.L["Show auctions above max price?"] = "Показать лоты выше макс. цены?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
TSM.L["Show Description"] = "Показать описание"
TSM.L["Show Destroying frame automatically"] = "Показывать окно уничтожения автоматически"
TSM.L["Show material cost"] = "Показать стоимость материалов"
TSM.L["Show on Modifier"] = "Модификатор для показа подсказки"
TSM.L["Showing %d Mail"] = "Показано писем: %d"
TSM.L["Showing %d of %d Mail"] = "Показано писем: %d из %d"
TSM.L["Showing %d of %d Mails"] = "Показано писем: %d из %d"
TSM.L["Showing all %d Mails"] = "Показаны все письма: %d"
TSM.L["Simple"] = "Простой"
TSM.L["SKIP"] = "Пропуск"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
TSM.L["Skipped: No assigned operation"] = "Пропущено: Нет связанной операции"
TSM.L["Slash Commands:"] = "Команды:"
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
TSM.L["Sniper 'BUYOUT' Button"] = "Кнопка «Выкупить» в режиме «Снайпер»"
TSM.L["Sniper Options"] = "Настройки режима «Снайпер»"
TSM.L["Sniper Settings"] = "Настройки режима «Снайпер»"
TSM.L["Sniping items below a max price"] = "Предметы «Снайпера» ниже макс. цены"
TSM.L["Sold"] = "Продан"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
TSM.L["Sold %s worth of items."] = "Продано %s предметов."
TSM.L["Sold (Min/Avg/Max Price)"] = "Продано (Мин./Ср./Макс. цена)"
TSM.L["Sold (Total Price)"] = "Продано (Общая цена)"
TSM.L["Sold [%s]x%d for %s to %s"] = "Продано [%s]x%d для %s %s"
TSM.L["Sold Auctions %s:"] = "Проданные лоты %s:"
TSM.L["Source"] = "Источник"
TSM.L["SOURCE %d"] = "Источник %d"
TSM.L["SOURCES"] = "ИСТОЧНИКИ"
TSM.L["Sources"] = "Источники"
TSM.L["Sources to include for restock:"] = "Учитывать при пополнении:"
TSM.L["Stack"] = "Стак"
TSM.L["Stack / Quantity"] = "Стаков / шт. в стаке"
TSM.L["Stack size multiple:"] = "Размер стака:"
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Запустите режим «Снайпер», используя кнопки «Ставка» или «Выкуп»."
TSM.L["Starting Scan..."] = "Запуск сканирования..."
TSM.L["STOP"] = "Стоп"
TSM.L["Store operations globally"] = "Глобальные операции, общие для всех профилей"
TSM.L["Subject"] = "Тема"
TSM.L["SUBJECT"] = "ТЕМА"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
TSM.L["Switch to %s"] = "Переключиться на %s"
TSM.L["Switch to WoW UI"] = "К интерфейсу WoW"
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Ошибка синхронизации: Выбранный игрок на другой учетной записи в настоящий момент не в сети."
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Ошибка синхронизации: Этот персонаж уже является частью известной учетной записи."
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Ошибка синхронизации: Вы ввели имя текущего персонажа, а не персонажа другой учётной записи."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
TSM.L["TAKE ALL"] = "Взять всё"
TSM.L["Take Attachments"] = "Прикрепить вложения"
TSM.L["Target Character"] = "Имя персонажа"
TSM.L["TARGET SHORTFALL TO BAGS"] = "Этого в сумках недостаточно"
TSM.L["Tasks Added to Task List"] = "Задача добавлена в ваш список"
TSM.L["Text (%s)"] = "Текст (%s)"
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "Фильтр canlearn игнорировался, поскольку аддон CanIMogIt не был найден."
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "Метод расчета стоимости крафта (%s) не вернул значение для этого предмета."
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "Цена 'disenchant' была заменена общим источником цен 'destroy'. Обновите свои индивидуальные цены."
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "Минимальная прибыль (%s) не определена для этого предмета."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "Название может содержать ТОЛЬКО буквы. Без пробелов, чисел или символов."
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "В очередь поставлено (%d) меньше мин. значения пополнения (%d)."
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "Операция для этого предмета не верна. Мин. запас %d больше макс. запаса %d."
TSM.L["The player \"%s\" is already on your whitelist."] = "Игрок \"%s\" уже в белом списке."
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "Прибыль от предмета (%s) это ниже мин. прибыли (%s)"
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "Сервер не вернул имя продавца с самым дешёвым лотом %s. Предмет пропущен."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "Неизвестный фильтр был проигнорирован, т.к. аддон CanIMogIt не найден."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "Некорректное имя профиля. Имя должно содержать хотя бы один символ и не содержать специальные символы."
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "У предмета нет цены создания. Проверьте чтобы все материалы имели цену."
TSM.L["This item is not in a TSM group."] = "Этот предмет не в группе TSM."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
TSM.L["This looks like an exported operation and not a custom price."] = "Это выглядит как экспортированная операция, а не как индивидуальная цена."
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "Хотите скопировать все настройки из «%s» в текущий активный профиль?"
TSM.L["This will permanently delete the '%s' profile."] = "Хотите навсегда удалить профиль «%s»?"
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "Это удалит все группы и операции (не сохраняющиеся глобально) из этого профиля."
TSM.L["Time"] = "Время"
TSM.L["Time Format"] = "Формат времени"
TSM.L["Time Frame"] = "Когда"
TSM.L["TIME FRAME"] = "КОГДА"
TSM.L["TINKER"] = "Быстрый ремонт"
TSM.L["Tooltip Price Format"] = "Формат цен в подсказке"
TSM.L["Tooltip Settings"] = "Подсказки"
TSM.L["Top Buyers:"] = "Лучший покупатель:"
TSM.L["Top Item:"] = "Лучший предмет:"
TSM.L["Top Sellers:"] = "Лучший продавец:"
TSM.L["Total"] = "Итого"
TSM.L["Total Gold"] = "Всего золота"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
TSM.L["Total Gold Earned:"] = "Всего золота получено:"
TSM.L["Total Gold Spent:"] = "Всего золота потрачено:"
TSM.L["Total Price"] = "Общая цена"
TSM.L["Total Profit:"] = "Общая прибыль:"
TSM.L["Total Value"] = "Общая стоимость"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
TSM.L["Track Sales / Purchases via trade"] = "Отслеживать продажи / покупки через торговлю"
TSM.L["TradeSkillMaster Info"] = "Информация TSM"
TSM.L["Transform Value"] = "Стоимость трансформации"
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
TSM.L["TSM Crafting"] = "TSM Crafting"
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM не смог просканировать некоторые лоты. Запустите новое сканирование."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "В TSM отсутствует важная информация из TSM Desktop Application. Убедитесь, что эта программа запущена и правильно настроена."
TSM.L["TSM Mailing"] = "TSM Почта"
TSM.L["TSM TASK LIST"] = "TSM Список задач"
TSM.L["TSM Vendoring"] = "TSM Торговля"
TSM.L["TSM Version Info:"] = "Информация о версии TSM:"
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting обнаружил, что вы поменяли %s %s на %s. Хотите, чтобы Accounting сделал запись об этом обмене?"
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
TSM.L["TUJ 3-Day Price"] = "3-х дневная цена из TUJ"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "Интеграция с Twitter"
TSM.L["Twitter Integration Not Enabled"] = "Интеграция с Twitter не включена"
TSM.L["Type"] = "Тип"
TSM.L["Type Something"] = "Ищите по названию предметов"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "Незакрытые скобки."
TSM.L["Undercut amount:"] = "Снижать цену на:"
TSM.L["Undercut by whitelisted player."] = "Перебито игроком из белого списка."
TSM.L["Undercutting blacklisted player."] = "Сбивать цену игроков из черного списка."
TSM.L["Undercutting competition."] = "Сбиваем цену конкурентов."
TSM.L["Ungrouped Items"] = "Предметы без группы"
TSM.L["Unknown Item"] = "Неизвестный предмет"
TSM.L["Unwrap Gift"] = "Развернуть подарок"
TSM.L["Up"] = "Вверх"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
TSM.L["UPDATE EXISTING MACRO"] = "Обновить внешний макрос"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "Использование: /tsm price <Предмет> <Цена>"
TSM.L["Use smart average for purchase price"] = "Использовать умную усредненную цену для покупки"
TSM.L["Use the field below to search the auction house by filter"] = "Для поиска на аукционе используйте поле ниже"
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Выберите группы в списке слева и настройте экспорт операций, связанных с ними. При импорте структура групп сохранится."
TSM.L["VALUE PRICE SOURCE"] = "Источник цены"
TSM.L["ValueSources"] = "Источники цен"
TSM.L["Variable Name"] = "Имя переменной"
TSM.L["Vendor"] = "Торговец"
TSM.L["Vendor Buy Price"] = "Покупка у торговца"
TSM.L["Vendor Search"] = "Поиск для продажи торговцу"
TSM.L["VENDOR SEARCH"] = "Поиск для продажи торговцу"
TSM.L["Vendor Sell"] = "Продажа торговцу"
TSM.L["Vendor Sell Price"] = "Продажа торговцу"
TSM.L["Vendoring 'SELL ALL' Button"] = "Кнопка «Продать всё» торговцу"
TSM.L["View ignored items in the Destroying options."] = "Показать игнорируемые предметы в настройках уничтожения."
TSM.L["Warehousing"] = "Хранение"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в сумках > банка/гбанка. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в банке/гбанке > сумок."
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы, возвращая %d предметов назад когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Склад переместит макс. %d предметов из группы."
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Склад переместит макс. %d предметов из группы. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка, %d когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в сумках > банка/гбанка. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в банке/гбанке > сумок."
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Склад переместит все предметы из группы, возвращая %d предметов назад когда в банке/гбанке > сумок. Пополнение запасов оставит %d предметов в сумках."
TSM.L["Warehousing will move all of the items in this group."] = "Склад будет перемещать все предметы из группы."
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Склад будет перемещать все предметы из группы. Пополнение запасов оставит %d в сумках."
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "ВНИМАНИЕ: Макрос был слишком длинным, поэтому он обрезан игрой."
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "ВНИМАНИЕ: Ваша минимальная цена для %s ниже, чем продажа предмета торговцу (с учётом сбивания цены на аукционе). Советуем увеличить минимальную цену или продать предмет торговцу."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
TSM.L["When above maximum:"] = "Когда выше максимума:"
TSM.L["When below minimum:"] = "Когда ниже минимума:"
TSM.L["Whitelist"] = "Белый список"
TSM.L["Whitelisted Players"] = "Добавление игроков в белый список"
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "У вас уже достаточно этих предметов. У вас есть %d, а максимально вам нужно %d"
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "Используйте настройки ниже для очистки старых данных. Мы рекомендуем периодически чистить данные, чтобы модуль статистики работал исправно. Выберите минимальное количество дней, которое нужно удалить, затем нажмите '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "Вы не можете использовать %s как часть индивидуальной цены."
TSM.L["You cannot use %s within convert() as part of this custom price."] = "Вы не можете использовать %s без convert() как часть этой индивидуальной цены."
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "Вам не нужно добавлять «%s», альты попадают в белый список автоматически."
TSM.L["You don't know how to craft this item."] = "Вы не умеете создавать этот предмет."
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "Вы должны перезагрузить свой интерфейс, чтобы эти настройки вступили в силу. Перезагрузить сейчас?"
TSM.L["You won an auction for %sx%d for %s"] = "Вы выиграли лот %sx%d за %s"
TSM.L["Your auction has not been undercut."] = "Ваш лот не перебит."
TSM.L["Your auction of %s expired"] = "Время вашего лота %s истекло"
TSM.L["Your auction of %s has sold for %s!"] = "Ваш лот %s был продан за %s!"
TSM.L["Your Buyout"] = "Выкуп"
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Ваш метод расчета стоимости крафта для '%s' не верен, поэтому был использован метод по умолчанию. Подробности: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
TSM.L["Your task list is currently empty."] = "Ваш список задач пуст."
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "Из-за ошибки на стороне Blizzard аукцион перестал работать. Закройте и снова откройте аукцион и перезапустите «Снайпер»."
TSM.L["You've been undercut."] = "Вашу цену сбили."
	elseif locale == "zhCN" then
TSM.L = TSM.L or {}
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group：群组; 已选择（%d |4项目：项目;）"
TSM.L["%d auctions"] = "%d拍卖"
TSM.L["%d Groups"] = "%d分组"
TSM.L["%d Items"] = "%d物品"
TSM.L["%d of %d"] = "发布%d堆，每堆%d个"
TSM.L["%d Operations"] = "%d操作"
TSM.L["%d Posted Auctions"] = "已发布%d个拍卖"
TSM.L["%d Sold Auctions"] = "%d个拍卖已卖出"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s 背包, %s 银行, %s 拍卖行, %s 邮件)"
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s 玩家, %s 小号, %s 公会, %s 拍卖行)"
TSM.L["%s (%s profit)"] = "%s (%s 利润)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
TSM.L["%s ago"] = "%s之前"
TSM.L["%s Crafts"] = "%s制造"
TSM.L["%s group updated with %d items and %d materials."] = "%s组已更新%d件和%d件材料。"
TSM.L["%s in guild vault"] = "公会仓库中 %s"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s 是一个有效的自定义价格但 %s 是一个无效的物品。"
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s 是一个有效的自定义价格但没有为 %s 给出一个值。"
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s'是一个无效的操作! 因为最小补货数量%d超过最高补货数量%d。"
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s 不是一个有效的自定义价格,错误信息: %s"
TSM.L["%s Operations"] = "%s操作"
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s 预先配置了最大数量，所以移除 %s"
TSM.L["%s removed."] = "移除 %s 。"
TSM.L["%s sent you %s"] = "%s邮寄给你%s"
TSM.L["%s sent you %s and %s"] = "%s邮寄给你%s和%s"
TSM.L["%s sent you a COD of %s for %s"] = "%s给你发送付费邮件%s以%s的价格"
TSM.L["%s sent you a message: %s"] = "%s发送给你一条消息：%s"
TSM.L["%s total"] = "共计 %s"
TSM.L["%sDrag%s to move this button"] = "%s按住%s以拖动此按钮"
TSM.L["%sLeft-Click%s to open the main window"] = "%s左键单击%s打开主窗口"
TSM.L["(%d/500 Characters)"] = "(%d/500个角色)"
TSM.L["(max %d)"] = "(最高 %d)"
TSM.L["(max 5000)"] = "(最多5000)"
TSM.L["(min %d - max %d)"] = "(最低%d - 最高%d)"
TSM.L["(min 0 - max 10000)"] = "(最低 0 - 最高 10000)"
TSM.L["(minimum 0 - maximum 20)"] = "(0 - 20)"
TSM.L["(minimum 0 - maximum 2000)"] = "(0 - 2000)"
TSM.L["(minimum 0 - maximum 905)"] = "(0 - 905)"
TSM.L["(minimum 0.5 - maximum 10)"] = "(0.5 - 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help - 显示帮助列表"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm - 打开TSM主窗口。"
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000重要通知:|r TSM_Accounting在本服务器最后的存储数据对WOW来说太大了，旧的数据将被自动删除以避免损坏已保存的参数。最后的 %s 购买数据已保留。"
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000重要通知:|r 当TSM_Accounting在本服务器最后的存储数据对WOW来说太大难以处理，旧的数据将被削减以避免损坏已保存的参数。最后的 %s 出售数据已保存。"
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839左键点击|r 临时忽略物品。按住|cffffd839Shift|r 左键点击永久忽略物品。你可以在Vendoring设置中从永久忽略列表中移除物品。"
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839左键点击|r临时忽略物品。"
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift+左键|r永久忽略物品。"
TSM.L["1 Group"] = "1 组"
TSM.L["1 Item"] = "1 项物品"
TSM.L["12 hr"] = "12 小时"
TSM.L["24 hr"] = "24 小时"
TSM.L["48 hr"] = "48 小时"
TSM.L["A custom price of %s for %s evaluates to %s."] = "%s的自定义价格为%s到%s。"
TSM.L["A maximum of 1 convert() function is allowed."] = "最多允许1兑换函数。"
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "目标账号上已存在同名档案。请在重新命名后重试。"
TSM.L["A profile with this name already exists."] = "已存在同名档案。"
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "一项扫描正在进行中。在开始新的扫描之前请停止前一项扫描。"
TSM.L["Above max expires."] = "超过最大流拍次数。"
TSM.L["Above max price. Not posting."] = "超出最高价。不发布。"
TSM.L["Above max price. Posting at max price."] = "超出最高价。以最高价发布。"
TSM.L["Above max price. Posting at min price."] = "超出最高价。以最低价发布。"
TSM.L["Above max price. Posting at normal price."] = "超出最高价。以正常价发布。"
TSM.L["Accepting these item(s) will cost"] = "接受这些物品将花费"
TSM.L["Accepting this item will cost"] = "接受此物品将花费"
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "帐户同步已删除, 请同时从其他帐户中删除帐户同步."
TSM.L["Account Syncing"] = "账务同步"
TSM.L["Accounting"] = "账务"
TSM.L["Accounting Tooltips"] = "账务提示"
TSM.L["Activity Type"] = "活动类型"
TSM.L["ADD %d ITEMS"] = "添加%d物品"
TSM.L["Add / Remove Items"] = "增加/移除 物品"
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "添加新的自定义价格"
TSM.L["ADD OPERATION"] = "添加操作"
TSM.L["Add Player"] = "添加玩家"
TSM.L["Add Subject / Description"] = "添加主题/描述"
TSM.L["Add Subject / Description (Optional)"] = "添加主题/描述（可选）"
TSM.L["ADD TO MAIL"] = "添加至邮件"
TSM.L["Added '%s' profile which was received from %s."] = "添加了从%s收到的'%s'个人资料。"
TSM.L["Added %s to %s."] = "已将%s添加至%s。"
TSM.L["Additional error suppressed"] = "已阻止的其他错误"
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "调整下面的设置以应用到该操作的拍卖分组"
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "调整下面的设置以应用到该操作的取消分组"
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "调整以下设置以设置添加到此操作分组组的定价方式。"
TSM.L["Advanced Item Search"] = "高级物品搜索"
TSM.L["Advanced Options"] = "高级设置"
TSM.L["AH"] = "拍卖行"
TSM.L["AH (Crafting)"] = "拍卖行（制造业）"
TSM.L["AH (Disenchanting)"] = "拍卖行（分解）"
TSM.L["AH BUSY"] = "拍卖行繁忙"
TSM.L["AH Frame Options"] = "拍卖行框体选项"
TSM.L["Alarm Clock"] = "闹钟"
TSM.L["All Auctions"] = "所有拍卖"
TSM.L["All Characters and Guilds"] = "所有角色和专精"
TSM.L["All Item Classes"] = "所有物品类别"
TSM.L["All Professions"] = "所有专业"
TSM.L["All Subclasses"] = "所有子类别"
TSM.L["Allow partial stack?"] = "允许部分堆叠"
TSM.L["Alt Guild Bank"] = "小号工会银行"
TSM.L["Alts"] = "小号"
TSM.L["Alts AH"] = "小号AH"
TSM.L["Amount"] = "数量"
TSM.L["AMOUNT"] = "数量"
TSM.L["Amount of Bag Space to Keep Free"] = "背包剩余空间"
TSM.L["APPLY FILTERS"] = "应用筛选"
TSM.L["Apply operation to group:"] = "应用操作到分组："
TSM.L["Are you sure you want to clear old accounting data?"] = "确定清除旧的账务数据吗？"
TSM.L["Are you sure you want to delete this group?"] = "你确定要删除这个分组吗？"
TSM.L["Are you sure you want to delete this operation?"] = "你确定要删除这个操作吗？"
TSM.L["Are you sure you want to reset all operation settings?"] = "确定要重置操作设置吗？"
TSM.L["At above max price and not undercut."] = "高于最高价格且未被压价。"
TSM.L["At normal price and not undercut."] = "处于正常价格且未被压价。"
TSM.L["Auction"] = "拍卖"
TSM.L["Auction Bid"] = "竞标价格"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
TSM.L["AUCTION DETAILS"] = "拍卖细节"
TSM.L["Auction Duration"] = "拍卖时效"
TSM.L["Auction has been bid on."] = "已被竞标。"
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "拍卖窗口关闭"
TSM.L["Auction Window Open"] = "拍卖窗口打开"
TSM.L["Auctionator - Auction Value"] = "Auctionator - 拍卖价格"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - 估价"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - 市场价"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - 最低一口价"
TSM.L["Auctioning"] = "拍卖"
TSM.L["Auctioning Log"] = "拍卖日志"
TSM.L["Auctioning Operation"] = "拍卖操作"
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "拍卖 '发布'/'取消' 按钮"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "拍卖"
TSM.L["Auto Quest Complete"] = "自动完成任务"
TSM.L["Average Earned Per Day:"] = "每日平均收入："
TSM.L["Average Prices:"] = "平均价："
TSM.L["Average Profit Per Day:"] = "每日平均利润："
TSM.L["Average Spent Per Day:"] = "每日平均花费："
TSM.L["Avg Buy Price"] = "平均买入价"
TSM.L["Avg Resale Profit"] = "平均转卖利润"
TSM.L["Avg Sell Price"] = "平均卖出价"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
TSM.L["BACK TO LIST"] = "返回列表"
TSM.L["Back to List"] = "返回列表"
TSM.L["Bag"] = "背包"
TSM.L["Bags"] = "背包"
TSM.L["Banks"] = "银行"
TSM.L["Base Group"] = "基础分组"
TSM.L["Base Item"] = "基础物品"
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "以下是你当前通过模块获得的可购入价格。点击%s来输入你的自定义价格。"
TSM.L["Below custom price:"] = "低于自定义价格："
TSM.L["Below min price. Posting at max price."] = "低于最低价。按最高价发布。"
TSM.L["Below min price. Posting at min price."] = "低于最低价。按最低价发布。"
TSM.L["Below min price. Posting at normal price."] = "低于最低价。按正常价发布。"
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "以下，您可以管理您的配置文件，这些配置文件允许您拥有完全不同的分组。"
TSM.L["BID"] = "竞拍"
TSM.L["Bid %d / %d"] = "竞拍%d / %d"
TSM.L["Bid (item)"] = "竞拍（物品）"
TSM.L["Bid (stack)"] = "出价（堆叠）"
TSM.L["Bid Price"] = "竞拍价格"
TSM.L["Bid Sniper Paused"] = "狙击竞价暂停"
TSM.L["Bid Sniper Running"] = "运行狙击竞标"
TSM.L["Bidding Auction"] = "竞标拍卖"
TSM.L["Blacklisted players:"] = "黑名单玩家:"
TSM.L["Bought"] = "买入"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
TSM.L["Bought %sx%d for %s from %s"] = "买入 %sx%d 为 %s 从 %s"
TSM.L["Bound Actions"] = "限制操作"
TSM.L["BUSY"] = "繁忙"
TSM.L["BUY"] = "购买"
TSM.L["Buy"] = "购买"
TSM.L["Buy %d / %d"] = "购买%d / %d"
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "购买 %d / %d (确认 %d / %d)"
TSM.L["Buy from AH"] = "从拍卖行购买"
TSM.L["Buy from Vendor"] = "从NPC购买"
TSM.L["BUY GROUPS"] = "购买分组"
TSM.L["Buy Options"] = "购买选项"
TSM.L["BUYBACK ALL"] = "全部回购"
TSM.L["Buyer/Seller"] = "购买者/出售者"
TSM.L["BUYOUT"] = "一口价"
TSM.L["Buyout (item)"] = "一口价（物品）"
TSM.L["Buyout (stack)"] = "一口价（堆叠）"
TSM.L["Buyout Confirmation Alert"] = "一口价确认提醒"
TSM.L["Buyout Price"] = "一口价"
TSM.L["Buyout Sniper Paused"] = "狙击购买已暂停"
TSM.L["Buyout Sniper Running"] = "狙击购买中"
TSM.L["BUYS"] = "购买"
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "默认情况下，此分组中的所有物品不能分配到分组中。此分组无法删除。"
TSM.L["Cancel auctions with bids"] = "取消已被竞标的拍卖"
TSM.L["Cancel Scan"] = "取消扫描"
TSM.L["Cancel to repost higher?"] = "取消并以更高价发布？"
TSM.L["Cancel undercut auctions?"] = "取消被压价的拍卖？"
TSM.L["Canceling"] = "取消"
TSM.L["Canceling %d / %d"] = "取消%d / %d"
TSM.L["Canceling %d Auctions..."] = "取消%d拍卖..."
TSM.L["Canceling all auctions."] = "取消全部拍卖。"
TSM.L["Canceling auction which you've undercut."] = "取消被压价的拍卖。"
TSM.L["Canceling disabled."] = "取消禁用"
TSM.L["Canceling Settings"] = "取消设置"
TSM.L["Canceling to repost at higher price."] = "取消并以更高价格发布。"
TSM.L["Canceling to repost at reset price."] = "取消并以转卖价发布。"
TSM.L["Canceling to repost higher."] = "取消并以更高价发布。"
TSM.L["Canceling undercut auctions and to repost higher."] = "取消被压价拍卖并以更高价发布。"
TSM.L["Canceling undercut auctions."] = "取消被压价拍卖。"
TSM.L["Cancelled"] = "已取消"
TSM.L["Cancelled auction of %sx%d"] = "取消%sx%d的拍卖"
TSM.L["Cancelled Since Last Sale"] = "自上次售出之后取消拍卖"
TSM.L["CANCELS"] = "取消"
TSM.L["Cannot repair from the guild bank!"] = "无法从公会银行修理"
TSM.L["Can't load TSM tooltip while in combat"] = "战斗中不能载入TSM鼠标提示"
TSM.L["Cash Register"] = "收银台"
TSM.L["CHARACTER"] = "角色"
TSM.L["Character"] = "角色"
TSM.L["Chat Tab"] = "聊天标签"
TSM.L["Cheapest auction below min price."] = "低于最低价的拍卖。"
TSM.L["Clear"] = "清除"
TSM.L["Clear All"] = "清除所有"
TSM.L["CLEAR DATA"] = "清除数据"
TSM.L["Clear Filters"] = "清除筛选"
TSM.L["Clear Old Data"] = "清除旧数据"
TSM.L["Clear Old Data Confirmation"] = "清除旧数据确认"
TSM.L["Clear Queue"] = "清除队列"
TSM.L["Clear Selection"] = "取消选择"
TSM.L["COD"] = "付费邮件"
TSM.L["Coins (%s)"] = "(%s) 金币"
TSM.L["Collapse All Groups"] = "折叠所有群组"
TSM.L["Combine Partial Stacks"] = "合并堆叠"
TSM.L["Combining..."] = "合并中..."
TSM.L["Configuration Scroll Wheel"] = "配置滚轮"
TSM.L["Confirm"] = "确认"
TSM.L["Confirm Complete Sound"] = "确认完成音效"
TSM.L["Confirming %d / %d"] = "确认%d / %d"
TSM.L["Connected to %s"] = "已连接 %s..."
TSM.L["Connecting to %s"] = "正在连接到%s"
TSM.L["CONTACTS"] = "联络"
TSM.L["Contacts Menu"] = "联络菜单"
TSM.L["Cooldown"] = "冷却"
TSM.L["Cooldowns"] = "冷却"
TSM.L["Cost"] = "成本"
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "无法创建宏，因为你的宏已经满了。删除一些宏后重试。"
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "找不到配置文件 '%s' 。可能是配置文件 '%s' 。"
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "由于没有可用于分割一组堆叠物品的空余背包空间，因此无法出售物品"
TSM.L["Craft"] = "制造"
TSM.L["CRAFT"] = "制造"
TSM.L["Craft (Unprofitable)"] = "制造（无利润的）"
TSM.L["Craft (When Profitable)"] = "制造（有利润时）"
TSM.L["Craft All"] = "制造所有"
TSM.L["CRAFT ALL"] = "制造所有"
TSM.L["Craft Name"] = "制造品名称"
TSM.L["CRAFT NEXT"] = "制作下一个"
TSM.L["Craft value method:"] = "计算制造成本的方法："
TSM.L["CRAFTER"] = "制造者"
TSM.L["CRAFTING"] = "制造"
TSM.L["Crafting"] = "制造"
TSM.L["Crafting Cost"] = "制造成本"
TSM.L["Crafting 'CRAFT NEXT' Button"] = "制造\"制造下一个\"按钮"
TSM.L["Crafting Queue"] = "制造队列"
TSM.L["Crafting Tooltips"] = "制造鼠标提示"
TSM.L["Crafts"] = "制造"
TSM.L["Crafts %d"] = "制造%d"
TSM.L["CREATE MACRO"] = "创建宏"
TSM.L["Create New Operation"] = "创建新的操作"
TSM.L["CREATE NEW PROFILE"] = "创建新的配置"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "水晶"
TSM.L["Current Profiles"] = "当前配置档"
TSM.L["CURRENT SEARCH"] = "当前搜索"
TSM.L["CUSTOM POST"] = "自定义发布"
TSM.L["Custom Price"] = "自定义价格"
TSM.L["Custom Price Source"] = "自定义价格来源"
TSM.L["Custom Sources"] = "自定义源"
TSM.L["Database Sources"] = "数据库源"
TSM.L["Default Craft Value Method:"] = "默认制造价函数："
TSM.L["Default Material Cost Method:"] = "默认材料价函数："
TSM.L["Default Price"] = "默认价格"
TSM.L["Default Price Configuration"] = "默认价格配置"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
TSM.L["Delete Profile Confirmation"] = "删除配置档确认"
TSM.L["Delete this record?"] = "删除此记录？"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
TSM.L["DEPOSIT REAGENTS"] = "存储虚空物品"
TSM.L["Deselect All Groups"] = "取消选择所有分组"
TSM.L["Deselect All Items"] = "取消所有物品"
TSM.L["Destroy Next"] = "分解下一个"
TSM.L["Destroy Value"] = "分解价值"
TSM.L["Destroy Value Source"] = "分解价来源"
TSM.L["Destroying"] = "分解"
TSM.L["Destroying 'DESTROY NEXT' Button"] = "分解\"分解下一个\"按钮"
TSM.L["Destroying Tooltips"] = "分解鼠标提示"
TSM.L["Destroying..."] = "分解中"
TSM.L["Details"] = "细节"
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "未取消%s，因为取消重新发布门槛(%s)无效。 检查您的设置."
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "未取消%s，因为最高价(%s)无效。 检查您的设置。"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "未取消%s，因为最低价(%s)无效。 检查您的设置。"
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "未取消%s，因为正常价(%s)无效。 检查您的设置。"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "未取消%s因为你的底价 (%s) 无效。请检查你的设置。"
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "未发布%s，因为暴雪未提供必要的信息,请重试"
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "未发布%s，因为最低拍卖的拥有者(%s)同时出现在黑名单和白名单上，这是不允许的。 调整您的设置以更正此问题。"
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "未发布%s，不允许您或您的角色(%s)在黑名单。 请从黑名单中删除。"
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "未发布%s,因为最高价(%s) 无效,请检查您的设置."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "未发布%s,因为正常价(%s) 无效,请检查您的设置."
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "未发布%s,因为正常价(%s) 低于最低价(%s),请检查您的设置."
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "未发布%s因为你的压价(%s) 无效。请检查你的设置。"
TSM.L["Disable invalid price warnings"] = "禁用无效价格提醒"
TSM.L["Disenchant Search"] = "分解搜索"
TSM.L["DISENCHANT SEARCH"] = "分解搜索"
TSM.L["Disenchant Search Options"] = "分解搜索选项"
TSM.L["Disenchant Value"] = "分解值"
TSM.L["Disenchanting Options"] = "分解选项"
TSM.L["Display auctioning values"] = "显示拍卖价值"
TSM.L["Display cancelled since last sale"] = "显示被取消的"
TSM.L["Display crafting cost"] = "显示制造成本"
TSM.L["Display detailed destroy info"] = "显示详细的分解信息"
TSM.L["Display disenchant value"] = "显示分解价值"
TSM.L["Display expired auctions"] = "显示过期的拍卖"
TSM.L["Display group name"] = "显示分组名称"
TSM.L["Display historical price"] = "显示历史价"
TSM.L["Display market value"] = "显示市场价"
TSM.L["Display mill value"] = "显示研磨价"
TSM.L["Display min buyout"] = "显示最低一口价"
TSM.L["Display Operation Names"] = "显示操作名称"
TSM.L["Display prospect value"] = "显示预期价格"
TSM.L["Display purchase info"] = "显示购买信息"
TSM.L["Display region historical price"] = "显示区域历史价格"
TSM.L["Display region market value avg"] = "显示区域市场平均价格"
TSM.L["Display region min buyout avg"] = "显示区域最低平均一口价"
TSM.L["Display region sale avg"] = "显示区域出售平均"
TSM.L["Display region sale rate"] = "显示区域出售比例"
TSM.L["Display region sold per day"] = "显示区域每天出售"
TSM.L["Display sale info"] = "显示出售信息"
TSM.L["Display sale rate"] = "显示出售比例"
TSM.L["Display shopping max price"] = "显示购买最高价"
TSM.L["Display total money recieved in chat?"] = "曲线图显示收到的所有金币"
TSM.L["Display transform value"] = "显示转化价值"
TSM.L["Display vendor buy price"] = "显示NPC购买价"
TSM.L["Display vendor sell price"] = "显示NPC出售价"
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "此操作还会删除附加到该组的所有子组"
TSM.L["Done Canceling"] = "取消完成"
TSM.L["Done Posting"] = "发布完成"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
TSM.L["Done Scanning"] = "扫描完成"
TSM.L["Don't post after this many expires:"] = "在过期这个数量后不要发布："
TSM.L["Don't Post Items"] = "不发布物品"
TSM.L["Don't prompt to record trades"] = "请勿立即记录交易"
TSM.L["DOWN"] = "向下"
TSM.L["Drag in Additional Items (%d/%d Items)"] = "拖拽添加物品(%d/%d 物品)"
TSM.L["Drag Item(s) Into Box"] = "把要准备发送的物品拖到此框内"
TSM.L["Duplicate"] = "重复"
TSM.L["Duplicate Profile Confirmation"] = "重复的配置文件确认"
TSM.L["Dust"] = "尘"
TSM.L["Elevate your gold-making!"] = "提升你的gold-making!"
TSM.L["Embed TSM tooltips"] = "嵌入TSM鼠标提示"
TSM.L["EMPTY BAGS"] = "清空背包"
TSM.L["Empty parentheses are not allowed"] = "不允许清空括号"
TSM.L["Empty price string."] = "清空价格字符串。"
TSM.L["Enable automatic stack combination"] = "启用自动堆叠整理"
TSM.L["Enable buying?"] = "启用购买?"
TSM.L["Enable inbox chat messages"] = "开启对话框收件信息"
TSM.L["Enable restock?"] = "启用补货?"
TSM.L["Enable selling?"] = "启用出售?"
TSM.L["Enable sending chat messages"] = "开启对话框发件信息"
TSM.L["Enable TSM Tooltips"] = "启用TSM工具提示"
TSM.L["Enable tweet enhancement"] = "启用Tweet增强"
TSM.L["Enchant Vellum"] = "附魔羊皮纸"
TSM.L["Ensure both characters are online and try again."] = "确保两个人物都在线，然后重试。"
TSM.L["Enter a name for the new profile"] = "输入新配置文件的名称"
TSM.L["Enter Filter"] = "输入过滤名"
TSM.L["Enter Keyword"] = "输入关键字"
TSM.L["Enter name of logged-in character from other account"] = "输入已经登录的角色名"
TSM.L["Enter player name"] = "输入玩家姓名"
TSM.L["Essences"] = "精华"
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "正在建立到 %s 的连接。确定你登陆过这个角色。"
TSM.L["Estimated Cost:"] = "预计成本:"
TSM.L["Estimated deliver time"] = "预计交货时间"
TSM.L["Estimated Profit:"] = "预计利润："
TSM.L["Exact Match Only?"] = "完全匹配?"
TSM.L["Exclude crafts with cooldowns"] = "忽略CD中的制造"
TSM.L["Expand All Groups"] = "展开所有群组"
TSM.L["Expenses"] = "支出"
TSM.L["EXPENSES"] = "支出"
TSM.L["Expirations"] = "过期"
TSM.L["Expired"] = "到期的"
TSM.L["Expired Auctions"] = "过期的拍卖"
TSM.L["Expired Since Last Sale"] = "上次出售到期的"
TSM.L["Expires"] = "到期"
TSM.L["EXPIRES"] = "到期"
TSM.L["Expires Since Last Sale"] = "自上次销售起过期"
TSM.L["Expiring Mails"] = "过期邮件"
TSM.L["Exploration"] = "探测"
TSM.L["Export"] = "导出"
TSM.L["Export List"] = "导出列表"
TSM.L["Failed Auctions"] = "拍卖失败"
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "上次出售失败的(到期/取消)"
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "无法为%s的%s（x%s）竞标出价。"
TSM.L["Failed to bid on auction of %s."] = "竞标%s失败"
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
TSM.L["Failed to buy auction of %s."] = "购买%s失败"
TSM.L["Failed to find auction for %s, so removing it from the results."] = "查找%s失败,已经从结果移除"
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
TSM.L["Failed to send profile."] = "无法发送个人资料。"
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "无法发送个人资料。确保两个人物都在线，然后重试。"
TSM.L["Favorite Scans"] = "收藏的扫描"
TSM.L["Favorite Searches"] = "收藏的搜索"
TSM.L["Filter Auctions by Duration"] = "按持续时间过滤拍卖"
TSM.L["Filter Auctions by Keyword"] = "按关键字过滤拍卖"
TSM.L["Filter by Keyword"] = "按关键字过滤"
TSM.L["FILTER BY KEYWORD"] = "按关键字过滤."
TSM.L["Filter group item lists based on the following price source"] = "根据以下价格源过滤分组物品"
TSM.L["Filter Items"] = "过滤物品"
TSM.L["Filter Shopping"] = "过滤shopping"
TSM.L["Finding Selected Auction"] = "查找选定的拍卖"
TSM.L["Fishing Reel In"] = "钓鱼卷轴"
TSM.L["Forget Character"] = "遗忘角色"
TSM.L["Found auction sound"] = "找到拍卖音效"
TSM.L["Friends"] = "好友"
TSM.L["From"] = "从"
TSM.L["Full"] = "满了"
TSM.L["Garrison"] = "要塞"
TSM.L["Gathering"] = "收集"
TSM.L["Gathering Search"] = "采集搜索"
TSM.L["General Options"] = "常规选项"
TSM.L["Get from Bank"] = "从银行获得"
TSM.L["Get from Guild Bank"] = "从公会银行获得"
TSM.L["Global Operation Confirmation"] = "全局操作确认"
TSM.L["Gold"] = "金"
TSM.L["Gold Earned:"] = "赚取金币："
TSM.L["GOLD ON HAND"] = "背包中的金币"
TSM.L["Gold Spent:"] = "花费的金币："
TSM.L["GREAT DEALS SEARCH"] = "搜索有利润的物品"
TSM.L["Group already exists."] = "已存在的组"
TSM.L["Group Management"] = "分组管理"
TSM.L["Group Operations"] = "分组操作"
TSM.L["Group Settings"] = "分组设置"
TSM.L["Grouped Items"] = "已分组的物品"
TSM.L["Groups"] = "分组"
TSM.L["Guild"] = "公会"
TSM.L["Guild Bank"] = "公会银行"
TSM.L["GVault"] = "公会银行"
TSM.L["Have"] = "拥有"
TSM.L["Have Materials"] = "拥有的材料"
TSM.L["Have Skill Up"] = "技能提升"
TSM.L["Hide auctions with bids"] = "隐藏已竞标的"
TSM.L["Hide Description"] = "隐藏描述"
TSM.L["Hide minimap icon"] = "隐藏小地图图标"
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "隐藏TSM银行界面,输入/tsm bankui 可重新打开"
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "隐藏TSM 任务列表UI,输入/tsm tasklist 可重新打开"
TSM.L["High Bidder"] = "高出价者"
TSM.L["Historical Price"] = "历史价格"
TSM.L["Hold ALT to repair from the guild bank."] = "按住 ALT 键进行公会修理"
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
TSM.L["Hr"] = "小时"
TSM.L["Hrs"] = "小时"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "我只卖了%s的[%s]！%s #TSM4 #warcraft"
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "如果您不想压价一个玩家，可以将它添加到白名单中，TSM将不会压价它。 请注意，如果您的白名单中的某人与您的买断匹配但列出较低的出价，TSM仍会对它们进行压价。"
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "如果您有多个配置文件建立了'操作'， 授权这个会导致除当前配置文件以外的所有的'操作'永久丢失，您确定要继续吗？"
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "如果您拥有WoW的Twitter集成设置，TSM将为其增强的拍卖销售/购买消息添加共享链接，以及用TSM链接替换URL。"
TSM.L["Ignore Auctions Below Min"] = "忽略最低价以下的拍卖"
TSM.L["Ignore auctions by duration?"] = "按持续时间忽略拍卖？"
TSM.L["Ignore Characters"] = "忽略角色"
TSM.L["Ignore Guilds"] = "忽略公会"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
TSM.L["Ignore operation on characters:"] = "忽略对角色的操作:"
TSM.L["Ignore operation on faction-realms:"] = "在阵营-服务器忽略操作："
TSM.L["Ignored Cooldowns"] = "忽略冷却"
TSM.L["Ignored Items"] = "忽略物品"
TSM.L["ilvl"] = "物品等级"
TSM.L["Import"] = "导入"
TSM.L["IMPORT"] = "导入"
TSM.L["Import %d Items and %s Operations?"] = "导入%d物品和%s操作?"
TSM.L["Import Groups & Operations"] = "导入分组&操作"
TSM.L["Imported Items"] = "已导入物品"
TSM.L["Inbox Settings"] = "收件设置"
TSM.L["Include Attached Operations"] = "包括附件操作"
TSM.L["Include operations?"] = "包括操作?"
TSM.L["Include soulbound items"] = "包括灵魂绑定物品"
TSM.L["Information"] = "信息"
TSM.L["Invalid custom price entered."] = "输入的自定义价格无效"
TSM.L["Invalid custom price source for %s. %s"] = "无效的自定义价格源%s. %s"
TSM.L["Invalid custom price."] = "无效的自定义价格。"
TSM.L["Invalid function."] = "无效功能。"
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
TSM.L["Invalid group name."] = "无效分组名"
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "无效的物品链接。"
TSM.L["Invalid operation name."] = "无效操作名"
TSM.L["Invalid operator at end of custom price."] = "无效的操作者自定义价格。"
TSM.L["Invalid parameter to price source."] = "无效的价格来源参数。"
TSM.L["Invalid player name."] = "无效玩家名"
TSM.L["Invalid price source in convert."] = "转换价格来源无效。"
TSM.L["Invalid price source."] = "无效价格来源"
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
TSM.L["Invalid seller data returned by server."] = "服务器返回无效的出售数据"
TSM.L["Invalid word: '%s'"] = "无效的单词：'%s'"
TSM.L["Inventory"] = "仓库"
TSM.L["Inventory / Gold Graph"] = "商品清单/金币图表"
TSM.L["Inventory / Mailing"] = "库存/邮寄"
TSM.L["Inventory Options"] = "库存设置"
TSM.L["Inventory Tooltip Format"] = "库存工具提示格式"
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "你似乎在账号间手动复制了SavedVariables，导致TSM的自动同步无法工作。你需要撤销此更改，并且/或者关闭魔兽世界后删除这些账号的TSM SavedVariables来修复此问题。"
TSM.L["Item"] = "物品"
TSM.L["ITEM CLASS"] = "物品种类"
TSM.L["Item Level"] = "物品等级"
TSM.L["ITEM LEVEL RANGE"] = "物品等级区间"
TSM.L["Item links may only be used as parameters to price sources."] = "物品链接仅可用来参考价格来源。"
TSM.L["Item Name"] = "物品名称"
TSM.L["Item Quality"] = "物品品质"
TSM.L["ITEM SEARCH"] = "物品搜索"
TSM.L["ITEM SELECTION"] = "项目选择"
TSM.L["ITEM SUBCLASS"] = "物品子类"
TSM.L["Item Value"] = "物品价格"
TSM.L["Item/Group is invalid (see chat)."] = "物品/分组无效(查看聊天框)"
TSM.L["ITEMS"] = "物品"
TSM.L["Items"] = "物品"
TSM.L["Items in Bags"] = "背包中的物品"
TSM.L["Keep in bags quantity:"] = "保持背包数量"
TSM.L["Keep in bank quantity:"] = "保持银行数量:"
TSM.L["Keep posted:"] = "保持已发布的:"
TSM.L["Keep quantity:"] = "保持数量:"
TSM.L["Keep this amount in bags:"] = "将此数量保存在背包"
TSM.L["Keep this amount:"] = "持有数量"
TSM.L["Keeping %d."] = "持有%d."
TSM.L["Keeping undercut auctions posted."] = "保留被压数量"
TSM.L["Last 14 Days"] = "14日内"
TSM.L["Last 3 Days"] = "3日内"
TSM.L["Last 30 Days"] = "30日内"
TSM.L["LAST 30 DAYS"] = "30日内"
TSM.L["Last 60 Days"] = "60日内"
TSM.L["Last 7 Days"] = "7日内"
TSM.L["LAST 7 DAYS"] = "7日内"
TSM.L["Last Data Update:"] = "上次数据更新："
TSM.L["Last Purchased"] = "上次购买"
TSM.L["Last Sold"] = "上次售出"
TSM.L["Level Up"] = "等级上升"
TSM.L["LIMIT"] = "限制"
TSM.L["Link to Another Operation"] = "关联到另一个操作"
TSM.L["List"] = "列表"
TSM.L["List materials in tooltip"] = "鼠标提示显示材料"
TSM.L["Loading Mails..."] = "正在读取邮件……"
TSM.L["Loading..."] = "读取中……"
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "TradeSkillMaster似乎发生了一个错误。请按以下所示说明来帮助作者修正这个错误。"
TSM.L["Loop detected in the following custom price:"] = "以下自定义价格循环检测："
TSM.L["Lowest auction by whitelisted player."] = "最低价的拍卖为白名单玩家"
TSM.L["Macro created and scroll wheel bound!"] = "已建立宏并且绑定鼠标滚轮！"
TSM.L["Macro Setup"] = "宏设置"
TSM.L["Mail"] = "邮件"
TSM.L["Mail Disenchantables"] = "邮寄可分解物品"
TSM.L["Mail Disenchantables Max Quality"] = "邮寄最大数量可分解物品"
TSM.L["MAIL SELECTED GROUPS"] = "邮递所选分组"
TSM.L["Mail to %s"] = "邮寄给%s"
TSM.L["Mailing"] = "邮寄"
TSM.L["Mailing all to %s."] = "全部邮寄至 %s"
TSM.L["Mailing Options"] = "邮递选项"
TSM.L["Mailing up to %d to %s."] = "邮寄%d给%s"
TSM.L["Main Settings"] = "主设置"
TSM.L["Make Cash On Delivery?"] = "货到对方付款"
TSM.L["Management Options"] = "管理选项"
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "TSM中的许多常用操作可以添加到宏并绑定到滚轮。 使用下面的选项设置宏和滚轮绑定。"
TSM.L["Map Ping"] = "地图Ping"
TSM.L["Market Value"] = "市场价格"
TSM.L["Market Value Price Source"] = "市场价来源"
TSM.L["Market Value Source"] = "市场价格来源"
TSM.L["Mat Cost"] = "原料花费"
TSM.L["Mat Price"] = "原料价格"
TSM.L["Match stack size?"] = "匹配堆叠数?"
TSM.L["Match whitelisted players"] = "匹配白名单玩家"
TSM.L["Material Name"] = "材料名称"
TSM.L["Materials"] = "材料"
TSM.L["Materials to Gather"] = "要收集的材料"
TSM.L["MAX"] = "最大"
TSM.L["Max Buy Price"] = "最高买入价"
TSM.L["MAX EXPIRES TO BANK"] = "银行最大到期日"
TSM.L["Max Sell Price"] = "最高卖价"
TSM.L["Max Shopping Price"] = "最高购买价"
TSM.L["Maximum amount already posted."] = "已发布最大数量"
TSM.L["Maximum Auction Price (Per Item)"] = "最高发布价(每件价格,不是每组)"
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "最高分解价值(输入 0c 禁用)"
TSM.L["Maximum disenchant level:"] = "最高分解等级:"
TSM.L["Maximum Disenchant Quality"] = "最高分解品质"
TSM.L["Maximum disenchant search percentage:"] = "最高分解比例"
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "最高市场价(输入 0c 禁用)"
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "最大购买数量"
TSM.L["Maximum quantity:"] = "最大数量"
TSM.L["Maximum restock quantity:"] = "最大补货数量"
TSM.L["Mill Value"] = "邮递价格"
TSM.L["Min"] = "最小"
TSM.L["Min Buy Price"] = "最低买入价"
TSM.L["Min Buyout"] = "最低一口价"
TSM.L["Min Sell Price"] = "最低卖价"
TSM.L["Min/Normal/Max Prices"] = "最低/正常/最高 价格"
TSM.L["Minimum Days Old"] = "最小天数"
TSM.L["Minimum disenchant level:"] = "最低分解等级:"
TSM.L["Minimum expires:"] = "最低到期"
TSM.L["Minimum profit:"] = "最低利润"
TSM.L["MINIMUM RARITY"] = "最低品质"
TSM.L["Minimum restock quantity:"] = "最小补货数量"
TSM.L["Misplaced comma"] = "错误的分隔逗号"
TSM.L["Missing Materials"] = "缺少的材料"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
TSM.L["Modifiers:"] = "编辑器："
TSM.L["Money Frame Open"] = "金钱框架打开"
TSM.L["Money Transfer"] = "金币交易量"
TSM.L["Most Profitable Item:"] = "有利润的物品"
TSM.L["MOVE"] = "移动"
TSM.L["Move already grouped items?"] = "移动在分组中的物品?"
TSM.L["Move Quantity Settings"] = "移动数量设置"
TSM.L["MOVE TO BAGS"] = "移到背包"
TSM.L["MOVE TO BANK"] = "移到银行"
TSM.L["MOVING"] = "移动中"
TSM.L["Moving"] = "移动中"
TSM.L["Multiple Items"] = "多个物品"
TSM.L["My Auctions"] = "我的拍卖"
TSM.L["My Auctions 'CANCEL' Button"] = "我的拍卖\"取消\"按钮"
TSM.L["Neat Stacks only?"] = "只移动整组"
TSM.L["NEED MATS"] = "需要材料"
TSM.L["New Group"] = "新的分组"
TSM.L["New Operation"] = "新操作"
TSM.L["NEWS AND INFORMATION"] = "新闻和信息"
TSM.L["No Attachments"] = "没有附件"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
TSM.L["No Data"] = "没有数据"
TSM.L["No group selected"] = "未选择分组"
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "未物品指定。 用法：/tsm restock help [物品链接]"
TSM.L["NO ITEMS"] = "没有物品"
TSM.L["No Materials to Gather"] = "没有材料来采集"
TSM.L["No Operation Selected"] = "未选择操作"
TSM.L["No posting."] = "未发布"
TSM.L["No Profession Opened"] = "未打开专业"
TSM.L["No Profession Selected"] = "未选择专业"
TSM.L["No profile specified. Possible profiles: '%s'"] = "无指定配置。可能配置：'%s'"
TSM.L["No recent AuctionDB scan data found."] = "未找到AuctionDB扫描数据。"
TSM.L["No Sound"] = "无声"
TSM.L["None"] = "无"
TSM.L["None (Always Show)"] = "无（总是显示）"
TSM.L["None Selected"] = "未选择"
TSM.L["NONGROUP TO BANK"] = "未分组到银行"
TSM.L["Normal"] = "常规"
TSM.L["Not canceling auction at reset price."] = "不取消位于转卖价格的拍卖"
TSM.L["Not canceling auction below min price."] = "低于最低价格时不取消拍卖"
TSM.L["Not canceling."] = "未取消"
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
TSM.L["Not enough items in bags."] = "背包物品不足"
TSM.L["NOT OPEN"] = "未打开"
TSM.L["Not Scanned"] = "未扫描的"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
TSM.L["NPC"] = "NPC"
TSM.L["Number Owned"] = "拥有的数量"
TSM.L["of"] = "的"
TSM.L["Offline"] = "离线"
TSM.L["On Cooldown"] = "冷却中"
TSM.L["Only show craftable"] = "只显示可制作的"
TSM.L["Only show items with disenchant value above custom price"] = "只显示具有高于自定义价格的分解价值的商品"
TSM.L["OPEN"] = "打开"
TSM.L["OPEN ALL MAIL"] = "打开所有邮件"
TSM.L["Open Mail"] = "打开邮件"
TSM.L["Open Mail Complete Sound"] = "打开邮箱声音"
TSM.L["Open Task List"] = "打开任务列表"
TSM.L["Operation"] = "操作"
TSM.L["Operations"] = "操作"
TSM.L["Other Character"] = "其他角色"
TSM.L["Other Settings"] = "其他设置"
TSM.L["Other Shopping Searches"] = "其他Shopping 搜索"
TSM.L["Override default craft value method?"] = "覆盖默认制造价值参数"
TSM.L["Override parent operations"] = "覆盖父操作"
TSM.L["Parent Items"] = "父项目"
TSM.L["Past 7 Days"] = "过去七天"
TSM.L["Past Day"] = "昨天的"
TSM.L["Past Month"] = "过去一个月的"
TSM.L["Past Year"] = "过去一年的"
TSM.L["Paste string here"] = "在此粘贴字符串"
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "将导入字符串粘贴到下面的字段中，然后点“导入”。 您可以导入任务物品到所有分组&操作结构到整个组和操作结构的所有内容（请逗号分隔）。"
TSM.L["Per Item"] = "每个物品"
TSM.L["Per Stack"] = "每组"
TSM.L["Per Unit"] = "每个"
TSM.L["Player Gold"] = "玩家金币"
TSM.L["Player Invite Accept"] = "接受玩家邀请"
TSM.L["Please select a group to export"] = "请选择一个分组来导出"
TSM.L["POST"] = "发布"
TSM.L["Post at Maximum Price"] = "以最高价发布"
TSM.L["Post at Minimum Price"] = "以最低价发布"
TSM.L["Post at Normal Price"] = "以正常价格发布"
TSM.L["POST CAP TO BAGS"] = "发布上限到背包"
TSM.L["Post Scan"] = "发布扫描"
TSM.L["POST SELECTED"] = "发布选择的"
TSM.L["POSTAGE"] = "邮费"
TSM.L["Postage"] = "邮费"
TSM.L["Posted at whitelisted player's price."] = "以白名单玩家价格发布"
TSM.L["Posted Auctions %s:"] = "发布的拍卖%s:"
TSM.L["Posting"] = "发布中"
TSM.L["Posting %d / %d"] = "发布中 %d / %d"
TSM.L["Posting %d stack(s) of %d for %d hours."] = "发布%d个堆叠的%d，持续时间为%d小时"
TSM.L["Posting at normal price."] = "以正常价发布"
TSM.L["Posting at whitelisted player's price."] = "正在以白名单玩家价格发布"
TSM.L["Posting at your current price."] = "正在以当前价格发布"
TSM.L["Posting disabled."] = "发布禁用"
TSM.L["Posting Settings"] = "发布设置"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
TSM.L["Potential"] = "潜在"
TSM.L["Price Per Item"] = "单价"
TSM.L["Price Settings"] = "价格设置"
TSM.L["PRICE SOURCE"] = "价格来源"
TSM.L["Price source with name '%s' already exists."] = "价格来源名称 '%s' 已经存在"
TSM.L["Price Variables"] = "价格变量"
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "价格变量允许您创建更高级的自定义价格，以便在整个插件中使用。 您将能够以与使用内置价格来源相同的方式使用这些新变量，例如'vendorsell'和'vendorbuy'"
TSM.L["PROFESSION"] = "专业"
TSM.L["Profession Filters"] = "专业过滤"
TSM.L["Profession Info"] = "专业信息"
TSM.L["Profession loading..."] = "专业加载中..."
TSM.L["Professions Used In"] = "涉及专业"
TSM.L["Profile changed to '%s'."] = "变更成'%s'配置。"
TSM.L["Profiles"] = "配置档"
TSM.L["PROFIT"] = "利润"
TSM.L["Profit"] = "利润"
TSM.L["Prospect Value"] = "预期价格"
TSM.L["PURCHASE DATA"] = "购买数据"
TSM.L["Purchased (Min/Avg/Max Price)"] = "购买（最小/平均/最高价)"
TSM.L["Purchased (Total Price)"] = "购买(总价)"
TSM.L["Purchases"] = "购买数量"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
TSM.L["Qty"] = "数量"
TSM.L["Quantity Bought:"] = "买入数量"
TSM.L["Quantity Sold:"] = "售出数量"
TSM.L["Quantity to move:"] = "移动数量"
TSM.L["Quest Added"] = "任务已添加"
TSM.L["Quest Completed"] = "任务已完成"
TSM.L["Quest Objectives Complete"] = "任务目标完成"
TSM.L["QUEUE"] = "队列"
TSM.L["Quick Sell Options"] = "快速出售选项"
TSM.L["Quickly mail all excess disenchantable items to a character"] = "快速将所有多余的可分解物品邮寄给角色"
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "快速将所有多余的金币（限制在一定数量）邮寄给角色"
TSM.L["Raid Warning"] = "副本警告"
TSM.L["Read More"] = "Read More"
TSM.L["Ready Check"] = "准备好检查"
TSM.L["Ready to Cancel"] = "准备取消"
TSM.L["Realm Data Tooltips"] = "鼠标提示阵营数据"
TSM.L["Recent Scans"] = "最近的扫描"
TSM.L["Recent Searches"] = "最近的搜索"
TSM.L["Recently Mailed"] = "最近的邮递"
TSM.L["RECIPIENT"] = "接受者"
TSM.L["Region Avg Daily Sold"] = "服务器平均每日出售"
TSM.L["Region Data Tooltips"] = "鼠标提示服务器数据"
TSM.L["Region Historical Price"] = "服务器历史价格"
TSM.L["Region Market Value Avg"] = "服务器市场平均价"
TSM.L["Region Min Buyout Avg"] = "区域最低平均一口价"
TSM.L["Region Sale Avg"] = "服务器平均出售"
TSM.L["Region Sale Rate"] = "服务器成交率"
TSM.L["Reload"] = "重载"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
TSM.L["Removed a total of %s old records."] = "总共删除了%s 旧记录"
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
TSM.L["REPAIR"] = "修复"
TSM.L["Repair Bill"] = "修复账单"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
TSM.L["REPLY"] = "回复"
TSM.L["REPORT SPAM"] = "举报垃圾信息"
TSM.L["Repost Higher Threshold"] = "重新以更高价发布"
TSM.L["Required Level"] = "请求的等级"
TSM.L["REQUIRED LEVEL RANGE"] = "要求的等级范围"
TSM.L["Requires TSM Desktop Application"] = "要求TSM 桌面App"
TSM.L["Resale"] = "转卖"
TSM.L["RESCAN"] = "重新扫描"
TSM.L["RESET"] = "重置"
TSM.L["Reset All"] = "重置所有"
TSM.L["Reset Filters"] = "重置过滤"
TSM.L["Reset Profile Confirmation"] = "重置配置确认"
TSM.L["RESTART"] = "重新开始"
TSM.L["Restart Delay (minutes)"] = "自动邮件重启延迟（分钟）"
TSM.L["RESTOCK BAGS"] = "补货背包"
TSM.L["Restock help for %s:"] = "补货帮助%s:"
TSM.L["Restock Quantity Settings"] = "补货数量设置"
TSM.L["Restock quantity:"] = "补货数量"
TSM.L["RESTOCK SELECTED GROUPS"] = "补货选择的分组"
TSM.L["Restock Settings"] = "补货设置"
TSM.L["Restock target to max quantity?"] = "对目标进行最大补货?"
TSM.L["Restocking to %d."] = "补货到%d"
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
TSM.L["RESTORE BAGS"] = "恢复背包"
TSM.L["Resume Scan"] = "恢复扫描"
TSM.L["Retrying %d auction(s) which failed."] = "重试失败的%d拍卖"
TSM.L["Revenue"] = "收益"
TSM.L["Round normal price"] = "正常价格附近"
TSM.L["RUN ADVANCED ITEM SEARCH"] = "运行高级物品搜索"
TSM.L["Run Bid Sniper"] = "运行狙击竞价"
TSM.L["Run Buyout Sniper"] = "运行狙击一口价"
TSM.L["RUN CANCEL SCAN"] = "取消扫描"
TSM.L["RUN POST SCAN"] = "发布扫描"
TSM.L["RUN SHOPPING SCAN"] = "购买扫描"
TSM.L["Running Sniper Scan"] = "运行狙击扫描"
TSM.L["Sale"] = "出售"
TSM.L["SALE DATA"] = "出售数据"
TSM.L["Sale Price"] = "销售价格"
TSM.L["Sale Rate"] = "成交率"
TSM.L["Sales"] = "出售"
TSM.L["SALES"] = "出售"
TSM.L["Sales Summary"] = "出售总览"
TSM.L["SCAN ALL"] = "取消所有"
TSM.L["Scan Complete Sound"] = "扫描完成声音"
TSM.L["Scan Paused"] = "扫描被暂停"
TSM.L["SCANNING"] = "正在扫描"
TSM.L["Scanning %d / %d (Page %d / %d)"] = "正在扫描第%d项/共%d项(第%d页/共%d页)"
TSM.L["Scroll wheel direction:"] = "滚轮方向"
TSM.L["Search"] = "搜索"
TSM.L["Search Bags"] = "搜索背包"
TSM.L["Search Groups"] = "搜索分组"
TSM.L["Search Inbox"] = "搜索收件箱"
TSM.L["Search Operations"] = "搜索操作"
TSM.L["Search Patterns"] = "搜索模式"
TSM.L["Search Usable Items Only?"] = "仅搜索可用物品"
TSM.L["Search Vendor"] = "搜索NPC"
TSM.L["Select a Source"] = "选择一个源"
TSM.L["Select Action"] = "选择操作"
TSM.L["Select All Groups"] = "选择所有分组"
TSM.L["Select All Items"] = "选择所有物品"
TSM.L["Select Auction to Cancel"] = "选择拍卖取消"
TSM.L["Select crafter"] = "选择制造者"
TSM.L["Select custom price sources to include in item tooltips"] = "选择要包含在提示中的自定义价格来源"
TSM.L["Select Duration"] = "选择持续时间"
TSM.L["Select Items to Add"] = "选择要添加的物品"
TSM.L["Select Items to Remove"] = "选择要移除的物品"
TSM.L["Select Operation"] = "选择操作"
TSM.L["Select professions"] = "选择专业"
TSM.L["Select which accounting information to display in item tooltips."] = "选择要显示物品提示的accounting信息"
TSM.L["Select which auctioning information to display in item tooltips."] = "选择要显示物品提示的拍卖信息"
TSM.L["Select which crafting information to display in item tooltips."] = "选择要显示物品提示的制造信息"
TSM.L["Select which destroying information to display in item tooltips."] = "选择要显示物品提示的分解信息"
TSM.L["Select which shopping information to display in item tooltips."] = "选择要显示物品提示的购买信息"
TSM.L["Selected Groups"] = "选择的分组"
TSM.L["Selected Operations"] = "选择的操作"
TSM.L["Sell"] = "出售"
TSM.L["SELL ALL"] = "出售所有"
TSM.L["SELL BOES"] = "出售BOE物品"
TSM.L["SELL GROUPS"] = "出售分组"
TSM.L["Sell Options"] = "出售选择"
TSM.L["Sell soulbound items?"] = "出售灵魂绑定的物品?"
TSM.L["Sell to Vendor"] = "卖给NPC"
TSM.L["SELL TRASH"] = "出售垃圾"
TSM.L["Seller"] = "出售者"
TSM.L["Selling soulbound items."] = "出售灵魂绑定物品"
TSM.L["Send"] = "发送"
TSM.L["SEND DISENCHANTABLES"] = "发送待拆解的装备"
TSM.L["Send Excess Gold to Banker"] = "发送超额金币给银行角色"
TSM.L["SEND GOLD"] = "发送金币"
TSM.L["Send grouped items individually"] = "单独发送分组物品"
TSM.L["SEND MAIL"] = "发送邮件"
TSM.L["Send Money"] = "发送金币"
TSM.L["Send Profile"] = "发送资料"
TSM.L["SENDING"] = "发送中"
TSM.L["Sending %s individually to %s"] = "将%s单独发送到%s"
TSM.L["Sending %s to %s"] = "发送%s到%s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
TSM.L["Sending Settings"] = "发送设置"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
TSM.L["SENDING..."] = "发送中..."
TSM.L["Set auction duration to:"] = "设置拍卖持续时间:"
TSM.L["Set bid as percentage of buyout:"] = "将出价设置为一口价的百分比"
TSM.L["Set keep in bags quantity?"] = "设置背包持有数量"
TSM.L["Set keep in bank quantity?"] = "设置银行持有数量"
TSM.L["Set Maximum Price:"] = "设置最高价:"
TSM.L["Set maximum quantity?"] = "设置最大数量"
TSM.L["Set Minimum Price:"] = "设置最低价:"
TSM.L["Set minimum profit?"] = "设置最低利润?"
TSM.L["Set move quantity?"] = "设置移动数量?"
TSM.L["Set Normal Price:"] = "设置正常价:"
TSM.L["Set post cap to:"] = "设置发布上限到:"
TSM.L["Set posted stack size to:"] = "设置发布堆叠数:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
TSM.L["Setup"] = "建立"
TSM.L["SETUP ACCOUNT SYNC"] = "设置账户同步"
TSM.L["Shards"] = "碎片"
TSM.L["Shopping"] = "购买"
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping \"一口价\" 按钮"
TSM.L["Shopping for auctions including those above the max price."] = "购买拍卖品(包括那些高于最高价格的)"
TSM.L["Shopping for auctions with a max price set."] = "购买拍卖品(在最高价格限定下)"
TSM.L["Shopping for even stacks including those above the max price"] = "购买整组,忽视最高价格选定"
TSM.L["Shopping for even stacks with a max price set."] = "购买整组,在最高价格限定下"
TSM.L["Shopping Tooltips"] = "购买提示"
TSM.L["SHORTFALL TO BAGS"] = "背包里的物品不够"
TSM.L["Show auctions above max price?"] = "显示高于最高价格的拍卖品"
TSM.L["Show confirmation alert if buyout is above the alert price"] = "如果一口价超过警惕价格，则显示确认提醒"
TSM.L["Show Description"] = "显示描述"
TSM.L["Show Destroying frame automatically"] = "自动显示分解窗口"
TSM.L["Show material cost"] = "显示材料成本"
TSM.L["Show on Modifier"] = "在调节器中显示"
TSM.L["Showing %d Mail"] = "显示 %d 邮件"
TSM.L["Showing %d of %d Mail"] = "显示 %d / %d 封邮件"
TSM.L["Showing %d of %d Mails"] = "显示 %d / %d 封邮件"
TSM.L["Showing all %d Mails"] = "显示所有 %d 邮件"
TSM.L["Simple"] = "简单"
TSM.L["SKIP"] = "跳过"
TSM.L["Skip Import confirmation?"] = "跳过导入确认？"
TSM.L["Skipped: No assigned operation"] = "已跳过:无指定操作"
TSM.L["Slash Commands:"] = "指令列表："
TSM.L["Sniper"] = "狙击"
TSM.L["Sniper 'BUYOUT' Button"] = "狙击\"一口价\"按钮"
TSM.L["Sniper Options"] = "狙击选项"
TSM.L["Sniper Settings"] = "狙击设置"
TSM.L["Sniping items below a max price"] = "狙击物品低于最高价"
TSM.L["Sold"] = "卖出"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
TSM.L["Sold %s worth of items."] = "售出%s物品"
TSM.L["Sold (Min/Avg/Max Price)"] = "出售(最小/平均/最高价)"
TSM.L["Sold (Total Price)"] = "售出(总价):"
TSM.L["Sold [%s]x%d for %s to %s"] = "卖出 [%s]x%d 为 %s 到 %s"
TSM.L["Sold Auctions %s:"] = "已售出拍卖%s:"
TSM.L["Source"] = "来源"
TSM.L["SOURCE %d"] = "来源%d"
TSM.L["SOURCES"] = "来源"
TSM.L["Sources"] = "来源"
TSM.L["Sources to include for restock:"] = "包括补货来源"
TSM.L["Stack"] = "堆叠"
TSM.L["Stack / Quantity"] = "堆叠/数量"
TSM.L["Stack size multiple:"] = "堆叠大小数量"
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "使用上面的按钮启动“一口价”或“竞标”狙击搜索"
TSM.L["Starting Scan..."] = "开始扫描..."
TSM.L["STOP"] = "停止"
TSM.L["Store operations globally"] = "全局保存操作"
TSM.L["Subject"] = "邮件主题"
TSM.L["SUBJECT"] = "主题"
TSM.L["Successfully sent your '%s' profile to %s!"] = "成功将您的“%s”个人资料发送到%s！"
TSM.L["Switch to %s"] = "切换到%s"
TSM.L["Switch to WoW UI"] = "切换到WOW界面"
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "同步设置错误：另一个账号中的指定角色不在线。"
TSM.L["Sync Setup Error: This character is already part of a known account."] = "同步设置错误：该角色已经在一个已知账号中。"
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "同步设置错误：您输入了当前角色名而非其他账号下的角色名。"
TSM.L["Sync Status"] = "同步状态"
TSM.L["TAKE ALL"] = "提取所有"
TSM.L["Take Attachments"] = "提取附件"
TSM.L["Target Character"] = "目标角色"
TSM.L["TARGET SHORTFALL TO BAGS"] = "补货到背包"
TSM.L["Tasks Added to Task List"] = "添加到任务列表"
TSM.L["Text (%s)"] = "文本 (%s)"
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "canlearn过滤被忽略，因为找不到CanIMogIt插件。"
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "这个物品的制造价值算法(%s)没有返回数值"
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "“分解”价格来源已经被通用“摧毁”价格来源重置。请更新自定义价格。"
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "最低利润（%s）未评估此物品的有效值"
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "该名称只能包含字母。不能有空格，数字或特殊字符。"
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "请求数量 (%d)小于最低重新补货数量 (%d)"
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "应用于此物品的操作无效！ %d最小补货高于%d的最大补货。"
TSM.L["The player \"%s\" is already on your whitelist."] = "玩家\"%s\"已经在白名单中"
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "此物品的利润 (%s)低于最低利润(%s)"
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "%s最低价卖家名未提交到服务器。忽略此物品"
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "unlearned过滤被忽略，因为找不到CanIMogIt插件"
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "这是一个非法的配置文件名。配置文件名必须至少有一个字符长度并且不包含@字符。"
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "此物品没有制造成本。 检查所有材料是否有材料价格"
TSM.L["This item is not in a TSM group."] = "此物品不在TSM分组"
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
TSM.L["This looks like an exported operation and not a custom price."] = "这看起来想一个导出操作而不是一个自定义价格。"
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "将'%s'中的设置复制到当前活动的设置中。"
TSM.L["This will permanently delete the '%s' profile."] = "此操作将永久删除'%s'配置档"
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "此操作将重置所有分组和操作（如果未全局保存）。"
TSM.L["Time"] = "时间"
TSM.L["Time Format"] = "时间格式"
TSM.L["Time Frame"] = "时限"
TSM.L["TIME FRAME"] = "时限"
TSM.L["TINKER"] = "修理"
TSM.L["Tooltip Price Format"] = "鼠标提示价格格式"
TSM.L["Tooltip Settings"] = "鼠标提示设置"
TSM.L["Top Buyers:"] = "TOP 买家:"
TSM.L["Top Item:"] = "TOP 物品:"
TSM.L["Top Sellers:"] = "TOP 卖家:"
TSM.L["Total"] = "总计"
TSM.L["Total Gold"] = "总金币"
TSM.L["Total Gold Collected: %s"] = "收集的金币总数: %s"
TSM.L["Total Gold Earned:"] = "获得的总金额"
TSM.L["Total Gold Spent:"] = "花费总金币"
TSM.L["Total Price"] = "总价格"
TSM.L["Total Profit:"] = "总利润："
TSM.L["Total Value"] = "总价值"
TSM.L["Total Value of All Items"] = "所有物品的总价值"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
TSM.L["Transform Value"] = "转化价格"
TSM.L["TSM Banking"] = "TSM 银行"
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM能在多个账号之间自动同步数据。此外，您还可以将当前有效的档案发送到已关联的帐户，以便快速将您的群组和配置发送到其他帐户。"
TSM.L["TSM Crafting"] = "TSM 制造"
TSM.L["TSM Destroying"] = "TSM 分解"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM未能扫描拍卖。 请重新运行扫描。"
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM缺少TSM桌面应用程序的重要信息。 请确保TSM桌面应用程序正在运行且配置正确。"
TSM.L["TSM Mailing"] = "TSM Mailing"
TSM.L["TSM TASK LIST"] = "TSM 任务列表"
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "TSM版本信息："
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting检测到您刚刚交易%s%s以赚取%s。 您希望Accounting模块存储此交易的记录吗？"
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
TSM.L["TUJ 3-Day Price"] = "TUJ中近3日价格"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
TSM.L["Twitter Integration"] = "整合推特"
TSM.L["Twitter Integration Not Enabled"] = "Twitter整合未启用"
TSM.L["Type"] = "类型"
TSM.L["Type Something"] = "输入一些东西"
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "由于目标组（%s）不再存在，因此无法处理导入。请再试一次。"
TSM.L["Unbalanced parentheses."] = "残缺的括号。"
TSM.L["Undercut amount:"] = "压价金额:"
TSM.L["Undercut by whitelisted player."] = "被白名单玩家压价"
TSM.L["Undercutting blacklisted player."] = "压价黑名单"
TSM.L["Undercutting competition."] = "压价发布"
TSM.L["Ungrouped Items"] = "未分组的物品"
TSM.L["Unknown Item"] = "未知物品"
TSM.L["Unwrap Gift"] = "打开礼物包裹"
TSM.L["Up"] = "向上"
TSM.L["Up to date"] = "最新"
TSM.L["UPDATE EXISTING MACRO"] = "更新已有的宏"
TSM.L["Updating"] = "更新中"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "用法：/tsm price <物品链接> <价格字符串>"
TSM.L["Use smart average for purchase price"] = "使用智能均价作为购买价"
TSM.L["Use the field below to search the auction house by filter"] = "使用下面的字段按过滤搜索拍卖行"
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "使用左侧的列表选择要为其创建导出字符串的分组和操作。"
TSM.L["VALUE PRICE SOURCE"] = "价格来源"
TSM.L["ValueSources"] = "价格来源"
TSM.L["Variable Name"] = "变量名"
TSM.L["Vendor"] = "NPC"
TSM.L["Vendor Buy Price"] = "NPC购买价"
TSM.L["Vendor Search"] = "卖店价搜索"
TSM.L["VENDOR SEARCH"] = "卖店价搜索"
TSM.L["Vendor Sell"] = "出售NPC"
TSM.L["Vendor Sell Price"] = "NPC出售价"
TSM.L["Vendoring 'SELL ALL' Button"] = "NPC \"出售所有\" 按钮"
TSM.L["View ignored items in the Destroying options."] = "在分解选项中查看忽略的物品"
TSM.L["Warehousing"] = "Warehousing"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件. 补货会保留%d件物品在你的背包里"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从背包→银行/公会银行时每种物品保留%d件. 补货会保留%d件物品在你的背包里"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从银行/公会银行→背包时每种物品保留%d件"
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件, 当从银行/公会银行→背包时每种物品保留%d件。补货会保留%d件物品在背包里"
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing会移动这个分组中每种物品最多%d件"
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组中每种物品最多%d件。补货会保留%d件物品在背包里"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件, 当从银行/公会银行→背包时每种物品保留%d件。补货会在背包里保留%d件物品"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d件"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing会移动这个分组的所有物品, 当从背包→银行/公会银行时每种物品保留%d。补货会在背包里保留%d件物品"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing会移动这个分组的所有物品, 当从银行/公会银行→背包时每种物品保留%d件"
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "当银行/工会银行>背包物品时仓库将移动该组中的所有物品，每个物品的%d保持不变。补货将在你的背包中保留%d。"
TSM.L["Warehousing will move all of the items in this group."] = "移动所有Warehousing物品到该分组"
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing将移动该组中的所有项目。补货将在你的背包中保留%d物品。"
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "警告：宏过长，将被调整到适合的长度。"
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "警告：你的  %s 的最低价格比卖给商人的价格更低（包含AH的手续费）。考虑提高你的最低价，或者直接卖店。"
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "欢迎使用TSM4！现在，所有旧的TSM3模块（例如Crafting，Shopping等）都内置在主要TSM插件中，因此您只需要安装TSM和TSM_AppHelper。TSM禁用了旧模块，需要重新加载。"
TSM.L["When above maximum:"] = "当超过最大值："
TSM.L["When below minimum:"] = "当小于最小值："
TSM.L["Whitelist"] = "白名单"
TSM.L["Whitelisted Players"] = "白名单玩家"
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "已经拥有此物品的的最多补货量。 已经有%d，最多补货量是%d"
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "您可以使用以下选项清除旧数据。 建议偶尔清除旧数据，以遍accounting模块顺利运行。 选择要删除的最小天数，然后单击“%s”。"
TSM.L["You cannot use %s as part of this custom price."] = "您不能使用 %s 作为自定义价格。"
TSM.L["You cannot use %s within convert() as part of this custom price."] = "你不能使用不超过 转化价的%s作为自定义价格。"
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "无需添加“%s”，小号会自动列入白名单。"
TSM.L["You don't know how to craft this item."] = "不知道如何制作此物品"
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "你需要重载UI来使这些改动生效。是否现在重载？"
TSM.L["You won an auction for %sx%d for %s"] = "你成功购买%sx%d从%s"
TSM.L["Your auction has not been undercut."] = "未被压价"
TSM.L["Your auction of %s expired"] = "您的%s拍卖已过期"
TSM.L["Your auction of %s has sold for %s!"] = "你的%s拍卖以%s的价格卖出！"
TSM.L["Your Buyout"] = "你的一口价"
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "'%s'制造方法无效，因此已返回默认值。 细节：%s"
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "你的默认制造价值方法是无效的，所以已经回到初始状态。详细: %s"
TSM.L["Your task list is currently empty."] = "你的任务列表现在是空的。"
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "由于暴雪结束时的错误导致AH停止工作，因此您已经分阶段进行了最小化。 请关闭并重新打开AH并重新启动Sniper"
TSM.L["You've been undercut."] = "已被压价。"
	elseif locale == "zhTW" then
TSM.L = TSM.L or {}
--[[Translation missing --]]
TSM.L["%d |4Group:Groups; Selected (%d |4Item:Items;)"] = "%d |4Group:Groups; Selected (%d |4Item:Items;)"
--[[Translation missing --]]
TSM.L["%d auctions"] = "%d auctions"
--[[Translation missing --]]
TSM.L["%d Groups"] = "%d Groups"
TSM.L["%d Items"] = "%d 物品"
--[[Translation missing --]]
TSM.L["%d of %d"] = "%d of %d"
--[[Translation missing --]]
TSM.L["%d Operations"] = "%d Operations"
--[[Translation missing --]]
TSM.L["%d Posted Auctions"] = "%d Posted Auctions"
--[[Translation missing --]]
TSM.L["%d Sold Auctions"] = "%d Sold Auctions"
TSM.L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s 包包, %s 銀行, %s 拍賣場, %s 信箱)"
--[[Translation missing --]]
TSM.L["%s (%s player, %s alts, %s guild, %s AH)"] = "%s (%s player, %s alts, %s guild, %s AH)"
TSM.L["%s (%s profit)"] = "%s (%s 利潤)"
--[[Translation missing --]]
TSM.L["%s |4operation:operations;"] = "%s |4operation:operations;"
TSM.L["%s ago"] = "%s前"
--[[Translation missing --]]
TSM.L["%s Crafts"] = "%s Crafts"
--[[Translation missing --]]
TSM.L["%s group updated with %d items and %d materials."] = "%s group updated with %d items and %d materials."
--[[Translation missing --]]
TSM.L["%s in guild vault"] = "%s in guild vault"
TSM.L["%s is a valid custom price but %s is an invalid item."] = "%s 是一個有效的自定義價格但 %s 是一個無效的物品。"
TSM.L["%s is a valid custom price but did not give a value for %s."] = "%s 是一個有效的自定義價格但沒有為 %s 給出一個值。"
--[[Translation missing --]]
TSM.L["'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."] = "'%s' is an invalid operation! Min restock of %d is higher than max restock of %d."
TSM.L["%s is not a valid custom price and gave the following error: %s"] = "%s 不是一個有效的自定義價格,錯誤資訊: %s"
--[[Translation missing --]]
TSM.L["%s Operations"] = "%s Operations"
--[[Translation missing --]]
TSM.L["%s previously had the max number of operations, so removed %s."] = "%s previously had the max number of operations, so removed %s."
TSM.L["%s removed."] = "%s 移除."
--[[Translation missing --]]
TSM.L["%s sent you %s"] = "%s sent you %s"
--[[Translation missing --]]
TSM.L["%s sent you %s and %s"] = "%s sent you %s and %s"
--[[Translation missing --]]
TSM.L["%s sent you a COD of %s for %s"] = "%s sent you a COD of %s for %s"
--[[Translation missing --]]
TSM.L["%s sent you a message: %s"] = "%s sent you a message: %s"
TSM.L["%s total"] = "%s 全部"
TSM.L["%sDrag%s to move this button"] = "%s拖曳%s 移動該按紐"
TSM.L["%sLeft-Click%s to open the main window"] = "%s點擊%s 開啟主視窗"
--[[Translation missing --]]
TSM.L["(%d/500 Characters)"] = "(%d/500 Characters)"
--[[Translation missing --]]
TSM.L["(max %d)"] = "(max %d)"
--[[Translation missing --]]
TSM.L["(max 5000)"] = "(max 5000)"
--[[Translation missing --]]
TSM.L["(min %d - max %d)"] = "(min %d - max %d)"
--[[Translation missing --]]
TSM.L["(min 0 - max 10000)"] = "(min 0 - max 10000)"
--[[Translation missing --]]
TSM.L["(minimum 0 - maximum 20)"] = "(minimum 0 - maximum 20)"
--[[Translation missing --]]
TSM.L["(minimum 0 - maximum 2000)"] = "(minimum 0 - maximum 2000)"
--[[Translation missing --]]
TSM.L["(minimum 0 - maximum 905)"] = "(minimum 0 - maximum 905)"
--[[Translation missing --]]
TSM.L["(minimum 0.5 - maximum 10)"] = "(minimum 0.5 - maximum 10)"
TSM.L["/tsm help|r - Shows this help listing"] = "/tsm help|r - 顯示幫助列表"
TSM.L["/tsm|r - opens the main TSM window."] = "/tsm|r - 開啟TSM主視窗。"
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of purchase data has been preserved."
--[[Translation missing --]]
TSM.L["|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."] = "|cffff0000IMPORTANT:|r When TSM_Accounting last saved data for this realm, it was too big for WoW to handle, so old data was automatically trimmed in order to avoid corruption of the saved variables. The last %s of sale data has been preserved."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."] = "|cffffd839Left-Click|r to ignore an item for this session. Hold |cffffd839Shift|r to ignore permanently. You can remove items from permanent ignore in the Vendoring settings."
--[[Translation missing --]]
TSM.L["|cffffd839Left-Click|r to ignore an item this session."] = "|cffffd839Left-Click|r to ignore an item this session."
--[[Translation missing --]]
TSM.L["|cffffd839Shift-Left-Click|r to ignore it permanently."] = "|cffffd839Shift-Left-Click|r to ignore it permanently."
--[[Translation missing --]]
TSM.L["1 Group"] = "1 Group"
TSM.L["1 Item"] = "1 物品"
TSM.L["12 hr"] = "12小時"
TSM.L["24 hr"] = "24小時"
TSM.L["48 hr"] = "48小時"
TSM.L["A custom price of %s for %s evaluates to %s."] = "%s的自定義價格為%s到%s。"
TSM.L["A maximum of 1 convert() function is allowed."] = "最多只允許1個convert()函數。"
--[[Translation missing --]]
TSM.L["A profile with that name already exists on the target account. Rename it first and try again."] = "A profile with that name already exists on the target account. Rename it first and try again."
--[[Translation missing --]]
TSM.L["A profile with this name already exists."] = "A profile with this name already exists."
--[[Translation missing --]]
TSM.L["A scan is already in progress. Please stop that scan before starting another one."] = "A scan is already in progress. Please stop that scan before starting another one."
--[[Translation missing --]]
TSM.L["Above max expires."] = "Above max expires."
--[[Translation missing --]]
TSM.L["Above max price. Not posting."] = "Above max price. Not posting."
--[[Translation missing --]]
TSM.L["Above max price. Posting at max price."] = "Above max price. Posting at max price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at min price."] = "Above max price. Posting at min price."
--[[Translation missing --]]
TSM.L["Above max price. Posting at normal price."] = "Above max price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Accepting these item(s) will cost"] = "Accepting these item(s) will cost"
--[[Translation missing --]]
TSM.L["Accepting this item will cost"] = "Accepting this item will cost"
--[[Translation missing --]]
TSM.L["Account sync removed. Please delete the account sync from the other account as well."] = "Account sync removed. Please delete the account sync from the other account as well."
TSM.L["Account Syncing"] = "帳戶同步"
--[[Translation missing --]]
TSM.L["Accounting"] = "Accounting"
--[[Translation missing --]]
TSM.L["Accounting Tooltips"] = "Accounting Tooltips"
--[[Translation missing --]]
TSM.L["Activity Type"] = "Activity Type"
--[[Translation missing --]]
TSM.L["ADD %d ITEMS"] = "ADD %d ITEMS"
--[[Translation missing --]]
TSM.L["Add / Remove Items"] = "Add / Remove Items"
--[[Translation missing --]]
TSM.L["ADD NEW CUSTOM PRICE SOURCE"] = "ADD NEW CUSTOM PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ADD OPERATION"] = "ADD OPERATION"
--[[Translation missing --]]
TSM.L["Add Player"] = "Add Player"
--[[Translation missing --]]
TSM.L["Add Subject / Description"] = "Add Subject / Description"
--[[Translation missing --]]
TSM.L["Add Subject / Description (Optional)"] = "Add Subject / Description (Optional)"
--[[Translation missing --]]
TSM.L["ADD TO MAIL"] = "ADD TO MAIL"
--[[Translation missing --]]
TSM.L["Added '%s' profile which was received from %s."] = "Added '%s' profile which was received from %s."
--[[Translation missing --]]
TSM.L["Added %s to %s."] = "Added %s to %s."
TSM.L["Additional error suppressed"] = "隱藏的其他錯誤"
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be auctioned."] = "Adjust the settings below to set how groups attached to this operation will be auctioned."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be cancelled."] = "Adjust the settings below to set how groups attached to this operation will be cancelled."
--[[Translation missing --]]
TSM.L["Adjust the settings below to set how groups attached to this operation will be priced."] = "Adjust the settings below to set how groups attached to this operation will be priced."
--[[Translation missing --]]
TSM.L["Advanced Item Search"] = "Advanced Item Search"
--[[Translation missing --]]
TSM.L["Advanced Options"] = "Advanced Options"
TSM.L["AH"] = "拍賣場"
--[[Translation missing --]]
TSM.L["AH (Crafting)"] = "AH (Crafting)"
--[[Translation missing --]]
TSM.L["AH (Disenchanting)"] = "AH (Disenchanting)"
--[[Translation missing --]]
TSM.L["AH BUSY"] = "AH BUSY"
--[[Translation missing --]]
TSM.L["AH Frame Options"] = "AH Frame Options"
TSM.L["Alarm Clock"] = "警示鐘"
--[[Translation missing --]]
TSM.L["All Auctions"] = "All Auctions"
--[[Translation missing --]]
TSM.L["All Characters and Guilds"] = "All Characters and Guilds"
--[[Translation missing --]]
TSM.L["All Item Classes"] = "All Item Classes"
--[[Translation missing --]]
TSM.L["All Professions"] = "All Professions"
--[[Translation missing --]]
TSM.L["All Subclasses"] = "All Subclasses"
--[[Translation missing --]]
TSM.L["Allow partial stack?"] = "Allow partial stack?"
--[[Translation missing --]]
TSM.L["Alt Guild Bank"] = "Alt Guild Bank"
--[[Translation missing --]]
TSM.L["Alts"] = "Alts"
--[[Translation missing --]]
TSM.L["Alts AH"] = "Alts AH"
--[[Translation missing --]]
TSM.L["Amount"] = "Amount"
--[[Translation missing --]]
TSM.L["AMOUNT"] = "AMOUNT"
--[[Translation missing --]]
TSM.L["Amount of Bag Space to Keep Free"] = "Amount of Bag Space to Keep Free"
--[[Translation missing --]]
TSM.L["APPLY FILTERS"] = "APPLY FILTERS"
--[[Translation missing --]]
TSM.L["Apply operation to group:"] = "Apply operation to group:"
--[[Translation missing --]]
TSM.L["Are you sure you want to clear old accounting data?"] = "Are you sure you want to clear old accounting data?"
TSM.L["Are you sure you want to delete this group?"] = "你確定要取消這個群組?"
TSM.L["Are you sure you want to delete this operation?"] = "你確定要取消這個動作?"
--[[Translation missing --]]
TSM.L["Are you sure you want to reset all operation settings?"] = "Are you sure you want to reset all operation settings?"
--[[Translation missing --]]
TSM.L["At above max price and not undercut."] = "At above max price and not undercut."
--[[Translation missing --]]
TSM.L["At normal price and not undercut."] = "At normal price and not undercut."
--[[Translation missing --]]
TSM.L["Auction"] = "Auction"
--[[Translation missing --]]
TSM.L["Auction Bid"] = "Auction Bid"
--[[Translation missing --]]
TSM.L["Auction Buyout"] = "Auction Buyout"
--[[Translation missing --]]
TSM.L["AUCTION DETAILS"] = "AUCTION DETAILS"
--[[Translation missing --]]
TSM.L["Auction Duration"] = "Auction Duration"
--[[Translation missing --]]
TSM.L["Auction has been bid on."] = "Auction has been bid on."
--[[Translation missing --]]
TSM.L["Auction House Cut"] = "Auction House Cut"
--[[Translation missing --]]
TSM.L["Auction Sale Sound"] = "Auction Sale Sound"
TSM.L["Auction Window Close"] = "關閉拍賣視窗"
TSM.L["Auction Window Open"] = "開啟拍賣視窗"
TSM.L["Auctionator - Auction Value"] = "Auctionator - 拍賣價格"
--[[Translation missing --]]
TSM.L["AuctionDB - Market Value"] = "AuctionDB - Market Value"
TSM.L["Auctioneer - Appraiser"] = "Auctioneer - 出價"
TSM.L["Auctioneer - Market Value"] = "Auctioneer - 市場價格"
TSM.L["Auctioneer - Minimum Buyout"] = "Auctioneer - 最小直購價"
--[[Translation missing --]]
TSM.L["Auctioning"] = "Auctioning"
--[[Translation missing --]]
TSM.L["Auctioning Log"] = "Auctioning Log"
--[[Translation missing --]]
TSM.L["Auctioning Operation"] = "Auctioning Operation"
--[[Translation missing --]]
TSM.L["Auctioning 'POST'/'CANCEL' Button"] = "Auctioning 'POST'/'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Auctioning Tooltips"] = "Auctioning Tooltips"
TSM.L["Auctions"] = "拍賣"
--[[Translation missing --]]
TSM.L["Auto Quest Complete"] = "Auto Quest Complete"
--[[Translation missing --]]
TSM.L["Average Earned Per Day:"] = "Average Earned Per Day:"
--[[Translation missing --]]
TSM.L["Average Prices:"] = "Average Prices:"
--[[Translation missing --]]
TSM.L["Average Profit Per Day:"] = "Average Profit Per Day:"
--[[Translation missing --]]
TSM.L["Average Spent Per Day:"] = "Average Spent Per Day:"
--[[Translation missing --]]
TSM.L["Avg Buy Price"] = "Avg Buy Price"
--[[Translation missing --]]
TSM.L["Avg Resale Profit"] = "Avg Resale Profit"
--[[Translation missing --]]
TSM.L["Avg Sell Price"] = "Avg Sell Price"
--[[Translation missing --]]
TSM.L["BACK"] = "BACK"
--[[Translation missing --]]
TSM.L["BACK TO LIST"] = "BACK TO LIST"
--[[Translation missing --]]
TSM.L["Back to List"] = "Back to List"
--[[Translation missing --]]
TSM.L["Bag"] = "Bag"
TSM.L["Bags"] = "包包"
--[[Translation missing --]]
TSM.L["Banks"] = "Banks"
--[[Translation missing --]]
TSM.L["Base Group"] = "Base Group"
--[[Translation missing --]]
TSM.L["Base Item"] = "Base Item"
--[[Translation missing --]]
TSM.L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."] = "Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."
--[[Translation missing --]]
TSM.L["Below custom price:"] = "Below custom price:"
--[[Translation missing --]]
TSM.L["Below min price. Posting at max price."] = "Below min price. Posting at max price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at min price."] = "Below min price. Posting at min price."
--[[Translation missing --]]
TSM.L["Below min price. Posting at normal price."] = "Below min price. Posting at normal price."
--[[Translation missing --]]
TSM.L["Below, you can manage your profiles which allow you to have entirely different sets of groups."] = "Below, you can manage your profiles which allow you to have entirely different sets of groups."
--[[Translation missing --]]
TSM.L["BID"] = "BID"
--[[Translation missing --]]
TSM.L["Bid %d / %d"] = "Bid %d / %d"
--[[Translation missing --]]
TSM.L["Bid (item)"] = "Bid (item)"
--[[Translation missing --]]
TSM.L["Bid (stack)"] = "Bid (stack)"
--[[Translation missing --]]
TSM.L["Bid Price"] = "Bid Price"
--[[Translation missing --]]
TSM.L["Bid Sniper Paused"] = "Bid Sniper Paused"
--[[Translation missing --]]
TSM.L["Bid Sniper Running"] = "Bid Sniper Running"
--[[Translation missing --]]
TSM.L["Bidding Auction"] = "Bidding Auction"
--[[Translation missing --]]
TSM.L["Blacklisted players:"] = "Blacklisted players:"
--[[Translation missing --]]
TSM.L["Bought"] = "Bought"
--[[Translation missing --]]
TSM.L["Bought %d of %s from %s for %s"] = "Bought %d of %s from %s for %s"
--[[Translation missing --]]
TSM.L["Bought %sx%d for %s from %s"] = "Bought %sx%d for %s from %s"
--[[Translation missing --]]
TSM.L["Bound Actions"] = "Bound Actions"
--[[Translation missing --]]
TSM.L["BUSY"] = "BUSY"
--[[Translation missing --]]
TSM.L["BUY"] = "BUY"
--[[Translation missing --]]
TSM.L["Buy"] = "Buy"
--[[Translation missing --]]
TSM.L["Buy %d / %d"] = "Buy %d / %d"
--[[Translation missing --]]
TSM.L["Buy %d / %d (Confirming %d / %d)"] = "Buy %d / %d (Confirming %d / %d)"
--[[Translation missing --]]
TSM.L["Buy from AH"] = "Buy from AH"
TSM.L["Buy from Vendor"] = "向商人購買"
--[[Translation missing --]]
TSM.L["BUY GROUPS"] = "BUY GROUPS"
--[[Translation missing --]]
TSM.L["Buy Options"] = "Buy Options"
--[[Translation missing --]]
TSM.L["BUYBACK ALL"] = "BUYBACK ALL"
--[[Translation missing --]]
TSM.L["Buyer/Seller"] = "Buyer/Seller"
--[[Translation missing --]]
TSM.L["BUYOUT"] = "BUYOUT"
--[[Translation missing --]]
TSM.L["Buyout (item)"] = "Buyout (item)"
--[[Translation missing --]]
TSM.L["Buyout (stack)"] = "Buyout (stack)"
--[[Translation missing --]]
TSM.L["Buyout Confirmation Alert"] = "Buyout Confirmation Alert"
--[[Translation missing --]]
TSM.L["Buyout Price"] = "Buyout Price"
--[[Translation missing --]]
TSM.L["Buyout Sniper Paused"] = "Buyout Sniper Paused"
--[[Translation missing --]]
TSM.L["Buyout Sniper Running"] = "Buyout Sniper Running"
--[[Translation missing --]]
TSM.L["BUYS"] = "BUYS"
--[[Translation missing --]]
TSM.L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."] = "By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."
--[[Translation missing --]]
TSM.L["Cancel auctions with bids"] = "Cancel auctions with bids"
--[[Translation missing --]]
TSM.L["Cancel Scan"] = "Cancel Scan"
--[[Translation missing --]]
TSM.L["Cancel to repost higher?"] = "Cancel to repost higher?"
--[[Translation missing --]]
TSM.L["Cancel undercut auctions?"] = "Cancel undercut auctions?"
--[[Translation missing --]]
TSM.L["Canceling"] = "Canceling"
--[[Translation missing --]]
TSM.L["Canceling %d / %d"] = "Canceling %d / %d"
--[[Translation missing --]]
TSM.L["Canceling %d Auctions..."] = "Canceling %d Auctions..."
--[[Translation missing --]]
TSM.L["Canceling all auctions."] = "Canceling all auctions."
--[[Translation missing --]]
TSM.L["Canceling auction which you've undercut."] = "Canceling auction which you've undercut."
--[[Translation missing --]]
TSM.L["Canceling disabled."] = "Canceling disabled."
--[[Translation missing --]]
TSM.L["Canceling Settings"] = "Canceling Settings"
--[[Translation missing --]]
TSM.L["Canceling to repost at higher price."] = "Canceling to repost at higher price."
--[[Translation missing --]]
TSM.L["Canceling to repost at reset price."] = "Canceling to repost at reset price."
--[[Translation missing --]]
TSM.L["Canceling to repost higher."] = "Canceling to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions and to repost higher."] = "Canceling undercut auctions and to repost higher."
--[[Translation missing --]]
TSM.L["Canceling undercut auctions."] = "Canceling undercut auctions."
--[[Translation missing --]]
TSM.L["Cancelled"] = "Cancelled"
--[[Translation missing --]]
TSM.L["Cancelled auction of %sx%d"] = "Cancelled auction of %sx%d"
--[[Translation missing --]]
TSM.L["Cancelled Since Last Sale"] = "Cancelled Since Last Sale"
--[[Translation missing --]]
TSM.L["CANCELS"] = "CANCELS"
--[[Translation missing --]]
TSM.L["Cannot repair from the guild bank!"] = "Cannot repair from the guild bank!"
TSM.L["Can't load TSM tooltip while in combat"] = "戰鬥中無法載入TSM提示"
--[[Translation missing --]]
TSM.L["Cash Register"] = "Cash Register"
--[[Translation missing --]]
TSM.L["CHARACTER"] = "CHARACTER"
--[[Translation missing --]]
TSM.L["Character"] = "Character"
TSM.L["Chat Tab"] = "聊天標籤"
--[[Translation missing --]]
TSM.L["Cheapest auction below min price."] = "Cheapest auction below min price."
TSM.L["Clear"] = "清除"
--[[Translation missing --]]
TSM.L["Clear All"] = "Clear All"
--[[Translation missing --]]
TSM.L["CLEAR DATA"] = "CLEAR DATA"
--[[Translation missing --]]
TSM.L["Clear Filters"] = "Clear Filters"
--[[Translation missing --]]
TSM.L["Clear Old Data"] = "Clear Old Data"
--[[Translation missing --]]
TSM.L["Clear Old Data Confirmation"] = "Clear Old Data Confirmation"
--[[Translation missing --]]
TSM.L["Clear Queue"] = "Clear Queue"
TSM.L["Clear Selection"] = "消除選擇"
--[[Translation missing --]]
TSM.L["COD"] = "COD"
--[[Translation missing --]]
TSM.L["Coins (%s)"] = "Coins (%s)"
--[[Translation missing --]]
TSM.L["Collapse All Groups"] = "Collapse All Groups"
--[[Translation missing --]]
TSM.L["Combine Partial Stacks"] = "Combine Partial Stacks"
--[[Translation missing --]]
TSM.L["Combining..."] = "Combining..."
--[[Translation missing --]]
TSM.L["Configuration Scroll Wheel"] = "Configuration Scroll Wheel"
--[[Translation missing --]]
TSM.L["Confirm"] = "Confirm"
--[[Translation missing --]]
TSM.L["Confirm Complete Sound"] = "Confirm Complete Sound"
--[[Translation missing --]]
TSM.L["Confirming %d / %d"] = "Confirming %d / %d"
--[[Translation missing --]]
TSM.L["Connected to %s"] = "Connected to %s"
--[[Translation missing --]]
TSM.L["Connecting to %s"] = "Connecting to %s"
--[[Translation missing --]]
TSM.L["CONTACTS"] = "CONTACTS"
--[[Translation missing --]]
TSM.L["Contacts Menu"] = "Contacts Menu"
--[[Translation missing --]]
TSM.L["Cooldown"] = "Cooldown"
--[[Translation missing --]]
TSM.L["Cooldowns"] = "Cooldowns"
--[[Translation missing --]]
TSM.L["Cost"] = "Cost"
--[[Translation missing --]]
TSM.L["Could not create macro as you already have too many. Delete one of your existing macros and try again."] = "Could not create macro as you already have too many. Delete one of your existing macros and try again."
--[[Translation missing --]]
TSM.L["Could not find profile '%s'. Possible profiles: '%s'"] = "Could not find profile '%s'. Possible profiles: '%s'"
--[[Translation missing --]]
TSM.L["Could not sell items due to not having free bag space available to split a stack of items."] = "Could not sell items due to not having free bag space available to split a stack of items."
--[[Translation missing --]]
TSM.L["Craft"] = "Craft"
--[[Translation missing --]]
TSM.L["CRAFT"] = "CRAFT"
--[[Translation missing --]]
TSM.L["Craft (Unprofitable)"] = "Craft (Unprofitable)"
--[[Translation missing --]]
TSM.L["Craft (When Profitable)"] = "Craft (When Profitable)"
--[[Translation missing --]]
TSM.L["Craft All"] = "Craft All"
--[[Translation missing --]]
TSM.L["CRAFT ALL"] = "CRAFT ALL"
--[[Translation missing --]]
TSM.L["Craft Name"] = "Craft Name"
--[[Translation missing --]]
TSM.L["CRAFT NEXT"] = "CRAFT NEXT"
--[[Translation missing --]]
TSM.L["Craft value method:"] = "Craft value method:"
--[[Translation missing --]]
TSM.L["CRAFTER"] = "CRAFTER"
--[[Translation missing --]]
TSM.L["CRAFTING"] = "CRAFTING"
--[[Translation missing --]]
TSM.L["Crafting"] = "Crafting"
--[[Translation missing --]]
TSM.L["Crafting Cost"] = "Crafting Cost"
--[[Translation missing --]]
TSM.L["Crafting 'CRAFT NEXT' Button"] = "Crafting 'CRAFT NEXT' Button"
--[[Translation missing --]]
TSM.L["Crafting Queue"] = "Crafting Queue"
--[[Translation missing --]]
TSM.L["Crafting Tooltips"] = "Crafting Tooltips"
--[[Translation missing --]]
TSM.L["Crafts"] = "Crafts"
--[[Translation missing --]]
TSM.L["Crafts %d"] = "Crafts %d"
--[[Translation missing --]]
TSM.L["CREATE MACRO"] = "CREATE MACRO"
--[[Translation missing --]]
TSM.L["Create New Operation"] = "Create New Operation"
--[[Translation missing --]]
TSM.L["CREATE NEW PROFILE"] = "CREATE NEW PROFILE"
--[[Translation missing --]]
TSM.L["Create Profession Group"] = "Create Profession Group"
--[[Translation missing --]]
TSM.L["Created custom price source: |cff99ffff%s|r"] = "Created custom price source: |cff99ffff%s|r"
TSM.L["Crystals"] = "水晶"
--[[Translation missing --]]
TSM.L["Current Profiles"] = "Current Profiles"
--[[Translation missing --]]
TSM.L["CURRENT SEARCH"] = "CURRENT SEARCH"
--[[Translation missing --]]
TSM.L["CUSTOM POST"] = "CUSTOM POST"
--[[Translation missing --]]
TSM.L["Custom Price"] = "Custom Price"
TSM.L["Custom Price Source"] = "自定義價格源"
--[[Translation missing --]]
TSM.L["Custom Sources"] = "Custom Sources"
--[[Translation missing --]]
TSM.L["Database Sources"] = "Database Sources"
--[[Translation missing --]]
TSM.L["Default Craft Value Method:"] = "Default Craft Value Method:"
--[[Translation missing --]]
TSM.L["Default Material Cost Method:"] = "Default Material Cost Method:"
--[[Translation missing --]]
TSM.L["Default Price"] = "Default Price"
--[[Translation missing --]]
TSM.L["Default Price Configuration"] = "Default Price Configuration"
--[[Translation missing --]]
TSM.L["Define what priority Gathering gives certain sources."] = "Define what priority Gathering gives certain sources."
--[[Translation missing --]]
TSM.L["Delete Profile Confirmation"] = "Delete Profile Confirmation"
--[[Translation missing --]]
TSM.L["Delete this record?"] = "Delete this record?"
--[[Translation missing --]]
TSM.L["Deposit"] = "Deposit"
--[[Translation missing --]]
TSM.L["Deposit Cost"] = "Deposit Cost"
--[[Translation missing --]]
TSM.L["Deposit Price"] = "Deposit Price"
--[[Translation missing --]]
TSM.L["DEPOSIT REAGENTS"] = "DEPOSIT REAGENTS"
TSM.L["Deselect All Groups"] = "取消所有分組選定"
--[[Translation missing --]]
TSM.L["Deselect All Items"] = "Deselect All Items"
--[[Translation missing --]]
TSM.L["Destroy Next"] = "Destroy Next"
--[[Translation missing --]]
TSM.L["Destroy Value"] = "Destroy Value"
--[[Translation missing --]]
TSM.L["Destroy Value Source"] = "Destroy Value Source"
--[[Translation missing --]]
TSM.L["Destroying"] = "Destroying"
--[[Translation missing --]]
TSM.L["Destroying 'DESTROY NEXT' Button"] = "Destroying 'DESTROY NEXT' Button"
--[[Translation missing --]]
TSM.L["Destroying Tooltips"] = "Destroying Tooltips"
--[[Translation missing --]]
TSM.L["Destroying..."] = "Destroying..."
--[[Translation missing --]]
TSM.L["Details"] = "Details"
--[[Translation missing --]]
TSM.L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."] = "Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."] = "Did not cancel %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."] = "Did not cancel %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."] = "Did not cancel %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."] = "Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."
--[[Translation missing --]]
TSM.L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."] = "Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."
--[[Translation missing --]]
TSM.L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."] = "Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is invalid. Check your settings."] = "Did not post %s because your maximum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your minimum price (%s) is invalid. Check your settings."] = "Did not post %s because your minimum price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is invalid. Check your settings."] = "Did not post %s because your normal price (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."] = "Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."
--[[Translation missing --]]
TSM.L["Did not post %s because your undercut (%s) is invalid. Check your settings."] = "Did not post %s because your undercut (%s) is invalid. Check your settings."
--[[Translation missing --]]
TSM.L["Disable invalid price warnings"] = "Disable invalid price warnings"
--[[Translation missing --]]
TSM.L["Disenchant Search"] = "Disenchant Search"
--[[Translation missing --]]
TSM.L["DISENCHANT SEARCH"] = "DISENCHANT SEARCH"
--[[Translation missing --]]
TSM.L["Disenchant Search Options"] = "Disenchant Search Options"
--[[Translation missing --]]
TSM.L["Disenchant Value"] = "Disenchant Value"
--[[Translation missing --]]
TSM.L["Disenchanting Options"] = "Disenchanting Options"
--[[Translation missing --]]
TSM.L["Display auctioning values"] = "Display auctioning values"
--[[Translation missing --]]
TSM.L["Display cancelled since last sale"] = "Display cancelled since last sale"
--[[Translation missing --]]
TSM.L["Display crafting cost"] = "Display crafting cost"
--[[Translation missing --]]
TSM.L["Display detailed destroy info"] = "Display detailed destroy info"
--[[Translation missing --]]
TSM.L["Display disenchant value"] = "Display disenchant value"
--[[Translation missing --]]
TSM.L["Display expired auctions"] = "Display expired auctions"
--[[Translation missing --]]
TSM.L["Display group name"] = "Display group name"
--[[Translation missing --]]
TSM.L["Display historical price"] = "Display historical price"
--[[Translation missing --]]
TSM.L["Display market value"] = "Display market value"
--[[Translation missing --]]
TSM.L["Display mill value"] = "Display mill value"
--[[Translation missing --]]
TSM.L["Display min buyout"] = "Display min buyout"
--[[Translation missing --]]
TSM.L["Display Operation Names"] = "Display Operation Names"
--[[Translation missing --]]
TSM.L["Display prospect value"] = "Display prospect value"
--[[Translation missing --]]
TSM.L["Display purchase info"] = "Display purchase info"
--[[Translation missing --]]
TSM.L["Display region historical price"] = "Display region historical price"
--[[Translation missing --]]
TSM.L["Display region market value avg"] = "Display region market value avg"
--[[Translation missing --]]
TSM.L["Display region min buyout avg"] = "Display region min buyout avg"
--[[Translation missing --]]
TSM.L["Display region sale avg"] = "Display region sale avg"
--[[Translation missing --]]
TSM.L["Display region sale rate"] = "Display region sale rate"
--[[Translation missing --]]
TSM.L["Display region sold per day"] = "Display region sold per day"
--[[Translation missing --]]
TSM.L["Display sale info"] = "Display sale info"
--[[Translation missing --]]
TSM.L["Display sale rate"] = "Display sale rate"
--[[Translation missing --]]
TSM.L["Display shopping max price"] = "Display shopping max price"
--[[Translation missing --]]
TSM.L["Display total money recieved in chat?"] = "Display total money recieved in chat?"
--[[Translation missing --]]
TSM.L["Display transform value"] = "Display transform value"
--[[Translation missing --]]
TSM.L["Display vendor buy price"] = "Display vendor buy price"
--[[Translation missing --]]
TSM.L["Display vendor sell price"] = "Display vendor sell price"
--[[Translation missing --]]
TSM.L["Doing so will also remove any sub-groups attached to this group."] = "Doing so will also remove any sub-groups attached to this group."
--[[Translation missing --]]
TSM.L["Done Canceling"] = "Done Canceling"
--[[Translation missing --]]
TSM.L["Done Posting"] = "Done Posting"
--[[Translation missing --]]
TSM.L["Done rebuilding item cache."] = "Done rebuilding item cache."
--[[Translation missing --]]
TSM.L["Done Scanning"] = "Done Scanning"
--[[Translation missing --]]
TSM.L["Don't post after this many expires:"] = "Don't post after this many expires:"
--[[Translation missing --]]
TSM.L["Don't Post Items"] = "Don't Post Items"
--[[Translation missing --]]
TSM.L["Don't prompt to record trades"] = "Don't prompt to record trades"
--[[Translation missing --]]
TSM.L["DOWN"] = "DOWN"
--[[Translation missing --]]
TSM.L["Drag in Additional Items (%d/%d Items)"] = "Drag in Additional Items (%d/%d Items)"
--[[Translation missing --]]
TSM.L["Drag Item(s) Into Box"] = "Drag Item(s) Into Box"
--[[Translation missing --]]
TSM.L["Duplicate"] = "Duplicate"
--[[Translation missing --]]
TSM.L["Duplicate Profile Confirmation"] = "Duplicate Profile Confirmation"
TSM.L["Dust"] = "塵"
--[[Translation missing --]]
TSM.L["Elevate your gold-making!"] = "Elevate your gold-making!"
--[[Translation missing --]]
TSM.L["Embed TSM tooltips"] = "Embed TSM tooltips"
--[[Translation missing --]]
TSM.L["EMPTY BAGS"] = "EMPTY BAGS"
--[[Translation missing --]]
TSM.L["Empty parentheses are not allowed"] = "Empty parentheses are not allowed"
TSM.L["Empty price string."] = "清空價格字串。"
--[[Translation missing --]]
TSM.L["Enable automatic stack combination"] = "Enable automatic stack combination"
--[[Translation missing --]]
TSM.L["Enable buying?"] = "Enable buying?"
--[[Translation missing --]]
TSM.L["Enable inbox chat messages"] = "Enable inbox chat messages"
--[[Translation missing --]]
TSM.L["Enable restock?"] = "Enable restock?"
--[[Translation missing --]]
TSM.L["Enable selling?"] = "Enable selling?"
--[[Translation missing --]]
TSM.L["Enable sending chat messages"] = "Enable sending chat messages"
--[[Translation missing --]]
TSM.L["Enable TSM Tooltips"] = "Enable TSM Tooltips"
--[[Translation missing --]]
TSM.L["Enable tweet enhancement"] = "Enable tweet enhancement"
--[[Translation missing --]]
TSM.L["Enchant Vellum"] = "Enchant Vellum"
--[[Translation missing --]]
TSM.L["Ensure both characters are online and try again."] = "Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Enter a name for the new profile"] = "Enter a name for the new profile"
--[[Translation missing --]]
TSM.L["Enter Filter"] = "Enter Filter"
--[[Translation missing --]]
TSM.L["Enter Keyword"] = "Enter Keyword"
--[[Translation missing --]]
TSM.L["Enter name of logged-in character from other account"] = "Enter name of logged-in character from other account"
--[[Translation missing --]]
TSM.L["Enter player name"] = "Enter player name"
TSM.L["Essences"] = "精華"
--[[Translation missing --]]
TSM.L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."] = "Establishing connection to %s. Make sure that you've entered this character's name on the other account."
--[[Translation missing --]]
TSM.L["Estimated Cost:"] = "Estimated Cost:"
--[[Translation missing --]]
TSM.L["Estimated deliver time"] = "Estimated deliver time"
--[[Translation missing --]]
TSM.L["Estimated Profit:"] = "Estimated Profit:"
--[[Translation missing --]]
TSM.L["Exact Match Only?"] = "Exact Match Only?"
--[[Translation missing --]]
TSM.L["Exclude crafts with cooldowns"] = "Exclude crafts with cooldowns"
--[[Translation missing --]]
TSM.L["Expand All Groups"] = "Expand All Groups"
--[[Translation missing --]]
TSM.L["Expenses"] = "Expenses"
--[[Translation missing --]]
TSM.L["EXPENSES"] = "EXPENSES"
--[[Translation missing --]]
TSM.L["Expirations"] = "Expirations"
--[[Translation missing --]]
TSM.L["Expired"] = "Expired"
--[[Translation missing --]]
TSM.L["Expired Auctions"] = "Expired Auctions"
--[[Translation missing --]]
TSM.L["Expired Since Last Sale"] = "Expired Since Last Sale"
--[[Translation missing --]]
TSM.L["Expires"] = "Expires"
--[[Translation missing --]]
TSM.L["EXPIRES"] = "EXPIRES"
--[[Translation missing --]]
TSM.L["Expires Since Last Sale"] = "Expires Since Last Sale"
--[[Translation missing --]]
TSM.L["Expiring Mails"] = "Expiring Mails"
--[[Translation missing --]]
TSM.L["Exploration"] = "Exploration"
--[[Translation missing --]]
TSM.L["Export"] = "Export"
--[[Translation missing --]]
TSM.L["Export List"] = "Export List"
--[[Translation missing --]]
TSM.L["Failed Auctions"] = "Failed Auctions"
--[[Translation missing --]]
TSM.L["Failed Since Last Sale (Expired/Cancelled)"] = "Failed Since Last Sale (Expired/Cancelled)"
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s (x%s) for %s."] = "Failed to bid on auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to bid on auction of %s."] = "Failed to bid on auction of %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s (x%s) for %s."] = "Failed to buy auction of %s (x%s) for %s."
--[[Translation missing --]]
TSM.L["Failed to buy auction of %s."] = "Failed to buy auction of %s."
--[[Translation missing --]]
TSM.L["Failed to find auction for %s, so removing it from the results."] = "Failed to find auction for %s, so removing it from the results."
--[[Translation missing --]]
TSM.L["Failed to post %sx%d as the item no longer exists in your bags."] = "Failed to post %sx%d as the item no longer exists in your bags."
--[[Translation missing --]]
TSM.L["Failed to send profile."] = "Failed to send profile."
--[[Translation missing --]]
TSM.L["Failed to send profile. Ensure both characters are online and try again."] = "Failed to send profile. Ensure both characters are online and try again."
--[[Translation missing --]]
TSM.L["Favorite Scans"] = "Favorite Scans"
--[[Translation missing --]]
TSM.L["Favorite Searches"] = "Favorite Searches"
TSM.L["Filter Auctions by Duration"] = "以時間篩選拍賣"
TSM.L["Filter Auctions by Keyword"] = "以關鍵字篩選拍賣"
--[[Translation missing --]]
TSM.L["Filter by Keyword"] = "Filter by Keyword"
--[[Translation missing --]]
TSM.L["FILTER BY KEYWORD"] = "FILTER BY KEYWORD"
--[[Translation missing --]]
TSM.L["Filter group item lists based on the following price source"] = "Filter group item lists based on the following price source"
--[[Translation missing --]]
TSM.L["Filter Items"] = "Filter Items"
--[[Translation missing --]]
TSM.L["Filter Shopping"] = "Filter Shopping"
--[[Translation missing --]]
TSM.L["Finding Selected Auction"] = "Finding Selected Auction"
--[[Translation missing --]]
TSM.L["Fishing Reel In"] = "Fishing Reel In"
--[[Translation missing --]]
TSM.L["Forget Character"] = "Forget Character"
--[[Translation missing --]]
TSM.L["Found auction sound"] = "Found auction sound"
--[[Translation missing --]]
TSM.L["Friends"] = "Friends"
--[[Translation missing --]]
TSM.L["From"] = "From"
--[[Translation missing --]]
TSM.L["Full"] = "Full"
--[[Translation missing --]]
TSM.L["Garrison"] = "Garrison"
--[[Translation missing --]]
TSM.L["Gathering"] = "Gathering"
--[[Translation missing --]]
TSM.L["Gathering Search"] = "Gathering Search"
TSM.L["General Options"] = "常規選項"
--[[Translation missing --]]
TSM.L["Get from Bank"] = "Get from Bank"
--[[Translation missing --]]
TSM.L["Get from Guild Bank"] = "Get from Guild Bank"
--[[Translation missing --]]
TSM.L["Global Operation Confirmation"] = "Global Operation Confirmation"
--[[Translation missing --]]
TSM.L["Gold"] = "Gold"
--[[Translation missing --]]
TSM.L["Gold Earned:"] = "Gold Earned:"
--[[Translation missing --]]
TSM.L["GOLD ON HAND"] = "GOLD ON HAND"
--[[Translation missing --]]
TSM.L["Gold Spent:"] = "Gold Spent:"
--[[Translation missing --]]
TSM.L["GREAT DEALS SEARCH"] = "GREAT DEALS SEARCH"
--[[Translation missing --]]
TSM.L["Group already exists."] = "Group already exists."
--[[Translation missing --]]
TSM.L["Group Management"] = "Group Management"
--[[Translation missing --]]
TSM.L["Group Operations"] = "Group Operations"
--[[Translation missing --]]
TSM.L["Group Settings"] = "Group Settings"
--[[Translation missing --]]
TSM.L["Grouped Items"] = "Grouped Items"
TSM.L["Groups"] = "分組"
--[[Translation missing --]]
TSM.L["Guild"] = "Guild"
--[[Translation missing --]]
TSM.L["Guild Bank"] = "Guild Bank"
--[[Translation missing --]]
TSM.L["GVault"] = "GVault"
--[[Translation missing --]]
TSM.L["Have"] = "Have"
--[[Translation missing --]]
TSM.L["Have Materials"] = "Have Materials"
--[[Translation missing --]]
TSM.L["Have Skill Up"] = "Have Skill Up"
--[[Translation missing --]]
TSM.L["Hide auctions with bids"] = "Hide auctions with bids"
--[[Translation missing --]]
TSM.L["Hide Description"] = "Hide Description"
--[[Translation missing --]]
TSM.L["Hide minimap icon"] = "Hide minimap icon"
--[[Translation missing --]]
TSM.L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."] = "Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."
--[[Translation missing --]]
TSM.L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."] = "Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."
--[[Translation missing --]]
TSM.L["High Bidder"] = "High Bidder"
--[[Translation missing --]]
TSM.L["Historical Price"] = "Historical Price"
--[[Translation missing --]]
TSM.L["Hold ALT to repair from the guild bank."] = "Hold ALT to repair from the guild bank."
--[[Translation missing --]]
TSM.L["Hold shift to move the items to the parent group instead of removing them."] = "Hold shift to move the items to the parent group instead of removing them."
--[[Translation missing --]]
TSM.L["Hr"] = "Hr"
--[[Translation missing --]]
TSM.L["Hrs"] = "Hrs"
--[[Translation missing --]]
TSM.L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"] = "I just bought [%s]x%d for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["I just sold [%s] for %s! %s #TSM4 #warcraft"] = "I just sold [%s] for %s! %s #TSM4 #warcraft"
--[[Translation missing --]]
TSM.L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."] = "If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."
TSM.L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"] = "警告：如果你在多個配置檔下設定了“操作”選項，該操作會導致除了當前配置檔以外的所有配置檔中的“操作”選項永久性丟失。你確定要繼續嗎？"
--[[Translation missing --]]
TSM.L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."] = "If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."
--[[Translation missing --]]
TSM.L["Ignore Auctions Below Min"] = "Ignore Auctions Below Min"
--[[Translation missing --]]
TSM.L["Ignore auctions by duration?"] = "Ignore auctions by duration?"
--[[Translation missing --]]
TSM.L["Ignore Characters"] = "Ignore Characters"
--[[Translation missing --]]
TSM.L["Ignore Guilds"] = "Ignore Guilds"
--[[Translation missing --]]
TSM.L["Ignore item variations?"] = "Ignore item variations?"
--[[Translation missing --]]
TSM.L["Ignore operation on characters:"] = "Ignore operation on characters:"
--[[Translation missing --]]
TSM.L["Ignore operation on faction-realms:"] = "Ignore operation on faction-realms:"
--[[Translation missing --]]
TSM.L["Ignored Cooldowns"] = "Ignored Cooldowns"
--[[Translation missing --]]
TSM.L["Ignored Items"] = "Ignored Items"
--[[Translation missing --]]
TSM.L["ilvl"] = "ilvl"
--[[Translation missing --]]
TSM.L["Import"] = "Import"
--[[Translation missing --]]
TSM.L["IMPORT"] = "IMPORT"
--[[Translation missing --]]
TSM.L["Import %d Items and %s Operations?"] = "Import %d Items and %s Operations?"
--[[Translation missing --]]
TSM.L["Import Groups & Operations"] = "Import Groups & Operations"
--[[Translation missing --]]
TSM.L["Imported Items"] = "Imported Items"
--[[Translation missing --]]
TSM.L["Inbox Settings"] = "Inbox Settings"
--[[Translation missing --]]
TSM.L["Include Attached Operations"] = "Include Attached Operations"
--[[Translation missing --]]
TSM.L["Include operations?"] = "Include operations?"
--[[Translation missing --]]
TSM.L["Include soulbound items"] = "Include soulbound items"
--[[Translation missing --]]
TSM.L["Information"] = "Information"
--[[Translation missing --]]
TSM.L["Invalid custom price entered."] = "Invalid custom price entered."
--[[Translation missing --]]
TSM.L["Invalid custom price source for %s. %s"] = "Invalid custom price source for %s. %s"
TSM.L["Invalid custom price."] = "無效的自定義價格。"
TSM.L["Invalid function."] = "無效函數。"
--[[Translation missing --]]
TSM.L["Invalid gold value."] = "Invalid gold value."
--[[Translation missing --]]
TSM.L["Invalid group name."] = "Invalid group name."
--[[Translation missing --]]
TSM.L["Invalid import string."] = "Invalid import string."
TSM.L["Invalid item link."] = "無效的物品鏈接。"
--[[Translation missing --]]
TSM.L["Invalid operation name."] = "Invalid operation name."
TSM.L["Invalid operator at end of custom price."] = "無效的自定義價格運算符"
TSM.L["Invalid parameter to price source."] = "無效的自定義價格源參數。"
--[[Translation missing --]]
TSM.L["Invalid player name."] = "Invalid player name."
TSM.L["Invalid price source in convert."] = "轉換價格來源無效"
--[[Translation missing --]]
TSM.L["Invalid price source."] = "Invalid price source."
--[[Translation missing --]]
TSM.L["Invalid search filter"] = "Invalid search filter"
--[[Translation missing --]]
TSM.L["Invalid seller data returned by server."] = "Invalid seller data returned by server."
TSM.L["Invalid word: '%s'"] = "無效詞：“%s”"
--[[Translation missing --]]
TSM.L["Inventory"] = "Inventory"
--[[Translation missing --]]
TSM.L["Inventory / Gold Graph"] = "Inventory / Gold Graph"
--[[Translation missing --]]
TSM.L["Inventory / Mailing"] = "Inventory / Mailing"
--[[Translation missing --]]
TSM.L["Inventory Options"] = "Inventory Options"
--[[Translation missing --]]
TSM.L["Inventory Tooltip Format"] = "Inventory Tooltip Format"
--[[Translation missing --]]
TSM.L["It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."] = "It appears that you've manually copied your saved variables between accounts which will cause TSM's automatic sync'ing to not work. You'll need to undo this, and/or delete the TradeSkillMaster saved variables files on both accounts (with WoW closed) in order to fix this."
TSM.L["Item"] = "物品"
--[[Translation missing --]]
TSM.L["ITEM CLASS"] = "ITEM CLASS"
--[[Translation missing --]]
TSM.L["Item Level"] = "Item Level"
--[[Translation missing --]]
TSM.L["ITEM LEVEL RANGE"] = "ITEM LEVEL RANGE"
TSM.L["Item links may only be used as parameters to price sources."] = "物品鏈接只能作為價格源的參數。"
TSM.L["Item Name"] = "物品名稱"
--[[Translation missing --]]
TSM.L["Item Quality"] = "Item Quality"
--[[Translation missing --]]
TSM.L["ITEM SEARCH"] = "ITEM SEARCH"
--[[Translation missing --]]
TSM.L["ITEM SELECTION"] = "ITEM SELECTION"
--[[Translation missing --]]
TSM.L["ITEM SUBCLASS"] = "ITEM SUBCLASS"
--[[Translation missing --]]
TSM.L["Item Value"] = "Item Value"
--[[Translation missing --]]
TSM.L["Item/Group is invalid (see chat)."] = "Item/Group is invalid (see chat)."
--[[Translation missing --]]
TSM.L["ITEMS"] = "ITEMS"
TSM.L["Items"] = "物品"
--[[Translation missing --]]
TSM.L["Items in Bags"] = "Items in Bags"
--[[Translation missing --]]
TSM.L["Keep in bags quantity:"] = "Keep in bags quantity:"
--[[Translation missing --]]
TSM.L["Keep in bank quantity:"] = "Keep in bank quantity:"
--[[Translation missing --]]
TSM.L["Keep posted:"] = "Keep posted:"
--[[Translation missing --]]
TSM.L["Keep quantity:"] = "Keep quantity:"
--[[Translation missing --]]
TSM.L["Keep this amount in bags:"] = "Keep this amount in bags:"
--[[Translation missing --]]
TSM.L["Keep this amount:"] = "Keep this amount:"
--[[Translation missing --]]
TSM.L["Keeping %d."] = "Keeping %d."
--[[Translation missing --]]
TSM.L["Keeping undercut auctions posted."] = "Keeping undercut auctions posted."
--[[Translation missing --]]
TSM.L["Last 14 Days"] = "Last 14 Days"
--[[Translation missing --]]
TSM.L["Last 3 Days"] = "Last 3 Days"
--[[Translation missing --]]
TSM.L["Last 30 Days"] = "Last 30 Days"
--[[Translation missing --]]
TSM.L["LAST 30 DAYS"] = "LAST 30 DAYS"
--[[Translation missing --]]
TSM.L["Last 60 Days"] = "Last 60 Days"
--[[Translation missing --]]
TSM.L["Last 7 Days"] = "Last 7 Days"
--[[Translation missing --]]
TSM.L["LAST 7 DAYS"] = "LAST 7 DAYS"
--[[Translation missing --]]
TSM.L["Last Data Update:"] = "Last Data Update:"
--[[Translation missing --]]
TSM.L["Last Purchased"] = "Last Purchased"
--[[Translation missing --]]
TSM.L["Last Sold"] = "Last Sold"
TSM.L["Level Up"] = "升級"
--[[Translation missing --]]
TSM.L["LIMIT"] = "LIMIT"
--[[Translation missing --]]
TSM.L["Link to Another Operation"] = "Link to Another Operation"
--[[Translation missing --]]
TSM.L["List"] = "List"
--[[Translation missing --]]
TSM.L["List materials in tooltip"] = "List materials in tooltip"
--[[Translation missing --]]
TSM.L["Loading Mails..."] = "Loading Mails..."
--[[Translation missing --]]
TSM.L["Loading..."] = "Loading..."
TSM.L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."] = "看起來TradeSkillMaster似乎發生了一個錯誤。請按照下列指示協助作者修正此問題。"
TSM.L["Loop detected in the following custom price:"] = "在以下自定義價格中循環檢測："
--[[Translation missing --]]
TSM.L["Lowest auction by whitelisted player."] = "Lowest auction by whitelisted player."
--[[Translation missing --]]
TSM.L["Macro created and scroll wheel bound!"] = "Macro created and scroll wheel bound!"
TSM.L["Macro Setup"] = "建立巨集"
TSM.L["Mail"] = "信箱"
--[[Translation missing --]]
TSM.L["Mail Disenchantables"] = "Mail Disenchantables"
--[[Translation missing --]]
TSM.L["Mail Disenchantables Max Quality"] = "Mail Disenchantables Max Quality"
--[[Translation missing --]]
TSM.L["MAIL SELECTED GROUPS"] = "MAIL SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Mail to %s"] = "Mail to %s"
--[[Translation missing --]]
TSM.L["Mailing"] = "Mailing"
--[[Translation missing --]]
TSM.L["Mailing all to %s."] = "Mailing all to %s."
--[[Translation missing --]]
TSM.L["Mailing Options"] = "Mailing Options"
--[[Translation missing --]]
TSM.L["Mailing up to %d to %s."] = "Mailing up to %d to %s."
--[[Translation missing --]]
TSM.L["Main Settings"] = "Main Settings"
--[[Translation missing --]]
TSM.L["Make Cash On Delivery?"] = "Make Cash On Delivery?"
--[[Translation missing --]]
TSM.L["Management Options"] = "Management Options"
--[[Translation missing --]]
TSM.L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."] = "Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."
--[[Translation missing --]]
TSM.L["Map Ping"] = "Map Ping"
--[[Translation missing --]]
TSM.L["Market Value"] = "Market Value"
--[[Translation missing --]]
TSM.L["Market Value Price Source"] = "Market Value Price Source"
--[[Translation missing --]]
TSM.L["Market Value Source"] = "Market Value Source"
--[[Translation missing --]]
TSM.L["Mat Cost"] = "Mat Cost"
--[[Translation missing --]]
TSM.L["Mat Price"] = "Mat Price"
--[[Translation missing --]]
TSM.L["Match stack size?"] = "Match stack size?"
--[[Translation missing --]]
TSM.L["Match whitelisted players"] = "Match whitelisted players"
--[[Translation missing --]]
TSM.L["Material Name"] = "Material Name"
--[[Translation missing --]]
TSM.L["Materials"] = "Materials"
--[[Translation missing --]]
TSM.L["Materials to Gather"] = "Materials to Gather"
--[[Translation missing --]]
TSM.L["MAX"] = "MAX"
--[[Translation missing --]]
TSM.L["Max Buy Price"] = "Max Buy Price"
--[[Translation missing --]]
TSM.L["MAX EXPIRES TO BANK"] = "MAX EXPIRES TO BANK"
--[[Translation missing --]]
TSM.L["Max Sell Price"] = "Max Sell Price"
--[[Translation missing --]]
TSM.L["Max Shopping Price"] = "Max Shopping Price"
--[[Translation missing --]]
TSM.L["Maximum amount already posted."] = "Maximum amount already posted."
--[[Translation missing --]]
TSM.L["Maximum Auction Price (Per Item)"] = "Maximum Auction Price (Per Item)"
--[[Translation missing --]]
TSM.L["Maximum Destroy Value (Enter '0c' to disable)"] = "Maximum Destroy Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["Maximum disenchant level:"] = "Maximum disenchant level:"
--[[Translation missing --]]
TSM.L["Maximum Disenchant Quality"] = "Maximum Disenchant Quality"
--[[Translation missing --]]
TSM.L["Maximum disenchant search percentage:"] = "Maximum disenchant search percentage:"
--[[Translation missing --]]
TSM.L["Maximum Market Value (Enter '0c' to disable)"] = "Maximum Market Value (Enter '0c' to disable)"
--[[Translation missing --]]
TSM.L["MAXIMUM QUANTITY TO BUY:"] = "MAXIMUM QUANTITY TO BUY:"
--[[Translation missing --]]
TSM.L["Maximum quantity:"] = "Maximum quantity:"
--[[Translation missing --]]
TSM.L["Maximum restock quantity:"] = "Maximum restock quantity:"
--[[Translation missing --]]
TSM.L["Mill Value"] = "Mill Value"
--[[Translation missing --]]
TSM.L["Min"] = "Min"
--[[Translation missing --]]
TSM.L["Min Buy Price"] = "Min Buy Price"
--[[Translation missing --]]
TSM.L["Min Buyout"] = "Min Buyout"
--[[Translation missing --]]
TSM.L["Min Sell Price"] = "Min Sell Price"
--[[Translation missing --]]
TSM.L["Min/Normal/Max Prices"] = "Min/Normal/Max Prices"
--[[Translation missing --]]
TSM.L["Minimum Days Old"] = "Minimum Days Old"
--[[Translation missing --]]
TSM.L["Minimum disenchant level:"] = "Minimum disenchant level:"
--[[Translation missing --]]
TSM.L["Minimum expires:"] = "Minimum expires:"
--[[Translation missing --]]
TSM.L["Minimum profit:"] = "Minimum profit:"
--[[Translation missing --]]
TSM.L["MINIMUM RARITY"] = "MINIMUM RARITY"
--[[Translation missing --]]
TSM.L["Minimum restock quantity:"] = "Minimum restock quantity:"
TSM.L["Misplaced comma"] = "錯誤的逗號分隔"
--[[Translation missing --]]
TSM.L["Missing Materials"] = "Missing Materials"
--[[Translation missing --]]
TSM.L["Missing operator between sets of parenthesis"] = "Missing operator between sets of parenthesis"
--[[Translation missing --]]
TSM.L["Modifiers:"] = "Modifiers:"
--[[Translation missing --]]
TSM.L["Money Frame Open"] = "Money Frame Open"
--[[Translation missing --]]
TSM.L["Money Transfer"] = "Money Transfer"
--[[Translation missing --]]
TSM.L["Most Profitable Item:"] = "Most Profitable Item:"
--[[Translation missing --]]
TSM.L["MOVE"] = "MOVE"
--[[Translation missing --]]
TSM.L["Move already grouped items?"] = "Move already grouped items?"
--[[Translation missing --]]
TSM.L["Move Quantity Settings"] = "Move Quantity Settings"
--[[Translation missing --]]
TSM.L["MOVE TO BAGS"] = "MOVE TO BAGS"
--[[Translation missing --]]
TSM.L["MOVE TO BANK"] = "MOVE TO BANK"
--[[Translation missing --]]
TSM.L["MOVING"] = "MOVING"
--[[Translation missing --]]
TSM.L["Moving"] = "Moving"
--[[Translation missing --]]
TSM.L["Multiple Items"] = "Multiple Items"
TSM.L["My Auctions"] = "我的拍賣"
--[[Translation missing --]]
TSM.L["My Auctions 'CANCEL' Button"] = "My Auctions 'CANCEL' Button"
--[[Translation missing --]]
TSM.L["Neat Stacks only?"] = "Neat Stacks only?"
--[[Translation missing --]]
TSM.L["NEED MATS"] = "NEED MATS"
TSM.L["New Group"] = "新分組"
--[[Translation missing --]]
TSM.L["New Operation"] = "New Operation"
--[[Translation missing --]]
TSM.L["NEWS AND INFORMATION"] = "NEWS AND INFORMATION"
--[[Translation missing --]]
TSM.L["No Attachments"] = "No Attachments"
--[[Translation missing --]]
TSM.L["No Crafts"] = "No Crafts"
--[[Translation missing --]]
TSM.L["No Data"] = "No Data"
--[[Translation missing --]]
TSM.L["No group selected"] = "No group selected"
--[[Translation missing --]]
TSM.L["No item specified. Usage: /tsm restock_help [ITEM_LINK]"] = "No item specified. Usage: /tsm restock_help [ITEM_LINK]"
--[[Translation missing --]]
TSM.L["NO ITEMS"] = "NO ITEMS"
--[[Translation missing --]]
TSM.L["No Materials to Gather"] = "No Materials to Gather"
--[[Translation missing --]]
TSM.L["No Operation Selected"] = "No Operation Selected"
--[[Translation missing --]]
TSM.L["No posting."] = "No posting."
--[[Translation missing --]]
TSM.L["No Profession Opened"] = "No Profession Opened"
--[[Translation missing --]]
TSM.L["No Profession Selected"] = "No Profession Selected"
--[[Translation missing --]]
TSM.L["No profile specified. Possible profiles: '%s'"] = "No profile specified. Possible profiles: '%s'"
--[[Translation missing --]]
TSM.L["No recent AuctionDB scan data found."] = "No recent AuctionDB scan data found."
--[[Translation missing --]]
TSM.L["No Sound"] = "No Sound"
--[[Translation missing --]]
TSM.L["None"] = "None"
--[[Translation missing --]]
TSM.L["None (Always Show)"] = "None (Always Show)"
--[[Translation missing --]]
TSM.L["None Selected"] = "None Selected"
--[[Translation missing --]]
TSM.L["NONGROUP TO BANK"] = "NONGROUP TO BANK"
--[[Translation missing --]]
TSM.L["Normal"] = "Normal"
--[[Translation missing --]]
TSM.L["Not canceling auction at reset price."] = "Not canceling auction at reset price."
--[[Translation missing --]]
TSM.L["Not canceling auction below min price."] = "Not canceling auction below min price."
--[[Translation missing --]]
TSM.L["Not canceling."] = "Not canceling."
--[[Translation missing --]]
TSM.L["Not Connected"] = "Not Connected"
--[[Translation missing --]]
TSM.L["Not enough items in bags."] = "Not enough items in bags."
--[[Translation missing --]]
TSM.L["NOT OPEN"] = "NOT OPEN"
--[[Translation missing --]]
TSM.L["Not Scanned"] = "Not Scanned"
--[[Translation missing --]]
TSM.L["Nothing to move."] = "Nothing to move."
--[[Translation missing --]]
TSM.L["NPC"] = "NPC"
--[[Translation missing --]]
TSM.L["Number Owned"] = "Number Owned"
--[[Translation missing --]]
TSM.L["of"] = "of"
--[[Translation missing --]]
TSM.L["Offline"] = "Offline"
--[[Translation missing --]]
TSM.L["On Cooldown"] = "On Cooldown"
--[[Translation missing --]]
TSM.L["Only show craftable"] = "Only show craftable"
--[[Translation missing --]]
TSM.L["Only show items with disenchant value above custom price"] = "Only show items with disenchant value above custom price"
--[[Translation missing --]]
TSM.L["OPEN"] = "OPEN"
--[[Translation missing --]]
TSM.L["OPEN ALL MAIL"] = "OPEN ALL MAIL"
--[[Translation missing --]]
TSM.L["Open Mail"] = "Open Mail"
--[[Translation missing --]]
TSM.L["Open Mail Complete Sound"] = "Open Mail Complete Sound"
--[[Translation missing --]]
TSM.L["Open Task List"] = "Open Task List"
--[[Translation missing --]]
TSM.L["Operation"] = "Operation"
TSM.L["Operations"] = "操作"
--[[Translation missing --]]
TSM.L["Other Character"] = "Other Character"
--[[Translation missing --]]
TSM.L["Other Settings"] = "Other Settings"
--[[Translation missing --]]
TSM.L["Other Shopping Searches"] = "Other Shopping Searches"
--[[Translation missing --]]
TSM.L["Override default craft value method?"] = "Override default craft value method?"
--[[Translation missing --]]
TSM.L["Override parent operations"] = "Override parent operations"
--[[Translation missing --]]
TSM.L["Parent Items"] = "Parent Items"
--[[Translation missing --]]
TSM.L["Past 7 Days"] = "Past 7 Days"
--[[Translation missing --]]
TSM.L["Past Day"] = "Past Day"
--[[Translation missing --]]
TSM.L["Past Month"] = "Past Month"
--[[Translation missing --]]
TSM.L["Past Year"] = "Past Year"
--[[Translation missing --]]
TSM.L["Paste string here"] = "Paste string here"
--[[Translation missing --]]
TSM.L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."] = "Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."
--[[Translation missing --]]
TSM.L["Per Item"] = "Per Item"
--[[Translation missing --]]
TSM.L["Per Stack"] = "Per Stack"
--[[Translation missing --]]
TSM.L["Per Unit"] = "Per Unit"
--[[Translation missing --]]
TSM.L["Player Gold"] = "Player Gold"
--[[Translation missing --]]
TSM.L["Player Invite Accept"] = "Player Invite Accept"
--[[Translation missing --]]
TSM.L["Please select a group to export"] = "Please select a group to export"
--[[Translation missing --]]
TSM.L["POST"] = "POST"
--[[Translation missing --]]
TSM.L["Post at Maximum Price"] = "Post at Maximum Price"
--[[Translation missing --]]
TSM.L["Post at Minimum Price"] = "Post at Minimum Price"
--[[Translation missing --]]
TSM.L["Post at Normal Price"] = "Post at Normal Price"
--[[Translation missing --]]
TSM.L["POST CAP TO BAGS"] = "POST CAP TO BAGS"
--[[Translation missing --]]
TSM.L["Post Scan"] = "Post Scan"
--[[Translation missing --]]
TSM.L["POST SELECTED"] = "POST SELECTED"
--[[Translation missing --]]
TSM.L["POSTAGE"] = "POSTAGE"
--[[Translation missing --]]
TSM.L["Postage"] = "Postage"
--[[Translation missing --]]
TSM.L["Posted at whitelisted player's price."] = "Posted at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posted Auctions %s:"] = "Posted Auctions %s:"
--[[Translation missing --]]
TSM.L["Posting"] = "Posting"
--[[Translation missing --]]
TSM.L["Posting %d / %d"] = "Posting %d / %d"
--[[Translation missing --]]
TSM.L["Posting %d stack(s) of %d for %d hours."] = "Posting %d stack(s) of %d for %d hours."
--[[Translation missing --]]
TSM.L["Posting at normal price."] = "Posting at normal price."
--[[Translation missing --]]
TSM.L["Posting at whitelisted player's price."] = "Posting at whitelisted player's price."
--[[Translation missing --]]
TSM.L["Posting at your current price."] = "Posting at your current price."
--[[Translation missing --]]
TSM.L["Posting disabled."] = "Posting disabled."
--[[Translation missing --]]
TSM.L["Posting Settings"] = "Posting Settings"
--[[Translation missing --]]
TSM.L["Posts"] = "Posts"
--[[Translation missing --]]
TSM.L["Potential"] = "Potential"
--[[Translation missing --]]
TSM.L["Price Per Item"] = "Price Per Item"
--[[Translation missing --]]
TSM.L["Price Settings"] = "Price Settings"
--[[Translation missing --]]
TSM.L["PRICE SOURCE"] = "PRICE SOURCE"
--[[Translation missing --]]
TSM.L["Price source with name '%s' already exists."] = "Price source with name '%s' already exists."
--[[Translation missing --]]
TSM.L["Price Variables"] = "Price Variables"
--[[Translation missing --]]
TSM.L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."] = "Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."
--[[Translation missing --]]
TSM.L["PROFESSION"] = "PROFESSION"
--[[Translation missing --]]
TSM.L["Profession Filters"] = "Profession Filters"
--[[Translation missing --]]
TSM.L["Profession Info"] = "Profession Info"
--[[Translation missing --]]
TSM.L["Profession loading..."] = "Profession loading..."
--[[Translation missing --]]
TSM.L["Professions Used In"] = "Professions Used In"
--[[Translation missing --]]
TSM.L["Profile changed to '%s'."] = "Profile changed to '%s'."
TSM.L["Profiles"] = "配置檔"
--[[Translation missing --]]
TSM.L["PROFIT"] = "PROFIT"
--[[Translation missing --]]
TSM.L["Profit"] = "Profit"
--[[Translation missing --]]
TSM.L["Prospect Value"] = "Prospect Value"
--[[Translation missing --]]
TSM.L["PURCHASE DATA"] = "PURCHASE DATA"
--[[Translation missing --]]
TSM.L["Purchased (Min/Avg/Max Price)"] = "Purchased (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Purchased (Total Price)"] = "Purchased (Total Price)"
--[[Translation missing --]]
TSM.L["Purchases"] = "Purchases"
--[[Translation missing --]]
TSM.L["Purchasing Auction"] = "Purchasing Auction"
--[[Translation missing --]]
TSM.L["Qty"] = "Qty"
--[[Translation missing --]]
TSM.L["Quantity Bought:"] = "Quantity Bought:"
--[[Translation missing --]]
TSM.L["Quantity Sold:"] = "Quantity Sold:"
--[[Translation missing --]]
TSM.L["Quantity to move:"] = "Quantity to move:"
--[[Translation missing --]]
TSM.L["Quest Added"] = "Quest Added"
--[[Translation missing --]]
TSM.L["Quest Completed"] = "Quest Completed"
--[[Translation missing --]]
TSM.L["Quest Objectives Complete"] = "Quest Objectives Complete"
--[[Translation missing --]]
TSM.L["QUEUE"] = "QUEUE"
--[[Translation missing --]]
TSM.L["Quick Sell Options"] = "Quick Sell Options"
--[[Translation missing --]]
TSM.L["Quickly mail all excess disenchantable items to a character"] = "Quickly mail all excess disenchantable items to a character"
--[[Translation missing --]]
TSM.L["Quickly mail all excess gold (limited to a certain amount) to a character"] = "Quickly mail all excess gold (limited to a certain amount) to a character"
--[[Translation missing --]]
TSM.L["Raid Warning"] = "Raid Warning"
--[[Translation missing --]]
TSM.L["Read More"] = "Read More"
--[[Translation missing --]]
TSM.L["Ready Check"] = "Ready Check"
--[[Translation missing --]]
TSM.L["Ready to Cancel"] = "Ready to Cancel"
--[[Translation missing --]]
TSM.L["Realm Data Tooltips"] = "Realm Data Tooltips"
--[[Translation missing --]]
TSM.L["Recent Scans"] = "Recent Scans"
--[[Translation missing --]]
TSM.L["Recent Searches"] = "Recent Searches"
--[[Translation missing --]]
TSM.L["Recently Mailed"] = "Recently Mailed"
--[[Translation missing --]]
TSM.L["RECIPIENT"] = "RECIPIENT"
--[[Translation missing --]]
TSM.L["Region Avg Daily Sold"] = "Region Avg Daily Sold"
--[[Translation missing --]]
TSM.L["Region Data Tooltips"] = "Region Data Tooltips"
--[[Translation missing --]]
TSM.L["Region Historical Price"] = "Region Historical Price"
--[[Translation missing --]]
TSM.L["Region Market Value Avg"] = "Region Market Value Avg"
--[[Translation missing --]]
TSM.L["Region Min Buyout Avg"] = "Region Min Buyout Avg"
--[[Translation missing --]]
TSM.L["Region Sale Avg"] = "Region Sale Avg"
--[[Translation missing --]]
TSM.L["Region Sale Rate"] = "Region Sale Rate"
--[[Translation missing --]]
TSM.L["Reload"] = "Reload"
--[[Translation missing --]]
TSM.L["REMOVE %d |4ITEM:ITEMS;"] = "REMOVE %d |4ITEM:ITEMS;"
--[[Translation missing --]]
TSM.L["Removed a total of %s old records."] = "Removed a total of %s old records."
--[[Translation missing --]]
TSM.L["Rename"] = "Rename"
--[[Translation missing --]]
TSM.L["Rename Profile"] = "Rename Profile"
--[[Translation missing --]]
TSM.L["REPAIR"] = "REPAIR"
--[[Translation missing --]]
TSM.L["Repair Bill"] = "Repair Bill"
--[[Translation missing --]]
TSM.L["Replace duplicate operations?"] = "Replace duplicate operations?"
--[[Translation missing --]]
TSM.L["REPLY"] = "REPLY"
--[[Translation missing --]]
TSM.L["REPORT SPAM"] = "REPORT SPAM"
--[[Translation missing --]]
TSM.L["Repost Higher Threshold"] = "Repost Higher Threshold"
--[[Translation missing --]]
TSM.L["Required Level"] = "Required Level"
--[[Translation missing --]]
TSM.L["REQUIRED LEVEL RANGE"] = "REQUIRED LEVEL RANGE"
--[[Translation missing --]]
TSM.L["Requires TSM Desktop Application"] = "Requires TSM Desktop Application"
--[[Translation missing --]]
TSM.L["Resale"] = "Resale"
--[[Translation missing --]]
TSM.L["RESCAN"] = "RESCAN"
--[[Translation missing --]]
TSM.L["RESET"] = "RESET"
--[[Translation missing --]]
TSM.L["Reset All"] = "Reset All"
--[[Translation missing --]]
TSM.L["Reset Filters"] = "Reset Filters"
--[[Translation missing --]]
TSM.L["Reset Profile Confirmation"] = "Reset Profile Confirmation"
--[[Translation missing --]]
TSM.L["RESTART"] = "RESTART"
--[[Translation missing --]]
TSM.L["Restart Delay (minutes)"] = "Restart Delay (minutes)"
--[[Translation missing --]]
TSM.L["RESTOCK BAGS"] = "RESTOCK BAGS"
--[[Translation missing --]]
TSM.L["Restock help for %s:"] = "Restock help for %s:"
--[[Translation missing --]]
TSM.L["Restock Quantity Settings"] = "Restock Quantity Settings"
--[[Translation missing --]]
TSM.L["Restock quantity:"] = "Restock quantity:"
--[[Translation missing --]]
TSM.L["RESTOCK SELECTED GROUPS"] = "RESTOCK SELECTED GROUPS"
--[[Translation missing --]]
TSM.L["Restock Settings"] = "Restock Settings"
--[[Translation missing --]]
TSM.L["Restock target to max quantity?"] = "Restock target to max quantity?"
--[[Translation missing --]]
TSM.L["Restocking to %d."] = "Restocking to %d."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with a min profit."] = "Restocking to a max of %d (min of %d) with a min profit."
--[[Translation missing --]]
TSM.L["Restocking to a max of %d (min of %d) with no min profit."] = "Restocking to a max of %d (min of %d) with no min profit."
--[[Translation missing --]]
TSM.L["RESTORE BAGS"] = "RESTORE BAGS"
--[[Translation missing --]]
TSM.L["Resume Scan"] = "Resume Scan"
--[[Translation missing --]]
TSM.L["Retrying %d auction(s) which failed."] = "Retrying %d auction(s) which failed."
--[[Translation missing --]]
TSM.L["Revenue"] = "Revenue"
--[[Translation missing --]]
TSM.L["Round normal price"] = "Round normal price"
--[[Translation missing --]]
TSM.L["RUN ADVANCED ITEM SEARCH"] = "RUN ADVANCED ITEM SEARCH"
--[[Translation missing --]]
TSM.L["Run Bid Sniper"] = "Run Bid Sniper"
--[[Translation missing --]]
TSM.L["Run Buyout Sniper"] = "Run Buyout Sniper"
--[[Translation missing --]]
TSM.L["RUN CANCEL SCAN"] = "RUN CANCEL SCAN"
--[[Translation missing --]]
TSM.L["RUN POST SCAN"] = "RUN POST SCAN"
--[[Translation missing --]]
TSM.L["RUN SHOPPING SCAN"] = "RUN SHOPPING SCAN"
--[[Translation missing --]]
TSM.L["Running Sniper Scan"] = "Running Sniper Scan"
--[[Translation missing --]]
TSM.L["Sale"] = "Sale"
--[[Translation missing --]]
TSM.L["SALE DATA"] = "SALE DATA"
--[[Translation missing --]]
TSM.L["Sale Price"] = "Sale Price"
--[[Translation missing --]]
TSM.L["Sale Rate"] = "Sale Rate"
--[[Translation missing --]]
TSM.L["Sales"] = "Sales"
--[[Translation missing --]]
TSM.L["SALES"] = "SALES"
--[[Translation missing --]]
TSM.L["Sales Summary"] = "Sales Summary"
--[[Translation missing --]]
TSM.L["SCAN ALL"] = "SCAN ALL"
--[[Translation missing --]]
TSM.L["Scan Complete Sound"] = "Scan Complete Sound"
--[[Translation missing --]]
TSM.L["Scan Paused"] = "Scan Paused"
--[[Translation missing --]]
TSM.L["SCANNING"] = "SCANNING"
--[[Translation missing --]]
TSM.L["Scanning %d / %d (Page %d / %d)"] = "Scanning %d / %d (Page %d / %d)"
--[[Translation missing --]]
TSM.L["Scroll wheel direction:"] = "Scroll wheel direction:"
--[[Translation missing --]]
TSM.L["Search"] = "Search"
--[[Translation missing --]]
TSM.L["Search Bags"] = "Search Bags"
--[[Translation missing --]]
TSM.L["Search Groups"] = "Search Groups"
--[[Translation missing --]]
TSM.L["Search Inbox"] = "Search Inbox"
--[[Translation missing --]]
TSM.L["Search Operations"] = "Search Operations"
--[[Translation missing --]]
TSM.L["Search Patterns"] = "Search Patterns"
--[[Translation missing --]]
TSM.L["Search Usable Items Only?"] = "Search Usable Items Only?"
--[[Translation missing --]]
TSM.L["Search Vendor"] = "Search Vendor"
--[[Translation missing --]]
TSM.L["Select a Source"] = "Select a Source"
--[[Translation missing --]]
TSM.L["Select Action"] = "Select Action"
TSM.L["Select All Groups"] = "選擇所有分組"
--[[Translation missing --]]
TSM.L["Select All Items"] = "Select All Items"
--[[Translation missing --]]
TSM.L["Select Auction to Cancel"] = "Select Auction to Cancel"
--[[Translation missing --]]
TSM.L["Select crafter"] = "Select crafter"
--[[Translation missing --]]
TSM.L["Select custom price sources to include in item tooltips"] = "Select custom price sources to include in item tooltips"
TSM.L["Select Duration"] = "選擇時間"
--[[Translation missing --]]
TSM.L["Select Items to Add"] = "Select Items to Add"
--[[Translation missing --]]
TSM.L["Select Items to Remove"] = "Select Items to Remove"
--[[Translation missing --]]
TSM.L["Select Operation"] = "Select Operation"
--[[Translation missing --]]
TSM.L["Select professions"] = "Select professions"
--[[Translation missing --]]
TSM.L["Select which accounting information to display in item tooltips."] = "Select which accounting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which auctioning information to display in item tooltips."] = "Select which auctioning information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which crafting information to display in item tooltips."] = "Select which crafting information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which destroying information to display in item tooltips."] = "Select which destroying information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Select which shopping information to display in item tooltips."] = "Select which shopping information to display in item tooltips."
--[[Translation missing --]]
TSM.L["Selected Groups"] = "Selected Groups"
--[[Translation missing --]]
TSM.L["Selected Operations"] = "Selected Operations"
--[[Translation missing --]]
TSM.L["Sell"] = "Sell"
--[[Translation missing --]]
TSM.L["SELL ALL"] = "SELL ALL"
--[[Translation missing --]]
TSM.L["SELL BOES"] = "SELL BOES"
--[[Translation missing --]]
TSM.L["SELL GROUPS"] = "SELL GROUPS"
--[[Translation missing --]]
TSM.L["Sell Options"] = "Sell Options"
--[[Translation missing --]]
TSM.L["Sell soulbound items?"] = "Sell soulbound items?"
TSM.L["Sell to Vendor"] = "賣給商人"
--[[Translation missing --]]
TSM.L["SELL TRASH"] = "SELL TRASH"
--[[Translation missing --]]
TSM.L["Seller"] = "Seller"
--[[Translation missing --]]
TSM.L["Selling soulbound items."] = "Selling soulbound items."
--[[Translation missing --]]
TSM.L["Send"] = "Send"
--[[Translation missing --]]
TSM.L["SEND DISENCHANTABLES"] = "SEND DISENCHANTABLES"
--[[Translation missing --]]
TSM.L["Send Excess Gold to Banker"] = "Send Excess Gold to Banker"
--[[Translation missing --]]
TSM.L["SEND GOLD"] = "SEND GOLD"
--[[Translation missing --]]
TSM.L["Send grouped items individually"] = "Send grouped items individually"
--[[Translation missing --]]
TSM.L["SEND MAIL"] = "SEND MAIL"
--[[Translation missing --]]
TSM.L["Send Money"] = "Send Money"
--[[Translation missing --]]
TSM.L["Send Profile"] = "Send Profile"
--[[Translation missing --]]
TSM.L["SENDING"] = "SENDING"
--[[Translation missing --]]
TSM.L["Sending %s individually to %s"] = "Sending %s individually to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s"] = "Sending %s to %s"
--[[Translation missing --]]
TSM.L["Sending %s to %s with a COD of %s"] = "Sending %s to %s with a COD of %s"
--[[Translation missing --]]
TSM.L["Sending Settings"] = "Sending Settings"
--[[Translation missing --]]
TSM.L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"] = "Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"
--[[Translation missing --]]
TSM.L["SENDING..."] = "SENDING..."
--[[Translation missing --]]
TSM.L["Set auction duration to:"] = "Set auction duration to:"
--[[Translation missing --]]
TSM.L["Set bid as percentage of buyout:"] = "Set bid as percentage of buyout:"
--[[Translation missing --]]
TSM.L["Set keep in bags quantity?"] = "Set keep in bags quantity?"
--[[Translation missing --]]
TSM.L["Set keep in bank quantity?"] = "Set keep in bank quantity?"
--[[Translation missing --]]
TSM.L["Set Maximum Price:"] = "Set Maximum Price:"
--[[Translation missing --]]
TSM.L["Set maximum quantity?"] = "Set maximum quantity?"
--[[Translation missing --]]
TSM.L["Set Minimum Price:"] = "Set Minimum Price:"
--[[Translation missing --]]
TSM.L["Set minimum profit?"] = "Set minimum profit?"
--[[Translation missing --]]
TSM.L["Set move quantity?"] = "Set move quantity?"
--[[Translation missing --]]
TSM.L["Set Normal Price:"] = "Set Normal Price:"
--[[Translation missing --]]
TSM.L["Set post cap to:"] = "Set post cap to:"
--[[Translation missing --]]
TSM.L["Set posted stack size to:"] = "Set posted stack size to:"
--[[Translation missing --]]
TSM.L["Set stack size for restock?"] = "Set stack size for restock?"
--[[Translation missing --]]
TSM.L["Set stack size?"] = "Set stack size?"
--[[Translation missing --]]
TSM.L["Setup"] = "Setup"
--[[Translation missing --]]
TSM.L["SETUP ACCOUNT SYNC"] = "SETUP ACCOUNT SYNC"
TSM.L["Shards"] = "碎片"
--[[Translation missing --]]
TSM.L["Shopping"] = "Shopping"
--[[Translation missing --]]
TSM.L["Shopping 'BUYOUT' Button"] = "Shopping 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Shopping for auctions including those above the max price."] = "Shopping for auctions including those above the max price."
--[[Translation missing --]]
TSM.L["Shopping for auctions with a max price set."] = "Shopping for auctions with a max price set."
--[[Translation missing --]]
TSM.L["Shopping for even stacks including those above the max price"] = "Shopping for even stacks including those above the max price"
--[[Translation missing --]]
TSM.L["Shopping for even stacks with a max price set."] = "Shopping for even stacks with a max price set."
--[[Translation missing --]]
TSM.L["Shopping Tooltips"] = "Shopping Tooltips"
--[[Translation missing --]]
TSM.L["SHORTFALL TO BAGS"] = "SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Show auctions above max price?"] = "Show auctions above max price?"
--[[Translation missing --]]
TSM.L["Show confirmation alert if buyout is above the alert price"] = "Show confirmation alert if buyout is above the alert price"
--[[Translation missing --]]
TSM.L["Show Description"] = "Show Description"
--[[Translation missing --]]
TSM.L["Show Destroying frame automatically"] = "Show Destroying frame automatically"
--[[Translation missing --]]
TSM.L["Show material cost"] = "Show material cost"
--[[Translation missing --]]
TSM.L["Show on Modifier"] = "Show on Modifier"
--[[Translation missing --]]
TSM.L["Showing %d Mail"] = "Showing %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mail"] = "Showing %d of %d Mail"
--[[Translation missing --]]
TSM.L["Showing %d of %d Mails"] = "Showing %d of %d Mails"
--[[Translation missing --]]
TSM.L["Showing all %d Mails"] = "Showing all %d Mails"
--[[Translation missing --]]
TSM.L["Simple"] = "Simple"
--[[Translation missing --]]
TSM.L["SKIP"] = "SKIP"
--[[Translation missing --]]
TSM.L["Skip Import confirmation?"] = "Skip Import confirmation?"
--[[Translation missing --]]
TSM.L["Skipped: No assigned operation"] = "Skipped: No assigned operation"
TSM.L["Slash Commands:"] = "斜線命令列表："
--[[Translation missing --]]
TSM.L["Sniper"] = "Sniper"
--[[Translation missing --]]
TSM.L["Sniper 'BUYOUT' Button"] = "Sniper 'BUYOUT' Button"
--[[Translation missing --]]
TSM.L["Sniper Options"] = "Sniper Options"
--[[Translation missing --]]
TSM.L["Sniper Settings"] = "Sniper Settings"
--[[Translation missing --]]
TSM.L["Sniping items below a max price"] = "Sniping items below a max price"
--[[Translation missing --]]
TSM.L["Sold"] = "Sold"
--[[Translation missing --]]
TSM.L["Sold %d of %s to %s for %s"] = "Sold %d of %s to %s for %s"
--[[Translation missing --]]
TSM.L["Sold %s worth of items."] = "Sold %s worth of items."
--[[Translation missing --]]
TSM.L["Sold (Min/Avg/Max Price)"] = "Sold (Min/Avg/Max Price)"
--[[Translation missing --]]
TSM.L["Sold (Total Price)"] = "Sold (Total Price)"
--[[Translation missing --]]
TSM.L["Sold [%s]x%d for %s to %s"] = "Sold [%s]x%d for %s to %s"
--[[Translation missing --]]
TSM.L["Sold Auctions %s:"] = "Sold Auctions %s:"
--[[Translation missing --]]
TSM.L["Source"] = "Source"
--[[Translation missing --]]
TSM.L["SOURCE %d"] = "SOURCE %d"
--[[Translation missing --]]
TSM.L["SOURCES"] = "SOURCES"
TSM.L["Sources"] = "來源"
--[[Translation missing --]]
TSM.L["Sources to include for restock:"] = "Sources to include for restock:"
--[[Translation missing --]]
TSM.L["Stack"] = "Stack"
--[[Translation missing --]]
TSM.L["Stack / Quantity"] = "Stack / Quantity"
--[[Translation missing --]]
TSM.L["Stack size multiple:"] = "Stack size multiple:"
--[[Translation missing --]]
TSM.L["Start either a 'Buyout' or 'Bid' sniper using the buttons above."] = "Start either a 'Buyout' or 'Bid' sniper using the buttons above."
--[[Translation missing --]]
TSM.L["Starting Scan..."] = "Starting Scan..."
--[[Translation missing --]]
TSM.L["STOP"] = "STOP"
--[[Translation missing --]]
TSM.L["Store operations globally"] = "Store operations globally"
--[[Translation missing --]]
TSM.L["Subject"] = "Subject"
--[[Translation missing --]]
TSM.L["SUBJECT"] = "SUBJECT"
--[[Translation missing --]]
TSM.L["Successfully sent your '%s' profile to %s!"] = "Successfully sent your '%s' profile to %s!"
--[[Translation missing --]]
TSM.L["Switch to %s"] = "Switch to %s"
TSM.L["Switch to WoW UI"] = "轉到魔獸界面"
--[[Translation missing --]]
TSM.L["Sync Setup Error: The specified player on the other account is not currently online."] = "Sync Setup Error: The specified player on the other account is not currently online."
--[[Translation missing --]]
TSM.L["Sync Setup Error: This character is already part of a known account."] = "Sync Setup Error: This character is already part of a known account."
--[[Translation missing --]]
TSM.L["Sync Setup Error: You entered the name of the current character and not the character on the other account."] = "Sync Setup Error: You entered the name of the current character and not the character on the other account."
--[[Translation missing --]]
TSM.L["Sync Status"] = "Sync Status"
--[[Translation missing --]]
TSM.L["TAKE ALL"] = "TAKE ALL"
--[[Translation missing --]]
TSM.L["Take Attachments"] = "Take Attachments"
--[[Translation missing --]]
TSM.L["Target Character"] = "Target Character"
--[[Translation missing --]]
TSM.L["TARGET SHORTFALL TO BAGS"] = "TARGET SHORTFALL TO BAGS"
--[[Translation missing --]]
TSM.L["Tasks Added to Task List"] = "Tasks Added to Task List"
--[[Translation missing --]]
TSM.L["Text (%s)"] = "Text (%s)"
--[[Translation missing --]]
TSM.L["The canlearn filter was ignored because the CanIMogIt addon was not found."] = "The canlearn filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["The 'Craft Value Method' (%s) did not return a value for this item."] = "The 'Craft Value Method' (%s) did not return a value for this item."
--[[Translation missing --]]
TSM.L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."] = "The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."
--[[Translation missing --]]
TSM.L["The min profit (%s) did not evalulate to a valid value for this item."] = "The min profit (%s) did not evalulate to a valid value for this item."
TSM.L["The name can ONLY contain letters. No spaces, numbers, or special characters."] = "名稱只能包括字母！不能有空格、數字或特殊字符。"
--[[Translation missing --]]
TSM.L["The number which would be queued (%d) is less than the min restock quantity (%d)."] = "The number which would be queued (%d) is less than the min restock quantity (%d)."
--[[Translation missing --]]
TSM.L["The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."] = "The operation applied to this item is invalid! Min restock of %d is higher than max restock of %d."
--[[Translation missing --]]
TSM.L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
--[[Translation missing --]]
TSM.L["The profit of this item (%s) is below the min profit (%s)."] = "The profit of this item (%s) is below the min profit (%s)."
--[[Translation missing --]]
TSM.L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."] = "The seller name of the lowest auction for %s was not given by the server. Skipping this item."
--[[Translation missing --]]
TSM.L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."] = "The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."
--[[Translation missing --]]
TSM.L["The unlearned filter was ignored because the CanIMogIt addon was not found."] = "The unlearned filter was ignored because the CanIMogIt addon was not found."
--[[Translation missing --]]
TSM.L["There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"] = "There is a crafting cost and crafted item value, but TSM wasn't able to calculate a profit. This shouldn't happen!"
--[[Translation missing --]]
TSM.L["There is no Crafting operation applied to this item's TSM group (%s)."] = "There is no Crafting operation applied to this item's TSM group (%s)."
--[[Translation missing --]]
TSM.L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."] = "This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."
--[[Translation missing --]]
TSM.L["This item does not have a crafting cost. Check that all of its mats have mat prices."] = "This item does not have a crafting cost. Check that all of its mats have mat prices."
--[[Translation missing --]]
TSM.L["This item is not in a TSM group."] = "This item is not in a TSM group."
--[[Translation missing --]]
TSM.L["This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."] = "This item will be added to the queue when you restock its group. If this isn't happening, make a post on the TSM forums with a screenshot of the item's tooltip, operation settings, and your general Crafting options."
--[[Translation missing --]]
TSM.L["This looks like an exported operation and not a custom price."] = "This looks like an exported operation and not a custom price."
--[[Translation missing --]]
TSM.L["This will copy the settings from '%s' into your currently-active one."] = "This will copy the settings from '%s' into your currently-active one."
--[[Translation missing --]]
TSM.L["This will permanently delete the '%s' profile."] = "This will permanently delete the '%s' profile."
--[[Translation missing --]]
TSM.L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."] = "This will reset all groups and operations (if not stored globally) to be wiped from this profile."
--[[Translation missing --]]
TSM.L["Time"] = "Time"
--[[Translation missing --]]
TSM.L["Time Format"] = "Time Format"
--[[Translation missing --]]
TSM.L["Time Frame"] = "Time Frame"
--[[Translation missing --]]
TSM.L["TIME FRAME"] = "TIME FRAME"
--[[Translation missing --]]
TSM.L["TINKER"] = "TINKER"
--[[Translation missing --]]
TSM.L["Tooltip Price Format"] = "Tooltip Price Format"
--[[Translation missing --]]
TSM.L["Tooltip Settings"] = "Tooltip Settings"
--[[Translation missing --]]
TSM.L["Top Buyers:"] = "Top Buyers:"
--[[Translation missing --]]
TSM.L["Top Item:"] = "Top Item:"
--[[Translation missing --]]
TSM.L["Top Sellers:"] = "Top Sellers:"
--[[Translation missing --]]
TSM.L["Total"] = "Total"
--[[Translation missing --]]
TSM.L["Total Gold"] = "Total Gold"
--[[Translation missing --]]
TSM.L["Total Gold Collected: %s"] = "Total Gold Collected: %s"
--[[Translation missing --]]
TSM.L["Total Gold Earned:"] = "Total Gold Earned:"
--[[Translation missing --]]
TSM.L["Total Gold Spent:"] = "Total Gold Spent:"
--[[Translation missing --]]
TSM.L["Total Price"] = "Total Price"
--[[Translation missing --]]
TSM.L["Total Profit:"] = "Total Profit:"
--[[Translation missing --]]
TSM.L["Total Value"] = "Total Value"
--[[Translation missing --]]
TSM.L["Total Value of All Items"] = "Total Value of All Items"
--[[Translation missing --]]
TSM.L["Track Sales / Purchases via trade"] = "Track Sales / Purchases via trade"
--[[Translation missing --]]
TSM.L["TradeSkillMaster Info"] = "TradeSkillMaster Info"
--[[Translation missing --]]
TSM.L["Transform Value"] = "Transform Value"
--[[Translation missing --]]
TSM.L["TSM Banking"] = "TSM Banking"
--[[Translation missing --]]
TSM.L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."] = "TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."
--[[Translation missing --]]
TSM.L["TSM Crafting"] = "TSM Crafting"
--[[Translation missing --]]
TSM.L["TSM Destroying"] = "TSM Destroying"
--[[Translation missing --]]
TSM.L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."] = "TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."
--[[Translation missing --]]
TSM.L["TSM failed to scan some auctions. Please rerun the scan."] = "TSM failed to scan some auctions. Please rerun the scan."
--[[Translation missing --]]
TSM.L["TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."] = "TSM is currently rebuilding its item cache which may cause FPS drops and result in TSM not being fully functional until this process is complete. This is normal and typically takes less than a minute."
--[[Translation missing --]]
TSM.L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."] = "TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."
--[[Translation missing --]]
TSM.L["TSM Mailing"] = "TSM Mailing"
--[[Translation missing --]]
TSM.L["TSM TASK LIST"] = "TSM TASK LIST"
--[[Translation missing --]]
TSM.L["TSM Vendoring"] = "TSM Vendoring"
TSM.L["TSM Version Info:"] = "TSM版本資訊:"
--[[Translation missing --]]
TSM.L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"] = "TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"
--[[Translation missing --]]
TSM.L["TSM4"] = "TSM4"
--[[Translation missing --]]
TSM.L["TUJ 14-Day Price"] = "TUJ 14-Day Price"
--[[Translation missing --]]
TSM.L["TUJ 3-Day Price"] = "TUJ 3-Day Price"
--[[Translation missing --]]
TSM.L["TUJ Global Mean"] = "TUJ Global Mean"
--[[Translation missing --]]
TSM.L["TUJ Global Median"] = "TUJ Global Median"
--[[Translation missing --]]
TSM.L["Twitter Integration"] = "Twitter Integration"
--[[Translation missing --]]
TSM.L["Twitter Integration Not Enabled"] = "Twitter Integration Not Enabled"
--[[Translation missing --]]
TSM.L["Type"] = "Type"
--[[Translation missing --]]
TSM.L["Type Something"] = "Type Something"
--[[Translation missing --]]
TSM.L["Unable to process import because the target group (%s) no longer exists. Please try again."] = "Unable to process import because the target group (%s) no longer exists. Please try again."
TSM.L["Unbalanced parentheses."] = "缺少括弧。"
--[[Translation missing --]]
TSM.L["Undercut amount:"] = "Undercut amount:"
--[[Translation missing --]]
TSM.L["Undercut by whitelisted player."] = "Undercut by whitelisted player."
--[[Translation missing --]]
TSM.L["Undercutting blacklisted player."] = "Undercutting blacklisted player."
--[[Translation missing --]]
TSM.L["Undercutting competition."] = "Undercutting competition."
--[[Translation missing --]]
TSM.L["Ungrouped Items"] = "Ungrouped Items"
--[[Translation missing --]]
TSM.L["Unknown Item"] = "Unknown Item"
--[[Translation missing --]]
TSM.L["Unwrap Gift"] = "Unwrap Gift"
--[[Translation missing --]]
TSM.L["Up"] = "Up"
--[[Translation missing --]]
TSM.L["Up to date"] = "Up to date"
--[[Translation missing --]]
TSM.L["UPDATE EXISTING MACRO"] = "UPDATE EXISTING MACRO"
--[[Translation missing --]]
TSM.L["Updating"] = "Updating"
TSM.L["Usage: /tsm price <ItemLink> <Price String>"] = "用法：/tsm price <ItemLink(物品鏈接)> <Price String(價格)>"
--[[Translation missing --]]
TSM.L["Use smart average for purchase price"] = "Use smart average for purchase price"
--[[Translation missing --]]
TSM.L["Use the field below to search the auction house by filter"] = "Use the field below to search the auction house by filter"
--[[Translation missing --]]
TSM.L["Use the list to the left to select groups, & operations you'd like to create export strings for."] = "Use the list to the left to select groups, & operations you'd like to create export strings for."
--[[Translation missing --]]
TSM.L["VALUE PRICE SOURCE"] = "VALUE PRICE SOURCE"
--[[Translation missing --]]
TSM.L["ValueSources"] = "ValueSources"
--[[Translation missing --]]
TSM.L["Variable Name"] = "Variable Name"
--[[Translation missing --]]
TSM.L["Vendor"] = "Vendor"
--[[Translation missing --]]
TSM.L["Vendor Buy Price"] = "Vendor Buy Price"
--[[Translation missing --]]
TSM.L["Vendor Search"] = "Vendor Search"
--[[Translation missing --]]
TSM.L["VENDOR SEARCH"] = "VENDOR SEARCH"
--[[Translation missing --]]
TSM.L["Vendor Sell"] = "Vendor Sell"
--[[Translation missing --]]
TSM.L["Vendor Sell Price"] = "Vendor Sell Price"
--[[Translation missing --]]
TSM.L["Vendoring 'SELL ALL' Button"] = "Vendoring 'SELL ALL' Button"
--[[Translation missing --]]
TSM.L["View ignored items in the Destroying options."] = "View ignored items in the Destroying options."
--[[Translation missing --]]
TSM.L["Warehousing"] = "Warehousing"
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group."] = "Warehousing will move a max of %d of each item in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."] = "Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group."] = "Warehousing will move all of the items in this group."
--[[Translation missing --]]
TSM.L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."] = "Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."
--[[Translation missing --]]
TSM.L["WARNING: The macro was too long, so was truncated to fit by WoW."] = "WARNING: The macro was too long, so was truncated to fit by WoW."
--[[Translation missing --]]
TSM.L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."] = "WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."
--[[Translation missing --]]
TSM.L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."] = "Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."
--[[Translation missing --]]
TSM.L["When above maximum:"] = "When above maximum:"
--[[Translation missing --]]
TSM.L["When below minimum:"] = "When below minimum:"
--[[Translation missing --]]
TSM.L["Whitelist"] = "Whitelist"
--[[Translation missing --]]
TSM.L["Whitelisted Players"] = "Whitelisted Players"
--[[Translation missing --]]
TSM.L["You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"] = "You already have at least your max restock quantity of this item. You have %d and the max restock quantity is %d"
--[[Translation missing --]]
TSM.L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."] = "You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."
TSM.L["You cannot use %s as part of this custom price."] = "你不能使用%s作為自定義價格的一部份。"
--[[Translation missing --]]
TSM.L["You cannot use %s within convert() as part of this custom price."] = "You cannot use %s within convert() as part of this custom price."
--[[Translation missing --]]
TSM.L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
--[[Translation missing --]]
TSM.L["You don't know how to craft this item."] = "You don't know how to craft this item."
--[[Translation missing --]]
TSM.L["You must reload your UI for these settings to take effect. Reload now?"] = "You must reload your UI for these settings to take effect. Reload now?"
--[[Translation missing --]]
TSM.L["You won an auction for %sx%d for %s"] = "You won an auction for %sx%d for %s"
--[[Translation missing --]]
TSM.L["Your auction has not been undercut."] = "Your auction has not been undercut."
--[[Translation missing --]]
TSM.L["Your auction of %s expired"] = "Your auction of %s expired"
--[[Translation missing --]]
TSM.L["Your auction of %s has sold for %s!"] = "Your auction of %s has sold for %s!"
--[[Translation missing --]]
TSM.L["Your Buyout"] = "Your Buyout"
--[[Translation missing --]]
TSM.L["Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"] = "Your craft value method for '%s' was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your default craft value method was invalid so it has been returned to the default. Details: %s"] = "Your default craft value method was invalid so it has been returned to the default. Details: %s"
--[[Translation missing --]]
TSM.L["Your task list is currently empty."] = "Your task list is currently empty."
--[[Translation missing --]]
TSM.L["You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."] = "You've been phased which has caused the AH to stop working due to a bug on Blizzard's end. Please close and reopen the AH and restart Sniper."
--[[Translation missing --]]
TSM.L["You've been undercut."] = "You've been undercut."
	else
		error("Unknown locale: "..tostring(locale))
	end

	--local HAS_STRINGS = next(TSM.L) and true or false
	setmetatable(TSM.L, {
		__index = function(t, k)
			--assert(not HAS_STRINGS)
			local v = tostring(k)
			rawset(t, k, v)
			return v
		end,
		__newindex = function(t, k, v)
			error("Cannot write to the locale table")
		end,
	})
end
