
local tonumber = _G.tonumber
local Wishlist = _G.MogIt.wishlist


local function HighlightQuestRewards()
	for i=1, 10 do
		ActionButton_HideOverlayGlow(_G["QuestInfoItem" .. i])
	end

	local number_of_choices

	if QuestInfoFrame.questLog then
		number_of_choices = GetNumQuestLogChoices()
	else
		number_of_choices = GetNumQuestChoices()
	end

	for i=1, number_of_choices do
		local link

		if QuestInfoFrame.questLog then
			link = GetQuestLogItemLink("choice", i)
		else
			link = GetQuestItemLink("choice", i)
		end

		if link then
			local itemID = tonumber(link:match("item:(%d+)"))

			if Wishlist:IsItemInWishlist(itemID) then
				ActionButton_ShowOverlayGlow(_G["QuestInfoItem" .. i])
			end
		end
	end
end


local function HighlightMerchantGoods()
	for i=1, MERCHANT_ITEMS_PER_PAGE do
		ActionButton_HideOverlayGlow( _G["MerchantItem" .. i .. "ItemButton"] )
	end

	ActionButton_HideOverlayGlow( _G["MerchantBuyBackItemItemButton"] )

	if MerchantFrame:IsShown() then
		if MerchantFrame.selectedTab == 1 then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = ( ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i )
				local itemLink = GetMerchantItemLink(index)

				if itemLink then
					local itemID = tonumber(itemLink:match("item:(%d+)"))

					if Wishlist:IsItemInWishlist(itemID) then
						ActionButton_ShowOverlayGlow( _G["MerchantItem" .. i .. "ItemButton"] )
					end
				end
			end

			local buyBackLink = GetBuybackItemLink(GetNumBuybackItems())

			if itemLink then
				local itemID = tonumber(itemLink:match("item:(%d+)"))

				if Wishlist:IsItemInWishlist(itemID) then
					ActionButton_ShowOverlayGlow( _G["MerchantBuyBackItemItemButton"] )
				end
			end
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				local itemLink = GetBuybackItemLink(i)

				if itemLink then
					local itemID = tonumber(itemLink:match("item:(%d+)"))

					if Wishlist:IsItemInWishlist(itemID) then
						ActionButton_ShowOverlayGlow( _G["MerchantItem" .. i .. "ItemButton"] )
					end
				end
			end
		end
	end
end


hooksecurefunc("QuestInfo_Display", HighlightQuestRewards)
hooksecurefunc('MerchantFrame_Update', HighlightMerchantGoods)
