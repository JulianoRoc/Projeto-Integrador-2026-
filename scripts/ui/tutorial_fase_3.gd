extends Control

@export_file("*.tscn") var terceira_fase: String

@onready var texto_tutorial: Label = $TextoTutorial

func _ready():
	texto_tutorial.text = "NOVAS MECÂNICAS (FASE 3):\n\n" + \
		"• Cuidado com o Cientista: Há um guarda patrulhando a sala. Se ele avistar você, é Game Over!\n" + \
		"• Usar Esconderijos: Aproxime-se de uma das caixas de madeira e aperte [E] para entrar e se esconder.\n" + \
		"• Objetivo Duplo: Vasculhe as caixas para encontrar o documento oculto e use a brecha na patrulha para responder ao terminal com segurança!\n\n" + \
		"Aperte [E] ou clique na tela para Iniciar a Fase 3!"

func _input(event):
	if event.is_action_pressed("interagir") or (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		_iniciar_fase()

func _iniciar_fase():
	if terceira_fase != "":
		get_tree().change_scene_to_file(terceira_fase)
	else:
		print("Erro: Esqueceu de arrastar a Fase 3 no Inspetor do Tutorial!")
