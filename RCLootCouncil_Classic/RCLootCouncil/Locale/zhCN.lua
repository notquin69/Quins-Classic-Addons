-- Translate RCLootCouncil to your language at:
-- http://wow.curseforge.com/addons/rclootcouncil/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("RCLootCouncil", "zhCN")
if not L then return end

L[" is not active in this raid."] = "在当前团队中未启用。"
L[" you are now the Master Looter and RCLootCouncil is now handling looting."] = "你现在是战利品分配者，RCLootCouncil正在管理分配。"
L["&p was awarded with &i for &r!"] = "&p获得了&i，理由为&r！"
L["A format to copy/paste to another player."] = "一个可以给其他玩家复制/粘贴的格式。"
L["A new session has begun, type '/rc open' to open the voting frame."] = "新的分配会话已经开始，输入'/rc open'打开投票界面。"
L["A tab delimited output for Excel. Might work with other spreadsheets."] = "以Tab字符分隔的导出格式。支持Excel。也有可能支持其他类型表格软件。"
L["Abort"] = "中止"
L["Accept Whispers"] = "接受密语"
L["accept_whispers_desc"] = "允许玩家密语他们当前的物品给你，以添加到分配界面。"
L["Active"] = "启用"
L["active_desc"] = "取消勾选以禁用RCLootCouncil。当你在团队中但没参与副本活动时这很有用。备注：此选项在每次登出时重置。"
L["Add Item"] = "添加物品"
L["Add Note"] = "添加备注"
L["Add ranks"] = "添加会阶"
L["Add rolls"] = "添加掷骰"
L["Add Rolls"] = "添加掷骰"
L["add_ranks_desc"] = "选择参与战利品分配议会的最低会阶"
L["add_ranks_desc2"] = [=[在上方选择一个会阶，添加该会阶以及高于此会阶的所有公会成员为议会成员。

点击左侧的会阶，添加指定玩家为议会成员。

点击"当前议会成员"页来查看你所选择的成员。]=]
L["add_rolls_desc"] = "自动给所有会话添加1-100的掷点。"
--[[Translation missing --]]
L["Additional Buttons"] = "Additional Buttons"
L["All items"] = "所有物品"
--[[Translation missing --]]
L["All items have been awarded and the loot session concluded"] = "All items have been awarded and the loot session concluded"
L["All items usable by the candidate"] = "所有此人可用的物品"
L["All unawarded items"] = "所有未分配物品"
L["Alt click Looting"] = "Alt+左键分配"
L["alt_click_looting_desc"] = "启用Alt+左键分配。使用Alt+左键点击物品以开始分配。"
L["Alternatively, flag the loot as award later."] = "另外，标记该物品为稍后分配。"
--[[Translation missing --]]
L["Always use RCLootCouncil with Personal Loot"] = "Always use RCLootCouncil with Personal Loot"
L["always_show_tooltip_howto"] = "双击切换是否总显示tooltip"
L["Announce Awards"] = "通告分配"
L["Announce Considerations"] = "通告考虑的物品"
L["announce_&i_desc"] = "|cfffcd400 &i|r: 物品链接。"
L["announce_&l_desc"] = "|cfffcd400 &l|r: 物品等级。"
--[[Translation missing --]]
L["announce_&m_desc"] = "|cfffcd400 &m|r: candidates note."
L["announce_&n_desc"] = "|cfffcd400 &n|r: 掷骰结果，如果有的话。"
--[[Translation missing --]]
L["announce_&o_desc"] = "|cfffcd400 &o|r: item owner, if applicable."
L["announce_&p_desc"] = "|cfffcd400 &p|r: 获得装备的玩家姓名。"
L["announce_&r_desc"] = "|cfffcd400 &r|r: 原因。"
L["announce_&s_desc"] = "|cfffcd400 &s|r: 会话id。"
L["announce_&t_desc"] = "|cfffcd400 &t|r: 物品类型。"
L["announce_awards_desc"] = "在聊天频道中显示物品分配信息。"
L["announce_awards_desc2"] = [=[
选择要通告物品分配信息的频道。提供以下关键字替换：]=]
L["announce_considerations_desc"] = "当物品分配开始时，通告待定的物品。"
L["announce_considerations_desc2"] = [=[
选择你想通告的频道和消息。
该消息将出现在物品列表之前。]=]
L["announce_item_string_desc"] = "输入每件物品的通告文字。提供以下关键字替换："
L["Announcements"] = "通告"
L["Anonymous Voting"] = "匿名投票"
L["anonymous_voting_desc"] = "开启匿名投票，成员无法看到谁投给了谁。"
L["Append realm names"] = "附加服务器名"
L["Are you sure you want to abort?"] = "确定要中止分配吗？"
L["Are you sure you want to give #item to #player?"] = "确定将%s分配给 %s？"
L["Are you sure you want to reannounce all unawarded items to %s?"] = "你确定要向 %s 重新通告所有未分配物品吗？"
L["Are you sure you want to request rolls for all unawarded items from %s?"] = "你确定要让 %s 对所有未分配物品掷点吗？"
L["Armor Token"] = "套装代币"
--[[Translation missing --]]
L["Ask me every time Personal Loot is enabled"] = "Ask me every time Personal Loot is enabled"
L["Auto Award"] = "自动分配"
L["Auto Award to"] = "自动分配给"
L["Auto awarded 'item'"] = "自动分配 %s"
L["Auto Close"] = "自动关闭"
L["Auto Enable"] = "自动开启"
L["Auto extracted from whisper"] = "自动从密语中提取"
L["Auto Open"] = "自动打开"
L["Auto Pass"] = "自动放弃"
L["Auto pass BoE"] = "自动放弃装绑"
L["Auto Pass Trinkets"] = "自动放弃饰品"
L["Auto Start"] = "自动开始"
--[[Translation missing --]]
L["Auto Trade"] = "Auto Trade"
L["auto_award_desc"] = "启用自动分配。"
L["auto_award_to_desc"] = "接受自动分配物品的玩家。当在团队中时，会有一个可选择团队成员的列表。"
L["auto_close_desc"] = "在战利品分配者结束物品分配时自动关闭投票窗口"
L["auto_enable_desc"] = "总是让RCLootCouncil管理物品分配。非勾选状态下，每次加入团队或成为战利品分配者时，插件都会询问是否开启。"
L["auto_loot_desc"] = "开启自动拾取所有可装备的物品。"
L["auto_open_desc"] = "勾选以自动打开投票界面。非勾选状态下，也可通过输入 /rc open 手动开启。注意：需要战利品分配者的许可。"
L["auto_pass_boe_desc"] = "取消勾选以禁用自动放弃装绑。"
L["auto_pass_desc"] = "勾选以自动放弃当前职业无法使用的物品。"
L["auto_pass_trinket_desc"] = "选中以自动放弃地下城手册中不属于你的职业的饰品"
L["auto_start_desc"] = "启用自动开始，开始分配所有符合条件的物品。取消勾选则会在开始分配物品前显示选择要分配物品的列表。"
L["Autoloot all BoE"] = "自动拾取所有装绑"
L["Autoloot BoE"] = "自动拾取装绑"
L["autoloot_BoE_desc"] = "开启自动拾取装绑物品。"
L["autoloot_others_BoE_desc"] = "启用以自动将装绑物品加入分配。"
L["autoloot_others_item_combat"] = "%s 拾取了%s。此物品将会在战斗结束后加入分配。"
L["Autopass"] = "自动放弃"
L["Autopassed on 'item'"] = "自动放弃%s"
L["Autostart isn't supported when testing"] = "测试模式不支持自动开始"
L["award"] = "奖励"
L["Award"] = "分配"
L["Award Announcement"] = "分配通告"
L["Award for ..."] = "分配为"
L["Award later"] = "稍后分配"
L["Award later isn't supported when testing."] = "测试模式不支持稍后分配。"
L["Award later?"] = "稍后分配？"
L["Award Reasons"] = "分配理由"
L["award_reasons_desc"] = [=[团员无法选择的分配理由。
用于自动分配以及右键手动指定分配原因。
]=]
L["Awarded"] = "已分配"
L["Awarded item cannot be awarded later."] = "已分配物品无法被稍后分配。"
L["Awards"] = "分配"
--[[Translation missing --]]
L["Azerite Armor"] = "Azerite Armor"
L["Background"] = "背景"
L["Background Color"] = "背景颜色"
L["Banking"] = "收藏"
L["BBCode export, tailored for SMF."] = "BBCode格式导出，适配SMF。"
L["Border"] = "边框"
L["Border Color"] = "边框颜色"
L["Button"] = "按钮"
L["Buttons and Responses"] = "按钮与回应"
L["buttons_and_responses_desc"] = [=[设置团队成员拾取界面的回应按钮。
在这里的顺序决定了投票窗口的排序，并且在拾取界面是从左到右排列的，使用滑动条设置按钮的数量 (最多为 %d)。

"放弃" 按钮自动添加至最右侧]=]
L["Candidate didn't respond on time"] = "没有及时回应"
L["Candidate has disabled RCLootCouncil"] = "RCLootCouncil已被禁用"
L["Candidate is not in the instance"] = "不在副本中"
L["Candidate is selecting response, please wait"] = "正在考虑中，请稍等"
L["Candidate removed"] = "已被排除"
L["Candidates that can't use the item"] = "无法使用此物品的人"
L["Cannot autoaward:"] = "无法自动分配："
L["Cannot give 'item' to 'player' due to Blizzard limitations. Gave it to you for distribution."] = "由于暴雪的限制，你无法将 %s 分配给 %s。交给你分配了。"
L["Change Award"] = "变更分配"
L["Change Response"] = "更改回应"
L["Changing loot threshold to enable Auto Awarding"] = "更改物品分配界限以启用自动分配"
L["Changing LootMethod to Master Looting"] = "拾取方式更改为队长分配"
L["channel_desc"] = "要发送消息的频道。"
--[[Translation missing --]]
L["Chat print"] = "Chat print"
L["chat tVersion string"] = "|cFF87CEFARCLootCouncil |cFFFFFFFF版本 |cFFFFA500 %s - %s"
L["chat version String"] = "|cFF87CEFARCLootCouncil |cFFFFFFFF版本 |cFFFFA500 %s"
--[[Translation missing --]]
L["chat_cmd_add_invalid_owner"] = "The player %s was either invalid or not a candidate."
L["chat_commands_add"] = "将一个物品加入分配"
L["chat_commands_award"] = "开始分配你之前稍后分配的物品。"
L["chat_commands_config"] = "打开设置界面"
L["chat_commands_council"] = "打开议会界面"
L["chat_commands_history"] = "打开历史界面(简称： 'h' 或者 'his')"
L["chat_commands_open"] = "打开投票界面"
L["chat_commands_reset"] = "重置界面位置"
L["chat_commands_sync"] = "打开设置同步器"
L["chat_commands_test"] = "模拟有#个物品的分配进程。如果省略默认为一个物品"
L["chat_commands_version"] = "打开版本检查器 (简称： 'v' 或者 'ver')"
L["chat_commands_whisper"] = "显示密语帮助"
L["chat_commands_winners"] = "显示稍后分配的物品的获胜者。"
L["Check this to loot the items and distribute them later."] = "勾选此项将拾取这些物品并稍后分配。"
L["Check to append the realmname of a player from another realm"] = "勾选以显示来自其他服务器玩家的服务器名"
L["Check to have all frames minimize when entering combat"] = "勾选此项将使所有窗口在进入战斗时最小化"
L["Choose timeout length in seconds"] = "选择超时时长(秒)"
L["Choose when to use RCLootCouncil"] = "选择何时使用RCLootCouncil"
L["Clear Loot History"] = "清除拾取历史"
L["Clear Selection"] = "清除选择"
L["clear_loot_history_desc"] = "清除所有拾取历史记录。"
L["Click to add note to send to the council."] = "点击添加要发送给议会的备注。"
L["Click to change your note."] = "点击修改备注。"
L["Click to expand/collapse more info"] = "点击展开/折叠更多信息"
L["Click to switch to 'item'"] = "点击切换为 %s"
L["config"] = "配置"
L["confirm_award_later_text"] = "你确认稍后分配物品%s吗？此物品将会被记录在插件的稍后分配列表中。如果此物品在拾取窗口中，你将拾取此物品。你可以之后使用命令'/rc award'分配此物品。"
L["confirm_usage_text"] = [=[|cFF87CEFA RCLootCouncil |r

是否在此团队使用RCLootCouncil？]=]
L["Conqueror Token"] = "征服者代币"
L["Could not Auto Award i because the Loot Threshold is too high!"] = "无法自动分配%s因为拾取物品分配界限过高！"
L["Could not find 'player' in the group."] = "在队伍中无法找到 %s。"
L["Couldn't find any councilmembers in the group"] = "在队伍中无法找到任何议会成员"
L["council"] = "议会"
L["Council"] = "议会"
L["Current Council"] = "当前议会成员"
L["current_council_desc"] = [=[
点击将指定玩家从议会中移除
]=]
L["Customize appearance"] = "自定义外观"
L["customize_appearance_desc"] = "你可以在这定制RCLootCouncil的外观。使用上方的保存功能快速切换皮肤。"
L["Data Received"] = "数据已接收"
L["Date"] = "日期"
L["days and x months"] = "%s 和%d月。"
L["days, x months, y years"] = "%s，%d月%d 年。"
L["Delete Skin"] = "删除皮肤"
L["delete_skin_desc"] = "从列表中删除当前选择的非默认皮肤。"
L["Deselect responses to filter them"] = "取消选择回应以过滤它们"
L["Diff"] = "提升"
--[[Translation missing --]]
L["Discord friendly output."] = "Discord friendly output."
L["disenchant_desc"] = "当通过'分解'按钮分配物品时使用该理由"
--[[Translation missing --]]
L["Do you want to keep %s for yourself?"] = "Do you want to keep %s for yourself?"
L["Done syncing"] = "同步完成"
L["Double click to delete this entry."] = "双击删除此项"
L["Dropped by:"] = "掉落自："
L["Edit Entry"] = "修改此项"
L["Enable Loot History"] = "启用拾取历史"
L["Enable Timeout"] = "启用超时"
L["enable_loot_history_desc"] = "启用历史记录。如果关闭，RCLootCouncil 将不会记录任何数据。"
L["enable_timeout_desc"] = "勾选以启用拾取窗口限时"
L["Enter your note:"] = "输入你的备注："
L["EQdkp-Plus XML output, tailored for Enjin import."] = "EQdkp-Plus XML导出，适用 Enjin。"
--[[Translation missing --]]
L["error_test_as_non_leader"] = "You cannot initiate a test while in a group without being the group leader."
--[[Translation missing --]]
L["Everybody is up to date."] = "Everybody is up to date."
L["Everyone have voted"] = "所有人都已投票"
L["Export"] = "导出"
--[[Translation missing --]]
L["Fake Loot"] = "Fake Loot"
L["Following items were registered in the award later list:"] = "以下物品已被稍后分配列表登记："
L["Following winners was registered:"] = "以下获胜者已被登记："
--[[Translation missing --]]
L["Found the following outdated versions"] = "Found the following outdated versions"
L["Frame options"] = "框架选项"
L["Free"] = "自由支配"
--[[Translation missing --]]
L["Full Bags"] = "Full Bags"
L["g1"] = true
L["g2"] = true
L["Gave the item to you for distribution."] = "将物品给你分配。"
L["General options"] = "常规选项"
L["Group Council Members"] = "队伍议会成员"
L["group_council_members_desc"] = "在此将来自其他服务器或其他公会的成员添加至议会。"
L["group_council_members_head"] = "从当前队伍添加议会成员。"
L["Guild Council Members"] = "公会议会成员"
L["Hide Votes"] = "隐藏投票"
L["hide_votes_desc"] = "直到玩家投票后才能看见投票详情。"
L["How to sync"] = "如何同步"
L["huge_export_desc"] = "大量数据。只显示第一行以避免游戏卡顿。可以使用Ctrl+C复制全部内容。"
L["Ignore List"] = "忽略列表"
L["Ignore Options"] = "忽略选项"
L["ignore_input_desc"] = "输入一个物品ID，将其添加至忽略列表，RCLootCouncil不再将此物品加入分配列表"
L["ignore_input_usage"] = "此功能只接受物品ID(数字), 物品名字以及物品链接"
L["ignore_list_desc"] = "被RCLootCouncil忽略的物品，点击该物品来移除它。"
L["ignore_options_desc"] = "控制RCLootCouncil忽略的物品。如果添加的物品未显示，切到其他标签再切回来，这样你就可以看到了。"
L["import_desc"] = "将数据粘贴于此。只显示前2500个字符以避免游戏卡顿。"
--[[Translation missing --]]
L["Invalid selection"] = "Invalid selection"
L["Item"] = "物品"
L["'Item' is added to the award later list."] = "%s被加入到了稍后分配列表了。"
L["Item quality is below the loot threshold"] = "物品品质低于物品分配界限。"
L["Item received and added from 'player'"] = "物品已收到，来自 %s。"
L["Item was awarded to"] = "物品被分配给了"
L["Item(s) replaced:"] = "被替换的物品："
L["item_in_bags_low_trade_time_remaining_reminder"] = "你的背包中的以下在稍后分配列表的物品剩余交易时间不足%s。如果你想避免此提示，交易该物品，使用‘/rc remove [index]’将物品从列表中移除，使用‘/rc clear’清空列表，或者装备该物品使其无法被交易。"
L["Items stored in the loot master's bag for award later cannot be awarded later."] = "存放在战利品分配者背包内的物品无法被稍后分配。"
L["Items under consideration:"] = "在考虑中的物品："
L["Latest item(s) won"] = "最近获得的物品"
L["Length"] = "长度"
L["Log"] = "记录"
L["log_desc"] = "启用以在拾取历史中记录"
L["Loot announced, waiting for answer"] = "拾取已通告，等待回应"
L["Loot Everything"] = "全部拾取"
L["Loot History"] = "拾取历史"
--[[Translation missing --]]
L["Loot Status"] = "Loot Status"
L["Loot won:"] = "赢得的拾取："
L["loot_everything_desc"] = "开启自动拾取非装备类物品(例如坐骑，套装兑换物)"
L["loot_history_desc"] = [=[RCLootCouncil 将自动记录分配相关信息。
原始数据储存在 ".../SavedVariables/RCLootCouncil.lua"。

注意: 非物品分配者只会储存来自物品分配者发送的数据。
]=]
--[[Translation missing --]]
L["Looted"] = "Looted"
--[[Translation missing --]]
L["Looted by:"] = "Looted by:"
L["Looting options"] = "拾取选项"
L["Lower Quality Limit"] = "最低品质限定"
L["lower_quality_limit_desc"] = [=[选择自动分配时物品的最低品质限定 (含此品质！)。
注意: 这将会更改物品分配界限。]=]
L["Mainspec/Need"] = "主天赋/需求"
--[[Translation missing --]]
L["Mass deletion of history entries."] = "Mass deletion of history entries."
L["Master Looter"] = "战利品分配者"
L["master_looter_desc"] = "注意: 这些设置仅供战利品分配者使用。"
L["Message"] = "消息"
L["Message for each item"] = "每件物品的信息"
L["message_desc"] = "要发送至所选频道的消息。"
L["Minimize in combat"] = "战斗中最小化"
L["Minor Upgrade"] = "小提升"
L["ML sees voting"] = "物品分配者可见投票"
L["ml_sees_voting_desc"] = "允许物品分配者查看投票详情。"
L["module_tVersion_outdated_msg"] = "最新模块 %s 的测试版本为: %s"
L["module_version_outdated_msg"] = "模块 %s 版本 %s 已过期。新版本为 %s。"
L["Modules"] = "模块"
L["More Info"] = "更多信息"
L["more_info_desc"] = "选择希望看到几名回复者上一次获得的物品。如：选择 2（默认）会显示上一次主天赋与次天赋获得的装备，以及多久以前获得的。"
L["Multi Vote"] = "多选投票"
L["multi_vote_desc"] = "允许多选投票，投票者可以投票给多个成员。"
L["'n days' ago"] = "%s 前"
L["Never use RCLootCouncil"] = "不使用RCLootCouncil"
L["new_ml_bagged_items_reminder"] = "你的稍后分配列表中有近期的物品。‘/rc list’以查看列表，‘/rc clear’以清空列表，'/rc remove [index]'以移除列表中的某一项，‘/rc award’分配稍后分配列表中的物品，‘/rc add’并在窗口中勾选稍后分配以把物品加入稍后分配列表。"
L["No (dis)enchanters found"] = "未发现附魔师"
L["No entries in the Loot History"] = "历史记录中无任何条目"
L["No entry in the award later list is removed."] = "未移除稍后分配列表中的任何一项。"
L["No items to award later registered"] = "没有已记录的稍后分配物品"
L["No recipients available"] = "无可用接收者"
L["No session running"] = "当前无分配在进行"
L["No winners registered"] = "没有已记录的获胜者"
--[[Translation missing --]]
L["non_tradeable_reason_nil"] = "Unknown"
--[[Translation missing --]]
L["non_tradeable_reason_not_tradeable"] = "Not Tradeable"
--[[Translation missing --]]
L["non_tradeable_reason_rejected_trade"] = "Wanted to keep item"
--[[Translation missing --]]
L["Non-tradeable reason:"] = "Non-tradeable reason:"
L["Not announced"] = "未通告"
L["Not cached, please reopen."] = "未缓存, 请重新打开."
L["Not Found"] = "未找到"
L["Not in your guild"] = "不在你的公会"
L["Not installed"] = "未安装"
L["Notes"] = "备注"
L["notes_desc"] = "允许成员向议会发送备注。"
L["Now handles looting"] = "现在管理分配"
L["Number of buttons"] = "按钮个数"
L["Number of raids received loot from:"] = "团本中获得物品数量："
L["Number of reasons"] = "理由个数"
L["Number of responses"] = "回应数量"
L["number_of_buttons_desc"] = "滑动以改变按钮个数。"
L["number_of_reasons_desc"] = "滑动以改变理由个数。"
L["Observe"] = "观察"
L["observe_desc"] = "允许非议会成员查看投票界面，但他们并不能投票。"
L["Offline or RCLootCouncil not installed"] = "离线或未安装RCLootCouncil"
L["Offspec/Greed"] = "副天赋/贪婪"
L["Only use in raids"] = "只在团队中启用"
L["onlyUseInRaids_desc"] = "选中此项以自动在5人小队中禁用RCLootCouncil."
L["open"] = "开启"
L["Open the Loot History"] = "打开拾取历史"
L["open_the_loot_history_desc"] = "点击打开拾取历史。"
L["Opens the synchronizer"] = "打开同步界面"
--[[Translation missing --]]
L["opt_addButton_desc"] = "Add a new button group for the selected slot."
--[[Translation missing --]]
L["opt_autoTrade_desc"] = "Check to automatically add awarded items to the trade window when trading with the winner. If disabled, you'll see a popup before items are added."
--[[Translation missing --]]
L["opt_buttonsGroup_desc"] = [=[Options group for %s buttons and responses.
See above for a detailed explanation.]=]
--[[Translation missing --]]
L["opt_deleteDate_confirm"] = [=[Are you sure you want to delete everything older than the selected?
This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deleteDate_desc"] = "Delete anything older than the selected number of days."
--[[Translation missing --]]
L["opt_deleteName_confirm"] = [=[Are you sure you want to delete all entries from %s?
This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deleteName_desc"] = "Delete all entries from the selected candidate."
--[[Translation missing --]]
L["opt_deletePatch_confirm"] = [=[Are you sure you want to delete everything older than the selected patch?
 This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deletePatch_desc"] = "Delete all entries added before the selected patch."
--[[Translation missing --]]
L["opt_moreButtons_desc"] = "Add a new set of buttons for a specific gear slot. The most specific type is used, i.e. adding buttons for 'Head' and 'Azerite Armor' will make head type armor use the head buttons instead of azerite armor."
--[[Translation missing --]]
L["opt_printCompletedTrade_Desc"] = "Check to enable a message every time a candidate trades an awarded item to the winner."
--[[Translation missing --]]
L["opt_printCompletedTrade_Name"] = "Trade Messages"
--[[Translation missing --]]
L["opt_rejectTrade_Desc"] = "Check to enable candidates to choose whether they want to 'give' the item to the council or not. If unchecked, all tradeable PL items are added automatically."
--[[Translation missing --]]
L["opt_rejectTrade_Name"] = "Allow Keeping"
--[[Translation missing --]]
L["Original Owner"] = "Original Owner"
--[[Translation missing --]]
L["Out of instance"] = "Out of instance"
--[[Translation missing --]]
L["Patch"] = "Patch"
--[[Translation missing --]]
L["Personal Loot - Non tradeable"] = "Personal Loot - Non tradeable"
--[[Translation missing --]]
L["Personal Loot - Rejected Trade"] = "Personal Loot - Rejected Trade"
L["'player' can't receive 'type'"] = "%s 不能接收 %s - 版本不符？"
L["'player' declined your sync request"] = "%s拒绝了你的同步请求"
L["'player' has asked you to reroll"] = "%s 要求你重新选择"
L["'player' has ended the session"] = "%s 结束了分配"
L["'player' has rolled 'roll' for: 'item'"] = "%s 掷出了 %d： %s"
L["'player' hasn't opened the sync window"] = "%s 没有打开同步窗口 (/rc sync)"
--[[Translation missing --]]
L["Player is ineligible for this item"] = "Player is ineligible for this item"
L["Player is not in the group"] = "玩家不在队伍中"
--[[Translation missing --]]
L["Player is not in this instance"] = "Player is not in this instance"
L["Player is offline"] = "玩家不在线"
L["Please wait a few seconds until all data has been synchronized."] = "请等待几秒以接收数据。"
L["Please wait before trying to sync again."] = "请稍后再尝试同步。"
L["Print Responses"] = "输出回应"
L["print_response_desc"] = "在聊天窗口中显示你的回应"
L["Protector Token"] = "保卫者代币"
L["Raw lua output. Doesn't work well with date selection."] = "原始 Lua 脚本导出。已知日期选择存在问题。"
L["RCLootCouncil - Synchronizer"] = "RCLootCouncil - 设置同步器"
L["RCLootCouncil Loot Frame"] = "RCLootCouncil拾取界面"
L["RCLootCouncil Loot History"] = "RCLootCouncil拾取历史记录"
L["RCLootCouncil Session Setup"] = "RCLootCouncil分配设置"
L["RCLootCouncil Version Checker"] = "RCLootCouncil版本检查器"
L["RCLootCouncil Voting Frame"] = "RCLootCouncil 投票界面"
L["rclootcouncil_trade_add_item_confirm"] = "RCLootCouncil检测到你的背包中有%d个可交易物品被分配给了 %s。你想把这些物品加入交易窗口吗？"
L["Reannounce ..."] = "再次通告..."
L["Reannounced 'item' to 'target'"] = "已重新通告 %s 给 %s"
L["Reason"] = "理由"
L["reason_desc"] = "自动分配时添加至历史记录的分配理由。"
L["Remove All"] = "移除所有"
L["Remove from consideration"] = "从待定中移除"
L["remove_all_desc"] = "移除所有议会成员。"
L["Requested rolls for 'item' from 'target'"] = "已要求 %2$s 对 %1$s 掷点"
L["Reset Skin"] = "重置皮肤"
L["Reset skins"] = "重置皮肤"
L["reset_announce_to_default_desc"] = "重置所有通告选项"
L["reset_buttons_to_default_desc"] = "重置所有按钮，颜色及其回应。"
L["reset_skin_desc"] = "重置当前皮肤的所有颜色及背景。"
L["reset_skins_desc"] = "重置默认皮肤。"
L["reset_to_default_desc"] = "重置分配理由。"
L["Response"] = "回应"
L["Response color"] = "回应颜色"
L["Response isn't available. Please upgrade RCLootCouncil."] = "回应不存在。请升级RCLootCouncil。"
L["Response options"] = "回应选项"
L["Response to 'item'"] = "对%s的回应"
L["Response to 'item' acknowledged as 'response'"] = "对%s的回应被认定为\" %s \""
L["response_color_desc"] = "为回应设置一种颜色。"
L["Responses"] = "回应"
L["Responses from Chat"] = "来自聊天的回应"
L["responses_from_chat_desc"] = [=[如果有人没有安装本插件 (当没有指定的关键字时，使用第1个按钮)。
例如："/w 战利品分配者 [物品] 贪婪" 将自动视为贪婪该物品。
在下方你可以设定每个按钮的关键词。关键词仅支持 A-Z，a-z 与 0-9，其他视为分隔符。
当插件启用时(例如在团队副本中时)，玩家可以通过密语战利品分配者"rchelp"来获取关键词列表。]=]
L["Save Skin"] = "保存皮肤"
L["save_skin_desc"] = "输入你的皮肤名称，点击'确认'以保存。注意，你可以覆盖任何非默认皮肤。"
L["Self Vote"] = "自我投票"
L["self_vote_desc"] = "允许投票者为自己投票。"
L["Send History"] = "发送历史"
L["send_history_desc"] = "发送数据给队伍中所有成员，无论是不是你自己记录的。只有你是战利品分配者时， RCLootCouncil才会发送数据。"
L["Sending 'type' to 'player'..."] = "正在发送 %s 给 %s"
L["Sent whisper help to 'player'"] = "发送密语帮助给 %s"
L["session_error"] = "出现了一些错误 - 请重新开始分配"
L["session_help_from_bag"] = "分配结束后，你可以使用命令'/rc winners'查看你应该和谁交易。"
L["session_help_not_direct"] = "此分配会话中的物品不会被直接分配。物品需要被交易。"
L["Set the text for button i's response."] = "设置第%d个按钮的回应文本"
L["Set the text on button 'number'"] = "设置第%i个按钮上的文本"
L["Set the whisper keys for button i."] = "设置第%d个按钮的密语关键词"
L["Show Spec Icon"] = "显示专精图标"
L["show_spec_icon_desc"] = "选中此项会在接收到专精信息时将候选人的职业图标替换为专精图标。"
L["Silent Auto Pass"] = "静默自动放弃"
L["silent_auto_pass_desc"] = "勾选以隐藏自动放弃信息"
L["Simple BBCode output."] = "简单BBCode导出。"
L["Skins"] = "皮肤"
L["skins_description"] = "选择一个默认皮肤或自己创建一个。注意这只有装饰效果。打开版本检查查看效果 ('/rc version')。"
--[[Translation missing --]]
L["Slot"] = "Slot"
--[[Translation missing --]]
L["Socket"] = "Socket"
L["Something went wrong :'("] = "出现了一些问题"
L["Something went wrong during syncing, please try again."] = "同步出现错误，请重试。"
L["Sort Items"] = "物品排序"
L["sort_items_desc"] = "将物品按照类型与装等排序。"
L["Standard .csv output."] = "标准csv格式导出。"
L["Status texts"] = "状态文字"
L["Store in bag and award later"] = "存入背包以稍后分配"
--[[Translation missing --]]
L["Succesfully deleted %d entries"] = "Succesfully deleted %d entries"
--[[Translation missing --]]
L["Succesfully deleted %d entries from %s"] = "Succesfully deleted %d entries from %s"
L["Successfully imported 'number' entries."] = "成功导入%d条数据。"
L["Successfully received 'type' from 'player'"] = "成功从 %2$s 获得%1$s。"
L["Sync"] = "同步"
L["sync_detailed_description"] = [=[1. 双方均应打开同步界面 (/rc sync)
2. 选择你想发送的数据类型。
3. 选择你想接收数据的玩家。
4. 点击“同步” - 你将会看到数据正在被传输的进度条。

此窗口需要打开以开始同步，
但是关闭此窗口不会打断已开始的同步。

同步目标包括在线工会成员，团队成员，朋友，以及你的当前友方目标。]=]
L["test"] = "测试"
L["Test"] = "测试"
L["test_desc"] = "为你以及团队里的所有人进行模拟分配。"
L["Text color"] = "文字颜色"
L["Text for reason #i"] = "理由#的文本"
L["text_color_desc"] = "文字显示时的颜色"
L["The award later list has been cleared."] = "已清空稍后分配列表。"
L["The award later list is empty."] = "稍后分配列表为空。"
L["The following council members have voted"] = "以下议会成员已投票"
L["The following entries are removed from the award later list:"] = "以下条目已被移除出稍后分配列表"
L["The following items are removed from the award later list and traded to 'player'"] = "以下物品已被移除出稍后分配列表并交易给了 %s"
L["The item can only be looted by you but it is not bind on pick up"] = "这件物品只能被你拾取，但是这件物品不拾取绑定。"
L["The item will be awarded later"] = "这件物品将会稍后分配"
L["The item would now be awarded to 'player'"] = "这件物品现在将被分配给 %s"
L["The loot is already on the list"] = "拾取已经在此列表"
L["The loot master"] = "战利品分配者"
L["The Master Looter doesn't allow multiple votes."] = "战利品分配者已禁用多次投票。"
L["The Master Looter doesn't allow votes for yourself."] = "战利品分配者已禁用自我投票。"
L["The session has ended."] = "分配已经结束。"
L["This item"] = "这件物品"
L["This item has been awarded"] = "这件物品已经被分配了"
L["Tier 19"] = "T19"
L["Tier 20"] = "T20"
L["Tier 21"] = "T21"
L["Tier Tokens ..."] = "套装代币 ..."
L["Tier tokens received from here:"] = "从这里获得的套装代币："
L["tier_token_heroic"] = "英雄"
L["tier_token_mythic"] = "史诗"
L["tier_token_normal"] = "普通"
L["Time"] = "时间"
--[[Translation missing --]]
L["time_remaining_warning"] = "Warning - The following items in your bags cannot be traded in less than %d minutes:"
L["Timeout"] = "超时"
L["Timeout when giving 'item' to 'player'"] = "将%s分配给 %s 时超时"
L["To target"] = "向目标"
L["Tokens received"] = "获得的代币"
L["Total awards"] = "奖励统计"
L["Total items received:"] = "总计收到物品："
L["Total items won:"] = "总计赢得物品："
--[[Translation missing --]]
L["trade_complete_message"] = "%s traded %s to %s."
--[[Translation missing --]]
L["trade_item_to_trade_not_found"] = "WARNING: Item to trade: %s couldn't be found in your inventory!"
--[[Translation missing --]]
L["trade_wrongwinner_message"] = "WARNING: %s traded %s to %s instead of %s!"
L["tVersion_outdated_msg"] = "最新的RCLootCouncil版本是：%s"
L["Unable to give 'item' to 'player'"] = "无法将 %s 分配给 %s"
L["Unable to give 'item' to 'player' - (player offline, left group or instance?)"] = "无法将 %s 分配给 %s - (玩家离线，不在队伍中或在副本外？)"
L["Unable to give out loot without the loot window open."] = "拾取窗口关闭时无法分配。"
L["Unawarded"] = "未分配"
L["Unguilded"] = "无公会"
L["Unknown date"] = "未知日期"
L["Unknown/Chest"] = "未知/箱子"
--[[Translation missing --]]
L["Unlooted"] = "Unlooted"
L["Unvote"] = "取消投票"
L["Upper Quality Limit"] = "品质上限"
L["upper_quality_limit_desc"] = [=[选择自动分配时物品的品质上限 (含此品质！).
注意: 这将会更改物品分配界限。]=]
L["Usage"] = "用法"
L["Usage Options"] = "用法选项"
L["Vanquisher Token"] = "胜利者代币"
L["version"] = "版本"
L["Version"] = "版本"
L["Version Check"] = "版本检查"
L["version_check_desc"] = "开启版本检查模块。"
L["version_outdated_msg"] = "当前版本%s已经过期。 最新版本为%s，请升级RCLootCouncil。"
L["Vote"] = "投票"
L["Voters"] = "投票者"
L["Votes"] = "投票"
L["Voting options"] = "投票选项"
L["Waiting for response"] = "等待回应"
L["whisper_guide"] = "[RCLootCouncil]：用数字回应 [物品1] [物品2]。发送要替换的物品链接与编号，回应为如下关键词：例如 '1 贪婪 [物品1]' 就是贪婪物品1"
L["whisper_guide2"] = "[RCLootCouncil]：如果你被成功添加，你将收到一条确认信息。"
L["whisper_help"] = [=[没有安装插件的团队成员可以使用密语系统.。
密语战利品分配者 "rchelp" 可以获取关键词列表，该列表可以在"按钮与回应"选项卡修改。
建议团长开启"通告待定"，因为密语系统需要每件物品编号才能使用。
注意: 团员仍然应当安装插件, 否则玩家的所有信息都将不可用。]=]
L["whisperKey_greed"] = "贪婪, 副天赋, os, 2"
L["whisperKey_minor"] = "较小提升, minor, 3"
L["whisperKey_need"] = "需求, 主天赋, ms, 1"
L["Windows reset"] = "窗口重置"
L["winners"] = "获胜者"
L["x days"] = "%d天"
L["x out of x have voted"] = "%d / %d 已投票"
L["You are not allowed to see the Voting Frame right now."] = "你现在无法查看投票界面。"
--[[Translation missing --]]
L["You are not in an instance"] = "You are not in an instance"
L["You can only auto award items with a quality lower than 'quality' to yourself due to Blizaard restrictions"] = "由于暴雪的限定，你只能自动分配低于%s品质的物品给自己"
L["You cannot start an empty session."] = "你无法开始不含任何物品的分配进程。"
L["You cannot use the menu when the session has ended."] = "你无法使用菜单，因为分配已经结束。"
L["You cannot use this command without being the Master Looter"] = "你无法使用此命令，因为你不是战利品分配者"
L["You can't start a loot session while in combat."] = "战斗中无法开始物品分配。"
L["You can't start a session before all items are loaded!"] = "在所有物品加载完成前，你不能开始物品分配！"
L["You haven't selected an award reason to use for disenchanting!"] = "你还没有为装备分解设定一个分配理由。"
L["You haven't set a council! You can edit your council by typing '/rc council'"] = "你还没有设定议会！你可以输入'/rc council'来进行编辑。"
L["You must select a target"] = "你必须选择一个目标"
L["Your note:"] = "你的备注："
L["You're already running a session."] = "你已经在进行物品分配了。"

