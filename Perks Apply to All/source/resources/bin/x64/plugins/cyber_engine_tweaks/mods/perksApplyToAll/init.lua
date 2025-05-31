-- perk groups
-- cool : slow firing weapons
-- pistols, revolvers, precision, snipers, + shotguns, smgs
-- reflexes : fast firing weapons
-- smgs, ARs, + lmgs, hmgs, precision, pistols
-- body: large calibers
-- shotguns, lmgs, hmgs, + snipers, revolvers, ARs

-- melee attacks body+reflexes
-- throwables 
-- knife -> reflexes
-- hatchets -> body



-- special cases:
-- body 
--  keystones
--   rip and tear -> cool/body hybrids (including axes)
--   onslaught -> reflexes/body hybrids
--   savage sling -> only blunts
-- reflexes
--  keystones
--   submachine fun -> cool/reflexes hybrids
--   salt in the wound -> reflexes/body hybrids
-- cool
--  keystones
--   nerves of tungsten steel -> cool/body hybrids
--   run 'n gun -> reflexs/cool hybrids
-- keystone checks exist already. Will have to create nested prereqs and replace them though.

-- mini skills apply to all ranged/all melee weapons if applicable
-- 
-- some exceptions
-- deadeye bulletspread can't affect shotguns
-- longshot+high noon -> can't affect shotguns
-- bladerunner 3 -> only blades
-- act of mercy finisher -> only throwables
-- like a feather -> keep heavy weapons. Make 
-- add rip and tear melee attack type check and weapon prereqs for axes :)
-- quickdraw swap speed only affects pistol, revolver, smg

-- balance changes
-- focus, shorten durration to account for SMGs but keep good for slow firing weapons (thinking of 1sec). Also reduce cost (thinking by 1/2)
-- deep breath, increase slow to 50%. Just cuz fun. Maybe by adding another point.
-- ready rested reloaded 1, replace with crit chance boost at high stamina. cuz crit chance is violently low in this game
-- rip and tear -> lower ranged bonus to 50%
-- don't stop me now -> give it a booooost. It should be feelable >14%
-- lower salt in the wound to 3 shots instead of 7 and reduce dmg bonus to 50%
-- rip and tear ranged dmg bonus nerfed to 50%. It has more conditions I get it, but not 4x higher dps boost amount of conditions.

-- weapon changes
-- AR nowaki to precision rifle. -> remove muzzle slot. Boost handling. Make burstfire
-- AR Umbra to burstfire
-- Revolver Nova get's 5 projectiles like a shoty :)
-- pistol Liberty -> 3 shot burst
-- nue lower headshot dmg, increase raw dmg
-- idk with melees
-- electric battons all have the same stats
-- razor and kukri try to fill the same role as heavy hitters
-- crowbar, steel pipe and tire iron fill same role as mediocre hitters. Additionally they all have 1-1 the same aesthetic of "I had to grab something, hadn't I?"


-- for melees
-- Have to test if thrown attacks are considered heavy attacks and/or ranged weapon attacks.


