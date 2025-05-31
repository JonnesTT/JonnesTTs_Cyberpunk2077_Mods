public class AdjustableDetectionDistanceConfig 
{
    @runtimeProperty("ModSettings.mod", "AdjustableDetectionDistance")
    @runtimeProperty("ModSettings.category", "AdjustableDetectionDistance-multipliers")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "AdjustableDetectionDistance-IsEnabled_name")
    @runtimeProperty("ModSettings.description", "AdjustableDetectionDistance-IsEnabled_desc")
    let isEnabled : Bool = true;

    @runtimeProperty("ModSettings.mod", "AdjustableDetectionDistance")
    @runtimeProperty("ModSettings.category", "AdjustableDetectionDistance-multipliers")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "AdjustableDetectionDistance-Mult_name")
    @runtimeProperty("ModSettings.description", "AdjustableDetectionDistance-Mult_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.1")
    @runtimeProperty("ModSettings.max", "10.0")
    @runtimeProperty("ModSettings.dependency", "isEnabled")
    let viewDistanceMultiplier: Float = 1.0;
}