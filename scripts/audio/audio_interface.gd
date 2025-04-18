extends Node
class_name DialogAudioInterface

## 音频接口类，可以控制BGM和角色对话

# 信号
# 播放BGM成功
signal finish_playbgm
# 播放语音成功
signal finish_playvoice
# 播放音效成功
signal finish_playsoundeffect

## 语音播放完成
signal voice_finish_playing


@export var bgm_name: String

## BGM播放器
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer
## 对话播放器
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
## 音效播放器
@onready var sound_effect_player: AudioStreamPlayer = $SoundEffectPlayer

## 播放BGM的方法（循环播放）
func play_bgm(audio: AudioStream, audio_id: String) -> void:
	if bgm_player.is_playing():
		bgm_player.stop()
	bgm_player.stream=audio
	bgm_player.play()
	bgm_name = audio_id
	finish_playbgm.emit()
	bgm_player.finished.connect(func():
		bgm_player.play())
		
	
## 停止播放BGM的方法
func stop_bgm() -> void:
	if bgm_player.is_playing():
		bgm_player.stop()

## 播放语音的方法
func play_voice(audio: AudioStream) -> void:
	if voice_player.is_playing():
		voice_player.stop()
	voice_player.stream=audio
	voice_player.play()
	finish_playvoice.emit()
	await voice_player.finished
	voice_finish_playing.emit()

## 停止播放语音的方法
func stop_voice() -> void:
	voice_player.stop()
	
## 播放音效的方法
func play_sound_effect(audio: AudioStream) -> void:
	sound_effect_player.stop()
	sound_effect_player.stream=audio
	sound_effect_player.play()
	finish_playsoundeffect.emit()
	
	
