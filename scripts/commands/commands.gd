extends Node

@export var Player: Node2D
var test: int = 2

var cmd_counter = 0
var commands = Dictionary()
var cmd_over = false
var cmd_busy = false

func _ready():
	if not Player:
		print("[at:commands.gd::_ready]" + "Player não encontrado! Verifique a estrutura de nós.")
	else:
		pass
		#print("[at:commands.gd::_ready]" + "Player encontrado: ", Player.name)


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

#Função temporária de testes.
func exec(cmd_sequence: Array, source: Array):
	#recursion 😱
	#source = f1/f2, recursion guard
	for cmd in cmd_sequence:
		if cmd.contains("f1"):	
			if source.has("f1"):
				print("[at:commands.gd::exec()]", "Recursion found, halting.")
				return
			exec(commands["f1"], source + ["f1"])
		elif cmd.contains("f2"):
			if source.has("f2"):
				print("[at:commands.gd::exec()]", "Recursion found, halting.")
				return
			exec(commands["f2"], source + ["f2"])
		else:
			if(cmd != "null"):
				print("[at:commands.gd::exec()]", await Player.move(cmd))
			

func _on_command_grid_cmd_ready(cmd_pack: Variant) -> void:
	if Player and !cmd_busy:
		cmd_busy = true
		commands = cmd_pack
		exec(commands["main"], ["main"])
		cmd_busy = false
	
	#do other stuff, propagate signal, whatever


func _on_reset_pressed() -> void:
	# Reseta a posição e rotação do player, se encontrado
	if Player:
		Player.reset_position()
		
	else:
		print("[at:commands.gd::_on_reset_pressed]" + "Não foi possível resetar o player, pois ele não foi encontrado.")
