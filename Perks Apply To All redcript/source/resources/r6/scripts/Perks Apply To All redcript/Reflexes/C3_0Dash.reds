// likely most compatible approach is to use the enum in the wrong slot. It's a workaround but it would work.
// for future reference, I'd appreciate if this was done with base.stats rather than perkbought checks. I for one will recode it to work that way.



// this is the lazy variant. Use stat instead!
@replaceMethod(AimWalkDecisions)
protected const func ToDodge( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
    let isDashPerkBought : Bool;
    // changed Reflexes_Central_Milestone_2 to Reflexes_Central_Milestone_3
    isDashPerkBought = PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner ).IsNewPerkBought( gamedataNewPerkType.Reflexes_Central_Milestone_3 ) == 2;
    if( isDashPerkBought && this.WantsToDodge( stateContext, scriptInterface ) )
    {
        return true;
    }
    return false;
}

// well now this is NOT the kind of function I want to replace!
// unfinished, 
@replaceMethod(DodgeEvents)
protected func OnEnter( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
{
    let ownerID : StatsObjectID;
    let questSystem : ref<QuestsSystem>;
    let dodgeHeading : Float;
    let shouldLeapToTarget : Bool;
    let npcdata : ref<IBlackboard>;
    let inputSchemesBB : ref<IBlackboard>;
    let inputSchemeNum : Uint32;
    let npcGObj : wref< GameObject >;
    let crossHairNPC : NPCNextToTheCrosshair;
    let fierceDashPerkIsBought : Bool;
    let playerDevelopmentData : ref<PlayerDevelopmentData>;
    let targetObjectMax : ref<GameObject>;
    let targetObjectMin : ref<GameObject>;
    let isExhausted : Bool;
    let isPlayerInTheAir : Bool;
    let isAirDash : Bool;
    let locomotionState : CName;
    let puppet : ref<ScriptedPuppet>;
    let maxDistToTarget : Float;
    let isPlayerInElevator : Bool;
    ownerID = Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID);
    questSystem = scriptInterface.GetQuestsSystem();
    dodgeHeading = stateContext.GetConditionFloat( n"DodgeDirection" );
    playerDevelopmentData = PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner );
    isExhausted = GameInstance.GetStatPoolsSystem( scriptInterface.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID), gamedataStatPoolType.Stamina ) == 0.0;
    locomotionState = stateContext.GetStateMachineCurrentState( n"Locomotion" );
    scriptInterface.localBlackboard.SetFloat( GetAllBlackboardDefs().PlayerStateMachine.DodgeTimeStamp, EngineTime.ToFloat( GameInstance.GetEngineTime( scriptInterface.GetGame() ) ) );
    this.m_currentNumberOfJumps = stateContext.GetIntParameter( n"currentNumberOfJumps", true );
    super.OnEnter( stateContext, scriptInterface );
    if( Equals(locomotionState, n"chargeJump" ) )
    {
        stateContext.SetPermanentBoolParameter( n"isGravityAffectedByChargedJump", true, true );
    }
    inputSchemesBB = GameInstance.GetBlackboardSystem( scriptInterface.GetGame() ).Get( GetAllBlackboardDefs().InputSchemes );
    if( inputSchemesBB != null )
    {
        inputSchemeNum = inputSchemesBB.GetUint( GetAllBlackboardDefs().InputSchemes.Scheme );
    }
    this.m_crouching = ( ( Equals( inputSchemeNum, Cast<Uint32>(EnumValueFromName(n"InputScheme", n"LEGACY"))  ) ) && !( scriptInterface.executionOwner.PlayerLastUsedKBM() ) ) || ( ( ( Equals( locomotionState,  n"crouch" ) || Equals( locomotionState,  n"crouchSprint" ) ) || Equals( locomotionState,  n"slide" ) ) && ( ( Equals( inputSchemeNum, Cast<Uint32>(EnumValueFromName(n"InputScheme", n"LEGACY"))  ) || !( scriptInterface.IsActionJustTapped( n"ToggleCrouch" ) ) ) || !( scriptInterface.IsActionJustPressed( n"Crouch" ) ) ) );
    if( this.m_crouching )
    {
        puppet = ( scriptInterface.owner as ScriptedPuppet );
        if( puppet != null )
        {
            puppet.GetPuppetPS().SetCrouch( true );
        }
        scriptInterface.GetAudioSystem().NotifyGameTone( n"EnterCrouch" );
        scriptInterface.GetSpatialQueriesSystem().GetPlayerObstacleSystem().OnEnterCrouch( scriptInterface.owner );
        this.SetBlackboardIntVariable( scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Locomotion, ( Cast<Int32>(EnumValueFromName(n"gamePSMLocomotionStates", n"CrouchDodge") )) );
        scriptInterface.SetAnimationParameterFloat( n"crouch", 1.0 );
    }
    else
    {
        if( Equals( locomotionState, n"crouch" ) || Equals( locomotionState, n"crouchSprint" ) )
        {
            stateContext.SetConditionBoolParameter( n"CrouchToggled", false, true );
        }
        this.SetBlackboardIntVariable( scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Locomotion, ( Cast<Int32>(EnumValueFromName(n"gamePSMLocomotionStates", n"Dodge"))) );
    }
    stateContext.SetConditionBoolParameter( n"DodgeWhileCrouching", this.m_crouching, true );
    npcdata = GameInstance.GetBlackboardSystem( scriptInterface.GetGame() ).Get( GetAllBlackboardDefs().UI_NPCNextToTheCrosshair );
    crossHairNPC = ( FromVariant<NPCNextToTheCrosshair>( npcdata.GetVariant( GetAllBlackboardDefs().UI_NPCNextToTheCrosshair.NameplateData ) )  );
    npcGObj = ( ( crossHairNPC.npc as ScriptedPuppet) );
    shouldLeapToTarget = npcGObj.IsHostile();
    isPlayerInTheAir = !( this.IsTouchingGround( scriptInterface ) );
    isPlayerInElevator = GameInstance.GetBlackboardSystem( scriptInterface.GetGame() ).GetLocalInstanced( scriptInterface.ownerEntityID, GetAllBlackboardDefs().PlayerStateMachine ).GetBool( GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator );

