QBCore = exports['qb-core']:GetCoreObject()

-- Register Weapons
local weapons = {
    'WEAPON_KNIFE', 'WEAPON_SHIV', 'WEAPON_KATANA', 'WEAPON_NIGHTSTICK', 'WEAPON_BREAD',
    'WEAPON_FLASHLIGHT', 'WEAPON_HAMMER', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_CROWBAR',
    'WEAPON_BOTTLE', 'WEAPON_DAGGER', 'WEAPON_HATCHET', 'WEAPON_MACHETE', 'WEAPON_SWITCHBLADE',
    'WEAPON_BATTLEAXE', 'WEAPON_POOLCUE', 'WEAPON_WRENCH', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_REVOLVER', 'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_ASSAULTSMG',
    'WEAPON_MINISMG', 'WEAPON_MACHINEPISTOL', 'WEAPON_COMBATPDW', 'WEAPON_PUMPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE', 'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_GUSENBERG', 'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER', 'WEAPON_MARKSMANRIFLE', 'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_STINGER',
    'WEAPON_MINIGUN', 'WEAPON_GRENADE', 'WEAPON_STICKYBOMB', 'WEAPON_SMOKEGRENADE', 'WEAPON_BZGAS',
    'WEAPON_MOLOTOV', 'WEAPON_DIGISCANNER', 'WEAPON_FIREWORK', 'WEAPON_MUSKET', 'WEAPON_STUNGUN',
    'WEAPON_HOMINGLAUNCHER', 'WEAPON_PROXMINE', 'WEAPON_FLAREGUN', 'WEAPON_MARKSMANPISTOL', 'WEAPON_RAILGUN',
    'WEAPON_DBSHOTGUN', 'WEAPON_AUTOSHOTGUN', 'WEAPON_COMPACTLAUNCHER', 'WEAPON_PIPEBOMB', 'WEAPON_DOUBLEACTION',
    'WEAPON_COMBATSHOTGUN', 'WEAPON_CERAMICPISTOL'
}

-- Police Weapons For Holster Anim
local holsterableWeapons = {
    'WEAPON_STUNGUN', 'WEAPON_COMBATPISTOL', 'WEAPON_NIGHTSTICK', 'WEAPON_FLASHLIGHT'
}

local holstered = true
local canFire = true
local currWeapon = GetHashKey('WEAPON_UNARMED')
local currentHolster = nil

RegisterNetEvent('weapons:ResetHolster')
AddEventHandler('weapons:ResetHolster', function()
    holstered = true
    canFire = true
    currWeapon = GetHashKey('WEAPON_UNARMED')
    currentHolster = nil
end)

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if DoesEntityExist(ped) and not IsEntityDead(ped) then
			if currWeapon ~= GetSelectedPedWeapon(ped) then
				pos = GetEntityCoords(ped, true)
				rot = GetEntityHeading(ped)

				local newWeap = GetSelectedPedWeapon(ped)
				SetCurrentPedWeapon(ped, currWeapon, true)
				loadAnimDict("reaction@intimidation@1h")
				loadAnimDict("reaction@intimidation@cop@unarmed")
				loadAnimDict("rcmjosh4")
				loadAnimDict("weapons@pistol@")

				if CheckWeapon(newWeap) then
					if holstered then
						job = QBCore.Functions.GetPlayerData().job.name
						if job == "police" or job == "security" or job == "ambulance" then
							canFire = false
							currentHoldster = GetPedDrawableVariation(ped, 7)
							TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(300)
							SetCurrentPedWeapon(ped, newWeap, true)
							currWeapon = newWeap
							Wait(300)
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						else
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1000)
							SetCurrentPedWeapon(ped, newWeap, true)
							currWeapon = newWeap
							Wait(1400)
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						end
					elseif newWeap ~= currWeapon and CheckWeapon(currWeapon) then
						if job == "police" or job == "security" or job == "ambulance" then
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(500)
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							currentHoldster = GetPedDrawableVariation(ped, 7)
							TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(300)
							SetCurrentPedWeapon(ped, newWeap, true)
							Wait(500)
							currWeapon = newWeap
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						else
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1600)
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1000)
							SetCurrentPedWeapon(ped, newWeap, true)
							currWeapon = newWeap
							Wait(1400)
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						end
					else
						if job == "police" or job == "security" or job == "ambulance" then
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							currentHoldster = GetPedDrawableVariation(ped, 7)
							TaskPlayAnimAdvanced(ped, "rcmjosh4", "josh_leadout_cop2", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(300)
							SetCurrentPedWeapon(ped, newWeap, true)
							currWeapon = newWeap
							Wait(300)
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						else
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1000)
							SetCurrentPedWeapon(ped, newWeap, true)
							currWeapon = newWeap
							Wait(1400)
							ClearPedTasks(ped)
							holstered = false
							canFire = true
						end
					end
				else
					if not holstered and CheckWeapon(currWeapon) then
						if job == "police" or job == "security" or job == "ambulance" then
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "intro", GetEntityCoords(ped, true), 0, 0, rot, 3.0, 3.0, -1, 50, 0, 0, 0)
							Wait(500)
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, newWeap, true)
							holstered = true
							canFire = true
							currWeapon = newWeap
						else
							canFire = false
							TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
							Wait(1400)
							SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, newWeap, true)
							holstered = true
							canFire = true
							currWeapon = newWeap
						end
					else
						SetCurrentPedWeapon(ped, newWeap, true)
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				end
			end
		else
			Wait(250)
		end

		Wait(5)
	end
end)


CreateThread(function()
    while true do
        if not canFire then
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerPedId(), true)
        end
        Wait(100)
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

function IsWeaponHolsterable(weap)
	for i = 1, #holsterableWeapons do
		if GetHashKey(holsterableWeapons[i]) == weap then
			return true
		end
	end
	return false
end
