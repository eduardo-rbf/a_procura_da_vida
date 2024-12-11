extends Control

signal cmd_sequence_ready(cmd_sequence)

var command_scene = preload("res://scenes/commands/command_element.tscn")
var commands = Array()
var cmd_sequence = Array()

# Referência ao player
var player: Area2D

func _ready() -> void:
	var parent_node = get_parent().get_parent() # deve ter um jeito melhor de fazer isso
	player = parent_node.get_node("Player") if parent_node.has_node("Player") else null

	if not player:
		print("Player não encontrado! Verifique a estrutura de nós.")
	else:
		print("Player encontrado: ", player.name)

	# Configuração inicial dos comandos
	for i in range(4):
		for j in range(6):
			var this_slot: Control = command_scene.instantiate()
			this_slot.position.x = j * 64
			this_slot.position.y = i * 64
			commands.append(this_slot)
			cmd_sequence.append("null")
			add_child(this_slot)

func _on_reset_pressed() -> void:
	# Reseta todos os slots de comando
	for slot in commands:
		slot.reset()

	# Reseta a posição e rotação do player, se encontrado
	if player:
		player.reset_position()
		
	else:
		print("Não foi possível resetar o player, pois ele não foi encontrado.")

func _on_trigger_pressed() -> void:
	# Atualiza a sequência de comandos
	for i in range(6 * 4): # Tamanho da matriz
		cmd_sequence[i] = commands[i].get_action()
	cmd_sequence_ready.emit(cmd_sequence)
