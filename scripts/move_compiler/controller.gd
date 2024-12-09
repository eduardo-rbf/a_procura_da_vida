extends Node

signal grid_emitted(grid: Array)

var grid: Array = [
	[null, null, null],
	[null, null, null],
	[null, null, null]
]

func _ready() -> void:
	for i in range(3):
		for j in range(3):
			var slot = $slots.get_child(i * 3 + j)
			slot.row = i
			slot.col = j
			slot.grid = grid

func _on_start_btn_pressed() -> void:
	emit_signal("grid_emitted", grid)
