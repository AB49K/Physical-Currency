g_PluginInfo =
{
	Name = "PhysicalCurrency",
	Date = "30-3-2016",
	Description = "An opensource currency plugin",

	AdditionalInfo =
	{
		{
			Title = "What is PhysicalCurrency?",
			Contents = "PhysicalCurrency is an API allowing plugins to tream physical in game items as currency.",
		},
	},
	Commands =
	{
		["/currency"] =
		{
			Subcommands =
			{
				give =
				{
					Handler = CurrencyCommand,
					HelpString = "Allows you to give currency",
					Permission = "PhysicalCurrency.admin",
				},
				take =
				{
					Handler = CurrencyCommand,
					HelpString = "Allows you to take currency",
					Permission = "PhysicalCurrency.admin",
				},
				balance =
				{
					Handler = CurrencyCommand,
					HelpString = "Returns the amount of currency in the users inventory",
					Permission = "PhysicalCurrency.check",
				},
			}
		},
	},
	Permissions =
	{
		["PhysicalCurrency.admin"] =
		{
			Description = "Allows the Give and Take commands.",
			RecommendedGroups = "admins, mods",
		},
		["PhysicalCurrency.check"] =
		{
			Description = "Allows you to use /currency balance <player> ",
			RecommendedGroups = "admins",
		},
	},
}
