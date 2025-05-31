module ChipwareExpansion

@if(ModuleExists("ChipwareExpansion"))
@replaceMethod(InventoryDataManagerV2)
public static func GetChipwareSlots() -> array<TweakDBID> 
{
  let game = GetGameInstance();

  let playerDevelopmentData: ref<PlayerDevelopmentData> = PlayerDevelopmentSystem.GetData(GetPlayer(game));
  let questsSystem = GameInstance.GetQuestsSystem(game);

  let slots = [
    t"ChipwareExpansion.ChipSlot1",
    t"ChipwareExpansion.ChipSlot2",
    t"ChipwareExpansion.ChipSlot3",
    t"ChipwareExpansion.ChipSlot4",
    t"ChipwareExpansion.ChipSlot5",
    t"ChipwareExpansion.ChipSlot6",
    t"ChipwareExpansion.ChipSlot7"
  ];

  if (playerDevelopmentData.IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Tech_Central_Perk_2_1)) {
      ArrayPush(slots, t"ChipwareExpansion.ChipSlotExtra");
  }

  if (questsSystem.GetFact(n"q005_johnny_chip_acquired") == 1) {
      ArrayPush(slots, t"ChipwareExpansion.ChipSlotJohnny");
  }

  return slots;
} 


private class NoRNGTweakPatcher extends ScriptableService 
{
  protected cb func OnInitialize() 
  {
    

  }

  // private func AddNewUIData()
  // {

  // }
}


private func MakeNeuralwareCompatible()
{
  LogChannel(n"DEBUG", "NoRNGTweakPatcher initialised");
    let items: array<TweakDBID> =
    [
      t"ChipwareExpansion.ZetatechNeuralwareRare",
      t"ChipwareExpansion.ZetatechNeuralwareRarePlus",
      t"ChipwareExpansion.ZetatechNeuralwareEpic",
      t"ChipwareExpansion.ZetatechNeuralwareEpicPlus",
      t"ChipwareExpansion.ZetatechNeuralwareLegendary",
      t"ChipwareExpansion.ZetatechNeuralwareLegendaryPlus",
      t"ChipwareExpansion.ZetatechNeuralwareLegendaryPlusPlus"
    ];


    let ToChange: array<TweakDBID>;

    let batch = TweakDBManager.StartBatch();

    for itemID in items 
    {
      LogChannel(n"DEBUG", "Finding Logic Packages in: " + TDBID.ToStringDEBUG(itemID));

      let LogicPackages = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(itemID + t".OnEquip"));

      for LogicPackage in LogicPackages 
      {
        LogChannel(n"DEBUG", "Found: " + TDBID.ToStringDEBUG(LogicPackage));
        let StatsModifiers = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(LogicPackage + t".stats"));
        for StatsModifier in StatsModifiers 
        {
          LogChannel(n"DEBUG", "included StatsModifier: " + TDBID.ToStringDEBUG(StatsModifier));
          LogChannel(n"DEBUG", "Stat Type record was: " + TDBID.ToStringDEBUG(FromVariant<TweakDBID>(TweakDBInterface.GetFlat(StatsModifier + t".statType"))));
          if Equals(t"BaseStats.SecondaryModifiersAdditiveMultiplier", FromVariant<TweakDBID>(TweakDBInterface.GetFlat(StatsModifier + t".statType")))
          {
            LogChannel(n"DEBUG", "Found SecondaryModifiersAdditiveMultiplier. Adding changes to patch.");
            batch.SetFlat(StatsModifier + t".statType", t"BaseStats.CyberwareCooldownReduction");
            // batch.UpdateRecord(StatsModifier + t".statType");
            batch.SetFlat(StatsModifier + t".value", (FromVariant<Float>(TweakDBInterface.GetFlat(StatsModifier + t".value")) / 2.0 ));
            // batch.UpdateRecord(StatsModifier + t".value");                                
            let uIData = FromVariant<TweakDBID>(TweakDBInterface.GetFlat(LogicPackage + t".UIData"));
            LogChannel(n"DEBUG", "Found UIData in: " + TDBID.ToStringDEBUG(uIData));
            let floatValues = FromVariant<array<Float>>(TweakDBInterface.GetFlat(uIData + t".floatValues"));
            LogChannel(n"DEBUG", "Float 0 is: " + floatValues[0] + " at " + TDBID.ToStringDEBUG(uIData + t".floatValues.0" ) );
            floatValues[0] = floatValues[0]/2.0;

            batch.SetFlat(uIData + t".floatValues", floatValues );
            batch.SetFlat(uIData + t".localizedDescription", "LocKey#40744" );
            batch.UpdateRecord(uIData);
            LogChannel(n"DEBUG", "Overwrote description with " + GetLocalizedTextByKey(n"LocKey#40744") );
            // above gives no text in console
          }
        }
      }
    }
    batch.Commit();
    LogChannel(n"DEBUG", "Batch commited.");
}