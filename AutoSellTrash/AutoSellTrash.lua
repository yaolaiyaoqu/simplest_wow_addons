local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if (GetContainerItemLink(bag,slot) or ""):find("ff9d9d9d") then
                UseContainerItem(bag, slot)
            end
        end
    end
end)
