extends PathFollow2D

@export var speed: float = 200.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.progress += speed * delta
	# so i don't keep a high number in memory if they stay on the screen
	self.rotation = int(self.rotation + 30) % 450
