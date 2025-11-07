extends FloorMap


@export var size: int = 15

var water_atlas = Vector2(0, 1)
var land_atlas = Vector2(0, 0)
var ne_border_atlas = Vector2(1, 1)
var nw_border_atlas = Vector2(2, 1)

var tile_size = Vector2(16, 8)


const TOWER_MIDDLE = preload("res://components/towers/tower_middle.tscn")


func generate_floor():
	for height in range(size):
		for width in range(size):
			var atlas = land_atlas
			if height == size - 2:
				if width == height:
					atlas = water_atlas
				else:
					atlas = ne_border_atlas
			if width == size - 2:
				if width == height:
					atlas = water_atlas
				else:
					atlas = nw_border_atlas
			
			if height == size - 1 || width == size - 1:
				atlas = water_atlas
	
			var position = Vector2(width, height)
			set_cell(position, 0, atlas)
			
func add_towers():
	var position = Vector2(1, 1)
	print("global", to_global(local_to_map(position)), local_to_map(position), to_global(position), map_to_local(position), position)
	var global = map_to_local(position)
	var tower = TOWER_MIDDLE.instantiate()
	tower.position = global
	tower.z_index = 12
	add_child(tower)


func _ready() -> void:
	generate_floor()
	add_towers()


func get_tile_type(coords: Vector2) -> String:
	var tile_coords = local_to_map(to_local(coords))
	var data = get_cell_tile_data(tile_coords)
	if is_instance_valid(data):
		return data.get_custom_data("type")
	return ""
