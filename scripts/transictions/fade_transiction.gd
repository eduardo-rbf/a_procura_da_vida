extends ColorRect

func fade_out() -> void:
	show()
	$fade_timer.start()
	$AnimationPlayer.play("fade_out")

func fade_in() -> void:
	show()
	$AnimationPlayer.play("fade_in")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		hide()
