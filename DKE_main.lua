local _, _, classId = UnitClass("player")
if classId ~= 6 then return end

DKE_settings = DKE_settings or {}
local DKE_soundEnabled  = (DKE_settings.soundEnabled ~= false)
local DKE_debugEnabled  = false
local DKE_GLOBAL_CD     = 0
local DKE_lastSoundTime = 0

local function CanPlay()
    local now = GetTime()
    if now - DKE_lastSoundTime < DKE_GLOBAL_CD then return false end
    DKE_lastSoundTime = now
    return true
end

local lastPlayedInCategory = {}

local function PlayRandom(category, force)
    if not DKE_soundEnabled then return end
    if force then
        DKE_lastSoundTime = GetTime()
    elseif not CanPlay() then
        return
    end
    local sounds = DKE_Sounds[category]
    if not sounds or #sounds == 0 then return end
    local lastPlayed = lastPlayedInCategory[category]
    local totalWeight = 0
    for _, s in ipairs(sounds) do
        local w = (s[2] or 1) * (s[1] == lastPlayed and 0.1 or 1)
        totalWeight = totalWeight + w
    end
    local roll = math.random() * totalWeight
    local cum  = 0
    for _, s in ipairs(sounds) do
        local w = (s[2] or 1) * (s[1] == lastPlayed and 0.1 or 1)
        cum = cum + w
        if roll <= cum then
            lastPlayedInCategory[category] = s[1]
            if DKE_debugEnabled then
                print("|cffC41E3ADKE DEBUG|r playing: " .. s[1])
            end
            pcall(PlaySoundFile,
                "Interface\\AddOns\\DeathKnightExperience\\sounds\\" .. s[1],
                "Master")
            return
        end
    end
end

DKE_Sounds = {
    SELECT = {
        { "select\\lichking.ogg",            7 }, { "select\\frostmourne.ogg",         7 },
        { "select\\servemeindeath.ogg",      7 }, { "select\\soulmismine.ogg",         1 },
        { "select\\freezeblood.ogg",         1 }, { "select\\beyondcomprehension.ogg", 1 },
        { "select\\youcantescapeme.ogg",     1 }, { "select\\nothingyoucando.ogg",     1 },
        { "select\\select_dke.ogg",          1 },
    },
    AGGRO = {
        { "aggroed\\deathcomesall.ogg",      1 }, { "aggroed\\comeforth.ogg",          1 },
        { "aggroed\\youboldtochallenge.ogg", 1 }, { "aggroed\\facemethen.ogg",         1 },
        { "aggroed\\scourgewillprevail.ogg", 1 }, { "aggroed\\worthyopponent.ogg",     1 },
    },
    DEATH = {
        { "death\\thiscantbe.ogg",     3 }, { "death\\impossible.ogg",     3 },
        { "death\\weakened.ogg",       1 }, { "death\\fallenagain.ogg",    1 },
        { "death\\notyetdefeated.ogg", 1 }, { "death\\death_dke.ogg",      1 },
    },
    REVIVE = {
        { "revived\\returnfromdead.ogg",  1 }, { "revived\\deathcantholme.ogg",  1 },
        { "revived\\riseagain.ogg",       1 }, { "revived\\lichkingcantdie.ogg", 1 },
    },
    MOUNT = {
        { "mount\\onward.ogg",           1 }, { "mount\\advance.ogg",          1 },
        { "mount\\ridefrostedearth.ogg", 1 }, { "mount\\forthelichking.ogg",   1 },
    },
    AFKSTART = {
        { "afkstart\\watchclosely.ogg",    1 }, { "afkstart\\waitingforyou.ogg",   1 },
        { "afkstart\\contemplating.ogg",   1 }, { "afkstart\\endlesspatience.ogg", 1 },
        { "afkstart\\idle_dke.ogg",        1 },
    },
    AFKEND = {
        { "afkend\\enoughrest.ogg",        2 }, { "afkend\\timetomarch.ogg",       2 },
        { "afkend\\backtobusiness.ogg",    1 }, { "afkend\\finallyreturned.ogg",   1 },
        { "afkend\\thescourgeawakens.ogg", 1 },
    },
    ARMY = {
        { "army\\risemylieges.ogg",    1 }, { "army\\armyofdead.ogg",      1 },
        { "army\\scourgecommands.ogg", 1 }, { "army\\apocalypse.ogg",      1 },
    },
    RAISE = {
        { "raise\\raisedead.ogg", 1 }, { "raise\\serveyourmaster.ogg", 1 },
        { "raise\\raise_dke.ogg", 1 }, { "raise\\raise2_dke.ogg",      1 },
    },
    ATTACK = {
        { "attack\\frostmournehungers.ogg", 1 }, { "attack\\youwillserve.ogg",      1 },
        { "attack\\yoursoulmismine.ogg",    1 }, { "attack\\diecreature.ogg",       1 },
        { "attack\\nonecanstopme.ogg",      1 }, { "attack\\feelmywrath.ogg",       1 },
        { "attack\\enoughtalking.ogg",      1 }, { "attack\\ihavenoweakness.ogg",   1 },
        { "attack\\grip1_dke.ogg",          1 },
    },
}

