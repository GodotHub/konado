using Godot;
using System;
using System.Collections.Generic;

namespace Konado.Runtime.API;

public static class Database
{
    private static Node _source;

    private static Node Source
    {
        get
        {
            _source ??= ((SceneTree)Engine.GetMainLoop()).Root.GetNodeOrNull("KND_Database");
            if (_source == null)
            {
                GD.PrintErr("Konado Database not found.");
            }
            return _source;
        }
    }

    public static IReadOnlyDictionary<long, string> Data => Source?.Get("knd_data_dic").AsGodotDictionary<long, string>();

    public static int CreateData(string type) => (int)Source?.Call("create_data", type).AsInt32();

    public static void DeleteData(long id) => Source?.Call("delete_data", id);

    public static Godot.Collections.Dictionary GetData(long id) => Source?.Call("get_data", id).AsGodotDictionary();

    public static void SetData(long id, string property, Variant value) => Source?.Call("set_data", id, property, value);

    public static void SaveDatabase() => Source?.Call("save_database");

    public static void LoadDatabase() => Source?.Call("load_database");
    
}
