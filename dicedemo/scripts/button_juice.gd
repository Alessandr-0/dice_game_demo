## INFO: Original from https://qaqelol.itch.io/tweens
# TODO: https://youtu.be/cIetsUMtyQc wellicht wat uitbreidingen

extends Button


var duration: float = 0.25
var tweeny: Tween


func _ready() -> void:
	# set pivot to bottom center
	# TODO: uitzoeken hoe die offset werkt
	pivot_offset = size + Vector2(0.5, 1.0)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

# When the button is hovered on by mouse
func _on_mouse_entered():
	# kill the tween to prevent bugs
	if tweeny: tweeny.kill()
	scale = Vector2(1.08, 1.08)

# When the button is no longer hovered on
func _on_mouse_exited():
	# kill the tween to prevent bugs
	if tweeny: tweeny.kill()
	scale = Vector2(1, 1)

# When the button is pressed down
func _on_button_down():
	# kill the tween to prevent bugs
	if tweeny: tweeny.kill()
	scale = Vector2(0.9, 0.7)
	SignalBus.si_any_button_was_pressed.emit()

# When the butten isn't pressed anymore
func _on_button_up():
	tweeny = create_tween().set_ease(Tween.EASE_OUT)
	tweeny.set_trans(Tween.TRANS_BOUNCE)
	tweeny.tween_property(self, "scale", Vector2(1,1), duration)
