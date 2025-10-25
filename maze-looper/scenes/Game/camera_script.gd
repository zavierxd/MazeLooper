extends Camera2D

# variables
@onready var targetNode = $"../Player"

# code
func _process(_dt: float) -> void:
	position = targetNode.position;
