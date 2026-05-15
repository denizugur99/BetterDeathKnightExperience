local _, _, classId = UnitClass("player")
if classId ~= 6 then return end

DKE_settings = DKE_settings or {}
local DKE_soundEnabled  = (DKE_settings.soundEnabled ~= false)
-- local DKE_debugEnabled  = false
local DKE_GLOBAL_CD     = DKE_settings.globalCD or 2
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
            -- if DKE_debugEnabled then
            --     print("|cffC41E3ADKE DEBUG|r playing: " .. s[1])
            -- end
            if currentSoundHandle then pcall(StopSound, currentSoundHandle) end
            local ok, success, handle = pcall(PlaySoundFile,
                "Interface\\AddOns\\BetterDeathKnightExperience\\sounds\\" .. s[1],
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
        { "afkstart\\afkstart.ogg", 1 }, { "afkstart\\idle.ogg", 1 },{ "afkstart\\afk.mp3", 1 },
    },
    AFKEND = {
        { "afkend\\afkend.ogg", 1 },
    },
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
    ARMY = {
        { "armyofdead\\army_of_the_dead.ogg", 1 },
    },
    DARKTRANSFORM = {
        { "darktransform\\dark_transformation.ogg", 1 },
    },
    DEATHS_ADVANCE = {
        { "deaths_advance\\deaths_advance_and_death_charge.ogg", 1 },
    },
    PUTREFY = {
        { "putrefy\\putrefy.ogg", 1 },
    },
    --SOUL_REAPER = {
    --    { "soulreaper\\soul_reaper.ogg", 1 },
    --},
}

local SpellToSound = {
    [42650]   = { cat = "ARMY",           prob = 1.0, force = true, anyCombat = true, protect = 6 }, -- Army of the Dead
    [1233448] = { cat = "DARKTRANSFORM",  prob = 1.0, force = true, anyCombat = true },              -- Dark Transformation
    [48265]   = { cat = "DEATHS_ADVANCE", prob = 1.0, anyCombat = true },                            -- Death's Advance
    [444347]  = { cat = "DEATHS_ADVANCE", prob = 1.0, anyCombat = true },                            -- Death Charge
    [1247378] = { cat = "PUTREFY",        prob = 1.0 },                                              -- Putrefy
    --[343294]= { cat = "SOUL_REAPER",    prob = 1.0 },                                              -- Soul Reaper
    [46585]   = { cat = "RAISE",          prob = 1.0, anyCombat = true },                            -- Raise Dead
    [51271]   = { cat = "PILLAR",         prob = 1.0, force = true, anyCombat = true },              -- Pillar of Frost
    [49576]   = { cat = "DEATHGRIP",      prob = 1.0 },                                              -- Death Grip
    [43265]   = { cat = "DAD",            prob = 1.0 },                                              -- Death and Decay
    [221562]  = { cat = "ASPHYXIATE",     prob = 1.0, force = true },                                -- Asphyxiate
    [207167]  = { cat = "BLINDING_SLEET", prob = 1.0, force = true },                                -- Blinding Sleet
    [1249658] = { cat = "BREATH",         prob = 1.0, force = true },                                -- Breath of Sindragosa
    [50977]   = { cat = "DEATHGATE",      prob = 1.0, anyCombat = true },                            -- Death Gate
    [279302]  = { cat = "FROSTWYRM",      prob = 1.0, force = true, anyCombat = true, protect = 6 }, -- Frostwyrm's Fury
    --[49039] = { cat = "LICHBORNE",      prob = 1.0, anyCombat = true },                            -- Lichborne
    [47528]   = { cat = "MIND_FREEZE",    prob = 1.0, force = true },                                -- Mind Freeze
    [61999]   = { cat = "RAISE_ALLY",     prob = 1.0, anyCombat = true },                            -- Raise Ally
    [45524]   = { cat = "CHAIN_OF_ICE",   prob = 1.0 },                                              -- Chain of Ice
}

local function HandleResolvedSpell(spellID)
    if not spellID then return end
    local info = SpellToSound[spellID]
    if not InCombatLockdown() and not (info and info.anyCombat) then return end
    -- if DKE_debugEnabled then
    --     print("|cffC41E3ADKE DEBUG|r spellID=" .. tostring(spellID))
    -- end
    if info then
        if math.random() <= info.prob then
            PlayRandom(info.cat, info.force, info.protect)
        end
    -- elseif DKE_debugEnabled then
    --     print("|cffC41E3ADKE DEBUG|r not in list: [" .. tostring(spellID) .. "]=true")
    end
end

local prevCombat     = false
local prevDead       = false
local prevMounted    = false
local prevAFK        = false
local prevTargetSelf = false
local prevPet        = false

local pollTimer       = 0
local POLL            = 0.2
local loginLastPlayed = nil

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:SetScript("OnEvent", function(_, event, unit, _, _, spellID)
    if event == "PLAYER_ENTERING_WORLD" then
        local now = GetTime()
        if not loginLastPlayed or now - loginLastPlayed >= 3600 then
            loginLastPlayed = now
            PlayRandom("LOGIN", true)
        end
    elseif event == "UNIT_SPELLCAST_SENT" and unit == "player" then
        HandleResolvedSpell(spellID)
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
        print("|cffFFFFFFBetter |r|cffC41E3ADeath Knight|r|cffFFFFFFExperience|r: Sound |cff00FF00enabled|r.")
    elseif cmd == "off" then
        DKE_soundEnabled = false
        DKE_settings.soundEnabled = false
        print("|cffFFFFFFBetter |r|cffC41E3ADeath Knight|r|cffFFFFFFExperience|r: Sound |cffFF0000disabled|r.")
    -- elseif cmd == "debug" then
    --     DKE_debugEnabled = not DKE_debugEnabled
    --     print("|cffFFFFFFBetter |r|cffC41E3ADeath Knight|r|cffFFFFFFExperience|r: Debug " .. (DKE_debugEnabled and "|cff00FF00on|r" or "|cffFF0000off|r") .. ".")
    elseif cmd:match("^cd %d+$") then
        local val = tonumber(cmd:match("%d+"))
        DKE_GLOBAL_CD = val
        DKE_settings.globalCD = val
        print("|cffFFFFFFBetter |r|cffC41E3ADeath Knight|r|cffFFFFFFExperience|r: Global CD set to |cffFFFF00" .. val .. "|r seconds.")
    else
        print("|cffFFFFFFBetter |r|cffC41E3ADeath Knight|r|cffFFFFFFExperience|r: Usage: /dke on | /dke off | /dke debug | /dke cd <seconds>")
    end
end
