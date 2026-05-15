# DeathKnightExperience

A World of Warcraft addon for Death Knights that plays Arthas / Lich King voice lines and spell sound effects automatically based on your in-game actions.

Only loads for Death Knight characters (class ID 6).

> Bug reports & feedback: **denougur0@gmail.com**

---

## Commands

| Command | Description |
|---|---|
| `/dke on` | Enable all sounds |
| `/dke off` | Disable all sounds |
| `/dke cd <seconds>` | Set the global cooldown between sounds (default: 2s) |

The global CD and enabled state are saved between sessions.

---

## Sound Channel

All sounds play through the **Dialog** channel. To control the volume, go to `Esc → System → Sound` and adjust the **Dialog** slider.

---

## How It Works

The addon listens for two types of triggers:

- **Ambient events** — state changes detected in the background (combat, death, AFK, etc.)
- **Key presses** — every time you press a key or mouse button, the addon looks up what spell is on that action bar slot and plays the matching sound

### Global Cooldown

A shared cooldown prevents two sounds from firing at the same time. Default is **2 seconds**, configurable with `/dke cd <seconds>`. Spells with their own internal CD (Pillar of Frost, Frostwyrm's Fury, etc.) bypass the global CD when they fire, but reset it so that subsequent sounds wait their turn.

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
| Pet summoned | RAISE | 100% | |

While dead, all ambient sounds except DEATH and REVIVE are suppressed.

### Spell Sounds

Triggered by pressing the key bound to the spell. Most require you to be in combat.

| Spell | Category | Chance | Internal CD | Out of combat |
|---|---|---|---|---|
| Raise Dead | RAISE | 100% | — | Yes |
| Raise Ally | RAISE_ALLY | 100% | — | Yes |
| Death Grip | DEATHGRIP | 100% | — | — |
| Death Strike | DEATH_STRIKE | 100% | 1s | — |
| Death and Decay | DAD | 100% | — | — |
| Asphyxiate | ASPHYXIATE | 100% | 45s | — |
| Blinding Sleet | BLINDING_SLEET | 100% | 60s | — |
| Mind Freeze | MIND_FREEZE | 100% | 15s | — |
| Chain of Ice | CHAIN_OF_ICE | 100% | 6s | — |
| Pillar of Frost | PILLAR | 100% | 44s | Yes |
| Breath of Sindragosa | BREATH | 100% | 89s | — |
| Frostwyrm's Fury | FROSTWYRM | 100% | 89s | Yes |
| Death Gate | DEATHGATE | 100% | — | Yes |

**Internal CD** — tracked per spell independently of the global cooldown. Prevents the same spell sound from firing repeatedly during a fight.

---

## Macro Support

The addon detects spells cast from macros by reading the key you pressed and looking up what spell is on that action bar slot.

**In WoW Midnight**, `GetActionInfo` returns the spell ID of the spell shown in the macro's tooltip. This means the `#showtooltip` line controls which sound plays:

```
#showtooltip Pillar of Frost
/cast [mod:shift] Frostwyrm's Fury; Pillar of Frost
```

In this example, pressing the key always plays the **Pillar of Frost** sound, because `#showtooltip` sets the displayed spell regardless of which branch of the macro actually fires.

If your macro has no `#showtooltip`, the addon falls back to the **first `/cast` or `/use` line** to identify the spell.

> The macro cache is built automatically on load and refreshed every time you leave combat.

---

## Sound Files

All files must be in **.ogg** format and placed in the corresponding subfolder under `Interface/AddOns/DeathKnightExperience/sounds/`.

### sounds/login/
| File | Used for |
|---|---|
| login.ogg | LOGIN |

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

### sounds/deathgrip/
| File |
|---|
| death_grip_1.ogg |
| death_grip_2.ogg |

### sounds/death_strike/
| File |
|---|
| death_strike.ogg |

### sounds/deathanddecay/
| File |
|---|
| death_and_decay.ogg |

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

### sounds/deathgate/
| File |
|---|
| death_gate.ogg |
