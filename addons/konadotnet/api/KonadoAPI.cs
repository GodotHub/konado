using Godot;

namespace Konado.Runtime.API;

public partial class KonadoAPI : Node
{
    public bool IsApiReady { get; private set; }
    public static KonadoAPI API { get; private set; }
    public static DialogueManagerAPI DialogueManager { get; private set; }
    public static KonadoDatabase Database { get; private set; }

    public override void _Ready()
    {
        if (IsModuleLoaded())
            return;

        API = this;
        DialogueManager = new DialogueManagerAPI();
        Database = new KonadoDatabase();

        DialogueManager.Name = "DialogueManager";
        Database.Name = "KonadoDatabase";

        AddChild(DialogueManager);
        AddChild(Database);

        IsApiReady = true;
    }

    private bool IsModuleLoaded()
        => GetNodeOrNull("DialogueManager") != null && GetNodeOrNull("KonadoDatabase") != null;
}