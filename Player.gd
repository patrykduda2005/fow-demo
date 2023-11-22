extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var isSprint = Input.is_action_pressed("sprint")
	velocity = direction * SPEED * (2 if isSprint else 1);
	move_and_slide()
