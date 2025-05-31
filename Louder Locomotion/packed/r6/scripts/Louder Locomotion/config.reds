public class LouderLocomotionConfig {

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_SoundDistanceMult")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_SoundDistanceMultToggle_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_SoundDistanceMultToggle_desc")
    let soundDistanceMultToggle : Bool = true;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_SoundDistanceMult")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_SoundDistanceMultWalk_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_SoundDistanceMultWalk_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "10.0")
    @runtimeProperty("ModSettings.dependency", "soundDistanceMultToggle")
    let SoundDistanceMultWalk: Float = 2.0;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_SoundDistanceMult")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_SoundDistanceMultRun_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_SoundDistanceMultRun_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "10.0")
    @runtimeProperty("ModSettings.dependency", "soundDistanceMultToggle")
    let SoundDistanceMultRun: Float = 2.0;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_SoundDistanceMult")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_SoundDistanceMultLanding_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_SoundDistanceMultLanding_desc")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.0")
    @runtimeProperty("ModSettings.max", "10.0")
    @runtimeProperty("ModSettings.dependency", "soundDistanceMultToggle")
    let SoundDistanceMultLanding: Float = 1.0;

    // @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    // @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_IsStealth")
    // @runtimeProperty("ModSettings.category.order", "2")
    // @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_WalkIsStealth_name")
    // @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_WalkIsStealth_desc")
    // let WalkIsStealth : Bool = true;

    // @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    // @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_IsStealth")
    // @runtimeProperty("ModSettings.category.order", "2")
    // @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_RunIsStealth_name")
    // @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_RunIsStealth_desc")
    // let RunIsStealth : Bool = false;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion_JumpSoundsToggle_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion_JumpSoundsToggle_desc")
    let JumpSoundsToggle : Bool = true;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion-JumpRegularSound_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion-JumpRegularSound_desc")
    @runtimeProperty("ModSettings.displayValues.None", "Mod-Louder_Locomotion-JumpSound_none")
    @runtimeProperty("ModSettings.displayValues.Walk", "Mod-Louder_Locomotion-JumpSound_walk")
    @runtimeProperty("ModSettings.displayValues.Run", "Mod-Louder_Locomotion-JumpSound_run")
    @runtimeProperty("ModSettings.dependency", "JumpSoundsToggle")
    let JumpRegularSound : SoundBroadcasts = SoundBroadcasts.None;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion-JumpChargeSound_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion-JumpChargeSound_desc")
    @runtimeProperty("ModSettings.displayValues.None", "Mod-Louder_Locomotion-JumpSound_none")
    @runtimeProperty("ModSettings.displayValues.Walk", "Mod-Louder_Locomotion-JumpSound_walk")
    @runtimeProperty("ModSettings.displayValues.Run", "Mod-Louder_Locomotion-JumpSound_run")
    @runtimeProperty("ModSettings.dependency", "JumpSoundsToggle")
    let JumpChargeSound : SoundBroadcasts = SoundBroadcasts.Walk;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion-JumpDoubleSound_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion-JumpDoubleSound_desc")
    @runtimeProperty("ModSettings.displayValues.None", "Mod-Louder_Locomotion-JumpSound_none")
    @runtimeProperty("ModSettings.displayValues.Walk", "Mod-Louder_Locomotion-JumpSound_walk")
    @runtimeProperty("ModSettings.displayValues.Run", "Mod-Louder_Locomotion-JumpSound_run")
    @runtimeProperty("ModSettings.dependency", "JumpSoundsToggle")
    let JumpDoubleSound : SoundBroadcasts = SoundBroadcasts.Run;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion-JumpHoverSound_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion-JumpHoverSound_desc")
    @runtimeProperty("ModSettings.displayValues.None", "Mod-Louder_Locomotion-JumpSound_none")
    @runtimeProperty("ModSettings.displayValues.Walk", "Mod-Louder_Locomotion-JumpSound_walk")
    @runtimeProperty("ModSettings.displayValues.Run", "Mod-Louder_Locomotion-JumpSound_run")
    @runtimeProperty("ModSettings.dependency", "JumpSoundsToggle")
    let JumpHoverSound : SoundBroadcasts = SoundBroadcasts.None;

    @runtimeProperty("ModSettings.mod", "Louder_Locomotion")
    @runtimeProperty("ModSettings.category", "Mod-Louder_Locomotion_JumpSounds")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Mod-Louder_Locomotion-DodgeSound_name")
    @runtimeProperty("ModSettings.description", "Mod-Louder_Locomotion-DodgeSound_desc")
    @runtimeProperty("ModSettings.displayValues.None", "Mod-Louder_Locomotion-JumpSound_none")
    @runtimeProperty("ModSettings.displayValues.Walk", "Mod-Louder_Locomotion-JumpSound_walk")
    @runtimeProperty("ModSettings.displayValues.Run", "Mod-Louder_Locomotion-JumpSound_run")
    @runtimeProperty("ModSettings.dependency", "JumpSoundsToggle")
    let DodgeSound : SoundBroadcasts = SoundBroadcasts.Run;


    public static func Init() -> ref<LouderLocomotionConfig> {
    let self: ref<LouderLocomotionConfig> = new LouderLocomotionConfig();
    return self;
    } 
}