// Reflexes_Central_Milestone_2 changed to to Reflexes_Central_Milestone_3
    if( !( isPlayerInElevator ) && ( playerDevelopmentData.IsNewPerkBought( gamedataNewPerkType.Reflexes_Central_Milestone_3 ) == 2 ) )
    {
        // replace Reflexes_Central_Milestone_3 with Reflexes_Central_Perk_3_2
        if( isPlayerInTheAir && ( !PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Central_Perk_3_2 ) ) )
        {
            return;
        }
        stateContext.SetPermanentBoolParameter( n"TemporarySpeedLimitIgnore", true, true );
        // replace Reflexes_Central_Perk_2_1 with Reflexes_Central_Perk_3_3
        fierceDashPerkIsBought = playerDevelopmentData.IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Central_Perk_3_3 );
        maxDistToTarget = this.GetStaticFloatParameterDefault( "maxDistToTarget", 5.0 );
        maxDistToTarget = ( ( fierceDashPerkIsBought ) ? ( maxDistToTarget * 2.0 ) : ( maxDistToTarget ) );
        targetObjectMax = DefaultTransition.GetTargetObject( scriptInterface, maxDistToTarget, true );
        targetObjectMin = DefaultTransition.GetTargetObject( scriptInterface, this.GetStaticFloatParameterDefault( "minDistToTarget", 1.0 ), true );
        if( ( shouldLeapToTarget && ( AbsF( dodgeHeading ) < 60.0 ) ) && ( targetObjectMin != null || targetObjectMax != null ) )
        {
            StatusEffectHelper.ApplyStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.PlayerMadDashLocomotionBuffer" );
            this.LeapToTarget( stateContext, scriptInterface, npcGObj );
            this.PlayRumbleBasedOnDodgeDirection( stateContext, scriptInterface );
        }
        else
        {
            if( isPlayerInTheAir )
            {
                isAirDash = this.TreatDashAsAirDash( scriptInterface );
            }
            this.Dash( stateContext, scriptInterface, isExhausted, isAirDash );
            this.PlayRumbleBasedOnDodgeDirection( stateContext, scriptInterface, isExhausted );
        }
        if( !( isExhausted ) )
        {
            this.PlaySound( n"lcm_dash", scriptInterface );
            GameObjectEffectHelper.StartEffectEvent( scriptInterface.executionOwner, n"dash" );
            StatusEffectHelper.ApplyStatusEffect( scriptInterface.owner, t"BaseStatusEffect.PlayerJustDashed", scriptInterface.owner.GetEntityID() );
        }
        scriptInterface.PushAnimationEvent( n"Dodge" );
    }
    else
    {
        this.Dodge( stateContext, scriptInterface, isExhausted );
        if( !( this.m_crouching ) )
        {
            scriptInterface.PushAnimationEvent( n"Dodge" );
        }
        if( StatusEffectHelper.HasStatusEffectWithTagConst( ( scriptInterface.executionOwner as PlayerPuppet ), n"SecondChancePerkTimeDilation" ) )
        {
            this.PlaySound( n"lcm_dash", scriptInterface );
        }
        this.PlayRumbleBasedOnDodgeDirection( stateContext, scriptInterface );
    }
    questSystem.SetFact( n"gmpl_player_dodged", questSystem.GetFact( n"gmpl_player_dodged" ) + 1 );
    this.m_blockStatFlag = RPGManager.CreateStatModifier( gamedataStatType.IsDodging, gameStatModifierType.Additive, 1.0 );
    StatusEffectHelper.ApplyStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.DodgeBuff" );
    StatusEffectHelper.ApplyStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.JustDodgedBuffer" );
    StatusEffectHelper.ApplyStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.PlayerJustDodgedLocomotionBuffer" );
    if( !( isExhausted ) && ( ( dodgeHeading < -45.0 ) || ( dodgeHeading > 45.0 ) ) )
    {
        StatusEffectHelper.ApplyStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.DodgeInvulnerability" );
    }
    this.ConsumeStaminaBasedOnLocomotionState( stateContext, scriptInterface );
    scriptInterface.GetStatsSystem().AddModifier( ownerID, this.m_blockStatFlag );
    this.SetDetailedState( scriptInterface, gamePSMDetailedLocomotionStates.Dodge );
    this.LogSpecialMovementToTelemetry( scriptInterface, telemetryMovementType.Dodge );
}

