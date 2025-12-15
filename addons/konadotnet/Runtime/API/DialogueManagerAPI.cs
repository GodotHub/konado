using Godot;
using System;
using System.Collections.Generic;


/// <summary>
/// Konado DialogueManager C# API，用于与 Konado DialogueManager 节点进行交互
/// </summary>
public sealed partial class DialogueManagerAPI : Node
{
    private Node _source;
    public override void _Ready()
    {
        _source = GetNodeOrNull("/root/KonadoSample/DialogManager");
        if (_source == null)
        {
            GD.PrintErr("未找到对话管理器节点。请确保已安装 Konado 插件，并且已初始化对话管理器节点。");
            return;
        }
    }


    public static class GDScriptSignalName
    {
        public static readonly StringName ShotStart = "shot_start";
        public static readonly StringName ShotEnd = "shot_end";
        public static readonly StringName DialogueLineStart = "dialogue_line_start";
        public static readonly StringName DialogueLineEnd = "dialogue_line_end";
    }

    public delegate void ShotStartSignalHandler();
    private ShotStartSignalHandler _shotStartSignal;
    private Callable _shotStartSignalCallable;
    public event ShotStartSignalHandler ShotStart
    {
        add
        {
            if (_shotStartSignal is null)
            {
                _shotStartSignalCallable = Callable.From(() => _shotStartSignal?.Invoke());
                _source.Connect(GDScriptSignalName.ShotStart, _shotStartSignalCallable);
            }
            _shotStartSignal += value;
        }
        remove
        {
            _shotStartSignal -= value;
            if (_shotStartSignal is not null) return;
            _source.Disconnect(GDScriptSignalName.ShotStart, _shotStartSignalCallable);
            _shotStartSignalCallable = default;
        }
    }

    public delegate void ShotEndSignalHandler();
    private ShotEndSignalHandler _shotEndSignal;
    private Callable _shotEndSignalCallable;
    public event ShotEndSignalHandler ShotEnd
    {
        add
        {
            if (_shotEndSignal is null)
            {
                _shotEndSignalCallable = Callable.From(() => _shotEndSignal?.Invoke());
                _source.Connect(GDScriptSignalName.ShotEnd, _shotEndSignalCallable);
            }
            _shotEndSignal += value;
        }
        remove
        {
            _shotEndSignal -= value;
            if (_shotEndSignal is not null) return;
            _source.Disconnect(GDScriptSignalName.ShotEnd, _shotEndSignalCallable);
            _shotEndSignalCallable = default;            
        }
        
    }

    public delegate void DialogueLineStartSignalHandler(long line);
    private DialogueLineStartSignalHandler _dialogueLineStartSignal;
    private Callable _dialogueLineStartSignalCallable;
    public event DialogueLineStartSignalHandler DialogueLineStart
    {
        add
        {
            if (_dialogueLineStartSignal is null)
            {
                _dialogueLineStartSignalCallable = Callable.From((long line) => _dialogueLineStartSignal?.Invoke(line));
                _source.Connect(GDScriptSignalName.DialogueLineStart, _dialogueLineStartSignalCallable);
            }
            _dialogueLineStartSignal += value;
        }
        remove
        {
            _dialogueLineStartSignal -= value;
            if (_dialogueLineStartSignal is not null) return;        
            _source.Disconnect(GDScriptSignalName.DialogueLineStart, _dialogueLineStartSignalCallable);
            _dialogueLineStartSignalCallable = default;
        }
    }

    public delegate void DialogueLineEndSignalHandler(long line);
    private DialogueLineEndSignalHandler _dialogueLineEndSignal;
    private Callable _dialogueLineEndSignalCallable;
    public event DialogueLineEndSignalHandler DialogueLineEnd
    {
        add
        {
            if (_dialogueLineEndSignal is null)
            {
                _dialogueLineEndSignalCallable = Callable.From((long line) => _dialogueLineEndSignal?.Invoke(line));
                _source.Connect(GDScriptSignalName.DialogueLineEnd, _dialogueLineEndSignalCallable);
            }
            _dialogueLineEndSignal += value;
        }
        remove
        {
            _dialogueLineEndSignal -= value;
            if (_dialogueLineEndSignal is not null) return;
            _source.Disconnect(GDScriptSignalName.DialogueLineEnd, _dialogueLineEndSignalCallable);
            _dialogueLineEndSignalCallable = default;            
        }
    }

    public static class GDScriptMethodName
    {
        public static readonly StringName InitDialogue = "init_dialogue";
        public static readonly StringName StartDialogue = "start_dialogue";
        public static readonly StringName StopDialogue = "stop_dialogue";
    }

    /// <summary>
    /// 初始化对话，调用 Konado DialogueManager 节点的 init_dialogue 方法
    /// </summary>
    public void InitDialogue() => _source?.Call(GDScriptMethodName.InitDialogue);
        
    /// <summary>
    /// 开始对话，调用 Konado DialogueManager 节点的 start_dialogue 方法
    /// </summary>
    public void StartDialogue() => _source?.Call(GDScriptMethodName.StartDialogue);

    /// <summary>
    /// 停止对话，调用 Konado DialogueManager 节点的 stop_dialogue 方法
    /// </summary>
    public void StopDialogue() => _source?.Call(GDScriptMethodName.StopDialogue);
}
