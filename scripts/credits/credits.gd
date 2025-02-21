extends Control

func _ready() -> void:
	$music_player.play(0)
	
	for button in get_tree().get_nodes_in_group("Button"):
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button.name))

func on_button_pressed(button_name: String) -> void:
	if button_name == "Menu":
		await $"Fade Transiction".fade_out()
		var _change_level: bool = get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
		return
		

func _on_menu_hover() -> void:
	$button_hover_player.play(0)
