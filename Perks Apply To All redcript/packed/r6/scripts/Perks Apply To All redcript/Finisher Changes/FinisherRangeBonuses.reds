
// finisher range
// So far done: Reflexes_3_4 Going The Distance applied to all finishers
// Cool_Inbetween_Right_3 Pounce applied to all finishers

private func ApplyFinisherRangeBonuses(activatorObject : wref< GameObject >, hotSpotObject : wref< GameObject >, distance : Float) -> Float
{
  // LogChannel(n"DEBUG", "ApplyFinisherRangeBonuses: Running from " + distance);


  // added Pounce (Cool_Inbetween_Right_3) distance bonus. 
  // I've moved the addatives first so it multiplies by "Going The Distance" to maximise possible inter-action between perks
 
  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Cool_Inbetween_Right_3 ) )
  {
    distance += ( TweakDBInterface.GetFloat( t"NewPerks.Cool_Inbetween_Right_3.distanceBase", 5.0 ) * ClampF( GameInstance.GetStatsSystem( hotSpotObject.GetGame() ).GetStatValue( Cast<StatsObjectID>( hotSpotObject.GetEntityID() ), gamedataStatType.Cool_Inbetween_Right_3_Stacks ), 0.0, TweakDBInterface.GetFloat( t"NewPerks.Cool_Inbetween_Right_3.distanceMaxStacks", 3.0 ) ) );
  }

  // Line bellow is per quickhack queued distance bonus. It seems to multiply the multiplier from Going The Distance for some reason.

  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Intelligence_Left_Perk_3_4 ) )
  {
    // in vanilla used the distance mult of Reflexes_Right_Perk_3_4
    distance += ( TweakDBInterface.GetFloat( t"NewPerks.Intelligence_Left_Perk_3_4.distanceMult", 3.0 ) * Cast<Float>( (hotSpotObject as ScriptedPuppet).GetDeviceActionQueueSize() ) );  
  }

  // added Reflexes_3_4 Going The Distance range bonus here 
  if (PlayerDevelopmentSystem.GetData( activatorObject ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_4 ) )
  {
    distance *=  TweakDBInterface.GetFloat( t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.0 );
  }
  
  
  // LogChannel(n"DEBUG", "ApplyFinisherRangeBonuses: Returning with " + distance );

  return distance;

}


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
  // replaced individual range extension with all range extensions
  minDistance = ApplyFinisherRangeBonuses(activatorObject, hotSpotObject, minDistance);
  // end of mod code
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
  // replaced individual range extension with all range extensions
  minDistance = ApplyFinisherRangeBonuses(activatorObject, hotSpotObject, minDistance);
  // end of mod code  
  if( distanceFromHotspot > minDistance )
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
  // replaced individual range extension with all range extensions
  // LogChannel(n"DEBUG", "NewPerkFinisherBluntEnabled: calling ApplyFinisherRangeBonuses with a distance of:" + targetDistanceMax);
  targetDistanceMax = ApplyFinisherRangeBonuses(activatorObject, hotSpotObject, targetDistanceMax);
  // end of mod code
  if( Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() ) > targetDistanceMax )
  {
    return false;
  }

  return true;
}

// Blade Finishers
@replaceMethod(NewPerkFinisherCondition)
protected const func NewPerkFinisherBladeEnabled( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject >, equippedWeapon : ref< WeaponObject > ) -> Bool
{
  let statsSystem : ref<StatsSystem>;
  let minDistance : Float;
  let distanceFromHotspot : Float;
  statsSystem = GameInstance.GetStatsSystem( activatorObject.GetGame() );
  distanceFromHotspot = Vector4.Length2D( hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition() );
  minDistance = statsSystem.GetStatValue( Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherReflexes_TargetDistanceMax );
  // replaced individual range extension with all range extensions
  // LogChannel(n"DEBUG", "NewPerkFinisherBladeEnabled: calling ApplyFinisherRangeBonuses with a distance of:" + minDistance);
  minDistance = ApplyFinisherRangeBonuses(activatorObject, hotSpotObject, minDistance);
  // end of mod code
  return distanceFromHotspot < minDistance;
}
