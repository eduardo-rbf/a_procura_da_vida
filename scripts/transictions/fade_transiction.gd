extends ColorRect

func fade_out() -> void:
	show()
	$fade_timer.start()
	$AnimationPlayer.play("fade_out")

func fade_in() -> void:
	show()
	$AnimationPlayer.play("fade_in")
