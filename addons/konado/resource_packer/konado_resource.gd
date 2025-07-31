# extends Resource
# class_name KonadoResource

# ## 角色列表
# @export var chara_list: CharacterList
# ## 背景列表
# @export var background_list: BackgroundList
# ## 对话列表
# @export var dialog_data_list: DialogueChapter
# ## BGM列表
# @export var bgm_list: DialogBGMList
# ## 配音资源列表
# @export var voice_list: DialogVoiceList
# ## 音效列表
# @export var soundeffect_list: DialogSoundEffectList

# func get_json_data() -> String:
#     return JSON.stringify([chara_list.get_json_data(), background_list, dialog_data_list, bgm_list, voice_list, soundeffect_list])
