using Godot;
using System;
using Konado.Runtime.API;

using static Konado.Runtime.API.KonadoAPI;
public partial class DialogueManagerAPISample : Node
{
    public override void _Ready()
    {
        DialogueManager.ShotStart += () =>
        {
            GD.Print("Shot Start");
        };

        DialogueManager.ShotEnd += () =>
        {
            GD.Print("Shot End");
        };
        DialogueManager.DialogueLineStart += (int index) =>
        {
            GD.Print(index);
        };
        DialogueManager.DialogueLineEnd += (int index) =>
        {
            GD.Print(index);
        };

        // 等待1秒
        Konado.Runtime.API.KonadoAPI.API.ApiReady += () =>
        {
            GD.Print("API Ready");

            DialogueManager.InitDialogue();
            DialogueManager.StartDialogue();
            //DialogueManagerAPI.Instance.LoadDialogueShot("res://sample/sample_lists/storys/test.ks");
        };


    }

}
