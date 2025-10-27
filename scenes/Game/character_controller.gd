extends CharacterBody2D

# this is so cool
# oh here we go, so it's exactly like python lmao

# variables
@onready var screen = get_viewport_rect().size
@onready var sprite = $"PlayerTexture"

@export var maxSpeed = 520
@export var acceleration = 5
var unitVelocity = Vector2i(0, 0)

# code
func _ready() -> void:
	print(screen)

func _flip(x: float) -> void:
	print("flipped!")
	sprite.scale.x = 0.75 * x

func _process(_dt: float) -> void:
	var old = unitVelocity.x
	unitVelocity = Vector2(int( Input.is_action_pressed("pm_right") ) - int( Input.is_action_pressed("pm_left") ), int( Input.is_action_pressed("pm_down") ) - int( Input.is_action_pressed("pm_up")) )
	velocity += ((unitVelocity * maxSpeed) - velocity) / acceleration
	if old != unitVelocity.x: 
		if unitVelocity.x != 0: 
			_flip(unitVelocity.x) 
		else: print("move")

func _physics_process(_dt: float) -> void:
	move_and_slide()
