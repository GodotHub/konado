#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class KndData : Resource
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/knd_data/knd_data.gd";

    protected KndData() { }

    public new static KndData Bind(GodotObject godotObject)
    {
        if (godotObject is KndData instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(KndData).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (KndData)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="KndData"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static KndData Instantiate()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New().AsGodotObject());
    }

    public new static class GDScriptPropertyName
    {
        public new static readonly StringName Type = "type";
        public new static readonly StringName Love = "love";
        public new static readonly StringName Tip = "tip";
    }

    public new string Type
    {
        get => Get(GDScriptPropertyName.Type).As<string>();
        set => Set(GDScriptPropertyName.Type, value);
    }

    public new bool Love
    {
        get => Get(GDScriptPropertyName.Love).As<bool>();
        set => Set(GDScriptPropertyName.Love, value);
    }

    public new string Tip
    {
        get => Get(GDScriptPropertyName.Tip).As<string>();
        set => Set(GDScriptPropertyName.Tip, value);
    }
}