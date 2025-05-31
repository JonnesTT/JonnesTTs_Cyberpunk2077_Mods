@wrapMethod(HitReactionComponent)
public func EvaluateHit( newHitEvent : gameHitEvent ) -> Void {
    let isNonlethal : Bool;
    isNonlethal = newHitEvent.attackdata.HasFlag( hitFlag.Nonlethal );

    if (isNonlethal)
    {
        LogChannel(n"DEBUG", "attack had Non-Lethal Flag");
        LogChannle(n"DEBUG", "attack was of " + EnumValueToString(gamedataAttackType, newHitEvent.GetAttackType()) + " type");
    } else
    {
        LogChannel(n"DEBUG", "attack did not have Non-Lethal Flag");
        LogChannle(n"DEBUG", "attack was of " + EnumValueToString(gamedataAttackType, newHitEvent.GetAttackType()) + " type");

    }
    wrappedMethod(newHitEvent);
}