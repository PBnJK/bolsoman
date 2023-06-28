extends Control

var listen_for_input := false

onready var z_label := $BarBottom/Label as Label

onready var label_timer := $LabelTimer as Timer

func _input(event: InputEvent) -> void:
	if not listen_for_input or not event is InputEventKey:
		return
	
	if event.is_action_pressed("shoot"):
		listen_for_input = false
		z_label.visible = false
		label_timer.wait_time = 0.1
		
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Intro":
		listen_for_input = true
		label_timer.start()

func _on_LabelTimer_timeout() -> void:
	z_label.visible = not z_label.visible
