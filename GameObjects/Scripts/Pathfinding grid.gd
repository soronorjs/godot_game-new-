extends Node2D

@export var cell_size = Vector2i(64, 64)

var astar_grid = AStarGrid2D.new()
var grid_size

func _ready():
	initialize_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()
