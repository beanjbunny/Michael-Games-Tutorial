extends ItemEffect
class_name ItemEffectHeal

@export var heal_amount : int = 1
@export var audio : AudioStream

func use() -> void:
	GlobalPlayerManager.player.update_hp(heal_amount)
	PauseMenu.play_audio(audio)
