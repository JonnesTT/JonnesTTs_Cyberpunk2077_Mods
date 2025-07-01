




// Gag Order
// making damage preview not stealth reliant
@replaceMethod(DefaultTransition)
protected func HandleDamagePreview( weapon : ref<WeaponObject>, scriptInterface : ref<StateGameScriptInterface>, stateContext : ref<StateContext> )
{
  if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Right_Milestone_1 ) == 1 )
  {
    if( ( this.IsNameplateVisible( scriptInterface ) ) && !( stateContext.GetBoolParameter( n"DamagePreviewActive", true ) ) )
    {
      this.ActivateDamageProjection( true, weapon, scriptInterface, stateContext );
    }
    else if( stateContext.GetBoolParameter( n"DamagePreviewActive", true ) && ( !( this.IsNameplateVisible( scriptInterface ) ) )  )
    {
      this.ActivateDamageProjection( false, weapon, scriptInterface, stateContext );
    }
  }
}

// Focus
// making Focus do time dilation by default
// @replaceMethod(AimingStateEvents)
// protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
// {
//   let player : PlayerPuppet;
//   let aimingCost : Float;
//   let weaponType : gamedataItemType;
//   let timeDilationFocusedPerk : Float;
//   let focusEventUI : FocusPerkTriggerd;
//   player = ( scriptInterface.executionOwner as PlayerPuppet);
//   super.OnEnter( stateContext, scriptInterface );
//   if( this.m_itemChanged )
//   {
//     this.m_weapon = this.GetWeaponObject( scriptInterface );
//     this.m_weaponHasPerfectAim = scriptInterface.GetTransactionSystem().HasTag( scriptInterface.executionOwner, n"PerfectAim", this.m_weapon.GetItemID() );
//   }
//   aimingCost = GameInstance.GetStatsSystem( player.GetGame() ).GetStatValue( Cast<StatsObjectID>( this.m_weapon.GetEntityID() ), gamedataStatType.AimingCost );
//   PlayerStaminaHelpers.ModifyStamina( player, -( aimingCost ) );
//   stateContext.SetConditionBoolParameter( n"AimingInterrupted", false, true );
//   scriptInterface.SetAnimationParameterBool( n"has_scope", this.m_weapon.HasScope() );
//   stateContext.SetTemporaryBoolParameter( n"InterruptSprint", true, true );
//   stateContext.SetTemporaryBoolParameter( n"InterruptSprintByAiming", true, true );
//   this.SetBlackboardIntVariable( scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.UpperBody, ( Cast<Int32>(EnumValueFromName(n"gamePSMUpperBodyStates", n"Aim") ) ) );
//   player.OnEnterAimState();
//   this.PlayEffectOnHeldItems( scriptInterface, n"lightswitch" );
//   this.OnAimStartBegin( stateContext, scriptInterface );
//   this. m_numZoomLevels = this.GetStaticIntParameterDefault( "maxNumberOfZoomLevels", 1 );
//   if( this.m_itemChanged )
//   {
//     this.UpdateWeaponOffsetPosition( scriptInterface );
//   }
//   this.m_itemChanged = false;
//   if( StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, n"RelaxedCoolPerkSE" ) )
//   {
//     StatusEffectHelper.RemoveStatusEffect( this.m_executionOwner, t"BaseStatusEffect.RelaxedCoolPerkSE" );
//   }
//   if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2 )
//   {
//     if( !( StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, n"FocusedCoolPerkSE" ) ) )
//     {
//       if( GameInstance.GetStatPoolsSystem( scriptInterface.owner.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>( this.m_executionOwner.GetEntityID() ), gamedataStatPoolType.Stamina ) > TDB.GetFloat( t"NewPerks.Cool_Left_Milestone_2.focusedStaminaThreshold" ) )
//       {
//         // weaponType = RPGManager.GetItemRecord( this.m_weapon.GetItemID() ).ItemType().Type();
//         // if( ( ( Equals(weaponType, gamedataItemType.Wea_Handgun) || weaponType == gamedataItemType.Wea_Revolver ) || weaponType == gamedataItemType.Wea_SniperRifle ) || weaponType == gamedataItemType.Wea_PrecisionRifle )
//         // {
//         //   StatusEffectHelper.ApplyStatusEffect( m_executionOwner, T"BaseStatusEffect.FocusedCoolPerkSE" );
//         //   focusEventUI = new FocusPerkTriggerd;
//         //   focusEventUI.isActive = true;
//         //   player.QueueEvent( focusEventUI );
//         //   GameObjectEffectHelper.StartEffectEvent( scriptInterface.executionOwner, 'cool_perk_focused_state_fullscreen', false );
//         //   GameObject.PlaySoundEvent( scriptInterface.owner, 'time_dilation_focused_enter' ); 
//         // changed check for gamedataNewPerkType.Cool_Inbetween_Left_2 lvl 1 to gamedataNewPerkType.Cool_Left_Milestone_2 lvl 2
//           if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2 )
//           {
//             timeDilationFocusedPerk = TDB.GetFloat( t"NewPerks.Cool_Inbetween_Left_2.timeDilationStrength" );
//             GameInstance.GetTimeSystem( scriptInterface.owner.GetGame() ).SetTimeDilation( n"focusedStatePerkDilation", 1.0 - timeDilationFocusedPerk, 12.0, n"MeleeHitEaseIn", n"MeleeHitEaseOut" );
//           }
//         // }
//       }
//     }
//   }
//   this.TryToActivateAirKerenzikovPerk( stateContext, scriptInterface );
// }


