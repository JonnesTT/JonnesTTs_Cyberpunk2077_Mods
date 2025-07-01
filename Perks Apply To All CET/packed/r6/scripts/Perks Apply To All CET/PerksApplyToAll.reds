// @addField(ItemInSlotPrereq)
//   public native let weaponTriggerType: gamedataTriggerMode;

// @wrapMethod(ItemInSlotPrereq)
// {
//   protected func Initialize( recordID : TweakDBID ) 
//   {
//     weaponTriggerType = TweakDBInterface.GetTriggerModeRecord( TweakDBInterface.GetForeignKeyDefault( recordID + T".triggerMode" ).Type() );
//     wrappedMethod(recordID);
//   }
// }

// @wrapMethod(ItemInSlotPrereq)
// {
//   protected func Evaluate( itemID : ItemID, owner : weak< GameObject > ) 
//   {
//     weaponTriggerType = TweakDBInterface.GetTriggerModeRecord( TweakDBInterface.GetForeignKeyDefault( recordID + T".triggerMode" ).Type() );
//   }
// }
