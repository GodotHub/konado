using Godot;
using Konado.Runtime.API;
using System;

using static Konado.Runtime.API.KonadoAPI;
public partial class DatabaseTest : Node
{
    public override void _Ready()
    {
        for (int i = 0; i < 3; i++)
        {
            Database.CreateData("KND_Character");
        }
        foreach (var kvp in Database.Data)
        {
            GD.Print($"【CS Test】ID: {kvp.Key}, Name: {kvp.Value}");
            GD.Print("【CS Test】", Database.GetData(kvp.Key));
            Database.SetData(kvp.Key, "name", "New Name");
            GD.Print("【CS Test】", Database.GetData(kvp.Key));
        }


    }
}
