class_name CatchUp
extends CameraControllerBase

@export var follow_speed:float = 10.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 10.0 - (dist_above_target / 2.0)

func _ready() -> void:
	cross_length = 2
	position = target.position
	super()


func _process(delta: float) -> void:
	if !current:
		center_camera_on_target()
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var speed:float
	if target.velocity != Vector3.ZERO:
		speed = follow_speed
	else:
		speed = catchup_speed
	
	var tpos = Vector2(target.global_position.x, target.global_position.z)
	var cpos = Vector2(global_position.x, global_position.z)
	var distance_to_target = cpos.distance_to(tpos)
	
	if distance_to_target <= leash_distance:
		var future_target_position = target.global_position - target.velocity * 0.2
		global_position = global_position.lerp(future_target_position, speed * delta)
	else:
		global_position = global_position.lerp(target.global_position, speed * delta)

	super(delta)


func draw_logic() -> void:
	draw_cross()
