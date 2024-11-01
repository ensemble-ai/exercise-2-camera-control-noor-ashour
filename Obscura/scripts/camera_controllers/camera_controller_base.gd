class_name CameraControllerBase
extends Camera3D


@export var target:Vessel
@export var dist_above_target:float = 10.0
@export var zoom_speed:float = 10.0
@export var min_zoom:float = 5.0
@export var max_zoom:float = 100.0
@export var draw_camera_logic:bool = false

var cross_length : int = 1;

#camera tilt around the z axis in radians
#var _camera_tilt_rad:float = 0.0
#var _camera_tilt_speed:float = 0.1

func _ready() -> void:
	current = false
	position += Vector3(0.0, dist_above_target, 0.0) 


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic
	if Input.is_action_pressed("zoom_in"):
		dist_above_target = clampf(dist_above_target - zoom_speed * delta, min_zoom, max_zoom)
	if Input.is_action_pressed("zoom_out"):
		dist_above_target = clampf(dist_above_target + zoom_speed * delta, min_zoom, max_zoom)
	
	#camera tilt code for the brave
	#if Input.is_action_pressed("camera_tilt_left"):
		#_camera_tilt_rad += _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#elif Input.is_action_pressed("camera_tilt_right"):
		#_camera_tilt_rad -= _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#else:
		#_camera_tilt_rad += -signf(_camera_tilt_rad) * _camera_tilt_speed * delta
		#if abs(_camera_tilt_rad) < 0.01:
			#_camera_tilt_rad = 0.0
		#rotation.z = _camera_tilt_rad
		
	position.y = target.position.y + dist_above_target


func center_camera_on_target() -> void:
	global_position.x = target.global_position.x
	global_position.z = target.global_position.z


func draw_logic() -> void:
	pass

func draw_box(box_width : float, box_height : float) -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func draw_cross() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	material.no_depth_test = true
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_set_normal(Vector3(0, 1, 0))
	immediate_mesh.surface_set_uv(Vector2(1, 1))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length))
	immediate_mesh.surface_add_vertex(Vector3(cross_length, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-cross_length, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
