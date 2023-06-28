class_name Player
extends KinematicBody2D

enum States {
	IDLE,
	WALK,
	RUN
}

const WALK_SPEED := 5000.0
const RUN_SPEED  := 7500.0

var input := 0.0

var velocity := Vector2.ZERO

var speed := WALK_SPEED

var state: int = States.IDLE

onready var sprite := $Sprite as Sprite
onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	animation_player.play("Blink")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		input = Input.get_axis("move_left", "move_right")
		
		if not is_zero_approx(input):
			sprite.flip_h = false if input > 0 else true
		
		if not input:
			if state != States.IDLE:
				state = _switch_states(States.IDLE)
		else:
			if Input.is_action_pressed("run"):
				state = _switch_states(States.RUN)
			else:
				state = _switch_states(States.WALK)

func _physics_process(delta: float) -> void:
	_move(delta)
	
func _move(delta: float) -> void:
	if state == States.IDLE:
		return
	elif state == States.WALK:
		speed = WALK_SPEED
	elif state == States.RUN:
		speed = RUN_SPEED
		
	velocity.x = input * speed * delta
	
	velocity = move_and_slide(velocity)
	
func _switch_states(new_state: int) -> int:
	if state == new_state:
		return new_state
		
	match new_state:
		States.IDLE:
			animation_player.play("Blink")
		States.WALK:
			if state == States.RUN:
				animation_player.play("Walk")
			elif not animation_player.current_animation == "Walk":
				animation_player.play("InchWalk")
		States.RUN:
			animation_player.play("Run")
	
	return new_state

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "InchWalk":
		animation_player.play("Walk")
