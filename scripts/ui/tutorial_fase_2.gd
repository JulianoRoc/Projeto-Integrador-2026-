extends Control

@export_file("*.tscn") var segunda_fase: String

@onready var texto_tutorial: Label = $TextoTutorial

func _ready():
	texto_tutorial.text = "NOVAS MECÂNICAS (FASE 2):\n\n" + \
		"• Mover Objetos: Ande em direção às caixas no chão para empurrá-las.\n" + \
		"• Criar Caminhos: Arraste as caixas para perto dos armários para conseguir subir neles.\n" + \
		"Aperte [E] ou clique na tela para Iniciar a Fase 2!"

func _input(event):
	if event.is_action_pressed("interagir") or (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		_iniciar_fase()

func _iniciar_fase():
	if segunda_fase != "":
		get_tree().change_scene_to_file(segunda_fase)
	else:
		print("Erro: Esqueceu de arrastar a Fase 2 no Inspetor do Tutorial!")
