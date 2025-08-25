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

        private Node targetDialogueManagerNode;
        public GodotObject dialogueManager;

        /// <summary>
        /// 是否已准备好 API，用于检查目标节点是否已找到
        /// </summary>
        public bool isApiReady = false;


        public override void _Ready()
        {
            Instance = this;
            isApiReady = false;

            ApiReady += () =>
            {
                ConnectSignals();
            };

            Callable.From(() => FindTargetNode("/root/KonadoSample/DialogManager")).CallDeferred();
        }

        /// <summary>
        /// 连接信号,当 Konado DialogueManager 节点发出对应信号时，调用对应方法
        /// </summary>
        public void ConnectSignals()
        {
            // 定义需要连接的信号，以及对应的方法
            var signals = new Dictionary<string, StringName>(){
                {"shot_start", MethodName.OnShotStart},
                {"shot_end", MethodName.OnShotEnd},
                {"dialogue_line_start", MethodName.OnDialogueLineStart},
                {"dialogue_line_end", MethodName.OnDialogueLineEnd}
            };
            if (IsApiReady())
            {
                GD.Print("Connecting signals...");
                foreach (var signal in signals)
                {
                    dialogueManager.Connect(signal.Key, new Callable(this, signal.Value));
                }
            }
        }

        private void OnShotStart()
        {
            EmitSignal(SignalName.ShotStart);
        }

        private void OnShotEnd()
        {
            EmitSignal(SignalName.ShotEnd);
        }

        private void OnDialogueLineStart(int lineIndex)
        {
            EmitSignal(SignalName.DialogueLineStart, lineIndex);
        }

        private void OnDialogueLineEnd(int lineIndex)
        {
            EmitSignal(SignalName.DialogueLineEnd, lineIndex);
        }


        /// <summary>
        /// 查找目标节点
        /// </summary>
        /// <param name="nodePath"></param>
        public void FindTargetNode(string nodePath)
        {
            targetDialogueManagerNode = GetNode<Node>(nodePath);

            if (targetDialogueManagerNode != null)
            {
                GD.Print("Target node found: ", targetDialogueManagerNode.Name);

                dialogueManager = targetDialogueManagerNode;

                isApiReady = true;

                EmitSignal(SignalName.ApiReady);
            }
            else
            {
                isApiReady = false;
                GD.PrintErr("Target node not found at path: ", nodePath);
            }
        }

        /// <summary>
        /// 检查 API 是否已准备好
        /// </summary>
        /// <returns></returns>
        public bool IsApiReady()
        {
            if (!isApiReady)
            {
                GD.PrintErr("API is not ready.");
            }
            return isApiReady;
        }

        /// <summary>
        /// 初始化对话，调用 Konado DialogueManager 节点的 init_dialogue 方法
        /// </summary>
        public void InitDialogue()
        {
            if (IsApiReady())
            {
                dialogueManager.Call("init_dialogue");
            }
        }

        /// <summary>
        /// 开始对话，调用 Konado DialogueManager 节点的 start_dialogue 方法
        /// </summary>
        public void StartDialogue()
        {
            if (IsApiReady())
            {
                dialogueManager.Call("start_dialogue");
            }
        }

        /// <summary>
        /// 停止对话，调用 Konado DialogueManager 节点的 stop_dialogue 方法
        /// </summary>
        public void StopDialogue()
        {
            if (IsApiReady())
            {
                dialogueManager.Call("stop_dialogue");
            }
        }

        /// <summary>
        /// 从指定路径加载对话，调用 Konado DialogueManager 节点的 load_dialogue_data_from_path 方法
        /// </summary>
        /// <param name="path"></param>
        public void LoadDialogueShot(string path)
        {
            if (IsApiReady())
            {
                dialogueManager.Call("load_dialogue_data_from_path", path);
            }
        }



    }
}