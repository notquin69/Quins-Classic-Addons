local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()

if namespace.locale == "zhCN" then
	-- The EU English game client also
	-- uses the US English locale code.

-- #######################################################################################################################################################
-- ##	简体中文 (Simplified Chinese) translations provided by C_Reus(Azpilicuet@主宰之剑), alvisjiang, aenerv7, xlfd2008, and y123ao6 on Curseforge.	##
-- #######################################################################################################################################################

L["  /dcstats config: Opens the DejaClassicStats addon config menu."] = "/dcstats config: 开启DejaClassicStats插件设置选项。"
L["  /dcstats reset:  Resets DejaClassicStats options to default."] = "/dcstats reset: 重置DejaClassicStats选项回预设。"
L["%s of %s increases %s by %.2f%%"] = "%s当%s 增加%s为%.2f%%"
L["About DCS"] = "关于DCS"
L["All Stats"] = "所有属性"
L["Attack"] = "攻击"
L["Average Durability"] = "平均耐久度"
L["Average equipped item durability percentage."] = "已装备的物品耐久度平均百分比"
L["Average Item Level:"] = "平均物品等级："
L["Avoidance Rating"] = "闪躲百分比值"
L["Blizzard's Hide At Zero"] = "以暴雪的方式隐藏 0 值"
L["Character Stats:"] = "角色属性："
L["Class Colors"] = "职业颜色"
L["Class Crest Background"] = "职业纹章背景"
L["Critical Strike Rating"] = "爆击百分比值"
L["DCS's Hide At Zero"] = "以 DCS 的方式隐藏 0 值"
L["Decimals"] = "小数点"
L["Defense"] = "防御"
L["Dejablue's improved character stats panel view."] = "Dejablue的角色属性统计面板增强。"
L["DejaClassicStats Slash commands (/dcstats):"] = "DejaClassicStats 命令(/dcsstats)"
L["Displays a durability bar next to each item."] = "在装备图标旁显示耐久条"
L["Displays average item durability on the character shirt slot and durability frames."] = "在角色界面衬衫栏与耐久度框架显示平均物品耐久度。"
L["Displays average item level to one decimal place."] = "显示平均装等小数点后一位"
L["Displays average item level to two decimal places."] = "显示平均装等小数点后两位"
L["Displays average item level with class colors."] = "以职业颜色显示平均物品等级。"
L["Displays each equipped item's durability."] = "显示每件装备的耐久度"
L["Displays each equipped item's repair cost."] = "显示每件装备的维修费用"
L["Displays 'Enhancements' category stats to two decimal places."] = "显示'强化'栏位的属性到两个小数点。"
L["Displays Equipped/Available item levels unless equal."] = "显示已装备/可用的物品等级除非相等。"
L["Displays the class crest background."] = "显示职业特色背景。"
L["Displays the DCS scrollbar."] = "显示DejaClassicStats滚动条"
L["Displays the Expand button for the character stats frame."] = "显示打开角色属性界面按钮。"
L["Displays the item level of each equipped item."] = "显示已装备物品等级。"
L["Dodge Rating"] = "躲闪值"
L["Durability"] = "耐久度"
L["Durability Bars"] = "耐久度条"
L["Equipped/Available"] = "已装备/可用"
L["Expand"] = "展开"
L["General"] = "综合"
L["General global cooldown refresh time."] = "公共冷却刷新时间。"
L["Global Cooldown"] = "公共冷却"
L["Haste Rating"] = "急速值"
L["Hide Character Stats"] = "隐藏人物属性"
L["Hide low level mastery"] = "隐藏低等级精通"
L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] = "如果'强化'属性值为零则隐藏，开启'小数点'选项则显示。"
L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] = "当'强化'属性值为零时隐藏，例：某属性值为0.001%，显示为0%"
L["Hides Mastery stat until the character starts to have benefit from it. Hiding Mastery with Select-A-Stat™ in the character panel has priority over this setting."] = "在角色从中受益之前，隐藏精通属性。(如果通过Select-A-Stat™在角色面板中隐藏精通，会优先于此设置。)"
L["Item Durability"] = "物品耐久度"
L["Item Level"] = "物品等级"
L["Item Repair Cost"] = "物品修理费"
L["Item Slots:"] = "物品栏位："
L["Leech Rating"] = "吸血值"
L["Lock DCS"] = "锁定DCS"
L["Main Hand"] = "主手"
L["Mastery Rating"] = "精通值"
L["Miscellaneous:"] = "其他选项："
L["Movement Speed"] = "移动速度"
L["Off Hand"] = "副手"
L["Offense"] = "设置"
L["One Decimal Place"] = "小数点后一位"
L["Parry Rating"] = "招架值"
L["Ratings"] = "等级"
L["Relevant Stats"] = "相应属性"
L["Repair Total"] = "总修理费"
L["Requires Level "] = "需求等级"
L["Reset Stats"] = "重置属性"
L["Reset to Default"] = "恢复至默认配置"
L["Resets order of stats."] = "重置属性顺序。"
L["Scrollbar"] = "滚动条"
L["Show all stats."] = "显示全部属性"
L["Show Character Stats"] = "显示角色属性"
L["Show only stats relevant to your class spec."] = "只显示你职业专精相关的属性。"
L["Total equipped item repair cost before discounts."] = "折扣前的已装备物品修理费"
L["Two Decimal Places"] = "小数点后两位"
L["Unlock DCS"] = "解锁DCS"
L["Versatility Rating"] = "全能百分比值"
L["weapon auto attack (white) DPS."] = "武器自动攻击(白字)每秒伤害。"
L["Weapon DPS"] = "武器伤害"

