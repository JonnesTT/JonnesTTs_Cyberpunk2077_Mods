// Gag Order
// making damage preview not stealth reliant
@replaceMethod(DefaultTransition)
protected func HandleDamagePreview( weapon : ref<WeaponObject>, scriptInterface : ref<StateGameScriptInterface>, stateContext : ref<StateContext> )
{
  if( PlayerDevelopmentSystem.GetInstance( scriptInterface.executionOwner ).IsNewPerkBought( scriptInterface.executionOwner, gamedataNewPerkType.Cool_Right_Milestone_1 ) == 1 )
  {
    if( ( this.IsNameplateVisible( scriptInterface ) ) && !( stateContext.GetBoolParameter( n"DamagePreviewActive", true ) ) )
    {
      this.ActivateDamageProjection( true, weapon, scriptInterface, stateContext );
    }
    else if( stateContext.GetBoolParameter( n"DamagePreviewActive", true ) && ( !( this.IsNameplateVisible( scriptInterface ) ) )  )
    {
      this.ActivateDamageProjection( false, weapon, scriptInterface, stateContext );
    }
  }
}
