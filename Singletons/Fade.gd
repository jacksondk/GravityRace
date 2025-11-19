extends CanvasLayer

signal first_fade_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene_to_file(target_scene: String) -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	animation_player.play_backwards("fade")
