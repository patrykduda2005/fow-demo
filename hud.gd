extends CanvasLayer

var pulledUp = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var doPullUp = Input.is_action_just_pressed("radar");
	if (doPullUp):
		if (pulledUp):
			offset.y += 1100
			pulledUp = false
		else:
			offset.y -= 1100
			pulledUp = true

	pass
