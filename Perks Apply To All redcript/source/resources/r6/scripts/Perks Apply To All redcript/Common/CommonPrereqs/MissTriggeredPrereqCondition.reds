public class MissTriggeredPrereqCondition extends BaseHitPrereqCondition
{
	public func Evaluate( hitEvent : ref< gameHitEvent > ) -> Bool
	{
		// LogChannel(n"DEBUG", "MissTriggeredPrereqCondition trying to evaluate");
		let result : Bool = false;
		let objectToCheck : wref< ScriptedPuppet >;
		objectToCheck =  hitEvent.target as ScriptedPuppet ;
		if( objectToCheck == null)
		{
            result = true;
		}
        return ( this.m_invert ? !result : result );
	}
}


// import condition into runtime
// done at: r6\scripts\Perks Apply To All redcript\CommonPrereqs\PrereqConditionCreator.reds