@replaceMethod(ClimbDecisions)
protected const func EnterCondition( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
    let isInAcceptableAerialState : Bool;
    let isInAutoClimbState : Bool;
    let isClimbInputActive : Bool;
    let climbInfo : ref<PlayerClimbInfo>;
    let enterAngleThreshold : Float;
    let isObstacleSuitable : Bool;
    let isPathClear : Bool;
    let preClimbAnimFeature : ref<AnimFeature_PreClimbing>;
    isPathClear = false;
    isInAcceptableAerialState = ( ( scriptInterface.localBlackboard.GetInt( GetAllBlackboardDefs().PlayerStateMachine.Locomotion ) == ( Cast<Int32>( EnumValueFromName(n"gamePSMLocomotionStates", n"Jump") ) ) ) || this.IsInLocomotionState( stateContext, n"dodgeAir" ) ) || stateContext.GetBoolParameter( n"enteredFallFromAirDodge", true );
    // Reflexes_Central_Milestone_2 replaced with Reflexes_Central_Milestone_3
    isInAutoClimbState = ( ( PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner ).IsNewPerkBought( gamedataNewPerkType.Reflexes_Central_Milestone_3 ) == 2 ) && this.IsTouchingGround( scriptInterface ) ) && ( this.IsInLocomotionState( stateContext, n"dodge" ) || StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, n"JustDodgedLocomotion" ) );
    isClimbInputActive = stateContext.GetConditionBool( n"JumpPressed" ) || scriptInterface.IsActionJustPressed( n"Jump" );
    if( !( isInAcceptableAerialState ) && !( isClimbInputActive ) )
    {
        if( !( isInAutoClimbState ) )
        {
            return false;
        }
        if( !( scriptInterface.IsMoveInputConsiderable() ) )
        {
            return false;
        }
    }
    climbInfo = scriptInterface.GetSpatialQueriesSystem().GetPlayerObstacleSystem().GetCurrentClimbInfo( scriptInterface.owner );
    isObstacleSuitable = climbInfo.climbValid && this.OverlapFitTest( scriptInterface, climbInfo );
    if( isObstacleSuitable )
    {
        isPathClear = this.TestClimbingPath( scriptInterface, climbInfo, DefaultTransition.GetPlayerPosition( scriptInterface ) );
        isObstacleSuitable = isObstacleSuitable && isPathClear;
    }
    preClimbAnimFeature = new AnimFeature_PreClimbing(); //+test installed
    preClimbAnimFeature.valid = 0.0;
    if( isObstacleSuitable )
    {
        preClimbAnimFeature.edgePositionLS = scriptInterface.TransformInvPointFromObject( climbInfo.descResult.topPoint );
        preClimbAnimFeature.valid = 1.0;
    }
    stateContext.SetConditionScriptableParameter( n"PreClimbAnimFeature", preClimbAnimFeature, true );
    if( isObstacleSuitable )
    {
        if( this.IsVaultingClimbingRestricted( scriptInterface ) )
        {
            return false;
        }
        if( !( this.ForwardAngleTest( stateContext, scriptInterface, climbInfo ) ) )
        {
            return false;
        }
        if( this.IsCurrentFallSpeedTooFastToEnter( stateContext, scriptInterface ) )
        {
            return false;
        }
        if( AbsF( scriptInterface.GetInputHeading() ) > 90.0 )
        {
            return false;
        }
        if( this.IsCameraPitchAcceptable( stateContext, scriptInterface, this.GetStaticFloatParameterDefault( "cameraPitchThreshold", -30.0 ) ) )
        {
            return false;
        }
        if( stateContext.IsStateActive( n"Locomotion", n"chargeJump" ) && ( this.GetVerticalSpeed( scriptInterface ) > 0.0 ) )
        {
            return false;
        }
        enterAngleThreshold = this.GetStaticFloatParameterDefault( "inputAngleThreshold", -180.0 );
        if( !( AbsF( scriptInterface.GetInputHeading() ) <= enterAngleThreshold ) )
        {
            return false;
        }
        if( !( stateContext.GetBoolParameter( n"enableVaultFromleapAttack", true ) ) && !( MeleeTransition.MeleeUseExplorationCondition( stateContext, scriptInterface ) ) )
        {
            return false;
        }
        return isObstacleSuitable;
    }
    return false;
}


