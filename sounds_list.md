# DeathKnightExperience - Sound Files & Probability Table

All files must be in **.ogg** format. Sound channel: **Dialog**.

**System rules:**
- Global cooldown between any two sounds: **14 seconds**
- CD spells (force sounds) minimum gap: **3 seconds**
- Same file repeat penalty within a category: **10% weight**

---

## Probability Table

### Event-Triggered Sounds

| Event | Category | Chance | Notes |
|-------|----------|--------|-------|
| Entering world | LOGIN | 100% | Fires on `PLAYER_ENTERING_WORLD` |
| Targeting self | SELECT | 100% | |
| Entering combat | AGGRO | 33% | |
| Death | DEATH | 100% | |
| Revive | REVIVE | 100% | |
| Mount | MOUNT | 100% | |
| Going AFK | AFKSTART | 100% | |
| Returning from AFK | AFKEND | 100% | |
| Pet summoned | RAISE | 75% | |

### Spell-Triggered Sounds

| Spell | Category | Chance | Notes |
|-------|----------|--------|-------|
| Raise Dead | RAISE | 75% | Works out of combat |
| Raise Ally | RAISE_ALLY | 100% | Works out of combat |
| Death Grip | DEATHGRIP | 100% | |
| Death Strike | DEATH_STRIKE | 100% | |
| Death and Decay | DAD | 100% | |
| Asphyxiate | ASPHYXIATE | 100% | |
| Blinding Sleet | BLINDING_SLEET | 100% | |
| Mind Freeze | MIND_FREEZE | 100% | |
| Pillar of Frost | PILLAR | 100% | Force sound, CD: 44s |
| Breath of Sindragosa | BREATH | 100% | Force sound, CD: 89s |
| Frostwyrm's Fury | FROSTWYRM | 100% | Force sound, CD: 89s |
| Lichborne | LICHBORNE | 100% | Works out of combat |
| Death Gate | DEATHGATE | 100% | Works out of combat |
| Frost Strike | ATTACK | 10% | |
| Obliterate | ATTACK | 10% | |
| Scourge Strike | ATTACK | 10% | |
| Glacial Advance | ATTACK | 10% | |
| Frostscythe | ATTACK | 10% | |
| Other attack spells | ATTACK | 40% | Generic fallback |

### No Sound Yet

| Spell |
|-------|
| Army of the Dead |
| Commander of the Dead |
| Apocalypse |

---

## Sound Files

### sounds/login/
| File | Description |
|------|-------------|
| login.ogg | Login / entering world |

### sounds/select/
| File |
|------|
| select-1.ogg |
| select-2.ogg |
| select_3.ogg |

### sounds/aggroed/
| File |
|------|
| aggro.ogg |

### sounds/death/
| File |
|------|
| death.ogg |
| death_2.ogg |
| death_3.ogg |
| death-4.ogg |

### sounds/revived/
| File |
|------|
| revive.ogg |

### sounds/mount/
| File |
|------|
| mount_1.ogg |
| mount_2.ogg |

### sounds/afkstart/
| File |
|------|
| afkstart.ogg |
| idle.ogg |

### sounds/afkend/
| File |
|------|
| afkend.ogg |

### sounds/attack/
| File |
|------|
| attack.ogg |

### sounds/raise/
| File |
|------|
| raise_dead.ogg |
| raise_dke.ogg |
| raise2_dke.ogg |

### sounds/raise_ally/
| File |
|------|
| raise_ally.ogg |

### sounds/deathgrip/
| File |
|------|
| death_grip_1.ogg |
| death_grip_2.ogg |

### sounds/death_strike/
| File |
|------|
| death_strike.ogg |

### sounds/deathanddecay/
| File |
|------|
| death_and_decay.ogg |

### sounds/asphyxiate/
| File |
|------|
| asphyxiate.ogg |

### sounds/blinding_sleet/
| File |
|------|
| blinding_sleet.ogg |

### sounds/mind_freeze/
| File |
|------|
| mind_freeze.ogg |
| mind_freeze_2.ogg |

### sounds/pillar_of_frost/
| File |
|------|
| pillar_of_frost.ogg |

### sounds/breath_of_syndragosa/
| File |
|------|
| breath_of_sindragosa.ogg |

### sounds/frostwrym_fury/
| File |
|------|
| frostwyrm_fury.ogg |

### sounds/lichborne/
| File |
|------|
| lichborne.ogg |

### sounds/deathgate/
| File |
|------|
| death_gate.ogg |
