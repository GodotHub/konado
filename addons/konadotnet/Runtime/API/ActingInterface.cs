using Godot;

namespace Konado.Runtime.API;

public sealed partial class ActingInterface : Control
{
    public enum BackgroundTransitionEffectsType
    {
        NoneEffect,
        EraseEffect,
        BlindsEffect,
        WaveEffect,
        AlphaFadeEffect,
        VortexSwapEffect,
        WindmillEffect,
        CyberGlitchEffect
    }
}