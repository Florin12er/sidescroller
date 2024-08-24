extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

func _ready() -> void:
	if spawnpoint:
		active()

func active():
	GameManger.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("Wind")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !activated:
		active()
