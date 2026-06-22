extends Control

@export var dice_result: int = 1

var mat
var random_value
var random_rotate

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	mat = color_rect.material as ShaderMaterial
	SignalBus.connect("si_dice_rolled", _dice_roll)

func _process(_delta) -> void:
	mat.set_shader_parameter("value", dice_result)


## TESTING: Use keyboard input only for playtesting and debugging
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("test_d"):
		#_dice_roll()
		#_rotate_dice()


func _dice_roll() -> void:
	randomize()
	random_value = randi_range(1,6)
	await get_tree().create_timer(0.5).timeout
	dice_result = random_value
	_rotate_dice()


func _rotate_dice() -> void:
	randomize()
	random_rotate = randi_range(0,1)
	if random_rotate > 0:
		color_rect.offset_transform_rotation += deg_to_rad(90)
	else:
		pass