@wrapMethod(AimingStateEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
{

  wrappedMethod(stateContext, scriptInterface);
  if(PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2)
  {
    if(GameInstance.GetStatPoolsSystem( scriptInterface.owner.GetGame() ).GetStatPoolValue( Cast(this.m_executionOwner.GetEntityID()), gamedataStatPoolType.Stamina ) > TDB.GetFloat( t"NewPerks.Cool_Left_Milestone_2.focusedStaminaThreshold" ) )
    {
      if( this.m_weapon == null )
      {
        return;
      }

      let timeDilationFocusedPerk : Float = FromVariant<Float>(TweakDBInterface.GetFlat(t"NewPerks.Cool_Left_Milestone_2.timeDilationStrength"));

      if ( !GameInstance.GetTimeSystem( scriptInterface.owner.GetGame() ).IsTimeDilationActive( ) && ( this.m_weapon.IsRanged() || this.m_weapon.IsThrowable() ) )
      {
        StatusEffectHelper.ApplyStatusEffect( this.m_executionOwner, t"BaseStatusEffect.FocusedCoolPerkSE" );
        GameInstance.GetTimeSystem( scriptInterface.owner.GetGame() ).SetTimeDilation( n"focusedStatePerkDilation", 1.0 - timeDilationFocusedPerk, 12.0, n"MeleeHitEaseIn", n"MeleeHitEaseOut" );
      }
    }
  }
}

// remove stamina cost reduction
@replaceMethod(ShootEvents)
protected func ConsumeStamina( scriptInterface : ref<StateGameScriptInterface>, attackRecord : wref< Attack_Record >, staminaPenaltyMultiplier : Float, staminaFullChargePenaltyMultiplier : Float )
{
  let staminaCost : Float;
  let staminaCostMods : array< wref< StatModifier_Record > >;
  attackRecord.StaminaCost( staminaCostMods );
  staminaCost = RPGManager.CalculateStatModifiers( staminaCostMods, scriptInterface.GetGame(), scriptInterface.owner, Cast<StatsObjectID>( scriptInterface.ownerEntityID ));
  staminaCost *= staminaPenaltyMultiplier;
  staminaCost *= staminaFullChargePenaltyMultiplier;

  if( staminaCost > 0.0 )
  {
    PlayerStaminaHelpers.ModifyStamina( (scriptInterface.executionOwner as PlayerPuppet), ( 0.0 - staminaCost )  );
  }
}


// experimenting with this one
// Override("ShootEvents", "ConsumeStamina", function( self, scriptInterface, attackRecord, staminaPenaltyMultiplier, staminaFullChargePenaltyMultiplier ) -- returns void
//     local staminaCost = 0.0
//     local staminaCostMods = attackRecord:StaminaCost()

//     staminaCost = RPGManager.CalculateStatModifiers(staminaCostMods, scriptInterface.owner, scriptInterface.ownerEntityID )
//     staminaCost = staminaCost * staminaPenaltyMultiplier
// 		staminaCost = staminaCost * staminaFullChargePenaltyMultiplier
//     -- move the bellow statement to the aim OnExit
//     if StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, "FocusedCoolPerkSE" ) then
//         local statusEffectSystem = GameInstance.GetStatusEffectSystem()
//         local effects = statusEffectSystem:GetAppliedEffectsWithID( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedCoolPerkSE" )
//         for _, effect in ipairs(effects) do
//           statusEffectSystem:SetStatusEffectRemainingDuration( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedCoolPerkSE", effect:GetRemainingDuration() - 0.5)
//           GameInstance.GetStatusEffectSystem():ApplyStatusEffect( scriptInterface.executionOwnerEntityID, "BaseStatusEffect.FocusedDelayedStaminaConsumptionSE" )
//         end
//     end
//     if staminaCost > 0.0 then
//       PlayerStaminaHelpers.ModifyStamina( scriptInterface.executionOwner, -staminaCost)
//     end
//   end)


// apply new cost
// might want to make a seperate check for the reset duration, because I might want this to combo with Head to Head but not with quickscoping
@wrapMethod(AimingStateEvents)
protected func OnExit( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
{
  let focusGracePeriod : Float = 0.5;
  let FocusSE : ref<StatusEffect> = StatusEffectHelper.GetStatusEffectByID(scriptInterface.executionOwner, t"BaseStatusEffect.FocusedCoolPerkSE");
  if (!Equals(FocusSE, null))
  {
    if ( FocusSE.GetRemainingDuration() < (FocusSE.GetTotalDuration()-focusGracePeriod) )
    {
      // focus stamina discount removed. 
      PlayerStaminaHelpers.ModifyStamina( ( scriptInterface.executionOwner as PlayerPuppet ), (0.0 - TDB.GetFloat( t"NewPerks.Cool_Left_Milestone_2.focusedStaminaCost" ) ) );
    }
  }
  
  wrappedMethod(stateContext, scriptInterface);
}

// and the UI
// test whether this works actually.
@replaceMethod(StaminabarWidgetGameController)
protected cb func OnFocusedCoolPerkActive( evt : ref<FocusPerkTriggerd> ) -> Bool
{
}

// High Noon
// remove superfluous slomo
// this is done by "High Noon Reload No Slowmo" with perfect compatibility. Let's not rip code and make that a prereq.

// Run 'n' Gun
// lacking the knowledge to make a good way to make new DB based prereqs, this is a workaround.
// apply buff on equip
// do same check in trigger mode switch
@wrapMethod(AimingStateEvents)
public func OnItemEquipped( slot : TweakDBID, item : ItemID )
{
  wrappedMethod(slot, item);
  let applyCycleTimeBuff : Bool = true;
  // let scriptInterface : wref<StateGameScriptInterface> = GetGameInstance().GetScriptInterface();

  let gameInstance = GetGameInstance();
  let ts = GameInstance.GetTransactionSystem( gameInstance );
  let player = GetPlayer(gameInstance);

  if (PlayerDevelopmentSystem.GetData( player ).IsNewPerkBought( gamedataNewPerkType.Cool_Left_Milestone_3 ) < 2)
  {
      return;
  }

  if ( !ItemID.IsValid(item) )
  {
    return;
  }

  // without a clean way to get the item object from the item ID this is my best :(
  this.m_weapon = ts.GetItemInSlot( player, t"AttachmentSlots.WeaponRight" ) as WeaponObject;
  if ( !this.m_weapon.WeaponHasTag( n"RangedWeapon" ) )
  {
    return;
  }

  let triggerModes : array<ref<TriggerMode_Record>> = this.m_weapon.GetTriggerModes();
  // PrimaryTriggerMode() if I manage to check for swapped trigger modes

  if ( ArraySize(triggerModes)<=0 ) 
  {
    return;
  }

  for triggerMode in triggerModes
  {
    let triggerType = triggerMode.Type( );
      if (Equals(triggerType, gamedataTriggerMode.Burst) ||  Equals(triggerType, gamedataTriggerMode.FullAuto) )
      {
        applyCycleTimeBuff = false;
        StatusEffectHelper.RemoveStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
      }
  }


  if (applyCycleTimeBuff) 
  {
    StatusEffectHelper.ApplyStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
  }
}


// aaaand remove SE
@wrapMethod(AimingStateEvents)
public func OnItemUnequipped( slot : TweakDBID, item : ItemID )
{
  wrappedMethod(slot, item);

  let player = GetPlayer(GetGameInstance());
  if (StatusEffectSystem.ObjectHasStatusEffectWithTag( player, n"Deadeye_CycleTimeBuff" )) 
  {
    StatusEffectHelper.RemoveStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
  }
}

// Spontaneous Obliteration 
// we gotta remove the weapon type check in here
@replaceMethod(HitReactionComponent)
protected final func IsValidBodyPerkDismemberAttack( healthMissing : Float ) -> Bool
{
  let chanceByHealth : Float;
  let weaponType : gamedataItemType;
  chanceByHealth = 0.0;
  if( this.m_executeDismembered || this.m_invalidForExecuteDismember )
  {
    return false;
  }
  if( healthMissing < this.m_dismemberExecuteHealthRange.X )
  {
    return false;
  }
  if( this.m_ownerNPC.IsBoss() || Equals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac) )
  {
    return false;
  }
  if( ( this.m_attackData != null || Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Ranged ) ) || this.m_attackData.HasFlag( hitFlag.Explosion ) )
  {
    return false;
  }
  if( !( this.m_attackData.GetInstigator().IsPlayer() ) )
  {
    return false;
  }
  if( PlayerDevelopmentSystem.GetData( this.m_attackData.GetInstigator() ).IsNewPerkBought( gamedataNewPerkType.Body_Left_Milestone_3 ) < 3 )
  {
    return false;
  }
  if( this.m_attackData.GetWeapon() !=null )
  {
    return false;
  }
  weaponType = RPGManager.GetItemType( this.m_attackData.GetWeapon().GetItemID() );
  // removed weapon type check
  // if( ( ( weaponType != gamedataItemType.Wea_Shotgun && weaponType != gamedataItemType.Wea_ShotgunDual ) && weaponType != gamedataItemType.Wea_LightMachineGun ) && weaponType != gamedataItemType.Wea_HeavyMachineGun )
  // {
  // 	return false;
  // }
  chanceByHealth = this.m_statsSystem.GetStatValue( Cast<StatsObjectID>( this.m_attackData.GetInstigator().GetEntityID() ), gamedataStatType.ExecuteDismemberByHealthChance );
  if( chanceByHealth <= 0.0001 )
  {
    return false;
  }
  return true;
}

