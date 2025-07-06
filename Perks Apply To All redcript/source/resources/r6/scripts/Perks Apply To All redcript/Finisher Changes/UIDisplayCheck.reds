import PerksApplyToMore.CommonFunctions.IsSavageSlingUnlocked

@wrapMethod(NewPerkFinisherCondition)
public const func Test( const activatorObject : wref< GameObject >, const hotSpotObject : wref< GameObject > ) -> Bool
{
  // LogChannel(n"DEBUG", "Test Wrapper: Running.");
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
    if isFinisherAvailable
    {
      // LogChannel(n"DEBUG", "Test Wrapper: a finisher was available");
      if finisherEnabled
      {
        // LogChannel(n"DEBUG", "Test Wrapper: it was the modded one! :D");
        if( !( targetPuppet.IsFinisherSoundPlayed() ) && !( hotSpotObject.GetIsInFastFinisher() ) )
        {
          GameObject.PlaySound( activatorObject, n"w_melee_perk_finisher_ready" );
          targetPuppet.SetFinisherSoundPlayed( true );
        }
        // LogChannel(n"DEBUG", "Test Wrapper: returning modded output as: " +this.IsAreaClear( activatorObject, hotSpotObject ));
        return this.IsAreaClear( activatorObject, hotSpotObject );
      }
    }
  }
  // LogChannel(n"DEBUG", "Test Wrapper: returning vanilla output as: " +vanillaOutput);
  return vanillaOutput;
} 