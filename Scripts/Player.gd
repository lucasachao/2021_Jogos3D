extends KinematicBody

#movimento
var velocity = Vector3.ZERO
var fall = Vector3.ZERO
var dir
#nós
var camera
#variaveis
var life = 100

const SPEED = 10
const MAX_FALL_SPEED = 100
const ACCELERATION = 2
const DE_ACCELERATION = 5
const GRAVITY = 50
const JUMP_FORCE = 25
const WEIGHT = 10

#func _ready():
#	pass

func _physics_process(delta):
	#variaveis
	camera = get_node("target/Camera").get_global_transform()
	dir = Vector3.ZERO

	#captura teclado
	if life > 0:
		moving(delta)
	falling(delta)
		
	#normaliza resultado
	dir = dir.normalized() * SPEED
	
	#frenagem
	var accel = DE_ACCELERATION
	
	#se estiver andando
	if dir != Vector3.ZERO:
		#aceleracao
		accel = ACCELERATION
		#faz personagem olhar para frente
		look_at(get_transform().origin - velocity, Vector3.UP)
	
	#adiciona aceleracao na velocidade
	#velocity = velocity.linear_interpolate(dir, accel * delta)
	velocity = lerp(velocity, dir, accel * delta)
	
	#faz transicao de animacao
	var anim_blend = velocity.length() / SPEED
	get_node("AnimationPlayer/AnimationTree").set("parameters/IdleRun/blend_amount", anim_blend)
	
	#colisoes
	var slide_count = get_slide_count()
	if slide_count > 0:
		collisions(slide_count)

	#velocity = move_and_slide(velocity,Vector3.UP, true)
	velocity = move_and_slide_with_snap(velocity + fall - get_floor_normal() * WEIGHT, Vector3.DOWN, Vector3.UP) 
	#print(is_on_floor())
	if is_on_floor() and fall.y < -30:
		got_hit(-fall.y)
	if(velocity.y < -MAX_FALL_SPEED):
		velocity.y = -MAX_FALL_SPEED
	fall.y = velocity.y
	velocity.y = 0

func moving(delta):
	if(Input.is_action_pressed("move_forward")):
		dir += -camera.basis[2]
	elif(Input.is_action_pressed("move_back")):
		dir += camera.basis[2]
	if(Input.is_action_pressed("move_left")):
		dir += -camera.basis[0]
	elif(Input.is_action_pressed("move_right")):
		dir += camera.basis[0]
		
func falling(delta):
	if(is_on_floor()):
		if(Input.is_action_just_pressed("jump")):
			fall.y += JUMP_FORCE
		else:
			fall = Vector3.ZERO
	else:
		fall.y -= GRAVITY * delta

	
func collisions(slide_count):
	for count in range(slide_count):
		var collision = get_slide_collision(count)
		var collider = collision.collider
		
		if collider.is_in_group("tree"):
			print("foi")
		
		elif collider.name == "megapulo":
			velocity.y += 50

		elif collider.name == "armadilha":
			got_hit(3)

		elif collider.name == "slider":
			if collider.get_node("AnimationPlayer").current_animation_position == 0:
				collider.active = true

		elif collider.name == "cura":
			if(life + 20 > 100):
				life = 100
			else:
				life += 20
			var scenery = get_parent().get_node("Scenery/Special")
			var cura = scenery.get_node("cura")
			scenery.remove_child(cura)

func got_hit(var dmg = 20):
	if(life > dmg):
		life -= dmg
	else:
		life = 0
		get_node("AnimationPlayer/AnimationTree").set("parameters/Death/blend_amount", 1)
		var timer = get_node("Timer")
		timer.start(4)

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/Menu.tscn")