// Wreckingball 
// this should be the before "enter" condition
// gotta remove the weapon evolution check
@replaceMethod(SprintDecisions)
private static func IsWreckingBallAllowed( const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
  // boy whoever wrote that original check, respect but please make it easier on yourself next time.
  let executionOwner = scriptInterface.executionOwner;
  let isWreckingBallUnlocked : Bool = PlayerDevelopmentSystem.GetInstance( executionOwner ).IsNewPerkBought( executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) >= 2;
  let isWeaponMelee : Bool = WeaponObject.IsMelee( GameObject.GetActiveWeapon( executionOwner ).GetItemID() );
  let isStaminaEnough : Bool = scriptInterface.GetStatPoolsSystem().GetStatPoolValue( Cast<StatsObjectID>(executionOwner.GetEntityID()), gamedataStatPoolType.Stamina, true ) > 0.0;
  return ( (isWreckingBallUnlocked && isWeaponMelee) && isStaminaEnough );
}

// this the attack that plays on contact
// gotta replace the blunt check with melee check
@replaceMethod(MeleeBodySlamAttackDecisions)
protected const func EnterCondition( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
  if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) < 2 )
  {
    return false;
  }
  // changed IsBlunt to IsMelee
  if( !( WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ).GetItemID() ) ) )
  // changes end
  {
    return false;
  }
  if( !( this.IsBlockHeld( stateContext, scriptInterface ) ) )
  {
    return false;
  }
  if( !( stateContext.IsStateActive( n"Locomotion", n"sprint" ) ) )
  {
    return false;
  }
  if( scriptInterface.GetStatPoolsSystem().GetStatPoolValue( Cast<StatsObjectID>(scriptInterface.executionOwner.GetEntityID()), gamedataStatPoolType.Stamina, true ) <= 0.0 )
  {
    return false;
  }
  return true;
}

