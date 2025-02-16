extends Control

signal cmd_ready(cmd_pack)

var command_scene = preload("res://scenes/commands/command_element.tscn")
#Vetor linear de elementos de comando na grade
var commands = Array()
#Vetor linear de comandos prontos da grade principal
var cmd_sequence = Array()
#Dicionário de vetores principal, F1 e F2
var cmd_pack = Dictionary()

@onready var cmd_f1 = $"../CommandGridF1"
@onready var cmd_f2 = $"../CommandGridF2"

#Movido para commands.gd, referencia por variável externa.
# Referência ao player
#var player: Area2D

func _ready() -> void:
	# Configuração inicial dos comandos
	for i in range(3):
		for j in range(6):
			var this_slot: Control = command_scene.instantiate()
			this_slot.position.x = j * 64
			this_slot.position.y = i * 64
			commands.append(this_slot)
			cmd_sequence.append("null")
			add_child(this_slot)
			
	cmd_pack["main"] = cmd_sequence
	cmd_pack["f1"] = cmd_f1.get_sequence()
	cmd_pack["f2"] = cmd_f2.get_sequence()

func _on_reset_pressed() -> void:
	print("[at:command_grid.gd::_on_reset_pressed]" + "Emitir sinal de reset para o nível (player, objetos)")
	# Reseta todos os slots de comando
	for slot in commands:
		slot.reset()

func _on_trigger_pressed() -> void:
	# Atualiza a sequência de comandos
	for i in range(6 * 3): # Tamanho da matriz
		cmd_sequence[i] = commands[i].get_action()
	cmd_pack["main"] = cmd_sequence
	cmd_pack["f1"] = cmd_f1.get_sequence()
	cmd_pack["f2"] = cmd_f2.get_sequence()
	#print("[at:command_grid.gd::_on_trigger_pressed()]", cmd_pack)
	cmd_ready.emit(cmd_pack)
