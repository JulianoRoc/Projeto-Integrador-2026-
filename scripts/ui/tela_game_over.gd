extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if visible:
		if event.is_action_pressed("reiniciar") or (event is InputEventKey and event.pressed and event.keycode == KEY_R):
			print("Reiniciando a Fase 4...")
			get_tree().paused = false
			get_tree().reload_current_scene()
