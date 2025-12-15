#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class KndShot : KndData
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/knd_data/shot/knd_shot.gd";

    protected KndShot() { }

    public new static KndShot Bind(GodotObject godotObject)
    {
        if (godotObject is KndShot instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(KndShot).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (KndShot)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="KndShot"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static KndShot Instantiate()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New().AsGodotObject());
    }

    public new static class GDScriptPropertyName
    {
        public new static readonly StringName Name = "name";
        public new static readonly StringName ShotId = "shot_id";
        public new static readonly StringName SourceStory = "source_story";

        public new static readonly StringName DialoguesSourceData = "dialogues_source_data";
        public new static readonly StringName Branches = "branches";
        public new static readonly StringName SourceBranches = "source_branches";
        public new static readonly StringName ActorCharacterMap = "actor_character_map";
    }

    public new string Name
    {
        get => Get(GDScriptPropertyName.Name).As<string>();
        set => Set(GDScriptPropertyName.Name, value);
    }

    public new string ShotId
    {
        get => Get(GDScriptPropertyName.ShotId).As<string>();
        set => Set(GDScriptPropertyName.ShotId, value);
    }

    public new string SourceStory
    {
        get => Get(GDScriptPropertyName.SourceStory).As<string>();
        set => Set(GDScriptPropertyName.SourceStory, value);
    }

    public new Godot.Collections.Array<Godot.Collections.Dictionary> DialoguesSourceData
    {
        get => Get(GDScriptPropertyName.DialoguesSourceData).AsGodotArray<Godot.Collections.Dictionary>();
        set => Set(GDScriptPropertyName.DialoguesSourceData, value);
    }

    public new Godot.Collections.Dictionary Branches
    {
        get => Get(GDScriptPropertyName.Branches).As<Godot.Collections.Dictionary>();
        set => Set(GDScriptPropertyName.Branches, value);
    }

    public new Godot.Collections.Dictionary<string, Godot.Collections.Dictionary> SourceBranches
    {
        get => Get(GDScriptPropertyName.SourceBranches).As<Godot.Collections.Dictionary<string, Godot.Collections.Dictionary>>();
        set => Set(GDScriptPropertyName.SourceBranches, value);
    }

    public new Godot.Collections.Dictionary<string, int> ActorCharacterMap
    {
        get => Get(GDScriptPropertyName.ActorCharacterMap).As<Godot.Collections.Dictionary<string, int>>();
        set => Set(GDScriptPropertyName.ActorCharacterMap, value);
    }    
}