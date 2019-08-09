--- **OneConfig-1.0** provides a common config table, and framework for onebag's suite
-- @class file
-- @name OneConfig-1.0.lua
local MAJOR, MINOR = "OneConfig-1.0", tonumber("56") or 9999
local OneConfig, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not OneConfig then return end -- No Upgrade needed.
-- Upgrading Library Variables

--- This will setup the embed function on the library as well as upgrade any old embeds will also upgrade the store
-- @param lib the library being setup
-- @param store a table used to keep track of what was previously embedded, this is for upgrading.
-- @param mixins a table of what needs to be mixed in
local function setup_embed_and_upgrade(lib, store, mixins)

    if lib.embeded then
        lib.embedded = lib.embeded
        lib.embeded = nil
    end

    lib[store] = lib[store] or {}
    store = lib[store]

    local function Embed(self, target)
        for k, v in pairs(mixins) do
            if type(k) == "number" then
                target[v] = self[v]
            else
                target[k] = type(v) == "string" and self[v] or v
            end
        end
        store[target] = true
    end

    lib.Embed = Embed

    for target, v in pairs(store) do
       lib:Embed(target)
    end
end

--- This will create the common config and pass it around for customization before installing it in blizzard options
function OneConfig:InitializeConfiguration()
    local AceConfig = LibStub("AceConfig-3.0")
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    local L = LibStub("AceLocale-3.1"):GetLocale("OneCore-1.0")

	self.configs = {}

	function GetBaseConfig()
		return {
			type = "group",
			name = self.displayName,
			args = {
				general = {
					type = "group",
					name = self.displayName,
					args = {
						desc1 = {
							type = "description",
							name = L["%s collapses all of the related bags into one frame.  In addition to this it provides colored slot highlights, customizable display, behavior enhancements, and more.  In addition plugins can provide a variety of more advanced functionality."]:format(self.displayName),
							order = 1,
						},
						heading = {
							type = "group",
							order = 2,
							name = L["Core Options"],
							inline = true,
							args = {
								desc1 = {
									type = "description",
									name = L["You can adjust how wide you wish your bag to be.  Note, this is considered a maxinum size.  If you don't have enough slots you will only see as many as you have."],
									order = 1
								},
								cols = {
									order = 5,
									type = "range",
									name = L["Number of Columns"],
									desc = L["Sets the maximum number of columns to use"],
									min = 1, max = 30, step = 1,
									get = function(info)
										return self.db.profile.appearance.cols
									end,
									set = function(info, cols)
										self.db.profile.appearance.cols = cols
										self:OrganizeFrame(true)
									end
								},
								desc2 = {
									type = "description",
									name = L["You may also adjust some of the characteristics of your bag window.  UI Scale refers to how large the window is while Frame Alpha talks about the overall frame's opacity.  Note that the background transparancy is controlled via the background color."],
									order = 10
								},
								scale = {
									order = 15,
									type = "range",
									name = L["UI Scale"],
									min = 0.5,
									max = 3,
									step = 0.01,
									get = function(info)
										return self.db.profile.appearance.scale
									end,
									set = function(info, scale)
										self.db.profile.appearance.scale = scale
										self.frame:CustomizeFrame(self.db.profile)
									end,
								},
								alpha = {
									order = 20,
									type = "range",
									name = L["Frame Alpha"],
									min = 0,
									max = 1,
									step = 0.01,
									get = function(info)
										return self.db.profile.appearance.alpha
									end,
									set = function(info, alpha)
										self.db.profile.appearance.alpha = alpha
										self.frame:CustomizeFrame(self.db.profile)
									end,
								},
								desc3 = {
									order = 25,
									type = "description",
									name = L["There are several customizable colors with regards to your bags.  Each one will control something different."],
								},
								background = {
					                order = 30,
					                type = "color",
					                name = L["Background"],
					 				desc = L["Sets the background color of your bag."],
									get = function(info)
										local color = self.db.profile.colors.background
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.background = {r = r, g = g, b = b, a = a}
										self.frame:CustomizeFrame(self.db.profile)
									end,
									hasAlpha = true,
					            },
								mouseover = {
					                order = 35,
					                type = "color",
					                name = L["Mouseover"],
					 				desc = L["Sets the border color of highlighted slots when you mouse over a bag."],
									get = function(info)
										local color = self.db.profile.colors.mouseover
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.mouseover = {r = r, g = g, b = b, a = a}
									end
					            },
							}
						},
						desc2 = {
							type = "description",
							name = L["There are also many other options available to you in the subpanels.  If you find this addon useful I ask that you tell your friends and give me feedback on how to make it better.  \n\nPlease check out the side panel under %s to find all the other options as well as plugin information."]:format(self.displayName),
							order = 10,
						},
					}
				},
				frame = {
					type = "group",
					name = L["Frame Options"],
					args = {
						frame = {
							type = "group",
							name = L["Frame Behavior"],
							inline = true,
							order = 1,
							args = {
								description = {
									order = 1,
									type = "description",
									name = L["These options affect how the frame itself behaves on your screen."],
								},
								locked = {
									order = 5,
									type = "toggle",
									name = L["Lock Frame"],
									desc = L["Toggles if the frame is movable or not"],
									get = function(info)
										return self.db.profile.behavior.locked
									end,
									set = function(info, value)
										self.db.profile.behavior.locked = value
									end
								},
								clamped = {
									order = 10,
									type = "toggle",
									name = L["Clamp to Screen"],
									desc = L["Toggles if you can drag the frame off screen."],
									get = function(info)
										return self.db.profile.behavior.clamped
									end,
									set = function(info, value)
										self.db.profile.behavior.clamped = value
										self.frame:CustomizeFrame(self.db.profile)
									end
								},
								strata = {
									order = 15,
									type = "range",
									name = L["Frame Strata"],
									min = 1,
									max = 5,
									step = 1,
									get = function(info)
										return self.db.profile.behavior.strata
									end,
									set = function(info, value)
										self.db.profile.behavior.strata = value
										self.frame:CustomizeFrame(self.db.profile)
									end
								},
								alpha = {
									order = 20,
									type = "range",
									name = L["Frame Alpha"],
									min = 0,
									max = 1,
									step = 0.05,
									get = function(info)
										return self.db.profile.appearance.alpha
									end,
									set = function(info, alpha)
										self.db.profile.appearance.alpha = alpha
										self.frame:CustomizeFrame(self.db.profile)
									end,
								},
								scale = {
									order = 25,
									type = "range",
									name = L["UI Scale"],
									min = 0.5,
									max = 3,
									step = 0.05,
									get = function(info)
										return self.db.profile.appearance.scale
									end,
									set = function(info, scale)
										self.db.profile.appearance.scale = scale
										self.frame:CustomizeFrame(self.db.profile)
									end,
								},

							},
						},
						bag = {
							type = "group",
							name = L["Bag Behavior"],
							order = 2,
							inline = true,
							plugins = {},
							args = {
								description = {
									order = 1,
									type = 'description',
									name = L["These options affect the way %s works with and treats your bags.  You can use them to do some base customization to the way you view your bags."]:format(self.displayName),
								},
								cols = {
									order = 10,
									type = "range",
									name = L["Number of Columns"],
									desc = L["Sets the maximum number of columns to use"],
									min = 1, max = 32, step = 1,
									get = function(info)
										return self.db.profile.appearance.cols
									end,
									set = function(info, cols)
										self.db.profile.appearance.cols = cols
										self:OrganizeFrame(true)
									end
								},
							}
						}
					}
				},
				colors = {
					type = "group",
					name = L["Color Options"],
					args = {
						general = {
							type = "group",
							order = 1,
							inline = true,
							name = L["General"],
							args = {
								background = {
					                order = 5,
					                type = "color",
					                name = L["Background"],
					 				desc = L["Sets the background color of your bag."],
									get = function(info)
										local color = self.db.profile.colors.background
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.background = {r = r, g = g, b = b, a = a}
										self.frame:CustomizeFrame(self.db.profile)
									end,
									hasAlpha = true,
					            },
								mouseover = {
					                order = 10,
					                type = "color",
					                name = L["Mouseover"],
					 				desc = L["Sets the border color of highlighted slots when you mouse over a bag."],
									get = function(info)
										local color = self.db.profile.colors.mouseover
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.mouseover = {r = r, g = g, b = b, a = a}
									end
					            },
								glow = {
									order = 15,
									type = "toggle",
									name = L["Use Glow Borders"],
									desc = L["Glow Borders are a little brighter and 'shinier' than the default ones."],
									get = function(info)
										return self.db.profile.appearance.glow
									end,
									set = function(info, value)
										self.db.profile.appearance.glow = value
										self:UpdateFrame()
									end,
								},
							}
						},
						item = {
							type = "group",
							order = 2,
							inline = true,
							name = L["Item Centric"],
							args = {
								rarity = {
									order = 10,
									type = "toggle",
									name = L["Use Rarity Borders"],
									desc = L["Toggles if a slot's border should be highlighted based on an items rarity."],
									get = function(info)
										return self.db.profile.appearance.rarity
									end,
									set = function(info, value)
										self.db.profile.appearance.rarity = value
										self:UpdateFrame()
									end,
								},
								lowlevel = {
									order = 15,
									type = "toggle",
									name = L["Color Low Level Items"],
									desc = L["Toggles if you want to color white and grey item's borders as well."],
									get = function(info)
										return self.db.profile.appearance.lowlevel
									end,
									set = function(info, value)
										self.db.profile.appearance.lowlevel = value
										self:UpdateFrame()
									end,
								},
							}
						},
						bag = {
							type = "group",
							order = 3,
							inline = true,
							name = L["Bag Centric"],
							args = {
								ammo = {
					                order = 5,
					                type = "color",
					                name = L["Ammo Bags"],
					 				desc = L["Sets the border color of ammo bag slots."],
									get = function(info)
										local color = self.db.profile.colors.ammo
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.ammo = {r = r, g = g, b = b, a = a}
										self:UpdateFrame()
									end
					            },
								soul = {
					                order = 10,
					                type = "color",
					                name = L["Soul Bags"],
					 				desc = L["Sets the border color of soul bag slots."],
									get = function(info)
										local color = self.db.profile.colors.soul
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.soul = {r = r, g = g, b = b, a = a}
										self:UpdateFrame()
									end
					            },
								profession = {
					                order = 15,
					                type = "color",
					                name = L["Profession Bags"],
					 				desc = L["Sets the border color of profession bag slots."],
									get = function(info)
										local color = self.db.profile.colors.profession
										return color.r, color.g, color.b, color.a
									end,
									set = function(info, r, g, b, a)
										self.db.profile.colors.profession = {r = r, g = g, b = b, a = a}
										self:UpdateFrame()
									end
					            },
							}
						},
					}
				},
				showbags = {
					type = "group",
					name = L["Bag Visibility"],
					args = {
						description = {
							type = 'description',
							name = L['These options allow you to stop certain bags from displaying.'],
							order = 1
						},
						type = {
							type = "group",
							name = L["Type Based Filters"],
							order = 1,
							inline = true,
							args = {
								ammo = {
									order = 15,
									type = "toggle",
									name = L["Ammo Bags & Quivers"],
									desc = L["Toggles the display of ammo bags and quivers."],
									get = function(info)
										return self.db.profile.show.ammo
									end,
									set = function(info, value)
										self.db.profile.show.ammo = value
										self:OrganizeFrame(true)
									end
								},
								soul = {
									order = 10,
									type = "toggle",
									name = L["Soul Bags"],
									desc = L["Toggles the display of soul bags."],
									get = function(info)
										return self.db.profile.show.soul
									end,
									set = function(info, value)
										self.db.profile.show.soul = value
										self:OrganizeFrame(true)
									end
								},
								profession = {
									order = 5,
									type = "toggle",
									name = L["Profession Bags"],
									desc = L["Toggles the display of profession bags."],
									get = function(info)
										return self.db.profile.show.profession
									end,
									set = function(info, value)
										self.db.profile.show.profession = value
										self:OrganizeFrame(true)
									end
								},
							}
						}
					},
				},
				plugins = {
					type = "group",
					name = L["Plugins"],
					args = {
					}
				},
			}
		}
	end

	baseconfig = GetBaseConfig()
    local pluginGroupCount = 1
	for typeName, _ in self:IteratePluginTypes() do
	    local values = {}
        for pluginName, plugin in self:IteratePluginsByType(typeName) do
            values[pluginName] = ("%s: %s"):format(plugin.pluginName, plugin.description or "")
        end

        local pluginGroup = {
            type = "multiselect",
            name = typeName,
            values = values,
            order = pluginGroupCount,
            tristate = false,
            get = function(info, pluginName)
                return self:GetPlugin(typeName, pluginName):IsEnabled()
            end,
            set = function(info, pluginName, state)
                local plugin = self:GetPlugin(typeName, pluginName)

                if state then
                    self:EnablePlugin(plugin)
                else
                    self:DisablePlugin(plugin)
                end

                self:OrganizeFrame(true)
            end,
        }

        baseconfig.args.plugins.args[typeName] = pluginGroup
        pluginGroupCount = pluginGroupCount + 1
    end

	if self.LoadCustomConfig then
		self:LoadCustomConfig(baseconfig)
	end

	AceConfig:RegisterOptionsTable(self.displayName, baseconfig)

	self.configs.base = baseconfig
	self.configs.main = AceConfigDialog:AddToBlizOptions(self.displayName, nil, nil, 'general')
	self.configs.frame = AceConfigDialog:AddToBlizOptions(self.displayName, L["Frame Options"], self.displayName, 'frame')
	self.configs.colors = AceConfigDialog:AddToBlizOptions(self.displayName, L["Color Options"], self.displayName, 'colors')
	self.configs.showbags = AceConfigDialog:AddToBlizOptions(self.displayName, L["Bag Visibility"], self.displayName, 'showbags')
	self.configs.plugins = AceConfigDialog:AddToBlizOptions(self.displayName, L["Plugins"], self.displayName, 'plugins')
end

--- Opens the configuration panel expanded so you see the sub options in the treeview
function OneConfig:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(self.configs.showbags)
	InterfaceOptionsFrame_OpenToCategory(self.configs.main)
end

setup_embed_and_upgrade(OneConfig, "embedded", {
    "InitializeConfiguration",
    "OpenConfig",
})
