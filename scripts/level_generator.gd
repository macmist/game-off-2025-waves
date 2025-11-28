extends FloorMap

class_name LevelGenerator

@onready var camera: Camera2D = $Camera
@export var ocean_sprite: Sprite2D
@export var horizon: Sprite2D 
@export var main_menu: bool = true

var water_atlas = Vector2(0, 1)
var land_atlas = Vector2(0, 0)
var ne_border_atlas = Vector2(1, 1)
var nw_border_atlas = Vector2(2, 1)

var tile_size = Vector2(16, 8)


const TOWER = preload("res://components/castle/towers/tower.tscn")
func read_level(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var num_of_waves = int(file.get_line())
	var wave_config = file.get_line().split(' ')
	var config = extract_wave_config(wave_config)
	var size = file.get_line().split(' ')
	var width = int(size[0])
	var height = int(size[1])
	var tiles = []
	for y in range(height):
		var content = file.get_line()
		tiles.append([])
		for x in content:
			tiles[y].append(int(x))
	var res =  {"width": width, "height": height, "tiles": tiles, "num_of_waves": num_of_waves}
	res.merge(config)
	return res

func extract_wave_config(config: Array[String]) -> Dictionary:
	if !config:
		return {}
	var speed = int(config[0])
	var strength = int(config[1])
	var width = int(config[2])
	var duration = int(config[3])
	return {"wave_speed": speed, "wave_strength" : strength, "wave_width": width, "wave_duration": duration}

func generate_floor(dict: Dictionary):
	if !dict.has("width") || !dict.has("height") || !dict.has("tiles"):
		return
	var width = dict.get("width")
	var height = dict.get("height")
	var tiles = dict.get("tiles")
	
	for h in range(height):
		for w in range(width):
			var atlas = land_atlas
			var t = tiles[h][w]
			match t:
				0: 
					atlas = water_atlas
				1:
					atlas = ne_border_atlas
				2:
					atlas = nw_border_atlas
				_:
					atlas = land_atlas
			
			var cell_position = Vector2(w, h)
			set_cell(cell_position, 0, atlas)
			if t >= 4:
				height = t - 3 # 4 is a tower of size 1
				add_tower(cell_position, height)
			
func add_tower(cell_position: Vector2, height: int):
	var global = map_to_local(cell_position)
	var tower = TOWER.instantiate()
	tower.position = global + Vector2(0, -4)
	#tower.z_index = 1
	tower.size = height
	add_child(tower)
	
	
func _ready() -> void:
	if main_menu:
		setup_main_menu()
	else:
		setup(Game.level.current)


func setup_main_menu():
	var data = read_level("res://levels/main_menu.txt")
	generate_floor(data)
	center_and_zoom(data)
	center_ocean(data)
	set_level_data(data)

func setup(level_number: int) -> void:
	var data = read_level("res://levels/level_%d.txt" % level_number)
	generate_floor(data)
	center_and_zoom(data)
	center_ocean(data)
	set_level_data(data)
	

func set_level_data(data: Dictionary):
	if data.has("wave_speed"):
		Game.speed.current = data.get("wave_speed")
	if data.has("wave_strength"):
		Game.strength.current = data.get("wave_strength")
	if data.has("wave_duration"):
		Game.duration.current = data.get("wave_duration")
	if data.has("wave_width"):
		Game.width.current = data.get("wave_width")
	if data.has("num_of_waves"):
		Game.num_of_waves.current = data.get("num_of_waves")
	Game.points_remaining.current = 0
	

func center_ocean(dict: Dictionary) -> void:
	if !dict.has("width") || !dict.has("height") || !dict.has("tiles"):
		return
	var width = dict.get("width")
	var height = dict.get("height")
	var center_h = Vector2(width / 2, height / 2)
	var h = to_global(map_to_local(center_h))
	ocean_sprite.global_position.y = h.y
	horizon.global_position.y = h.y - horizon.transform.get_scale().y / 3

func center_and_zoom(dict: Dictionary):
	if !dict.has("width") || !dict.has("height") || !dict.has("tiles"):
		return
	var width = dict.get("width")
	var height = dict.get("height")
	
	var map_width = (width + 2) * tile_size.x
	var map_height = (height + 2) * tile_size.y

	
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	var zoom_x = viewport_size.x / map_width
	var zoom_y = viewport_size.y / map_height
	
	var zoom_factor = min(zoom_x, zoom_y)
	
	$Camera.zoom = Vector2(zoom_factor, zoom_factor)

	var center_map = Vector2(width / 2, height / 2)
	var center = to_global(map_to_local(center_map))
	$Camera.global_position = center
	

func get_tile_type(coords: Vector2) -> String:
	var tile_coords = local_to_map(to_local(coords))
	var data = get_cell_tile_data(tile_coords)
	if is_instance_valid(data):
		return data.get_custom_data("type")
	return ""
