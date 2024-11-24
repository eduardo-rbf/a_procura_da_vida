extends Node2D

var player: Node2D
var target_position = null
var move_distance = 50
var is_moving = false
var current_pos = 0
var move_time = 0.5
var elapsed_time = 0

# Lógica dos botões
func _on_start_pressed() -> void:
	print("Apertou!!!!")
	start_moving()

func _ready():
	player = get_node("/root/Level-01/player")
	target_position = player.position

func _process(_delta: float) -> void:
	if is_moving:
		move_player(_delta)

	# Quando a fila for completada, parar o movimento
	if current_pos >= len(Global.queue):
		is_moving = false

func start_moving():
	is_moving = true
	current_pos = 0
	elapsed_time = 0  # Resetando o tempo

func move_player(_delta: float):
	if current_pos < len(Global.queue) and Global.queue[current_pos] != -1: 
		var dir = Global.queue[current_pos]
		var movement_vector = Vector2.ZERO
		
		match dir:
			0:
				movement_vector = Vector2(0, -move_distance)
			1:
				movement_vector = Vector2(0, move_distance)
			2:
				movement_vector = Vector2(move_distance, 0)
			3:
				movement_vector = Vector2(-move_distance, 0)

		target_position = player.position + movement_vector

		# Movimento com interpolação
		if elapsed_time < move_time:
			elapsed_time += _delta
			player.position = player.position.lerp(target_position, elapsed_time / move_time)
		else:
			player.position = target_position  # Garante que o player chegue à posição final
			current_pos += 1
			elapsed_time = 0  # Resetando o tempo para o próximo movimento
	
	# Se a fila de movimentos estiver completa, parar
	if current_pos >= len(Global.queue) or Global.queue[current_pos] == -1: 
		is_moving = false
