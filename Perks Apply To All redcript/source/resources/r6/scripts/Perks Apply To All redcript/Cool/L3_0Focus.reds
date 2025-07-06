
// the applicator
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


// remove the "locked stamina bar" UI (might reuse later)
@replaceMethod(StaminabarWidgetGameController)
protected cb func OnFocusedCoolPerkActive( evt : ref<FocusPerkTriggerd> ) -> Bool
{
}