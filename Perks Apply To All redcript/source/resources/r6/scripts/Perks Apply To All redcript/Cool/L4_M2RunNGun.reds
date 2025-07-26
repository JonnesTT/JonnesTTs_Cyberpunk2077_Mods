
// Run 'n' Gun
// need to apply the lvl 1 firerate bonus somehow
// lacking the knowledge to make a good way to make new DB based prereqs, this is a workaround.
// apply buff on equip
// do same check in trigger mode switch
@wrapMethod(AimingStateEvents)
public func OnItemEquipped( slot : TweakDBID, item : ItemID )
{
  wrappedMethod(slot, item);
  let applyCycleTimeBuff : Bool = true;
  // let scriptInterface : wref<StateGameScriptInterface> = GetGameInstance().GetScriptInterface();

  let gameInstance = GetGameInstance();
  let ts = GameInstance.GetTransactionSystem( gameInstance );
  let player = GetPlayer(gameInstance);

  if (PlayerDevelopmentSystem.GetData( player ).IsNewPerkBought( gamedataNewPerkType.Cool_Left_Milestone_2 ) < 2)
  {
      return;
  }

  if ( !ItemID.IsValid(item) )
  {
    return;
  }

  // without a clean way to get the item object from the item ID this is my best :(
  this.m_weapon = ts.GetItemInSlot( player, t"AttachmentSlots.WeaponRight" ) as WeaponObject;
  if ( !this.m_weapon.WeaponHasTag( n"RangedWeapon" ) )
  {
    return;
  }

  let triggerModes : array<ref<TriggerMode_Record>> = this.m_weapon.GetTriggerModes();
  // PrimaryTriggerMode() if I manage to check for swapped trigger modes

  if ( ArraySize(triggerModes)<=0 ) 
  {
    return;
  }

  for triggerMode in triggerModes
  {
    let triggerType = triggerMode.Type( );
      if (Equals(triggerType, gamedataTriggerMode.Burst) ||  Equals(triggerType, gamedataTriggerMode.FullAuto) )
      {
        applyCycleTimeBuff = false;
        StatusEffectHelper.RemoveStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
      }
  }

  if (applyCycleTimeBuff) 
  {
    StatusEffectHelper.ApplyStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
  }
}



// aaaand need to remove SE once it's no longer necessary
@wrapMethod(AimingStateEvents)
public func OnItemUnequipped( slot : TweakDBID, item : ItemID )
{
  wrappedMethod(slot, item);

  let player = GetPlayer(GetGameInstance());
  if (StatusEffectSystem.ObjectHasStatusEffectWithTag( player, n"Deadeye_CycleTimeBuff" )) 
  {
    StatusEffectHelper.RemoveStatusEffect( player, t"PerksApplyToMore.Deadeye_CycleTimeBuff" );
  }
}