Zee = Zee or {};
Zee.RPPrefix = Zee.RPPrefix or {};
local Win = Zee.WindowAPI;
local RP = Zee.RPPrefix;
RP.Enabled = false;
RP.Hooked = false;
RP.ButtonText = "Off";
RPPrefix_Settings_New = {}

function RP.LoadSettings()
	RPPrefix_Settings = RPPrefix_Settings or {} -- create table if one doesn't exist
	RPPrefix_Settings_New = RPPrefix_Settings -- assign settings declared above
	if RPPrefix_Settings_New.PreviousPrefix == nil then RPPrefix_Settings_New.PreviousPrefix = "|cFF707070Type prefix here"; end
	 RPPrefix_Settings = RPPrefix_Settings_New;
end

function RP.Hook_SendChatMessage(msg, chatType, language, channel)
	local newMsg = msg;
	if RP.Enabled then
		if (chatType == "SAY" or chatType == "YELL") and string.sub(msg, 0, 1) ~= "/" then
			if msg ~= "" and msg ~= nil and RPPrefix_Settings_New.PreviousPrefix ~= "|cFF707070Type prefix here" then
				newMsg = RPPrefix_Settings_New.PreviousPrefix .. " " .. msg;
			end
		end
	end

	RP.SavedSendChatMessage(newMsg, chatType, language, channel);
end

function RP.Toggle()

	if RP.Hooked == false then
		RP.SavedSendChatMessage = SendChatMessage;
		SendChatMessage = RP.Hook_SendChatMessage;
		RP.Hooked = true;
	end

	-- disable --
	if RP.Enabled then
		RP.Enabled = false;
		for i = 1, NUM_CHAT_WINDOWS do
			RP.ButtonText = "Off";
		end
	-- enable --
	else
		RP.Enabled = true;
		for i = 1, NUM_CHAT_WINDOWS do
			RP.ButtonText = "On";
		end
	end
end

RP.MainFrame = CreateFrame("Frame", "RPPrefixMainFrame", UIParent);
RP.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
RP.MainFrame:SetSize(200, 20);
RP.MainFrame.texture = RP.MainFrame:CreateTexture("RP-Prefix-MainFrame-Texture", "ARTWORK");
RP.MainFrame.texture:SetColorTexture(0,0,0,0.5);
RP.MainFrame.texture:SetAllPoints(RP.MainFrame);
RP.MainFrame:SetMovable(true);
RP.MainFrame:EnableMouse(true);
RP.MainFrame:RegisterForDrag("LeftButton");
RP.MainFrame:SetScript("OnDragStart", function() RP.MainFrame:StartMoving() end)
RP.MainFrame:SetScript("OnDragStop", function() RP.MainFrame:StopMovingOrSizing() end)

RP.CornerDrag = CreateFrame("Frame", "RPPrefixCornerDrag", RP.MainFrame);
RP.CornerDrag:SetPoint("TOPLEFT", RP.MainFrame, "TOPLEFT", 0, 0);
RP.CornerDrag:SetSize(10, 20);
RP.CornerDrag.texture = RP.CornerDrag:CreateTexture("RP-Prefix-MainFrame-Texture", "ARTWORK");
RP.CornerDrag.texture:SetColorTexture(0.315,0,0,1);
RP.CornerDrag.texture:SetAllPoints(RP.CornerDrag);

RP.Button_Toggle = Win.CreateButton(11, 0, 30, 20, RP.MainFrame, "TOPLEFT", "TOPLEFT", "Off", nil, Win.BUTTON_WOW)
RP.Button_Toggle:SetScript("OnClick", function() RP.Toggle() RP.Button_Toggle.text:SetText(RP.ButtonText) end)

RP.EditBox = CreateFrame('EditBox', "RPPrefixEditbox", RP.MainFrame) ---- left side editable text box
RP.EditBox:SetPoint("TOPRIGHT", RP.MainFrame, "TOPRIGHT", 0, 0)
RP.EditBox:SetAutoFocus(false)
RP.EditBox:EnableMouse(true)
RP.EditBox:SetMaxLetters(20)
RP.EditBox:SetFont('Fonts\\ARIALN.ttf', 12, 'THINOUTLINE')
RP.EditBox:SetScript('OnEscapePressed', function() RP.EditBox:ClearFocus()  end)
RP.EditBox:SetScript('OnEnterPressed', function() RP.EditBox:ClearFocus()  end)
RP.EditBox:EnableMouse()
RP.EditBox:SetScript('OnMouseDown', 
	function() 
		RP.EditBox:SetFocus();
		if RP.EditBox:GetText() == "|cFF707070Type prefix here" then
			RP.EditBox:SetText("");
		end
	end)
RP.EditBox:SetScript("OnTextChanged", 
	function(self,isUserInput) 
		RPPrefix_Settings_New.PreviousPrefix = RP.EditBox:GetText()
		RPPrefix_Settings = RPPrefix_Settings_New;
 	end)
RP.EditBox:SetWidth(155)
RP.EditBox:SetHeight(20)


-- Variables loaded event --
RP.LOGIN_EVENT = CreateFrame("Frame","VARIABLES_LOADED_EVENT_FRAME",UIParent)
RP.LOGIN_EVENT:RegisterEvent("VARIABLES_LOADED");
RP.LOGIN_EVENT:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out
RP.LOGIN_EVENT:SetScript("OnEvent",
function(self,event,...)
	if event=="VARIABLES_LOADED" then
		RP.LoadSettings();
		RP.LOGIN_EVENT:UnregisterEvent("VARIABLES_LOADED");
		RP.EditBox:SetText(RPPrefix_Settings_New.PreviousPrefix)
	elseif event == "PLAYER_LOGOUT" then
		RPPrefix_Settings = RPPrefix_Settings_New;
		RP.LOGIN_EVENT:UnregisterEvent("PLAYER_LOGOUT");
  	end
end)

----------------------------------------------------------
--	Chat Commands										--
----------------------------------------------------------

function RPPrefixChatCommands(msg, editbox)
	if msg == "reset" then
		RP.MainFrame:ClearAllPoints()
		RP.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	else
		RPPrefix_Settings_New.PreviousPrefix = msg;
	 	RPPrefix_Settings = RPPrefix_Settings_New;
	 	RP.EditBox:SetText(RPPrefix_Settings_New.PreviousPrefix)
	end
end
SLASH_PREFIX1 = "/prefix";
SlashCmdList["PREFIX"] = RPPrefixChatCommands;