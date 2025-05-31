@replaceMethod(AimingStateEvents)
protected func OnEnter( stateContext : StateContext, scriptInterface : StateGameScriptInterface ) -> Void
{
    if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Left_Milestone_2 ) == 2 )
    {
        if( !( StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, 'FocusedCoolPerkSE' ) ) )
        {
            if( GameInstance.GetStatPoolsSystem( scriptInterface.owner.GetGame() ).GetStatPoolValue( m_executionOwner.GetEntityID(), gamedataStatPoolType.Stamina ) > TDB.GetFloat( T"NewPerks.Cool_Left_Milestone_2.focusedStaminaThreshold", 90.0 ) )
            {
                weaponType = RPGManager.GetItemRecord( m_weapon.GetItemID() ).ItemType().Type();
                if( ( ( weaponType == gamedataItemType.Wea_Handgun || weaponType == gamedataItemType.Wea_Revolver ) || weaponType == gamedataItemType.Wea_SniperRifle ) || weaponType == gamedataItemType.Wea_PrecisionRifle )
                {
                    StatusEffectHelper.ApplyStatusEffect( m_executionOwner, T"BaseStatusEffect.FocusedCoolPerkSE" );
                    focusEventUI = new FocusPerkTriggerd;
                    focusEventUI.isActive = true;
                    player.QueueEvent( focusEventUI );
                    GameObjectEffectHelper.StartEffectEvent( scriptInterface.executionOwner, 'cool_perk_focused_state_fullscreen', false );
                    GameObject.PlaySoundEvent( scriptInterface.owner, 'time_dilation_focused_enter' );
                    if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Inbetween_Left_2 ) == 1 )
                    {
                        timeDilationFocusedPerk = TDB.GetFloat( T"NewPerks.Cool_Inbetween_Left_2.timeDilationStrength", 0.15000001 );
                        GameInstance.GetTimeSystem( scriptInterface.owner.GetGame() ).SetTimeDilation( 'focusedStatePerkDilation', 1.0 - timeDilationFocusedPerk, 12.0, 'MeleeHitEaseIn', 'MeleeHitEaseOut' );
                    }
                }
            }
        }
    }
    wrappedMethod( stateContext : StateContext, scriptInterface : StateGameScriptInterface )
}