// this should be the "continue running" condition?
@replaceMethod(MeleeTransition)
public static func MeleeSprintStateCondition( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
  // ok if this is the continue condition, then why are we checking whether the player is blocking to return on missing prereqs?
  // like... if we aint blocking we continue?
  // is this the check for regular spriting?
  let isPlayerBlocking : Bool = Equals( scriptInterface.localBlackboard.GetInt( GetAllBlackboardDefs().PlayerStateMachine.Melee ), Cast<Int32>(EnumValueFromName(n"gamePSMMelee", n"Block")));
  let isPerkBought : Bool = ( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Body_Right_Milestone_2 ) >= 2  );
  // ..IsBlunt(...) function call replaced with ..IsMelee(...)
  let isWeaponMelee : Bool = ( WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ).GetItemID() ) );
  let isStaminaEnough : Bool = scriptInterface.GetStatPoolsSystem().GetStatPoolValue( Cast<StatsObjectID>(scriptInterface.executionOwner.GetEntityID()), gamedataStatPoolType.Stamina, true ) > 0.0;
  if( isPlayerBlocking && ( ( !isPerkBought || !isWeaponMelee ) || !isStaminaEnough ) )
  {
    return false;
  }
  if( !( stateContext.GetBoolParameter( n"canSprintWhileCharging", true ) ) && Equals(stateContext.GetStateMachineCurrentState( n"Melee" ), n"meleeChargedHold") )
  {
    return false;
  }
  if( stateContext.GetBoolParameter( n"isAttacking", true ) && !( stateContext.IsStateActive( n"Melee", n"meleeBodySlamAttack" ) ) )
  {
    return false;
  }
  return true;
}


//Quake
@replaceMethod(MeleeGroundSlamAttackDecisions)
protected const func EnterCondition( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
  if( scriptInterface.IsOnGround() )
  {
    if( !( scriptInterface.GetStatsSystem().GetStatBoolValue( Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID), gamedataStatType.CanGroundSlamOnGround ) ) )
    {
      return false;
    }
  }
  else
  {
    if( !( scriptInterface.GetStatsSystem().GetStatBoolValue( Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID), gamedataStatType.CanGroundSlamInAir ) ) )
    {
      return false;
    }
  }
  if( !( MeleeTransition.WantsToQuickMelee( stateContext, scriptInterface ) ) )
  {
    return false;
  }
  // bellow: changed ..IsBlunt(...) to ..IsMelee(...)
  if( !( WeaponObject.IsMelee( GameObject.GetActiveWeapon( scriptInterface.executionOwner ).GetItemID() ) ) )
  {
    return false;
  }
  if( StatusEffectSystem.ObjectHasStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.GroundSlamCooldown" ) )
  {
    stateContext.SetConditionBoolParameter( n"QuickMeleeAttackTapped", false, true );
    return false;
  }
  if( !( this.IsValidLocomotionState( stateContext.GetStateMachineCurrentState( n"Locomotion" ) ) ) )
  {
    return false;
  }
  if( !( this.CanFit( scriptInterface ) ) )
  {
    return false;
  }
  if( scriptInterface.localBlackboard.GetBool( GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideMovingElevator ) )
  {
    return false;
  }
  return true;
}

