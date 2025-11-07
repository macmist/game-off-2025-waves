extends FloorMap


@export var size: int = 15

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
	print(width, height)
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
	tower.z_index = 1
	tower.size = height
	print("local ", position, "global ", global)
	add_child(tower)


func _ready() -> void:
	var data = read_level("res://levels/level_0.txt")
	generate_floor(data)
	


func get_tile_type(coords: Vector2) -> String:
	var tile_coords = local_to_map(to_local(coords))
	var data = get_cell_tile_data(tile_coords)
	if is_instance_valid(data):
		return data.get_custom_data("type")
	return ""
