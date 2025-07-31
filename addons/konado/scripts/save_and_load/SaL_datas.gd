extends Node

var save_data : Dictionary = {
	"metadata" : {
		"SaL_system_version" : "1.0",#开发用水印
		"timestamp" : "0"#时间戳
	},
	"game_data" : {
		"chara_disc" : "chara_disc",#角色用字典
		"background_id" : "background_id",#背景列表数据
		#"chapter_id" : "chapter_id.replace("\r","")",#章节id，注释掉防止报错
		"bgm_id" : "bgm_id",#bgm id
		"bgm_progress" : "bgm_progress",#bgm进度
		"voice_id" : "voice_id",#配音列表
		"sound_effect_id" : "sound_effect_id",#音效列表
		"curline" : "curline"#当前对话
	},
	"Writer" : {
		"This_is" : "KamikiMayumi"#水印，别管
	}
	}
