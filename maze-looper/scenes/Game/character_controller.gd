extends CharacterBody2D

# this is so cool
# oh here we go, so it's exactly like python lmao

# variables
@onready var screen = get_viewport_rect().size
@export var maxSpeed = 300

# code
func _ready() -> void:
	print(screen)

func _process(_dt: float) -> void:
	velocity += ( (Vector2( ( int(Input.is_action_pressed("pm_right")) - int(Input.is_action_pressed("pm_left")) ), ( int(Input.is_action_pressed("pm_down")) - int(Input.is_action_pressed("pm_up")) ) ) * maxSpeed) - velocity ) / 5

func _physics_process(_dt: float) -> void:
	move_and_slide()
