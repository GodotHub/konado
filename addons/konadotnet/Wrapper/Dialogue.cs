#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;
using Konado.Runtime.API;

namespace Konado.Wrapper;

public partial class Dialogue : Resource
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/scripts/dialogue/dialogue.gd";

    protected Dialogue() { }

    public new static Dialogue Bind(GodotObject godotObject)
    {
        if (godotObject is Dialogue instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(Dialogue).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (Dialogue)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="Dialogue"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static Dialogue Instantiate()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New().AsGodotObject());
    }

    public enum Type
    {
        Start,
        OrdinaryDialog,
        DisplayActor,
        ActorChangeState,
        MoveActor,
        SwitchBackground,
        ExitActor,
        PlayBgm,
        StopBgm,
        PlaySoundEffect,
        ShowChoice,
        Branch,
        JumpTag,
        JumpShot,
        TheEnd,
        Label
    }

    public new static class GDScriptPropertyName
    {
        public new static readonly StringName DialogType = "dialog_type";
        public new static readonly StringName BranchId = "branch_id";
        public new static readonly StringName BranchDialogue = "branch_dialogue";
        public new static readonly StringName IsBranchLoaded = "is_branch_loaded";
        public new static readonly StringName CharacterId = "character_id";
        public new static readonly StringName DialogueContent = "dialogue_content";
        public new static readonly StringName ShowActor = "show_actor";
        public new static readonly StringName ExitActor = "exit_actor";
        public new static readonly StringName ChangeStateActor = "change_state_actor";
        public new static readonly StringName ChangeState = "change_state";
        public new static readonly StringName TargetMoveChara = "target_move_chara";
        public new static readonly StringName TargetMovePos = "target_move_pos";
        public new static readonly StringName Choices = "choices";
        public new static readonly StringName BgmName = "bgm_name";
        public new static readonly StringName VoiceId = "voice_id";
        public new static readonly StringName SoundeffectName = "soundeffect_name";
        public new static readonly StringName BackgroundImageName = "background_image_name";
        public new static readonly StringName BackgroundToggleEffects = "background_toggle_effects";
        public new static readonly StringName JumpShotId = "jump_shot_id";
        public new static readonly StringName LabelNotes = "label_notes";
        public new static readonly StringName ActorSnapshots = "actor_snapshots";
    }

    public new Type DialogueType
    {
        set => Set(GDScriptPropertyName.DialogType, (int)value);
    }

    public new string BranchId
    {
        get => Get(GDScriptPropertyName.BranchId).As<string>();
        set => Set(GDScriptPropertyName.BranchId, value);
    }

    public new Godot.Collections.Array<Dialogue> BranchDialogue
    {
        get => new(Get(GDScriptPropertyName.BranchDialogue).As<Godot.Collections.Array<Resource>>().Select(Bind));
        set => Set(GDScriptPropertyName.BranchDialogue, value);
    }

    public new bool IsBranchLoaded
    {
        get => Get(GDScriptPropertyName.IsBranchLoaded).As<bool>();
        set => Set(GDScriptPropertyName.IsBranchLoaded, value);
    }

    public new string CharacterId
    {
        get => Get(GDScriptPropertyName.CharacterId).As<string>();
        set => Set(GDScriptPropertyName.CharacterId, value);
    }

    public new string DialogueContent
    {
        get => Get(GDScriptPropertyName.DialogueContent).As<string>();
        set => Set(GDScriptPropertyName.DialogueContent, value);
    }

    public new DialogueActor ShowActor
    {
        get => DialogueActor.Bind(Get(GDScriptPropertyName.ShowActor).As<Resource>());
        set => Set(GDScriptPropertyName.ShowActor, value);
    }

    public new string ExitActor
    {
        get => Get(GDScriptPropertyName.ExitActor).As<string>();
        set => Set(GDScriptPropertyName.ExitActor, value);
    }

    public string ChangeStateActor
    {
        get => Get(GDScriptPropertyName.ChangeStateActor).As<string>();
        set => Set(GDScriptPropertyName.ChangeStateActor, value);
    }

    public string TargetMoveChara
    {
        get => Get(GDScriptPropertyName.TargetMoveChara).As<string>();
        set => Set(GDScriptPropertyName.TargetMoveChara, value);
    }

    public Vector2 TargetMovePos
    {
        get => Get(GDScriptPropertyName.TargetMovePos).As<Vector2>();
        set => Set(GDScriptPropertyName.TargetMovePos, value);
    }

    public Godot.Collections.Array<DialogueChoice> Choices
    {
        get => new(Get(GDScriptPropertyName.Choices).As<Godot.Collections.Array<Resource>>().Select(DialogueChoice.Bind));
        set => Set(GDScriptPropertyName.Choices, value);
    }

    public new string BgmName
    {
        get => Get(GDScriptPropertyName.BgmName).As<string>();
        set => Set(GDScriptPropertyName.BgmName, value);
    }

    public new string VoiceId
    {
        get => Get(GDScriptPropertyName.VoiceId).As<string>();
        set => Set(GDScriptPropertyName.VoiceId, value);    
    }

    public new string SoundeffectName
    {
        get => Get(GDScriptPropertyName.SoundeffectName).As<string>();
        set => Set(GDScriptPropertyName.SoundeffectName, value);
    }

    public new string BackgroundImageName
    {
        get => Get(GDScriptPropertyName.BackgroundImageName).As<string>();
        set => Set(GDScriptPropertyName.BackgroundImageName, value);
    }

    public new ActingInterface.BackgroundTransitionEffectsType BackgroundToggleEffects
    {
        get => Get(GDScriptPropertyName.BackgroundToggleEffects).As<ActingInterface.BackgroundTransitionEffectsType>();
        set => Set(GDScriptPropertyName.BackgroundToggleEffects, (int)value);
    }

    public new string JumpShotId
    {
        get => Get(GDScriptPropertyName.JumpShotId).As<string>();
        set => Set(GDScriptPropertyName.JumpShotId, value);
    }

    public new string LabelNotes
    {
        get => Get(GDScriptPropertyName.LabelNotes).As<string>();
        set => Set(GDScriptPropertyName.LabelNotes, value);
    }

    public new Godot.Collections.Dictionary ActorSnapshots
    {
        get => Get(GDScriptPropertyName.ActorSnapshots).As<Godot.Collections.Dictionary>();
        set => Set(GDScriptPropertyName.ActorSnapshots, value);
    }
}