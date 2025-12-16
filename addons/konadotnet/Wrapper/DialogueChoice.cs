#pragma warning disable CS0109
using System.Linq;
using System.Reflection;
using Godot;

namespace Konado.Wrapper;

public partial class DialogueChoice : Resource
{
    private static GDScript _sourceScript;
    private const string SourceScriptPath = "res://addons/konado/scripts/dialogue/dialogue_choice.gd";
    private GodotObject _source;

    public DialogueChoice(GodotObject source)
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
    /// Create a new instance of the <see cref="DialogueChoice"/> class.
    /// </summary>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public DialogueChoice()
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
        public new static readonly StringName ChoiceText = "choice_text";
        public new static readonly StringName JumpTag = "jump_tag";
    }

    public new string ChoiceText
    {
        get => _source.Get(GDScriptPropertyName.ChoiceText).As<string>();
        set => _source.Set(GDScriptPropertyName.ChoiceText, value);
    }

    public new string JumpTag
    {
        get => _source.Get(GDScriptPropertyName.JumpTag).As<string>();
        set => _source.Set(GDScriptPropertyName.JumpTag, value);    
    }
}