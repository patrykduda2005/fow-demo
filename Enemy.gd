extends CharacterBody2D

@export var movement_speed: float = 150.0

@export var movement_target: CharacterBody2D
@export var navigation_agent: NavigationAgent2D
enum movementState {
	jumping,
	breaking,
	following,
}
var state: movementState = movementState.following
var skokTargetPoint: Vector2;
var timeForBreaking: SceneTreeTimer;
var timeSpentJumping: SceneTreeTimer;

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
func _physics_process(delta):
	#Raycast patrzy na target
	get_node("RayCast2D").look_at(movement_target.position);
	
	#Handle following
	if (state == movementState.following):
		set_velocity_to_next_node()
		
	#Skacze gdy jest wystarczajaco blisko i ma nie zaslonietą wizje
	if (state == movementState.following &&
	 global_position.distance_to(navigation_agent.target_position) < 600 &&
	 has_unobstructed_vision_to(navigation_agent.target_position)
	):
		state = movementState.jumping
		skokTargetPoint = navigation_agent.target_position
		timeSpentJumping = get_tree().create_timer(1)
		velocity = global_position.direction_to(navigation_agent.target_position).normalized() * movement_speed * 20
		
	#Handle breaking
	if (state == movementState.breaking):
		breaking()
		
	#Start breaking gdy doszedl do celu lub minie odpowiednio dlugo czasu
	if (state == movementState.jumping && (global_position.distance_to(skokTargetPoint) < 60 || timeSpentJumping.time_left == 0)):
		state = movementState.breaking
		timeForBreaking = get_tree().create_timer(1.5)
	
	animation_flip()
	move_and_slide()
	
func breaking():
	#Zmniejsza velocity za pomocą dzielenia
	velocity /= 1.04
	
	#Gdy minie czas to przerywa zatrzymywanie sie i wraca do followowania
	if (timeForBreaking.time_left == 0):
		state = movementState.following
	
func has_unobstructed_vision_to(point: Vector2):
	var patrzenie: RayCast2D = get_node("RayCast2D")
	if (patrzenie.is_colliding()):
		if (patrzenie.get_collider() == movement_target):
			return true
	return false
	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point

func set_velocity_to_next_node():
	set_movement_target(movement_target.position)
	if navigation_agent.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	
	velocity = new_velocity
	
func animation_flip():
	if (velocity.x<0): #to nie ma velocity = false
		get_node("AnimatedSprite2D").flip_h = true
	else:
		get_node("AnimatedSprite2D").flip_h = false

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		pass


func _on_deduwa_body_entered(body):
	if body.name == "Player":
		get_tree().quit()
	
