# Deadly Boss Mods Core

## [1.13.16](https://github.com/DeadlyBossMods/DBM-Classic/tree/1.13.16) (2019-10-13)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Classic/compare/1.13.15...1.13.16)

- Tweak default HUD refresh rate, since testing revealed that 0.035 is a terrible refresh rate for 60fps (it causes jitter since it poorly matches the refresh rate). 0.03 refresh rate is much smoother.  
    Bumped version to prep tag. I know it's wierd to tag a new release for feature not even used in dungeons/raid, but these api tweaks are important to push out since opening the HUD api wide open for 3rd party usage :)  
- Support API for 3rd party mods to control refresh rate of HUD  
- Because in classic it's up to 40 targets,  half the scan count on fireball to reduce target iteration by 50%  
