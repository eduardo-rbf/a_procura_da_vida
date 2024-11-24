extends Node

# 0 = Top
# 1 = Down
# 2 = Right
# 3 = Left

var queue = []

func _ready():
	resetQueue()

func resetQueue():
	queue.clear()
	for i in range(8):
		queue.append(-1)
	print(queue)

func addQueue(pos, dir):
	if pos >= 0 and pos < len(queue):
		queue[pos] = dir
		print("Adicionado, Local: ", queue[pos], " Posicao: ", pos, " Direcao: ", dir)
	else:
		print("Posição inválida.")
