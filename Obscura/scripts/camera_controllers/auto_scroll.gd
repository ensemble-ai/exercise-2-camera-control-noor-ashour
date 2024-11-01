class_name AutoScroll
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var top_left:Vector2 = Vector2(0, box_height)
@export var bottom_right:Vector2 = Vector2(box_width, 0)
@export var autoscroll_speed:float = target.BASE_SPEED / 2.0

var corner_pushback_value:float = 15.0
var target_additional_move_speed:float = 3.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		center_camera_on_target()
		return
	
	if draw_camera_logic:
		draw_logic()
	
#region Box Boundary Check
	var tpos = target.global_position
	var cpos = global_position
	
	#boundary checks
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
#endregion
	
	global_position.x += autoscroll_speed * delta 
	global_position.z += autoscroll_speed * delta
	
	var diff_btn_top_left_corner = (top_left - Vector2(diff_between_left_edges, diff_between_top_edges)).round()
	var diff_btn_bottom_right_corner = (bottom_right - Vector2(diff_between_right_edges, diff_between_bottom_edges)).round()
	
	# Check if vessel is near a corner
	if diff_btn_top_left_corner.is_equal_approx(top_left):
		target.global_position.x += (autoscroll_speed + corner_pushback_value) * delta
		target.global_position.z += (autoscroll_speed + corner_pushback_value) * delta
	elif diff_btn_bottom_right_corner.is_equal_approx(bottom_right):
		target.global_position.x -= (autoscroll_speed + corner_pushback_value) * delta
		target.global_position.z -= (autoscroll_speed + corner_pushback_value) * delta
	else:
		target.global_position.x += (autoscroll_speed + target_additional_move_speed) * delta
		target.global_position.z += (autoscroll_speed + target_additional_move_speed) * delta
	
	super(delta)


func draw_logic() -> void:
	draw_box(box_width, box_height)
	draw_cross()
