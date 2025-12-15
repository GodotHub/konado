#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class DialogueChoice : Resource
{
    private static CSharpScript _wrapperScriptAsset;
    private const string SourceScriptPath = "res://addons/konado/scripts/dialogue/dialogue_choice.gd";

    protected DialogueChoice() { }

    public new static DialogueChoice Bind(GodotObject godotObject)
    {
        if (godotObject is DialogueChoice instance)
            return instance;

        if (_wrapperScriptAsset is null)
        {
            var scriptPathAttribute = typeof(DialogueChoice).GetCustomAttributes<ScriptPathAttribute>().FirstOrDefault()
                ?? throw new System.InvalidOperationException();

            _wrapperScriptAsset = ResourceLoader.Load<CSharpScript>(scriptPathAttribute.Path);
        }

        var instanceId = godotObject.GetInstanceId();
        godotObject.SetScript(_wrapperScriptAsset);
        return (DialogueChoice)InstanceFromId(instanceId);
    }

    /// <summary>
    /// Create a new instance of the <see cref="KonadoScriptsInterpreter"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public new static DialogueChoice Instantiate()
    {
        if (!ResourceLoader.Exists(SourceScriptPath))
        {
            throw new System.InvalidOperationException("Source script not found!");
        }

        return Bind(ResourceLoader.Load<GDScript>(SourceScriptPath).New().AsGodotObject());
    }

    public new static class GDScriptPropertyName
    {
        public new static readonly StringName ChoiceText = "choice_text";
        public new static readonly StringName JumpTag = "jump_tag";
    }

    public new string ChoiceText
    {
        get => Get(GDScriptPropertyName.ChoiceText).As<string>();
        set => Set(GDScriptPropertyName.ChoiceText, value);
    }

    public new string JumpTag
    {
        get => Get(GDScriptPropertyName.JumpTag).As<string>();
        set => Set(GDScriptPropertyName.JumpTag, value);    
    }
}