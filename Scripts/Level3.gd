extends "BaseLevel.gd"

const LEVEL_INDEX := 3
const TILE_SIZE := 32
const MAP_WIDTH := 64
const MAP_HEIGHT := 64
const CORRIDOR_WIDTH := 4
const SOURCE_ID := 2
const ATLAS_COORDS := Vector2i(0, 0)

const START_CELL := Vector2i(46, 52)
const LEFT_X := 12
const UP_Y := 10
const RIGHT_X := 56

func _init():
	super(LEVEL_INDEX)

func _ready():
	_configure_level_objects()
	_build_maze()
	super._ready()

func _configure_level_objects():
	var start_pos = _cell_center(START_CELL)
	$Rocket.position = start_pos
	$Goal.position = _cell_center(Vector2i(RIGHT_X, UP_Y))
	$Powerups/Powerup.position = _cell_center(Vector2i(20, START_CELL.y))

func _build_maze():
	var tilemap := $TileMapLayer
	tilemap.clear()

	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			tilemap.set_cell(Vector2i(x, y), SOURCE_ID, ATLAS_COORDS)

	var half = int(CORRIDOR_WIDTH / 2)
	# Left segment: from start going left.
	_erase_rect(tilemap, Rect2i(Vector2i(LEFT_X, START_CELL.y - half), Vector2i(START_CELL.x - LEFT_X + 1, CORRIDOR_WIDTH)))
	# Up segment: from the left turn going up.
	_erase_rect(tilemap, Rect2i(Vector2i(LEFT_X - half, UP_Y), Vector2i(CORRIDOR_WIDTH, START_CELL.y - UP_Y + 1)))
	# Right segment: from the top turn going right to the goal (right of the start).
	_erase_rect(tilemap, Rect2i(Vector2i(LEFT_X, UP_Y - half), Vector2i(RIGHT_X - LEFT_X + 1, CORRIDOR_WIDTH)))

	# Open up start and goal pockets.
	_erase_rect(tilemap, Rect2i(START_CELL - Vector2i(2, 2), Vector2i(5, 5)))
	_erase_rect(tilemap, Rect2i(Vector2i(RIGHT_X, UP_Y) - Vector2i(2, 2), Vector2i(5, 5)))

func _erase_rect(tilemap: TileMapLayer, rect: Rect2i) -> void:
	var min_x = max(0, rect.position.x)
	var min_y = max(0, rect.position.y)
	var max_x = min(MAP_WIDTH, rect.position.x + rect.size.x)
	var max_y = min(MAP_HEIGHT, rect.position.y + rect.size.y)
	for y in range(min_y, max_y):
		for x in range(min_x, max_x):
			tilemap.erase_cell(Vector2i(x, y))

func _cell_center(cell: Vector2i) -> Vector2:
	return Vector2((cell.x + 0.5) * TILE_SIZE, (cell.y + 0.5) * TILE_SIZE)
