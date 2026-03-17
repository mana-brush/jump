extends CharacterBody2D


# --- TUNING ---
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 900.0

enum State {
	NORMAL,
	HANGING
}

var state = State.NORMAL

# Current latch target
var current_latch_point: Node2D = null


func _physics_process(delta):

	match state:

		State.NORMAL:
			handle_movement(delta)

			if current_latch_point and Input.is_action_just_pressed("latch"):
				latch_to_point()

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

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	move_and_slide()


# -------------------------
# 🧲 LATCH
# -------------------------
func latch_to_point():
	state = State.HANGING
	velocity = Vector2.ZERO

	var snap_position = current_latch_point.get_node("SnapPoint").global_position
	global_position = snap_position


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
	elif Input.is_action_just_pressed("ui_down"):
		state = State.NORMAL
		velocity.y = 100

func set_latch_point(point):
	current_latch_point = point

func clear_latch_point(point):
	if current_latch_point == point:
		current_latch_point = null
