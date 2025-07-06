
@wrapMethod(PerkDisplayTooltipController)
private func MeleewarePerkToText( type : gamedataNewPerkType ) -> String
{
    if Equals(type, gamedataNewPerkType.Intelligence_Left_Perk_3_4) 
    {
        return "";
    }
    return wrappedMethod(type);
}

@wrapMethod(PerkDisplayTooltipController)
private func MeleewarePerkToIcon( type : gamedataNewPerkType ) -> CName
{
    if Equals(type, gamedataNewPerkType.Intelligence_Left_Perk_3_4) 
    {
        return n"";
    }
    return wrappedMethod(type);
}