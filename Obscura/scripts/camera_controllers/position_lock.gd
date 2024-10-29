class_name PositionLock
extends CameraControllerBase


func _ready() -> void:
	cross_length = 2
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	global_position.x = target.global_position.x
	global_position.z = target.global_position.z
	super(delta)


func draw_logic() -> void:
	draw_cross()
