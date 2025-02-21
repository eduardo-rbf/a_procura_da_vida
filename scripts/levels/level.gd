extends Node2D

class_name Level

##Refer to TestLevel's LevelScript for documentation.

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog/dialog.tscn")
var coin_hud: PackedScene = preload("res://scenes/hud/coin_hud.tscn")

@onready var Player = $Player
@onready var Map = $Map
@onready var Commands = $Commands

#LevelScript as dialog coordinator.

@export_category("Objects")
@export var _hud: CanvasLayer = null

func _ready() -> void:
	Player.map = Map
	Commands.Player = Player
	if _hud:
		var coin_hud_instance = coin_hud.instantiate()
		coin_hud_instance.reset_coins()
	else:
		print("Erro: _hud não foi configurado corretamente no editor.")

	$"Fade Transiction".fade_in()
	
	_connect_level_buttons()

func _on_dialog_initiated(dialog_data):
	var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = dialog_data
	_hud.add_child(_new_dialog)

func _connect_level_buttons() -> void:
	var fases_button = get_node_or_null("HUD/fases_button")
	if fases_button:
		fases_button.pressed.connect(_on_fases_button_pressed)
	else:
		print("ERRO: Botão 'fases_button' não encontrado!")

func _on_fases_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_selector/level_selector.tscn")
	return

func level_reset():#this should be a better place to reset the player and coins and stuff
	pass
	


func _on_commands_exec_finished() -> void:
	pass # Replace with function body.
