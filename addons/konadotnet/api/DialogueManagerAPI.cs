using Godot;
using System;
using System.Collections.Generic;


namespace Konado.Runtime.API
{
    /// <summary>
    /// Konado DialogueManager C# API，用于与 Konado DialogueManager 节点进行交互
    /// </summary>
    public partial class DialogueManagerAPI : Node
    {
        [Signal]
        public delegate void ShotStartEventHandler();

        [Signal]
        public delegate void ShotEndEventHandler();

        [Signal]
        public delegate void DialogueLineStartEventHandler(int lineIndex);

        [Signal]
        public delegate void DialogueLineEndEventHandler(int lineIndex);

        private Node _source;
        private Dictionary<string, Callable> _signals = [];
        public override void _Ready()
        {
            _source = GetNodeOrNull("/root/KonadoSample/DialogManager");
            if (_source == null)
            {
                GD.PrintErr("未找到对话管理器节点。请确保已安装 Konado 插件，并且已初始化对话管理器节点。");
            }
            ConnectSignals();
        }

        public override void _ExitTree()
        {
            foreach (var signal in _signals)
            {
                if (_source.IsConnected(signal.Key, signal.Value))
                {
                    _source.Disconnect(signal.Key, signal.Value);
                }                
            }     
        }

        private void ConnectSignals()
        {            
            _signals = new Dictionary<string, Callable>(){
                {"shot_start", Callable.From(OnShotStart)},
                {"shot_end", Callable.From(OnShotEnd)},
                {"dialogue_line_start", Callable.From<int>(OnDialogueLineStart)},
                {"dialogue_line_end", Callable.From<int>(OnDialogueLineEnd)}
            };
            GD.Print("Connecting signals...");
            foreach (var signal in _signals)
            {
                _source.Connect(signal.Key, signal.Value);
            }
        }

        private void OnShotStart() => EmitSignalShotStart();

        private void OnShotEnd() => EmitSignalShotEnd();

        private void OnDialogueLineStart(int lineIndex) => EmitSignalDialogueLineStart(lineIndex);

        private void OnDialogueLineEnd(int lineIndex) => EmitSignalDialogueLineEnd(lineIndex);

        /// <summary>
        /// 初始化对话，调用 Konado DialogueManager 节点的 init_dialogue 方法
        /// </summary>
        public void InitDialogue() => _source?.Call("init_dialogue");
            
        /// <summary>
        /// 开始对话，调用 Konado DialogueManager 节点的 start_dialogue 方法
        /// </summary>
        public void StartDialogue() => _source?.Call("start_dialogue");

        /// <summary>
        /// 停止对话，调用 Konado DialogueManager 节点的 stop_dialogue 方法
        /// </summary>
        public void StopDialogue() => _source?.Call("stop_dialogue");

        /// <summary>
        /// 从指定路径加载对话，调用 Konado DialogueManager 节点的 load_dialogue_data_from_path 方法
        /// </summary>
        /// <param name="path"></param>
        public void LoadDialogueShot(string path) => _source?.Call("load_dialogue_data_from_path", path);



    }
}