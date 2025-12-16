#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class KndData : Resource
{
    private static GDScript _sourceScript;
    private const string SourceScriptPath = "res://addons/konado/knd_data/knd_data.gd";
    private GodotObject _source;

    public KndData(GodotObject source)
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
    /// Create a new instance of the <see cref="KndData"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public KndData()
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
        public new static readonly StringName Type = "type";
        public new static readonly StringName Love = "love";
        public new static readonly StringName Tip = "tip";
    }

    public new string Type
    {
        get => _source.Get(GDScriptPropertyName.Type).As<string>();
        set => _source.Set(GDScriptPropertyName.Type, value);
    }

    public new bool Love
    {
        get => _source.Get(GDScriptPropertyName.Love).As<bool>();
        set => _source.Set(GDScriptPropertyName.Love, value);
    }

    public new string Tip
    {
        get => _source.Get(GDScriptPropertyName.Tip).As<string>();
        set => _source.Set(GDScriptPropertyName.Tip, value);
    }
}