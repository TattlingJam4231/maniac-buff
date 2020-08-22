Hooks:Add("LocalizationManagerPostInit", "Maniac Buff Localization", function(loc)
	LocalizationManager:add_localized_strings({
        ["menu_deck14_1_desc"] = "##100%## of damage you deal is converted into hysteria stacks, up to ##240## every ##3## seconds. Max amount of stacks is ##600##. \n\nHysteria Stacks\nYou gain ##1## damage absorption for every ##30## stacks of Hysteria. Taking damage reduces Hysteria Stacks by ##80##, up to ##240## every ##3## seconds. Hysteria Stacks decays ##60% + 90## every ##3## seconds if you haven't dealt damage for ##6## seconds.\n\nNOTE: Damage from dots and sentry guns does not prevent decay.",
        ["menu_deck14_3_desc"] = "While you have Hysteria Stacks, damage is reduced by ##25%## after absorption.\n\nMembers of your crew gain the damage absorption effect of your Hysteria Stacks.\n\nHysteria Stacks from multiple crew members do not stack and only the stacks that gives the highest damage absorption will have an affect.",
        ["menu_deck14_5_desc"] = "Reduce the amount of Hysteria Stacks lost when taking damage to ##60##.",
	["menu_deck14_7_desc"] = "Damage reduction gained from Hysteria is increased by ##10%##.\n\nChange the damage absorption of your Hysteria Stacks on you and your crew to ##1## absorption for every ##25## stacks of Hysteria.",
	["menu_deck14_9_desc"] = "Damage absorption from Hysteria Stacks on you is increased by ##50%##.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%##."
    })
end)
