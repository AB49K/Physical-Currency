Outline of PhysicalCurrency Features:

Mainly to be used through other plugins.
All currency is 100% physical. IF you don't have the items, you don't have any currency, you will need to stash them in a safe chest.

There will be 3 commands that admins can use

/currency give <user> <amount>
/currency take <user> <amount>
/currency balance <user>


The API allows 3 calls/functions.

TakeCurrency - This will allow a plugin or admin to remove currency from a players inventory.
TakeCurrency has a few return codes.
10: Success - The player had enough currency in their inventory and it's been removed from their inventory.
20: Failure - The player specified could not be found.
21: Failure - The specified player did not have enough currency in their inventory.

Example:
result = cPluginManager:CallPlugin("PhysicalCurrency", "TakeCurrency", "AB49K", "10")


GiveCurrency - This will add currency to the players inventory
GiveCurrency has a maximum give count of 640 - this is to stop server lag if an admin or plugin sends over 100K emeralds to one person

GiveCurrency has 2 return codes

10: Success - the player has had the currency added to their inventory
20: Failure - The specified player could not be found.

Example:
result = cPluginManager:CallPlugin("PhysicalCurrency", "GiveCurrency", "AB49K", "10")


Balance
This will return the amount of currency in the players inventory.

Example:
result = cPluginManager:CallPlugin("PhysicalCurrency", "Balance", "AB49K")


