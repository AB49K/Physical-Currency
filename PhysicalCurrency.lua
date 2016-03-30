PLUGIN = nil


--This is the beta version - everything works if you put in the right commands.
--It needs much more testing and tweaking before I'll be happy with it.


function Initialize(Plugin)
	Plugin:SetName("PhysicalCurrency")
	CurrencyItem = cItem(E_ITEM_EMERALD);
	Plugin:SetVersion(2)
	PLUGIN = Plugin 
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua");

	--Bind all the commands:
	RegisterPluginInfoCommands();
	--dofile(cPluginManager:GetPluginsPath() .. "/" .. Plugin:GetName() .. "/Plugin_info.lua") --This will be fixed soon.
	--cPluginManager.BindCommand("/currency", "Physical.admin", CurrencyCommand, " Allows administration of the Physical-Currency plugin")
	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " is shutting down...")
end
				
function CurrencyCommand(Split, Player)
	if Split[2] == 'balance' then
		balance = GetBalance(Split[3])
		if balance == nil then
			Player:SendMessage("No Player ".. Split[3] .." found")
			end
		Player:SendMessage("Balance for ".. Split[3] ..": " .. balance)
		return true
	end
	
	if (#Split ~= 4) then
		Player:SendMessage("Usage: /currency <give:take:balance> <user> [amount to give or take]")
		return true			
		end
	if type(tonumber(Split[4])) ~= 'number' then
			Player:SendMessage("Usage: /currency <give:take:balance> <user> [amount to give or take]")
			return true
			end

	if Split[2] == 'take' then
		TargetPlayer=GetPlayer(Split[3])
		if TargetPlayer ~= nil then
			result=TakeCurrency(Split[3], Split[4])
			if result == 10 then
				Player:SendMessage("Taking " .. Split[4] .. " Currency from " .. Split[3])
			elseif result == 20 then
				Player:SendMessage("No Player ".. Split[3] .." found")
			elseif result == 21 then
				Player:SendMessage(Split[3] .. " Does not have enough currency in their inventory")
			end
		return true
		end
		
		
	elseif Split[2] == 'give' then
		TargetPlayer=GetPlayer(Split[3])
		if TargetPlayer ~= nil then
			if tonumber(Split[4]) > 640 then --This is to stop a DOS attempt, otherwise you could put a large number and the loop will cause the server to lag (after about 100'000 items given at once)
				Player:SendMessage("You cannot give more than 640 currency at a time.")
				return true
				end
			result = GiveCurrency(Split[3], Split[4])
			if result == 10 then
				Player:SendMessage("Giving " .. Split[4] .. " Currency to " .. Split[3])
			else
				Player:SendMessage("Something went wrong")
			return true
		end
		else
			Player:SendMessage("No Player: " .. Split[3])
			return true
		end
		return true
	else
		Player:SendMessage("Usage: /currency <give:take:balance> <user> [amount to give or take]")
		return true
		end		
end			

function GetBalance(TargetPlayer)
	-- This will return and int with the amount of CurrencyItem in the targets inventory
	-- If the user does not exist, it will return nil
	TargetPlayer=GetPlayer(TargetPlayer)
	if TargetPlayer == nil then
		return nil
		end
	return TargetPlayer:GetInventory():HowManyItems(CurrencyItem)

end

function TakeCurrency(Target, Amount)
	--This function will take an amount of CurrencyItem from the target players inventory
	--This is where we need the custom return codes and true/false don't cut it
	--Return codes:
	--10: Success. Currency has been removed from the users inventory
	--20: Failure. Unable to find target user
	--21: Failure. Target Player does not have enough CurrencyItem in their inventory

	TargetPlayer=GetPlayer(Target)
	if TargetPlayer ~= nil then
		TargetBalance=GetBalance(TargetPlayer:GetName())
		if tonumber(Amount) > TargetBalance then
			return 21
			end
		i = 1
		while i  <= tonumber(Amount) do
			TargetPlayer:GetInventory():RemoveItem(CurrencyItem)
			i = i + 1
			end
		
		return 10
	else
		return 20
		end
end

function GiveCurrency(Target, Amount)
	--This function will give CurrencyItem to the player.
	--The return codes are a little different here to allow adding of features later
	--If the command is successfull, it will return 10
	--If the player does not exist, the return code is 20
	
	TargetPlayer=GetPlayer(Target)
	if TargetPlayer ~= nil then
		
		i = 1
		while i  <= tonumber(Amount) do
			TargetPlayer:GetInventory():AddItem(CurrencyItem)
			i = i + 1
			end
		
		return 10
	else
		return 20
		end
end

function GetPlayer(Player_To_Find) 
	-- This is the function we use to verify the user exists, It will return the user class if the user exists
	-- returns nil if they do not exist
	Target=nil
	local Found = false
	local FindPlayer = function(TargetPlayer)
		if (TargetPlayer:GetName() == Player_To_Find) then
			Target=TargetPlayer
			return TargetPlayer
		end
	end
	cRoot:Get():FindAndDoWithPlayer(Player_To_Find, FindPlayer)
	return Target
end
