extends Area2D

@export var is_locked: bool
@export var required_key: String = "bronze_key"

var is_open: bool = false

func try_unlock(player) -> bool:
	if not is_locked:
		return true
	if player.has_key(required_key):
		is_locked = false
		return true
	return false
	
func open():
	if is_open:
		return
	if is_locked:
		return
		
	is_open = true
	
	$CollisionShape2D.disabled = true
	
	# play animation?



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_interactable"):
		body.set_interactable(self)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("clear_interactable"):
		body.clear_interactable(self)