----------------------------------------------------
-- DejaClassicStats specific translation phrases. --
----------------------------------------------------
L["Primary"] = "Primary"
L["Melee Enhancements"] = "Melee Enhancements"
L["Spell Enhancements"] = "Spell Enhancements"

L["\"Melee Hit: "] = "近战命中: "
--[[Translation missing --]]
L[". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."] = ". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."
L["+ Healing: "] = "治疗效果: "
--[[Translation missing --]]
L["Alternate Expand"] = "Alternate Expand"
--[[Translation missing --]]
L["Background Art"] = "Background Art"
--[[Translation missing --]]
L["Base Defense including talents such as Warrior's Anticipation is "] = "Base Defense including talents such as Warrior's Anticipation is "
--[[Translation missing --]]
L["Black Item Icons"] = "Black Item Icons"
--[[Translation missing --]]
L["Black item icons to make text more visible."] = "Black item icons to make text more visible."
L["Block: "] = "格挡: "
--[[Translation missing --]]
L["Bonus Defense from items and enhancements is "] = "Bonus Defense from items and enhancements is "
--[[Translation missing --]]
L["Darken Item Icons"] = "Darken Item Icons"
--[[Translation missing --]]
L["Darken item icons to make text more visible."] = "Darken item icons to make text more visible."
L["Defense: "] = "防御: "
--[[Translation missing --]]
L["Display Info Beside Items"] = "Display Info Beside Items"
--[[Translation missing --]]
L["Displays black and white class talents background art."] = "Displays black and white class talents background art."
--[[Translation missing --]]
L["Displays each equipped item's enchantment."] = "Displays each equipped item's enchantment."
--[[Translation missing --]]
L["Displays the class talents background art."] = "Displays the class talents background art."
--[[Translation missing --]]
L["Displays the Expand button above the hands item slot."] = "Displays the Expand button above the hands item slot."
--[[Translation missing --]]
L["Displays the item's info beside each item's slot."] = "Displays the item's info beside each item's slot."
L["Dodge: "] = "躲闪: "
L["Durability: "] = "耐久: "
--[[Translation missing --]]
L["Enchants"] = "Enchants"
--[[Translation missing --]]
L["Mana Regen Current: "] = "Mana Regen Current: "
--[[Translation missing --]]
L["Mana Regen: "] = "Mana Regen: "
L["Melee + Damage: "] = "近战攻击强度: "
L["Melee Crit: "] = "近战爆击: "
--[[Translation missing --]]
L["Monochrome Background Art"] = "Monochrome Background Art"
L["Movement Speed: "] = "移动速度: "
L["MP5: "] = "5秒回蓝: "
L["Parry: "] = "招架: "
--[[Translation missing --]]
L["Physical Critical Strike: "] = "Physical Critical Strike: "
L["Ranged Crit: "] = "远程暴击："
L["Repair Total: "] = "维修总价："
L["Spell + Damage: "] = "法术伤害增量："
L["Spell Crit: "] = "法术爆击: "
L["Spell Hit: "] = "法术命中："
--[[Translation missing --]]
L["Total Defense is "] = "Total Defense is "

return end
