
// All Finisher Rewards go here aka healing
@replaceMethod(FinisherEndEvents)
public static func ApplyFinisherBuffs( playerPuppet : wref< PlayerPuppet >, isWorkspotFinisher : Bool )
{
    let weapon : ref<WeaponObject>;
    if( playerPuppet == null )
    {
        return;
    }
    weapon = GameObject.GetActiveWeapon( playerPuppet );
    StatusEffectHelper.RemoveStatusEffect( playerPuppet, t"BaseStatusEffect.BlockFinisherStatusEffect" );
    StatusEffectHelper.RemoveStatusEffect( playerPuppet, t"BaseStatusEffect.PlayerInFinisherWorkspot" );
    if( isWorkspotFinisher )
    {
        StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.BlockWorkspotFinisherStatusEffect", playerPuppet.GetEntityID() );
    }
    StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Finisher_Healing_Buff", playerPuppet.GetEntityID() );
    if( weapon.IsMantisBlades() && ( PlayerDevelopmentSystem.GetData( playerPuppet ).IsNewPerkBought( gamedataNewPerkType.Espionage_Central_Milestone_1 ) > 0 ) )
    {
        StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Espionage_Central_Milestone_1_Buff_MantisBlades" );
    }
    // replaced ..IsBlade(...) check with ..IsMelee(...)
    // this makes the Reflexes_3_1 FlashOfSteel attackspeed buff universal to melee weapons
    if( weapon.IsMelee() && PlayerDevelopmentSystem.GetData( playerPuppet ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Right_Perk_3_1 ) )
    {
        StatusEffectHelper.ApplyStatusEffect( playerPuppet, t"BaseStatusEffect.Reflexes_Right_Perk_3_1_Buff_Level_1", playerPuppet.GetEntityID() );
    }
}