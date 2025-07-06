
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