@replaceMethod(VaultDecisions)
protected const func EnterCondition( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
    let playerDevelopmentData : ref<PlayerDevelopmentData>;
    let detailedLocomotionState : Int32;
    let dashVaultAttempt : Bool;
    let velocity : Vector4;
    let angle : Float;
    let vaultInfo : ref<PlayerClimbInfo>;
    let enterAngleThreshold : Float;
    let playerCapsuleDimensions : Vector4;
    let enableVaultFromleapAttack : Bool;
    playerDevelopmentData = PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner );
    
    // replaced Reflexes_Central_Milestone_2 with Reflexes_Central_Milestone_3
    if( ( playerDevelopmentData.IsNewPerkBought( gamedataNewPerkType.Reflexes_Central_Milestone_3 ) == 2 ) && this.IsTouchingGround( scriptInterface ) )
    {
        detailedLocomotionState = scriptInterface.localBlackboard.GetInt( GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed );
        if( ( ( detailedLocomotionState == ( Cast<Int32>( EnumValueFromName( n"gamePSMDetailedLocomotionStates", n"Dodge" )) ) ) || StatusEffectSystem.ObjectHasStatusEffectWithTag( scriptInterface.executionOwner, n"JustDodgedLocomotion" ) ) || ( !( this.m_shouldDisableEnterCondition ) && ( ( ( ( ( ( scriptInterface.GetActionValue( n"Dodge" ) > 0.0 ) || ( scriptInterface.GetActionValue( n"DodgeDirection" ) > 0.0 ) ) || ( scriptInterface.GetActionValue( n"DodgeForward" ) > 0.0 ) ) || ( scriptInterface.GetActionValue( n"DodgeRight" ) > 0.0 ) ) || ( scriptInterface.GetActionValue( n"DodgeLeft" ) > 0.0 ) ) || ( scriptInterface.GetActionValue( n"DodgeBack" ) > 0.0 ) ) ) )
        {
            dashVaultAttempt = true;
        }
    }
    if( ( dashVaultAttempt && ( scriptInterface.GetActionValue( n"Jump" ) <= 0.0 ) ) && ( scriptInterface.GetActionValue( n"Dodge" ) <= 0.0 ) )
    {
        velocity = DefaultTransition.GetLinearVelocity( scriptInterface );
        angle = Vector4.GetAngleBetween( scriptInterface.executionOwner.GetWorldForward(), velocity );
        if( AbsF( angle ) > 50.0 )
        {
            this.EnableOnEnterCondition( false );
            return false;
        }
    }
    enableVaultFromleapAttack = stateContext.GetBoolParameter( n"enableVaultFromleapAttack", true );
    if( ( !( dashVaultAttempt ) && !( enableVaultFromleapAttack ) ) && this.m_shouldDisableEnterCondition )
    {
        this.EnableOnEnterCondition( false );
        return false;
    }
    if( this.IsVaultingClimbingRestricted( scriptInterface ) )
    {
        this.EnableOnEnterCondition( false );
        return false;
    }
    if( ( !( enableVaultFromleapAttack ) && this.GetStaticBoolParameterDefault( "requireDirectionalInputToVault", false ) ) && !( scriptInterface.IsMoveInputConsiderable() ) )
    {
        this.EnableOnEnterCondition( false );
        return false;
    }
    enterAngleThreshold = this.GetStaticFloatParameterDefault( "enterAngleThreshold", -180.0 );
    if( AbsF( scriptInterface.GetInputHeading() ) > enterAngleThreshold )
    {
        if( !( enableVaultFromleapAttack ) )
        {
            this.EnableOnEnterCondition( false );
        }
        return false;
    }
    if( !( enableVaultFromleapAttack ) && !( MeleeTransition.MeleeUseExplorationCondition( stateContext, scriptInterface ) ) )
    {
        this.EnableOnEnterCondition( false );
        return false;
    }
    vaultInfo = scriptInterface.GetSpatialQueriesSystem().GetPlayerObstacleSystem().GetCurrentClimbInfo( scriptInterface.owner );
    if( !( vaultInfo.vaultValid ) )
    {
        if( !( dashVaultAttempt ) && !( enableVaultFromleapAttack ) )
        {
            this.EnableOnEnterCondition( false );
        }
        return false;
    }
    playerCapsuleDimensions.X = this.GetStaticFloatParameterDefault( "capsuleRadius", 0.40000001 );
    playerCapsuleDimensions.Y = ( ( dashVaultAttempt ) ? ( ( this.GetStaticFloatParameterDefault( "capsuleHeight", 0.89999998 ) * 0.5 ) - playerCapsuleDimensions.X ) : ( -1.0 ) );
    playerCapsuleDimensions.Z = -1.0;
    if( !( this.FitTest( scriptInterface, playerCapsuleDimensions, vaultInfo ) ) )
    {
        if( !( enableVaultFromleapAttack ) )
        {
            this.EnableOnEnterCondition( false );
        }
        return false;
    }
    if( !( this.ObstacleLengthCheck( stateContext, scriptInterface, vaultInfo ) ) )
    {
        if( !( dashVaultAttempt ) && !( enableVaultFromleapAttack ) )
        {
            this.EnableOnEnterCondition( false );
        }
        return false;
    }
    if( !( dashVaultAttempt ) && !( enableVaultFromleapAttack ) )
    {
        this.EnableOnEnterCondition( false );
    }
    return true;
}


