registerForEvent("onInit", function()

  ObserveAfter("DefaultTransition", "HandleDamagePreview", function( self , weapon , scriptInterface , stateContext ) 
    --   spdlog.info("DefaultTransition;HandleDamagePreview running")
    local inStealth = false
    if PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Right_Milestone_1 ) == 1 then
      --   spdlog.info("checked perk Level")
      inStealth = ( scriptInterface.localBlackboard:GetInt( GetAllBlackboardDefs().PlayerStateMachine.Combat ) ~= gamePSMCombat.InCombat )
      --   spdlog.info("set stealth bool")
      if  ( ( inStealth and not self:CanWeaponSilentKill( weapon, scriptInterface ) ) and self:IsNameplateVisible( scriptInterface ) ) and not stateContext:GetBoolParameter( "DamagePreviewActive", true ) then
        --   spdlog.info("checked conditions")
        self:ActivateDamageProjection( true, weapon, scriptInterface, stateContext )
        --   spdlog.info("set projection")
      end
    end
    --   spdlog.info("DefaultTransition;HandleDamagePreview finished running")
  end)

  ObserveAfter("AimingStateEvents", "OnEnter", function(self, stateContext, scriptInterface) -- returns nil
    --   spdlog.info("AimingStateEvents;OnEnter running")
    if PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2 then
      if GameInstance.GetStatPoolsSystem( ):GetStatPoolValue( scriptInterface.executionOwner:GetEntityID( ), gamedataStatPoolType.Stamina ) > TDB.GetFloat( "NewPerks.Cool_Left_Milestone_2.focusedStaminaThreshold" ) then
        if not self.weapon then
          return
          -- self.weapon = Game.GetTransactionSystem():GetItemInSlot( self.executionOwner, "AttachmentSlots.WeaponRight" )
        end
        if self.weapon:IsRanged() and not GameInstance.GetTimeSystem( ):IsTimeDilationActive( ) then
          --apply focus
          StatusEffectHelper.ApplyStatusEffect( Game.GetPlayer(), TweakDBID.new("BaseStatusEffect.FocusedCoolPerkSE") )
          -- apply Focus timeDilation
          Game.GetTimeSystem():SetTimeDilation( CName"focusedStatePerkDilation", 1.0-TweakDB:GetFlat("NewPerks.Cool_Left_Milestone_2.timeDilationStrength"), 12.0, "MeleeHitEaseIn", "MeleeHitEaseOut")
        end
      end
    end  
    --   spdlog.info("AimingStateEvents;OnEnter finished running")
  end)
  

  ObserveAfter( "AimingStateEvents", "OnItemEquipped", function( self, slot, item )
    --   spdlog.info("AimingStateEvents;OnItemEquipped running")
    local applyCycleTimeBuff = true
    
    if PlayerDevelopmentSystem.GetData( self.executionOwner ):IsNewPerkBought( gamedataNewPerkType.Cool_Left_Milestone_3 ) < 2 then
      return
    end

    self.weapon = Game.GetTransactionSystem():GetItemInSlot( self.executionOwner, "AttachmentSlots.WeaponRight" )

    if not self.weapon:WeaponHasTag( "RangedWeapon" ) then
      return
    end

    if not item or item == nil then
      --   spdlog.info( "No item equipped" )
      return
    end
    
    local triggerModes = RPGManager.GetItemRecord( item ):TriggerModes( )
    if not triggerModes then
      --   spdlog.info( "Item had no trigger modes" )
    end

    --   spdlog.info( "TriggerModes were:" )
    -- print( "TriggerModes were:" )
    for _, triggerMode in ipairs( triggerModes ) do
      if tostring( triggerMode:Type( ) ) == "gamedataTriggerMode : Burst (0)" or tostring( triggerMode:Type( ) ) == "gamedataTriggerMode : FullAuto (2)" then
      --   spdlog.info( tostring( triggerMode:Type( ) ) )
        if triggerMode:Type( ) == gamedataTriggerMode.Burst or triggerMode:Type( ) == gamedataTriggerMode.FullAuto then
          --   spdlog.info( "Trigger Mode was burst or full auto" )
          -- print( "Trigger Mode was burst or full auto")
          applyCycleTimeBuff = false
          StatusEffectHelper.RemoveStatusEffect( self.executionOwner, "PerksApplyToMore.Deadeye_CycleTimeBuff" )
          --   spdlog.info( "Deadeye_CycleTimeBuff removed" )
          -- print( "Deadeye_CycleTimeBuff removed" )
          return
        end
      end
    end
    --   spdlog.info( "Trigger Mode wasn't burst or full auto" )
    -- print( "Trigger Mode wasn't burst or full auto" )

    if applyCycleTimeBuff then
      StatusEffectHelper.ApplyStatusEffect( self.executionOwner, "PerksApplyToMore.Deadeye_CycleTimeBuff" )
      --   spdlog.info( "Deadeye_CycleTimeBuff applied" )
      -- print( "Deadeye_CycleTimeBuff applied" )
    end
  --   spdlog.info("AimingStateEvents;OnItemEquipped finished running")
  end)

  ObserveAfter( "AimingStateEvents", "OnItemUnequipped", function( self, slot, item ) 
  --   spdlog.info("AimingStateEvents;OnItemUnequipped running")
    if StatusEffectSystem.ObjectHasStatusEffectWithTag( self.executionOwner, "Deadeye_CycleTimeBuff" ) then
      StatusEffectHelper.RemoveStatusEffect( self.executionOwner, "PerksApplyToMore.Deadeye_CycleTimeBuff" )
    end
  --   spdlog.info("AimingStateEvents;OnItemUnequipped finished running")
  end)


  Override("ShootEvents", "ConsumeStamina", function( self, scriptInterface, attackRecord, staminaPenaltyMultiplier, staminaFullChargePenaltyMultiplier ) -- returns void
    local staminaCost = 0.0
    local staminaCostMods = attackRecord:StaminaCost()

    staminaCost = RPGManager.CalculateStatModifiers(staminaCostMods, scriptInterface.owner, scriptInterface.ownerEntityID )
    staminaCost = staminaCost * staminaPenaltyMultiplier
		staminaCost = staminaCost * staminaFullChargePenaltyMultiplier
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
    local FocusSE = StatusEffectHelper.GetStatusEffectByID(scriptInterface.executionOwner, "BaseStatusEffect.FocusedCoolPerkSE")
    --   spdlog.info(tostring(FocusSE))
    if FocusSE then
      --   spdlog.info("focus duration was: " .. FocusSE:GetRemainingDuration())
      if FocusSE:GetRemainingDuration() < 1.5 then
        -- I don't like this workaround, but the SEHelper doesn't seem to act before the rest of the function is triggered, so here we are.
        if not StatusEffectHelper.GetStatusEffectByID(scriptInterface.executionOwner, "BaseStatusEffect.FocusedDelayedStaminaConsumptionSE") then
          --   spdlog.info("focus cost applied")

          local relaxedStacks = 0
          local FocusDiscountSE = StatusEffectHelper.GetStatusEffectByID( scriptInterface.executionOwner, "BaseStatusEffect.ReduceStaminaCostOfFocused" )
          if FocusDiscountSE then
              relaxedStacks = FocusDiscountSE:GetStackCount()
          end
          PlayerStaminaHelpers.ModifyStamina( scriptInterface.executionOwner, -( TDB.GetInt( "NewPerks.Cool_Left_Milestone_2.focusedStaminaCost" ) - (TDB.GetInt("NewPerks.Cool_Left_Perk_2_4.staminaCostReduction" ) * relaxedStacks )) )
        end
      end
    end
  end)

  -- ObserveBefore("ItemInSlotPrereq" ,"Evaluate" , function(self, itemID, owner) -- returns void
  -- local triggermodetocheck = TweakDBInterface.GetTriggerModeRecord( self.recordID + ".triggerMode" ).Type()
  -- local result
  --   if gamedataCheckType.TriggerType then
  --     RPGManager.GetItemRecord( item ):TriggerModes( )
  --     if not triggerModes then
  --       --   spdlog.info( "Item had no trigger modes" )
  --     end
  
  --     --   spdlog.info( "TriggerModes were:" )
  --     -- print( "TriggerModes were:" )
  --     for _, triggerMode in ipairs( triggerModes ) do
  --       if triggerMode:Type( ) == gamedataTriggerMode.Burst or triggerMode:Type( ) == gamedataTriggerMode.FullAuto then
  --         -- set variable
  --       end
  --     end
  --     if self.invert then
  --       return not result
  --     else
  --       return result
  --     end
  --   end
  -- end)

  Override("StaminabarWidgetGameController", "OnFocusedCoolPerkActive", function(self, FocusPerkTriggerd) -- returns void
  end)

  Override("HitReactionComponent", "IsValidBodyPerkDismemberAttack", function(self, healthMissing) -- returns bool
    if not self.attackData then
      --   spdlog.info("attackData was nil")
      return false
    end
    local attackInstigator = self.attackData:GetInstigator( )
    if not attackInstigator:IsPlayer( ) then 
			return false
    end
    if PlayerDevelopmentSystem.GetData( attackInstigator ):IsNewPerkBought( gamedataNewPerkType.Body_Left_Milestone_3 ) < 3 then 
			return false
    end
		local chanceByHealth = 0.0
		if self.executeDismembered or self.invalidForExecuteDismember then
			return false
    end
		if healthMissing < self.dismemberExecuteHealthRange.X then 
			return false
    end
		if self.ownerNPC:IsBoss( ) or self.ownerNPC:GetNPCRarity( ) == gamedataNPCRarity.MaxTac then 
			return false
    end
		if not self.attackData or self.attackData:GetAttackType( ) ~= gamedataAttackType.Ranged or self.attackData:HasFlag( hitFlag.Explosion ) then 
			return false
    end
		if not self.attackData:GetWeapon( ) then 
			return false
    end
		if not self.attackData:GetWeapon( ):IsRanged( ) then
			return false
    end
	  chanceByHealth = self.statsSystem:GetStatValue( attackInstigator:GetEntityID( ), gamedataStatType.ExecuteDismemberByHealthChance )
		if chanceByHealth <= 0.0001 then 
			return false
    end
    --   spdlog.info( "Body_Left_Milestone_3 worked" )
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
    return false  end
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
    if ( scriptInterface.localBlackboard:GetInt( GetAllBlackboardDefs().PlayerStateMachine.Melee ) == gamePSMMelee.Block and ( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ):IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) < 2 or scriptInterface:GetStatPoolsSystem():GetStatPoolValue( scriptInterface.executionOwner:GetEntityID(), gamedataStatPoolType.Stamina, true ) <= 0.0 )) then
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
    if not self.IsValidLocomotionState( stateContext:GetStateMachineCurrentState( "Locomotion" ) ) then
      return false
    end
    if not CanFit( scriptInterface ) then
        return false
    end
    if scriptInterface.localBlackboard:GetBool( GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideMovingElevator ) then
        return false
    end
    return true
  end)


  Override("DamageManager", "CanBlockBullet;gameHitEvent", function(hitEvent) -- returns bool
    if PlayerDevelopmentSystem.GetData( hitEvent.target ) == nil then
      return false
    end
    local defenderWeapon = GameObject.GetActiveWeapon( hitEvent.target )
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
    local cameraForward = GameInstance.GetCameraSystem():GetActiveCameraForward()
    if not DamageManager.IsValidDirectionToDefendMeleeAttack( hitEvent.hitDirection, cameraForward ) then
      return false
    end
    if AbsF( Vector4.GetAngleDegAroundAxis( hitEvent.target:GetWorldForward(), cameraForward, hitEvent.target:GetWorldUp() ) ) > TDB.GetFloat("player.melee.maxLookbackDefendAngle") then
      return false
    end 
    return true
  end)

  Override("DamageSystem", "ProcessBulletBlockAndDeflect", function(self, hitEvent) -- returns nul
    local computedDamageFactor = 1.0
    if not (hitEvent.attackData:WasBulletBlocked() or hitEvent.attackData:WasBulletDeflected()) then
      return
    end
    local blockingItem = GameInstance.GetTransactionSystem():GetItemInSlot( hitEvent.target, "AttachmentSlots.WeaponRight" )
    local  attackingItem = hitEvent.attackData:GetWeapon()
    if not blockingItem or not attackingItem then
      return
    end
    local playerTarget = hitEvent.target 
    if not playerTarget then
      return
    end
    local playerDevelopmentData = PlayerDevelopmentSystem.GetData( playerTarget )
    local perkLevel = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 )
    if( perkLevel < 2 ) then
      return
    end
    computedDamageFactor = 0.0
    local statsSystem = GameInstance.GetStatsSystem()
    local statPoolsSystem = GameInstance.GetStatPoolsSystem()
    local targetID = playerTarget:GetEntityID()
    local currentStamina = statPoolsSystem:GetStatPoolValue( hitEvent.target:GetEntityID(), gamedataStatPoolType.Stamina, false )
    local perkGot = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_3 ) > 0
    local timeDilActive = GameInstance.GetTimeSystem():IsTimeDilationActive()
    local isBulletTimeActive = perkGot and timeDilActive
    if not isBulletTimeActive then
      local meleeCostToBlock = statsSystem:GetStatValue( blockingItem:GetEntityID(), gamedataStatType.StaminaCostToBlock )
      local staminaReduction = meleeCostToBlock / 2.0
      local totalOriginalDamage = 0.0
      local originalDamages = hitEvent.attackComputed:GetOriginalAttackValues()
      for i = 1, #originalDamages, 1 do
        totalOriginalDamage = totalOriginalDamage + originalDamages[ i ]
      end
      local playerMaxHealth = GameInstance.GetStatsSystem():GetStatValue( playerTarget:GetEntityID(), gamedataStatType.Health )
      if playerMaxHealth > 0.0 then
        local damagePerc = totalOriginalDamage / playerMaxHealth
        local maxStaminaDamagePerc = 0.5
        if damagePerc < maxStaminaDamagePerc then
          staminaReduction = staminaReduction * MaxF( 0.2, damagePerc / maxStaminaDamagePerc )
        end
      end
      local newStamina = MaxF( currentStamina - staminaReduction, 0.0 )
      if newStamina <= 0.0 then
        computedDamageFactor = TDB.GetFloat( "Constants.DamageSystem.blockBreakPlayerDamageFactor")
      end
      PlayerStaminaHelpers.ModifyStamina( playerTarget, -( staminaReduction ) )
      PlayerStaminaHelpers.OnPlayerBlock( playerTarget )
    end
    if computedDamageFactor ~= 1.0 then
      hitEvent.attackComputed:MultAttackValue( computedDamageFactor )
    end
    local wasDeflected = hitEvent.attackData:HasFlag( hitFlag.WasBulletDeflected )
    local perkR21Had = playerDevelopmentData:IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_1 ) > 0
    local staminaCostHad = currentStamina > statsSystem:GetStatValue( targetID, gamedataStatType.Stamina ) * statsSystem:GetStatValue( targetID, gamedataStatType.Reflexes_Right_Milestone_2_StaminaDeflectPerc )
    local isDeflect = wasDeflected and perkR21Had and staminaCostHad
    if hitEvent.attackData:HasFlag( hitFlag.WasBulletParried ) or isDeflect then
      self:ProcessBulletDeflect( hitEvent, isBulletTimeActive, blockingItem )
    else
      GameObject.PlaySound( playerTarget, "w_perk_lead_and_steel" )
    end
  end)

  Override("FinisherEndEvents", "ApplyFinisherBuffs;PlayerPuppetBool", function(playerPuppet, isWorkspotFinisher) -- returns nul
    if not playerPuppet then
      return
    end
    local weapon = GameObject.GetActiveWeapon( playerPuppet )
    StatusEffectHelper.RemoveStatusEffect( playerPuppet, "BaseStatusEffect.BlockFinisherStatusEffect" )
    StatusEffectHelper.RemoveStatusEffect( playerPuppet, "BaseStatusEffect.PlayerInFinisherWorkspot" )
    if isWorkspotFinisher then
      StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.BlockWorkspotFinisherStatusEffect", playerPuppet:GetEntityID() )
    end
    StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Finisher_Healing_Buff", playerPuppet:GetEntityID() )
    if weapon:IsMantisBlades() and ( PlayerDevelopmentSystem.GetData( playerPuppet ):IsNewPerkBought( gamedataNewPerkType.Espionage_Central_Milestone_1 ) > 0 ) then
      StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Espionage_Central_Milestone_1_Buff_MantisBlades" )
    end
    if PlayerDevelopmentSystem.GetData( playerPuppet ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_1 ) then
      StatusEffectHelper.ApplyStatusEffect( playerPuppet, "BaseStatusEffect.Reflexes_Right_Perk_3_1_Buff_Level_1", playerPuppet:GetEntityID() )
    end
  end)


  Override("NewPerkFinisherCondition", "NewPerkFinisherThrowableEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    local statsSystem = GameInstance.GetStatsSystem()
    local distanceFromHotspot= Vector4.Length2D( SubtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) )
    local minDistance = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherCool_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      minDistance = minDistance * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    minDistance = minDistance + ( TweakDBInterface.GetFloat( "NewPerks.Cool_Inbetween_Right_3.distanceBase", 5.0 ) * ClampF( GameInstance.GetStatsSystem():GetStatValue( hotSpotObject:GetEntityID(), gamedataStatType.Cool_Inbetween_Right_3_Stacks ), 0.0, TweakDBInterface.GetFloat( "NewPerks.Cool_Inbetween_Right_3.distanceMaxStacks", 3.0 ) ) )
    if distanceFromHotspot > minDistance then
      return false
    end
    return true
  end)

  Override("NewPerkFinisherCondition", "NewPerkFinisherMonowireEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    local statsSystem = GameInstance.GetStatsSystem()
    local distanceFromHotspot = Vector4.Length2D( SubtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) )
    local minDistance = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherMonowire_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      minDistance = minDistance * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    minDistance = minDistance + TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 3.0 ) * ( hotSpotObject:GetDeviceActionQueueSize( ) )
    if distanceFromHotspot > minDistance then
      return false
    end
    return true
  end)

  Override("NewPerkFinisherCondition", "NewPerkFinisherBluntEnabled", function(self, activatorObject, hotSpotObject, equippedWeapon) -- returns bool
    local statsSystem = GameInstance.GetStatsSystem()
    local targetDistanceMax = statsSystem:GetStatValue( activatorObject:GetEntityID(), gamedataStatType.NewPerkFinisherBlunt_TargetDistanceMax )
    if PlayerDevelopmentSystem.GetData( activatorObject ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) then
      targetDistanceMax = targetDistanceMax * TweakDBInterface.GetFloat( "NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 )
    end
    if Vector4.Length2D( SubtractVector(hotSpotObject:GetWorldPosition() , activatorObject:GetWorldPosition()) ) > targetDistanceMax  then
      return false
    end
    return true
  end)


--   -- this was an attempt to isolate the Yeet finisher.
--   -- the following Crashes the Shit out of the game
-- Override("GameObject", "HasFinisherAvailable", function(self) -- returns bool
--     if not self or not self:IsPlayer() then
--       return false
--     end
-- 		local statsSystem = GameInstance.GetStatsSystem( )
-- 		local weapon = GameObject.GetActiveWeapon( self )
-- 		return     ( 
--       statsSystem:GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformReflexFinisher ) and weapon:IsBlade() or
--       statsSystem:GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformBluntFinisher ) and weapon:IsBlunt() or
--       statsSystem:GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformCoolFinisher ) and weapon:IsThrowable() or
--       statsSystem:GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformMonowireFinisher ) and weapon:IsMonowire()
--       or
--       PlayerDevelopmentSystem.GetData( Game.GetPlayer() ):IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Body_Right_Master_5 )
--     )
-- end)

