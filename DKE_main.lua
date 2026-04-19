local _, _, classId = UnitClass("player")
if classId ~= 6 then return end

DKE_settings = DKE_settings or {}
local DKE_soundEnabled     = (DKE_settings.soundEnabled ~= false)
local DKE_GLOBAL_CD        = 12
local DKE_OVERRIDE_CD      = 3
local DKE_lastSoundTime    = 0
local DKE_lastOverrideTime = 0

local function CanPlay(override)
    local now = GetTime()
    if override then
        if now - DKE_lastOverrideTime < DKE_OVERRIDE_CD then return false end
        DKE_lastOverrideTime = now
        return true
    end
    if now - DKE_lastSoundTime < DKE_GLOBAL_CD then return false end
    DKE_lastSoundTime = now
    return true
end

local function PlayRandom(category, override)
    if not DKE_soundEnabled then return end
    if not CanPlay(override) then return end
    local sounds = DKE_Sounds[category]
    if not sounds or #sounds == 0 then return end
    local totalWeight = 0
    for _, s in ipairs(sounds) do totalWeight = totalWeight + (s[2] or 1) end
    local roll = math.random() * totalWeight
    local cum  = 0
    for _, s in ipairs(sounds) do
        cum = cum + (s[2] or 1)
        if roll <= cum then
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
    },
    AGGRO = {
        { "aggroed\\deathcomesall.ogg",      1 }, { "aggroed\\comeforth.ogg",          1 },
        { "aggroed\\youboldtochallenge.ogg", 1 }, { "aggroed\\facemethen.ogg",         1 },
        { "aggroed\\scourgewillprevail.ogg", 1 }, { "aggroed\\worthyopponent.ogg",     1 },
    },
    DEATH = {
        { "death\\thiscantbe.ogg",     3 }, { "death\\impossible.ogg",     3 },
        { "death\\weakened.ogg",       1 }, { "death\\fallenagain.ogg",    1 },
        { "death\\notyetdefeated.ogg", 1 },
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
    },
    AFKEND = {
        { "afkend\\enoughrest.ogg",        2 }, { "afkend\\timetomarch.ogg",       2 },
        { "afkend\\backtobusiness.ogg",    1 }, { "afkend\\finallyreturned.ogg",   1 },
        { "afkend\\thescourgeawakens.ogg", 1 },
    },
    ARMY = {
        { "army\\risemylieges.ogg",    1 }, { "army\\armyofdead.ogg",      1 },
        { "army\\scourgecommands.ogg", 1 },
    },
    RAISE = {
        { "raise\\raisedead.ogg", 1 }, { "raise\\serveyourmaster.ogg", 1 },
    },
    ATTACK = {
        { "attack\\frostmournehungers.ogg", 1 }, { "attack\\youwillserve.ogg",      1 },
        { "attack\\yoursoulmismine.ogg",    1 }, { "attack\\diecreature.ogg",       1 },
        { "attack\\nonecanstopme.ogg",      1 }, { "attack\\feelmywrath.ogg",       1 },
        { "attack\\enoughtalking.ogg",      1 }, { "attack\\ihavenoweakness.ogg",   1 },
    },
}

local prevCombat     = false
local prevDead       = false
local prevMounted    = false
local prevAFK        = false
local prevTargetSelf = false
local prevPet        = false

-- Buff polling: yeni buff gorununce ses calar
-- spellID -> { cat, override, prob }
--local BUFF_WATCH = {
    --[51271]  = { cat = "ATTACK", override = false, prob = 0.7 }, -- Pillar of Frost
    --[47568]  = { cat = "ATTACK", override = false, prob = 0.7 }, -- Empower Rune Weapon
    --[195181] = { cat = "ATTACK", override = false, prob = 0.7 }, -- Bone Shield
    --[51124]  = { cat = "ATTACK", override = false, prob = 0.5 }, -- Killing Machine (proc)
   -- [81340]  = { cat = "ATTACK", override = false, prob = 0.5 }, -- Sudden Doom (proc)
   -- [42650]  = { cat = "ARMY",   override = true,  prob = 1.0 }, -- Army of the Dead aura
--}
local buffActive = {}

local function GetAura(spellID)
    if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
        local ok, info = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
        if ok and info then return true end
    end
    local ok, name = pcall(UnitBuff, "player", spellID)
    if ok and name then return true end
    return false
end

local pollTimer = 0
local POLL = 0.2

