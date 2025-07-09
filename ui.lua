---@diagnostic disable: undefined-global
local _G = _G or getfenv(0)

local resizes = {
	MainMenuBar,
	MainMenuExpBar,
	MainMenuBarMaxLevelBar,
	ReputationWatchBar,
	ReputationWatchStatusBar,
}

local frames = {
	BonusActionBarTexture0,
	BonusActionBarTexture1,
	ShapeshiftBarLeft,
	ShapeshiftBarMiddle,
	ShapeshiftBarRight,
	MainMenuMaxLevelBar2,
	MainMenuMaxLevelBar3,
	ActionBarUpButton,
	ActionBarDownButton,
	MainMenuBarPageNumber,
}

local textures = {
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuXPBarTexture2,
	MainMenuXPBarTexture3,
	ReputationWatchBarTexture2,
	ReputationWatchBarTexture3,
	ReputationXPBarTexture2,
	ReputationXPBarTexture3,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarArtFrameBackground,
}

local normtextures = {
	ShapeshiftButton1,
	ShapeshiftButton2,
	ShapeshiftButton3,
	ShapeshiftButton4,
	ShapeshiftButton5,
	ShapeshiftButton6,
}

-- general function to hide textures and frames
local function hide(frame, texture)
	if not frame then
		return
	end

	if texture and texture == 1 and frame.SetTexture then
		frame:SetTexture("")
	elseif texture and texture == 2 and frame.SetNormalTexture then
		frame:SetNormalTexture("")
	else
		frame:ClearAllPoints()
		frame.Show = function()
			return
		end
		frame:Hide()
	end
end

-- reduce actionbar size
for id, frame in pairs(resizes) do
	frame:SetWidth(488)
end

-- hide reduced frames
for id, frame in pairs(frames) do
	hide(frame)
end

-- clear reduced textures
for id, frame in pairs(textures) do
	hide(frame, 1)
end

-- clear some button textures
for id, frame in pairs(normtextures) do
	hide(frame, 2)
end

-- create a jump button
ActionButtonJmp = CreateFrame("CheckButton", "ActionButtonJmp", MainMenuBarArtFrame, "ActionButtonTemplate")

local ui = CreateFrame("Frame", "TurtleControllerUI", UIParent)
ui:RegisterEvent("PLAYER_ENTERING_WORLD")
ui:SetScript("OnEvent", function()
	-- update ui when frame positions get managed
	ui.manage_positions_hook = UIParent_ManageFramePositions
	UIParent_ManageFramePositions = ui.manage_positions
	ui:UnregisterAllEvents()
end)

ui:SetScript("OnUpdate", function()
	-- update ui once the first frame is shown
	UIParent_ManageFramePositions()
	this:Hide()
end)

local actionhide = CreateFrame("Frame", "TurtleControllerActionHide", BonusActionBarFrame)
actionhide.buttons = {}

actionhide:SetScript("OnShow", function()
	for button, bonus in pairs(this.buttons) do
		if button:GetID() ~= 0 then
			button:EnableMouse(bonus)
			button:SetAlpha(bonus)
		end
	end
end)

actionhide:SetScript("OnHide", function()
	for button, bonus in pairs(this.buttons) do
		if button:GetID() ~= 0 then
			button:EnableMouse(bonus == 0 and 1 or 0)
			button:SetAlpha(bonus == 0 and 1 or 0)
		end
	end
end)

