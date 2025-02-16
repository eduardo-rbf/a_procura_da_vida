extends Control

var total_coins: int = 3
var collected_coins: int = 0
var current_level: int = 1

func _ready() -> void:
	connect_all_coins()
	update_display()
	current_level = get_current_level_number()

	var commands = get_node_or_null("/root/Commands")
	if not commands:
		commands = get_tree().get_root().find_child("Commands", true, false)
	
	if commands:
		print("Commands encontrado, conectando sinal...")
		commands.reset_level.connect(_on_reset_level)
	else:
		print("ERRO: Não foi possível encontrar o nó Commands!")

func connect_all_coins() -> void:
	var coins = get_tree().get_nodes_in_group("coins")
	total_coins = coins.size()
	for coin in coins:
		coin.coin_collected.connect(_on_coin_coin_collected)

func update_display() -> void:
	$container/HBoxContainer/CoinLabel.text = str(collected_coins) + "/" + str(total_coins)

func reset_coins() -> void:
	collected_coins = 0
	update_display()

func _on_coin_coin_collected() -> void:
	collected_coins += 1
	update_display()
	check_level_completion()

func _on_reset_level() -> void:
	reset_coins()
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.reset_coin()

func check_level_completion() -> void:
	if collected_coins >= 2:
		Global.levels_data[current_level][2] = true
		
		if Global.levels_data.has(current_level + 1):
			Global.levels_data[current_level + 1][1] = true
		
		if collected_coins >= 3:
			Global.levels_data[current_level][3] = true
			
		Global.read_dict()

func get_current_level_number() -> int:
	var scene_path = get_tree().current_scene.scene_file_path
	for level in Global.levels_data:
		if Global.levels_data[level][0] == scene_path:
			return level
	return 1
