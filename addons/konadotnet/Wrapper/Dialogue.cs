#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;
using Konado.Runtime.API;

namespace Konado.Wrapper;

public partial class Dialogue : Resource
{
    private static GDScript _sourceScript;
    private const string SourceScriptPath = "res://addons/konado/scripts/dialogue/dialogue.gd";
    private GodotObject _source;

    public Dialogue(GodotObject source)
    {
        if (source is null || !IsInstanceValid(source))
        {
            throw new System.InvalidOperationException("Source object is not valid!");
        }
        
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        _sourceScript ??= ResourceLoader.Load<GDScript>(SourceScriptPath);
        if (source.GetScript().As<GDScript>() != _sourceScript)
        {
            throw new System.InvalidOperationException("Source Object is not a valid source!");
        }

        _source = source;
    }

    /// <summary>
    /// Create a new instance of the <see cref="Dialogue"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public Dialogue()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        _sourceScript ??= ResourceLoader.Load<GDScript>(SourceScriptPath);
        _source = _sourceScript.New().AsGodotObject();
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
        set => _source.Set(GDScriptPropertyName.DialogType, (int)value);
    }

    public new string BranchId
    {
        get => _source.Get(GDScriptPropertyName.BranchId).As<string>();
        set => _source.Set(GDScriptPropertyName.BranchId, value);
    }

    public new Godot.Collections.Array<Dialogue> BranchDialogue
    {
        get => new(_source.Get(GDScriptPropertyName.BranchDialogue).As<Godot.Collections.Array<Resource>>().Select(r => new Dialogue(r)));
        set => _source.Set(GDScriptPropertyName.BranchDialogue, value);
    }

    public new bool IsBranchLoaded
    {
        get => _source.Get(GDScriptPropertyName.IsBranchLoaded).As<bool>();
        set => _source.Set(GDScriptPropertyName.IsBranchLoaded, value);
    }

    public new string CharacterId
    {
        get => _source.Get(GDScriptPropertyName.CharacterId).As<string>();
        set => _source.Set(GDScriptPropertyName.CharacterId, value);
    }

    public new string DialogueContent
    {
        get => _source.Get(GDScriptPropertyName.DialogueContent).As<string>();
        set => _source.Set(GDScriptPropertyName.DialogueContent, value);
    }

    public new DialogueActor ShowActor
    {
        get => new(_source.Get(GDScriptPropertyName.ShowActor).As<Resource>());
        set => _source.Set(GDScriptPropertyName.ShowActor, value);
    }

    public new string ExitActor
    {
        get => _source.Get(GDScriptPropertyName.ExitActor).As<string>();
        set => _source.Set(GDScriptPropertyName.ExitActor, value);
    }

    public string ChangeStateActor
    {
        get => _source.Get(GDScriptPropertyName.ChangeStateActor).As<string>();
        set => _source.Set(GDScriptPropertyName.ChangeStateActor, value);
    }

    public string TargetMoveChara
    {
        get => _source.Get(GDScriptPropertyName.TargetMoveChara).As<string>();
        set => _source.Set(GDScriptPropertyName.TargetMoveChara, value);
    }

    public Vector2 TargetMovePos
    {
        get => _source.Get(GDScriptPropertyName.TargetMovePos).As<Vector2>();
        set => _source.Set(GDScriptPropertyName.TargetMovePos, value);
    }

    public Godot.Collections.Array<DialogueChoice> Choices
    {
        get => new(_source.Get(GDScriptPropertyName.Choices).As<Godot.Collections.Array<Resource>>().Select(r => new DialogueChoice(r)));
        set => _source.Set(GDScriptPropertyName.Choices, value);
    }

    public new string BgmName
    {
        get => _source.Get(GDScriptPropertyName.BgmName).As<string>();
        set => _source.Set(GDScriptPropertyName.BgmName, value);
    }

    public new string VoiceId
    {
        get => _source.Get(GDScriptPropertyName.VoiceId).As<string>();
        set => _source.Set(GDScriptPropertyName.VoiceId, value);    
    }

    public new string SoundeffectName
    {
        get => _source.Get(GDScriptPropertyName.SoundeffectName).As<string>();
        set => _source.Set(GDScriptPropertyName.SoundeffectName, value);
    }

    public new string BackgroundImageName
    {
        get => _source.Get(GDScriptPropertyName.BackgroundImageName).As<string>();
        set => _source.Set(GDScriptPropertyName.BackgroundImageName, value);
    }

    public new ActingInterface.BackgroundTransitionEffectsType BackgroundToggleEffects
    {
        get => _source.Get(GDScriptPropertyName.BackgroundToggleEffects).As<ActingInterface.BackgroundTransitionEffectsType>();
        set => _source.Set(GDScriptPropertyName.BackgroundToggleEffects, (int)value);
    }

    public new string JumpShotId
    {
        get => _source.Get(GDScriptPropertyName.JumpShotId).As<string>();
        set => _source.Set(GDScriptPropertyName.JumpShotId, value);
    }

    public new string LabelNotes
    {
        get => _source.Get(GDScriptPropertyName.LabelNotes).As<string>();
        set => _source.Set(GDScriptPropertyName.LabelNotes, value);
    }

    public new Godot.Collections.Dictionary ActorSnapshots
    {
        get => _source.Get(GDScriptPropertyName.ActorSnapshots).As<Godot.Collections.Dictionary>();
        set => _source.Set(GDScriptPropertyName.ActorSnapshots, value);
    }
}