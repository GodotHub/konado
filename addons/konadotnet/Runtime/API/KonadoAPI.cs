using Godot;

namespace Konado.Runtime.API;

public sealed partial class KonadoAPI : Node
{
    public bool IsApiReady { get; private set; }
    public static KonadoAPI API { get; private set; }
    public static DialogueManagerAPI DialogueManagerApi { get; private set; }

    public override void _Ready()
    {
        if (IsModuleLoaded())
            return;

        API = this;
        DialogueManagerApi = new DialogueManagerAPI();

        DialogueManagerApi.Name = "DialogueManagerAPI";

        AddChild(DialogueManagerApi);

        IsApiReady = true;
    }

    private bool IsModuleLoaded()
        => GetNodeOrNull("DialogueManagerAPI") != null;
}