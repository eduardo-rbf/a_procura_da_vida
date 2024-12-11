extends Control

signal cmd_sequence_ready(cmd_sequence)

var command_scene = preload("res://scenes/commands/command_element.tscn")
var commands = Array()
var cmd_sequence = Array()

func _ready() -> void:
	for i in range(4):
		for j in range(6):
			var this_slot: Control = command_scene.instantiate()
			this_slot.position.x = j * 64
			this_slot.position.y = i * 64
			commands.append(this_slot)
			cmd_sequence.append("null")
			add_child(this_slot)
	pass


func _on_reset_pressed() -> void:
	for slot in commands:
		slot.reset()

func _on_trigger_pressed() -> void:
	for i in range(6*4):#matrix size
		cmd_sequence[i] = commands[i].get_action()
	cmd_sequence_ready.emit(cmd_sequence)	