ui.manage_button = function(self, frame, pos, x, y, image, bonus)
	if frame and tonumber(frame) then
		self:manage_button(_G["ActionButton" .. frame], pos, x, y, image)
		self:manage_button(_G["BonusActionButton" .. frame], pos, x, y, image, true)
		return
	end

	if pos == "DISABLED" then
		frame.Show = function()
			return
		end
		frame:ClearAllPoints()
		frame:Hide()
		return
	end

	-- add button to actionhide registry
	actionhide.buttons[frame] = bonus and 1 or 0

	-- set button scale and set position
	local scale = image == "" and 1 or 1.2
	local revscale = scale == 1 and 1.2 or 1
	frame:SetScale(scale)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, pos, x * revscale, y * revscale)

	-- hide keybind text
	_G[frame:GetName() .. "HotKey"]:Hide()

	-- add keybind icon
	if not frame.keybind_icon then
		frame.keybind_icon = CreateFrame("Frame", nil, frame)
		frame.keybind_icon:SetFrameLevel(255)
		frame.keybind_icon:SetAllPoints(frame)

		frame.keybind_icon.tex = frame.keybind_icon:CreateTexture(nil, "OVERLAY")
		frame.keybind_icon.tex:SetTexture(image)
		frame.keybind_icon.tex:SetPoint("TOPRIGHT", frame.keybind_icon, "TOPRIGHT", 0, 0)
		frame.keybind_icon.tex:SetWidth(16)
		frame.keybind_icon.tex:SetHeight(16)

		-- handle out of range as desaturation of keybind and icon
		_G[frame:GetName() .. "HotKey"].SetVertexColor = function(self, r, g, b, a)
			if r == 1.0 and g == 0.1 and b == 0.1 then
				_G[frame:GetName() .. "Icon"]:SetDesaturated(true)
				frame.keybind_icon.tex:SetDesaturated(true)
			else
				_G[frame:GetName() .. "Icon"]:SetDesaturated(false)
				frame.keybind_icon.tex:SetDesaturated(false)
			end
		end
	end
end

ui.manage_jump_button = function(self, frame)
	local icon = _G[frame:GetName() .. "Icon"]
	local name = _G[frame:GetName() .. "Name"]

	icon:Show()
	icon:SetTexture("Interface\\Icons\\inv_gizmo_rocketboot_01")
	icon.SetTexture = function()
		return
	end
	icon.Hide = function()
		return
	end

	name:SetPoint("BOTTOM", 0, 5)
	name.SetText = function()
		return
	end

	frame:Show()
	frame.Hide = function()
		return
	end
	frame.GetID = function()
		return 0
	end
end

local buttonmap = {
	-- dummy jump button
	{ ActionButtonJmp, "BOTTOMRIGHT", -420, 45, "Interface\\AddOns\\TurtleController\\img\\a" },

	-- right controls
	{ 1, "BOTTOMRIGHT", -465, 90, "Interface\\AddOns\\TurtleController\\img\\x" },
	{ 2, "BOTTOMRIGHT", -420, 135, "Interface\\AddOns\\TurtleController\\img\\y" },
	{ 3, "BOTTOMRIGHT", -375, 90, "Interface\\AddOns\\TurtleController\\img\\b" },

	-- Bumpers
	{ 4, "BOTTOMRIGHT", -420, 90, "Interface\\AddOns\\TurtleController\\img\\r1" },
	{ 5, "BOTTOMLEFT", 420, 90, "Interface\\AddOns\\TurtleController\\img\\r2" },

	-- left controls
	{ 6, "BOTTOMLEFT", 375, 90, "Interface\\AddOns\\TurtleController\\img\\left" },
	{ 7, "BOTTOMLEFT", 420, 135, "Interface\\AddOns\\TurtleController\\img\\up" },
	{ 8, "BOTTOMLEFT", 465, 90, "Interface\\AddOns\\TurtleController\\img\\right" },
	{ 9, "BOTTOMLEFT", 420, 45, "Interface\\AddOns\\TurtleController\\img\\down" },

	-- disabled
	{ 10, "DISABLED" },
	{ 11, "DISABLED" },
	{ 12, "DISABLED" },
}