// Lead and Steel
@replaceMethod(DamageManager)
private static func CanBlockBullet( hitEvent : ref<gameHitEvent> ) -> Bool
{
  let defenderWeapon : ref<WeaponObject>;
  let cameraForward : Vector4;
  defenderWeapon = GameObject.GetActiveWeapon( hitEvent.target );
  if( defenderWeapon == null )
  {
    return false;
  }
  // changed ..IsBlade(...) to ..IsMelee(...)
  if( !( defenderWeapon.IsMelee() ) )
  {
    return false;
  }
  if( !( AttackData.IsRangedOnly( hitEvent.attackData.GetAttackType() ) ) )
  {
    return false;
  }
  if( PlayerDevelopmentSystem.GetData( hitEvent.target ).IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 ) < 2 )
  {
    return false;
  }
  cameraForward = GameInstance.GetCameraSystem( hitEvent.target.GetGame() ).GetActiveCameraForward();
  if( !( DamageManager.IsValidDirectionToDefendMeleeAttack( hitEvent.hitDirection, cameraForward ) ) )
  {
    return false;
  }
  if( AbsF( Vector4.GetAngleDegAroundAxis( hitEvent.target.GetWorldForward(), cameraForward, hitEvent.target.GetWorldUp() ) ) > TDB.GetFloat( t"player.melee.maxLookbackDefendAngle" ) )
  {
    return false;
  }
  return true;
}

@replaceMethod(DamageSystem)
private func ProcessBulletBlockAndDeflect( hitEvent : ref<gameHitEvent> )
{
  let blockingItem : wref< ItemObject >;
  let attackingItem : wref< ItemObject >;
  let statsSystem : ref<StatsSystem>;
  let statPoolsSystem : ref<StatPoolsSystem>;
  let currentStamina : Float;
  let newStamina : Float;
  let staminaReduction : Float;
  let targetID : StatsObjectID;
  let playerTarget : ref<PlayerPuppet>;
  let computedDamageFactor : Float;
  let meleeCostToBlock : Float;
  let isBulletTimeActive : Bool;
  let isDeflect : Bool;
  let playerDevelopmentData : ref<PlayerDevelopmentData>;
  let perkLevel : Int32;
  let i : Int32;
  let originalDamages : array< Float >;
  let totalOriginalDamage : Float;
  let playerMaxHealth : Float;
  let damagePerc : Float;
  let maxStaminaDamagePerc : Float;
  computedDamageFactor = 1.0;
  if( !( hitEvent.attackData.WasBulletBlocked() || hitEvent.attackData.WasBulletDeflected() ) )
  {
    return;
  }
  blockingItem = GameInstance.GetTransactionSystem( hitEvent.target.GetGame() ).GetItemInSlot( hitEvent.target, t"AttachmentSlots.WeaponRight" );
  attackingItem = hitEvent.attackData.GetWeapon();
  if( blockingItem == null || attackingItem == null )
  {
    return;
  }
  playerTarget = hitEvent.target as PlayerPuppet ;
  if( playerTarget == null )
  {
    return;
  }
  playerDevelopmentData = PlayerDevelopmentSystem.GetData( playerTarget );
  perkLevel = playerDevelopmentData.IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Milestone_2 );
  if( perkLevel < 2 )
  {
    return;
  }
  // changed ..IsBlade(...) to ..IsMelee(...)
  if( !(blockingItem as WeaponObject).IsMelee() )
  {
    return;
  }
  computedDamageFactor = 0.0;
  statsSystem = GameInstance.GetStatsSystem( playerTarget.GetGame() );
  statPoolsSystem = GameInstance.GetStatPoolsSystem( playerTarget.GetGame() );
  targetID = Cast<StatsObjectID>(playerTarget.GetEntityID());
  currentStamina = statPoolsSystem.GetStatPoolValue( Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Stamina, false );
  isBulletTimeActive = ( playerDevelopmentData.IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_3 ) > 0 ) && GameInstance.GetTimeSystem( playerTarget.GetGame() ).IsTimeDilationActive();
  if( !( isBulletTimeActive ) )
  {
    meleeCostToBlock = statsSystem.GetStatValue( Cast<StatsObjectID>(blockingItem.GetEntityID()), gamedataStatType.StaminaCostToBlock );
    staminaReduction = meleeCostToBlock / 2.0;
    totalOriginalDamage = 0.0;
    originalDamages = hitEvent.attackComputed.GetOriginalAttackValues();
    for originalDamage in originalDamages
    {
      totalOriginalDamage += originalDamage;
    }
    playerMaxHealth = GameInstance.GetStatsSystem( playerTarget.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerTarget.GetEntityID()), gamedataStatType.Health );
    if( playerMaxHealth > 0.0 )
    {
      damagePerc = totalOriginalDamage / playerMaxHealth;
      maxStaminaDamagePerc = 0.5;
      if( damagePerc < maxStaminaDamagePerc )
      {
        staminaReduction *= MaxF( 0.2, damagePerc / maxStaminaDamagePerc );
      }
    }
    newStamina = MaxF( currentStamina - staminaReduction, 0.0 );
    if( newStamina <= 0.0 )
    {
      computedDamageFactor = TDB.GetFloat( t"Constants.DamageSystem.blockBreakPlayerDamageFactor" );
    }
    PlayerStaminaHelpers.ModifyStamina( playerTarget, ( 0.0- staminaReduction ) );
    PlayerStaminaHelpers.OnPlayerBlock( playerTarget );
  }
  if( computedDamageFactor != 1.0 )
  {
    hitEvent.attackComputed.MultAttackValue( computedDamageFactor );
  }
  isDeflect = ( hitEvent.attackData.HasFlag( hitFlag.WasBulletDeflected ) && ( playerDevelopmentData.IsNewPerkBought( gamedataNewPerkType.Reflexes_Right_Perk_2_1 ) > 0 ) ) && ( currentStamina > ( statsSystem.GetStatValue( targetID, gamedataStatType.Stamina ) * statsSystem.GetStatValue( targetID, gamedataStatType.Reflexes_Right_Milestone_2_StaminaDeflectPerc ) ) );
  if( hitEvent.attackData.HasFlag( hitFlag.WasBulletParried ) || isDeflect )
  {
    this.ProcessBulletDeflect( hitEvent, isBulletTimeActive, blockingItem );
  }
  else
  {
    GameObject.PlaySound( playerTarget, n"w_perk_lead_and_steel" );
  }
}

