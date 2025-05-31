@replaceMethod(BaseGrenade)
protected func TriggerStimuli( radius : Float )
{
    let investigateData : stimInvestigateData;
    let broadcaster : ref<StimBroadcasterComponent>;
    if( radius > 0.0 )
    {
        broadcaster = this.GetStimBroadcasterComponent();
        if( broadcaster != null )
        {
            // investigateData.attackInstigator = this.GetUser();
            // investigateData.attackInstigatorPosition = this.GetUser().GetWorldPosition();
            // investigateData.revealsInstigatorPosition = true;
            // investigateData.illegalAction = true;
            // ArrayClear(investigateData.investigationSpots);
            ArrayPush(investigateData.investigationSpots, this.GetUser().GetWorldPosition());
            // investigateData.controllerEntity = this.GetUser();
            // investigateData.distrationPoint = this.GetUser().GetWorldPosition();
            // investigateData.skipReactionDelay = true;
            // investigateData.investigateController = true;
            broadcaster.TriggerSingleBroadcast( this, gamedataStimType.Recon, radius, investigateData );
            // broadcaster.TriggerSingleBroadcast( this, IntEnum<gamedataStimType>(EnumValueFromName(n"gamedataStimType", n"GrenadeExplosion")), radius, investigateData );

        }
    }
}