registerForEvent("onInit", function()
  
  local errorCount = 0


  
  local function findindexOfItem(arrayName, itemToFind)
    FoundIndex = -1
    arrayCopy = {}
    arrayCopy = TweakDB:GetFlat(arrayName)
    for index=1,#arrayCopy,1 do
      if arrayCopy[index] == TweakDBID(itemToFind) then
        FoundIndex = index 
        break
      end
    end
    if FoundIndex ==-1 then
      print("findindexOfItem couldn't find "..itemToFind.." on the array "..arrayName)
    end
    return FoundIndex
  end



  local function arrayAppendFlat (arrayName, itemToAdd)
    local arrayCopy = {}
    local arrayCopy = TweakDB:GetFlat(arrayName)
    local controlValue = #arrayCopy
    table.insert(arrayCopy, itemToAdd)
    TweakDB:SetFlat(arrayName, arrayCopy)
    if #arrayCopy ~= controlValue+1 then
    print("arrayAppendFlat failed to append "..itemToAdd.." onto "..arrayName)
    errorCount = errorCount + 1
    end
  end

  local function arrayAppendFlats (arrayName, table)
    local controlValue = #TweakDB:GetFlat(arrayName)+#table
    for index=1,#table,1 do
      arrayAppendFlat(arrayName, table[index])
    end
    if #TweakDB:GetFlat(arrayName) ~= controlValue then
      print("arrayAppendFlats failed to append a table onto "..arrayName)
      errorCount = errorCount + 1
    end
  end


  -- removes the First instance of an item
  local function arrayRemoveFlat (arrayName, itemToRemove)
    local arrayCopy = {}
    local arrayCopy = TweakDB:GetFlat(arrayName)
    local indexOfItem = findindexOfItem(arrayName, itemToRemove)
    local controlValue = #arrayCopy
    table.remove(arrayCopy, indexOfItem)
    TweakDB:SetFlat(arrayName, arrayCopy)
    if #arrayCopy ~= controlValue-1 then
      print("arrayRemoveFlat failed to remove "..itemToRemove.." from "..arrayName)
      errorCount = errorCount + 1
    end
  end

  local function arrayRemoveFlats (arrayName, table)
    local comtrolValue = #TweakDB:GetFlat(arrayName)-#table
    for index=1,#table,1 do
      arrayRemoveFlat(arrayName, table[index])
    end
    if #TweakDB:GetFlat(arrayName)-#table ~= controlValue then
      print("arrayRemoveFlats failed to remove a table from ",arrayName)
      errorCount = errorCount + 1
    end
  end


  local function arrayReplaceFlat (arrayName, itemToRemove, itemToAdd)
    arrayRemoveFlat(arrayName, itemToRemove)
    arrayAppendFlat(arrayName, itemToAdd)
  end

  -- cool
  -- add shotgun and smg types
  arrayAppendFlats("Prereqs.CoolPerksGunsHeldPrereq.nestedPrereqs", {"Prereqs.ShotgunHeldPrereq","Prereqs.ShotgunDualHeldPrereq","Prereqs.SMGHeldPrereq"})
  -- maybe actively remove the crusher from here?

  -- reflexes
  -- not creating a new record creates a missleading naming convention. But otherwise it'd wouldn't be cross compatible
  -- add lmgs, hmgs, precision, pistols, knifes
  arrayAppendFlats("Perks.RiflesAndSMGPrereq.nestedPrereqs",{"Prereqs.LMGHeldPrereq", "Prereqs.HMGHeldPrereq", "Prereqs.PrecisionRifleHeldPrereq", "Prereqs.HandgunHeldPrereq", "Prereqs.KnifeHeldPrereq"})
  -- milestone 3 uses an entirely new prereq
  arrayAppendFlats("NewPerks.ReflexesWeaponTypePrereq.nestedPrereqs",{"Prereqs.LMGHeldPrereq", "Prereqs.HMGHeldPrereq", "Prereqs.PrecisionRifleHeldPrereq", "Prereqs.HandgunHeldPrereq"})
  -- , "Prereqs.KnifeHeldPrereq"

  -- body
  arrayAppendFlats("Perks.DemolitionPerkPrereq.nestedPrereqs",{"Prereqs.SniperRifleHeldPrereq", "Prereqs.RevolverHeldPrereq", "Perks.RiflesAndSMGPrereq_inline0", "Perks.RiflesAndSMGPrereq_inline1"})
  -- , "Prereqs.AxeHeldPrereq"


  print("Perks Apply To More: Modified ranged perk weapon group prereq checks.")


  -- cool/body hybrids
  -- snipers, revolvers. shotguns
  TweakDB:CreateRecord("PerksApplyToMore.CoolBodyHybridWeaponGroup", "gamedataMultiPrereq_Record")
  TweakDB:SetFlat("PerksApplyToMore.CoolBodyHybridWeaponGroup.aggregationType", "OR")
  TweakDB:SetFlat("PerksApplyToMore.CoolBodyHybridWeaponGroup.prereqClassName", "gameMultiPrereq")
  arrayAppendFlats("PerksApplyToMore.CoolBodyHybridWeaponGroup.nestedPrereqs",{"Prereqs.SniperRifleHeldPrereq", "Prereqs.RevolverHeldPrereq", "Prereqs.ShotgunHeldPrereq", "Prereqs.ShotgunDualHeldPrereq"})


  -- cool/reflexes hybrids
  -- pistols, precision rifles, smgs
  TweakDB:CreateRecord("PerksApplyToMore.CoolReflexesHybridWeaponGroup", "gamedataMultiPrereq_Record")
  TweakDB:SetFlat("PerksApplyToMore.CoolReflexesHybridWeaponGroup.aggregationType", "OR")
  TweakDB:SetFlat("PerksApplyToMore.CoolReflexesHybridWeaponGroup.prereqClassName", "gameMultiPrereq")
  arrayAppendFlats("PerksApplyToMore.CoolReflexesHybridWeaponGroup.nestedPrereqs",{"Prereqs.HandgunHeldPrereq", "Prereqs.PrecisionRifleHeldPrereq", "Prereqs.SMGHeldPrereq"})
  

  -- reflexes/body hybrids
  -- ARs, lmgs, hmgs
  TweakDB:CreateRecord("PerksApplyToMore.BodyReflexesHybridWeaponGroup", "gamedataMultiPrereq_Record")
  TweakDB:SetFlat("PerksApplyToMore.BodyReflexesHybridWeaponGroup.aggregationType", "OR")
  TweakDB:SetFlat("PerksApplyToMore.BodyReflexesHybridWeaponGroup.prereqClassName", "gameMultiPrereq")
  arrayAppendFlats("PerksApplyToMore.BodyReflexesHybridWeaponGroup.nestedPrereqs",{"Perks.RiflesAndSMGPrereq_inline0", "Perks.RiflesAndSMGPrereq_inline1", "Prereqs.LMGHeldPrereq", "Prereqs.HMGHeldPrereq"})

  print("Perks Apply To More: Created ranged hybrid weapon group prereq checks.")

if errorCount ~=0 then
  print("Perks Apply to More encountered "..errorCount.." errors. Please forward it's log file to the mods creator. For more info feel free to leave a comment in the mods nexus page or contact user jonnestt on discord.")
end
end)