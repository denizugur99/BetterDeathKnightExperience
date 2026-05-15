local _, _, classId = UnitClass("player")
if classId ~= 6 then return end

DKE_settings = DKE_settings or {}
local DKE_soundEnabled  = (DKE_settings.soundEnabled ~= false)
local DKE_debugEnabled  = false
local DKE_GLOBAL_CD     = DKE_settings.globalCD or 3
local DKE_lastSoundTime = 0

local function CanPlay()
    local now = GetTime()
    if now - DKE_lastSoundTime < DKE_GLOBAL_CD then return false end
    DKE_lastSoundTime = now
    return true
end

local lastPlayedInCategory = {}
local currentSoundHandle  = nil
local soundLockedUntil    = 0

local function PlayRandom(category, force, protectDuration)
    if not DKE_soundEnabled then return end
    local now = GetTime()
    if now < soundLockedUntil then return end
    if force then
        DKE_lastSoundTime = now
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
            if currentSoundHandle then pcall(StopSound, currentSoundHandle) end
            local ok, success, handle = pcall(PlaySoundFile,
                "Interface\\AddOns\\DeathKnightExperience\\sounds\\" .. s[1],
                "Dialog")
            currentSoundHandle = (ok and success) and handle or nil
            if protectDuration then soundLockedUntil = GetTime() + protectDuration end
            return
        end
    end
end

DKE_Sounds = {
    LOGIN = {
        { "login\\login.ogg", 1 },
    },
    SELECT = {
        { "select\\select-1.ogg", 1 }, { "select\\select-2.ogg", 1 },
        { "select\\select_3.ogg", 1 },
    },
    AGGRO = {
        { "aggroed\\aggro.ogg", 1 },
    },
    DEATH = {
        { "death\\death.ogg",   1 }, { "death\\death_2.ogg", 1 },
        { "death\\death_3.ogg", 1 }, { "death\\death-4.ogg", 1 },
    },
    REVIVE = {
        { "revived\\revive.ogg", 1 },
    },
    MOUNT = {
        { "mount\\mount_1.ogg", 1 }, { "mount\\mount_2.ogg", 1 },
    },
    AFKSTART = {
        { "afkstart\\afkstart.ogg", 1 }, { "afkstart\\idle.ogg", 1 },
    },
    AFKEND = {
        { "afkend\\afkend.ogg", 1 },
    },
    -- ATTACK = {
    --     { "attack\\attack.ogg", 1 },
    -- },
    RAISE = {
        { "raise\\raise_dead.ogg", 1 }, { "raise\\raise_dke.ogg",  1 },
        { "raise\\raise2_dke.ogg", 1 },
    },
    ASPHYXIATE = {
        { "asphyxiate\\asphyxiate.ogg", 1 },
    },
    BLINDING_SLEET = {
        { "blinding_sleet\\blinding_sleet.ogg", 1 },
    },
    BREATH = {
        { "breath_of_syndragosa\\breath_of_sindragosa.ogg", 1 },
    },
    DEATH_STRIKE = {
        { "death_strike\\death_strike.ogg", 1 },
    },
    DAD = {
        { "deathanddecay\\death_and_decay.ogg", 1 },
    },
    DEATHGATE = {
        { "deathgate\\death_gate.ogg", 1 },
    },
    DEATHGRIP = {
        { "deathgrip\\death_grip_1.ogg", 1 }, { "deathgrip\\death_grip_2.ogg", 1 },
    },
    FROSTWYRM = {
        { "frostwrym_fury\\frostwyrm_fury.ogg", 1 },
    },
    LICHBORNE = {
        { "lichborne\\lichborne.ogg", 1 },
    },
    MIND_FREEZE = {
        { "mind_freeze\\mind_freeze.ogg", 1 }, { "mind_freeze\\mind_freeze_2.ogg", 1 },
    },
    PILLAR = {
        { "pillar_of_frost\\pillar_of_frost.ogg", 1 },
    },
    RAISE_ALLY = {
        { "raise_ally\\raise_ally.ogg", 1 },
    },
    CHAIN_OF_ICE = {
        { "chainofice\\chains_of_ice.ogg", 1 },
    },
}

local SpellNameToID = {
    ["Raise Dead"]             = 46585,
    ["Frost Strike"]           = 49143,
    ["Obliterate"]             = 49020,
    ["Scourge Strike"]         = 55090,
    ["Pillar of Frost"]        = 51271,
    ["Death Strike"]           = 49998,
    ["Death Coil"]             = 47541,
    ["Death and Decay"]        = 43265,
    ["Summon Gargoyle"]        = 49206,
    ["Howling Blast"]          = 49184,
    ["Death Grip"]             = 49576,
    ["Asphyxiate"]             = 108194,
    ["Blinding Sleet"]         = 207167,
    ["Breath of Sindragosa"]   = 152279,
    ["Death Gate"]             = 50977,
    ["Frostwyrm's Fury"]       = 1249658,
    ["Lichborne"]              = 49039,
    ["Mind Freeze"]            = 47528,
    ["Glacial Advance"]        = 194913,
    ["Frostscythe"]            = 207230,
    ["Chain of Ice"]            = 45524,
    -- ["Army of the Dead"]    = 42650,   -- no sound
    -- ["Commander of the Dead"] = 390260, -- no sound
    -- ["Apocalypse"]          = 220143,  -- no sound
    ["Raise Ally"]             = 61999,
}

