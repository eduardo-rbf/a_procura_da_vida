extends Node

@export var Player: Node2D
var test: int = 2

var cmd_counter = 0
var commands = Array()
var cmd_over = false
var cmd_busy = false

func _unhandled_input(_event):
	#if event.is_action_pressed("ui_accept") and !cmd_over and !cmd_busy:
	#	print("starting")
	#	advance("start")
		#reset
	pass

func advance(state):
	while(!cmd_over):
		match state:
			"start": #reset
				cmd_busy = true
			"fail": #highlight red
				pass
			"halt": 
				return
	
		#OK
		print(commands[cmd_counter])
		#state = Player.move(commands[cmd_counter])
		await Player.move(commands[cmd_counter])
		
		cmd_counter += 1
		if cmd_counter == commands.size():
			cmd_over = true

func _on_command_grid_cmd_sequence_ready(cmd_sequence: Variant) -> void:
	if Player and !cmd_busy:
		cmd_busy = true
		for cmd in cmd_sequence:
			print("move " + cmd)
			print(await Player.move(cmd))
		cmd_busy = false
		
	commands = cmd_sequence
	print(commands)
	
	#do other stuff, propagate signal, whatever
