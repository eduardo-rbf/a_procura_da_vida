extends Node

signal dialog_initiated

var string_sequence = [
	"Bem-vindo! Vamos começar....",
	"Seu dever é proteger a terra",
	"Vamos ao que interessa...",
	"Você deve seguir aos meus comandos passo a passo como eu for dizendo....",
	"Selecione e arraste a seta que aponta para cima 6 vezes e solte ela na caixa vazia a baixo até coletar todos os itens",
	"Após isso aperte no botão Play!"
]

var _dialog_data: Dictionary

func _ready():
	for i in range(string_sequence.size()): 
		_dialog_data[i] = {"faceset": "res://sprites/portraits/Comandante.jpg",
							"dialog": string_sequence[i],
							"title": "Comandante"}
	dialog_initiated.emit(_dialog_data)
	pass
