class_name PositionLock
extends CameraControllerBase


func _ready() -> void:
	cross_length = 2
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		center_camera_on_target()
		return
	
	if draw_camera_logic:
		draw_logic()
	
	center_camera_on_target()
	super(delta)


func draw_logic() -> void:
	draw_cross()
