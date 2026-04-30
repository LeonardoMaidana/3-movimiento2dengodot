extends CharacterBody2D

enum State { PATROL, CHASE, ATACK}

@export_group("Patrol")
@export var patrol_speed = 100.0
@export var patrol_points: Array[Vector2] = []

@export_group("Chase")
@export var chase_speed = 200.0
@export var chase_range = 250.0
@export var lose_range = 400.0

@export_group("atack")
@export var atack_range = 200.0
@export var atack_count = 10

var atack_cd = 1.0
var atack_timer = 0.0
var current_state: State = State.PATROL
var patrol_index: int = 0
var player: CharacterBody2D = null
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if atack_timer > 0:
		atack_timer -= delta
	if player == null:
		return
	var dist = global_position.distance_to(player.global_position)
	
	match current_state:
		State.PATROL:
			if dist <= chase_range:
				current_state = State.CHASE
				print("Enemigo: cambio a CHASE")
		
		State.CHASE:
			if dist <= atack_range:
				current_state = State.ATACK
			elif dist >= lose_range:
				current_state = State.PATROL
				print("Enemigo: perdio al jugador, vuelve a Patrullaje")
		
		State.ATACK:
			if dist > atack_range:
				current_state = State.CHASE
				
	match current_state:
		State.PATROL: _state_patrol(delta)
		State.CHASE: _state_chase()
		State.ATACK: _state_atack()
		
	move_and_slide()
	
	
func _state_patrol(delta:float) -> void:
	if patrol_points.size() == 0:
		return
	
	var target = patrol_points[patrol_index]
	var direction = (target - global_position)
	
	if direction.length() < 5.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
	else:
		velocity.x = sign(direction.x) * patrol_speed
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func _state_chase() -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * chase_speed
	if !is_on_floor():
		velocity += get_gravity() * get_physics_process_delta_time()
		
func _state_atack() -> void:
	velocity.x = 0
	if atack_timer <= 0:
		player.take_damage(atack_count)
		atack_timer = atack_cd
		print("Enemigo toco al jugador! Le hizo danio: ")
