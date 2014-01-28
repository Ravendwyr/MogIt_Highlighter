
local tonumber = _G.tonumber
local Wishlist = _G.MogIt.wishlist


local function MakeItShine(itemLink, frame)
	if itemLink then
		local itemID = tonumber(itemLink:match("item:(%d+)"))

		if Wishlist:IsItemInWishlist(itemID) then
			ActionButton_ShowOverlayGlow(frame)
		end
	end
end


local function HighlightQuestRewards()
	for i=1, 10 do
		ActionButton_HideOverlayGlow( _G["QuestInfoItem" .. i] )
	end

	local number_of_choices

	if QuestInfoFrame.questLog then
		number_of_choices = GetNumQuestLogChoices()
	else
		number_of_choices = GetNumQuestChoices()
	end

	for i=1, number_of_choices do
		local itemLink

		if QuestInfoFrame.questLog then
			itemLink = GetQuestLogItemLink("choice", i)
		else
			itemLink = GetQuestItemLink("choice", i)
		end

		MakeItShine(itemLink, _G["QuestInfoItem" .. i])
	end
end


local function HighlightMerchantGoods()
	-- code in this function largely stolen from oGlow
	for i=1, MERCHANT_ITEMS_PER_PAGE do
		ActionButton_HideOverlayGlow( _G["MerchantItem" .. i .. "ItemButton"] )
	end

	ActionButton_HideOverlayGlow( _G["MerchantBuyBackItemItemButton"] )

	if MerchantFrame:IsShown() then
		if MerchantFrame.selectedTab == 1 then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = ( ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i )

				MakeItShine(GetMerchantItemLink(index), _G["MerchantItem" .. i .. "ItemButton"])
			end

			MakeItShine(GetBuybackItemLink(GetNumBuybackItems()), _G["MerchantBuyBackItemItemButton"])
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				MakeItShine(GetBuybackItemLink(i), _G["MerchantItem" .. i .. "ItemButton"])
			end
		end
	end
end


hooksecurefunc("QuestInfo_Display", HighlightQuestRewards)
hooksecurefunc('MerchantFrame_Update', HighlightMerchantGoods)
