registerForEvent("onInit", function()
  local weaponTypeToAttribute = {
    -- melee fallback
    ["gamedataItemType : Wea_Melee (88)"] = gamedataProficiencyType.ReflexesSkill,
    -- body melees
    ["gamedataItemType : Wea_TwoHandedClub (99)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Wea_Hammer (80)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Wea_OneHandedClub (89)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Wea_Fists (78)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Cyb_StrongArms (18)"] = gamedataProficiencyType.ReflexesSkill,
    -- reflexes melees
    ["gamedataItemType : Wea_Katana (83)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_Sword (98)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_LongBlade (86)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_ShortBlade (93)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_Chainsword (77)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_Machete (87)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Cyb_MantisBlades (16)"] = gamedataProficiencyType.StrengthSkill,  
  
    -- ->body hybrids
    ["gamedataItemType : Wea_Revolver (91)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_SniperRifle (96)"] = gamedataProficiencyType.StrengthSkill,
  
    ["gamedataItemType : Wea_Rifle (92)"] = gamedataProficiencyType.StrengthSkill,
    ["gamedataItemType : Wea_AssaultRifle (75)"] = gamedataProficiencyType.StrengthSkill,
  
    -- ->cool hybrids
    ["gamedataItemType : Wea_SubmachineGun (97)"] = gamedataProficiencyType.CoolSkill,
  
    ["gamedataItemType : Wea_Shotgun (94)"] = gamedataProficiencyType.CoolSkill,
    ["gamedataItemType : Wea_ShotgunDual (95)"] = gamedataProficiencyType.CoolSkill,
  
    -- ->reflexes hybrids
    ["gamedataItemType : Wea_HeavyMachineGun (82)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Wea_LightMachineGun (85)"] = gamedataProficiencyType.ReflexesSkill,
  
    ["gamedataItemType : Wea_Handgun (81)"] = gamedataProficiencyType.ReflexesSkill,
    ["gamedataItemType : Wea_PrecisionRifle (90)"] = gamedataProficiencyType.ReflexesSkill

    -- unhandled types:
    -- -> nanowires
    -- ["gamedataItemType : Cyb_NanoWires (17)"] = gamedataProficiencyType.StrengthSkill,  

    -- -> throwables
    -- [gamedataItemType.Wea_Knife] = unhandledAttributeTag
    -- [gamedataItemType.Wea_Axe] = unhandledAttributeTag
  }
  

  ObserveAfter("DefaultTransition", "HandleDamagePreview", function( self, weapon, scriptInterface, stateContext) 
    
    inStealth = false
    if PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Right_Milestone_1 ) == 1 then

      inStealth = scriptInterface.localBlackboard.GetInt( GetAllBlackboardDefs().PlayerStateMachine.Combat ) ~= gamePSMCombat.InCombat
      if  ((inStealth and not self:CanWeaponSilentKill( weapon, scriptInterface )) and self:IsNameplateVisible( scriptInterface )) and not stateContext:GetBoolParameter( "DamagePreviewActive", true ) then
        self:ActivateDamageProjection( true, weapon, scriptInterface, stateContext )
      end
    end
  end)



  ObserveAfter("AimingStateEvents", "OnEnter", function(self, stateContext, scriptInterface) -- returns nil
    -- if self.m_itemChanged  then
    --   spdlog.info(""ello")
		m_weapon = self:GetWeaponObject( scriptInterface )
    if m_weapon == nil or not m_weapon then
      return
    end
    -- spdlog.info(tostring(self.m_weapon))
    --   -- Game.GetPlayer():GetActiveWeapon()
		-- end
    -- if perk bought
    if PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2 then
      if GameInstance.GetStatPoolsSystem():GetStatPoolValue( scriptInterface.executionOwner:GetEntityID(), gamedataStatPoolType.Stamina ) > TDB.GetFloat( "NewPerks.Cool_Left_Milestone_2.focusedStaminaThreshold" ) then
        if isNewCoolWeapon(RPGManager.GetItemRecord( m_weapon:GetItemID() ):ItemType():Type()) then
          --apply focus
          StatusEffectHelper.ApplyStatusEffect( Game.GetPlayer(), TweakDBID.new("BaseStatusEffect.FocusedCoolPerkSE"), Game.GetPlayer() )
          -- apply Focus timeDilation
          Game.GetTimeSystem():SetTimeDilation( CName"focusedStatePerkDilation", 1.0-TweakDB:GetFlat("NewPerks.Cool_Left_Milestone_2.timeDilationStrength"), 12.0, "MeleeHitEaseIn", "MeleeHitEaseOut")
          FocusActivationTime = GetSingleton("EngineTime"):ToFloat(Game.GetPlaythroughTime())
        end
      end
    end
  end)
  

  Override("ShootEvents", "ConsumeStamina", function( self, scriptInterface, attackRecord, staminaPenaltyMultiplier, staminaFullChargePenaltyMultiplier ) -- returns void
    local staminaCost = 0.0
    local staminaCostMods = attackRecord:StaminaCost()

    local staminaCost = RPGManager.CalculateStatModifiers(staminaCostMods, scriptInterface.owner, scriptInterface.ownerEntityID )
    local staminaCost = staminaCost * staminaPenaltyMultiplier
		local staminaCost = staminaCost * staminaFullChargePenaltyMultiplier
  -- move the bellow statement to the aim OnExit
    if StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, "FocusedCoolPerkSE" ) then
        local statusEffectSystem = GameInstance.GetStatusEffectSystem()
        local effects = statusEffectSystem:GetAppliedEffectsWithID( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedCoolPerkSE" )
        for _, effect in ipairs(effects) do
          statusEffectSystem:SetStatusEffectRemainingDuration( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedCoolPerkSE" , effect:GetRemainingDuration() - 0.5)
          GameInstance.GetStatusEffectSystem():ApplyStatusEffect( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedDelayedStaminaConsumptionSE" )
        end
    end
    if staminaCost > 0.0 then
      PlayerStaminaHelpers.ModifyStamina( scriptInterface.executionOwner , -staminaCost)
    end
  end)

  ObserveBefore("AimingStateEvents" ,"OnExit" , function(self, stateContext, scriptInterface) -- returns void
    FocusSE = StatusEffectHelper.GetStatusEffectByID(scriptInterface.executionOwner, "BaseStatusEffect.FocusedCoolPerkSE")
    -- spdlog.info(tostring(FocusSE))
    if FocusSE then
      -- spdlog.info("focus duration was: " .. FocusSE:GetRemainingDuration())
      if FocusSE:GetRemainingDuration() < 1.5 then
        -- I don't like this workaround, but the SEHelper doesn't seem to act before the rest of the function is triggered, so here we are.
        if not StatusEffectHelper.GetStatusEffectByID(scriptInterface.executionOwner, "BaseStatusEffect.FocusedDelayedStaminaConsumptionSE") then
          -- spdlog.info("focus cost applied")

          local relaxedStacks = 0
          local FocusDiscountSE = StatusEffectHelper.GetStatusEffectByID( scriptInterface.executionOwner, "BaseStatusEffect.ReduceStaminaCostOfFocused" )
          if FocusDiscountSE then
             local relaxedStacks = FocusDiscountSE:GetStackCount()
          end
          PlayerStaminaHelpers.ModifyStamina( scriptInterface.executionOwner, -( TDB.GetInt( "NewPerks.Cool_Left_Milestone_2.focusedStaminaCost" ) - (TDB.GetInt("NewPerks.Cool_Left_Perk_2_4.staminaCostReduction" ) * relaxedStacks )) )
        end
      end
    end
  end)


  Override("StaminabarWidgetGameController", "OnFocusedCoolPerkActive", function(self, FocusPerkTriggerd) -- returns void
  end)

  Override("HitReactionComponent", "IsValidBodyPerkDismemberAttack", function(self, healthMissing) -- returns bool
    if self.m_attackData == nil then
      -- spdlog.info("m_attackData was nil")
      return false
    end
    -- spdlog.info("m_attackData wasn't nil")
    if PlayerDevelopmentSystem.GetData( self.m_attackData.GetInstigator() ):IsNewPerkBought( gamedataNewPerkType.Body_Left_Milestone_3 ) < 3 then 
			return false
    end
		chanceByHealth = 0.0
		if self.m_executeDismembered or self.m_invalidForExecuteDismember then
			return false
    end
		if healthMissing < self.m_dismemberExecuteHealthRange.X then 
			return false
    end
		if self.m_ownerNPC.IsBoss() or self.m_ownerNPC.GetNPCRarity() == gamedataNPCRarity.MaxTac then 
			return false
    end
		if not self.m_attackData or self.m_attackData:GetAttackType() ~= gamedataAttackType.Ranged or self.m_attackData.HasFlag( hitFlag.Explosion ) then 
			return false
    end
		if not m_attackDataGetInstigator().IsPlayer() then 
			return false
    end
		if not self.m_attackData.GetWeapon() then 
			return false
    end
		if not isBodyWeapon(RPGManager.GetItemType( self.m_attackData.GetWeapon():GetItemID() )) then
			return false
    end
		chanceByHealth = self.m_statsSystem.GetStatValue( self.m_attackData.GetInstigator().GetEntityID(), gamedataStatType.ExecuteDismemberByHealthChance )
		if chanceByHealth <= 0.0001 then 
			return false
    end
    spdlog.info("Wurked")
		return true
  end)

  -- this is defined as a function... and then typed out THREE TIMES. I'm sorry for slandering my collegues, but this looks like either the PM slept or the programmers didn't. Has calling this func caused THAT much lag?
  Override("SprintDecisions", "IsWreckingBallAllowed;StateGameScriptInterface", function (scriptInterface) -- returns bool
    return PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) >= 2 and WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ):GetItemID() ) and scriptInterface:GetStatPoolsSystem():GetStatPoolValue( scriptInterface.executionOwner:GetEntityID(), gamedataStatPoolType.Stamina, true ) > 0.0
  end)
  

  Override("MeleeBodySlamAttackDecisions", "EnterCondition", function(self, stateContext, scriptInterface) -- returns bool
  if PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) < 2 then
    return false
  end
  if not WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ):GetItemID() ) then
    return false
  end
  if not self:IsBlockHeld( stateContext, scriptInterface )  then
    return false
  end
  if not stateContext:IsStateActive( "Locomotion", "sprint" ) then
    return false
  end
  if scriptInterface:GetStatPoolsSystem():GetStatPoolValue( scriptInterface.executionOwner:GetEntityID(), gamedataStatPoolType.Stamina, true ) <= 0.0 then
    return false
  end
  return true
  end)

  Override("MeleeTransition", "MeleeSprintStateCondition;StateContextStateGameScriptInterface", function(stateContext, scriptInterface) -- returns bool#
    if (scriptInterface.localBlackboard.GetInt( GetAllBlackboardDefs().PlayerStateMachine.Melee ) == gamePSMMelee.Block and ( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) < 2 or scriptInterface:GetStatPoolsSystem():GetStatPoolValue( scriptInterface.executionOwner:GetEntityID(), gamedataStatPoolType.Stamina, true ) <= 0.0 )) then
      return false
    end
    if not stateContext:GetBoolParameter( "canSprintWhileCharging", true ) and stateContext:GetStateMachineCurrentState( StateMachineCurrentState ) == "meleeChargedHold" then
      return false
    end
    if stateContext:GetBoolParameter( "isAttacking", true ) and not stateContext:IsStateActive( "Melee", "meleeBodySlamAttack" ) then
      return false
    end
    return true
  end)
  
  Override("MeleeGroundSlamAttackDecisions", "EnterCondition", function(self, stateContext, scriptInterface) -- returns bool
    if scriptInterface:IsOnGround() then
      if not scriptInterface:GetStatsSystem():GetStatBoolValue( scriptInterface.executionOwnerEntityID, gamedataStatType.CanGroundSlamOnGround ) then
        return false
      end
    else
      if not scriptInterface:GetStatsSystem():GetStatBoolValue( scriptInterface.executionOwnerEntityID, gamedataStatType.CanGroundSlamInAir ) then
        return false
      end
    end
    if not self.WantsToQuickMelee( stateContext, scriptInterface ) then
      return false
    end
    if not WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ):GetItemID() ) then
      return false
    end
    if StatusEffectSystem.ObjectHasStatusEffect( scriptInterface.executionOwner, "BaseStatusEffect.GroundSlamCooldown") then
      stateContext:SetConditionBoolParameter( "QuickMeleeAttackTapped", false, true )
      return false
    end
    if not IsValidLocomotionState( stateContext:GetStateMachineCurrentState( "Locomotion" ) ) then
      return false
    end
    if not CanFit( scriptInterface ) then
        return false
    end
    if scriptInterface.localBlackboard.GetBool( GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideMovingElevator ) then
        return false
    end
    return true
  end)


  Override("DamageManager", "CanBlockBullet;gameHitEvent", function(hitEvent) -- returns bool
    if PlayerDevelopmentSystem.GetData( hitEvent.target ) == nil then
      return false
    end
    defenderWeapon = GameObject.GetActiveWeapon( hitEvent.target )
    if not defenderWeapon then
      return false
    end
    if not AttackData.IsRangedOnly( hitEvent.attackData:GetAttackType()) then
      return false
    end
    -- PDD = PlayerDevelopmentSystem.GetData( hitEvent.target )
    -- local Event = hitEvent.target
    -- local Data = PlayerDevelopmentSystem.GetData( hitEvent.target )
    -- local Perk = gamedataNewPerkType.Reflexes_Right_Milestone_2
    -- local PerkLvL = PlayerDevelopmentSystem.GetData( hitEvent.target ):IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 )
    if PlayerDevelopmentSystem.GetData( hitEvent.target ):IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 ) < 2 then
      return false
    end
    cameraForward = GameInstance.GetCameraSystem():GetActiveCameraForward()
    if not DamageManager.IsValidDirectionToDefendMeleeAttack( hitEvent.hitDirection, cameraForward ) then
      return false
    end
    if AbsF( Vector4.GetAngleDegAroundAxis( hitEvent.target:GetWorldForward(), cameraForward, hitEvent.target:GetWorldUp() ) ) > TDB.GetFloat("player.melee.maxLookbackDefendAngle") then
      return false
    end 
    return true
  end)

  Override("DamageSystem", "ProcessBulletBlockAndDeflect", function(self, hitEvent) -- returns nul
    computedDamageFactor = 1.0
    if not (hitEvent.attackData:WasBulletBlocked() or hitEvent.attackData:WasBulletDeflected()) then
      return
    end
    blockingItem = GameInstance.GetTransactionSystem():GetItemInSlot( hitEvent.target, "AttachmentSlots.WeaponRight" )
    attackingItem = hitEvent.attackData:GetWeapon()
    if not blockingItem or not attackingItem then
      return
    end
    playerTarget = hitEvent.target 
    if not playerTarget then
      return
    end
    playerDevelopmentData = PlayerDevelopmentSystem.GetData( playerTarget )
    perkLevel = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 )
    if( perkLevel < 2 ) then
      return
    end
    computedDamageFactor = 0.0
    statsSystem = GameInstance.GetStatsSystem()
    statPoolsSystem = GameInstance.GetStatPoolsSystem()
    targetID = playerTarget:GetEntityID()
    currentStamina = statPoolsSystem:GetStatPoolValue( hitEvent.target:GetEntityID(), gamedataStatPoolType.Stamina, false )
    perkGot = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_3 ) > 0
    timeDilActive = GameInstance.GetTimeSystem():IsTimeDilationActive()
    isBulletTimeActive = perkGot and timeDilActive
    if not isBulletTimeActive then
      meleeCostToBlock = statsSystem:GetStatValue( blockingItem:GetEntityID(), gamedataStatType.StaminaCostToBlock )
      staminaReduction = meleeCostToBlock / 2.0
      totalOriginalDamage = 0.0
      originalDamages = hitEvent.attackComputed:GetOriginalAttackValues()
      for i = 1, #originalDamages, 1 do
        totalOriginalDamage = totalOriginalDamage + originalDamages[ i ]
      end
      playerMaxHealth = GameInstance.GetStatsSystem():GetStatValue( playerTarget:GetEntityID(), gamedataStatType.Health )
      if playerMaxHealth > 0.0 then
        damagePerc = totalOriginalDamage / playerMaxHealth
        maxStaminaDamagePerc = 0.5
        if damagePerc < maxStaminaDamagePerc then
          staminaReduction = staminaReduction * MaxF( 0.2, damagePerc / maxStaminaDamagePerc )
        end
      end
      newStamina = MaxF( currentStamina - staminaReduction, 0.0 )
      if newStamina <= 0.0 then
        computedDamageFactor = TDB.GetFloat( "Constants.DamageSystem.blockBreakPlayerDamageFactor")
      end
      PlayerStaminaHelpers.ModifyStamina( playerTarget, -( staminaReduction ) )
      PlayerStaminaHelpers.OnPlayerBlock( playerTarget )
    end
    if computedDamageFactor ~= 1.0 then
      hitEvent.attackComputed:MultAttackValue( computedDamageFactor )
    end
    wasDeflected = hitEvent.attackData:HasFlag( hitFlag.WasBulletDeflected )
    perkR21Had = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_1 ) > 0
    staminaCostHad = currentStamina > statsSystem:GetStatValue( targetID, gamedataStatType.Stamina ) * statsSystem:GetStatValue( targetID, gamedataStatType.Reflexes_Right_Milestone_2_StaminaDeflectPerc )
    isDeflect = wasDeflected and perkR21Had and staminaCostHad
    if hitEvent.attackData:HasFlag( hitFlag.WasBulletParried ) or isDeflect then
      self:ProcessBulletDeflect( hitEvent, isBulletTimeActive, blockingItem )
    else
      GameObject.PlaySound( playerTarget, "w_perk_lead_and_steel" )
    end
  end)

  -- Override("FinisherEndEvents", "ApplyFinisherBuffs;PlayerPuppetBool", function(playerPuppet, isWorkspotFinisher) -- returns nul
  --   if not playerPuppet then
  --     return
  --   end
  --   weapon = GameObject.GetActiveWeapon( playerPuppet )
  --   StatusEffectHelper.RemoveStatusEffect( playerPuppet, "BaseStatusEffect.BlockFinisherStatusEffect" )
  --   StatusEffectHelper.RemoveStatusEffect( playerPuppet, "BaseStatusEffect.PlayerInFinisherWorkspot" )
  --   if isWorkspotFinisher then
  --     StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.BlockWorkspotFinisherStatusEffect", playerPuppet:GetEntityID() )
  --   end
  --   StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Finisher_Healing_Buff", playerPuppet:GetEntityID() )
  --   if weapon:IsMantisBlades() and ( PlayerDevelopmentSystem.GetData( playerPuppet ):IsNewPerkBought( gamedataNewPerkType.Espionage_Central_Milestone_1 ) > 0 ) then
  --     StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Espionage_Central_Milestone_1_Buff_MantisBlades" )
  --   end
  --   if PlayerDevelopmentSystem.GetData( playerPuppet ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_1 ) then
  --     StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Reflexes_Right_Perk_3_1_Buff_Level_1", playerPuppet:GetEntityID() )
  --   end
  -- end)


  Override("NewPerkFinisherCondition", "NewPerkFinisherThrowableEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    statsSystem = GameInstance.GetStatsSystem()
    distanceFromHotspot= Vector4.Length2D( subtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) )
    minDistance = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherCool_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      minDistance = minDistance * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    minDistance = minDistance + ( TweakDBInterface.GetFloat( "NewPerks.Cool_Inbetween_Right_3.distanceBase", 5.0 ) * ClampF( GameInstance.GetStatsSystem().GetStatValue( hotSpotObject.GetEntityID(), gamedataStatType.Cool_Inbetween_Right_3_Stacks ), 0.0, TweakDBInterface.GetFloat( "NewPerks.Cool_Inbetween_Right_3.distanceMaxStacks", 3.0 ) ) )
    if distanceFromHotspot > minDistance then
      return false
    end
    return true
  end)

  Override("NewPerkFinisherCondition", "NewPerkFinisherMonowireEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    statsSystem = GameInstance.GetStatsSystem()
    distanceFromHotspot = Vector4.Length2D( subtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) )
    minDistance = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherMonowire_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      minDistance = minDistance * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    minDistance = minDistance + ( TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 3.0 ) * ( ( Float )( ( ( ScriptedPuppet )( hotSpotObject ) ).GetDeviceActionQueueSize() ) ) )
    if distanceFromHotspot > minDistance then
      return false
    end
    return true
  end)

  Override("NewPerkFinisherCondition", "NewPerkFinisherBluntEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    statsSystem = GameInstance.GetStatsSystem()
    targetDistanceMax = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherBlunt_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      minDistance = minDistance * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    if Vector4.Length2D( subtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) ) > targetDistanceMax  then
      return false
    end
    return true
  end)

  ObserveAfter("RPGManager", "AwardExperienceFromDamage;gameHitEventFloat", function(hitEvent, damagePercentage) -- returns nil
    -- spdlog.info("damagePercentage is: " .. damagePercentage)

  local attackDataVar = hitEvent.attackData
  if not attackDataVar or attackDataVar == nil  then
    -- spdlog.info("attackDataVar was nil or broken")
    return
  end
  if AttackData.IsDoT( attackDataVar ) then
    return
  end

  local weapon = attackDataVar:GetWeapon()
  if not weapon then
    -- spdlog.info("weapon was nil or broken.")
    return
  end

  local targetPuppet = hitEvent.target
  if not targetPuppet then
    return
  end
  
  if not targetPuppet or not targetPuppet:IsActive() or not targetPuppet:AwardsExperience() or not attackDataVar:GetInstigator():IsPlayer() or hitEvent.target:IsPlayer() then
    -- spdlog.info("targetPuppet was nil or broken")
    return
  end

  local weaponRecord = TweakDBInterface.GetItemRecord( ItemID.GetTDBID( weapon:GetItemID() ) ) --now this is nil?!

  local targetPowerLevel = GameInstance.GetStatsSystem():GetStatValue( targetPuppet:GetEntityID(), gamedataStatType.PowerLevel )
  local queueExpRequest = QueueCombatExperience.new()
  -- spdlog.info(tostring(queueExpRequest:GetClassName()))

  queueExpRequest.m_experienceType = weaponTypeToAttribute[tostring( weaponRecord:ItemType():Type() )]
  if not queueExpRequest.m_experienceType then
    return
  end
  queueExpRequest.m_amount = GameInstance.GetStatsDataSystem():GetValueFromCurve( "activity_to_proficiency_xp", targetPowerLevel, "damage_to_skill_xp" ) * 0.5  
  evolution = weaponRecord:Evolution():Type()
  if evolution == gamedataWeaponEvolution.Smart or evolution == gamedataWeaponEvolution.Tech then
    queueExpRequest.m_amount = queueExpRequest.m_amount * 0.5
  end



  if attackDataVar:HasFlag( hitFlag.WeakspotHit ) or attackDataVar:HasFlag( hitFlag.Headshot ) or attackDataVar:HasFlag( hitFlag.FinisherTriggered ) then
    queueExpRequest.m_amount = queueExpRequest.m_amount * 1.10
  end
  if attackDataVar:HasFlag( hitFlag.PerfectlyCharged ) then
    queueExpRequest.m_amount = queueExpRequest.m_amount * 1.10
  end 
  if attackDataVar:HasFlag( hitFlag.BodyPerksMeleeAttack ) then
    queueExpRequest.m_amount = queueExpRequest.m_amount * 1.10
  end
  -- spdlog.info("m_amount was: " .. queueExpRequest.m_amount .. "after weakpoint check")

  player = Game.GetPlayer()
  playerXPmultiplier = Game.GetStatsSystem():GetStatValue( player:GetEntityID(), gamedataStatType.XPbonusMultiplier )

  playerDevelopmentData = PlayerDevelopmentSystem.GetData( player )
  -- spdlog.info("m_amount was: " .. queueExpRequest.m_amount .. " at granting")
  queueExpRequest.owner = player
  queueExpRequest.m_amount = queueExpRequest.m_amount * RPGManager.GetRarityMultiplier( targetPuppet , "power_level_to_dmg_xp_mult" )
  -- spdlog.info("rarity multiplier was: " .. RPGManager.GetRarityMultiplier( targetPuppet , "power_level_to_dmg_xp_mult" ))
  queueExpRequest.m_amount = queueExpRequest.m_amount * damagePercentage
  queueExpRequest.m_amount = queueExpRequest.m_amount * playerXPmultiplier
  queueExpRequest.m_entity = targetPuppet:GetEntityID()
  -- spdlog.info("Awarded: " .. tostring(queueExpRequest.m_amount) .. " ".. tostring(queueExpRequest.m_experienceType) .. " XP to player?: " .. tostring(queueExpRequest.owner:IsPlayerControlled()))
  playerDevelopmentData:QueueCombatExperience(queueExpRequest.m_amount, queueExpRequest.m_experienceType, queueExpRequest.m_entity)

  end)


