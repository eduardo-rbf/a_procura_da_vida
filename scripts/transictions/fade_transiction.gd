extends ColorRect

signal fade_finished

func fade_out():
	show()
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	return fade_finished

func fade_in():
	show()
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	return fade_finished


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		hide()
