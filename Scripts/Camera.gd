extends Camera

# Declare member variables here. Examples:
var distance = 3.0
var height = 1.0

const CAM_ROTATION = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	#força uso de physics_process handler (em detrimento da process)
	set_physics_process(true)
	#permite que a camera se movimente fora do movimento do pai
	set_as_toplevel(true)

func _physics_process(delta):
	#posicao atual do target
	var target = get_parent().get_global_transform().origin
	#posicao atual da camera
	var pos = get_global_transform().origin
	#diferenca de posicao entre a camera e o target
	var offset = pos - target

	#posiciona camera atras do personagem
	if(Input.is_action_just_pressed("reset_camera")):
		offset = -get_parent().get_global_transform().basis[2]
	#rotaciona a camera
	if(Input.is_action_pressed("move_camera_left")):
#		var player = get_node("../../")
#		player.rotate_y(deg2rad(CAM_ROTATION * delta))
		var angle = deg2rad(rotation_degrees.y + CAM_ROTATION * delta)
		offset = Vector3(sin(angle), 0, cos(angle))
	if(Input.is_action_pressed("move_camera_right")):
#		var player = get_node("../../")
#		player.rotate_y(-deg2rad(CAM_ROTATION * delta))
		var angle = deg2rad(rotation_degrees.y - CAM_ROTATION * delta)
		offset = Vector3(sin(angle), 0, cos(angle))
	#muda distancia da camera
	if(Input.is_action_just_pressed("camera_distance")):
		if distance == 1.5:
			distance = 3 #medio
			height = 1.0
		elif distance == 3:
			distance = 6 #longe
			height = 1.5
		else:
			distance = 1.5 #perto
			height = 0.5
			
	#calcula offset novo
	offset = offset.normalized() * distance
	offset.y = height
	
	#atualiza pos calculando onde a camera deve estar
	pos = target + offset
	#camera olha para o target da sua nova posicao
	look_at_from_position(pos, target, Vector3.UP)
