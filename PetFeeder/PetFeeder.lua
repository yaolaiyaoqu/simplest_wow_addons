-- 确保在经典旧世版本中兼容
local ADDON_NAME, ns = ...
local PetFeeder = CreateFrame("Frame", "PetFeederFrame", UIParent)

-- 配置文件保存（经典旧世需要显式保存）
PetFeederDB = PetFeederDB or {
    foodID = nil,
    position = { point = "CENTER", x = 0, y = 0 }
}

-- 主框架
function ns.CreateFeederFrame()
    local frame = CreateFrame("Button", nil, UIParent)
    frame:SetSize(64, 64)  -- 经典旧世更适合小尺寸
    frame:SetPoint(PetFeederDB.position.point, PetFeederDB.position.x, PetFeederDB.position.y)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    
    -- 经典旧世风格背景
    frame:SetNormalTexture("Interface\\Buttons\\UI-EmptySlot.blp")
    -- local nt = frame:GetNormalTexture()
    -- nt:SetVertexColor(1, 1, 1, 0.5)
    
    -- 高亮边框
    -- frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square.blp")
    
    -- 拖动处理
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint(1)
        PetFeederDB.position = { point = point, x = x, y = y }
    end)

    -- 在OnReceiveDrag脚本中修改如下：
    frame:SetScript("OnReceiveDrag", function(self)

        local cursorType, itemID = GetCursorInfo()

        
        if cursorType == "item" then
            -- 经典旧世正确获取物品信息的方式
            -- local texture, itemCount, locked, quality, readable, lootable, itemLink, noValue, itemID = GetContainerItemInfo(bag, slot)
            -- print(itemID)
            -- print("hehe")
            if itemID then
                -- 保存物品ID和物品链接
                PetFeederDB.foodID = itemID
                -- PetFeederDB.foodLink = itemLink
                
                -- 更新图标和提示
                self.foodIcon:SetTexture(GetItemIcon(itemID))
                print("成功设置食物："..itemLink)
                ClearCursor()
            else
                print("错误：无法获取物品信息")
            end
        else
            print("请拖动食物到框体中（当前拖放的是非物品类型）")
        end
    end)
    
    -- 点击喂食逻辑
    frame:SetScript("OnClick", function(self)
        -- if not PetFeederDB.foodID or not PetFeederDB.foodLink then
        if not PetFeederDB.foodID then
            print("请先拖动有效的食物到框体中！")
            return 
        end
        
        -- 经典旧世喂食逻辑
        if not HasPetUI() then
            print("没有召唤宠物！")
            return
        end
        
        for bag = 0,4 do
            for slot = 1,GetContainerNumSlots(bag) do
                local itemID = GetContainerItemID(bag, slot)

                if itemID == PetFeederDB.foodID then
                    print(bag, slot)
                    PickupContainerItem(bag,slot)
                    --DropItemOnUnit("pet")
                    -- UseContainerItem(bag, slot)
                    -- print("正在喂食...")
                    return
                end
            end
        end
        print("背包中没有该食物！")
    end)
    
    -- 物品图标显示
    frame.foodIcon = frame:CreateTexture(nil, "ARTWORK")
    frame.foodIcon:SetSize(32, 32)
    frame.foodIcon:SetPoint("CENTER")
    if PetFeederDB.foodID then
        frame.foodIcon:SetTexture(GetItemIcon(PetFeederDB.foodID))
    end
    
    return frame
end

-- 初始化
PetFeeder:RegisterEvent("PLAYER_LOGIN")
PetFeeder:SetScript("OnEvent", function(self, event)
    local frame = ns.CreateFeederFrame()
    frame:SetPoint(PetFeederDB.position.point, PetFeederDB.position.x, PetFeederDB.position.y)
    
    -- -- 经典旧世提示文字
    -- local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- text:SetPoint("BOTTOM", frame, "TOP", 0, 5)
    -- text:SetText("宠物喂食器\n拖动食物到此处")
end)