-- Hic RegisterEvent yok, hic GetSpellCooldown yok
local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", function(_, elapsed)
    pollTimer = pollTimer + elapsed
    if pollTimer < POLL then return end
    pollTimer = 0

    if not DKE_soundEnabled then return end

    local inCombat = InCombatLockdown()
    if inCombat and not prevCombat then
        prevCombat = true
        if math.random() <= 0.33 then PlayRandom("AGGRO", false) end
    elseif not inCombat then
        prevCombat = false
    end

    local isDead = UnitIsDeadOrGhost("player")
    if isDead and not prevDead then
        prevDead = true
        PlayRandom("DEATH", false)
    elseif not isDead and prevDead then
        prevDead = false
        PlayRandom("REVIVE", false)
    elseif not isDead then
        prevDead = false
    end

    local isMounted = IsMounted()
    if isMounted and not prevMounted then
        prevMounted = true
        PlayRandom("MOUNT", false)
    elseif not isMounted then
        prevMounted = false
    end

    local isAFK = UnitIsAFK("player")
    if isAFK and not prevAFK then
        prevAFK = true
        PlayRandom("AFKSTART", false)
    elseif not isAFK and prevAFK then
        prevAFK = false
        PlayRandom("AFKEND", false)
    end

    local targetSelf = UnitExists("target") and UnitIsUnit("target", "player")
    if targetSelf and not prevTargetSelf then
        prevTargetSelf = true
        PlayRandom("SELECT", false)
    elseif not targetSelf then
        prevTargetSelf = false
    end

    -- Raise Dead: pet yokken pet gelirse ses
    local hasPet = UnitExists("pet")
    if hasPet and not prevPet then
        prevPet = true
        if math.random() <= 0.75 then PlayRandom("RAISE", false) end
    elseif not hasPet then
        prevPet = false
    end

    -- Buff polling: yeni buff gorununce saldiri/army sesi
    --for spellID, info in pairs(BUFF_WATCH) do
        --local isActive = GetAura(spellID)
       -- local wasActive = buffActive[spellID]
       -- if isActive and not wasActive then
           -- buffActive[spellID] = true
           -- if math.random() <= info.prob then
            --    PlayRandom(info.cat, info.override)
           -- end
      --  elseif not isActive then
            buffActive[spellID] = false
      --  end
   -- end
end)

local AttackSpells = {
    [49143]=true,[49020]=true,[49184]=true,[47541]=true,[55090]=true,
    [50842]=true,[207311]=true,[195292]=true,[206930]=true,[195182]=true,
    [220143]=true,[43265]=true,[49998]=true,[51271]=true,[49206]=true,[63560]=true,
}

-- Action bar binding adi → GetActionInfo slot ofseti
local BAR_OFFSETS = {
    ACTIONBUTTON          = 0,   -- Ana bar  : slot 1-12
    MULTIACTIONBAR3BUTTON = 48,  -- Sag bar 1: slot 49-60
    MULTIACTIONBAR4BUTTON = 60,  -- Sag bar 2: slot 61-72
    MULTIACTIONBAR2BUTTON = 72,  -- Alt bar 2: slot 73-84
    MULTIACTIONBAR1BUTTON = 84,  -- Alt bar 1: slot 85-96
}

-- Tusa basilan tuşun hangi spell'e karsilik geldigini döndürür
local function SpellFromKey(key)
    local mod = ""
    if IsShiftKeyDown   and IsShiftKeyDown()   then mod = "SHIFT-" .. mod end
    if IsControlKeyDown and IsControlKeyDown() then mod = "CTRL-"  .. mod end
    if IsAltKeyDown     and IsAltKeyDown()     then mod = "ALT-"   .. mod end

    local ok, action = pcall(GetBindingAction, mod .. key, false)
    if not ok or not action or action == "" then return nil end

    for barName, offset in pairs(BAR_OFFSETS) do
        local n = action:match("^" .. barName .. "(%d+)$")
        if n then
            local ok2, aType, id = pcall(GetActionInfo, offset + tonumber(n))
            if ok2 and aType == "spell" and id then return id end
        end
    end
    return nil
end

-- Klavye dinleyici: RegisterEvent yok, taint yok
local keyFrame = CreateFrame("Frame", nil, UIParent)
keyFrame:SetAllPoints()
keyFrame:EnableKeyboard(true)
keyFrame:SetPropagateKeyboardInput(true)  -- tuş oyuna geçmeye devam eder
keyFrame:SetScript("OnKeyDown", function(_, key)
    if not DKE_soundEnabled then return end
    local spellID = SpellFromKey(key)
    if not spellID then return end

    if spellID == 42650 then
        PlayRandom("ARMY", true)
    elseif spellID == 46584 or spellID == 61999 then
        if math.random() <= 0.75 then PlayRandom("RAISE", false) end
    elseif AttackSpells[spellID] then
        if math.random() <= 0.40 then PlayRandom("ATTACK", false) end
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
    else
        print("|cffC41E3ADeathKnightExperience|r: Kullanim: /dke on  |  /dke off")
    end
end
