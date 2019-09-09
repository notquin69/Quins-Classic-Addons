-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TexturePacks = TSM.UI:NewPackage("TexturePacks")
local private = {}
local TEXTURE_FILE_INFO = {
	uiFrames = {
		path = "Interface\\Addons\\TradeSkillMaster\\Media\\UIFrames.tga",
		scale = 1,
		width = 512,
		height = 512,
		coord = {
			["ActiveInputFieldLeft"] = { 324, 345, 146, 166 },
			["ActiveInputFieldMiddle"] = { 324, 345, 171, 191 },
			["ActiveInputFieldRight"] = { 394, 415, 273, 293 },
			["AuctionCounterTexture"] = { 394, 417, 257, 268 },
			["CraftingApplicationInnerFrameTopLeftCorner"] = { 3, 179, 3, 35 },
			["CraftingApplicationInnerFrameTopRightCorner"] = { 184, 360, 3, 35 },
			["DefaultUIButton"] = { 365, 496, 3, 19 },
			["DividerHandle"] = { 501, 509, 3, 85 },
			["HeaderLeft"] = { 186, 211, 132, 160 },
			["HeaderMiddle"] = { 155, 181, 132, 160 },
			["HeaderRight"] = { 293, 319, 146, 174 },
			["HighlightDot"] = { 427, 435, 240, 248 },
			["InactiveInputFieldLeft"] = { 440, 461, 276, 296 },
			["InactiveInputFieldMiddle"] = { 466, 487, 276, 296 },
			["InactiveInputFieldRight"] = { 394, 415, 298, 318 },
			["LargeActiveButtonLeft"] = { 331, 344, 196, 222 },
			["LargeActiveButtonMiddle"] = { 118, 144, 163, 189 },
			["LargeActiveButtonRight"] = { 331, 344, 227, 253 },
			["LargeApplicationCloseFrameBackground"] = { 155, 211, 99, 127 },
			["LargeApplicationFrameInnerFrameBottomEdge"] = { 216, 288, 138, 144 },
			["LargeApplicationFrameInnerFrameBottomLeftCorner"] = { 365, 391, 195, 221 },
			["LargeApplicationFrameInnerFrameBottomRightCorner"] = { 396, 422, 195, 221 },
			["LargeApplicationFrameInnerFrameLeftEdge"] = { 502, 509, 245, 317 },
			["LargeApplicationFrameInnerFrameRightEdge"] = { 136, 143, 220, 292 },
			["LargeApplicationInnerFrameTopEdge"] = { 365, 437, 146, 175 },
			["LargeApplicationInnerFrameTopLeftCorner"] = { 78, 150, 109, 141 },
			["LargeApplicationInnerFrameTopRightCorner"] = { 365, 437, 109, 141 },
			["LargeApplicationOuterFrameBottomEdge"] = { 365, 437, 180, 190 },
			["LargeApplicationOuterFrameBottomLeftCorner"] = { 427, 437, 195, 205 },
			["LargeApplicationOuterFrameBottomRightCorner"] = { 427, 437, 210, 220 },
			["LargeApplicationOuterFrameLeftEdge"] = { 350, 360, 117, 189 },
			["LargeApplicationOuterFrameRightEdge"] = { 350, 360, 194, 266 },
			["LargeApplicationOuterFrameTopEdge"] = { 3, 75, 40, 94 },
			["LargeApplicationOuterFrameTopLeftCorner"] = { 80, 144, 40, 94 },
			["LargeApplicationOuterFrameTopRightCorner"] = { 149, 213, 40, 94 },
			["LargeClickedButtonLeft"] = { 149, 162, 165, 191 },
			["LargeClickedButtonMiddle"] = { 442, 468, 214, 240 },
			["LargeClickedButtonRight"] = { 118, 131, 194, 220 },
			["LargeHoverButtonLeft"] = { 87, 100, 195, 221 },
			["LargeHoverButtonMiddle"] = { 473, 499, 214, 240 },
			["LargeHoverButtonRight"] = { 87, 100, 226, 252 },
			["LargeInactiveButtonLeft"] = { 167, 180, 165, 191 },
			["LargeInactiveButtonMiddle"] = { 365, 391, 226, 252 },
			["LargeInactiveButtonRight"] = { 185, 198, 165, 191 },
			["LoadingBarLeft"] = { 3, 23, 109, 148 },
			["LoadingBarMiddle"] = { 28, 48, 109, 148 },
			["LoadingBarRight"] = { 53, 73, 109, 148 },
			["MediumActiveButtonLeft"] = { 252, 265, 170, 190 },
			["MediumActiveButtonMiddle"] = { 420, 435, 298, 318 },
			["MediumActiveButtonRight"] = { 270, 283, 183, 203 },
			["MediumClickedButtonLeft"] = { 252, 265, 195, 215 },
			["MediumClickedButtonMiddle"] = { 440, 455, 301, 321 },
			["MediumClickedButtonRight"] = { 288, 301, 200, 220 },
			["MediumHoverButtonLeft"] = { 270, 283, 208, 228 },
			["MediumHoverButtonMiddle"] = { 460, 475, 301, 321 },
			["MediumHoverButtonRight"] = { 288, 301, 225, 245 },
			["MediumInactiveButtonLeft"] = { 306, 319, 228, 248 },
			["MediumInactiveButtonMiddle"] = { 480, 495, 301, 321 },
			["MediumInactiveButtonRight"] = { 216, 229, 201, 221 },
			["PopupBottomEdge"] = { 276, 288, 149, 161 },
			["PopupBottomLeftCorner"] = { 276, 288, 166, 178 },
			["PopupBottomRightCorner"] = { 118, 130, 225, 237 },
			["PopupLeftEdge"] = { 117, 129, 242, 254 },
			["PopupRightEdge"] = { 167, 179, 217, 229 },
			["PopupTopEdge"] = { 184, 196, 217, 229 },
			["PopupTopLeftCorner"] = { 213, 225, 226, 238 },
			["PopupTopRightCorner"] = { 302, 342, 119, 141 },
			["PromoTextureLeft"] = { 365, 444, 24, 104 },
			["PromoTextureMiddle"] = { 3, 82, 155, 235 },
			["PromoTextureRight"] = { 218, 297, 40, 120 },
			["RankFrame"] = { 449, 494, 70, 84 },
			["RegularActiveDropdownLeft"] = { 216, 229, 170, 196 },
			["RegularActiveDropdownMiddle"] = { 396, 422, 226, 252 },
			["RegularActiveDropdownRight"] = { 234, 247, 170, 196 },
			["RegularInactiveDropdownLeft"] = { 422, 435, 266, 293 },
			["RegularInactiveDropdownMiddle"] = { 87, 113, 163, 190 },
			["RegularInactiveDropdownRight"] = { 313, 326, 196, 223 },
			["RoundDarkBottom"] = { 427, 435, 253, 261 },
			["RoundDarkBottomLeft"] = { 500, 508, 322, 330 },
			["RoundDarkBottomRight"] = { 136, 144, 194, 202 },
			["RoundDarkCenter"] = { 105, 113, 195, 203 },
			["RoundDarkLeft"] = { 105, 112, 234, 241 },
			["RoundDarkRight"] = { 105, 113, 208, 216 },
			["RoundDarkTop"] = { 105, 112, 246, 253 },
			["RoundDarkTopLeft"] = { 201, 208, 217, 224 },
			["RoundDarkTopRight"] = { 105, 113, 221, 229 },
			["RoundLightBottom"] = { 203, 211, 165, 173 },
			["RoundLightBottomLeft"] = { 203, 211, 178, 186 },
			["RoundLightBottomRight"] = { 203, 211, 191, 199 },
			["RoundLightCenter"] = { 203, 211, 165, 173 },
			["RoundLightLeft"] = { 203, 211, 165, 173 },
			["RoundLightRight"] = { 203, 211, 165, 173 },
			["RoundLightTop"] = { 203, 211, 165, 173 },
			["RoundLightTopLeft"] = { 136, 144, 207, 215 },
			["RoundLightTopRight"] = { 203, 211, 204, 212 },
			["SearchLeft"] = { 234, 247, 201, 221 },
			["SearchMiddle"] = { 252, 265, 220, 240 },
			["SearchRight"] = { 270, 283, 233, 253 },
			["SearchTypeIndicator"] = { 87, 146, 146, 158 },
			["SettingsNavShadow"] = { 354, 360, 40, 112 },
			["SmallActiveButtonLeft"] = { 288, 301, 250, 266 },
			["SmallActiveButtonMiddle"] = { 216, 231, 149, 165 },
			["SmallActiveButtonRight"] = { 306, 319, 253, 269 },
			["SmallApplicationCloseFrameBackground"] = { 302, 345, 86, 114 },
			["SmallApplicationInnerFrameBottomEdge"] = { 216, 288, 138, 144 },
			["SmallApplicationInnerFrameBottomLeftCorner"] = { 365, 391, 195, 221 },
			["SmallApplicationInnerFrameBottomRightCorner"] = { 396, 422, 195, 221 },
			["SmallApplicationInnerFrameLeftEdge"] = { 502, 509, 245, 317 },
			["SmallApplicationInnerFrameRightEdge"] = { 136, 143, 220, 292 },
			["SmallApplicationInnerFrameTopEdge"] = { 216, 288, 125, 133 },
			["SmallApplicationInnerFrameTopLeftCorner"] = { 440, 466, 245, 271 },
			["SmallApplicationInnerFrameTopRightCorner"] = { 471, 497, 245, 271 },
			["SmallApplicationOuterFrameBottomEdge"] = { 365, 437, 180, 190 },
			["SmallApplicationOuterFrameBottomLeftCorner"] = { 427, 437, 195, 205 },
			["SmallApplicationOuterFrameBottomRightCorner"] = { 427, 437, 225, 235 },
			["SmallApplicationOuterFrameLeftEdge"] = { 350, 360, 117, 189 },
			["SmallApplicationOuterFrameRightEdge"] = { 350, 360, 194, 266 },
			["SmallApplicationOuterFrameTopEdge"] = { 3, 75, 40, 94 },
			["SmallApplicationOuterFrameTopLeftCorner"] = { 442, 506, 155, 209 },
			["SmallApplicationOuterFrameTopRightCorner"] = { 365, 389, 257, 311 },
			["SmallClickedButtonLeft"] = { 324, 337, 258, 274 },
			["SmallClickedButtonMiddle"] = { 236, 251, 149, 165 },
			["SmallClickedButtonRight"] = { 342, 355, 271, 287 },
			["SmallHoverButtonLeft"] = { 149, 162, 196, 212 },
			["SmallHoverButtonMiddle"] = { 256, 271, 149, 165 },
			["SmallHoverButtonRight"] = { 167, 180, 196, 212 },
			["SmallInactiveButtonLeft"] = { 185, 198, 196, 212 },
			["SmallInactiveButtonMiddle"] = { 293, 308, 179, 195 },
			["SmallInactiveButtonRight"] = { 149, 162, 217, 233 },
			["TSMLogo"] = { 449, 509, 90, 150 },
			["ToggleDisabledOff"] = { 449, 496, 24, 42 },
			["ToggleDisabledOn"] = { 449, 496, 47, 65 },
			["ToggleOff"] = { 302, 349, 40, 58 },
			["ToggleOn"] = { 302, 349, 63, 81 },
		},
	},
	iconPack = {
		path = "Interface\\Addons\\TradeSkillMaster\\Media\\IconPack.tga",
		scale = 2,
		width = 512,
		height = 1024,
		coord = {
			["10x10/Add/Circle"] = { 76, 96, 238, 258 },
			["10x10/Add/Default"] = { 76, 96, 260, 280 },
			["10x10/Arrow/Down"] = { 76, 96, 282, 302 },
			["10x10/Arrow/Up"] = { 76, 96, 304, 324 },
			["10x10/Auctions"] = { 76, 96, 326, 346 },
			["10x10/Bid"] = { 76, 96, 348, 368 },
			["10x10/Boxes"] = { 76, 96, 370, 390 },
			["10x10/Buyout"] = { 76, 96, 392, 412 },
			["10x10/Carot/Collapsed"] = { 76, 96, 414, 434 },
			["10x10/Carot/Expanded"] = { 76, 96, 436, 456 },
			["10x10/Checkmark/Circle"] = { 454, 474, 404, 424 },
			["10x10/Checkmark/Default"] = { 454, 474, 426, 446 },
			["10x10/Chevron/Collapsed"] = { 76, 96, 458, 478 },
			["10x10/Chevron/Expanded"] = { 52, 72, 618, 638 },
			["10x10/Chevron/Inactive"] = { 0, 20, 634, 654 },
			["10x10/Clock"] = { 22, 42, 634, 654 },
			["10x10/Close/Circle"] = { 130, 150, 584, 604 },
			["10x10/Close/Default"] = { 152, 172, 584, 604 },
			["10x10/Coins"] = { 174, 194, 584, 604 },
			["10x10/Configure"] = { 196, 216, 584, 604 },
			["10x10/Crafting"] = { 218, 238, 584, 604 },
			["10x10/Dashboard"] = { 240, 260, 584, 604 },
			["10x10/Delete"] = { 262, 282, 584, 604 },
			["10x10/DragHandle"] = { 284, 304, 584, 604 },
			["10x10/Duplicate"] = { 306, 326, 588, 608 },
			["10x10/Edit"] = { 328, 348, 588, 608 },
			["10x10/Expire"] = { 350, 370, 588, 608 },
			["10x10/Filter"] = { 372, 392, 598, 618 },
			["10x10/Groups"] = { 394, 414, 612, 632 },
			["10x10/Help"] = { 416, 436, 614, 634 },
			["10x10/Hide"] = { 130, 150, 606, 626 },
			["10x10/Import"] = { 104, 124, 610, 630 },
			["10x10/Inventory"] = { 152, 172, 606, 626 },
			["10x10/Link"] = { 174, 194, 606, 626 },
			["10x10/More"] = { 196, 216, 606, 626 },
			["10x10/New"] = { 218, 238, 606, 626 },
			["10x10/Operations"] = { 240, 260, 606, 626 },
			["10x10/Pause"] = { 262, 282, 606, 626 },
			["10x10/Post"] = { 284, 304, 606, 626 },
			["10x10/Posting"] = { 306, 326, 610, 630 },
			["10x10/Queue"] = { 328, 348, 610, 630 },
			["10x10/Reset"] = { 350, 370, 610, 630 },
			["10x10/Resize"] = { 372, 392, 620, 640 },
			["10x10/Running"] = { 394, 414, 634, 654 },
			["10x10/SaleRate"] = { 416, 436, 636, 656 },
			["10x10/Search"] = { 438, 458, 636, 656 },
			["10x10/Settings"] = { 460, 480, 636, 656 },
			["10x10/Shopping"] = { 482, 502, 636, 656 },
			["10x10/SideArrow"] = { 126, 146, 628, 648 },
			["10x10/SkillUp"] = { 74, 94, 632, 652 },
			["10x10/SkillUp/1"] = { 44, 64, 640, 660 },
			["10x10/SkillUp/10"] = { 96, 116, 632, 652 },
			["10x10/SkillUp/2"] = { 0, 20, 656, 676 },
			["10x10/SkillUp/3"] = { 22, 42, 656, 676 },
			["10x10/SkillUp/4"] = { 148, 168, 628, 648 },
			["10x10/SkillUp/5"] = { 170, 190, 628, 648 },
			["10x10/SkillUp/6"] = { 192, 212, 628, 648 },
			["10x10/SkillUp/7"] = { 214, 234, 628, 648 },
			["10x10/SkillUp/8"] = { 236, 256, 628, 648 },
			["10x10/SkillUp/9"] = { 258, 278, 628, 648 },
			["10x10/Skip"] = { 280, 300, 628, 648 },
			["10x10/Sniper"] = { 302, 322, 632, 652 },
			["10x10/Star/Filled"] = { 324, 344, 632, 652 },
			["10x10/Star/Unfilled"] = { 346, 366, 632, 652 },
			["10x10/Stop"] = { 368, 388, 642, 662 },
			["10x10/Subtract/Circle"] = { 390, 410, 656, 676 },
			["10x10/Subtract/Default"] = { 412, 432, 658, 678 },
			["12x12/Add/Circle"] = { 454, 478, 200, 224 },
			["12x12/Add/Default"] = { 454, 478, 226, 250 },
			["12x12/Arrow/Down"] = { 488, 512, 480, 504 },
			["12x12/Arrow/Up"] = { 488, 512, 506, 530 },
			["12x12/Auctions"] = { 398, 422, 494, 518 },
			["12x12/Bid"] = { 424, 448, 508, 532 },
			["12x12/Boxes"] = { 450, 474, 510, 534 },
			["12x12/Buyout"] = { 476, 500, 532, 556 },
			["12x12/Carot/Collapsed"] = { 120, 144, 506, 530 },
			["12x12/Carot/Expanded"] = { 90, 114, 528, 552 },
			["12x12/Checkmark/Circle"] = { 60, 84, 540, 564 },
			["12x12/Checkmark/Default"] = { 0, 24, 556, 580 },
			["12x12/Chevron/Collapsed"] = { 26, 50, 556, 580 },
			["12x12/Chevron/Expanded"] = { 146, 170, 506, 530 },
			["12x12/Chevron/Inactive"] = { 172, 196, 506, 530 },
			["12x12/Clock"] = { 198, 222, 506, 530 },
			["12x12/Close/Circle"] = { 224, 248, 506, 530 },
			["12x12/Close/Default"] = { 250, 274, 506, 530 },
			["12x12/Coins"] = { 276, 300, 506, 530 },
			["12x12/Configure"] = { 302, 326, 506, 530 },
			["12x12/Crafting"] = { 328, 352, 510, 534 },
			["12x12/Dashboard"] = { 354, 378, 510, 534 },
			["12x12/Delete"] = { 380, 404, 520, 544 },
			["12x12/DragHandle"] = { 406, 430, 534, 558 },
			["12x12/Duplicate"] = { 432, 456, 536, 560 },
			["12x12/Edit"] = { 458, 482, 558, 582 },
			["12x12/Expire"] = { 484, 508, 558, 582 },
			["12x12/Filter"] = { 116, 140, 532, 556 },
			["12x12/Groups"] = { 86, 110, 554, 578 },
			["12x12/Help"] = { 52, 76, 566, 590 },
			["12x12/Hide"] = { 0, 24, 582, 606 },
			["12x12/Import"] = { 26, 50, 582, 606 },
			["12x12/Inventory"] = { 142, 166, 532, 556 },
			["12x12/Link"] = { 168, 192, 532, 556 },
			["12x12/More"] = { 194, 218, 532, 556 },
			["12x12/New"] = { 220, 244, 532, 556 },
			["12x12/Operations"] = { 246, 270, 532, 556 },
			["12x12/Pause"] = { 272, 296, 532, 556 },
			["12x12/Post"] = { 298, 322, 532, 556 },
			["12x12/Posting"] = { 324, 348, 536, 560 },
			["12x12/Queue"] = { 350, 374, 536, 560 },
			["12x12/Reset"] = { 376, 400, 546, 570 },
			["12x12/Resize"] = { 402, 426, 560, 584 },
			["12x12/Running"] = { 428, 452, 562, 586 },
			["12x12/SaleRate"] = { 454, 478, 584, 608 },
			["12x12/Search"] = { 480, 504, 584, 608 },
			["12x12/Settings"] = { 112, 136, 558, 582 },
			["12x12/Shopping"] = { 78, 102, 580, 604 },
			["12x12/SideArrow"] = { 52, 76, 592, 616 },
			["12x12/SkillUp"] = { 0, 24, 608, 632 },
			["12x12/SkillUp/1"] = { 26, 50, 608, 632 },
			["12x12/SkillUp/10"] = { 138, 162, 558, 582 },
			["12x12/SkillUp/2"] = { 164, 188, 558, 582 },
			["12x12/SkillUp/3"] = { 190, 214, 558, 582 },
			["12x12/SkillUp/4"] = { 216, 240, 558, 582 },
			["12x12/SkillUp/5"] = { 242, 266, 558, 582 },
			["12x12/SkillUp/6"] = { 268, 292, 558, 582 },
			["12x12/SkillUp/7"] = { 294, 318, 558, 582 },
			["12x12/SkillUp/8"] = { 320, 344, 562, 586 },
			["12x12/SkillUp/9"] = { 346, 370, 562, 586 },
			["12x12/Skip"] = { 372, 396, 572, 596 },
			["12x12/Sniper"] = { 398, 422, 586, 610 },
			["12x12/Star/Filled"] = { 424, 448, 588, 612 },
			["12x12/Star/Unfilled"] = { 450, 474, 610, 634 },
			["12x12/Stop"] = { 476, 500, 610, 634 },
			["12x12/Subtract/Circle"] = { 104, 128, 584, 608 },
			["12x12/Subtract/Default"] = { 78, 102, 606, 630 },
			["14x14/Add/Circle"] = { 484, 512, 0, 28 },
			["14x14/Add/Default"] = { 484, 512, 30, 58 },
			["14x14/Arrow/Down"] = { 350, 378, 38, 66 },
			["14x14/Arrow/Up"] = { 350, 378, 68, 96 },
			["14x14/Auctions"] = { 480, 508, 60, 88 },
			["14x14/Bid"] = { 480, 508, 90, 118 },
			["14x14/Boxes"] = { 350, 378, 98, 126 },
			["14x14/Buyout"] = { 350, 378, 128, 156 },
			["14x14/Carot/Collapsed"] = { 480, 508, 120, 148 },
			["14x14/Carot/Expanded"] = { 480, 508, 150, 178 },
			["14x14/Checkmark/Circle"] = { 480, 508, 180, 208 },
			["14x14/Checkmark/Default"] = { 350, 378, 158, 186 },
			["14x14/Chevron/Collapsed"] = { 480, 508, 210, 238 },
			["14x14/Chevron/Expanded"] = { 480, 508, 240, 268 },
			["14x14/Chevron/Inactive"] = { 480, 508, 270, 298 },
			["14x14/Clock"] = { 478, 506, 300, 328 },
			["14x14/Close/Circle"] = { 478, 506, 330, 358 },
			["14x14/Close/Default"] = { 478, 506, 360, 388 },
			["14x14/Coins"] = { 478, 506, 390, 418 },
			["14x14/Configure"] = { 364, 392, 390, 418 },
			["14x14/Crafting"] = { 394, 422, 390, 418 },
			["14x14/Dashboard"] = { 424, 452, 404, 432 },
			["14x14/Delete"] = { 476, 504, 420, 448 },
			["14x14/DragHandle"] = { 136, 164, 416, 444 },
			["14x14/Duplicate"] = { 98, 126, 438, 466 },
			["14x14/Edit"] = { 0, 28, 466, 494 },
			["14x14/Expire"] = { 30, 58, 466, 494 },
			["14x14/Filter"] = { 166, 194, 416, 444 },
			["14x14/Groups"] = { 196, 224, 416, 444 },
			["14x14/Help"] = { 226, 254, 416, 444 },
			["14x14/Hide"] = { 256, 284, 416, 444 },
			["14x14/Import"] = { 286, 314, 416, 444 },
			["14x14/Inventory"] = { 316, 344, 416, 444 },
			["14x14/Link"] = { 346, 374, 420, 448 },
			["14x14/More"] = { 376, 404, 420, 448 },
			["14x14/New"] = { 406, 434, 434, 462 },
			["14x14/Operations"] = { 436, 464, 448, 476 },
			["14x14/Pause"] = { 466, 494, 450, 478 },
			["14x14/Post"] = { 128, 156, 446, 474 },
			["14x14/Posting"] = { 98, 126, 468, 496 },
			["14x14/Queue"] = { 60, 88, 480, 508 },
			["14x14/Reset"] = { 0, 28, 496, 524 },
			["14x14/Resize"] = { 30, 58, 496, 524 },
			["14x14/Running"] = { 158, 186, 446, 474 },
			["14x14/SaleRate"] = { 188, 216, 446, 474 },
			["14x14/Search"] = { 218, 246, 446, 474 },
			["14x14/Settings"] = { 248, 276, 446, 474 },
			["14x14/Shopping"] = { 278, 306, 446, 474 },
			["14x14/SideArrow"] = { 308, 336, 446, 474 },
			["14x14/SkillUp"] = { 338, 366, 450, 478 },
			["14x14/SkillUp/1"] = { 368, 396, 450, 478 },
			["14x14/SkillUp/10"] = { 398, 426, 464, 492 },
			["14x14/SkillUp/2"] = { 428, 456, 478, 506 },
			["14x14/SkillUp/3"] = { 458, 486, 480, 508 },
			["14x14/SkillUp/4"] = { 128, 156, 476, 504 },
			["14x14/SkillUp/5"] = { 90, 118, 498, 526 },
			["14x14/SkillUp/6"] = { 60, 88, 510, 538 },
			["14x14/SkillUp/7"] = { 0, 28, 526, 554 },
			["14x14/SkillUp/8"] = { 30, 58, 526, 554 },
			["14x14/SkillUp/9"] = { 158, 186, 476, 504 },
			["14x14/Skip"] = { 188, 216, 476, 504 },
			["14x14/Sniper"] = { 218, 246, 476, 504 },
			["14x14/Star/Filled"] = { 248, 276, 476, 504 },
			["14x14/Star/Unfilled"] = { 278, 306, 476, 504 },
			["14x14/Stop"] = { 308, 336, 476, 504 },
			["14x14/Subtract/Circle"] = { 338, 366, 480, 508 },
			["14x14/Subtract/Default"] = { 368, 396, 480, 508 },
			["18x18/Add/Circle"] = { 150, 186, 188, 224 },
			["18x18/Add/Default"] = { 100, 136, 210, 246 },
			["18x18/Arrow/Down"] = { 0, 36, 238, 274 },
			["18x18/Arrow/Up"] = { 38, 74, 238, 274 },
			["18x18/Auctions"] = { 188, 224, 188, 224 },
			["18x18/Bid"] = { 226, 262, 188, 224 },
			["18x18/Boxes"] = { 264, 300, 188, 224 },
			["18x18/Buyout"] = { 302, 338, 188, 224 },
			["18x18/Carot/Collapsed"] = { 340, 376, 188, 224 },
			["18x18/Carot/Expanded"] = { 378, 414, 200, 236 },
			["18x18/Checkmark/Circle"] = { 416, 452, 200, 236 },
			["18x18/Checkmark/Default"] = { 138, 174, 226, 262 },
			["18x18/Chevron/Collapsed"] = { 98, 134, 248, 284 },
			["18x18/Chevron/Expanded"] = { 0, 36, 276, 312 },
			["18x18/Chevron/Inactive"] = { 38, 74, 276, 312 },
			["18x18/Clock"] = { 176, 212, 226, 262 },
			["18x18/Close/Circle"] = { 214, 250, 226, 262 },
			["18x18/Close/Default"] = { 252, 288, 226, 262 },
			["18x18/Coins"] = { 290, 326, 226, 262 },
			["18x18/Configure"] = { 328, 364, 226, 262 },
			["18x18/Crafting"] = { 366, 402, 238, 274 },
			["18x18/Dashboard"] = { 404, 440, 238, 274 },
			["18x18/Delete"] = { 442, 478, 252, 288 },
			["18x18/DragHandle"] = { 136, 172, 264, 300 },
			["18x18/Duplicate"] = { 98, 134, 286, 322 },
			["18x18/Edit"] = { 0, 36, 314, 350 },
			["18x18/Expire"] = { 38, 74, 314, 350 },
			["18x18/Filter"] = { 174, 210, 264, 300 },
			["18x18/Groups"] = { 212, 248, 264, 300 },
			["18x18/Help"] = { 250, 286, 264, 300 },
			["18x18/Hide"] = { 288, 324, 264, 300 },
			["18x18/Import"] = { 326, 362, 264, 300 },
			["18x18/Inventory"] = { 364, 400, 276, 312 },
			["18x18/Link"] = { 402, 438, 276, 312 },
			["18x18/More"] = { 440, 476, 290, 326 },
			["18x18/New"] = { 136, 172, 302, 338 },
			["18x18/Operations"] = { 98, 134, 324, 360 },
			["18x18/Pause"] = { 0, 36, 352, 388 },
			["18x18/Post"] = { 38, 74, 352, 388 },
			["18x18/Posting"] = { 174, 210, 302, 338 },
			["18x18/Queue"] = { 212, 248, 302, 338 },
			["18x18/Reset"] = { 250, 286, 302, 338 },
			["18x18/Resize"] = { 288, 324, 302, 338 },
			["18x18/Running"] = { 326, 362, 302, 338 },
			["18x18/SaleRate"] = { 364, 400, 314, 350 },
			["18x18/Search"] = { 402, 438, 314, 350 },
			["18x18/Settings"] = { 440, 476, 328, 364 },
			["18x18/Shopping"] = { 136, 172, 340, 376 },
			["18x18/SideArrow"] = { 98, 134, 362, 398 },
			["18x18/SkillUp"] = { 0, 36, 390, 426 },
			["18x18/SkillUp/1"] = { 38, 74, 390, 426 },
			["18x18/SkillUp/10"] = { 174, 210, 340, 376 },
			["18x18/SkillUp/2"] = { 212, 248, 340, 376 },
			["18x18/SkillUp/3"] = { 250, 286, 340, 376 },
			["18x18/SkillUp/4"] = { 288, 324, 340, 376 },
			["18x18/SkillUp/5"] = { 326, 362, 340, 376 },
			["18x18/SkillUp/6"] = { 364, 400, 352, 388 },
			["18x18/SkillUp/7"] = { 402, 438, 352, 388 },
			["18x18/SkillUp/8"] = { 440, 476, 366, 402 },
			["18x18/SkillUp/9"] = { 136, 172, 378, 414 },
			["18x18/Skip"] = { 98, 134, 400, 436 },
			["18x18/Sniper"] = { 0, 36, 428, 464 },
			["18x18/Star/Filled"] = { 38, 74, 428, 464 },
			["18x18/Star/Unfilled"] = { 174, 210, 378, 414 },
			["18x18/Stop"] = { 212, 248, 378, 414 },
			["18x18/Subtract/Circle"] = { 250, 286, 378, 414 },
			["18x18/Subtract/Default"] = { 288, 324, 378, 414 },
			["24x24/Auctions"] = { 384, 432, 0, 48 },
			["24x24/Bid"] = { 434, 482, 0, 48 },
			["24x24/Boxes"] = { 0, 48, 38, 86 },
			["24x24/Buyout"] = { 50, 98, 38, 86 },
			["24x24/Close/Circle"] = { 100, 148, 38, 86 },
			["24x24/Close/Default"] = { 150, 198, 38, 86 },
			["24x24/Coins"] = { 200, 248, 38, 86 },
			["24x24/Crafting"] = { 250, 298, 38, 86 },
			["24x24/Dashboard"] = { 300, 348, 38, 86 },
			["24x24/Groups"] = { 380, 428, 50, 98 },
			["24x24/Import"] = { 430, 478, 50, 98 },
			["24x24/Inventory"] = { 0, 48, 88, 136 },
			["24x24/Mail"] = { 50, 98, 88, 136 },
			["24x24/Notifications"] = { 100, 148, 88, 136 },
			["24x24/Operations"] = { 150, 198, 88, 136 },
			["24x24/Other"] = { 200, 248, 88, 136 },
			["24x24/Pause"] = { 250, 298, 88, 136 },
			["24x24/Post"] = { 300, 348, 88, 136 },
			["24x24/Posting"] = { 380, 428, 100, 148 },
			["24x24/Send Mail"] = { 430, 478, 100, 148 },
			["24x24/Settings"] = { 380, 428, 150, 198 },
			["24x24/Shopping"] = { 430, 478, 150, 198 },
			["24x24/Skip"] = { 0, 48, 138, 186 },
			["24x24/Sniper"] = { 50, 98, 138, 186 },
			["24x24/Stop"] = { 100, 148, 138, 186 },
			["Misc/BackArrow"] = { 100, 148, 188, 208 },
			["Misc/Checkbox/Checked"] = { 150, 198, 138, 186 },
			["Misc/Checkbox/Checked/Disabled"] = { 200, 248, 138, 186 },
			["Misc/Checkbox/Unchecked"] = { 250, 298, 138, 186 },
			["Misc/Checkbox/Unchecked/Disabled"] = { 300, 348, 138, 186 },
			["Misc/Knob"] = { 326, 362, 378, 414 },
			["Misc/Radio/Checked"] = { 0, 48, 188, 236 },
			["Misc/Radio/Unchecked"] = { 50, 98, 188, 236 },
			["Misc/Toggle/Off"] = { 0, 94, 0, 36 },
			["Misc/Toggle/Off/Disabled"] = { 96, 190, 0, 36 },
			["Misc/Toggle/On"] = { 192, 286, 0, 36 },
			["Misc/Toggle/On/Disabled"] = { 288, 382, 0, 36 },
		},
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function TexturePacks.IsValid(key)
	-- if not key then return false end
	local fileInfo, coord = private.GetFileInfo(key)
	return fileInfo and coord and true or false
end

function TexturePacks.GetTexturePath(key)
	local fileInfo = private.GetFileInfo(key)
	assert(fileInfo)
	return fileInfo.path
end

function TexturePacks.GetTexCoord(key)
	local fileInfo, coord = private.GetFileInfo(key)
	assert(fileInfo and coord)
	local minX, maxX, minY, maxY = unpack(coord)
	minX = minX / fileInfo.width
	maxX = maxX / fileInfo.width
	minY = minY / fileInfo.height
	maxY = maxY / fileInfo.height
	return minX, maxX, minY, maxY
end

function TexturePacks.GetTexCoordRotated(key, angle)
	return private.RotateTexCoords(angle, TexturePacks.GetTexCoord(key))
end

function TexturePacks.GetSize(key)
	local fileInfo, coord = private.GetFileInfo(key)
	assert(fileInfo and coord)
	local minX, maxX, minY, maxY = unpack(coord)
	local width = (maxX - minX) / fileInfo.scale
	local height = (maxY - minY) / fileInfo.scale
	return width, height
end

function TexturePacks.GetWidth(key)
	local width = TexturePacks.GetSize(key)
	return width
end

function TexturePacks.GetHeight(key)
	local _, height = TexturePacks.GetSize(key)
	return height
end

function TexturePacks.SetTexture(texture, key)
	texture:SetTexture(TexturePacks.GetTexturePath(key))
	texture:SetTexCoord(TexturePacks.GetTexCoord(key))
end

function TexturePacks.SetTextureRotated(texture, key, angle)
	texture:SetTexture(TexturePacks.GetTexturePath(key))
	texture:SetTexCoord(TexturePacks.GetTexCoordRotated(key, angle))
end

function TexturePacks.SetSize(texture, key)
	local width, height = TexturePacks.GetSize(key)
	texture:SetWidth(width)
	texture:SetHeight(height)
end

function TexturePacks.SetWidth(texture, key)
	texture:SetWidth(TexturePacks.GetWidth(key))
end

function TexturePacks.SetHeight(texture, key)
	texture:SetHeight(TexturePacks.GetHeight(key))
end

function TexturePacks.SetTextureAndWidth(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetWidth(texture, key)
end

function TexturePacks.SetTextureAndHeight(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetHeight(texture, key)
end

function TexturePacks.SetTextureAndSize(texture, key)
	TexturePacks.SetTexture(texture, key)
	TexturePacks.SetSize(texture, key)
end

function TexturePacks.SetTextureAndSizeRotated(texture, key, angle)
	TexturePacks.SetTextureRotated(texture, key, angle)
	TexturePacks.SetSize(texture, key)
end

function TexturePacks.GetTextureLink(key)
	local path = TexturePacks.GetTexturePath(key)
	local width, height = TexturePacks.GetSize(key)
	local fileInfo, coord = private.GetFileInfo(key)
	assert(fileInfo and coord)
	local minX, maxX, minY, maxY = unpack(coord)
	return "|T"..strjoin(":", path, width, height, 0, 0, fileInfo.width, fileInfo.height, minX, maxX, minY, maxY).."|t"
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetFileInfo(key)
	local file, entry = strmatch(key, "^([^%.]+)%.(.+)$")
	local fileInfo = file and TEXTURE_FILE_INFO[file]
	return fileInfo, fileInfo and fileInfo.coord[entry]
end

function private.RotateTexCoords(angle, minX, maxX, minY, maxY)
	local centerX = (minX + maxX) / 2
	local centerY = (minY + maxY) / 2
	local ULx, ULy = private.RotateCoordPair(minX, minY, centerX, centerY, angle)
	local LLx, LLy = private.RotateCoordPair(minX, maxY, centerX, centerY, angle)
	local URx, URy = private.RotateCoordPair(maxX, minY, centerX, centerY, angle)
	local LRx, LRy = private.RotateCoordPair(maxX, maxY, centerX, centerY, angle)
	return ULx, ULy, LLx, LLy, URx, URy, LRx, LRy
end

function private.RotateCoordPair(x, y, originX, originY, angle)
	local cosResult = cos(angle)
	local sinResult = sin(angle)
	local resultX = originX + (x - originX) * cosResult - (y - originY) * sinResult
	local resultY = originY + (y - originY) * cosResult + (x - originX) * sinResult
	return resultX, resultY
end
