class_name PositionLock
extends CameraControllerBase


@export var box_width:float = 10.0
@export var box_height:float = 10.0


func _ready() -> void:
	cross_length = 2
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	#var tpos = target.global_position
	#var cpos = global_position
	
	#boundary checks
	#left
	#var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
	
	global_position.x = target.global_position.x
	global_position.z = target.global_position.z
	super(delta)


func draw_logic() -> void:
	draw_cross()
