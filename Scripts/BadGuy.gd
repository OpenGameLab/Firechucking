extends CharacterBody2D

@export var HP = 100
@export var attack = 50
const SPEED = 85.0
const JUMP_VELOCITY = -400.0
signal jump
#@onready var player = get_parent().player
@onready var player : CharacterBody2D = $"../Player"

@onready var Ray = $FrontRay
@onready var Sprite = $Sprite2D
@onready var GapRay = $GapRay

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print(str(player))
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta



# chase the player
	if is_instance_valid(player):
		
		if player.global_position.x >= global_position.x :
			velocity.x = SPEED 
			Ray.scale.x = -1 
			GapRay.scale.x = -1
		
		else : 
			velocity.x = -1 * SPEED
			Ray.scale.x = 1
			GapRay.scale.x = 1
			
			
#check if we need to jump
	if Ray.is_colliding() :
		print ("ray colliding")
		var RayHit = Ray.get_collider()
		
		if RayHit != player :
			print("I should be jumping")
			if is_on_floor() : velocity.y = JUMP_VELOCITY

	if  GapRay.is_colliding() == false :
		print ("GapRay not colliding, I should be Jumping")
		if is_on_floor() : velocity.y = JUMP_VELOCITY

	move_and_slide()
	
	
	
	var testcollision = get_last_slide_collision()
	if testcollision != null :
		var collided = testcollision.get_collider()
		if collided.is_in_group("Good Guys") :
			collided.HP -= attack
			print(collided.HP)
			if collided.HP <= 0 :
					collided.queue_free()
		

