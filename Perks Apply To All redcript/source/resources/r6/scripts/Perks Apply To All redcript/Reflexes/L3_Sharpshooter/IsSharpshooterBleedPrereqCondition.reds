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



// import condition into runtime
// done at: r6\scripts\Perks Apply To All redcript\CommonPrereqs\PrereqConditionCreator.reds
