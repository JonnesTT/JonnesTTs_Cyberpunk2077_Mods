enum SoundBroadcasts {
        None = 0,
        Walk = 1,
        Run = 2
}

@addField(LocomotionEventsTransition)
protected static let louderLocomotionConfig: ref<LouderLocomotionConfig>;


@wrapMethod(LocomotionEventsTransition)
protected func OnAttach( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );


        this.louderLocomotionConfig = LouderLocomotionConfig.Init();

        if this.louderLocomotionConfig.soundDistanceMultToggle 
        {
        TweakDBManager.SetFlat( t"stims.FootStepRegularStimuli.radius", 6.0*this.louderLocomotionConfig.SoundDistanceMultWalk );
        TweakDBManager.UpdateRecord( t"stims.FootStepRegularStimuli" );
        TweakDBManager.SetFlat( t"stims.FootStepSprintStimuli.radius", 9.0*this.louderLocomotionConfig.SoundDistanceMultRun );
        TweakDBManager.UpdateRecord( t"stims.FootStepSprintStimuli" );

        TweakDBManager.SetFlat( t"stims.LandingRegularStimuli.radius", 12.0*this.louderLocomotionConfig.SoundDistanceMultLanding );
        TweakDBManager.UpdateRecord( t"stims.LandingRegularStimuli" );
        TweakDBManager.SetFlat( t"stims.LandingHardStimuli.radius", 18.0*this.louderLocomotionConfig.SoundDistanceMultLanding );
        TweakDBManager.UpdateRecord( t"stims.LandingHardStimuli" );
        TweakDBManager.SetFlat( t"stims.LandingVeryHardStimuli.radius", 24.0*this.louderLocomotionConfig.SoundDistanceMultLanding );
        TweakDBManager.UpdateRecord( t"stims.LandingVeryHardStimuli" );
        }
        else
        {
        TweakDBManager.SetFlat( t"stims.FootStepRegularStimuli.radius", 6.0 );
        TweakDBManager.UpdateRecord( t"stims.FootStepRegularStimuli" );
        TweakDBManager.SetFlat( t"stims.FootStepSprintStimuli.radius", 9.0 );
        TweakDBManager.UpdateRecord( t"stims.FootStepSprintStimuli" );

        TweakDBManager.SetFlat( t"stims.LandingRegularStimuli.radius", 12.0 );
        TweakDBManager.UpdateRecord( t"stims.LandingRegularStimuli" );
        TweakDBManager.SetFlat( t"stims.LandingHardStimuli.radius", 18.0 );
        TweakDBManager.UpdateRecord( t"stims.LandingHardStimuli" );
        TweakDBManager.SetFlat( t"stims.LandingVeryHardStimuli.radius", 24.0 );
        TweakDBManager.UpdateRecord( t"stims.LandingVeryHardStimuli" );
        }
}


@wrapMethod(JumpEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.JumpRegularSound, scriptInterface);
        }
}

@wrapMethod(LadderJumpEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.JumpRegularSound, scriptInterface);
        }
}

@wrapMethod(DoubleJumpEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.JumpDoubleSound, scriptInterface);
        }
}

@wrapMethod(ChargeJumpEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.JumpChargeSound, scriptInterface);
        }
}

@wrapMethod(HoverJumpEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> ) -> Void
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.JumpHoverSound, scriptInterface);
        }
}

@wrapMethod(DodgeEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
{
        wrappedMethod( stateContext, scriptInterface );
        if super.louderLocomotionConfig.JumpSoundsToggle 
        {
                super.emitSound(super.louderLocomotionConfig.DodgeSound, scriptInterface);
        }
}


@addMethod(LocomotionEventsTransition)
protected func emitSound(soundType : SoundBroadcasts, scriptInterface : ref<StateGameScriptInterface>)
{
        switch soundType
        {
                case SoundBroadcasts.None:
                        return;
                case SoundBroadcasts.Walk:
                        this.BroadcastStimuliFootstepSprint( scriptInterface );
                        return;
                case SoundBroadcasts.Run:
                        this.BroadcastStimuliFootstepRegular( scriptInterface );
                        return;
        }
}