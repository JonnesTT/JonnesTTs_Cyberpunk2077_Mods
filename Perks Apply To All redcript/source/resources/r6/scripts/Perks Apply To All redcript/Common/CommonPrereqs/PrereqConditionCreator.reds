@wrapMethod(GenericHitPrereq)
private func CreateHitCondition( record : ref<HitPrereqCondition_Record> ) -> ref<BaseHitPrereqCondition>
{
	let condition : ref<BaseHitPrereqCondition>;
    let recordTypeName : CName; //this the workaround for not having enums. Having the enum stored in a record is a godsent!
	switch (record.Type().EnumName())
    {
        case n"MissTriggeredPrereqCondition" :
            condition = new MissTriggeredPrereqCondition();
            return condition;
// this is the hyperspecific cutoff line. For organisations sake, only put conditions here that the player may not commonly have access to
        case n"IsSharpshooterBleedHitPrereqCondition" :
            condition = new IsSharpshooterBleedHitPrereqCondition();
            return condition;
    }

	return wrappedMethod(record);
}



