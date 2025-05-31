if TweakDB:GetRecord("Items.Preset_Unity_Answer") ~= nil then
    TweakDB:SetFlat("Items.Preset_Unity_Answer.blueprint", "Items.Iconic_Power_Handgun_Blueprint")
end


registerForEvent("onInit", function() 
	curSettings = LoadFile("settings.json")
	if curSettings == nil then
		curSettings = { 
			answer_Using_UMAS = false, 
		}
	end
	
	SetBlueprint(curSettings.answer_Using_UMAS)


	local nativeSettings = GetMod("nativeSettings")
    if nativeSettings then 
		if not nativeSettings.pathExists("/JonnesTTIconics") then nativeSettings.addTab("/JonnesTTIconics", "Iconics By JonnesTT") end
		nativeSettings.addSubcategory("/JonnesTTIconics/The_Answer", "The Answer")
		
		nativeSettings.addSwitch("/JonnesTTIconics/The_Answer", "Unlock Me A Slot Compatibility", "If you use Unlock Me A Slot or Unlock Me 2 Slots, enable this.", curSettings.answer_Using_UMAS, false, function(state)
			curSettings.answer_Using_UMAS = state
		end)
	
		local fromMods = false
		Observe("PauseMenuGameController", "OnMenuItemActivated", function (_, _, target)
			fromMods = target:GetData().label == "Mods"
		end) 
		Observe("gameuiMenuItemListGameController", "OnMenuItemActivated", function (_, _, target)
			fromMods = target:GetData().label == "Mods"
		end) 
		Observe("SettingsMainGameController", "RequestClose", function () 
			if fromMods then
				SaveFile("settings.json", curSettings)
				SetBlueprint(curSettings.answer_Using_UMAS)
				fromMods = false
			end
		end)
	end
end)

function SetBlueprint(makeUmasCompat)
	if makeUmasCompat then TweakDB:SetFlat("Items.Preset_Unity_Answer.blueprint", "Items.Iconic_Power_Handgun_Blueprint")
	else TweakDB:SetFlat("Items.Preset_Unity_Answer.blueprint", "Items.Iconic_Ranged_Weapon_Blueprint")
	end
end

function LoadFile(path)
    local file = io.open(path, "r")
	if file ~= nil then
		local config = json.decode(file:read("*a"))
		file:close()
		return config
	else return nil
	end
end

function SaveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = json.encode(data)
    file:write(jconfig)
    file:close()
end
