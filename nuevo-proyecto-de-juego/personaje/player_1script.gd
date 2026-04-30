extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -500.0
var  max_jumps = 2
var jumps_left = 2
var dash_speed = 800.0
var dash_duration = 0.15
var dash_timer = 0.0
var is_dashing = false
var can_dash = true
var dash_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	#Implementacion de "Dash" / Disclaimer: una parte del script salio de un video y
	#otras que fui probando-Que por ahora me sirven y funcionan
	if Input.is_action_just_pressed("ui_accept") and can_dash:
		is_dashing = true
		can_dash = false
		dash_timer = dash_duration
		# Lo de arriba lo pense, de como seria un dash pero lo de aca abajo,
		#Entiendo por partes, Vector2, se que son las cordenadas que le dan al dash_direction
		
		dash_direction = Input.get_vector("ui_left","ui_right", "ui_up", "ui_accept")
		
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(velocity.x, 0)
			#Aca entendi por prueba y error que Zero es literal 0.0 del personaje
			#Lo que si no se como hacer para que el dash se de para el lado que quedo mirando
			#Osea el si mi ultima tecla fue la derecha antes de tocar el dash
			#Quiero que el dash vaya para ahi y no solo a la derecha.
			#En proximos commits voy a intentar resolverlo. Tengo una vaga idea.
			if dash_direction == Vector2.ZERO:
				dash_direction = Vector2.RIGHT
	if is_dashing:
		dash_timer -= delta
		velocity = dash_direction.normalized() * dash_speed
		
		move_and_slide()
		
		if dash_timer <= 0:
			is_dashing = false
			
		return
	#Implementacion de la gravedad
	if !is_on_floor():
		velocity += get_gravity() * delta
	#Implementacion del salto
	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			
	if is_on_floor():
		jumps_left = max_jumps
		can_dash = true
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
