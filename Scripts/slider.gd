extends KinematicBody

var active = false
var anim
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	anim = get_node("AnimationPlayer")
	anim.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	if(active):
		anim.play("move")
		active = false
	
	#se animacao esta no final e timer n iniciou
	if anim.current_animation_position == 5:
		if(timer.get_time_left() == 0):
			timer.start()

func _on_Timer_timeout():
	anim.play_backwards("move")
	timer.stop()
