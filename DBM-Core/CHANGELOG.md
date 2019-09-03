# Deadly Boss Mods Core

## [1.13.2](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.2) (2019-08-24)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.1...1.13.2)

- Add Stratholme dungeon support to Classic WoW and prep for new release for launch  
- Re-enable moam mod, the mod was actually fine, just misunderstood.  
- Merge sunken temple support into classic range, with mods converted to spellName and features that won't work in classic disabled  
- Push the unit target scanner improvements to classic as well  
- CN update  
- AQ20 converted to spell name  
- Handle sound default migration in event user copies settings from retail dbm to classic.  
- AQ40 converted to spell name  
- Another day, another classic raid converted to spellName  
- Convert ZG to spell names, as well as fix some very obviously wrong spellIds/names in some mods.  
- Oops, accounted for it in wrong place, this is correct place  
- Account for combat delay in initial scheduler  
- Converted entirety of naxx to spellName, in addition changed a few methods that were upgraded over years, back to their legacy methods since methods like UNIT\_SPELLCAST\_SUCCEEDED won't work in classic.  
    Also updated several things to newer objects  
    Fixed a bug where range check would never show on KT  
- Fix bad call to spellId instead of spellName  
- reworked IsTanking object for classic to better handle bosses that don't have boss unitIDs  
    Added classic SpellId/spellName for dragons of nightmare breaths and re-enabled those warnings.  
    Converted all 6 world bosses to spellName handling  
