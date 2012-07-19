
local _G = getfenv(0)
local tonumber = _G.tonumber
local Wishlist = _G.MogIt.wishlist


local function highlight()
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


hooksecurefunc("QuestInfo_Display", highlight)
