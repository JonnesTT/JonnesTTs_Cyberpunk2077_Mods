

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