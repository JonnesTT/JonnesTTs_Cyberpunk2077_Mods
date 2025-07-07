import PerksApplyToMore.CommonFunctions.IsSharpshooterBleed

// Spontaneous Obliteration 
// we gotta remove the weapon type check in here
@replaceMethod(HitReactionComponent)
protected final func IsValidBodyPerkDismemberAttack( healthMissing : Float ) -> Bool
{
  // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack: Checking whether attack can Spontaneously Obliterate");
  let chanceByHealth : Float;
  let weaponType : gamedataItemType;
  chanceByHealth = 0.0;
  if( this.m_executeDismembered || this.m_invalidForExecuteDismember )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: m_executeDismembered or m_invalidForExecuteDismember were false");
    return false;
  }
  if( healthMissing < this.m_dismemberExecuteHealthRange.X )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: healthMissing < this.m_dismemberExecuteHealthRange");

    return false;
  }
  if( this.m_ownerNPC.IsBoss() || Equals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac) )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: enemy too rare");

    return false;
  }
  // added (X && !IsSharpshooterBleed) around ranged attack check
  if( this.m_attackData == null || this.m_attackData.HasFlag( hitFlag.Explosion ) )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: attack was ranged or something");
    return false;
  }
  if( !Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Ranged ) && !IsSharpshooterBleed(this.m_attackData) )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: attack was neither ranged nor bleed");
    return false;
  }
  if( !( this.m_attackData.GetInstigator().IsPlayer() ) )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: instigator wasn't player");
    return false;
  }
  if( PlayerDevelopmentSystem.GetData( this.m_attackData.GetInstigator() ).IsNewPerkBought( gamedataNewPerkType.Body_Left_Milestone_3 ) < 2 )
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: Body_Left_Milestone_3 wasn't maxed out");
    return false;
  }
  // added check to make sure we only throw dots out that aren't the sharpshooter bleed
  if( this.m_attackData.GetWeapon() == null && !IsSharpshooterBleed(this.m_attackData))
  {
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: weapon couldn't be got");
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
    // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack returns false reason: chance by health ≈0");
    return false;
  }
  // LogChannel(n"DEBUG", "IsValidBodyPerkDismemberAttack: IDed attack as valid");
  return true;
}


@wrapMethod(GameObject)
public func ReactToHitProcess( hitEvent : ref<gameHitEvent> )
{
  // LogChannel(n"DEBUG", "ReactToHitProcess: running");
  wrappedMethod(hitEvent);
  if (!IsSharpshooterBleed(hitEvent.attackData))
  {
    // LogChannel(n"DEBUG", "ReactToHitProcess: returning wasn't SharpshooterBleed");
    return;
  }
  let target = this as NPCPuppet;
  if( target == null )
  {
    // LogChannel(n"DEBUG", "ReactToHitProcess: target wasn't an NPC");
    return;
  }

  let healthMissingAfterAttack = GameInstance.GetStatPoolsSystem( target.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>(target.GetEntityID()), gamedataStatPoolType.Health, false ) - target.GetTotalFrameDamage();
  healthMissingAfterAttack = 1.0 - ClampF( healthMissingAfterAttack / GameInstance.GetStatsSystem( target.GetGame() ).GetStatValue( Cast<StatsObjectID>( target.GetEntityID() ), gamedataStatType.Health ), 0.0, 1.0 );
  if( target.m_hitReactionComponent.IsValidBodyPerkDismemberAttack( healthMissingAfterAttack ) )
  {
    // LogChannel(n"DEBUG", "ReactToHitProcess: target was valid for dismemberment");
    if( target.m_hitReactionComponent.TryTriggerBodyPerkDismembement( healthMissingAfterAttack ) )
    {
      target.m_hitReactionComponent.ProcessBodyPerkDismembement();
      // LogChannel(n"DEBUG", "ReactToHitProcess: DismembermentProcessed");
      return;
    }
  }
}

// // pure logging
// @wrapMethod(HitReactionComponent)
// public func EvaluateHit( newHitEvent : ref<gameHitEvent> )
// {
//   LogChannel(n"DEBUG", "EvaluateHit: HitEvent was ");
//   if (newHitEvent.attackData.HasFlag(hitFlag.DamageOverTime))
//   {
//     LogChannel(n"DEBUG", "EvaluateHit: was dot ");
//   }
//   else
//   {
//     LogChannel(n"DEBUG", "EvaluateHit: wasn't dot ");
//   }
//   wrappedMethod( newHitEvent );
// }
