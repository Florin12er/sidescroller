extends CharacterBody2D
class_name Player

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -350.0
@export var DOUBLE_JUMP_VELOCITY = -250.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_double_jump = false
@export var attacking = false

func _ready() -> void:
	GameManger.player = self

func _process(delta: float) -> void:
	if !attacking:
		check_attacks()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x)

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			can_double_jump = true
		elif can_double_jump:
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false

	var direction := Input.get_axis("left", "right")
	if direction and !attacking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	update_animation()

	move_and_slide()
	
	if position.y >= 600:
		die()

func check_attacks():
	if Input.is_action_just_pressed("Attack"):
		if Input.is_action_pressed("up"):
			attack_up()
		elif Input.is_action_pressed("left"):
			attack_left()
		elif Input.is_action_pressed("right"):
			attack_right()
		elif !is_on_floor():
			attack_jump()
		else:
			attack_normal()

func register_attack():
	var overlaping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlaping_objects:
		var parent = area.get_parent()
		parent.queue_free()
	
func attack_normal():
	register_attack()
	attacking = true
	animation_player.play("Attack")
	await animation_player.animation_finished
	attacking = false

func attack_up():
	register_attack()
	attacking = true
	animation_player.play("UpAttack")
	await animation_player.animation_finished
	attacking = false

func attack_left():
	register_attack()
	attacking = true
	sprite.scale.x = abs(sprite.scale.x) * -1
	animation_player.play("LeftAttack")
	await animation_player.animation_finished
	attacking = false

func attack_right():
	register_attack()
	attacking = true
	sprite.scale.x = abs(sprite.scale.x)
	animation_player.play("LeftAttack")
	await animation_player.animation_finished
	attacking = false

func attack_jump():
	register_attack()
	attacking = true
	animation_player.play("JumpAttack")
	await animation_player.animation_finished
	attacking = false

func update_animation():
	if !attacking:
		if !is_on_floor():
			if velocity.y < 0:
				animation_player.play("Jump")
			else:
				animation_player.play("FALL")
		elif velocity.x != 0:
			animation_player.play("RUN")
		else:
			animation_player.play("Idle")

func die():
	GameManger.respawn_player()
