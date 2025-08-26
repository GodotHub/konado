using Godot;
using System;
using Konado.Runtime.API;

public partial class DialogueManagerAPISample : Node
{
    public override void _Ready()
    {
        DialogueManagerAPI.Instance.ShotStart += () =>
        {
            GD.Print("Shot Start");
        };

        DialogueManagerAPI.Instance.ShotEnd += () =>
        {
            GD.Print("Shot End");
        };
        DialogueManagerAPI.Instance.DialogueLineStart += (int index) =>
        {
            GD.Print(index);
        };
        DialogueManagerAPI.Instance.DialogueLineEnd += (int index) =>
        {
            GD.Print(index);
        };

        // 等待1秒
        DialogueManagerAPI.Instance.ApiReady += () =>
        {
            GD.Print("API Ready");

            DialogueManagerAPI.Instance.InitDialogue();
            DialogueManagerAPI.Instance.StartDialogue();
            //DialogueManagerAPI.Instance.LoadDialogueShot("res://sample/sample_lists/storys/test.ks");
        };


    }

}
