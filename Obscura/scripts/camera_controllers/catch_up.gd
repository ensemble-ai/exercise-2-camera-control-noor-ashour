class_name CatchUp
extends CameraControllerBase


@export var follow_speed:float = 10.0
@export var catchup_speed:float = 10.0
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
	var target_position:Vector3 = target.global_position
	if target.velocity != Vector3.ZERO:
		speed = follow_speed
		var tpos = Vector2(target.global_position.x, target.global_position.z)
		var cpos = Vector2(global_position.x, global_position.z)
		var distance_to_target:float = cpos.distance_to(tpos)
		
		if distance_to_target < leash_distance:
			global_position = global_position.lerp(target_position, speed * delta)
		else:
			var additional_speed:float = 10.0
			global_position = global_position.lerp(target_position, (speed + additional_speed) * delta)
	else:
		speed = catchup_speed
		global_position = global_position.lerp(target_position, speed * delta)

	super(delta)


func draw_logic() -> void:
	draw_cross()
