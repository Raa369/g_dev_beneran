extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -450.0
@onready var player_ui: AnimatedSprite2D = $AnimatedSprite2D
var isAttack = false
var isJump =false

	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("attack") and not isAttack:
		isAttack=true
		player_ui.play("punch")
		await get_tree().create_timer(0.5).timeout
		isAttack=false
	if isAttack:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
		
	if velocity.x > 0 or velocity.x < 0:
		player_ui.animation="lari"
	else:
		player_ui.animation="idle"
		
	if velocity.x >0:
		player_ui.flip_h= false
	elif velocity.x < 0:
		player_ui.flip_h=true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("lompat") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if not is_on_floor():
		player_ui.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("kiri", "kanan")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


	


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_pop_up_draw() -> void:
	pass # Replace with function body.
