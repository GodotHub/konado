using Godot;

namespace Konado.Runtime.API;

public sealed partial class KonadoAPI : Node
{
    public bool IsApiReady { get; private set; }
    public static KonadoAPI API { get; private set; }
    public static DialogueManagerAPI DialogueManager { get; private set; }

    public override void _Ready()
    {
        if (IsModuleLoaded())
            return;

        API = this;
        DialogueManager = new DialogueManagerAPI();

        DialogueManager.Name = "DialogueManager";

        AddChild(DialogueManager);

        IsApiReady = true;
    }

    private bool IsModuleLoaded()
        => GetNodeOrNull("DialogueManager") != null;
}