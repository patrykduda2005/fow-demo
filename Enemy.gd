extends CharacterBody2D

@export var movement_speed: float = 200.0

@export var movement_target: CharacterBody2D
@export var navigation_agent: NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target(movement_target.position)
	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav
	#if (velocity.x>0): #to nie ma velocity
		#get_node("AnimatedSprite2D").flip_h = true
	#else:
		#get_node("AnimatedSprite2D").flip_h = false

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		pass


func _on_deduwa_body_entered(body):
	if body.name == "Player":
		get_tree().quit()
	
