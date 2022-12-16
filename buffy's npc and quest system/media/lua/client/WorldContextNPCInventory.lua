---@diagnostic disable: undefined-global, lowercase-global, deprecated
--***************************************************************************************************************************************************************
--**                                                                NECROPOLISRP.NET                                                                           **
--**                                            			      File Author: github.com/buffyuwu                                                                   **
--**                                                            NPC Dialogue and Creator                                                                       **
--** If you're reading this code, come contribute to Necropolis! We're always looking for new developers to help make the original B41 rp community better. <3 **
--***************************************************************************************************************************************************************
require "ISUI/ISPanel"
require "BuildingDefs"

local function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "\r\n"
  indent = indent + 1
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  " -> "
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. "\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "" .. v .. "\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2)
    else
      toprint = toprint .. "" .. tostring(v) .. "_\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. " "
  return toprint
end
local showText
local scrollText
local function timerCleanup()
    for i=1, #MxUtils.IntervalTimers do
      MxUtils.deleteIntervalTimer(i);
    end
    showText = ""
  end
local UI
local dialogChoices = {" "}
local function onCreateGenericNPCUI(npcName, obj)
    --initializeModData()
    local player = getPlayer()
    local modData = player:getModData()
    modData['_NPCDialogueTarget'] = obj
    npcName = npcName or "Interact"
    local portrait = obj:getModData()['_NPCGenericPortrait']
    local function genericChoice(button, args)
        if button:getTitle() == "Leave" then
            timerCleanup()
            UI:close();
            return
        end

        if button:getTitle() ~= " " and button:getTitle() ~= "" then
            timerCleanup()
            print("selected "..button:getTitle())
            print(tprint(obj:getModData()['_NPCGenericReplies']))
            if obj:getModData()['_NPCGenericReplies'][button:getTitle()] then --our button exists in the reply table and a reply is nested
              local buttonData = obj:getModData()['_NPCGenericReplies'][button:getTitle()]
              print("found "..tostring(buttonData).." in _NPCGenericReplies")
              scrollText = buttonData["reply"]
              UI["b1"]:setText(buttonData["b1"])
              UI["b2"]:setText(buttonData["b2"])
              UI["b3"]:setText(buttonData["b3"])
              print("foo 1")
            else --we are on the default screen
                print("no reply")
            end

            MxUtils.createIntervalTimer(40, function()
            showText = scrollText:sub(1, #showText+1)
            UI["rtext"]:setText("<BR> <SIZE:large> "..showText)
            if not luautils.stringEnds(showText, " ") and not luautils.stringEnds(showText, ",") and modData['_NPCTextSounds'] == 1 then
              if luautils.stringEnds(showText, "\"") then
                if obj:getModData()['_NPCGenericVoice'] == "Feminine" then
                    modData['_NPCTextSoundProfile'] = "speech_fem_"..ZombRand(1,4)
                elseif obj:getModData()['_NPCGenericVoice'] == "Masculine" then
                    modData['_NPCTextSoundProfile'] = "speech_default"
                else
                  modData['_NPCTextSoundProfile'] = "speech_text"
                end
              end
              if luautils.stringEnds(showText, ".\"") or luautils.stringEnds(showText, "!\"") then
                modData['_NPCTextSoundProfile'] = "speech_text"
              end
              if ZombRand(1,3) >= 2 then
                getSoundManager():PlaySound(modData['_NPCTextSoundProfile'], false, 1)
              end
            end
            if #showText == #scrollText then
              timerCleanup()
            end
            end)
        end
    end
    UI = NewUI();
    UI:setDrawFrame(false)
    UI:setWidthPercent(0.50)
    UI:setPositionPercent(0.25, 1)
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addText("text1", npcName, "Title", "Center")
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 100);
    UI:addImageButton("image1", portrait)
    UI["image1"]:setWidthPixel(256)

    UI:addEmpty(_, _, _, 10);
    UI:addEmpty(_, _, _, 10);
    UI:addEmpty(_, _, _, 10);
    UI:addEmpty(_, _, _, 10);
    UI:addRichText("rtext", " ");
    UI:addEmpty(_, _, _, 10);
    UI["rtext"]:setBorder(false);

    UI:nextLine();
    UI:addText("_spacer1", " ", "Title", "Center")
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b1", obj:getModData()['_NPCGenericReplies']["default"]["b1"], genericChoice);

    UI["b1"].borderColor = {r=0, g=0, b=0, a=0};
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b2", obj:getModData()['_NPCGenericReplies']["default"]["b2"], genericChoice);
    UI["b2"]:addArg("choice", "2");
    UI["b2"].borderColor = {r=0, g=0, b=0, a=0}
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b3", " ", genericChoice);
    UI["b3"]:addArg("choice", "3");
    UI["b3"].borderColor = {r=0, g=0, b=0, a=0}
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b4", " ", genericChoice);
    UI["b4"]:addArg("choice", "4");
    UI["b4"].borderColor = {r=0, g=0, b=0, a=0}
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b5", " ", genericChoice);
    UI["b5"]:addArg("choice", "5");
    UI["b5"].borderColor = {r=0, g=0, b=0, a=0}
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 10);
    UI:addButton("b6", "Leave", genericChoice);
    UI["b6"]:addArg("choice", "leave");
    UI:addEmpty(_, _, _, 10);
    UI:addText("spacer5", " ", "Title", "Center")
    UI:addText("spacer6", " ", "Title", "Center")
    UI:addText("spacer7", " ", "Title", "Center")
    UI:addText("spacer8", " ", "Title", "Center")
    UI:addButton("bskipdialogue", "Skip", genericChoice);
    UI["bskipdialogue"]:addArg("skip", "true");
    UI:addButton("bsoundtoggle", "Toggle Sound", genericChoice);
    UI["bsoundtoggle"]:addArg("sound", "toggle");
    UI:addEmpty(_, _, _, 10);
    UI:nextLine();
    UI:addEmpty(_, _, _, 5);
    UI:saveLayout();
    dialogChoices = obj:getModData()['_NPCGenericChoices']
    if not obj:getModData()['_NPCGenericReplies']["default"]["reply"] then
      scrollText = "This NPC was created without first adding text with the object in your inventory. Do that first."
    else
      scrollText = obj:getModData()['_NPCGenericReplies']["default"]["reply"]
    end
    if modData['_NPCIntroFlags']["Approached"] then
      scrollText = "\"You're back.\""
    end
    modData['_NPCLastMessage'] = scrollText
    timerCleanup()
    MxUtils.createIntervalTimer(40, function()
    showText = scrollText:sub(1, #showText+1)
    UI["rtext"]:setText("<BR> <SIZE:large> "..showText)
    if not luautils.stringEnds(showText, " ") and not luautils.stringEnds(showText, ",") and modData['_NPCTextSounds'] == 1 then
      if luautils.stringEnds(showText, "\"") then
        if obj:getModData()['_NPCGenericVoice'] == "Feminine" then
            modData['_NPCTextSoundProfile'] = "speech_fem_"..ZombRand(1,4)
        elseif obj:getModData()['_NPCGenericVoice'] == "Masculine" then
            modData['_NPCTextSoundProfile'] = "speech_default"
        else
          modData['_NPCTextSoundProfile'] = "speech_text"
        end
      end
      if luautils.stringEnds(showText, ".\"") then
        modData['_NPCTextSoundProfile'] = "speech_text"
      end
      if ZombRand(1,3) >= 2 then
        getSoundManager():PlaySound(modData['_NPCTextSoundProfile'], false, 1)
      end
    end
    if #showText == #scrollText then
      timerCleanup()
      if scrollText == obj:getModData()['_NPCGenericReplies']["default"]["reply"] then
        UI["b1"]:setText(obj:getModData()['_NPCGenericReplies']["default"]["b1"])
      end
    end
    end)
end
local function lines(str)
  local result = {}
  for line in str:gmatch '[^\n]+' do
    table.insert(result, line)
  end
  return result
end
local customizeUI
local repliesUI
local function onNPCCustomize(npcName, obj)
if not obj then return end
local player = getPlayer()
local modData = obj:getModData()
if not obj:getModData()['_NPCGenericName'] then obj:getModData()['_NPCGenericName'] = "Spiffo"; end
if not obj:getModData()['_NPCGenericVoice'] then obj:getModData()['_NPCGenericVoice'] = "Masculine"; end
if not obj:getModData()['_NPCGenericInteractText'] then obj:getModData()['_NPCGenericInteractText'] = "Interact with "; end
if not obj:getModData()['_NPCGenericPortrait'] then obj:getModData()['_NPCGenericPortrait'] = "media/textures/generic_male.png"; end
if not obj:getModData()['_NPCGenericReplies'] then obj:getModData()['_NPCGenericReplies'] = {
    ["default"] = {
        ["reply"] = "\"Hello there!\" They said happily.",
        ["b1"] = "\"Hello.\"",
        ["b2"] = "You stare at the NPC expectantly.",
        ["b3"] = "\"Have you seen Gwendolyn P. Birdie anywhere?\"",
    },
};
end
if not obj:getModData()['_NPCGenericButtons'] then obj:getModData()['_NPCGenericButtons'] = {obj:getModData()['_NPCGenericReplies']["default"]["b1"],obj:getModData()['_NPCGenericReplies']["default"]["b2"],obj:getModData()['_NPCGenericReplies']["default"]["b3"]}; end
if not obj:getModData()['_NPCReplyCount'] then obj:getModData()['_NPCReplyCount'] = 0; end
--obj:getModData()['_NPCGenericChoices'] = {" "," "," "," "," "}
customizeUI = NewUI();
customizeUI:setTitle("NPC Maker");
customizeUI:setDrawFrame(true)
customizeUI:setWidthPercent(0.5)
--customizeUI:setDefaultLineHeightPercent(0.025)
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addText("interactText", "Right Click Text: ", "large", "left")
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addEntry("entryInteract", obj:getModData()['_NPCGenericInteractText'], false)
local function entryInteract()
    obj:getModData()['_NPCGenericInteractText'] = customizeUI["entryInteract"]:getValue().." "
end
customizeUI["entryInteract"]:setEnterFunc(entryInteract)
--customizeUI["entryName"]:setWidthPercent(0.45)
--customizeUI:addEmpty(_, _, _, 500);
customizeUI:nextLine();
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addText("nameText", "Name: ", "large", "left")
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addEntry("entryName", obj:getModData()['_NPCGenericName'], false)
local function entryName()
    obj:getModData()['_NPCGenericName'] = customizeUI["entryName"]:getValue()
end
customizeUI["entryName"]:setEnterFunc(entryName)
--customizeUI["entryName"]:setWidthPercent(0.45)
--customizeUI:addEmpty(_, _, _, 500);
customizeUI:nextLine();
-- customizeUI:addText("text", "Text: ", "large", "left")
-- customizeUI:addEmpty(_, _, _, 10);
-- local dialogText = obj:getModData()['_NPCGenericReplies']["default"]["reply"]
-- customizeUI:addEntry("entryText", dialogText, false)
-- local function entryText()
--     obj:getModData()['_NPCGenericReplies']["default"]["reply"] = customizeUI["entryText"]:getValue()
--     customizeUI["currentText"]:setText("Dialog Text: <BR> "..customizeUI["entryText"]:getValue())
--     --openTestUI(obj)
-- end
-- customizeUI["entryText"]:setEnterFunc(entryText)
--customizeUI["entryText"]:setWidthPercent(0.45)
local function voiceSwap()
    local voice = obj:getModData()['_NPCGenericVoice']
    if voice == "Masculine" then
        obj:getModData()['_NPCGenericVoice'] = "Feminine"
    elseif voice == "Feminine" then
        obj:getModData()['_NPCGenericVoice'] = "Masculine"
    end
    customizeUI["voiceBox"]:setText(obj:getModData()['_NPCGenericVoice'])
end
local num = 1
local portraits = {"media/textures/generic_female.png","media/textures/generic_male.png"}
local function portraitSwap()
    if num > 3 then
        num = 1
    end
    portraits = {"media/textures/generic_female.png","media/textures/generic_male.png",obj:getTextureName()}
    customizeUI["image1"]:setPath(portraits[num])
    obj:getModData()['_NPCGenericPortrait'] = portraits[num]
    customizeUI["image1"]:setPath(portraits[num])
    print("swapping portrait to "..portraits[num])
    customizeUI["portraitPath"]:setText("Portrait Path: "..obj:getModData()['_NPCGenericPortrait'])
    num = num + 1
end
local function openRepliesUI(button, args)
  repliesUI:open();
  repliesUI:setPositionPixel(customizeUI:getX() + customizeUI:getWidth(), customizeUI:getY());
end

local function addDynamicReply()
local newReply = {
["default"] = {
    ["reply"] = tostring(repliesUI["default_reply"]:getValue()),
    ["b1"] = tostring(repliesUI["default_b1"]:getValue()),
    ["b2"] = tostring(repliesUI["default_b2"]:getValue()),
    ["b3"] = tostring(repliesUI["default_b3"]:getValue()),
},
-- hold a gun to my head and demand to know why the below table merge doesnt work without them being tostring'd and i would tell you to pull the trigger
[tostring(repliesUI["leadingChoice"]:getValue())] = {
    ["reply"] = tostring(repliesUI["reply_1"]:getValue()),
    ["b1"] = tostring(repliesUI["b_1"]:getValue()),
    ["b2"] = tostring(repliesUI["b_2"]:getValue()),
    ["b3"] = tostring(repliesUI["b_3"]:getValue()),
},
}
for k,v in pairs(newReply) do obj:getModData()['_NPCGenericReplies'][k] = v; end
end

customizeUI:addEmpty(_, _, _, 10);
customizeUI:addText("voice", "Voice: ", "large", "center")
customizeUI:addButton("voiceBox", obj:getModData()['_NPCGenericVoice'], voiceSwap);
--customizeUI["voiceBox"]:setWidthPercent(0.45)
customizeUI:nextLine();
customizeUI:addEntry("customVoicePath", obj:getModData()['_NPCGenericVoice'], false)
customizeUI["customVoicePath"]:setEnterFunc(function() print("updating npc's voice to custom path, though this is not fully implemented yet and it is just going to default to speech_text for now. if this comment made it to live release, go yell at buffy to implement this feature"); obj:getModData()['_NPCGenericVoice'] = customizeUI["customVoicePath"]:getValue(); end)
customizeUI:nextLine();
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addImageButton("image1", obj:getModData()['_NPCGenericPortrait'],portraitSwap)
customizeUI["image1"]:setWidthPixel(256)
customizeUI:addEmpty(_, _, _, 10);
--customizeUI["image1"].borderColor = {r=0, g=0, b=0, a=0};
customizeUI:nextLine();
customizeUI:addEmpty(_, _, _, 10);
customizeUI:addText("portraitPath", "Portrait Path: "..obj:getModData()['_NPCGenericPortrait'], "large", "center")
customizeUI:addEmpty(_, _, _, 10);
customizeUI:nextLine();
customizeUI:addEntry("customPortraitPath", obj:getModData()['_NPCGenericPortrait'], false)
customizeUI["customPortraitPath"]:setEnterFunc(function() print("updating npc's portrait to custom path"); obj:getModData()['_NPCGenericPortrait'] = customizeUI["customPortraitPath"]:getValue(); end)
customizeUI:nextLine();
customizeUI:addButton("addReply1", "Dialogue Editor", openRepliesUI);
customizeUI:nextLine();
customizeUI:addButton("refreshButton", "Refresh", function() customizeUI["tableContents"]:setItems(lines(tprint(obj:getModData()['_NPCGenericReplies']))); end);
customizeUI:nextLine();
customizeUI:addScrollList("tableContents", lines(tprint(obj:getModData()['_NPCGenericReplies'])))
--customizeUI:setLineHeightPercent(0.5)
customizeUI:saveLayout();

-- Replies UI
repliesUI = NewUI();
repliesUI:setTitle("Replies");
repliesUI:isSubUIOf(customizeUI);
repliesUI:setWidthPercent(0.50)
repliesUI:addText("replyExplain1", "Default Text", "large", "center")
repliesUI:nextLine();
repliesUI:addEntry("default_reply", obj:getModData()['_NPCGenericReplies']["default"]["reply"], false)
repliesUI["default_reply"]:setEnterFunc(function() print("updating npc's default reply"); obj:getModData()['_NPCGenericReplies']["default"]["reply"] = repliesUI["default_reply"]:getValue();
  customizeUI["tableContents"]:setItems(lines(tprint(obj:getModData()['_NPCGenericReplies']))); end)
repliesUI:nextLine();
repliesUI:addText("replyExplain2", "Default Choices", "large", "center")
repliesUI:nextLine();
repliesUI:addEntry("default_b1", obj:getModData()['_NPCGenericReplies']["default"]["b1"], false)
repliesUI["default_b1"]:setEnterFunc(function() print("updating npc's default button 1"); obj:getModData()['_NPCGenericReplies']["default"]["b1"] = repliesUI["default_b1"]:getValue(); customizeUI["tableContents"]:setItems(lines(tprint(obj:getModData()['_NPCGenericReplies']))); end)
repliesUI:nextLine();
repliesUI:addEntry("default_b2", obj:getModData()['_NPCGenericReplies']["default"]["b2"], false)
repliesUI["default_b2"]:setEnterFunc(function() print("updating npc's default button 2"); obj:getModData()['_NPCGenericReplies']["default"]["b2"] = repliesUI["default_b2"]:getValue(); customizeUI["tableContents"]:setItems(lines(tprint(obj:getModData()['_NPCGenericReplies']))); end)
repliesUI:nextLine();
repliesUI:addEntry("default_b3", obj:getModData()['_NPCGenericReplies']["default"]["b3"], false)
repliesUI["default_b3"]:setEnterFunc(function() print("updating npc's default button 3"); obj:getModData()['_NPCGenericReplies']["default"]["b3"] = repliesUI["default_b3"]:getValue(); customizeUI["tableContents"]:setItems(lines(tprint(obj:getModData()['_NPCGenericReplies']))); end)
repliesUI:nextLine();
repliesUI:addEmpty(_, _, _, 10);
repliesUI:nextLine();
repliesUI:addText("replyExplain3", "+ New Entry +", "large", "center")
repliesUI:nextLine();
repliesUI:addText("replyExplain4", "If the player picks ->", "large", "center")
repliesUI:addEntry("leadingChoice", "button text", false)
repliesUI["leadingChoice"]:setWidthPercent(0.42)
repliesUI:nextLine();
repliesUI:addText("replyExplain5", "New Reply ->", "large", "center")
repliesUI:addEntry("reply_1", "Dialogue text", false)
repliesUI["reply_1"]:setWidthPercent(0.42)
repliesUI["reply_1"]:setEnterFunc(addDynamicReply)
repliesUI:nextLine();
repliesUI:addEmpty(_, _, _, 10);
repliesUI:nextLine();
repliesUI:addText("replyExplain6", "New Choices ->", "large", "center")
repliesUI:addText("replyExplain6", "If a choice is blank it won't go anywhere when a user presses it.", "small", "center")
repliesUI:nextLine();
repliesUI:addEntry("b_1", "Choice 1", false)
repliesUI["b_1"]:setEnterFunc(addDynamicReply)
repliesUI["b_1"]:setWidthPercent(0.45)
repliesUI:nextLine();
repliesUI:addEntry("b_2", "Choice 2", false)
repliesUI["b_2"]:setEnterFunc(addDynamicReply)
repliesUI["b_2"]:setWidthPercent(0.45)
repliesUI:nextLine();
repliesUI:addEntry("b_3", "Choice 3", false)
repliesUI["b_3"]:setEnterFunc(addDynamicReply)
repliesUI["b_3"]:setWidthPercent(0.45)
repliesUI:nextLine();
repliesUI:addEmpty(_, _, _, 10);
repliesUI:saveLayout();
repliesUI:close();
end
local function npcMenu(player, context, worldobjects, test, items)
	for _,obj in ipairs(worldobjects) do --filter for what we find when we right click
    local npcName = obj:getModData()['_NPCGenericName'] or "Unconfigured NPC"
    local interactText = obj:getModData()['_NPCGenericInteractText'] or "Interact with "
		local objTextureName = obj:getTextureName()
		local dx = (obj:getSquare():getX() - getSpecificPlayer(player):getSquare():getX()) or 0
		local dy = (obj:getSquare():getY() - getSpecificPlayer(player):getSquare():getY()) or 0
		local zGood = (math.abs(obj:getSquare():getZ() - getSpecificPlayer(player):getSquare():getZ()) < 2) or 0
		local dist = math.sqrt(dx*dx + dy*dy) or 5
        if not objTextureName then return end
        if npcName ~= "Unconfigured NPC" and dist < 2 and zGood then
          local npcInteractMenu = context:addOption(interactText..npcName, npcName, onCreateGenericNPCUI, obj)
            if isAdmin() then
              local npcInteractSubMenu = ISContextMenu:getNew(context);
              context:addSubMenu(npcInteractMenu, npcInteractSubMenu);
              local npcOption = npcInteractSubMenu:addOption("Configuration", nil, nil);
              local npcSubMenu = ISContextMenu:getNew(npcInteractSubMenu)
              npcInteractSubMenu:addSubMenu(npcOption, npcSubMenu)
              npcSubMenu:addOption("Make interactive", nil, onNPCCustomize, obj)
            end
            --context:addOption(interactText..npcName, npcName, onCreateGenericNPCUI, obj)
            return
        end
        --print(obj:getTextureName())
    end
end

Events.OnFillWorldObjectContextMenu.Add(npcMenu)
local function loadDiceStats()
  local player = getPlayer()
  local modData = player:getModData()
  if not modData['_DiceSkills'] then modData['_DiceSkills'] = {
    ["Contest"] = {
      ["Strength"]        = 0,
      ["Accuracy"]        = 0,
      ["Melee"]           = 0,
      ["Toughness"]       = 0,
      ["Evasion"]         = 0,
    },
    ["Dexterity"] = {
      ["Dexterity"]       = 0,
      ["Agility"]         = 0,
      ["Sleight of Hand"] = 0,
      ["Stealth"]         = 0,
    },
    ["Intelligence"] = {
      ["Intelligence"]    = 0,
      ["Perception"]      = 0,
      ["Willpower"]       = 0,
      ["Wisdom"]          = 0,
    },
    ["Charisma"] = {
      ["Charisma"]        = 0,
      ["Deception"]       = 0,
      ["Insight"]         = 0,
      ["Persuasion"]      = 0,
    },
    ["Luck"] = {
      ["Luck"]        = 0,
      ["Deception"]       = 0,
      ["Insight"]         = 0,
      ["Persuasion"]      = 0,
    },
    };
  end
end
local function statPrint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "\r\n"
  indent = indent + 1
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint .. k
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. "\r\n"
    elseif (type(v) == "string") then
      toprint = "" .. toprint .. v .. "\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2)
    else
      toprint = toprint .. "" .. tostring(v) .. "_\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. " "
  return toprint
end
local function diceLines(str)
  local result = {}
  for line in str:gmatch '[^\n]+' do
    table.insert(result, line)
  end
  return result
end
local diceUI
function openDiceSkillsUI()
  loadDiceStats()
  diceUI = NewUI();
  diceUI:setTitle("Buffy Dice");
  diceUI:setWidthPercent(0.50)
  diceUI:addText("header", "hello world", "large", "center")
  diceUI:nextLine();
  diceUI:addScrollList("tableContents", diceLines(statPrint(getPlayer():getModData()['_DiceSkills'])))
  diceUI["tableContents"]:setItems(diceLines(statPrint(getPlayer():getModData()['_DiceSkills'])))
  diceUI:saveLayout();

  end