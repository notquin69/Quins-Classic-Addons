﻿LibRealmInfo
===============

Library to provide information about realms.

If you only need to know the names of realms connected to the player's current realm, you should just use [GetAutoCompleteRealms](http://wowpedia.org/API_GetAutoCompleteRealms) instead of this library.

If you only need to know which region the player is currently on, you can use [GetCurrentRegion](http://wowpedia.org/API_GetCurrentRegion), but you should be aware that this function is not always reliable.

* [Download on Curse](https://wow.curseforge.com/projects/librealminfo)
* [Download on WoWInterface](https://www.wowinterface.com/downloads/info22987-LibRealmInfo.html)
* [Source Code](https://github.com/phanx-wow/LibRealmInfo)
* [Issue Tracker](https://github.com/phanx-wow/LibRealmInfo/issues)
* [Documentation](https://github.com/phanx-wow/LibRealmInfo/wiki)


Usage
--------

Available API methods:

* `:GetCurrentRegion()` - Get the two-letter abbrevation for the region the player is currently connected to; one of US, EU, KR, TW, or CN. Returns nil on PTR and Beta realms.
* `:GetRealmInfo(name[, region])` - Get information about a realm by name; if no region is provided, the player's current region will be assumed.
* `:GetRealmInfoByID(id)` - Get information about a realm by ID.
* `:GetRealmInfoByGUID(guid)` - Get information about the realm the given player GUID belongs to.
* `:GetRealmInfoByUnit(unit)` - Get information about the realm the given player unit belongs to.

All of the above methods return the following values:

1. `id` - the numeric unique ID of the realm
2. `name` - the name of the realm
3. `apiName` - the name of the realm without spaces, as seen in chat etc.
4. `rules` - one of "PVP", "PVE", "RP" or "RPPVP"
5. `locale` - the official language of the realm
6. `battlegroup` - the name of the realm's battlegroup
7. `region` - one of "US", "EU", "KR", "CN" or "TW"
8. `timezone` - for realms in the US region, a string describing the realm's time zone, eg. "PST" or "AEST"
9. `connections` - for connected realms, a table listing the IDs of connected realms
10. `latinName` - for Russian-language realms, the English name of the realm
11. `latinApiName` - for Russian-language realms, the English name of the realm without spaces

Note that the realm IDs contained in the GUIDs of player characters on connected realms indicate the realm hosting the connected realm group, which may not be the realm that character actually belongs to. Use [GetPlayerInfoByGUID](http://wowpedia.org/API_GetPlayerInfoByGUID) to get the real realm name, or use the :GetRealmInfoByGUID or :GetRealmInfoByUnit methods provided by LibRealmInfo.
