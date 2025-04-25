extends CharacterBody2D

var max_speed = 100
var last_direction := Vector2(1, 0)
var is_attacking = false

@onready var attack_timer = Timer.new()

func _ready():
	# Setup timer to control how long attack animation lasts
	attack_timer.wait_time = 0.5
	attack_timer.one_shot = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)

func _physics_process(delta):
	if is_attacking:
		return  # Skip movement if attacking

	var direction = Input.get_vector("move_left", "move_right", "jump", "move_down")
	velocity = direction * max_speed
	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		play_attack_animation()
		return

	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
	else:
		play_idle_animation(direction)

func play_walk_animation(direction): 
	if direction.x > 0:
		$AnimatedSprite2D.play("move_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("move_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("move_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("jump")

func play_idle_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("idle_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("idle_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("idle_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("jump")

func play_attack_animation():
	is_attacking = true
	$AnimatedSprite2D.play("attack")
	attack_timer.start()  # Start the 0.5s timer to end attack

func _on_attack_timer_timeout():
	is_attacking = false
	$AnimatedSprite2D.play("idle_down")

