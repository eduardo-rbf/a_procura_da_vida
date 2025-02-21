extends Node

signal dialog_initiated

#example
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
	}
}

func _ready():
	dialog_initiated.emit(_dialog_data)
	pass
