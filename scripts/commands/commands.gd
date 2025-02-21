extends Node

signal reset_level
signal exec_finished

@export var Player: Node2D
var test: int = 2

var cmd_counter = 0
var commands = Dictionary()
var cmd_over = false
var cmd_busy = false
var halt_flag = false

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
#ASSINCRONA
func exec(cmd_sequence: Array, source: Array):
	#recursion 😱
	#source = f1/f2, recursion guard
	for cmd in cmd_sequence:
		if halt_flag: 
			return
		if cmd.contains("f1"):	
			if source.has("f1"):
				print("[at:commands.gd::exec()]", "Recursion found, halting.")
				return
			await exec(commands["f1"], source + ["f1"])
		elif cmd.contains("f2"):
			if source.has("f2"):
				print("[at:commands.gd::exec()]", "Recursion found, halting.")
				return
			await exec(commands["f2"], source + ["f2"])
		else:
			if(cmd != "null"):
				#print("[at:commands.gd::exec()]", 
				#"attempting to ", cmd, ". Status: ", await Player.move(cmd))
				await Player.move(cmd)
				#quiet
			

func _on_command_grid_cmd_ready(cmd_pack: Variant) -> void:
	#hack, refactor
	_on_reset_pressed()
	if Player and !cmd_busy:
		cmd_busy = true
		commands = cmd_pack
		halt_flag = false
		await exec(commands["main"], ["main"])
		if halt_flag:
			_on_reset_pressed()
			halt_flag = false
		cmd_busy = false
		exec_finished.emit()
	
	#do other stuff, propagate signal, whatever


func _on_reset_pressed() -> void:
	halt_flag = true
	reset_level.emit()
	# Reseta a posição e rotação do player, se encontrado
	if Player:
		Player.reset_position()
	else:
		print("[at:commands.gd::_on_reset_pressed]" + "Não foi possível resetar o player, pois ele não foi encontrado.")
