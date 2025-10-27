extends TileMapLayer

const STATUS_UNMARKED = 0
const STATUS_FINALIZED = 1
const STATUS_ON_PATH = 2
const dims = Vector2i(41, 41)

var root = Vector2i(0,0)
var maze = []

@onready var player = $"../../Player"

func is_between(x: float, lo = 0, hi = 1) -> bool:
	return lo < x and x < hi

func reset_maze() -> void:
	maze = []
	for x in range(dims.x):
		var row = []
		for y in range(dims.y):
			row.push_back(0)
		maze.push_back(row)

func carve_passage(pos: Vector2i) -> void:
	var dirs = [Vector2i.UP*2, Vector2i.DOWN*2, Vector2i.LEFT*2, Vector2i.RIGHT*2]
	
	dirs.shuffle()
	
	for dir in dirs:
		var next = pos+dir
		var beforeNext = pos+(dir/2)
		if is_between(next.x, 0, dims.x-1) and is_between(next.y, 0, dims.y-1) and maze[next.x][next.y] == STATUS_UNMARKED:
			maze[next.x][next.y] = STATUS_FINALIZED
			maze[beforeNext.x][beforeNext.y] = STATUS_FINALIZED
			carve_passage(next)

func generate_maze(initPos = null) -> void:
	if not initPos or typeof(initPos) != TYPE_VECTOR2I: initPos = Vector2i(1, 1)
	carve_passage(initPos)

func swap_vector_types(v: Vector2i) -> Variant:
	if typeof(v) == TYPE_VECTOR2: return Vector2i(v.x, v.y)
	else: return Vector2(v.x, v.y)

func _ready() -> void: pass

func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var start = Vector2i(0,0)
		reset_maze()
		generate_maze(start)
		player.position = (swap_vector_types(Vector2i(randi_range(1,10), randi_range(1,10))*2)*scale*swap_vector_types(tile_set.tile_size))+position
		
		# draw maze
		clear()
		for x in range(dims.x):
			for y in range(dims.y):
				if maze[x][y] == STATUS_UNMARKED: set_cell(Vector2i(x, y), 1, Vector2i(0, 0))
