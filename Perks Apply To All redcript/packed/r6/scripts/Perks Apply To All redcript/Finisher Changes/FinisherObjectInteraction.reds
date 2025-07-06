
// make sure we have it displayed
@replaceMethod(ScriptedPuppet)
private func ProcessNewPerkFinisherLayer( evt : ref<InteractionChoiceEvent>, playerPuppet : ref<PlayerPuppet>, npcPuppet : ref<NPCPuppet> )
{
  // LogChannel(n"DEBUG", "ProcessNewPerkFinisherLayer running.");

  if(  playerPuppet == null || npcPuppet == null )
  {
    return;
  }
  if( !( playerPuppet.HasFinisherAvailable() ) )
  {
    return;
  }
  
  // add the new interaction to the check that acts on the NPC
  let isFinisherBluntHold : Bool = evt.choice.choiceMetaData.tweakDBID == t"Interactions.NewPerkFinisherBluntHold";
  // if isFinisherBluntHold 
  // {
  //   LogChannel(n"DEBUG", "ProcessNewPerkFinisherLayer: Interaction was regular savage sling.");
  // }
  let isNewSavageSling : Bool = evt.choice.choiceMetaData.tweakDBID == t"Interactions.NewSavageSlingFinisher";
  // if isNewSavageSling 
  // {
  //   LogChannel(n"DEBUG", "ProcessNewPerkFinisherLayer: Interaction was custom savage sling.");
  // }
  if( isFinisherBluntHold || isNewSavageSling )
  {
    this.TriggerNewPerkFinisherBluntHold( playerPuppet, npcPuppet );
  }
  else
  {
    // LogChannel(n"DEBUG", "ProcessNewPerkFinisherLayer: Triggering regular Finisher.");
    this.TriggerNewPerkFinisher( evt, playerPuppet );
  }
  // LogChannel(n"DEBUG", "ProcessNewPerkFinisherLayer returning.");
}
