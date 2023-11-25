extends CharacterBody2D
func _physics_process(delta):
	position += (get_parent().get_node("CanvasLayer/Player").position - position).normalized()
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		pass


func _on_deduwa_body_entered(body):
	if body.name == "Player":
		get_tree().quit()
