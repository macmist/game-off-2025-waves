extends FloorMap


@export var size: int = 15
@onready var camera: Camera2D = $Camera
@export var ocean_sprite: Sprite2D

var water_atlas = Vector2(0, 1)
var land_atlas = Vector2(0, 0)
var ne_border_atlas = Vector2(1, 1)
var nw_border_atlas = Vector2(2, 1)

var tile_size = Vector2(16, 8)


const TOWER = preload("res://components/towers/tower.tscn")
func read_level(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var size = file.get_line().split(' ')
	var width = int(size[0])
	var height = int(size[1])
	var tiles = []
	for y in range(height):
		var content = file.get_line()
		tiles.append([])
		for x in content:
			tiles[y].append(int(x))
	return {"width": width, "height": height, "tiles": tiles}

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
			
			var position = Vector2(w, h)
			set_cell(position, 0, atlas)
			if t >= 4:
				height = t - 3 # 4 is a tower of size 1
				add_tower(position, height)
			
func add_tower(position: Vector2, height: int):
	var global = map_to_local(position)
	var tower = TOWER.instantiate()
	tower.position = global + Vector2(0, -4)
	#tower.z_index = 1
	tower.size = height
	add_child(tower)


func _ready() -> void:
	var data = read_level("res://levels/level_0.txt")
	generate_floor(data)
	center_and_zoom(data)
	center_ocean(data)
	

func center_ocean(dict: Dictionary) -> void:
	if !dict.has("width") || !dict.has("height") || !dict.has("tiles"):
		return
	var width = dict.get("width")
	var height = dict.get("height")
	var center_h = Vector2(width / 2, height / 2)
	var h = to_global(map_to_local(center_h))
	ocean_sprite.global_position.y = h.y

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
