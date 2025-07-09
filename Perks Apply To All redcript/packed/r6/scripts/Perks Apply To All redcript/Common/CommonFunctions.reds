module PerksApplyToMore.CommonFunctions

public func IsSavageSlingUnlocked(player : ref<GameObject>) -> Bool
{
  // LogChannel(n"DEBUG", "IsSavageSlingUnlocked checking");
  return PlayerDevelopmentSystem.GetInstance( player ).IsNewPerkBought( player, gamedataNewPerkType.Body_Master_Perk_5 ) >= 2;
}

public func IsSharpshooterBleed(attackData : ref<AttackData>) -> Bool
{
  return attackData.attackDefinition.GetRecord().GetID() == t"PerksApplyToMore.SharpshooterBleed_Ticker";
}
