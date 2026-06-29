extends Control


var dice_mat
var fire_mat
var random_value
var random_rotate
var my_delay: float = 2.0
var dice_scale: Vector2
var dice_scaling_factor: float = 1.2
var tweeny: Tween

# INFO: ±1.15 for safety margin beyon 1.0
@export var fire_progress: float = -1.15
@export var dice_result: int = 1
@export var color_rect: ColorRect
@export var sprite_2d: Sprite2D


func _ready() -> void:
	dice_mat = color_rect.material as ShaderMaterial
	#fire_mat = sprite_2d.material as Material
	#fire_mat = fire_mat.duplicate()
	fire_mat = sprite_2d.material as ShaderMaterial
	fire_progress = -2.0
	dice_scale = self.scale
	
	var random_seed
	randomize()
	random_seed = randi_range(0,12)
	fire_mat.set_shader_parameter("seed", random_seed)
	
	SignalBus.connect("si_dice_rolled", _dice_roll)
	SignalBus.connect("si_dice_picked_up", _straighten_dice)
	SignalBus.connect("si_dice_reconstruct", _reconstruct_dice)


func _process(_delta) -> void:
	dice_mat.set_shader_parameter("value", dice_result)
	fire_mat.set_shader_parameter("progress", fire_progress)


func _dice_roll() -> void:
	_reconstruct_dice()
	if tweeny: tweeny.kill()
	_dice_scaling()
	randomize()
	random_value = randi_range(1,6)
	await get_tree().create_timer(0.5).timeout
	dice_result = random_value
	_rotate_dice()


func _dice_scaling():
	tweeny = create_tween().set_ease(Tween.EASE_OUT)
	tweeny.set_trans(Tween.TRANS_BOUNCE)
	tweeny.tween_property(self, "scale", dice_scale * dice_scaling_factor, 0.3)
	tweeny.tween_property(self, "scale",dice_scale , 0.2)


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


func destroy_dice() -> void:
	randomize()
	var random_direction = randi_range(-90,90)
	var tween = create_tween()
		# set burning direction in degrees
	fire_mat.set_shader_parameter("direction", random_direction)
		# use tweens to animate the progress value
	tween.tween_method(update_progress, -2.0, 2.0, 1.0)
	SignalBus.si_dice_destroyed.emit()
	await get_tree().create_timer(my_delay).timeout


func _reconstruct_dice() -> void:
	fire_progress = -2.0


func update_progress(value: float):
	fire_progress = value 
