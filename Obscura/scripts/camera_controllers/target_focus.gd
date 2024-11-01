class_name TargetFocus
extends CameraControllerBase


@export var lead_speed:float = 10.0
@export var catchup_delay_duration:float = 2.0
@export var catchup_speed:float = 10.0
@export var leash_distance:float = 10.0 - (dist_above_target / 2.0)

var _timer:Timer
var _velocity_dampen:float = 0.2

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
	
	var tpos2D = Vector2(target.global_position.x, target.global_position.z)
	var cpos2D = Vector2(global_position.x, global_position.z)
	var distance_to_target:float = cpos2D.distance_to(tpos2D)
	
	if target.velocity != Vector3.ZERO: # if player is moving
		var future_position:Vector3 = target.global_position
		future_position.x += target.velocity.x * _velocity_dampen
		future_position.z += target.velocity.z * _velocity_dampen
		
		var speed:float = 0.0
		if distance_to_target > leash_distance:
			speed = 10.0
			
		global_position = global_position.lerp(future_position, (lead_speed - speed) * delta)
		
	else: # player stopped moving
		if _timer == null:
			_timer = Timer.new()
			add_child(_timer)
			_timer.one_shot = true
			
			if !is_zero_approx(catchup_delay_duration):
				_timer.start(catchup_delay_duration)
		if _timer.is_stopped():
			global_position = global_position.lerp(target.global_position, catchup_speed * delta)

	super(delta)


func draw_logic() -> void:
	draw_cross()
