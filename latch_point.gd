extends Area2D

@onready var area = $LatchArea

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.has_method("set_latch_point"):
		body.set_latch_point(self)


func _on_body_exited(body):
	if body.has_method("clear_latch_point"):
		body.clear_latch_point(self)
