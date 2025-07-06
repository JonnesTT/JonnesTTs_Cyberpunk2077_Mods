
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
