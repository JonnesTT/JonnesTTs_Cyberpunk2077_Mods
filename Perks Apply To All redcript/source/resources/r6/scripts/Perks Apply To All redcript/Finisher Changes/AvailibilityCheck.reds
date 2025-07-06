import PerksApplyToMore.CommonFunctions.IsSavageSlingUnlocked


// add new savage sling to availability check
@replaceMethod(GameObject)
public func HasFinisherAvailable() -> Bool
{
  // LogChannel(n"DEBUG", "HasFinisherAvailable running.");

  let statsSystem : ref<StatsSystem>;
  let weapon : ref<WeaponObject>;
  statsSystem = GameInstance.GetStatsSystem( this.GetGame() );
  weapon = GameObject.GetActiveWeapon( this );
  let isSavageSlingAvalible : Bool = IsSavageSlingUnlocked( this );
  let isRegularFinisherAvalible : Bool =
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
  
  // LogChannel(n"DEBUG", "HasFinisherAvailable returning.");

  return ( isSavageSlingAvalible || isRegularFinisherAvalible);
}
