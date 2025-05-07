extends Node

var save_data : Dictionary = {
	"metadata": {  # 元数据
		"timestamp": "2025-05-07 12:30:00",#时间戳
	},
	"game_data": {  # 核心游戏数据
		"chara" : "0",#角色列表数据
		"background" : "0",#背景列表数据
		"dialog_data": {#对话数据
			"chap_id" : "0",#章节ID
			"chap_name" : "0",#章节名称
			"dialogs" : "0"#对话列表
		},
		"bgm" : "0",#bgm列表
		"voice" : "0",#配音列表
		"sound_effect" : "0",#音效列表
		"curline" : "0"
	},
}
