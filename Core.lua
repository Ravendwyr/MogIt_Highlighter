
--<< ================================================= >>--
--     Upvalues                                          --
--<< ================================================= >>--

local _G = getfenv(0)

local ShowOverlayGlow = LibStub("LibButtonGlow-1.0").ShowOverlayGlow
local HideOverlayGlow = LibStub("LibButtonGlow-1.0").HideOverlayGlow
local Wishlist = _G.MogIt.wishlist

local BUYBACK_ITEMS_PER_PAGE = _G.BUYBACK_ITEMS_PER_PAGE
local MERCHANT_ITEMS_PER_PAGE = _G.MERCHANT_ITEMS_PER_PAGE

local GetBuybackItemLink = _G.GetBuybackItemLink
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetNumBuybackItems = _G.GetNumBuybackItems
local GetNumQuestChoices = _G.GetNumQuestChoices
local GetNumQuestLogChoices = _G.GetNumQuestLogChoices
local GetNumQuestLogRewards = _G.GetNumQuestLogRewards
local GetNumQuestRewards = _G.GetNumQuestRewards
local GetQuestLogItemLink = _G.GetQuestLogItemLink
local MapQuestInfoRewardsFrame = _G.MapQuestInfoRewardsFrame
local MerchantFrame = _G.MerchantFrame
local QuestInfoFrame = _G.QuestInfoFrame

local match = _G.string.match
local tonumber = _G.tonumber


--<< ================================================= >>--
--     Centralised Glow Function                         --
--<< ================================================= >>--

local function CheckAndHighlightItem(itemLink, frame)
	if itemLink then
		local itemID = tonumber( match(itemLink, "item:(%d+)") )

		if Wishlist:IsItemInWishlist(itemID) then
			ShowOverlayGlow( _G[frame] )
		end
	end
end


--<< ================================================= >>--
--     Quest Rewards                                     --
--<< ================================================= >>--

local function ScanQuestRewards()
	for i=1, #MapQuestInfoRewardsFrame.RewardButtons do
		if _G["MapQuestInfoRewardsFrameQuestInfoItem"..i] then
			HideOverlayGlow( _G["MapQuestInfoRewardsFrameQuestInfoItem"..i] )
		end
	end

	for i=1, #QuestInfoFrame.rewardsFrame.RewardButtons do
		if _G["QuestInfoRewardsFrameQuestInfoItem"..i] then
			HideOverlayGlow( _G["QuestInfoRewardsFrameQuestInfoItem"..i] )
		end
	end

	local itemLink
	local numChoices, numRewards

	if QuestInfoFrame.questLog then
		numRewards = GetNumQuestLogRewards()
		numChoices = GetNumQuestLogChoices()
	else
		numRewards = GetNumQuestRewards()
		numChoices = GetNumQuestChoices()
	end

	for i=1, numRewards do
		itemLink = GetQuestLogItemLink("reward", i)

		if QuestInfoFrame.mapView then
			CheckAndHighlightItem(itemLink, "MapQuestInfoRewardsFrameQuestInfoItem"..i)
		else
			CheckAndHighlightItem(itemLink, "QuestInfoRewardsFrameQuestInfoItem"..i)
		end
	end

	for i=1, numChoices do
		itemLink = GetQuestLogItemLink("choice", i)

		if QuestInfoFrame.mapView then
			CheckAndHighlightItem(itemLink, "MapQuestInfoRewardsFrameQuestInfoItem"..i)
		else
			CheckAndHighlightItem(itemLink, "QuestInfoRewardsFrameQuestInfoItem"..i)
		end
	end
end

hooksecurefunc("QuestInfo_Display", ScanQuestRewards)


--<< ================================================= >>--
--     Merchants                                         --
--<< ================================================= >>--

local function ScanMerchantGoods()
	for i=1, MERCHANT_ITEMS_PER_PAGE do
		HideOverlayGlow( _G["MerchantItem"..i.."ItemButton"] )
	end

	HideOverlayGlow( _G["MerchantBuyBackItemItemButton"] )

	if MerchantFrame:IsShown() then
		if MerchantFrame.selectedTab == 1 then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
				CheckAndHighlightItem(GetMerchantItemLink(index), "MerchantItem"..i.."ItemButton")
			end

			CheckAndHighlightItem(GetBuybackItemLink(GetNumBuybackItems()), "MerchantBuyBackItemItemButton")
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				CheckAndHighlightItem(GetBuybackItemLink(i), "MerchantItem"..i.."ItemButton")
			end
		end
	end
end

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", ScanMerchantGoods)
