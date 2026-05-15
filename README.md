# DeathKnightExperience

A World of Warcraft addon for Death Knights that plays Arthas / Lich King voice lines and spell sound effects automatically based on your in-game actions.

Designed for **Unholy** and **Frost** Death Knights. Only loads for Death Knight characters (class ID 6).

> Bug reports & feedback: **denougur0@gmail.com**

---

## Recommended Sound Settings

For the best experience, go to `Esc → System → Sound` and set:

| Channel | Value |
|---|---|
| Music |10%-30% |
| Sound Effects |10%-20% |
| Ambience |10%-20% |
| **Dialog** | **100%** |

All addon sounds play through the **Dialog** channel.

---

## Commands

| Command | Description |
|---|---|
| `/dke on` | Enable all sounds |
| `/dke off` | Disable all sounds |
| `/dke cd <seconds>` | Set the global cooldown between sounds (default: 2s) |

The global CD and enabled state are saved between sessions.

---

## How It Works

The addon listens for two types of triggers:

- **Ambient events** — state changes detected in the background (combat, death, AFK, mounting, etc.)
- **Spell casts** — detected via `UNIT_SPELLCAST_SENT`, which fires only when a spell actually goes through (not when on cooldown or out of range). Works with keyboard, mouse clicks, mouse wheel, and macros.

### Global Cooldown

A shared cooldown prevents two sounds from overlapping. Default is **2 seconds**, configurable with `/dke cd <seconds>`. Important spells (Pillar of Frost, Frostwyrm's Fury, etc.) bypass the global CD with a `force` flag and always play when cast.

### Repeat Penalty

Within any sound category, the last played file gets **10% weight** in the random roll, making back-to-back repeats unlikely without making them impossible.

---

## Triggered Sounds

### Ambient Events

| Event | Category | Chance | Notes |
|---|---|---|---|
| Login / UI reload | LOGIN | 100% | At most once per hour |
| Targeting yourself | SELECT | 100% | |
| Entering combat | AGGRO | 33% | |
| Dying | DEATH | 100% | |
| Reviving / releasing | REVIVE | 100% | |
| Mounting | MOUNT | 100% | |
| Going AFK | AFKSTART | 100% | |
| Returning from AFK | AFKEND | 100% | |
| Pet summoned | RAISE | 75% | |

### Spell Sounds

Triggered when the spell is actually cast. Most require you to be in combat.

| Spell | Category | Chance | Bypasses Global CD | Out of Combat |
|---|---|---|---|---|
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

---

## Sound Files

All files must be in **.ogg** format and placed in the corresponding subfolder under `Interface/AddOns/DeathKnightExperience/sounds/`.

### sounds/login/
| File |
|---|
| login.ogg |

### sounds/select/
| File |
|---|
| select-1.ogg |
| select-2.ogg |
| select_3.ogg |

### sounds/aggroed/
| File |
|---|
| aggro.ogg |

### sounds/death/
| File |
|---|
| death.ogg |
| death_2.ogg |
| death_3.ogg |
| death-4.ogg |

### sounds/revived/
| File |
|---|
| revive.ogg |

### sounds/mount/
| File |
|---|
| mount_1.ogg |
| mount_2.ogg |

### sounds/afkstart/
| File |
|---|
| afkstart.ogg |
| idle.ogg |
| afk.mp3 |

### sounds/afkend/
| File |
|---|
| afkend.ogg |

### sounds/raise/
| File |
|---|
| raise_dead.ogg |
| raise_dke.ogg |
| raise2_dke.ogg |

### sounds/raise_ally/
| File |
|---|
| raise_ally.ogg |

### sounds/armyofdead/
| File |
|---|
| army_of_the_dead.ogg |

### sounds/darktransform/
| File |
|---|
| dark_transformation.ogg |

### sounds/deaths_advance/
| File |
|---|
| deaths_advance_and_death_charge.ogg |

### sounds/deathgrip/
| File |
|---|
| death_grip_1.ogg |
| death_grip_2.ogg |

### sounds/deathanddecay/
| File |
|---|
| death_and_decay.ogg |

### sounds/deathgate/
| File |
|---|
| death_gate.ogg |

### sounds/asphyxiate/
| File |
|---|
| asphyxiate.ogg |

### sounds/blinding_sleet/
| File |
|---|
| blinding_sleet.ogg |

### sounds/mind_freeze/
| File |
|---|
| mind_freeze.ogg |
| mind_freeze_2.ogg |

### sounds/chainofice/
| File |
|---|
| chains_of_ice.ogg |

### sounds/putrefy/
| File |
|---|
| putrefy.ogg |

### sounds/pillar_of_frost/
| File |
|---|
| pillar_of_frost.ogg |

### sounds/breath_of_syndragosa/
| File |
|---|
| breath_of_sindragosa.ogg |

### sounds/frostwrym_fury/
| File |
|---|
| frostwyrm_fury.ogg |

### sounds/lichborne/
| File |
|---|
| lichborne.ogg |

### sounds/soulreaper/
| File |
|---|
| soul_reaper.ogg |
