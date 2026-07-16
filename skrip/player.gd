extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -450.0
@onready var player_ui: AnimatedSprite2D = $AnimatedSprite2D
@onready var combo_timer: Timer=$combat_timer
@onready var health_bar: ProgressBar=$"Camera2D/health bar"
var max_bar=100
var default_bar=100
var isAttack = false
var isJump =false
var combo=0
var can_attack=true


func _ready() -> void:
	health_bar.max_value=max_bar
	health_bar.value=default_bar
	
	player_ui.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	combo_timer.timeout.connect(_on_combat_timer_timeout)

func take_damage(amount: int) -> void:
	default_bar-=amount
	default_bar=clamp(default_bar,0,max_bar)
	health_bar.value=default_bar
	if default_bar<=0:
		die()
		
func die()->void:
	print("PLAYER MATI! GAME OVER")
	# Di sini lu bisa play animasi mati, atau restart scene, dll.
	# get_tree().reload_current_scene() # <--- Contoh kalau mau auto-restart map
func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("lompat") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("kiri", "kanan")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if not isAttack:
		if velocity.x > 0 or velocity.x < 0:
			player_ui.play("lari")
		else:
			player_ui.play("idle")
		if not is_on_floor():
			player_ui.play("jump")
			
		if velocity.x >0:
			player_ui.flip_h= false
		elif velocity.x < 0:
			player_ui.flip_h=true
	
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("attack") and can_attack:
			combat()
		move_and_slide()

func combat():
	isAttack=true
	can_attack=false
	combo_timer.start()
	if combo==0:
		player_ui.play("pukul kanan")
		combo=1
	elif combo==1:
		player_ui.play("pukul kiri")
		combo=0
func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_pop_up_draw() -> void:
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if player_ui.animation == "pukul kanan" or player_ui.animation == "pukul kiri":
		isAttack = false
		can_attack = true


func _on_combat_timer_timeout() -> void:
	combo=0
