extends TileMapLayer

const STATUS_UNMARKED = 0
const STATUS_FINALIZED = 1
const STATUS_ON_PATH = 2
const dims = Vector2i(40, 40)
var maze = []

func is_between(x: float, lo = 0, hi = 1) -> bool:
	return lo < x and x < hi

func get_in_1d_array(array: Array, pos: Vector2i, dimensions: Vector2i, columnsFirst: bool = true) -> Variant:
	if columnsFirst: return array[(pos.x * dimensions.x) + pos.y]
	else: return array[(pos.y * dimensions.y) + pos.x]

func set_in_1d_array(array: Array, pos: Vector2i, dimensions: Vector2i, value: Variant = null, columnsFirst: bool = true) -> void:
	if columnsFirst: array[(pos.x * dimensions.x) + pos.y] = value
	else: array[(pos.y * dimensions.y) + pos.x] = value

func unmarked_point() -> Vector2i:
	var _p = Vector2i(1,1)
	while get_in_1d_array(maze, _p, dims) != STATUS_UNMARKED:
		@warning_ignore("integer_division")
		_p = Vector2i(randi_range(1, (dims.x/2)-2), randi_range(1, (dims.y/2)-2))
	return _p

func algo_to_grid(pos: Vector2i) -> Vector2i:
	return pos*2

func wilson_algorithm() -> void:
	const goal = dims.x*dims.y
	
	var neighbors_4_way = func(pos: Vector2i) -> Array[Vector2i]:
		var selection = []
		for _d in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var _final = pos+_d
			@warning_ignore("integer_division")
			if is_between(_final.x, 1, (dims.x/2)-2) and is_between(_final.y, 1, (dims.y/2)-2):
				selection.push_back(_final)
		return selection
	var path = [unmarked_point()]
	var head = path[0]
	var finalBlocks: int = 0
	
	set_in_1d_array(maze, algo_to_grid(unmarked_point()), dims, STATUS_FINALIZED)
	
	while finalBlocks < goal: pass
	while head != STATUS_FINALIZED:
		head = get_in_1d_array(maze, algo_to_grid(path.back()), dims)
		
		if head == STATUS_ON_PATH:
			var root = path[-1]
			path.pop_back()
			
			while path.back() != root:
				set_in_1d_array(maze, algo_to_grid(path.back()), dims, STATUS_UNMARKED) 
				path.pop_back()
		path.push_back(neighbors_4_way.call().pick_random())
		set_in_1d_array(maze, algo_to_grid(path.back()), dims, STATUS_ON_PATH)

	for _u in path: # _u means unused
		set_in_1d_array(maze, algo_to_grid(path.back()), dims, STATUS_FINALIZED)
		path.pop_back()
	
	path.push_back(unmarked_point())

func _ready() -> void:
	for i in range(dims.x*dims.y): maze.push_back(0) # fill maze

func _process(_dt: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		wilson_algorithm()
		
		# draw maze
		for x in range(dims.x):
			for y in range(dims.y):
				var _pos = Vector2i(x,y)
				if get_in_1d_array(maze, _pos, dims) == STATUS_FINALIZED: set_cell(_pos, 1, Vector2i(0,0))
