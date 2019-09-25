# [2.15.0](https://github.com/WeakAuras/WeakAuras2/tree/2.15.0) (2019-09-24)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/2.14.6...2.15.0)

## Highlights

 - Tons of Bug fixes
- A new experimental repair tool (details soon(TM))
- PvP talents in Templates
- New feature to add models to progress bar textures 

## Commits

Ian Kerins (1):

- Fix typo

InfusOnWoW (25):

- Fix error in UnloadAll (#1722)
- Fix conditions not untriggering in certain conditions
- Fix Modernize for auras that don't have a set anchor for text
- BuffTrigger2: Fix maxUnitCount if there are no matches
- Author Options: Fix multiline option author
- Fix ContainsPlaceHolder to consider \n a placeholder
- Fix Spec Role load option.
- Fix lua error on wrong input into variables (#1701)
- Fix Icon.lua using L before it's defined
- Use new staticId api from Masque
- Add a default property for Sub Elements Conditions
- Fix Paste Condition Options
- Fix Cooldown ready tracking
- Bufftrigger 2: Fix matching against tooltip on initial scan
- Model: Fix regression in "unit" mode
- Add PVP Talents
- Add Position/Facing/Transform settings to BarModel
- Fix errors on entering a path
- Disable BarModel for classic
- BuffTriger2: Fix nameplate group unit somewhat
- Add a text_justify option to SubText
- Make SetDurationInfo hack work for stacks
- Fix regression in Model animation
- Model for AuraBar sub element
- Add some headers to the sub elements section

Stanzilla (10):

- switch all github links in pkgmetas to https format
- add discord notifications for build failures
- Update TOC for Patch 8.25
- Update ISSUE_TEMPLATE.md
- fix packaging for retail
- enable uploading again
- use GitHub Actions v2 instead of TravisCI (#1646)
- semicolon police
- don't hide font and font size in the pencil
- now that sticky.duration is gone, we can optimize this code path a bit (#1653)

Vardex (1):

- Improve Weapon Enchant Trigger (#1649)

emptyrivers (4):

- guard against inf/nan in %t text replacement
- Add Experimental Repair Tool (#1648)
- don't package modelpaths for WeakAuras classic
- use min/max/etc for range slider

mrbuds (15):

- fix nil error in UnloadAll #1723
- fix ranged swing timer on retail
- fix potential error with text subregion with nil text_justify (#1710)
- disable Health trigger overlays in Classic
- fix nil error in Action Usable spellInRange condition #1697 (#1698)
- fix nil error when clicking minimize button #1677
- fix "set parent to anchor" option for custom anchors fixes #1651
- fix error when importing power trigger for stagger on classic (#1664)
- fix inverse cast trigger force events solve issue when closing options or with load condition in combat
- force_events can be a table
- fix cast trigger events for classic
- don't load environment of children for custom anchor function (#1626)
- disable autocast shine for classic fix #1624
- Use Square_FullWhite.tga as default for borders
- fix WA_GetUnitAura for classic

