extends Resource
class_name Character

enum zodiac_signs{
	Unknown,
	Aries_白羊座,
	Taurus_金牛座,
	Gemini_双子座,
	Cancer_巨蟹座,
	Leo_狮子座,
	Virgo_处女座,
	Libra_天秤座,
	Scorpio_天蝎座,
	Sagittarius_射手座,
	Capricorn_摩羯座,
	Aquarius_水瓶座,
	Pisces_双鱼座
}

enum gender{
	Unknown,
	Girl,
	Boy
}
@export_group("角色基本信息")
## 角色ID
@export var chara_id: String
## 角色姓名
@export var chara_name: String
## 角色性别
@export var chara_gender: gender
## 角色生日
@export var chara_birthday: String
## 角色年龄
@export_range(1, 100, 1) var age: int
## 角色标记颜色
@export var tag_color: Color
@export_group("角色属性信息")
## 角色介绍
@export_multiline var chara_description: String
## CV姓名
@export var cv_name: String
## 角色能力
@export var chara_ability: String
## 角色星座
@export var chara_zodiac_signs: zodiac_signs
@export_group("角色看板 & 状态")
## 角色看板立绘
@export var chara_kanban: Texture
## 角色状态图集
@export var chara_status: Array[CharacteStatus]
@export_group("角色社交信息")
## 角色网名
@export var nick: String
## 角色社交媒体头像
@export var avatar: Texture
@export_group("角色变量")
## 角色好感度
@export var chara_favor: int = 0
