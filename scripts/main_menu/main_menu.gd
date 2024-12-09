extends Control
class_name Menu

@onready var v_container: VBoxContainer = get_node("GUI/VContainer")

var button_type = null
var scene = null

func _ready() -> void:
	# Música
	$music_player.play(0)

	# Animações
	$GUI/CenterContainer/Logo/AnimationPlayer.play("idle")
	$spr_earth_planet/AnimationPlayer.play("idle")
	$spr_lava_planet/AnimationPlayer.play("idle")
	$spr_shooting_star/AnimationPlayer.play("moving")
	
	for button in v_container.get_children():
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button.name))
		
		
func on_button_pressed(button_name: String) -> void:
	$"Fade Transiction".fade_out()
	button_type = button_name
	
	match button_name:
		"NewGame":
			scene = "res://scenes/levels/level_1.tscn"
			
		"LevelSelector":
			scene =  "res://scenes/level_selector.tscn"
			
		"Quit":
			get_tree().quit()

func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file(scene)


func _on_new_game_mouse_entered() -> void:
	$button_hover_player.play(0)


func _on_level_selector_mouse_entered() -> void:
	$button_hover_player.play(0)


func _on_quit_mouse_entered() -> void:
	$button_hover_player.play(0)
