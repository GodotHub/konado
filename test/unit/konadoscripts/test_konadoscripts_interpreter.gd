################################################################################
# Project: Konado
# File: test_konadoscripts_interpreter.gd
# Author: DSOE1024
# Created: 2025-08-20
# Last Modified: 2025-08-20
# Description:
#    Konado脚本解释器单元测试脚本，基于GutTest框架
#    应该在每次更新解释器代码后运行此脚本以验证其正确性
################################################################################

extends GutTest

var interpreter: KonadoScriptsInterpreter


func before_all():
	interpreter = KonadoScriptsInterpreter.new()
	interpreter.init_insterpreter({"allow_custom_suffix": true, "enable_actor_validation": true})


func after_all():
	interpreter.free()


func test_init_interpreter_with_valid_flags():
	var vf_interpreter = KonadoScriptsInterpreter.new()
	var result = vf_interpreter.init_insterpreter(
		{"allow_custom_suffix": false, "enable_actor_validation": true}
	)
	assert_true(result, "解释器flags正确")
	assert_true(vf_interpreter.is_init, "解释器应该成功初始化")
	assert_false(vf_interpreter.allow_custom_suffix, "allow_custom_suffix 应该设置为 false")
	assert_true(vf_interpreter.enable_actor_validation, "enable_actor_validation 应该设置为 true")
	vf_interpreter.free()


func test_init_interpreter_with_invalid_flags():
	var vf_interpreter = KonadoScriptsInterpreter.new()
	var result = vf_interpreter.init_insterpreter(
		{"allow_custom_suffix": "invalid", "enable_actor_validation": 123}
	)
	assert_false(result, "解释器flags应该错误")
	assert_false(vf_interpreter.is_init, "解释器应该没有初始化")
	vf_interpreter.free()


func test_process_scripts_with_nonexistent_file():
	# 测试处理不存在的文件
	var result = interpreter.process_scripts_to_data("nonexistent.ks")
	assert_null(result, "处理不存在的文件应该返回 null")


func test_process_scripts_with_invalid_suffix():
	# 测试处理无效后缀的文件
	interpreter.allow_custom_suffix = false

	# 创建临时文件
	var temp_file = "user://test_invalid_suffix.txt"
	var file = FileAccess.open(temp_file, FileAccess.WRITE)
	file.store_string("shot_id test_shot\n")
	file.close()

	var result = interpreter.process_scripts_to_data(temp_file)
	assert_null(result, "处理无效后缀的文件应该返回 null")

	# 清理
	DirAccess.remove_absolute(temp_file)


func test_parse_metadata_valid():
	# 测试解析有效的元数据
	var lines = ["shot_id test_shot_id", "# 这是一个注释"]

	var result = interpreter._parse_metadata(lines, "test_path")
	assert_eq(result.size(), 1, "应该解析出一个元数据项")
	assert_eq(result[0], "test_shot_id", "shot_id 应该匹配")


func test_parse_metadata_invalid():
	# 测试解析无效的元数据
	var lines = ["invalid_meta test_value", "# 这是一个注释"]

	var result = interpreter._parse_metadata(lines, "test_path")
	assert_eq(result.size(), 0, "无效元数据应该返回空数组")


func test_parse_label():
	# 测试解析标签行
	var line = "# 这是一个标签注释"
	var dialog = Dialogue.new()

	var result = interpreter._parse_label(line, dialog)
	assert_true(result, "应该成功解析标签行")
	assert_eq(dialog.dialog_type, Dialogue.Type.LABEL, "对话类型应该是 LABEL")
	assert_eq(dialog.label_notes, " 这是一个标签注释", "标签内容应该匹配")


func test_parse_background():
	# 测试解析背景行
	var line = "background bg_image fade"
	var dialog = Dialogue.new()

	var result = interpreter._parse_background(line, dialog)
	assert_true(result, "应该成功解析背景行")
	assert_eq(dialog.dialog_type, Dialogue.Type.Switch_Background, "对话类型应该是 Switch_Background")
	assert_eq(dialog.background_image_name, "bg_image", "背景图片名称应该匹配")
	# 这里可以进一步检查效果类型


