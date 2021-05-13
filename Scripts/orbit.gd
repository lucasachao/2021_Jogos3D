extends MeshInstance

export var angle = 0.0
var distance = 0.8
var height = 1.0
var speed = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	angle += speed * delta
	var offset = Vector3(cos(deg2rad(angle)),height,sin(deg2rad(angle))) * distance
	var pos = target + offset
	look_at_from_position(pos, target, Vector3.UP)
