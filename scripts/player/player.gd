extends Sprite2D

@onready var animation_player = $AnimationPlayer

# Direção mapeada para isometria
var direction_map = {
	"up": {"movement": Vector2(1, 1).normalized() * 32, "animation": "walk_up"},
	"down": {"movement": Vector2(-1, -1).normalized() * 32, "animation": "walk_down"},
	"left": {"movement": Vector2(-1, 1).normalized() * 32, "animation": "walk_left"},
	"right": {"movement": Vector2(1, -1).normalized() * 32, "animation": "walk_right"}
}

var target_position = Vector2.ZERO  # Posição final que o personagem deve alcançar
var move_start_position = Vector2.ZERO  # Posição inicial
var move_duration = 0.0  # Duração da animação
var time_elapsed = 0.0  # Tempo decorrido
var moving = false  # Controla se o personagem está se movendo ou não

# Função chamada quando uma direção é emitida
func _on_move_compiler_grid_emitted(grid: Array) -> void:
	for i in range(3):
		for j in range(3):
			if grid[i][j] != null:
				var direction = grid[i][j]
				if direction_map.has(direction):
					# Calcula a direção do movimento de forma isométrica
					var move_vector = direction_map[direction]["movement"]
					target_position = position + move_vector  # Define a posição final isométrica
					move_start_position = position  # Posição inicial para o movimento
					move_duration = animation_player.get_animation(direction_map[direction]["animation"]).length  # Duração da animação
					time_elapsed = 0.0  # Reseta o tempo
					moving = true  # Marca o movimento como ativo
					
					# Toca a animação correspondente
					animation_player.play(direction_map[direction]["animation"])

# Função chamada a cada frame para atualizar a posição do personagem
func _process(delta: float) -> void:
	if moving:
		# Incrementa o tempo
		time_elapsed += delta
		
		# Calcular o progresso do movimento com base na duração da animação
		var progress = time_elapsed / move_duration  # Progresso do movimento (vai de 0 a 1)
		
		# Move o personagem progressivamente, respeitando a interpolação isométrica
		position = move_start_position.lerp(target_position, progress)
		
		# Verifica se o movimento foi concluído
		if progress >= 1.0:
			position = target_position  # Ajusta para a posição final exata
			moving = false  # Para o movimento
