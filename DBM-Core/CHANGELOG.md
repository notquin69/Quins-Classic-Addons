# Deadly Boss Mods Core

## [1.13.12](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.12) (2019-09-24)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.11...1.13.12)

- Bump Version  
- Remove invalid spellIds, they'll no longer error with previous changes to core, but they still don't belong.  
- Additional tweaks to last  
- Stop playing/scheduling funny sounds for more dots funny sounds in air phase, when she's close to pushing to phase 3 Onyxia, since this is where you stop dots.  
    Fixed a bug where sound P2 funny sounds might go through one more loop instead of canceling, during phase 3 onyxia.  
    Tweaked funny sound order/timing in phase 3 to further fit in line with no/slow dps at first.  
- Delete Splintered Obsidan timer from Uldaman, this is not a cooldown ability.  
- Remove invalid spellId from Ironaya that was causing lua error on combat end in uldaman  
    Made core more robust in detecting this problem, since in classic it matters more (because in classic dbm unregisters spellname lookup, not just number, so it actually errors if spell doesn't exist. Well, used to error :D)  
- Added external function so other addons can request an existing marker table from hud  
