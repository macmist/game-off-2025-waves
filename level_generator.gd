extends FloorMap


@export var size: int = 15

var water_atlas = Vector2(0, 1)
var land_atlas = Vector2(0, 0)
var ne_border_atlas = Vector2(1, 1)
var nw_border_atlas = Vector2(2, 1)


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

func _ready() -> void:
	generate_floor()


func get_tile_type(coords: Vector2) -> String:
	var tile_coords = local_to_map(to_local(coords))
	var data = get_cell_tile_data(tile_coords)
	if is_instance_valid(data):
		return data.get_custom_data("type")
	return ""
