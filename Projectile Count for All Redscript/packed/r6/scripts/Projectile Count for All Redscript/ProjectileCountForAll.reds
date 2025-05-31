@wrapMethod(UIInventoryItemStatsManager)
private func InternalFetchStatByType( statType : gamedataStatType, statId : TweakDBID, skipEmpty : Bool ) -> ref<UIInventoryItemStat>
{
    // LogChannel(n"DEBUG", "Observed InternalFetchStatByType");
    let gameItemDataStrong : wref<gameItemData> = this.m_gameItemData;
    let value : Float;

    if( IsDefined( gameItemDataStrong ) )
    {
        // LogChannel(n"DEBUG", "gameItemDataStrong was defined");
        if( this.m_useBareStats )
        {
            value = gameItemDataStrong.GetBareStatValueByType( statType );
        }
        else
        {
            value = gameItemDataStrong.GetStatValueByType( statType );
        }
    }
    
    value = AbsF( value );

    if ( Equals(statType, gamedataStatType.ProjectilesPerShot) && ( value <= 1.001 && value >= 0.999) )
    {
        // LogChannel(n"DEBUG", "InternalFetchStatByType returns NULL");
        return null;
    }
    // LogChannel(n"DEBUG", "Calling InternalFetchStatByType");
    return wrappedMethod(statType, statId, skipEmpty);
}