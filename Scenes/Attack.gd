extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
	
	var testcollision = get_last_slide_collision()
	if testcollision != null :
		
		#Tell us what we hit
		


		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			print("Collided with: ", collision.get_collider().name)
			#if collision.get_collider() == TileMap : print(str(collision.get_collider()) + "Tilemap Cell Found" ))
			#collision.get_collider().queue_free()  # kill whatever we hit

		
		
		#kill the bullet when we explode
		queue_free()
