extends PathFollow2D

@export var speed: float = 200.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.progress += speed * delta
