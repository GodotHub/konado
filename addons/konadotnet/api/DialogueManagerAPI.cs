using Godot;
using System;


namespace Konado.Runtime.API
{
    /// <summary>
    /// Konado DialogueManager C# API，用于与 Konado DialogueManager 节点进行交互
    /// </summary>
    public partial class DialogueManagerAPI : Node
    {
        private Node targetDialogueManagerNode;
        public GodotObject dialogueManager;

        /// <summary>
        /// 是否已准备好 API，用于检查目标节点是否已找到
        /// </summary>
        public bool isApiReady = false;


        public override void _Ready()
        {
            isApiReady = false;
            Callable.From(() => FindTargetNode("/root/KonadoSample/DialogManager")).CallDeferred();
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

                InitDialogue();
                StartDialogue();
                LoadDialogueShot("res://sample/sample_lists/storys/test.ks");

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

        public void InitDialogue()
        {
            if (IsApiReady())
            {
                dialogueManager.Call("init_dialogue");
            }
        }

        public void StartDialogue()
        {
            if (IsApiReady())
            {
                dialogueManager.Call("start_dialogue");
            }
        }

        public void LoadDialogueShot(string path)
        {
            if (IsApiReady())
            {
                dialogueManager.Call("load_dialogue_data_from_path", path);
            }
        }

    }
}