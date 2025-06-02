public class Configurable_sTaSt extends ScriptableService 
{
    protected persistent let config : ref<ConfigurableShorterTaStConfig>;
    protected persistent let allguns : array<ref<WeaponItem_Record>>;
    protected persistent let techGuns : array<ref<WeaponItem_Record>>;
    protected persistent let chargeTimeBonus : TweakDBID = t"ConfigurableTaSTimers.ChargeBonus";
    protected persistent let smartGuns : array<ref<WeaponItem_Record>>;

    protected persistent let lockOnBonusADS : TweakDBID = t"ConfigurableTaSTimers.LockOnTimeAds";
    protected persistent let lockOnBonusHip : TweakDBID = t"ConfigurableTaSTimers.LockOnTimeHip";
    protected persistent let BoltWindowMult : TweakDBID = t"ConfigurableTaSTimers.PerfectChargeWindow";
    protected persistent let targetAqusitionRangeMult: TweakDBID = t"ConfigurableTaSTimers.AquisitionRange";

    protected persistent let BoltBaseRecordID : TweakDBID = t"NewPerks.Tech_Right_Milestone_3_inline17";
    protected persistent let BoltBoostRecordID : TweakDBID = t"NewPerks.Tech_Right_Perk_3_2_inline4";
    protected persistent let chargeTimeMinID : TweakDBID = t"BaseStats.ChargeTime";
    protected persistent let baseChargeTimeMinID : TweakDBID = t"BaseStats.BaseChargeTime";
    protected persistent let lockOnTimeADS : TweakDBID = t"BaseStats.SmartGunAdsTimeToLock";
    protected persistent let lockOnTimeHip : TweakDBID = t"BaseStats.SmartGunHipTimeToLock";

    protected persistent let batch : ref<TweakDBBatch>;

    private cb func OnLoad() 
    {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/BeforeStart", this, n"OnLoadSave");

        ArrayClear(this.techGuns);
        ArrayClear(this.smartGuns);
    }

    private cb func OnLoadSave( event : ref<GameSessionEvent> ) -> Void
    {
        this.config = new ConfigurableShorterTaStConfig();

        // we expect the guns to be about 200-250 records each.
        // seems the size is cached somewhere
        if (ArraySize(this.techGuns) + ArraySize(this.smartGuns) <= 0) 
        {
            // LogChannel(n"DEBUG", "Getting Item Record Lists");
            this.allguns = this.GetAllGunRecords();

            this.techGuns = this.GetTechGunRecords(this.allguns);
            this.smartGuns = this.GetSmartGunRecords(this.allguns);

            ArrayClear(this.allguns);
        }else
        {
            // LogChannel(n"DEBUG", "Didn't get Item Record Lists");
        }


        // LogChannel(n"DEBUG", "Array allguns was " + ArraySize(this.allguns) + " long");
        // LogChannel(n"DEBUG", "Array techGuns was " + ArraySize(this.techGuns) + " long");
        // LogChannel(n"DEBUG", "Array smartGuns was " + ArraySize(this.smartGuns) + " long");


        
        this.batch = TweakDBManager.StartBatch();
        if this.config.isEnabled
        {  
            // LogChannel(n"DEBUG", "Adding sTaSt records");
            this.AddTaSRecords();
        }
        else
        {
            // LogChannel(n"DEBUG", "Removing sTaSt records");
            this.RemoveTaSRecords();
        }
        this.batch.Commit();
    }

    private func RemoveTaSRecords() -> Void
    {
        // Charge Speed
        for gun in this.techGuns
        {
            let technicalStatsRecord = this.GetTechnicalStatsListRecord(gun);
            this.RemoveItemfromArrayRecord(technicalStatsRecord+t".statModifiers", this.chargeTimeBonus);
            this.batch.UpdateRecord(technicalStatsRecord);
        }

        this.batch.SetFlat(this.BoltBaseRecordID+t".value", 25.0);
        this.batch.UpdateRecord(this.BoltBaseRecordID);

        this.batch.SetFlat(this.BoltBoostRecordID+t".value", 10.0);
        this.batch.UpdateRecord(this.BoltBoostRecordID);

        // Target Lock Speeds
        for gun in this.smartGuns
        {
            let smartGunStatsRecords = this.GetSmartGunStatsRecord(gun);
            this.RemoveItemfromArrayRecord(smartGunStatsRecords+t".statModifiers", this.lockOnBonusADS);
            this.RemoveItemfromArrayRecord(smartGunStatsRecords+t".statModifiers", this.lockOnBonusHip);
            this.batch.UpdateRecord(smartGunStatsRecords);
        }
    }

    public func AddTaSRecords() -> Void
    {
        //Charge Speed
        for gun in this.techGuns
        {
            let technicalStatsRecord = this.GetTechnicalStatsListRecord(gun);
            this.AddItemtoArrayRecord(technicalStatsRecord+t".statModifiers", this.chargeTimeBonus);
            this.batch.UpdateRecord(technicalStatsRecord);
        }
        this.batch.SetFlat(this.chargeTimeBonus+t".value", (this.config.chargeTimeMult));
        this.batch.UpdateRecord(this.chargeTimeBonus);

        // mult values for bolt window don't seem  to work :(
        // // Bolt Charge Window
        // this.batch.SetFlat(this.BoltWindowMult+t".value", this.config.chargeBoltWindow);
        // this.batch.UpdateRecord(this.BoltWindowMult);
        // this.AddItemtoArrayRecord(t"NewPerks.Tech_Right_Milestone_3_inline14.effectors", this.BoltWindowMult);
        // this.batch.UpdateRecord(t"NewPerks.Tech_Right_Milestone_3_inline14");

        this.batch.SetFlat(this.BoltBaseRecordID+t".value", 25.0*this.config.chargeBoltWindow);
        this.batch.UpdateRecord(this.BoltBaseRecordID);

        this.batch.SetFlat(this.BoltBoostRecordID+t".value", 10.0*this.config.chargeBoltWindow);
        this.batch.UpdateRecord(this.BoltBoostRecordID);

        // min Charge Time
        this.batch.SetFlat(this.chargeTimeMinID+t".min", this.config.chargeTimeMin);
        this.batch.UpdateRecord(this.chargeTimeMinID);

        this.batch.SetFlat(this.baseChargeTimeMinID+t".min", this.config.chargeTimeMin);
        this.batch.UpdateRecord(this.baseChargeTimeMinID);

        // min lock on time
        this.batch.SetFlat(this.lockOnTimeHip+t".min", this.config.lockOnTimeMin);
        this.batch.UpdateRecord(this.lockOnTimeHip);

        this.batch.SetFlat(this.lockOnTimeADS+t".min", this.config.lockOnTimeMin);
        this.batch.UpdateRecord(this.lockOnTimeADS);


        this.batch.SetFlat(this.targetAqusitionRangeMult+t".value", this.config.aquisitionRangeMult);
        this.batch.UpdateRecord(this.targetAqusitionRangeMult);

        for gun in this.smartGuns
        {
            let smartGunStatsRecords = this.GetSmartGunStatsRecord(gun);
            // Target Lock Speeds
            this.AddItemtoArrayRecord(smartGunStatsRecords+t".statModifiers", this.lockOnBonusADS);
            this.AddItemtoArrayRecord(smartGunStatsRecords+t".statModifiers", this.lockOnBonusHip);

            // aquisiton time
            this.AddItemtoArrayRecord(smartGunStatsRecords+t".statModifiers", this.targetAqusitionRangeMult);

            this.batch.UpdateRecord(smartGunStatsRecords);
        }
        this.batch.SetFlat(this.lockOnBonusADS+t".value", this.config.lockOnTimeADSMult);
        this.batch.UpdateRecord(this.lockOnBonusADS);
        this.batch.SetFlat(this.lockOnBonusHip+t".value", this.config.lockOnTimeHipMult);
        this.batch.UpdateRecord(this.lockOnBonusHip);
    }

    private func GetAllGunRecords() -> array<ref<WeaponItem_Record>>
    {
        let allGunRecordsBase = TweakDBInterface.GetRecords(n"gamedataWeaponItem_Record");
        let allGunRecords : array<ref<WeaponItem_Record>>;
        for gunRecord in allGunRecordsBase
        {
            let asWeaponRecord = TweakDBInterface.GetWeaponItemRecord(gunRecord.GetID());
            if this.IsActuallyGun(asWeaponRecord)
            {
                ArrayPush(allGunRecords, asWeaponRecord);
            }
        }
        return allGunRecords;
    }
    
    private func IsActuallyGun(record : ref<WeaponItem_Record>) -> Bool
    {
        // rule out Cyberware
        if Equals(record.ItemCategory().Type(), gamedataItemCategory.Cyberware)
        {
            return false;
        }
        // rule out plasma cutters (not aquirable. I want though.)
        if Equals(record.Blueprint(), null)
        {
            return false;
        }
        // rule out 
        if !record.CanDrop()
        {
            return false;
        }
        return true;
    }

    private func GetTechGunRecords(records : array<ref<WeaponItem_Record>>) -> array<ref<WeaponItem_Record>>
    {
        let outputList : array<ref<WeaponItem_Record>>;
        for record in records 
        {
            if Equals( record.Evolution().Type(), gamedataWeaponEvolution.Tech ) 
            {
                ArrayPush(outputList, record);
            }
        };
        return outputList;
    }

    private func GetSmartGunRecords(records : array<ref<WeaponItem_Record>>) -> array<ref<WeaponItem_Record>>
        {
        let outputList : array<ref<WeaponItem_Record>>;
        for record in records 
        {
            if Equals( record.Evolution().Type(), gamedataWeaponEvolution.Smart ) 
            {
                ArrayPush(outputList, record);
            }
        }
        return outputList;
    }

    private func GetTechnicalStatsListRecord(record : ref<WeaponItem_Record> ) -> TweakDBID
    {
        let tempList : array<TweakDBID>;
        let recordID : TweakDBID = record.GetID();
        tempList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(recordID+t".statModifierGroups"));
        for statModGroup in tempList 
        {
            if StrContains(TDBID.ToStringDEBUG(statModGroup), "_Technical_Stats")
            {
                return statModGroup;
            }
        }
        //failstate reached no record found
        let newTechStatsRecID : TweakDBID = recordID+t"_Technical_Stats";
        this.batch.CreateRecord(newTechStatsRecID, n"gamedataStatModifierGroup_Record");
        this.batch.UpdateRecord(newTechStatsRecID);
        this.AddItemtoArrayRecord(recordID+t".statModifierGroups", newTechStatsRecID);
        this.batch.UpdateRecord(recordID);
        FTLogError(s"[Configurable sTasT] Weapon record \(TDBID.ToStringDEBUG(recordID)) did not include Technical_Stats record. Generated Placeholder.");
        return newTechStatsRecID;
    }

    private func GetSmartGunStatsRecord(record : ref<WeaponItem_Record> ) -> TweakDBID
    {
        let tempList : array<TweakDBID>;
        let recordID : TweakDBID = record.GetID(); 
        tempList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(recordID+t".statModifierGroups"));
        for statModGroup in tempList 
        {
            if StrContains(TDBID.ToStringDEBUG(statModGroup), "_SmartGun_Stats")
            {
                return statModGroup;
            }
        }
        //failstate reached no record found
        let newSmartGunStatsRecID : TweakDBID = recordID+t"_SmartGun_Stats";
        this.batch.CreateRecord(newSmartGunStatsRecID, n"gamedataStatModifierGroup_Record");
        this.batch.UpdateRecord(newSmartGunStatsRecID);
        this.AddItemtoArrayRecord(recordID+t".statModifierGroups", newSmartGunStatsRecID);
        this.batch.UpdateRecord(recordID);
        FTLogError(s"[Configurable sTasT] Weapon record \(TDBID.ToStringDEBUG(recordID)) did not include SmartGun_Stats record. Generated Placeholder.");
        return newSmartGunStatsRecID;
    }

    private func AddItemtoArrayRecord(tdbidOfArray : TweakDBID, tdbidtoPush : TweakDBID ) -> Void
    {
        let recordIDList : array<TweakDBID>;
        recordIDList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(tdbidOfArray));
        if !ArrayContains(recordIDList, tdbidtoPush) 
        {
            ArrayPush(recordIDList, tdbidtoPush);

            this.batch.SetFlat(tdbidOfArray, recordIDList);
        }
    }

    private func RemoveItemfromArrayRecord(tdbidOfArray : TweakDBID, tdbidtoRemove : TweakDBID ) -> Void
    {
        let recordIDList : array<TweakDBID>;
        recordIDList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(tdbidOfArray));
        if ArrayContains(recordIDList, tdbidtoRemove) 
        {
            ArrayRemove(recordIDList, tdbidtoRemove);

            this.batch.SetFlat(tdbidOfArray, recordIDList);
        }
    }
}

