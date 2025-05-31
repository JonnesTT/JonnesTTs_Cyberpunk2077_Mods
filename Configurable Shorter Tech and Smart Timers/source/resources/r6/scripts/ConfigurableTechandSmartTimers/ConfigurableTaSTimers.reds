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

    private cb func OnLoad() 
    {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/BeforeStart", this, n"OnLoadSave");

        this.config = new ConfigurableShorterTaStConfig();

        this.allguns = this.GetAllGunRecords();

        this.techGuns = this.GetTechGunRecords(this.allguns);
        this.smartGuns = this.GetSmartGunRecords(this.allguns);

        ArrayClear(this.allguns);
    }


    private cb func OnLoadSave( event : ref<GameSessionEvent> ) -> Void
    {
        if this.config.isEnabled
        {  
            this.AddTaSRecords();
        }
        else
        {
            this.RemoveTaSRecords();
        }
    }

    // private func OnDetach() -> Void
    // {
    //     this.config = null;

    //     this.techGuns = [];
    //     this.smartGuns = [];

    //     this.allguns = [];
    // }


    private func RemoveTaSRecords() -> Void
    {
        // Charge Speed
        for gun in this.techGuns
        {
            this.RemoveItemfromArrayRecord(this.GetTechnicalStatsListRecord(gun)+t".statModifiers", this.chargeTimeBonus);
            TweakDBManager.UpdateRecord(this.GetTechnicalStatsListRecord(gun));
        }

        TweakDBManager.SetFlat(this.BoltBaseRecordID+t".value", 25.0);
        TweakDBManager.UpdateRecord(this.BoltBaseRecordID);

        TweakDBManager.SetFlat(this.BoltBoostRecordID+t".value", 10.0);
        TweakDBManager.UpdateRecord(this.BoltBoostRecordID);

        // Target Lock Speeds
        for gun in this.smartGuns
        {
            this.RemoveItemfromArrayRecord(this.GetSmartGunStatsRecord(gun)+t".statModifiers", this.lockOnBonusADS);
            this.RemoveItemfromArrayRecord(this.GetSmartGunStatsRecord(gun)+t".statModifiers", this.lockOnBonusHip);
            TweakDBManager.UpdateRecord(this.GetSmartGunStatsRecord(gun));
        }
    }

    public func AddTaSRecords() -> Void
    {
        //Charge Speed
        for gun in this.techGuns
        {
            this.AddItemtoArrayRecord(this.GetTechnicalStatsListRecord(gun)+t".statModifiers", this.chargeTimeBonus);
            TweakDBManager.UpdateRecord(this.GetTechnicalStatsListRecord(gun));
        }
        TweakDBManager.SetFlat(this.chargeTimeBonus+t".value", (this.config.chargeTimeMult));
        TweakDBManager.UpdateRecord(this.chargeTimeBonus);

        // mult values for bolt window don't seem  to work :(
        // // Bolt Charge Window
        // TweakDBManager.SetFlat(this.BoltWindowMult+t".value", this.config.chargeBoltWindow);
        // TweakDBManager.UpdateRecord(this.BoltWindowMult);
        // this.AddItemtoArrayRecord(t"NewPerks.Tech_Right_Milestone_3_inline14.effectors", this.BoltWindowMult);
        // TweakDBManager.UpdateRecord(t"NewPerks.Tech_Right_Milestone_3_inline14");

        TweakDBManager.SetFlat(this.BoltBaseRecordID+t".value", 25.0*this.config.chargeBoltWindow);
        TweakDBManager.UpdateRecord(this.BoltBaseRecordID);

        TweakDBManager.SetFlat(this.BoltBoostRecordID+t".value", 10.0*this.config.chargeBoltWindow);
        TweakDBManager.UpdateRecord(this.BoltBoostRecordID);

        // min Charge Time
        TweakDBManager.SetFlat(this.chargeTimeMinID+t".min", this.config.chargeTimeMin);
        TweakDBManager.UpdateRecord(this.chargeTimeMinID);

        TweakDBManager.SetFlat(this.baseChargeTimeMinID+t".min", this.config.chargeTimeMin);
        TweakDBManager.UpdateRecord(this.baseChargeTimeMinID);

        // min lock on time
        TweakDBManager.SetFlat(this.lockOnTimeHip+t".min", this.config.lockOnTimeMin);
        TweakDBManager.UpdateRecord(this.lockOnTimeHip);

        TweakDBManager.SetFlat(this.lockOnTimeADS+t".min", this.config.lockOnTimeMin);
        TweakDBManager.UpdateRecord(this.lockOnTimeADS);


        TweakDBManager.SetFlat(this.targetAqusitionRangeMult+t".value", this.config.aquisitionRangeMult);
        TweakDBManager.UpdateRecord(this.targetAqusitionRangeMult);

        for gun in this.smartGuns
        {
            // Target Lock Speeds
            this.AddItemtoArrayRecord(this.GetSmartGunStatsRecord(gun)+t".statModifiers", this.lockOnBonusADS);
            this.AddItemtoArrayRecord(this.GetSmartGunStatsRecord(gun)+t".statModifiers", this.lockOnBonusHip);

            // aquisiton time
            this.AddItemtoArrayRecord(this.GetSmartGunStatsRecord(gun)+t".statModifiers", this.targetAqusitionRangeMult);

            TweakDBManager.UpdateRecord(this.GetSmartGunStatsRecord(gun));
        }
        TweakDBManager.SetFlat(this.lockOnBonusADS+t".value", this.config.lockOnTimeADSMult);
        TweakDBManager.UpdateRecord(this.lockOnBonusADS);
        TweakDBManager.SetFlat(this.lockOnBonusHip+t".value", this.config.lockOnTimeHipMult);
        TweakDBManager.UpdateRecord(this.lockOnBonusHip);
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

    private func GetTechnicalStatsListRecord(record : ref<WeaponItem_Record>) -> TweakDBID
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
        let newTechStatsRecID : TweakDBID = recordID+t"_Technical_Stats";
        TweakDBManager.CreateRecord(newTechStatsRecID, n"gamedataStatModifierGroup_Record");
        TweakDBManager.UpdateRecord(newTechStatsRecID);
        this.AddItemtoArrayRecord(recordID+t".statModifierGroups", newTechStatsRecID);
        TweakDBManager.UpdateRecord(recordID+t".statModifierGroups");
        FTLogError(s"[Configurable sTasT] Weapon record \(TDBID.ToStringDEBUG(recordID)) did not include Technical_Stats record. Generated Placeholder.");
        return newTechStatsRecID;
    }

    private func GetSmartGunStatsRecord(record : ref<WeaponItem_Record>) -> TweakDBID
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
        let newSmartGunStatsRecID : TweakDBID = recordID+t"_SmartGun_Stats";
        TweakDBManager.CreateRecord(newSmartGunStatsRecID, n"gamedataStatModifierGroup_Record");
        TweakDBManager.UpdateRecord(newSmartGunStatsRecID);
        this.AddItemtoArrayRecord(recordID+t".statModifierGroups", newSmartGunStatsRecID);
        FTLogError(s"[Configurable sTasT] Weapon record \(TDBID.ToStringDEBUG(recordID)) did not include SmartGun_Stats record. Generated Placeholder.");
        return newSmartGunStatsRecID;
    }

    private func AddItemtoArrayRecord(tdbidOfArray : TweakDBID, tdbidtoPush : TweakDBID) -> Void
    {
        let recordIDList : array<TweakDBID>;
        recordIDList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(tdbidOfArray));
        if !ArrayContains(recordIDList, tdbidtoPush) 
        {
            ArrayPush(recordIDList, tdbidtoPush);

            TweakDBManager.SetFlat(tdbidOfArray, recordIDList);
        }
    }

    private func RemoveItemfromArrayRecord(tdbidOfArray : TweakDBID, tdbidtoRemove : TweakDBID) -> Void
    {
        let recordIDList : array<TweakDBID>;
        recordIDList = FromVariant<array<TweakDBID>>(TweakDBInterface.GetFlat(tdbidOfArray));
        if ArrayContains(recordIDList, tdbidtoRemove) 
        {
            ArrayRemove(recordIDList, tdbidtoRemove);

            TweakDBManager.SetFlat(tdbidOfArray, recordIDList);
        }
    }
}

