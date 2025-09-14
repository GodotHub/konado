using Godot;

namespace Konado.Runtime.API;

public partial class KonadoAPI : Node
{
    [Signal]
    public delegate void ApiReadyEventHandler();
    public static KonadoAPI API { get; private set; }
    public static DialogueManagerAPI DialogueManager { get; private set; }
    public static KonadoDatabase Database { get; private set; }

    public override void _Ready()
    {
        API = this;
        DialogueManager = new DialogueManagerAPI();
        Database = new KonadoDatabase();

        DialogueManager.Name = "DialogueManager";
        Database.Name = "KonadoDatabase";

        AddChild(DialogueManager);
        AddChild(Database);

        EmitSignalApiReady();
    }
}