local SpellToSound = {
    -- [42650]  = { cat = "ARMY",  ... }, -- Army of the Dead      (no sound)
    -- [390260] = { cat = "ARMY",  ... }, -- Commander of the Dead (no sound)
    -- [220143] = { cat = "ARMY",  ... }, -- Apocalypse            (no sound)
    [46585]  = { cat = "RAISE",        prob = 1.0, anyCombat = true }, -- Raise Dead
     
    --[49143]  = { cat = "ATTACK",       prob = 0.01  },                   -- Frost Strike
    --[49020]  = { cat = "ATTACK",       prob = 0.01  },                   -- Obliterate
    --[55090]  = { cat = "ATTACK",       prob = 0.01 },                   -- Scourge Strike
    [51271]  = { cat = "PILLAR",       prob = 1.0, cd = 44, anyCombat = true, protect = 6 }, -- Pillar of Frost
    [49576]  = { cat = "DEATHGRIP",    prob = 1.0  },                   -- Death Grip
    [49998]  = { cat = "DEATH_STRIKE", prob = 1.0, cd = 1 },             -- Death Strike
    [43265]  = { cat = "DAD",          prob = 1.0  },                   -- Death and Decay
    [108194] = { cat = "ASPHYXIATE",   prob = 1.0  },                   -- Asphyxiate
    [207167] = { cat = "BLINDING_SLEET", prob = 1.0 },                  -- Blinding Sleet
    [152279] = { cat = "BREATH",       prob = 1.0, cd = 89 },           -- Breath of Sindragosa
    [50977]  = { cat = "DEATHGATE",    prob = 1.0, anyCombat = true },  -- Death Gate
    [1249658] = { cat = "FROSTWYRM",    prob = 1.0, cd = 89, protect = 6 }, -- Frostwyrm's Fury
    [49039]  = { cat = "LICHBORNE",    prob = 1.0, anyCombat = true },  -- Lichborne
    [47528]  = { cat = "MIND_FREEZE",  prob = 1.0, cd = 14 },           -- Mind Freeze
    --[194913] = { cat = "ATTACK",       prob = 0.01  },                   -- Glacial Advance
  --  [207230] = { cat = "ATTACK",       prob = 0.01  },                   -- Frostscythe
    [61999] = { cat = "RAISE_ALLY",   prob = 1.0, anyCombat = true },  -- Raise Ally
    [45524] = { cat = "CHAIN_OF_ICE", prob = 1.0, cd = 12 },           -- Chain of Ice
}

-- local AttackSpells = {
--     [49184]=true, [47541]=true, [50842]=true, [207311]=true, [195292]=true,
--     [206930]=true, [195182]=true, [49206]=true, [63560]=true,
-- }


local spellLastPlayed = {}

local function HandleResolvedSpell(spellID)
    if not spellID then return end
    local info = SpellToSound[spellID]
    if not InCombatLockdown() and not (info and info.anyCombat) then return end
    if DKE_debugEnabled then
        print("|cffC41E3ADKE DEBUG|r key resolved spellID=" .. tostring(spellID))
    end
    if info then
        local now = GetTime()
        if info.cd and now - (spellLastPlayed[spellID] or 0) < info.cd then
            if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r spell on cooldown, skipped") end
            return
        end
        if math.random() <= info.prob then
            spellLastPlayed[spellID] = now
            PlayRandom(info.cat, info.cd ~= nil, info.protect)
        end
    elseif DKE_debugEnabled then
        print("|cffC41E3ADKE DEBUG|r not in list, to add: [" .. tostring(spellID) .. "]=true")
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
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r no binding found") end
        return nil
    end

    local slot = ResolveActionSlot(action)
    if not slot then
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r could not resolve slot: " .. tostring(action)) end
        return nil
    end

    local ok, aType, id = pcall(GetActionInfo, slot)
    if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r slot=" .. slot .. " type=" .. tostring(aType) .. " id=" .. tostring(id)) end
    if ok and aType == "spell" and id then return id end
    if ok and aType == "macro" and id then
        -- WoW Midnight: GetActionInfo returns spell ID directly for macros
        if DKE_debugEnabled then print("|cffC41E3ADKE DEBUG|r macro direct spellID=" .. id) end
        return id
    end
    return nil
end

local function RebuildMacroCache()
    macroSlotCache = {}
    local bodyFn = GetMacroBody or (C_Macro and C_Macro.GetMacroBody)
    if not bodyFn then return end
    local count = 0
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
                                count = count + 1
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if DKE_debugEnabled then
        print("|cffC41E3ADKE DEBUG|r macro cache rebuilt: " .. count .. " slots")
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
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    local now = time()
    if not DKE_settings.lastLoginSound or now - DKE_settings.lastLoginSound >= 3600 then
        DKE_settings.lastLoginSound = now
        PlayRandom("LOGIN")
    end
end)
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
        print("|cffC41E3ADeathKnightExperience|r: Sound |cff00FF00enabled|r.")
    elseif cmd == "off" then
        DKE_soundEnabled = false
        DKE_settings.soundEnabled = false
        print("|cffC41E3ADeathKnightExperience|r: Sound |cffFF0000disabled|r.")
    elseif cmd == "debug" then
        DKE_debugEnabled = not DKE_debugEnabled
        print("|cffC41E3ADeathKnightExperience|r: Debug " .. (DKE_debugEnabled and "|cff00FF00on|r" or "|cffFF0000off|r") .. ".")
    elseif cmd:match("^cd %d+$") then
        local val = tonumber(cmd:match("%d+"))
        DKE_GLOBAL_CD = val
        DKE_settings.globalCD = val
        print("|cffC41E3ADeathKnightExperience|r: Global CD set to |cffFFFF00" .. val .. "|r seconds.")
    else
        print("|cffC41E3ADeathKnightExperience|r: Usage: /dke on | /dke off | /dke debug | /dke cd <seconds>")
    end
end

RebuildMacroCache()