-- Override("ScriptedPuppet", "ProcessNewPerkFinisherLayer", function(self, evt, playerPuppet, npcPuppet) -- returns bool
--   if not npcPuppet then
--     return
--   end
--   if not playerPuppet:HasFinisherAvailable() then
--     return
--   end
--   if evt.choice.choiceMetaData.tweakDBID == "Interactions.NewPerkFinisherBluntHold" then
--     self.TriggerNewPerkFinisherBluntHold( playerPuppet, npcPuppet )
--   else
--     if isMeleeFinisherAvailible() then
--       self.TriggerNewPerkFinisher( evt, playerPuppet )
--     end
--   end
-- end)


end)



-- function isMeleeFinisherAvailible()
--   statsSystem = GameInstance.GetStatsSystem( )
--   weapon = GameObject.GetActiveWeapon( Game.GetPlayer() )
--   return (
--   statsSystem.GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformReflexFinisher ) and weapon.IsBlade() or
--   statsSystem.GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformBluntFinisher ) and weapon.IsBlunt() or
--   statsSystem.GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformCoolFinisher ) and weapon.IsThrowable() or
--   statsSystem.GetStatBoolValue( Game.GetPlayer():GetEntityID(), gamedataStatType.CanPerformMonowireFinisher ) and weapon.IsMonowire()
-- )
-- end

-- DONE in HasFinisherAvailable add a seperate check for yeet finisher
-- in ProcessNewPerkFinisherLayer check if fallback is melee else fallback to none
-- Note they check weapon AGAIN on NewPerkFinisherBluntEnabled

function SubtractVector(v1, v2)
  return Vector4.new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w)
end