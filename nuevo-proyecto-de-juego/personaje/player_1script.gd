extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -500.0
var  max_jumps = 2
var jumps_left = 2

func _physics_process(delta: float) -> void:

	if !is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			
	if is_on_floor():
		jumps_left = max_jumps
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
