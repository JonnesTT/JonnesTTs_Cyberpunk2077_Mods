@wrapMethod(ItemTooltipWeaponInfoModule)
  protected func NEW_Update( data : weak< UIInventoryItem >, comparisonData : weak< UIInventoryItemComparisonManager > ) -> Void {
    wrappedMethod( data , comparisonData );
    let projectilesPerShot : Int32;
 		projectilesPerShot = data.GetNumberOfPellets();
    if !Equals(data.GetWeaponType() == WeaponType.Melee)
    {
      isShotgun = Equals(data.GetItemType() == gamedataItemType.Wea_Shotgun) || Equals(data.GetItemType() == gamedataItemType.Wea_ShotgunDual )
      if !isShotgun && projectilesPerShot != 1.0 
			{
				inkTextRef.SetText( this.m_perHitText, "UI-Tooltips-DamagePerHitWithMultiplierTemplate" );
				damageParams.AddString( "multiplier", IntToString( projectilesPerShot ) );
			}



      // if !isShotgun && projectilesPerShot != 1.0
      // {
      //   inkTextRef.SetText( this.m_damagePerHitValue, "UI-Tooltips-DamagePerHitWithMultiplierTemplate" );
      //   damageParams.AddString( "multiplier", IntToString( RoundF( projectilesPerShot ) ) );
      // };
    }
  }


// @replaceMethod(ItemTooltipController)
//   protected func UpdateDPS() -> Void {
// 		let i : Int32;
// 		let dps : Float;
// 		let itemRecord : ref<Item_Record>;
// 		let projectilesPerShot : Float;
//     let damagePerHit : Float;
//     let damagePerHitMin : Float;
//     let damagePerHitMax : Float;
//     let attacksPerSecond : Float;
//     let dpsDiffValue : Float;
// 		let dpsParams : ref<inkTextParams>;
//     let damageParams : ref<inkTextParams>;
//     let attackPerSecondParams : ref<inkTextParams>;
// 		let divideAttacksByPellets : Bool;
// 		dps = -1.0;
// 		itemRecord = TweakDBInterface.GetItemRecord( ItemID.GetTDBID( this.m_data.itemID ) );
// 	  dpsParams = new inkTextParams();
// 		damageParams = new inkTextParams();
// 		attackPerSecondParams = new inkTextParams();
// 		for primaryStat in this.m_data.primaryStats
// 		{
// 			if primaryStat.statType == gamedataStatType.EffectiveDPS
// 			{
// 				dps = primaryStat.currentValueF;
// 				dpsDiffValue = primaryStat.diffValueF;
// 			}
// 		}
// 		inkWidgetRef.SetState( m_dpsWrapper, GetArrowWrapperState( dpsDiffValue ) );
// 		inkWidgetRef.SetVisible( m_dpsWrapper, dps >= 0.0 );
// 		inkImageRef.SetVisible( m_dpsArrow, dpsDiffValue != 0.0 );
// 		if( dpsDiffValue > 0.0 )
// 		{
// 			inkImageRef.SetBrushMirrorType( m_dpsArrow, inkBrushMirrorType.NoMirror );
// 		}
// 		else if( dpsDiffValue < 0.0 )
// 		{
// 			inkImageRef.SetBrushMirrorType( m_dpsArrow, inkBrushMirrorType.Vertical );
// 		}
// 		dpsParams.AddNumber( "value", FloorF( dps ) );
// 		dpsParams.AddNumber( "valueDecimalPart", RoundF( ( dps - RoundF( dps ) ) * 10.0 ) % 10 );
// 		inkTextRef.SetTextParameters( m_dpsText, dpsParams );
// 		projectilesPerShot = InventoryItemData.GetGameItemData( m_data.inventoryItemData ).GetStatValueByType( gamedataStatType.ProjectilesPerShot );
// 		attacksPerSecond = InventoryItemData.GetGameItemData( m_data.inventoryItemData ).GetStatValueByType( gamedataStatType.AttacksPerSecond );
// 		divideAttacksByPellets = TweakDBInterface.GetBool( ItemID.GetTDBID( m_data.itemID ) + t".divideAttacksByPelletsOnUI", false ) && ( projectilesPerShot > 0.0 );
// 		attackPerSecondParams.AddString( "value", FloatToStringPrec( ( ( divideAttacksByPellets ) ? ( attacksPerSecond / projectilesPerShot ) : ( attacksPerSecond ) ), 2 ) );
// 		inkTextRef.SetLocalizedTextScript( m_attacksPerSecondValue, "UI-Tooltips-AttacksPerSecond", attackPerSecondParams );
// 		damagePerHit = InventoryItemData.GetGameItemData( m_data.inventoryItemData ).GetStatValueByType( gamedataStatType.EffectiveDamagePerHit );
// 		if( InventoryItemData.GetGameItemData( m_data.inventoryItemData ).HasTag( "Melee" ) )
// 		{
// 			inkTextRef.SetText( m_damagePerHitValue, "UI-Tooltips-DamagePerHitMeleeTemplate" );
// 			damageParams.AddString( "value", IntToString( RoundF( damagePerHit ) ) );
// 			inkTextRef.SetTextParameters( m_damagePerHitValue, damageParams );
// 			return;
// 		}
// 		damagePerHitMin = InventoryItemData.GetGameItemData( m_data.inventoryItemData ).GetStatValueByType( gamedataStatType.EffectiveDamagePerHitMin );
// 		damagePerHitMax = InventoryItemData.GetGameItemData( m_data.inventoryItemData ).GetStatValueByType( gamedataStatType.EffectiveDamagePerHitMax );
// 		damageParams.AddString( "value", IntToString( RoundF( damagePerHitMin ) ) );
// 		damageParams.AddString( "valueMax", IntToString( RoundF( damagePerHitMax ) ) );
// 		if( projectilesPerShot != 1.0 )
// 		{
// 			inkTextRef.SetText( m_damagePerHitValue, "UI-Tooltips-DamagePerHitWithMultiplierTemplate" );
// 			damageParams.AddString( "multiplier", IntToString( RoundF( projectilesPerShot ) ) );
// 		}
// 		else
// 		{
// 			inkTextRef.SetText( m_damagePerHitValue, "UI-Tooltips-DamagePerHitTemplate" );
// 		}
// 		inkTextRef.SetTextParameters( m_damagePerHitValue, damageParams );
//   }