// Finishers

// Finisher Reward aka healing
@replaceMethod(FinisherEndEvents)
public static func ApplyFinisherBuffs( playerPuppet : wref< PlayerPuppet >, isWorkspotFinisher : Bool )
{
  let weapon : ref<WeaponObject>;
  if( playerPuppet == null )
  {
    return;
  }
  weapon = GameObject.GetActiveWeapon( playerPuppet );
  StatusEffectHelper.RemoveStatusEffect( playerPuppet, t"BaseStatusEffect.BlockFinisherStatusEffect" );
  StatusEffectHelper.RemoveStatusEffect( playerPuppet, t"BaseStatusEffect.PlayerInFinisherWorkspot" );
  if( isWorkspotFinisher )
  {
    StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.BlockWorkspotFinisherStatusEffect", playerPuppet.GetEntityID() );
  }
  StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Finisher_Healing_Buff", playerPuppet.GetEntityID() );
  if( weapon.IsMantisBlades() && ( PlayerDevelopmentSystem.GetData( playerPuppet ).IsNewPerkBought( gamedataNewPerkType.Espionage_Central_Milestone_1 ) > 0 ) )
  {
    StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Espionage_Central_Milestone_1_Buff_MantisBlades" );
  }
  // replaced ..IsBlade(...) check with ..IsMelee(...)
  // this makes the healing buff universal to melee weapons
  if( weapon.IsMelee() && PlayerDevelopmentSystem.GetData( playerPuppet ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_1 ) )
  {
    StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Reflexes_Right_Perk_3_1_Buff_Level_1", playerPuppet.GetEntityID() );
  }
}

// Going The Distance
// finisher range

// Throwable
@replaceMethod(NewPerkFinisherCondition)
protected const func NewPerkFinisherThrowableEnabled( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject >, equippedWeapon : ref< WeaponObject >  ) -> Bool
{
  let statsSystem : ref<StatsSystem>;
  let minDistance : Float;
  let distanceFromHotspot : Float;
  statsSystem = GameInstance.GetStatsSystem( activatorObject.GetGame() );
  distanceFromHotspot = Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() );
  minDistance = statsSystem.GetStatValue( Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherCool_TargetDistanceMax );
  // added Going The Distance bonus here
  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) )
  {
    minDistance = minDistance * TweakDBInterface.GetFloat( t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 );
  }
  // end of mod code
  // line bellow is for Pounce (Cool_Inbetween_Right_3). This should be universally applicable
  minDistance += ( TweakDBInterface.GetFloat( t"NewPerks.Cool_Inbetween_Right_3.distanceBase", 5.0 ) * ClampF( GameInstance.GetStatsSystem( hotSpotObject.GetGame() ).GetStatValue( Cast<StatsObjectID>( hotSpotObject.GetEntityID() ), gamedataStatType.Cool_Inbetween_Right_3_Stacks ), 0.0, TweakDBInterface.GetFloat( t"NewPerks.Cool_Inbetween_Right_3.distanceMaxStacks", 3.0 ) ) );
  if( distanceFromHotspot > minDistance )
  {
    return false;
  }
  return true;
}

