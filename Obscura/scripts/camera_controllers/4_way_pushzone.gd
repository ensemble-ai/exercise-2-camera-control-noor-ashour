class_name FourWayPushZone
extends CameraControllerBase


@export var box_width:float = 10.0
@export var box_height:float = 10.0

var inner_box_width:float = box_width - (box_width / 2)
var inner_box_height:float = box_height - (box_height / 2)

@export var push_ratio:float = 2.0
@export var pushbox_top_left:Vector2 = Vector2(0, box_height)
@export var pushbox_bottom_right:Vector2 = Vector2(box_width, 0)
@export var speedup_zone_top_left:Vector2 = Vector2(0, inner_box_height)
@export var speedup_zone_bottom_right:Vector2 = Vector2(inner_box_width, 0)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		center_camera_on_target()
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	var vertical_speedup_diff = (box_height - inner_box_height) / 2.0
	var horizontal_speedup_diff = (box_width - inner_box_width) / 2.0
	
	#boundary checks
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	#if diff_between_left_edges < 0:
	#	global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	#if diff_between_right_edges > 0:
	#	global_position.x += diff_between_right_edges
	# top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	#if diff_between_top_edges < 0:
	#	global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	#if diff_between_bottom_edges > 0:
	#	global_position.z += diff_between_bottom_edges
	#var diff_btn_top_left_corner = (pushbox_top_left - Vector2(diff_between_left_edges, diff_between_top_edges)).round()
	
	var diff_btn_inner_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - inner_box_width / 2.0)
	var diff_btn_inner_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + inner_box_width / 2.0)
	var diff_btn_inner_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - inner_box_height / 2.0)
	var diff_btn_inner_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + inner_box_height / 2.0)
	
	var is_target_touching_pushbox = false
	if (diff_between_left_edges < 0 or 
		diff_between_right_edges < 0 or
		diff_between_top_edges < 0 or 
		diff_between_bottom_edges < 0):
		is_target_touching_pushbox = true
	
	var is_target_touching_speedup_box = false
	if (diff_btn_inner_left_edges < 0 or 
		diff_btn_inner_right_edges < 0 or
		diff_btn_inner_top_edges < 0 or 
		diff_btn_inner_bottom_edges < 0):
		is_target_touching_speedup_box = true
	
	if (target.velocity != Vector3.ZERO):
		
		if diff_btn_inner_left_edges < 0:
			$"../../debug2".text = str("We're moving!")
			global_position.x += -vertical_speedup_diff * push_ratio
		elif diff_btn_inner_right_edges < 0:
			global_position.x += vertical_speedup_diff * push_ratio
		elif diff_btn_inner_top_edges < 0:
			global_position.z += -horizontal_speedup_diff * push_ratio
		elif diff_btn_inner_bottom_edges < 0:
			global_position.z += horizontal_speedup_diff * push_ratio
			
		
		#global_position.x = target.velocity.x * push_ratio
		#global_position.z = target.velocity.z * push_ratio
	#else:
	#	center_camera_on_target()
	
	
	super(delta)


func draw_logic() -> void:
	draw_box(box_width, box_height)
	draw_box(inner_box_width, inner_box_height)