end)

-- unedited
-- function grantExperience()
--   var i, j : Int32;
--   var toRemove : array< Int32 >;
--   var removeIndex : Int32;
--   var expAwarded : Bool;
--   var expAmount : Float;
--   for( i = 0; i < ( ( Int32 )( gamedataProficiencyType.Count ) ); i += 1 )
--   {
--     expAwarded = false;
--     expAmount = 0.0;
--     for( j = 0; j < m_queuedCombatExp.Size(); j += 1 )
--     {
--       if( ( m_queuedCombatExp[ j ].entity == entity ) && ( ( ( Int32 )( m_queuedCombatExp[ j ].forType ) ) == i ) )
--       {
--         expAmount += m_queuedCombatExp[ j ].amount;
--         expAwarded = true;
--         toRemove.PushBack( j );
--       }
--     }
--     for( j = 0; j < toRemove.Size(); j += 1 )
--     {
--       removeIndex = toRemove.PopBack();
--       m_queuedCombatExp.Erase( removeIndex );
--     }
--     if( expAwarded )
--     {
--       AddExperience( ( ( Int32 )( expAmount ) ), ( ( gamedataProficiencyType )( i ) ), telemetryLevelGainReason.Gameplay );
--     }
--   }
-- end


function isNewCoolWeapon(weaponType)
  if weaponType == gamedataItemType.Wea_SubmachineGun or weaponType == gamedataItemType.Wea_Shotgun or weaponType == gamedataItemType.Wea_ShotgunDual or weaponType == gamedataItemType.Wea_Revolver or weaponType == gamedataItemType.Wea_Handgun or weaponType == gamedataItemType.Wea_PrecisionRifle or weaponType == gamedataItemType.Wea_SniperRifle or weaponType == gamedataItemType.Wea_Knife or weaponType == gamedataItemType.Wea_Axe then
    return true
  else
    return false
  end
end

function isBodyWeapon(weaponType)
  if weaponType == gamedataItemType.Wea_Revolver or weaponType == gamedataItemType.Wea_SniperRifle or weaponType == gamedataItemType.Wea_Shotgun  or weaponType == gamedataItemType.Wea_ShotgunDual or weaponType == gamedataItemType.Wea_LightMachineGun or weaponType == gamedataItemType.Wea_HeavyMachineGun then
    return true
  else
    return false
  end
end

function subtractVector(v1, v2)
  return Vector4.new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w)
end

function powerWeaponBonus( weaponRecord ) 
  if weaponRecord:TagsContains( "PowerWeapon" ) then 
    return 1.0 
  else 
    return 0.5 
  end
end