// monowire, interestingly has it's own finisher conditions
@replaceMethod(NewPerkFinisherCondition)
protected const func NewPerkFinisherMonowireEnabled( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject >, equippedWeapon : ref< WeaponObject >  ) -> Bool
{
  let statsSystem : ref<StatsSystem>;
  let minDistance : Float;
  let distanceFromHotspot : Float;
  statsSystem = GameInstance.GetStatsSystem( activatorObject.GetGame() );
  distanceFromHotspot = Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() );
  minDistance = statsSystem.GetStatValue( Cast<StatsObjectID>( activatorObject.GetEntityID() ), gamedataStatType.NewPerkFinisherMonowire_TargetDistanceMax );
  // added Going The Distance bonus here
  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) )
  {
    minDistance = minDistance * TweakDBInterface.GetFloat( t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 );
  }
  // end of mod code
  // Line bellow is per quickhack queued distance bonus
  // we can isolate this and make it universal
  minDistance += ( TweakDBInterface.GetFloat( t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 3.0 ) * Cast<Float>( (hotSpotObject as ScriptedPuppet).GetDeviceActionQueueSize() ) );  if( distanceFromHotspot > minDistance )
  {
    return false;
  }
  return true;
}


// Blunt
@replaceMethod(NewPerkFinisherCondition)
protected const func NewPerkFinisherBluntEnabled( const activatorObject : wref<GameObject>, const hotSpotObject : wref< GameObject >, const equippedWeapon : ref< WeaponObject > ) -> Bool
{
  let statsSystem : ref<StatsSystem>;
  let targetDistanceMax : Float;
  statsSystem = GameInstance.GetStatsSystem( activatorObject.GetGame() );
  targetDistanceMax = statsSystem.GetStatValue( Cast<StatsObjectID>( activatorObject.GetEntityID() ), gamedataStatType.NewPerkFinisherBlunt_TargetDistanceMax );
  // added Going The Distance bonus here
  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) )
  {
    targetDistanceMax = targetDistanceMax * TweakDBInterface.GetFloat( t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 );
  }
  // end of mod code
  if( Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() ) > targetDistanceMax )
  {
    return false;
  }

  return true;
}

// Blade Finishers
// yet unused
// @replaceMethod(NewPerkFinisherCondition)
// protected const function NewPerkFinisherBladeEnabled( const activatorObject : weak< GameObject >, const hotSpotObject : weak< GameObject >, equippedWeapon : WeaponObject ) : Bool
// {
//   var statsSystem : StatsSystem;
//   var minDistance : Float;
//   var distanceFromHotspot : Float;
//   statsSystem = GameInstance.GetStatsSystem( activatorObject.GetGame() );
//   distanceFromHotspot = Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() );
//   minDistance = statsSystem.GetStatValue( activatorObject.GetEntityID(), gamedataStatType.NewPerkFinisherReflexes_TargetDistanceMax );
//   if( PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) )
//   {
//     minDistance *= TweakDBInterface.GetFloat( T"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 );
//   }
//   return distanceFromHotspot < minDistance;
// }

// to make Quickhack Queue increase of Finisher: Live Wire (Monowire, Intelligence_Left_Perk_3_4) apply to all
@replaceMethod(GameObject)
public const func IsInFinisherHealthThreshold( playerPuppet : wref< GameObject > ) -> Bool
{

  let currentHealthPercentage : Float;
  let finisherHealthTrigger : Float;
  let finisherHealthClamp : Float;
  let equippedWeapon : ref<WeaponObject>;
  let thresholdPerQueue : Float;
  if( playerPuppet == null )
  {

    return false;
  }
  if( this.BlockFinisherThreshold() )
  {
    return false;
  }
  equippedWeapon = GameObject.GetActiveWeapon( playerPuppet );
  // moved check here because universal
  // might crash if perk not unlocked
  thresholdPerQueue = QuickHackableQueueHelper.GetFinisherHealthThresholdIncreaseForQueue( playerPuppet, this );
  // added check for yeet finisher perk
  if( IsSavageSlingUnlocked(playerPuppet) || equippedWeapon.WeaponHasTag( n"Throwable" ) || equippedWeapon.IsBlade() || equippedWeapon.IsMonowire() || equippedWeapon.IsBlunt())
  {
    finisherHealthTrigger = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherBlunt_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) + thresholdPerQueue;
  }
  finisherHealthClamp = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.Finisher_TargetHealthMax_Clamp );
  if( finisherHealthClamp > 0.0 )
  {
    finisherHealthTrigger = ClampF( finisherHealthTrigger, 0.0, finisherHealthClamp );
  }
  currentHealthPercentage = GameInstance.GetStatPoolsSystem( this.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatPoolType.Health, true );

  return currentHealthPercentage <= finisherHealthTrigger;
}

