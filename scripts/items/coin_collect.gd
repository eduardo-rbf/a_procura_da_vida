extends Area2D

signal coin_collected
var initial_position: Vector2
@onready var anim = $AnimationPlayer

func _ready() -> void:
	add_to_group("coins")
	initial_position = position

func reset_coin() -> void:
	position = initial_position
	show()

func respawn_coin(position: Vector2) -> void:
	self.position = position
	show()

func _on_area_entered(area: Area2D) -> void:
	#print("[at:coin_collet.gd::_on_area_entered()]", "Sinal Enviado")
	if visible:
		coin_collected.emit()
		hide()  # Ao invés de queue_free, apenas escondemos
