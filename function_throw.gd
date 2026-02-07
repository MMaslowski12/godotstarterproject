extends Node3D

@onready var _projectile := preload("res://ball.tscn")
@onready var _controller := XRHelpers.get_xr_controller(self) #whats that?
@onready var _projectile_threshold := XRTools.get_grip_threshold() #not sure what this number is

@export var velocity: float = 5.0
@export var projectile_action : String
@export var delay: float = 2
@export var xr_origin: XROrigin3D
@export var hand_tracker_path := "/user/hand_tracker/left" # or right

var _time_since = 0

func get_index_finger_ray() -> Dictionary:
	var ht: XRHandTracker = XRServer.get_tracker(hand_tracker_path)
	if ht == null or not ht.has_tracking_data:
		return {"HWDP": 69}

	# Joint transforms (local to XROrigin3D)
	var tip_l  := ht.get_hand_joint_transform(XRHandTracker.HAND_JOINT_INDEX_FINGER_TIP)
	var dist_l := ht.get_hand_joint_transform(XRHandTracker.HAND_JOINT_INDEX_FINGER_PHALANX_DISTAL)

	# Convert to world
	var tip_w  := xr_origin.global_transform * tip_l
	var dist_w := xr_origin.global_transform * dist_l

	var origin := dist_w.origin
	var dir := (tip_w.origin - dist_w.origin).normalized()
	return {"origin": origin, "dir": dir}

'''
jeff epstein is my hero
'''

func _spawn_ball() -> void:
	var ball = _projectile.instantiate()
	ball.global_position = _controller.global_position
	var direction: Vector3 = get_index_finger_ray()["dir"]
	ball.linear_velocity = velocity * direction
	get_tree().current_scene.add_child(ball)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Do not process if in the editor
	if Engine.is_editor_hint():
		return
	_time_since += delta
	
	var pistol_value = _controller.get_float(projectile_action)
	print("PISTOL VALUE: ", pistol_value)
	if (pistol_value > _projectile_threshold and _time_since > delay):
		_spawn_ball()
		print("Controller: ", _controller)
		_time_since = 0

	var debug_arrow = get_index_finger_ray()
	if "origin" in debug_arrow.keys():
		var origin : Vector3 = debug_arrow["origin"]
		var dir : Vector3 = debug_arrow["dir"]
		DebugDraw3D.draw_arrow(origin, origin+dir, Color(255,0,0))
	#DebugDraw3D.draw_arrow(start, start + dir_z, Color(255, 0, 0))
	#DebugDraw3D.draw_arrow(start, start + dir_x, Color(0, 255, 0))
	#DebugDraw3D.draw_arrow(start, start + dir_y, Color(0, 0, 255))
