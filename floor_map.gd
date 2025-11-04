extends TileMapLayer
class_name FloorMap

func get_tile_type(coords: Vector2) -> String:
	var tile_coords = local_to_map(to_local(coords))
	var data = get_cell_tile_data(tile_coords)
	if is_instance_valid(data):
		return data.get_custom_data("type")
	return ""
