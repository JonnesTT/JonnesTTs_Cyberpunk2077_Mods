
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


@wrapMethod(GenericHitPrereq)
private func CreateHitCondition( record : ref<HitPrereqCondition_Record> ) -> ref<BaseHitPrereqCondition>
{
	let condition : ref<BaseHitPrereqCondition>;
	let typeName : CName;
	typeName = record.Type().EnumName();
	if ( Equals(typeName, n"MissTriggeredPrereqCondition") )
	{
		// LogChannel(n"DEBUG", "Generated new MissTriggeredPrereqCondition");
		condition = new MissTriggeredPrereqCondition();
		return condition;
	}
	wrappedMethod(record);
}



// // for logging
// @replaceMethod(buffListItemLogicController)
// public func SetData( icon : CName, time : Float, totalTime : Float, opt stackCount : Int32 )
// {
// 	LogChannel(n"DEBUG", "SetData: icon running for effect with icon" + NameToString(icon));
// 	if( stackCount > 1 )
// 	{
// 		inkWidgetRef.SetVisible( this.m_stackCounterContainer, true );
// 		inkTextRef.SetText( this.m_stackCounter, "x" + IntToString( stackCount ) );
// 	}
// 	else
// 	{
// 		inkWidgetRef.SetVisible( this.m_stackCounterContainer, false );
// 	}
// 	this.SetTimeFill( time, totalTime );
// 	this.SetTimeText( time );
// 	LogChannel(n"DEBUG", "SetData: icon running for effect with icon UIIcon." + NameToString(icon));
// 	InkImageUtils.RequestSetImage( this, this.m_icon, "UIIcon." + NameToString( icon ) );
// 	InkImageUtils.RequestSetImage( this, this.m_iconBg, "UIIcon." + NameToString( icon ) );
// }
