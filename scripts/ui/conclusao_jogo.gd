extends Control

@onready var texto_conclusao: Label = $TextoConclusao

func _ready():
	texto_conclusao.text = "PARABÉNS! VOCÊ CONQUISTOU A LIBERDADE!\n\n" + \
		"Obrigado por jogar LabChange! A revolução pelo respeito à vida animal continua com você.\n\n" + \
		"Aperte [E] ou clique na tela para voltar ao Menu Inicial."

func _input(event):
	if event.is_action_pressed("interagir") or (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		_voltar_ao_menu()

func _voltar_ao_menu():
	get_tree().change_scene_to_file("res://scenes/ui/menu_inicial.tscn")
