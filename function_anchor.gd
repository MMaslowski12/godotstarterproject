extends Node3D
@onready var _controller := XRHelpers.get_xr_controller(self) #whats that?
@onready var spatial_anchor_manager: OpenXRFbSpatialAnchorManager = $"../../OpenXRFbSpatialAnchorManager"
@onready var _controller_manual := $'..'
@onready var _mesh = $'../MeshInstance3D2'


func _on_xr_controller_3d_button_pressed(name: String) -> void:
	if name == "pointbool":
		spatial_anchor_manager.create_anchor(_controller.global_transform, {})

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_controller.button_pressed.connect(_on_xr_controller_3d_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("CONT: ", _controller.get_float('pointbool'))
	pass
	
	
'So, controller is 1, but there is no signal. This is obv a fuckup. Find out why.'

'''
1. fix spatial anchor manager
1. fix size
2. fix only one action? IS this RE TAR DEDD????

'''
