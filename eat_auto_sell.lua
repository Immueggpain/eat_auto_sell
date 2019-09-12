local lastUpdate = 0

local function moneyToString(totalMoney)
	local gold = floor(abs(totalMoney / 10000))
	local silver = floor(abs(mod(totalMoney / 100, 100)))
	local copper = floor(abs(mod(totalMoney, 100)))
	-- wow has shorthand references to the Lua string library
	return format("%dg %ds %dc", gold, silver, copper)
end

local function sell_junk()
	local totalMoney = 0
	for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		--if no container, slots is 0
		for slot = 1, slots do
			local item_id = GetContainerItemID(container, slot)
			if item_id ~= nil then
				local texture, count, locked, quality, readable, lootable, link, isFiltered = GetContainerItemInfo(container, slot)
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item_id)
				
				--is junk
				if quality == 0 then
					UseContainerItem(container, slot)
					totalMoney = totalMoney + itemSellPrice * count
					--print(itemName, itemSellPrice * count)
				end
			end
		end
	end
	
	--print money gain
	if totalMoney > 0 then
		print('selling junk gains', moneyToString(totalMoney))
	end
	
	--repair
	if CanMerchantRepair() then
		local cost = GetRepairAllCost()
		if cost > 0 then
			RepairAllItems()
			print('repair costs', moneyToString(cost))
		end
	end
end

local function destroy_items()
	for container = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		--if no container, slots is 0
		for slot = 1, slots do
			local item_id = GetContainerItemID(container, slot)
			if item_id ~= nil then
				local texture, count, locked, quality, readable, lootable, link, isFiltered = GetContainerItemInfo(container, slot)
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item_id)
				
				--need destroy
				if itemName == 'Mark of Aquaos' then
					--PickupContainerItem(bagID, slot)
					PickupItem(itemName)
					DeleteCursorItem()
					print(itemName, 'destroyed')
				end
			end
		end
	end
end

--local e,m,n,f=EnumerateFrames,MouseIsOver;ChatFrame1:AddMessage("The mouse is over the following frames:");f=e();while f do n=f:GetName();if n and f:IsVisible()and m(f) then ChatFrame1:AddMessage("   - "..n) end f=e(f) end

local function onUpdate(self, elapsed)
	local now = time();
	if now - lastUpdate >= 1 then
		lastUpdate = time();
		
		
	end
end

local function onEvent(self, event, ...)
	if event == "MERCHANT_SHOW" then
		sell_junk()
	elseif event == "BAG_UPDATE" then
		print("BAG_UPDATE", GetTime())
	elseif event == "BAG_UPDATE_DELAYED" then
		print("BAG_UPDATE_DELAYED", GetTime())
	elseif event == "ITEM_PUSH" then
		print("ITEM_PUSH", GetTime())
		--destroy_items()
	end
end

--create a frame for receiving events
CreateFrame("FRAME", "eat_auto_sell_frame");
eat_auto_sell_frame:RegisterEvent("MERCHANT_SHOW");
--cas_frame:RegisterEvent("BAG_UPDATE");
--cas_frame:RegisterEvent("BAG_UPDATE_DELAYED");
--cas_frame:RegisterEvent("ITEM_PUSH");
eat_auto_sell_frame:SetScript("OnEvent", onEvent);