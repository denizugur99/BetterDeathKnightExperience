# DeathKnightExperience - Sound Files & Probability Table

All files must be in **.ogg** format. Sound channel: **Dialog**.

**System rules:**
- Global cooldown between any two sounds: **2 seconds** (configurable with `/dke cd`)
- Force spells (long cooldown abilities) bypass the global CD
- Same file repeat penalty within a category: **10% weight**

---

## Probability Table

### Event-Triggered Sounds

| Event | Category | Chance | Notes |
|-------|----------|--------|-------|
| Login / UI reload | LOGIN | 100% | At most once per hour |
| Targeting self | SELECT | 100% | |
| Entering combat | AGGRO | 33% | |
| Death | DEATH | 100% | |
| Revive | REVIVE | 100% | |
| Mount | MOUNT | 100% | |
| Going AFK | AFKSTART | 100% | |
| Returning from AFK | AFKEND | 100% | |
| Pet summoned | RAISE | 75% | |

### Spell-Triggered Sounds

| Spell | Category | Chance | Force | Out of Combat |
|-------|----------|--------|-------|---------------|
| Raise Dead | RAISE | 100% | — | Yes |
| Raise Ally | RAISE_ALLY | 100% | — | Yes |
| Army of the Dead | ARMY | 100% | Yes | Yes |
| Dark Transformation | DARKTRANSFORM | 100% | Yes | Yes |
| Death's Advance | DEATHS_ADVANCE | 100% | — | Yes |
| Death Charge | DEATHS_ADVANCE | 100% | — | Yes |
| Death Grip | DEATHGRIP | 100% | — | — |
| Death and Decay | DAD | 100% | — | — |
| Death Gate | DEATHGATE | 100% | — | Yes |
| Asphyxiate | ASPHYXIATE | 100% | Yes | — |
| Blinding Sleet | BLINDING_SLEET | 100% | Yes | — |
| Mind Freeze | MIND_FREEZE | 100% | Yes | — |
| Chain of Ice | CHAIN_OF_ICE | 100% | — | — |
| Putrefy | PUTREFY | 100% | — | — |
| Pillar of Frost | PILLAR | 100% | Yes | Yes |
| Breath of Sindragosa | BREATH | 100% | Yes | — |
| Frostwyrm's Fury | FROSTWYRM | 100% | Yes | Yes |

### Commented Out (no active sound)

| Spell | Reason |
|-------|--------|
| Soul Reaper | Sound file present, pending tuning |
| Lichborne | Sound file present, pending tuning |
| Commander of the Dead | No sound |
| Apocalypse | No sound |

---

## Sound Files

### sounds/login/
| File |
|------|
| login.ogg |

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
| afk.mp3 |

### sounds/afkend/
| File |
|------|
| afkend.ogg |

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

### sounds/armyofdead/
| File |
|------|
| army_of_the_dead.ogg |

### sounds/darktransform/
| File |
|------|
| dark_transformation.ogg |

### sounds/deaths_advance/
| File |
|------|
| deaths_advance_and_death_charge.ogg |

### sounds/deathgrip/
| File |
|------|
| death_grip_1.ogg |
| death_grip_2.ogg |

### sounds/deathanddecay/
| File |
|------|
| death_and_decay.ogg |

### sounds/deathgate/
| File |
|------|
| death_gate.ogg |

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

### sounds/chainofice/
| File |
|------|
| chains_of_ice.ogg |

### sounds/putrefy/
| File |
|------|
| putrefy.ogg |

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

### sounds/soulreaper/
| File |
|------|
| soul_reaper.ogg |
