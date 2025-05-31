module ChipwareExpansion

@if(ModuleExists("ChipwareExpansion"))
@replaceMethod(InventoryDataManagerV2)
public static func GetChipwareSlots() -> array<TweakDBID> {
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

private class NoRNGCompataibiltyTweaker extends ScriptableService 
{
  private cb func OnInitialize() 
  {
    let batch = TweakDBManager.StartBatch();
    
    let tmpRecordArray = FromVariant(TweakDBInterface.GetFlat(t"NewPerks.TechnicalAbilityAttributeData.perks"));
    ArrayPush(tmpRecordArray, t"NewPerks.Tech_Central_Perk_2_1");
    batch.SetFlat(t"NewPerks.TechnicalAbilityAttributeData.perks", tmpRecordArray);
    batch.SetFlat(t"NewPerks.Tech_Central_Perk_2_1.loc_desc_key", t"LocKey#chipwareExpansion_perk_chipware_description");
    batch.SetFlat(t"NewPerks.Tech_Central_Perk_2_1.dataPackage", t"");
    batch.Commit();
  } 
}
