#pragma warning disable CS0109
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class DialogueActor : Resource
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/scripts/dialogue/dialogue_actor.gd";

    protected DialogueActor() { }

    public new static DialogueActor Bind(GodotObject godotObject)
    {
        if (godotObject is DialogueActor instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(DialogueActor).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (DialogueActor)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="DialogueActor"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static DialogueActor Instantiate()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New().AsGodotObject());
    }

    public new static class GDScriptPropertyName
    {
        public new static readonly StringName CharacterName = "character_name";
        public new static readonly StringName CharacterState = "character_state";
        public new static readonly StringName ActorPosition = "actor_position";
        public new static readonly StringName ActorScale = "actor_scale";
        public new static readonly StringName ActorMirror = "actor_mirror";
    }

    public new string CharacterName
    {
        get => Get(GDScriptPropertyName.CharacterName).As<string>();
        set => Set(GDScriptPropertyName.CharacterName, value);
    }

    public new string CharacterState
    {
        get => Get(GDScriptPropertyName.CharacterState).As<string>();
        set => Set(GDScriptPropertyName.CharacterState, value);
    }

    public new Vector2 ActorPosition
    {
        get => Get(GDScriptPropertyName.ActorPosition).As<Vector2>();
        set => Set(GDScriptPropertyName.ActorPosition, value);
    }

    public new Vector2 ActorScale
    {
        get => Get(GDScriptPropertyName.ActorScale).As<Vector2>();
        set => Set(GDScriptPropertyName.ActorScale, value);
    }

    public new bool ActorMirror
    {
        get => Get(GDScriptPropertyName.ActorMirror).As<bool>();
        set => Set(GDScriptPropertyName.ActorMirror, value);
    }
}