public class ConfigurableShorterTaStConfig 
{
    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-technical")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-Tech_IsEnabled_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-Tech_IsEnabled_desc")
    public let isEnabled : Bool = true;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-TechGuns")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-TechGuns-ChargeTimeMult_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-TechGuns-ChargeTimeMult_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "2.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let chargeTimeMult: Float = 0.5;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-TechGuns")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-TechGuns-ChargeBoltWindow_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-TechGuns-ChargeBoltWindow_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "4.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let chargeBoltWindow: Float = 1.0;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-TechGuns")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-TechGuns-ChargeTimeMin_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-TechGuns-ChargeTimeMin_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "4.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let chargeTimeMin: Float = 0.0;


    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-SmartGuns")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-SmartGuns-LocOnTimeHip_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-SmartGuns-LocOnTimeHip_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "2.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let lockOnTimeHipMult: Float = 0.5;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-SmartGuns")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-SmartGuns-LocOnTimeADS_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-SmartGuns-LocOnTimeADS_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "2.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let lockOnTimeADSMult: Float = 0.3;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-SmartGuns")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-SmartGuns-AquisitionRangeMult_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-SmartGuns-AquisitionRangeMult_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "2.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let aquisitionRangeMult: Float = 1.0;

    @runtimeProperty("ModSettings.mod", "Configurable_sTaSt")
    @runtimeProperty("ModSettings.category", "Configurable_sTaSt-SmartGuns")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Configurable_sTaSt-SmartGuns-MinLocOnTimeADS_name")
    @runtimeProperty("ModSettings.description", "Configurable_sTaSt-SmartGuns-MinLocOnTimeADS_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "2.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    public let lockOnTimeMin: Float = 0.0;
}