extends Control

var player
var life_bar
var life_text
var max_width

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")
	life_bar = get_node("ColorRect2")
	max_width = life_bar.rect_size.x
	life_text = get_node("Label")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life_bar.rect_size.x = int((player.life * max_width)/100)
	life_text.text = str(round(player.life))
	