local SpellNameToID = {
    ["Army of the Dead"]      = 42650,
    ["Commander of the Dead"] = 390260,
    ["Raise Dead"]            = 46584,
    ["Frost Strike"]          = 49143,
    ["Obliterate"]            = 49020,
    ["Scourge Strike"]        = 55090,
    ["Pillar of Frost"]       = 51271,
    ["Death Strike"]          = 49998,
    ["Death Coil"]            = 47541,
    ["Death and Decay"]       = 43265,
    ["Summon Gargoyle"]       = 49206,
    ["Howling Blast"]         = 49184,
    ["Death Grip"]            = 49576,
    ["Apocalypse"]            = 220143,
}

local SpellToSound = {
    [42650]  = { cat = "ARMY",   prob = 1.0  }, -- Army of the Dead
    [390260] = { cat = "ARMY",   prob = 1.0  }, -- Commander of the Dead
    [46584]  = { cat = "RAISE",  prob = 0.75 }, -- Raise Dead
    [61999]  = { cat = "RAISE",  prob = 0.75 }, -- Raise Dead (alt)
    [49143]  = { cat = "ATTACK", prob = 0.3  }, -- Frost Strike
    [49020]  = { cat = "ATTACK", prob = 0.3  }, -- Obliterate
    [55090]  = { cat = "ATTACK", prob = 0.3  }, -- Scourge Strike
    [51271]  = { cat = "ATTACK", prob = 1.0, cd = 45 }, -- Pillar of Frost
    [49576]  = { cat = "ATTACK", prob = 0.5  },          -- Death Grip
    [220143] = { cat = "ARMY",   prob = 0.8  },          -- Apocalypse
}

local AttackSpells = {
    [49184]=true, [47541]=true, [50842]=true, [207311]=true, [195292]=true,
    [206930]=true, [195182]=true, [43265]=true, [49998]=true,
    [49206]=true, [63560]=true,
}


local spellLastPlayed = {}

local function HandleResolvedSpell(spellID)
    if not spellID then return end
    if not InCombatLockdown() then return end
    if DKE_debugEnabled then
        print("|cffC41E3ADKE DEBUG|r key resolved spellID=" .. tostring(spellID))
    end
    local info = SpellToSound[spellID]
    if info then
        local now = GetTime()
        if info.cd and now - (spellLastPlayed[spellID] or 0) < info.cd then
            if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r spell CD'de, atlandi") end
            return
        end
        if math.random() <= info.prob then
            spellLastPlayed[spellID] = now
            PlayRandom(info.cat, info.cd ~= nil)
        end
    elseif AttackSpells[spellID] then
        if math.random() <= 0.4 then
            PlayRandom("ATTACK")
        end
    elseif DKE_debugEnabled then
        print("|cffC41E3ADKE DEBUG|r listede yok, eklemek icin: [" .. tostring(spellID) .. "]=true")
    end
end

local BAR_OFFSETS = {
    ACTIONBUTTON          = 0,
    MULTIACTIONBAR3BUTTON = 48,
    MULTIACTIONBAR4BUTTON = 60,
    MULTIACTIONBAR2BUTTON = 72,
    MULTIACTIONBAR1BUTTON = 84,
    BONUSACTIONBUTTON     = 120,
}

