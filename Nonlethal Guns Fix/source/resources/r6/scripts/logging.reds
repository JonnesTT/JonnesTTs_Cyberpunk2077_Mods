// @wrapMethod(WeaponTypeHitPrereqCondition)
// public func Evaluate( newHitEvent : ref<gameHitEvent> ) -> Bool
// {
//     let isNonlethal : Bool;
//     isNonlethal = newHitEvent.attackData.HasFlag( hitFlag.Nonlethal );

//     LogChannel(n"DEBUG", "in weaponTypeHitPrereq");
//     LogChannel(n"DEBUG", "Attack was of " + EnumValueToString("gamedataAttackType", Cast<Int64>(EnumInt(newHitEvent.attackData.GetAttackType()))) + " type");
//     LogChannel(n"DEBUG", "Recorded Weapon was: " + GetLocalizedTextByKey(newHitEvent.attackData.GetWeapon().GetWeaponRecord().DisplayName()) );
//     wrappedMethod(newHitEvent);

//     let objectToCheck : wref< WeaponObject >;
//     objectToCheck = newHitEvent.attackData.GetWeapon();
//     if ( objectToCheck.IsRanged() )
//     {
//         LogChannel(n"DEBUG", "AttackType was IDed as Ranged");
//     }
// // }
// native func NameToString(n: CName) -> String

@wrapMethod(AttackData)
public func AddFlag( flag : hitFlag, sourceName : CName ) -> Bool
{
    LogChannel(n"DEBUG", "added flat " + Cast<Int64>(EnumInt(flag)) + " to attack at behest of " + NameToString(sourceName));
    wrappedMethod(newHitEvent);
}


@wrapMethod(HitReactionComponent)
public func EvaluateHit( newHitEvent : ref<gameHitEvent> ) -> Void
{
    let isNonlethal : Bool;
    isNonlethal = newHitEvent.attackData.HasFlag( hitFlag.Nonlethal );

    LogChannel(n"DEBUG", "in HitReaction");

    if (isNonlethal)
    {
        LogChannel(n"DEBUG", "attack had non-Lethal Flag");
        LogChannel(n"DEBUG", "attack was of " + EnumValueToString("gamedataAttackType", Cast<Int64>(EnumInt(newHitEvent.attackData.GetAttackType()))) + " type");
        LogChannel(n"DEBUG", "Recorded Weapon was: " + GetLocalizedTextByKey(newHitEvent.attackData.GetWeapon().GetWeaponRecord().DisplayName()) );

    } else
    {
        LogChannel(n"DEBUG", "attack did not have Non-Lethal Flag");
        LogChannel(n"DEBUG", "attack was of " + EnumValueToString("gamedataAttackType", Cast<Int64>(EnumInt(newHitEvent.attackData.GetAttackType()))) + " type");
        LogChannel(n"DEBUG", "Recorded Weapon was: " + GetLocalizedTextByKey(newHitEvent.attackData.GetWeapon().GetWeaponRecord().DisplayName()) );

    }
    wrappedMethod(newHitEvent);

}