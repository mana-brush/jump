extends Node2D

@onready var area = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.has_method("set_checkpoint"):
		body.set_checkpoint(self)
