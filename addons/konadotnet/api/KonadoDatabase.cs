using Godot;
using System.Collections.Generic;

namespace Konado.Runtime.API;

public partial class KonadoDatabase : Node
{

    private Node _source;

    public override void _Ready()
    {
        _source = GetNodeOrNull("/root/KND_Database");
        if (_source == null)
        {
            GD.PrintErr("未找到数据库节点。请确保已安装 Konado 插件，并且数据库已初始化。");
        }
    }
    
    public IReadOnlyDictionary<long, string> Data => _source?.Get("knd_data_dic").AsGodotDictionary<long, string>();

    public long CreateData(string type) => (long)_source?.Call("create_data", type).AsInt64();

    public void DeleteData(long id) => _source?.Call("delete_data", id);

    public Godot.Collections.Dictionary GetData(long id) => _source?.Call("get_data", id).AsGodotDictionary();

    public void SetData(long id, string property, Variant value) => _source?.Call("set_data", id, property, value);

    public void SaveDatabase() => _source?.Call("save_database");

    public void LoadDatabase() => _source?.Call("load_database");
    
}
