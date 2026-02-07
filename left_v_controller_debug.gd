extends XRController3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pose = get_pose()
	if pose != null:
		print("non null pose detected by left v controller")
		if pose.StringName == "grip":
			print("GRIP DETECTED", pose.active, pose.transform)