ui.manage_positions = function(a1, a2, a3)
	-- run original function first
	ui.manage_positions_hook(a1, a2, a3)

	-- move and skin all buttons
	for id, button in pairs(buttonmap) do
		ui:manage_button(unpack(button))
	end

	-- skin jump button
	ui:manage_jump_button(ActionButtonJmp)

	-- move and resize chat
	ChatFrameEditBox:ClearAllPoints()
	ChatFrameEditBox:SetPoint("TOP", UIParent, "TOP", 0, -10)
	ChatFrameEditBox:SetWidth(300)
	ChatFrameEditBox:SetScale(2)

	-- on-screen keyboard helper
	ChatFrame1.oskHelper = ChatFrame1.oskHelper or CreateFrame("Button", nil, UIParent)
	ChatFrame1.oskHelper:SetFrameStrata("BACKGROUND")
	ChatFrame1.oskHelper:SetAllPoints(ChatFrame1)
	ChatFrame1.oskHelper:SetScript("OnClick", function()
		if not ChatFrameEditBox:IsVisible() then
			ChatFrameEditBox:Show()
			ChatFrameEditBox:Raise()
		else
			ChatFrameEditBox:Hide()
		end
	end)

	ChatFrame1.oskHelper:SetScript("OnUpdate", function()
		if ChatFrameEditBox:IsVisible() and this.state ~= 1 then
			ChatFrame1:SetScale(2)
			ChatFrame1:ClearAllPoints()
			ChatFrame1:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
			ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "RIGHT", 0, -14)

			FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
			FCF_SetWindowAlpha(ChatFrame1, 0.5)

			this.state = 1
		elseif not ChatFrameEditBox:IsVisible() and this.state ~= 0 then
			local anchor = MainMenuBarArtFrame
			anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
			anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
			anchor = ShapeshiftBarFrame:IsVisible() and ShapeshiftBarFrame or anchor
			anchor = PetActionBarFrame:IsVisible() and PetActionBarFrame or anchor

			ChatFrame1:SetScale(1)
			ChatFrame1:ClearAllPoints()
			ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 20)
			ChatFrame1:SetWidth(400) -- Optional: set a fixed width
			ChatFrame1:SetHeight(200) -- Optional: set a fixed height

			FCF_SetWindowColor(ChatFrame1, 0, 0, 0)
			FCF_SetWindowAlpha(ChatFrame1, 0)

			this.state = 0
		end
	end)

	-- move and hide some chat buttons
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton.Show = function()
		return
	end

	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame" .. i .. "DownButton"]:ClearAllPoints()
		_G["ChatFrame" .. i .. "DownButton"]:SetPoint("BOTTOMRIGHT", _G["ChatFrame" .. i], "BOTTOMRIGHT", 0, -5)

		_G["ChatFrame" .. i .. "UpButton"]:ClearAllPoints()
		_G["ChatFrame" .. i .. "UpButton"]:SetPoint("RIGHT", _G["ChatFrame" .. i .. "DownButton"], "LEFT", 0, 0)

		_G["ChatFrame" .. i .. "BottomButton"]:Hide()
		_G["ChatFrame" .. i .. "BottomButton"].Show = function()
			return
		end
	end

	-- move pet action bar
	local anchor = MainMenuBarArtFrame
	anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
	anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
	anchor = ShapeshiftBarFrame:IsVisible() and ShapeshiftBarFrame or anchor
	PetActionBarFrame:ClearAllPoints()
	PetActionBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 3)

	-- move shapeshift bar
	local anchor = MainMenuBarArtFrame
	anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
	anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
	ShapeshiftBarFrame:ClearAllPoints()
	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 15, -5)

	-- move normal action bars
	MultiBarBottomLeft:ClearAllPoints()
	MultiBarBottomLeft:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 20)

	MultiBarBottomRight:ClearAllPoints()
	MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 5)

	-- Clear any existing anchor points on the XP bar
	MainMenuExpBar:ClearAllPoints()
	-- move and stretch XP bar to bottom full width
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	MainMenuExpBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

	-- Hide all XP bar textures for a clean stretched bar
	MainMenuXPBarTexture0:Hide()
	MainMenuXPBarTexture1:Hide()
	MainMenuXPBarTexture2:Hide()
	MainMenuXPBarTexture3:Hide()

	-- Clear previous anchor points on the reputation bar
	ReputationWatchBar:ClearAllPoints()

	-- Stretch reputation bar to match XP bar width
	ReputationWatchBar:SetPoint("BOTTOMLEFT", MainMenuExpBar, "TOPLEFT", 0, 0)
	ReputationWatchBar:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "TOPRIGHT", 0, 0)

	-- Optionally enforce a specific height to match XP bar (uncomment if needed)
	-- ReputationWatchBar:SetHeight(8)

	-- Hide all XP bar textures for a clean stretched bar
	ReputationWatchBarTexture0:Hide()
	ReputationWatchBarTexture1:Hide()
	ReputationWatchBarTexture2:Hide()
	ReputationWatchBarTexture3:Hide()

	-- move elements for reduced actionbar size
	MainMenuMaxLevelBar0:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
	MainMenuBarTexture2:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT")
	MainMenuBarTexture3:SetPoint("RIGHT", MainMenuBarArtFrame, "RIGHT")

	ActionBarDownButton:SetPoint("BOTTOMLEFT", MainMenuBarArtFrame, "BOTTOMLEFT", -5, -5)
	ActionBarUpButton:SetPoint("TOPLEFT", MainMenuBarArtFrame, "TOPLEFT", -5, -5)
	MainMenuBarPageNumber:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT", 25, -5)
	CharacterMicroButton:SetPoint("LEFT", MainMenuBarArtFrame, "LEFT", 38, 0)

	MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBarArtFrame, "LEFT", 30, 0)
	MainMenuBarRightEndCap:SetPoint("LEFT", MainMenuBarArtFrame, "RIGHT", -30, 0)

	-- Move Latency meter
	MainMenuBarPerformanceBar:ClearAllPoints()
	MainMenuBarPerformanceBar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -5)
	MainMenuBarPerformanceBar:SetHeight(MainMenuBarPerformanceBar:GetWidth())

	-- Anchor bag buttons bottom-right with no gaps
	local bagParent = UIParent
	local bagAnchorX, bagAnchorY = -10, 60 -- distance from bottom-right corner

	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", bagParent, "BOTTOMRIGHT", bagAnchorX, bagAnchorY)

	local prevButton = MainMenuBarBackpackButton
	local buttonSpacing = 0 -- reduce spacing to fix gaps after texture removal

	for i = 3, 0, -1 do
		local bagSlot = _G["CharacterBag" .. i .. "Slot"]
		if bagSlot then
			bagSlot:ClearAllPoints()
			bagSlot:SetPoint("RIGHT", prevButton, "LEFT", -buttonSpacing, 0)
			prevButton = bagSlot
		end
	end

	local microBarAnchorX, microBarAnchorY = -10, 20 -- same X, higher Y to be above bagbar

	-- If you have the full microbar cluster, you may want to loop them like for bags
	local microButtons = {
		HelpMicroButton,
		MainMenuMicroButton,
		WorldMapMicroButton,
		SocialsMicroButton,
		QuestLogMicroButton,
		TalentMicroButton,
		SpellbookMicroButton,
		CharacterMicroButton,
	}

	local prevMicro = nil
	local microSpacing = 0 -- spacing to the left
	for i, btn in ipairs(microButtons) do
		btn:ClearAllPoints()
		btn:SetWidth(29)
		btn:SetHeight(58)
		if i == 1 then
			btn:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", microBarAnchorX, microBarAnchorY)
			prevMicro = btn
		elseif btn:IsShown() then
			btn:SetPoint("RIGHT", prevMicro, "LEFT", -microSpacing, 0)
			prevMicro = btn
		end
	end

	-- Hide Gargyles (configurable)
	if HIDE_GARGOYLES then
		hide(MainMenuBarLeftEndCap)
		hide(MainMenuBarRightEndCap)
	end

	-- move pfQuest arrow if existing
	if pfQuest and pfQuest.route and pfQuest.route.arrow then
		pfQuest.route.arrow:SetPoint("CENTER", 0, -120)
	end
