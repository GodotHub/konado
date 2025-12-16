#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class KndShot : KndData
{
    private static GDScript _sourceScript;
    private const string SourceScriptPath = "res://addons/konado/knd_data/shot/knd_shot.gd";
    private GodotObject _source;


    public KndShot(GodotObject source)
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
    /// Create a new instance of the <see cref="KndShot"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public KndShot()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        _sourceScript ??= ResourceLoader.Load<GDScript>(SourceScriptPath);
        _source = _sourceScript.New().AsGodotObject();
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
        get => _source.Get(GDScriptPropertyName.Name).As<string>();
        set => _source.Set(GDScriptPropertyName.Name, value);
    }

    public new string ShotId
    {
        get => _source.Get(GDScriptPropertyName.ShotId).As<string>();
        set => _source.Set(GDScriptPropertyName.ShotId, value);
    }

    public new string SourceStory
    {
        get => _source.Get(GDScriptPropertyName.SourceStory).As<string>();
        set => _source.Set(GDScriptPropertyName.SourceStory, value);
    }

    public new Godot.Collections.Array<Godot.Collections.Dictionary> DialoguesSourceData
    {
        get => _source.Get(GDScriptPropertyName.DialoguesSourceData).AsGodotArray<Godot.Collections.Dictionary>();
        set => _source.Set(GDScriptPropertyName.DialoguesSourceData, value);
    }

    public new Godot.Collections.Dictionary Branches
    {
        get => _source.Get(GDScriptPropertyName.Branches).As<Godot.Collections.Dictionary>();
        set => _source.Set(GDScriptPropertyName.Branches, value);
    }

    public new Godot.Collections.Dictionary<string, Godot.Collections.Dictionary> SourceBranches
    {
        get => _source.Get(GDScriptPropertyName.SourceBranches).As<Godot.Collections.Dictionary<string, Godot.Collections.Dictionary>>();
        set => _source.Set(GDScriptPropertyName.SourceBranches, value);
    }

    public new Godot.Collections.Dictionary<string, int> ActorCharacterMap
    {
        get => _source.Get(GDScriptPropertyName.ActorCharacterMap).As<Godot.Collections.Dictionary<string, int>>();
        set => _source.Set(GDScriptPropertyName.ActorCharacterMap, value);
    }    
}