func test_parse_actor_show():
	# 测试解析演员显示行
	var line = "actor show chara1 normal 0 100 200 1.0"
	var dialog = Dialogue.new()

	var result = interpreter._parse_actor(line, dialog)
	assert_true(result, "应该成功解析演员行")
	assert_eq(dialog.dialog_type, Dialogue.Type.Display_Actor, "对话类型应该是 Display_Actor")
	assert_not_null(dialog.show_actor, "show_actor 不应该为空")


func test_parse_dialog():
	# 测试解析对话行
	var line = '"character1" "Hello world!" voice_001'
	var dialog = Dialogue.new()

	var result = interpreter._parse_dialog(line, dialog)
	assert_true(result, "应该成功解析对话行")
	assert_eq(dialog.dialog_type, Dialogue.Type.Ordinary_Dialog, "对话类型应该是 Ordinary_Dialog")
	assert_eq(dialog.character_id, "character1", "角色ID应该匹配")
	assert_eq(dialog.dialog_content, "Hello world!", "对话内容应该匹配")
	assert_eq(dialog.voice_id, "voice_001", "语音ID应该匹配")


func test_parse_choice():
	# 测试解析选项行
	var line = 'choice "Option 1" tag1 "Option2" tag2'
	var dialog = Dialogue.new()

	var result = interpreter._parse_choice(line, dialog)
	assert_true(result, "应该成功解析选项行")
	assert_eq(dialog.dialog_type, Dialogue.Type.Show_Choice, "对话类型应该是 Show_Choice")
	assert_eq(dialog.choices.size(), 2, "应该有两个选项")
	assert_eq(dialog.choices[0].choice_text, "Option 1", "第一个选项文本应该匹配")
	assert_eq(dialog.choices[0].jump_tag, "tag1", "第一个选项跳转标签应该匹配")
	assert_eq(dialog.choices[1].choice_text, "Option2", "第二个选项文本应该匹配")
	assert_eq(dialog.choices[1].jump_tag, "tag2", "第二个选项跳转标签应该匹配")


func test_parse_branch():
	# 测试解析分支行
	var line = "branch branch_tag"
	var dialog = Dialogue.new()

	var result = interpreter._parse_branch(line, dialog)
	assert_true(result, "应该成功解析分支行")
	assert_eq(dialog.dialog_type, Dialogue.Type.Branch, "对话类型应该是 Branch")
	assert_eq(dialog.branch_id, "branch_tag", "分支ID应该匹配")


func test_parse_jumpshot():
	# 测试解析跳转行
	var line = "jump next_shot"
	var dialog = Dialogue.new()

	var result = interpreter._parse_jumpshot(line, dialog)
	assert_true(result, "应该成功解析跳转行")
	assert_eq(dialog.dialog_type, Dialogue.Type.JUMP_Shot, "对话类型应该是 JUMP_Shot")
	assert_eq(dialog.jump_shot_id, "next_shot", "跳转ID应该匹配")


func test_parse_start():
	# 测试解析开始行
	var line = "start"
	var dialog = Dialogue.new()

	var result = interpreter._parse_start(line, dialog)
	assert_true(result, "应该成功解析开始行")
	assert_eq(dialog.dialog_type, Dialogue.Type.START, "对话类型应该是 START")


func test_parse_end():
	# 测试解析结束行
	var line = "end"
	var dialog = Dialogue.new()

	var result = interpreter._parse_end(line, dialog)
	assert_true(result, "应该成功解析结束行")
	assert_eq(dialog.dialog_type, Dialogue.Type.THE_END, "对话类型应该是 THE_END")


func test_parse_line_with_unknown_syntax():
	# 测试解析未知语法
	var line = "unknown_syntax param1 param2"

	var result = interpreter.parse_line(line, 1, "test_path")
	assert_null(result, "未知语法应该返回 null")


# 集成测试，测试完整脚本处理
func test_process_complete_script():
	var temp_file = "res://test/unit/konadoscripts/test_shot.ks"

	# 初始化解释器
	interpreter.init_insterpreter({})

	# 处理脚本
	var result: DialogueShot = interpreter.process_scripts_to_data(temp_file)
	assert_not_null(result, "应该成功处理脚本")
	assert_eq(result.shot_id, "test_shot", "shot_id 应该匹配")
	assert_eq(result.dialogs.size(), 5, "应该有5个对话")
	assert_eq(result.branchs.size(), 2, "应该有两个分支")
