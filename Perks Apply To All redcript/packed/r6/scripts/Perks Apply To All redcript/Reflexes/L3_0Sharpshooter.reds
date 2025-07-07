import PerksApplyToMore.CommonFunctions.IsSharpshooterBleed

public class IsSharpshooterBleedHitPrereqCondition extends BaseHitPrereqCondition
{
	public func Evaluate( hitEvent : ref< gameHitEvent > ) -> Bool
	{
		// LogChannel(n"DEBUG", "MissTriggeredPrereqCondition trying to evaluate");
		let result : Bool = IsSharpshooterBleed(hitEvent.attackData);
        return ( this.m_invert ? !result : result );
	}
}



@wrapMethod(GenericHitPrereq)
private func CreateHitCondition( record : ref<HitPrereqCondition_Record> ) -> ref<BaseHitPrereqCondition>
{
	let condition : ref<BaseHitPrereqCondition>;
	if ( Equals(record.Type().EnumName(), n"IsSharpshooterBleedHitPrereqCondition") )
	{
		// LogChannel(n"DEBUG", "Generated new MissTriggeredPrereqCondition");
		condition = new IsSharpshooterBleedHitPrereqCondition();
		return condition;
	}
	return wrappedMethod(record);
}

