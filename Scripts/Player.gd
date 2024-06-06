extends CharacterBody2D

@export var HP = 100
const SPEED = 350.0
const JUMP_VELOCITY = -450.0

var attacking : bool = false
var jumping : bool = false
@onready var AttackCooldown = $AttackCooldown
@onready var Projectile = preload("res://Scenes/Attack.tscn")
@onready var AttackpointRight = $AttackOrginRight
@onready var AttackpointLeft = $AttackOrginLeft
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Root = $".."
@onready var Player = $"."


func _physics_process(delta):
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
		jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
	
	 
	if Input.is_action_just_pressed("attack_left") and is_on_floor():
		if attacking == false:
			attacking = true
			var projectile = Projectile.instantiate()
			#projectile.position = Attackpoint.position
			Root.add_child(projectile)
			projectile.global_position = AttackpointLeft.global_position
			print("Debug : Attacking Left")
			AttackCooldown.start(2)
			
	
	
	if Input.is_action_just_pressed("attack_right") and is_on_floor():
		if attacking == false:
			attacking = true
			var projectile = Projectile.instantiate()
			#projectile.position = Attackpoint.position
			Root.add_child(projectile)
			projectile.global_position = AttackpointRight.global_position
			print("Debug : Attacking right")
			AttackCooldown.start(2)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#if Input.is_action_just_pressed("ui_left") : Player.scale.x = -1
	#if Input.is_action_just_pressed("ui_right") : Player.scale.x = -1
	move_and_slide()
	

func _on_attack_cooldown_timeout():
	attacking = false
	print("Debug: Cooldown expired")
	
