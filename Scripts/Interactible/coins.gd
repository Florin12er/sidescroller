extends Node2D

func _ready():
	$AnimationPlayer.play("Idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManger.gain_coins(1)
	queue_free()
	
