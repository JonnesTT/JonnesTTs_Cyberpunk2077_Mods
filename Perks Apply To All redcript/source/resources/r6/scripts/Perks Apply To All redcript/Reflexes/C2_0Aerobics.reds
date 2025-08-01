@wrapMethod(LocomotionEventsTransition)
protected final func ConsumeStaminaBasedOnLocomotionState( stateContext : ref<StateContext>, scriptInterface : ref<StateGameScriptInterface> )
{
    if ! ( Equals(this.GetStateName(), n"crouchSprint" ) && RPGManager.HasStatFlag( scriptInterface.executionOwner, gamedataStatType.IsSprintStaminaFree ))
    {
        wrappedMethod(stateContext, scriptInterface);
    }

}

// BaseStats.IsCrouchSprintFree