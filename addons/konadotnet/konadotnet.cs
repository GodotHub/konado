#if TOOLS
using Godot;
using System;
using System.Collections.Generic;

[Tool]
public partial class konadotnet : EditorPlugin
{
	private Dictionary<string, string> _autoloads = new Dictionary<string, string>()
	{
		{"DialogueManagerAPI", "res://addons/konadotnet/api/DialogueManagerAPI.cs"}
	};
	
	public override void _EnterTree()
	{
		GD.Print("Hello from Konadotnet!");

		foreach (var autoload in _autoloads)
		{
			AddAutoloadSingleton(autoload.Key, autoload.Value);
		}


	}

	public override void _ExitTree()
	{
		foreach (var autoload in _autoloads)
		{
			RemoveAutoloadSingleton(autoload.Key);
		}
	}
}
#endif