local BAR_FRAME_PREFIX = {
    ACTIONBUTTON          = "ActionButton",
    MULTIACTIONBAR1BUTTON = "MultiBarBottomLeftButton",
    MULTIACTIONBAR2BUTTON = "MultiBarBottomRightButton",
    MULTIACTIONBAR3BUTTON = "MultiBarRightButton",
    MULTIACTIONBAR4BUTTON = "MultiBarLeftButton",
    BONUSACTIONBUTTON     = "BonusActionButton",
}

local function ResolveActionSlot(action)
    if not action or action == "" then return nil end
    for barName, framePrefix in pairs(BAR_FRAME_PREFIX) do
        local n = action:match("^" .. barName .. "(%d+)$")
        if n then
            local button = _G and _G[framePrefix .. n]
            if button then
                local slot = button.action
                if type(slot) == "number" and slot > 0 then return slot end
            end
        end
    end
    for barName, offset in pairs(BAR_OFFSETS) do
        local n = action:match("^" .. barName .. "(%d+)$")
        if n then return offset + tonumber(n) end
    end
    return nil
end

local macroSlotCache = {}

local function SpellFromKey(key)
    local mod = ""
    if IsShiftKeyDown   and IsShiftKeyDown()   then mod = "SHIFT-" .. mod end
    if IsControlKeyDown and IsControlKeyDown() then mod = "CTRL-"  .. mod end
    if IsAltKeyDown     and IsAltKeyDown()     then mod = "ALT-"   .. mod end

    local shiftedToBase = {
        ["!"]="1",["@"]="2",["#"]="3",["$"]="4",["%"]="5",
        ["^"]="6",["&"]="7",["*"]="8",["("]="9",[")"]="0",
        ["_"]="-",["+"]=  "=",["{"]=  "[",["}"]="]",["|"]="\\",
        [":"]=";",['\"']="'",["<"]=",",[">"]=".",["?"]="/",["'"]=  "2",
    }

    local tried = {}
    local candidates = { key, string.upper(key or ""), string.lower(key or "") }
    local base = shiftedToBase[key]
    if base then
        table.insert(candidates, base)
        table.insert(candidates, string.upper(base))
        table.insert(candidates, string.lower(base))
    end

    local action
    for _, c in ipairs(candidates) do
        if c and c ~= "" and not tried[c] then
            tried[c] = true
            local ok1, found1 = pcall(GetBindingAction, mod .. c, false)
            if ok1 and found1 and found1 ~= "" then action = found1; break end
            local ok2, found2 = pcall(GetBindingAction, mod .. c, true)
            if ok2 and found2 and found2 ~= "" then action = found2; break end
        end
    end
    if not action then
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r binding bulunamadi") end
        return nil
    end

    local slot = ResolveActionSlot(action)
    if not slot then
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r slot cozulemedi: " .. tostring(action)) end
        return nil
    end

    local ok, aType, id = pcall(GetActionInfo, slot)
    if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r slot=" .. slot .. " type=" .. tostring(aType) .. " id=" .. tostring(id)) end
    if ok and aType == "spell" and id then return id end
    if ok and aType == "macro" and id then
        -- WoW Midnight: GetActionInfo macro icin dogrudan spell ID donduruyor
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r macro direct spellID=" .. id) end
        return id
    end
    return nil
end

local function RebuildMacroCache()
    macroSlotCache = {}
    local bodyFn = GetMacroBody or (C_Macro and C_Macro.GetMacroBody)
    if not bodyFn then return end
    for _, offset in pairs(BAR_OFFSETS) do
        for i = 1, 12 do
            local slot = offset + i
            local ok, aType, macroID = pcall(GetActionInfo, slot)
            if ok and aType == "macro" and macroID then
                local ok2, body = pcall(bodyFn, macroID)
                if ok2 and body then
                    for line in body:gmatch("[^\n]+") do
                        local castStr = line:match("^%s*/cast%s+(.+)$") or line:match("^%s*/use%s+(.+)$")
                        if castStr then
                            local spellName = castStr:gsub("%b[]", ""):match("^%s*(.-)%s*$")
                            local sID = spellName and SpellNameToID[spellName]
                            if sID then
                                macroSlotCache[slot] = sID
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if DKE_debugEnabled then
        local count = 0
        for _ in pairs(macroSlotCache) do count = count + 1 end
        print("|cffC41E3ADKE DEBUG|r macro cache rebuild: " .. count .. " slot")
    end
