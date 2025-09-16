using Godot;
using Konado.Runtime.API;
using System;
using System.Diagnostics;
using System.Threading.Tasks;
using static Konado.Runtime.API.KonadoAPI;
public partial class DatabaseTest : Node
{
    public override async void _Ready()
    {
        var timeWatch = new Stopwatch();
        timeWatch.Start();
        Database.LoadDatabase();

        for (int i = 0; i < 5; i++)
        {
            var id = Database.CreateData("KND_Shot");
            var sub = Database.CreateSubData("KND_Dialogue");
            Database.AddSubSourceData(id, sub["id"].AsInt64(), sub["data"].AsGodotDictionary());
        }

        await Task.Delay(100);

        Database.SaveDatabase();

        timeWatch.Stop();
        GD.Print("测试用时(ms): ", timeWatch.ElapsedMilliseconds);

    }
}
