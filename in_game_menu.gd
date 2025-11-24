extends CanvasLayer

@onready var bottom_menu: HBoxContainer = $"MarginContainer/PanelContainer/MarginContainer/VSplitContainer/Bottom Menu"
@onready var waves_remaining: RichTextLabel = $"MarginContainer2/PanelContainer/MarginContainer/Waves Remaining"
@onready var points_remaining: RichTextLabel = $"MarginContainer/PanelContainer/MarginContainer/VSplitContainer/Points Remaining"

var buttons: Array[TextWithButton] = []

const TEXT_WITH_BUTTON = preload("res://text_with_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_bottom_button("speed", 10, Game.speed)
	add_bottom_button("strength", 1, Game.strength)
	add_bottom_button("width", 2, Game.width)
	add_bottom_button("duration", 1, Game.duration)
	Game.num_of_waves.changed.connect(edit_wave_text)
	Game.points_remaining.changed.connect(points_remaining_listener)
	
func add_bottom_button(text: String, increment_value: int, value: EditableInt):
	var button = TEXT_WITH_BUTTON.instantiate()
	button.value_text = text
	button.editable_value = value
	button.button_increment = increment_value
	bottom_menu.add_child(button)
	edit_wave_text()
	points_remaining_listener()
	button.clicked.connect(button_clicked_listener)
	buttons.append(button)


func edit_wave_text():
	waves_remaining.text = "Waves remaining: " + str(Game.num_of_waves.current)
	
func button_clicked_listener():
	Game.points_remaining.current -= 1
	

func points_remaining_listener():
	points_remaining.text = "Points remaining: " + str(Game.points_remaining.current)
	for b in buttons:
		b.enabled = Game.points_remaining.current > 0
