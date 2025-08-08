@tool
extends Node
class_name KonadoScriptGenerator

# 脚本生成器
func generate_script_from_data(shot_data: DialogueShot) -> String:
    if not shot_data:
        push_error("无效的DialogueShot数据")
        return ""
        
    var script_lines = PackedStringArray()
    
    # 添加元数据行
    script_lines.append("shot_id " + shot_data.shot_id)
    
	# 遍历所有对话
    for dialog in shot_data.dialogs:
        script_lines.append(_generate_dialog_line(dialog))
        
    return "\n".join(script_lines)

# 生成单个对话行
func _generate_dialog_line(dialog: Dialogue) -> String:
    match dialog.dialog_type:
        Dialogue.Type.LABEL:
            return "#" + dialog.label_notes
            
        Dialogue.Type.Switch_Background:
            var line = "background " + dialog.background_image_name
            if dialog.background_toggle_effects != ActingInterface.EffectsType.None:
                line += " " + _get_effect_name(dialog.background_toggle_effects)
            return line
        Dialogue.Type.Display_Actor:
            if dialog.show_actor:
                var actor = dialog.show_actor
                var line = "actor show %s %s at %d %d scale %.1f" % [
					actor.character_name,
					actor.character_state,
					actor.actor_position.x,
					actor.actor_position.y,
					actor.actor_scale
				]
                if actor.actor_mirror:
                    line += " mirror"
                return line
        Dialogue.Type.Exit_Actor:
            return "actor exit " + dialog.exit_actor
        Dialogue.Type.Actor_Change_State:
            return "actor change %s %s" % [dialog.change_state_actor, dialog.change_state]
        Dialogue.Type.Move_Actor:
            return "actor move %s %d %d" % [
				dialog.target_move_chara,
				dialog.target_move_pos.x,
				dialog.target_move_pos.y
			]
        Dialogue.Type.Play_BGM:
            return "play bgm " + dialog.bgm_name
        Dialogue.Type.Play_SoundEffect:
            return "play se " + dialog.soundeffect_name
        Dialogue.Type.Stop_BGM:
            return "stop bgm"
        Dialogue.Type.Show_Choice:
            var line = "choice"
            for choice in dialog.choices:
                line += ' "' + choice.choice_text + '" ' + choice.jump_tag
            return line
        Dialogue.Type.Tag:
            var lines = PackedStringArray()
            lines.append("branch " + dialog.branch_id)
            # 添加分支内的对话（缩进4个空格）
            for branch_dialog in dialog.branch_dialogue:
                lines.append("    " + _generate_dialog_line(branch_dialog))
            return "\n".join(lines)
        Dialogue.Type.JUMP:
            return "jump " + dialog.jump_data_name
        Dialogue.Type.Ordinary_Dialog:
            var line = '"' + dialog.character_id + '" "' + dialog.dialog_content + '"'
            if dialog.voice_id:
                line += " " + dialog.voice_id
            return line
        Dialogue.Type.START:
            return "start"
        Dialogue.Type.THE_END:
            return "end"
    return ""

# 获取效果名称
func _get_effect_name(effect: ActingInterface.EffectsType) -> String:
    match effect:
        ActingInterface.EffectsType.EraseEffect: return "erase"
        ActingInterface.EffectsType.BlindsEffect: return "blinds"
        ActingInterface.EffectsType.WaveEffect: return "wave"
        ActingInterface.EffectsType.FadeInAndOut: return "fade"
        _: return ""