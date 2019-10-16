Real Mob Health
by SDPhantom
https://www.wowinterface.com/forums/member.php?u=34145
===============================================================================

All Rights Reserved - Use at your own risk
UnZip contents into the "Interface\AddOns" folder in your WoW instalation directory


Commands:

/RMHDel [UnitID]
Removes selected UnitID from stored health values. This defaults to target if not specified.

/RMHWipe
Clears all recorded health data.

===============================================================================
Versions:
2.13	(2019-09-25)
	-Removed lingering debug message that was hiding in the aura scanner

2.12	(2019-09-23)
	-Now detects health from a Hunter's Beast Lore
	-Added ruRU localization (courtesy of vAlshebnik)

2.11	(2019-09-15)
	-Localization.lua now uncludes Unicode BOM for easier UTF-8 editing
	-Revised deDE localization (courtesy of Dathwada)
	-Added esES localization (courtesy of Lynk_One)

2.10	(2019-09-11)
	-Added koKR localization (courtesy of chkid)

2.9	(2019-09-10)
	-Added deDE localization (courtesy of Figlmueller)
	-Fixed zhCN, zhTW, and koKR numeric abbreviations

2.8	(2019-09-09)
	-Added zhCN and zhTW localizations (courtesy of EKE00372 and HopeASD)

2.7	(2019-09-08)
	-Fixed Localization loader not loading the default locale for some people

2.6	(2019-09-08)
	-Added frFR localization (courtesy of Pgmbru)

2.5	(2019-09-06)
	-GameTooltip health text is now offloaded to the same on-use generation code that TargetFrame uses

2.4	(2019-09-05)	APIVersion: 3.2
	-Fixed TargetFrame text not checking options on creation
	-Added health text to the GameTooltip's StatusBar
	-"Show Tooltip Info" in options has been renamed "Show Tooltip Feedback" to avoid ambiguity with the new health text
	-Added API version info to API
		Note: APIVersion is noted in this file for continuity, however it's only available starting now
	-Added RealMobHealth.OverrideOption() and RealMobHealth.UITweaksSetEnabled() to API (See APIDoc.txt)

2.3	(2019-08-11)	APIVersion: 3.1
	-Improved UITweaks' integration with layout addons
	-Tooltip lines have been added to the localization table
	-Tooltip now shows if a creature's health is overridden
	-Added RealMobHealth.HasHealthOverride() to API (See APIDoc.txt)

2.2	(2019-08-09)
	-Fixed newly created nameplates not checking options

2.1	(2019-08-08)
	-Implemented GetNormalizedRealmName() fallback if UnitFullName("player") fails to return realm name
	-Fixed stack overflow in UITweaks

2.0	(2019-07-14)	APIVersion: 3.0
	-Complete restructure
	-Supporting code is split into different modules
	-Peer system broadcasts discovered health values and makes queries through the AddOn comm channels
	-Health recording can now happen when targeting a corpse after witnessing a fight
	-New cache timeout system purges damage data from mobs that have not been seen in a while
	-Cache timeout varies based on what data exists for the mob and if the addon is aware the mob is dead
	-BlizzardUI Tweaks is reintegrated to streamline the new options system
	-Lots of API additions/tweaks/changes (See APIDoc.txt)
	-Callbacks are now handled by the new event system
	-RealMobHealth.GetUnitHealth() speculative mode is now force-enabled. The argument to control it has been removed.

1.1	(2019-06-05)	APIVersion: 2.0
	-Streamlined the core code
	-Fixed issue with Shaman totems getting recorded
	-World/Raid bosses are now supported
	-Damage reflection is now properly tallied
	-More API functions (See APIDoc.txt)
	-RealMobHealth.GetHealth() had been renamed RealMobHealth.GetUnitHealth()
	-RealMobHealth.GetUnitHealth() now falls back to native values if not enough data present
	-GameTooltip hook now only runs if the unit is attackable

1.0	(2019-05-19)	APIVersion: 1.0
	-Classic release
	-Records damage taken of nearby mobs from the CombatLog
	-Obtains mob level using mouseover/target/partytarget/raidtarget and if enabled, nameplates
	-TargetFrame and Nameplates show text values for health, TargetFrame also shows mana/rage/energy
	-Gametooltip shows which mobs have had their health recorded
