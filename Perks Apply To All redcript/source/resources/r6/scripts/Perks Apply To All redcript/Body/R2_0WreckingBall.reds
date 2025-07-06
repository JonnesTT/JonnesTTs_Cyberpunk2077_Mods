
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
