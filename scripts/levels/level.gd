extends Node2D

class_name Level

##Refer to TestLevel's LevelScript for documentation.

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/dialog/dialog.tscn")

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

	$"Fade Transiction".fade_in()
	Player.map = Map
	Commands.Player = Player

	#var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	#_new_dialog.data = _dialog_data
	#_hud.add_child(_new_dialog)

func level_reset():
	pass
	