// for air dash

@replaceMethod(LocomotionTransition)
protected const func WantsToDodge( const stateContext : ref<StateContext>, const scriptInterface : ref<StateGameScriptInterface> ) -> Bool
{
    let isInCooldown : Bool;
    let disableAirDash : StateResultBool;
    let isAirDashPerkBought : Bool;
    let isStaminaPositive : Bool;
    if( !( scriptInterface.HasStatFlag( gamedataStatType.HasDodge ) ) )
    {
        return false;
    }
    if( StatusEffectSystem.ObjectHasStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.HealFood3" ) )
    {
        return false;
    }
    isInCooldown = StatusEffectSystem.ObjectHasStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.DodgeCooldown" ) || StatusEffectSystem.ObjectHasStatusEffect( scriptInterface.executionOwner, t"BaseStatusEffect.DodgeAirCooldown" );
    if( isInCooldown )
    {
        return false;
    }
    disableAirDash = stateContext.GetPermanentBoolParameter( n"disableAirDash" );
    // replaced Reflexes_Central_Milestone_3 with Reflexes_Central_Perk_3_2
    isAirDashPerkBought = PlayerDevelopmentSystem.GetData( scriptInterface.executionOwner ).IsNewPerkBoughtAnyLevel( gamedataNewPerkType.Reflexes_Central_Perk_3_2 );
    isStaminaPositive = GameInstance.GetStatPoolsSystem( scriptInterface.executionOwner.GetGame() ).GetStatPoolValue( Cast<StatsObjectID>(scriptInterface.executionOwner.GetEntityID()), gamedataStatPoolType.Stamina, true ) > 0.0;
    if( !( this.IsTouchingGround( scriptInterface ) ) && ( ( !( isAirDashPerkBought ) || !( isStaminaPositive ) ) || ( disableAirDash.valid && disableAirDash.value ) ) )
    {
        return false;
    }
    if( this.IsCurrentFallSpeedTooFastToEnter( stateContext, scriptInterface ) )
    {
        return false;
    }
    if( scriptInterface.IsActionJustTapped( n"Dodge" ) )
    {
        if( scriptInterface.IsMoveInputConsiderable() )
        {
            stateContext.SetConditionFloatParameter( n"DodgeDirection", scriptInterface.GetInputHeading(), true );
            return true;
        }
        else if( this.GetStaticBoolParameterDefault( "dodgeWithNoMovementInput", false ) )
        {
            stateContext.SetConditionFloatParameter( n"DodgeDirection", -180.0, true );
            return true;
        }
    }
    if( this.WantsToDodgeFromMovementInput( stateContext, scriptInterface ) && GameplaySettingsSystem.GetMovementDodgeEnabled( scriptInterface.executionOwner ) )
    {
        return true;
    }
    return false;
}