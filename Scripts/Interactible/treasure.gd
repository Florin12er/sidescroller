extends Node2D

var active = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not active:
		$AnimationPlayer.play("Open")
		GameManger.gain_coins(10)
		active = true
