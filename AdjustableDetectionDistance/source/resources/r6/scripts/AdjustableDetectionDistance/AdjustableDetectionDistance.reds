@addField(PlayerPuppet)
let AdjustableDetectionDistanceConfig : ref<AdjustableDetectionDistanceConfig>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();
    this.AdjustableDetectionDistanceConfig = new AdjustableDetectionDistanceConfig();
}

public class AdjustableDetectionDistance extends ScriptableService 
{
    protected let config : ref<AdjustableDetectionDistanceConfig>;
    protected let RegularDistanceRecords : ref<DetectionDistanceRecords>;
    protected let m100DistanceRecordIDs : ref<DetectionDistanceRecords>;
    protected let m200DistanceRecordIDs : ref<DetectionDistanceRecords>;
    protected let m300DistanceRecordIDs : ref<DetectionDistanceRecords>;




    private cb func OnLoad() 
    {
        GameInstance.GetCallbackSystem()
        .RegisterCallback(n"Session/BeforeStart", this, n"OnLoadSave");
        this.RegularDistanceRecords = new DetectionDistanceRecords();
        this.RegularDistanceRecords.recordIDs =         
        [ 
            t"Senses.DefaultDetectionCurve.maxDistance", 
            t"Senses.StealthDetectionCurve.maxDistance", 
            t"Senses.AttentionDetectionCurve.maxDistance", 
            t"Senses.SniperAttentionDetectionCurve", 
            t"Senses.SniperAttentionDetectionCurve.maxDistance", 
            t"Senses.SniperDefaultDetectionCurve.maxDistance", 
            t"Senses.SniperStealthDetectionCurve.maxDistance"
        ];
        this.RegularDistanceRecords.baseDistance = Cast<Uint16>(30u) ;

        this.m100DistanceRecordIDs = new DetectionDistanceRecords();
        this.m100DistanceRecordIDs.recordIDs =
        [
            t"Senses.SniperRelaxed50m_inline0.maxDistance",
            t"Senses.SniperRelaxed50m_inline1.maxDistance",
            t"Senses.SniperRelaxed50m_inline2.maxDistance",
            t"Senses.SniperCombat50m_inline0.maxDistance",
            t"Senses.SniperCombat50m_inline1.maxDistance",
            t"Senses.SniperCombat50m_inline2.maxDistance"
        ];
        this.m100DistanceRecordIDs.baseDistance = Cast<Uint16>(100u) ;

        this.m200DistanceRecordIDs = new DetectionDistanceRecords();
        this.m200DistanceRecordIDs.recordIDs =
        [
           t"Senses.SniperCombat100m_inline2.maxDistance",
           t"Senses.SniperCombat100m_inline3.maxDistance",
           t"Senses.SniperCombat100m_inline4.maxDistance",
           t"Senses.SniperRelaxed100m_inline0.maxDistance",
           t"Senses.SniperRelaxed100m_inline1.maxDistance",
           t"Senses.SniperRelaxed100m_inline2.maxDistance"
        ];
        this.m200DistanceRecordIDs.baseDistance = Cast<Uint16>(200u) ;

        this.m300DistanceRecordIDs = new DetectionDistanceRecords();
        this.m300DistanceRecordIDs.recordIDs =
        [
            t"Senses.SniperRelaxed150m_inline0.maxDistance",
            t"Senses.SniperRelaxed150m_inline1.maxDistance",
            t"Senses.SniperRelaxed150m_inline2.maxDistance",
            t"Senses.SniperCombat150m_inline2.maxDistance",
            t"Senses.SniperCombat150m_inline3.maxDistance",
            t"Senses.SniperCombat150m_inline4.maxDistance"
        ];
        this.m300DistanceRecordIDs.baseDistance = Cast<Uint16>(300u) ;
    }


    private cb func OnLoadSave( event : ref<GameSessionEvent> ) -> Void
    {
        // set values
        this.config = new AdjustableDetectionDistanceConfig();

        if this.config.isEnabled
        {  
            this.SetMultipliedValues(this.RegularDistanceRecords, this.config.viewDistanceMultiplier);
            this.SetMultipliedValues(this.m100DistanceRecordIDs, this.config.viewDistanceMultiplier);
            this.SetMultipliedValues(this.m200DistanceRecordIDs, this.config.viewDistanceMultiplier);
            this.SetMultipliedValues(this.m300DistanceRecordIDs, this.config.viewDistanceMultiplier);

        }
        else
        {
            this.SetMultipliedValues(this.RegularDistanceRecords, 1);
            this.SetMultipliedValues(this.m100DistanceRecordIDs, 1);
            this.SetMultipliedValues(this.m200DistanceRecordIDs, 1);
            this.SetMultipliedValues(this.m300DistanceRecordIDs, 1);
        }
    }

    private func OnDetach() -> Void
    {
        this.config = null;
        this.RegularDistanceRecords = null;
        this.m100DistanceRecordIDs = null;
        this.m200DistanceRecordIDs = null;
        this.m300DistanceRecordIDs = null;
    }

    private func SetMultipliedValues(recordIDList : ref<DetectionDistanceRecords>,  multiplier : Float) -> Void
    {
        let newRange : Float;
        newRange = Cast<Float>(recordIDList.baseDistance) * multiplier;
        for recordID in recordIDList.recordIDs 
        {
            TweakDBManager.SetFlat(recordID, newRange);
            TweakDBManager.UpdateRecord(recordID);
        };
    }

}

private class DetectionDistanceRecords
{
    private let baseDistance : Uint16;
    private let recordIDs : array<TweakDBID>;
}