end

-- Key Modifier Bar Switching
local modifierWatcher = CreateFrame("Frame")
modifierWatcher.lastPage = nil

modifierWatcher:SetScript("OnUpdate", function()
	local ctrl = IsControlKeyDown() -- 001
	local shift = IsShiftKeyDown() -- 010
	--  local alt = IsAltKeyDown() -- 100

	local page = (ctrl and shift and 4) or (ctrl and 2) or (shift and 3) or 1
	--  if alt and shift and ctrl then -- 111
	--    page = 8
	--  elseif alt and shift then -- 110
	--    page = 7
	--  elseif alt and ctrl then -- 101
	--    page = 6
	--  elseif alt then -- 100
	--    page = 5
	--  elseif shift and ctrl then -- 011
	--    page = 4
	--  elseif shift then -- 010
	--    page = 3
	--  elseif ctrl then -- 001
	--    page = 2
	--  else -- 000
	--    page = 1
	--  end

	if CURRENT_ACTIONBAR_PAGE ~= page then
		CURRENT_ACTIONBAR_PAGE = page
		ChangeActionBarPage()
	end
end)

-- unset bindings
for i = 1, 9 do
	--  SetBinding("ALT-" .. i)
	SetBinding("SHIFT-" .. i)
	SetBinding("CTRL-" .. i)
end

-- save to main frame
TurtleController.ui = ui
