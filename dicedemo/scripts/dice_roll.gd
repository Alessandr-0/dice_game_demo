extends Control

@export var dice_result: int = 1
@export var fire_progress: float = -1.15

var dice_mat
var fire_mat
var random_value
var random_rotate

@onready var color_rect: ColorRect = $SubViewport/ColorRect
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	dice_mat = color_rect.material as ShaderMaterial
	fire_mat = sprite_2d.material as ShaderMaterial
	#fire_mat.set_shader_parameter("progress", -1.15)
	
	SignalBus.connect("si_dice_rolled", _dice_roll)
	SignalBus.connect("si_dice_picked_up", _straighten_dice)
	SignalBus.connect("si_dice_destroyed", _destroy_dice)
	SignalBus.connect("si_dice_survided", _survived_dice)


func _process(_delta) -> void:
	dice_mat.set_shader_parameter("value", dice_result)
	fire_mat.set_shader_parameter("progress", fire_progress)

## TESTING: Use keyboard input only for playtesting and debugging
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("test_d"):
		#_dice_roll()
		#_rotate_dice()


func _dice_roll() -> void:
	_reconstruct_dice()
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
	randomize()
	random_rotate = randi_range(-35,35)
	sprite_2d.rotation += deg_to_rad(random_rotate)


func _straighten_dice() -> void:
	sprite_2d.rotation -= deg_to_rad(random_rotate)


func _destroy_dice() -> void:
	print("* D E S T R O Y E D *")
	randomize()
	var random_direction = randi_range(20,160)
	var tween = create_tween()
		# set burning direction in degrees
	fire_mat.set_shader_parameter("direction", random_direction)
		# use tweens to animate the progress value
	tween.tween_method(update_progress, -1.5, 1.5, 1.0)
	#await get_tree().create_timer(0.5).timeout
	_reconstruct_dice()

func _reconstruct_dice() -> void:
	fire_progress = -1.15

func update_progress(value: float):
	#fire_mat.set_shader_parameter("progress", value)
	fire_progress = value 


func _survived_dice() -> void:
	print("~ survived ~")
