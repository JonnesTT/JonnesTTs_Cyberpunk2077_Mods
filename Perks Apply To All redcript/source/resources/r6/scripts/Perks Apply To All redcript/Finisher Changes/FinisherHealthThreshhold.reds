import PerksApplyToMore.CommonFunctions.IsSavageSlingUnlocked

// to make Quickhack Queue increase of Intelligence_Left_Perk_3_4 Live Wire (Monowire) apply to all
// make sure we have a health thresshold to use when only yeet finisher is unlocked
@replaceMethod(GameObject)
public const func IsInFinisherHealthThreshold( playerPuppet : wref< GameObject > ) -> Bool
{
  // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold running.");

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
  

  if( equippedWeapon.WeaponHasTag( n"Throwable" ) )
  {
    // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold: Weapon had Tag 'throwable'.");
    finisherHealthTrigger = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherCool_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) + thresholdPerQueue;
  }
  else if( equippedWeapon.IsBlade() )
  {
    // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold: Weapon was blade.");
    finisherHealthTrigger = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherReflexes_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) + thresholdPerQueue;
  }
  else if( equippedWeapon.IsMonowire() )
  {
    // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold: Weapon was Monowire.");

    finisherHealthTrigger = ( GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherMonowire_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) ) + thresholdPerQueue;
  }
  else if( equippedWeapon.IsBlunt() )
  {
    // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold: Weapon was Blunt.");
    finisherHealthTrigger = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherBlunt_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) + thresholdPerQueue;
  }
  // bit of a weird interaction. So, we HAVE TO inherit the range from the equipped weapons into savage sling while they are equipped unless I recode more of this.
  // I don't see a big problem with that atm. Especially considering I'd have to goof around with the Takedown (ObjectAction) definitions again to make that work smoothly but it is a concession I make here.
  else if( IsSavageSlingUnlocked(playerPuppet) )
  {
    // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold: No weapon but Savage Sling detected.");
    finisherHealthTrigger = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>(playerPuppet.GetEntityID()), gamedataStatType.NewPerkFinisherBlunt_TargetHealthMax ) + GameObject.GetFinisherHealthThresholdIncrease( this, playerPuppet ) + thresholdPerQueue;
  }


  finisherHealthClamp = GameInstance.GetStatsSystem( this.GetGame() ).GetStatValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatType.Finisher_TargetHealthMax_Clamp );
  if( finisherHealthClamp > 0.0 )
  {
    finisherHealthTrigger = ClampF( finisherHealthTrigger, 0.0, finisherHealthClamp );
  }
  currentHealthPercentage = GameInstance.GetStatPoolsSystem( this.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>( this.GetEntityID() ), gamedataStatPoolType.Health, true );
  
  // LogChannel(n"DEBUG", "IsInFinisherHealthThreshold returning.");

  return currentHealthPercentage <= finisherHealthTrigger;
}