// now to make Savage Sling Universal
@replaceMethod(ScriptedPuppet)
private func ProcessNewPerkFinisherLayer( evt : ref<InteractionChoiceEvent>, playerPuppet : ref<PlayerPuppet>, npcPuppet : ref<NPCPuppet> )
{
  if(  playerPuppet == null || npcPuppet == null )
  {
    return;
  }
  if( !( playerPuppet.HasFinisherAvailable() ) )
  {
    return;
  }
  // add the new interaction to the check that acts on the NPC
  let isFinisherBluntHold : Bool = evt.choice.choiceMetaData.tweakDBID == t"Interactions.NewPerkFinisherBluntHold";
  if isFinisherBluntHold
  {
  }
  let isNewSavageSling : Bool = evt.choice.choiceMetaData.tweakDBID == t"Interactions.NewSavageSlingFinisher";
  if isNewSavageSling
  {
  }
  if( isFinisherBluntHold || isNewSavageSling )
  {
    this.TriggerNewPerkFinisherBluntHold( playerPuppet, npcPuppet );
  }
  else
  {
    this.TriggerNewPerkFinisher( evt, playerPuppet );
  }
}

// add to check whether availib
@replaceMethod(GameObject)
public func HasFinisherAvailable() -> Bool
{
  let statsSystem : ref<StatsSystem>;
  let weapon : ref<WeaponObject>;
  statsSystem = GameInstance.GetStatsSystem( this.GetGame() );
  weapon = GameObject.GetActiveWeapon( this );
  let savageSlingAvalible : Bool = IsSavageSlingUnlocked( this );
  let regularFinisherAvalible : Bool =
  ( 
    (
      (
          statsSystem.GetStatBoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.CanPerformReflexFinisher ) && weapon.IsBlade() 
      ) 
      || 
      ( 
        statsSystem.GetStatBoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.CanPerformBluntFinisher ) && weapon.IsBlunt() 
      ) 
    ) 
    || 
    ( 
      statsSystem.GetStatBoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.CanPerformCoolFinisher ) && weapon.IsThrowable() 
    ) 
  ) 
  || 
  ( 
    statsSystem.GetStatBoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.CanPerformMonowireFinisher ) && weapon.IsMonowire() 
  );
  return (savageSlingAvalible || regularFinisherAvalible);
}

@wrapMethod(NewPerkFinisherCondition)
public const func Test( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject > ) -> Bool
{
  let vanillaOutput : Bool = wrappedMethod(activatorObject, hotSpotObject);

	let targetPuppet : wref< ScriptedPuppet > = hotSpotObject as ScriptedPuppet;
  let equippedWeapon : ref< WeaponObject > = GameObject.GetActiveWeapon( activatorObject );
  if ( targetPuppet == null ) 
  {
    return false;
  }
  if (IsSavageSlingUnlocked(activatorObject))
  {
    let isFinisherAvailable : Bool = this.IsFinisherAvailable( activatorObject, hotSpotObject);
    let finisherEnabled : Bool = this.NewPerkFinisherBluntEnabled( activatorObject, hotSpotObject, equippedWeapon );
    if isFinisherAvailable  && finisherEnabled
    {
      if( !( targetPuppet.IsFinisherSoundPlayed() ) && !( hotSpotObject.GetIsInFastFinisher() ) )
      {
        GameObject.PlaySound( activatorObject, n"w_melee_perk_finisher_ready" );
        targetPuppet.SetFinisherSoundPlayed( true );
      }
      return this.IsAreaClear( activatorObject, hotSpotObject );
    }
  }
  return vanillaOutput;
} 



private func IsSavageSlingUnlocked(player : ref<GameObject>) -> Bool
{
  return PlayerDevelopmentSystem.GetInstance( player ).IsNewPerkBought( player, gamedataNewPerkType.Body_Master_Perk_5 ) >= 1;
}

// // pure Logging
// @replaceMethod(NewPerkFinisherCondition)
// private const func IsFinisherAvailable( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject > ) -> Bool
// {
//   let isInPoiseState : Bool;
//   let isInThreshold : Bool;
//   isInPoiseState = StatusEffectSystem.ObjectHasStatusEffect( hotSpotObject, t"BaseStatusEffect.FinisherActiveStatusEffect" );
//   if (isInPoiseState)
//   {
//     LogChannel(n"DEBUG", "IsFinisherAvailable: isInPoiseState was true");
//   }
//   isInThreshold = hotSpotObject.IsInFinisherHealthThreshold( activatorObject );
//   if (isInThreshold)
//   {
//     LogChannel(n"DEBUG", "IsFinisherAvailable: isInThreshold was true");
//   }
//   if( !( isInPoiseState ) && !( isInThreshold ) )
//   {
//     LogChannel(n"DEBUG", "IsFinisherAvailable: Returning False");
//     return false;
//   }
//   LogChannel(n"DEBUG", "IsFinisherAvailable: Returning True");
//   return true;
// }