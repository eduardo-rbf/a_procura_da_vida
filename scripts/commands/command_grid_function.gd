extends Control

# return cmd_sequence at _on_trigger_pressed()
# signal cmd_sequence_ready(cmd_sequence)

var command_scene = preload("res://scenes/commands/command_element.tscn")
var commands = Array()
var cmd_sequence = Array()

func _ready() -> void:
	# Configuração inicial dos comandos
	for i in range(2):
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

func get_sequence() -> Array:
	# Atualiza a sequência de comandos
	for i in range(6 * 2): # Tamanho da matriz
		cmd_sequence[i] = commands[i].get_action()
	return cmd_sequence
