extends CharacterBody2D

# --- TUNING ---
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 900.0
const LATCH_SPEED = 10.0

var latch_target_position: Vector2

enum State {
	NORMAL,
	LATCHING,
	HANGING
}

var state = State.NORMAL
var current_checkpoint: Node2D

# Current latch target
var current_latch_point: Node2D = null

var nearby_interactable = null

func _physics_process(delta):

	if nearby_interactable:
		print("Near %s" % nearby_interactable.name);

	match state:
		State.NORMAL:
			handle_movement(delta)
			if current_latch_point and Input.is_action_just_pressed("latch"):
				latch_to_point(delta)
		State.LATCHING:
			handle_latching(delta)
		State.HANGING:
			handle_hanging()


# -------------------------
# 🏃 MOVEMENT
# -------------------------
func handle_movement(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	move_and_slide()


# -------------------------
# 🧲 LATCH
# -------------------------
func latch_to_point(delta):
	state = State.LATCHING
	velocity = Vector2.ZERO

	latch_target_position = current_latch_point.get_node("SnapPoint").global_position
	
func handle_latching(delta):
	# Smooth movement toward target
	global_position = global_position.lerp(
		latch_target_position,
		LATCH_SPEED * delta
	)

	# Check if close enough
	if global_position.distance_to(latch_target_position) < 2.0:
		global_position = latch_target_position
		state = State.HANGING

# -------------------------
# 🪜 HANGING
# -------------------------
func handle_hanging():

	velocity = Vector2.ZERO

	# Jump off
	if Input.is_action_just_pressed("ui_select"):
		state = State.NORMAL
		velocity.y = JUMP_VELOCITY

	# Optional: drop
	elif Input.is_action_just_pressed("move_down"):
		state = State.NORMAL
		velocity.y = 100

func set_latch_point(point):
	current_latch_point = point

func clear_latch_point(point):
	if current_latch_point == point:
		current_latch_point = null

func set_interactable(obj):
	nearby_interactable = obj
	
func clear_interactable(obj):
	if nearby_interactable == obj:
		nearby_interactable = null

func set_checkpoint(point: Node2D):
	
	# only set if new checkpoint
	if (current_checkpoint and current_checkpoint.name == point.name):
		return
		
	current_checkpoint = point
	print("Checkpoint set:", point.name)
	
func respawn():
	if current_checkpoint:
		state = State.NORMAL
		current_latch_point = null
		global_position = current_checkpoint.global_position
		velocity = Vector2.ZERO
