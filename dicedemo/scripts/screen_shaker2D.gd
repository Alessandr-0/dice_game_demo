class_name ScreenShaker2D
extends Camera2D
## INFO: Original from Mina Pêcheux: https://www.youtube.com/watch?v=Xrh6SQL3Fvo
# CAUTION: 2D version
# NOTE: To use in same tree:
# func camera_effect(shake_duration = null, shake_strength = null) -> void:
	# ScreenShaker.instance.shake(shake_duration, shake_strength)
	
static var instance: ScreenShaker2D

@export var duration: float = 1.0
@export var strength: float = 5

var tweeny: Tween = null


func _ready() -> void:
	instance = self

func shake(_duration = null, _strength = null):
	var d = _duration if _duration != null else duration
	var s = _strength if _strength != null else strength
	var base_offset = offset
	if tweeny: tweeny.kill()
	tweeny = get_tree().create_tween()
	tweeny.tween_method(func (delay: float):
		var movement = Vector2(
			randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * s * delay
		offset = base_offset + movement, 1.0, 0.0, d)
