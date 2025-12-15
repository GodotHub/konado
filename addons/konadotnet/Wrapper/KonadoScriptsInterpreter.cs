#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public sealed partial class KonadoScriptsInterpreter : RefCounted
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/ks/ks_interpreter.gd";

    private KonadoScriptsInterpreter() { }

    public new static KonadoScriptsInterpreter Bind(GodotObject godotObject)
    {
        if (godotObject is KonadoScriptsInterpreter instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(KonadoScriptsInterpreter).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (KonadoScriptsInterpreter)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="KonadoScriptsInterpreter"/> class.
    /// </summary>
    /// <param name="flags"></param>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static KonadoScriptsInterpreter Instantiate(Godot.Collections.Dictionary<string, Variant> flags)
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New(flags).AsGodotObject());
    }

    public new static class GDScriptMethodName
    {
        public new static readonly StringName ProcessScriptsToData = "process_scripts_to_data";
        public new static readonly StringName ParseSingleLine = "parse_single_line";
    }

    public KndShot ProcessScriptsToData(string path)
        => KndShot.Bind(Call(GDScriptMethodName.ProcessScriptsToData, [path]).As<Resource>());

    public Dialogue ParseSingleLine(string line, long lineNumber, string path)
        => Dialogue.Bind(Call(GDScriptMethodName.ParseSingleLine, [line, lineNumber, path]).As<Resource>());

}