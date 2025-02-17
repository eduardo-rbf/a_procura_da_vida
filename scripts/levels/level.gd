extends Node2D

class_name Level

##Refer to TestLevel's LevelScript for documentation.

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog/dialog.tscn")
var coin_hud: PackedScene = preload("res://scenes/hud/coin_hud.tscn")

@onready var Player = $Player
@onready var Map = $Map
@onready var Commands = $Commands

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://sprites/portraits/placeholder.jpg",
		"dialog": "Olá, seja bem vindo!",
		"title": "O Desenvolvedor"
	},

	1: {
		"faceset": "res://sprites/portraits/placeholder.jpg",
		"dialog": "Espero que você aproveite o game :)",
		"title": "O Desenvolvedor"
	},
}

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

	var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
	
	_connect_level_buttons()

func _connect_level_buttons() -> void:
	var fases_button = get_node_or_null("HUD/fases_button")
	if fases_button:
		fases_button.pressed.connect(_on_fases_button_pressed)
	else:
		print("ERRO: Botão 'fases_button' não encontrado!")

func _on_fases_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_selector/level_selector.tscn")
	return

func level_reset():
	pass
	
