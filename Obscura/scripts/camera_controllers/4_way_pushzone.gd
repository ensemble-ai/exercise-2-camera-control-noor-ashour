class_name FourWayPushZone
extends CameraControllerBase


@export var push_ratio:float = 2.0
@export var pushbox_top_left:Vector2 = Vector2(0, 10)
@export var pushbox_bottom_right:Vector2 = Vector2(10, 0)
@export var speedup_zone_top_left:Vector2 = Vector2(0, 5)
@export var speedup_zone_bottom_right:Vector2 = Vector2(5, 0)

var box_width:float = pushbox_bottom_right.x
var box_height:float = pushbox_top_left.y
var inner_box_width:float = speedup_zone_bottom_right.x
var inner_box_height:float = speedup_zone_top_left.y


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		center_camera_on_target()
		return
	
	if draw_camera_logic:
		draw_logic()
	
	if target.velocity != Vector3.ZERO:
		var tpos:Vector3 = target.global_position
		var cpos:Vector3 = global_position
		var speed:float = 5.0
		var final_speed:float = 0.0
		if !is_touching_pushbox(tpos, cpos):
			if is_touching_speedup_zone(tpos):
				final_speed = speed * push_ratio
				if is_touching_a_corner():
					final_speed -= 2.0
		else:
			final_speed = box_width - (target.WIDTH / 2.0)
		global_position = global_position.lerp(target.global_position, final_speed * delta)
	
	super(delta)


func is_touching_pushbox(tpos:Vector3, cpos:Vector3) -> bool:
	var is_touching:bool = false
	
	var diff_between_left_edges:float =  (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	var diff_between_right_edges:float = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	var diff_between_top_edges:float = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	var diff_between_bottom_edges:float = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	
	if (
			diff_between_left_edges < 0 
			or diff_between_right_edges > 0
			or diff_between_bottom_edges > 0
			or diff_between_top_edges < 0
	):
		is_touching = true
	
	return is_touching


func is_touching_speedup_zone(tpos:Vector3) -> bool:
	var is_touching_speedup:bool = false
	
	var diff_between_left_edges:float =  (tpos.x - target.WIDTH / 2.0)
	var diff_between_right_edges:float = (tpos.x + target.WIDTH / 2.0)
	var diff_between_top_edges:float = (tpos.z - target.HEIGHT / 2.0)
	var diff_between_bottom_edges:float = (tpos.z + target.HEIGHT / 2.0)
	
	if (
		diff_between_left_edges >= speedup_zone_top_left.x
		or diff_between_right_edges <= speedup_zone_bottom_right.x
		or diff_between_top_edges >= speedup_zone_top_left.y
		or diff_between_bottom_edges <= speedup_zone_bottom_right.y
	):
		is_touching_speedup = true
	
	return is_touching_speedup


func is_touching_a_corner() -> bool:
	var is_touching:bool = false
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).limit_length(1.0)
	
	if abs(input.x) < 1 and abs(input.y) > 0: # if input vector is something like (0.707..., 0.707...)
		is_touching = true 

	return is_touching

func draw_logic() -> void:
	draw_box(box_width, box_height)
	draw_box(inner_box_width, inner_box_height)
