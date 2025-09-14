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
        public static DialogueManagerAPI Instance { get; private set; }

        /// <summary>
        /// API 准备就绪信号，当 API 准备就绪时触发
        /// </summary>
        [Signal]
        public delegate void ApiReadyEventHandler();

        [Signal]
        public delegate void ShotStartEventHandler();

        [Signal]
        public delegate void ShotEndEventHandler();

        [Signal]
        public delegate void DialogueLineStartEventHandler(int lineIndex);

        [Signal]
        public delegate void DialogueLineEndEventHandler(int lineIndex);

        private GodotObject _dialogueManager;

        /// <summary>
        /// 检查 API 是否已准备好
        /// </summary>
        /// <returns></returns>
        public bool IsApiReady
        {
            get
            {
                if (!_isApiReady)
                {
                    GD.PrintErr("API is not ready.");
                }
                return _isApiReady;
            }
        }

        /// <summary>
        /// 是否已准备好 API，用于检查目标节点是否已找到
        /// </summary>
        private bool _isApiReady = false;

        private DialogueManagerAPI() { }

        public override void _Ready()
        {
            Instance = this;
            _isApiReady = false;

            ApiReady += ConnectSignals;

            Callable.From(() => FindTargetNode("/root/KonadoSample/DialogManager")).CallDeferred();
        }

        /// <summary>
        /// 连接信号,当 Konado DialogueManager 节点发出对应信号时，调用对应方法
        /// </summary>
        private void ConnectSignals()
        {
            // 定义需要连接的信号，以及对应的方法
            var signals = new Dictionary<string, StringName>(){
                {"shot_start", MethodName.OnShotStart},
                {"shot_end", MethodName.OnShotEnd},
                {"dialogue_line_start", MethodName.OnDialogueLineStart},
                {"dialogue_line_end", MethodName.OnDialogueLineEnd}
            };
            if (IsApiReady)
            {
                GD.Print("Connecting signals...");
                foreach (var signal in signals)
                {
                    _dialogueManager.Connect(signal.Key, new Callable(this, signal.Value));
                }
            }
        }

        private void OnShotStart() => EmitSignalShotStart();

        private void OnShotEnd() => EmitSignalShotEnd();

        private void OnDialogueLineStart(int lineIndex) => EmitSignalDialogueLineStart(lineIndex);

        private void OnDialogueLineEnd(int lineIndex) => EmitSignalDialogueLineEnd(lineIndex);

        /// <summary>
        /// 查找目标节点
        /// </summary>
        /// <param name="nodePath"></param>
        private void FindTargetNode(string nodePath)
        {
            var node = GetNode<Node>(nodePath);

            if (node != null)
            {
                GD.Print("Target node found: ", node.Name);

                _dialogueManager = node;

                _isApiReady = true;

                EmitSignalApiReady();
            }
            else
            {
                _isApiReady = false;
                GD.PrintErr("Target node not found at path: ", nodePath);
            }
        }

        /// <summary>
        /// 初始化对话，调用 Konado DialogueManager 节点的 init_dialogue 方法
        /// </summary>
        public void InitDialogue() => _dialogueManager?.Call("init_dialogue");
            
        /// <summary>
        /// 开始对话，调用 Konado DialogueManager 节点的 start_dialogue 方法
        /// </summary>
        public void StartDialogue() => _dialogueManager?.Call("start_dialogue");

        /// <summary>
        /// 停止对话，调用 Konado DialogueManager 节点的 stop_dialogue 方法
        /// </summary>
        public void StopDialogue() => _dialogueManager?.Call("stop_dialogue");

        /// <summary>
        /// 从指定路径加载对话，调用 Konado DialogueManager 节点的 load_dialogue_data_from_path 方法
        /// </summary>
        /// <param name="path"></param>
        public void LoadDialogueShot(string path) => _dialogueManager?.Call("load_dialogue_data_from_path", path);



    }
}