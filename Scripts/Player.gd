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
			projectile.global_position = AttackpointLeft.global_position
			AttackpointLeft.add_child(projectile)
			
			print("Debug : Attacking Left")
			AttackCooldown.start(2)
			
	
	
	if Input.is_action_just_pressed("attack_right") and is_on_floor():
		if attacking == false:
			attacking = true
			var projectile = Projectile.instantiate()
			#projectile.position = Attackpoint.position
			
			AttackpointRight.add_child(projectile)
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
	
	var testcollision = get_last_slide_collision()
	if testcollision != null :
		var collided = testcollision.get_collider()
		if not collided.is_in_group("Bad Guy") : 
			var hit = testcollision.get_collider()
			var vec = hit.local_to_map(Vector2(global_position.x , global_position.y +32 ))
			#print(vec)
			var data = hit.get_cell_tile_data(0, vec)
			##can the current tile be destroyed or climbed on
		
			if data : 
				var _destroy = data.get_custom_data("Destructible") # TODO: Add something to check for and support blowing up tiles
				var  _ladder =  data.get_custom_data("Climbing") # TODO:  Add something to check for and support climbing lad

		#print((testcollision.get_coords_for_body_rid(testcollision)))
		#print(testcollision.get_collider_rid() + "Collided with the tilemap on this node")
		#print(testcollision.get_collider().get_coords_for_body_rid(hit))
		#print(hit.get_cell_tile_data(0, vec))



		#print(testcollision.get_collider().get_surrounding_cells(global_position))

func _on_attack_cooldown_timeout():
	attacking = false
	print("Debug: Cooldown expired")
	
