local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()

if namespace.locale == "koKR" then
	-- The EU English game client also
	-- uses the US English locale code.

-- #######################################################################################################################
-- ##	한국어 (Korean) translations provided by PositiveMind, yuk6196, netaras, meloppy, and next96 on Curseforge.		##
-- #######################################################################################################################

L["  /dcstats config: Opens the DejaClassicStats addon config menu."] = "/dcstats config: DejaClassicStats 애드온 설정 메뉴를 엽니다."
L["  /dcstats reset:  Resets DejaClassicStats options to default."] = "/dcstats reset: DejaClassicStats 설정을 기본값으로 초기화합니다."
--[[Translation missing --]]
--[[ L["%s of %s increases %s by %.2f%%"] = ""--]] 
L["About DCS"] = "DCS 정보"
L["All Stats"] = "모든 능력치"
--[[Translation missing --]]
--[[ L["Attack"] = ""--]] 
L["Average Durability"] = "평균 내구도"
L["Average equipped item durability percentage."] = "착용 중인 아이템의 평균 내구도 백분율입니다."
L["Average Item Level:"] = "평균 아이템 레벨:"
L["Avoidance Rating"] = "광역회피 수치"
--[[Translation missing --]]
--[[ L["Blizzard's Hide At Zero"] = ""--]] 
L["Character Stats:"] = "캐릭터 능력치:"
L["Class Colors"] = "직업 색상"
L["Class Crest Background"] = "직업 문장 배경"
L["Critical Strike Rating"] = "치명타 및 극대화 수치"
--[[Translation missing --]]
--[[ L["DCS's Hide At Zero"] = ""--]] 
L["Decimals"] = "소수점"
L["Defense"] = "방어"
--[[Translation missing --]]
--[[ L["Dejablue's improved character stats panel view."] = ""--]] 
L["DejaClassicStats Slash commands (/dcstats):"] = "DejaClassicStats 슬래시 명령어 (/dcstats):"
L["Displays a durability bar next to each item."] = "각 아이템 옆에 내구도 바를 표시합니다."
L["Displays average item durability on the character shirt slot and durability frames."] = "캐릭터 속옷 칸과 내구도 창에 착용 아이템의 평균 내구도를 표시합니다."
L["Displays average item level to one decimal place."] = "평균 아이템 레벨을 소수점 첫째 자리까지 표시합니다."
L["Displays average item level to two decimal places."] = "평균 아이템 레벨을 소수점 둘째 자리까지 표시합니다."
L["Displays average item level with class colors."] = "평균 아이템 레벨을 직업색상으로 표시합니다."
L["Displays each equipped item's durability."] = "각 착용 아이템의 내구도를 표시합니다."
L["Displays each equipped item's repair cost."] = "각 착용 아이템의 수리비를 표시합니다."
L["Displays 'Enhancements' category stats to two decimal places."] = "'강화 수치' 항목의 능력치를 소수점 2자리까지 표시합니다."
L["Displays Equipped/Available item levels unless equal."] = "동일하지 않으면 착용/소지 아이템 레벨을 표시합니다."
L["Displays the class crest background."] = "직업 문장 배경을 표시합니다."
L["Displays the DCS scrollbar."] = "DCS 스크롤바를 표시합니다"
L["Displays the Expand button for the character stats frame."] = "캐릭터 능력치 창에 확장 버튼을 표시합니다."
L["Displays the item level of each equipped item."] = "각 착용 아이템의 아이템 레벨을 표시합니다."
L["Dodge Rating"] = "회피 수치"
L["Durability"] = "내구도"
L["Durability Bars"] = "내구도 바"
L["Equipped/Available"] = "착용 중/소지 중"
L["Expand"] = "확장 표시"
L["General"] = "일반"
L["General global cooldown refresh time."] = "일반적인 전역 재사용 대기시간입니다."
L["Global Cooldown"] = "전역 재사용 대기시간"
L["Haste Rating"] = "가속 수치"
L["Hide Character Stats"] = "캐릭터 능력치 숨기기"
--[[Translation missing --]]
--[[ L["Hide low level mastery"] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides Mastery stat until the character starts to have benefit from it. Hiding Mastery with Select-A-Stat™ in the character panel has priority over this setting."] = ""--]] 
L["Item Durability"] = "아이템 내구도"
L["Item Level"] = "아이템 레벨"
L["Item Repair Cost"] = "아이템 수리비"
L["Item Slots:"] = "아이템 칸:"
L["Leech Rating"] = "생기흡수 수치"
L["Lock DCS"] = "DCS 잠그기"
L["Main Hand"] = "주장비"
L["Mastery Rating"] = "특화 수치"
L["Miscellaneous:"] = "기타:"
L["Movement Speed"] = "이동 속도"
L["Off Hand"] = "보조장비"
L["Offense"] = "공격"
L["One Decimal Place"] = "소수점 첫째 자리"
L["Parry Rating"] = "무기막기 수치"
L["Ratings"] = "수치"
L["Relevant Stats"] = "관련 능력치"
L["Repair Total"] = "총 수리비"
L["Requires Level "] = "최소 요구 레벨 "
L["Reset Stats"] = "능력치 초기화"
L["Reset to Default"] = "기본값으로 초기화"
L["Resets order of stats."] = "능력치 순서를 초기화합니다."
L["Scrollbar"] = "스크롤바"
L["Show all stats."] = "모든 능력치를 표시합니다."
L["Show Character Stats"] = "캐릭터 능력치 표시"
L["Show only stats relevant to your class spec."] = "직업 전문화와 관련된 능력치만 표시합니다."
L["Total equipped item repair cost before discounts."] = "착용 아이템의 할인 전 총 수리비입니다."
L["Two Decimal Places"] = "소수점 둘째 자리"
L["Unlock DCS"] = "DCS 잠금 해제"
L["Versatility Rating"] = "유연성 수치"
L["weapon auto attack (white) DPS."] = "무기의 자동 공격 (흰색) DPS입니다."
L["Weapon DPS"] = "무기 DPS"

----------------------------------------------------
-- DejaClassicStats specific translation phrases. --
----------------------------------------------------
L["Primary"] = "Primary"
L["Melee Enhancements"] = "Melee Enhancements"
L["Spell Enhancements"] = "Spell Enhancements"

L["\"Melee Hit: "] = "\"근접 적중: "
L[". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."] = ". 공격대 우두머리를 상대할 때 60레벨 플레이어가 치명 적중 면역을 달성하기 위해서는 440의 방어도와 140의 방어 숙련도가 필요합니다."
L["+Healing: "] = "추가 치유: "
L["Alternate Expand"] = "대체 확장 버튼"
L["Background Art"] = "배경 삽화"
L["Base Defense including talents such as Warrior's Anticipation is "] = "특성(전사의 직감 등)이 적용된 기본 방어 숙련도: "
L["Black Item Icons"] = "장비창의 아이템 아이콘을 까맣게 표시"
L["Black item icons to make text more visible."] = "장비창의 아이템 아이콘을 까맣게 표시하여 문자 가시성을 높입니다."
L["Block: "] = "방패막기: "
L["Bonus Defense from items and enhancements is "] = "아이템과 마법 부여가 적용된 추가 방어 숙련도: "
L["Darken Item Icons"] = "장비창의 아이템 아이콘을 어둡게 표시"
L["Darken item icons to make text more visible."] = "장비창의 아이템 아이콘을 어둠게 표시하여 문자 가시성을 높입니다."
L["Defense: "] = "방어 숙련도: "
L["Display Info Beside Items"] = "정보를 아이콘 옆에 표시"
L["Displays black and white class talents background art."] = "배경을 검은색으로 표시합니다."
L["Displays each equipped item's enchantment."] = "착용한 아이템의 마법부여를 표시합니다."
L["Displays the class talents background art."] = "직업별 삽화를 배경에 표시합니다."
L["Displays the Expand button above the hands item slot."] = "확장 버튼을 손 착용칸 위에 표시합니다."
L["Displays the item's info beside each item's slot."] = "아이템의 정보를 아이템 착용 칸 옆에 표시합니다."
L["Dodge: "] = "회피: "
L["Durability: "] = "내구도: "
L["Enchants"] = "마법부여 표시"
L["Mana Regen Current: "] = "전투자원 회복: "
L["Mana Regen: "] = "마나 회복: "
L["Melee +Damage: "] = "근접 추가 피해: "
L["Melee Crit: "] = "근접 치명:"
L["Monochrome Background Art"] = "배경을 검은색으로 표시"
L["Movement Speed: "] = "이동속도: "
L["MP5: "] = "5초당 마나 회복: "
L["Parry: "] = "무기막기: "
L["Physical Critical Strike: "] = "물리 치명타: "
L["Ranged Crit: "] = "원거리 치명: "
L["Repair Total: "] = "수리비: "
L["Spell +Damage: "] = "주문 추가 피해:"
L["Spell Crit: "] = "주문 극대화: "
L["Spell Hit: "] = "주문 적중: "
L["Total Defense is "] = "총 방어 숙련도:"

return end