end

local MOUSE_TO_BIND_KEY = {
    LeftButton="BUTTON1", RightButton="BUTTON2", MiddleButton="BUTTON3",
    Button4="BUTTON4", Button5="BUTTON5",
}

local keyFrame = CreateFrame("Frame", nil, UIParent)
keyFrame:SetAllPoints()
keyFrame:EnableKeyboard(true)
keyFrame:EnableMouse(true)
keyFrame:SetPropagateKeyboardInput(true)
if keyFrame.SetPropagateMouseClicks then keyFrame:SetPropagateMouseClicks(true) end


keyFrame:SetScript("OnKeyDown", function(_, key)
    if not DKE_soundEnabled then return end
    HandleResolvedSpell(SpellFromKey(key))
end)

keyFrame:SetScript("OnMouseDown", function(_, button)
    if not DKE_soundEnabled then return end
    HandleResolvedSpell(SpellFromKey(MOUSE_TO_BIND_KEY[button] or button))
end)

local prevCombat     = false
local prevDead       = false
local prevMounted    = false
local prevAFK        = false
local prevTargetSelf = false
local prevPet        = false

local pollTimer = 0
local POLL = 0.2

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", function(_, elapsed)
    pollTimer = pollTimer + elapsed
    if pollTimer < POLL then return end
    pollTimer = 0

    if not DKE_soundEnabled then return end

    local isDead = UnitIsDeadOrGhost("player")
    if isDead and not prevDead then
        prevDead = true
        PlayRandom("DEATH")
    elseif not isDead and prevDead then
        prevDead = false
        PlayRandom("REVIVE")
    else
        prevDead = isDead
    end

    if not isDead then
        local inCombat = InCombatLockdown()
        if inCombat and not prevCombat then
            prevCombat = true
            if math.random() <= 0.33 then PlayRandom("AGGRO") end
        elseif not inCombat then
            if prevCombat then RebuildMacroCache() end
            prevCombat = false
        end

        local isMounted = IsMounted()
        if isMounted and not prevMounted then
            prevMounted = true
            PlayRandom("MOUNT")
        elseif not isMounted then
            prevMounted = false
        end

        local isAFK = UnitIsAFK("player")
        if isAFK and not prevAFK then
            prevAFK = true
            PlayRandom("AFKSTART")
        elseif not isAFK and prevAFK then
            prevAFK = false
            PlayRandom("AFKEND")
        end

        local targetSelf = UnitExists("target") and UnitIsUnit("target", "player")
        if targetSelf and not prevTargetSelf then
            prevTargetSelf = true
            PlayRandom("SELECT")
        elseif not targetSelf then
            prevTargetSelf = false
        end

        local hasPet = UnitExists("pet")
        if hasPet and not prevPet then
            prevPet = true
            if math.random() <= 0.75 then PlayRandom("RAISE") end
        elseif not hasPet then
            prevPet = false
        end
    end
end)

SLASH_DKE1 = "/dke"
SlashCmdList["DKE"] = function(msg)
    local cmd = string.lower(string.trim(msg or ""))
    if cmd == "on" then
        DKE_soundEnabled = true
        DKE_settings.soundEnabled = true
        print("|cffC41E3ADeathKnightExperience|r: Seslendirme |cff00FF00acik|r.")
    elseif cmd == "off" then
        DKE_soundEnabled = false
        DKE_settings.soundEnabled = false
        print("|cffC41E3ADeathKnightExperience|r: Seslendirme |cffFF0000kapali|r.")
    elseif cmd == "debug" then
        DKE_debugEnabled = not DKE_debugEnabled
        print("|cffC41E3ADeathKnightExperience|r: Debug " .. (DKE_debugEnabled and "|cff00FF00acik|r" or "|cffFF0000kapali|r") .. ".")
    else
        print("|cffC41E3ADeathKnightExperience|r: Kullanim: /dke on | /dke off | /dke debug")
    end
end

RebuildMacroCache()
