extends Node

# 0 = Top
# 1 = Down
# 2 = Right
# 3 = Left

var queue = []

func _ready():
	resetQuee()

func resetQuee():
	for i in range(8):
		queue.append(-1)
	print(queue)

func addQuee(pos, dir):
	queue[pos] = dir
	print("Adicionado, Local: ", queue[pos], " Posicao: ", pos, " Direcao: ",dir)
