extends Control

@export_file("*.tscn") var primeira_fase: String

@onready var texto_tutorial: Label = $TextoTutorial

func _ready():
	texto_tutorial.text = "MECÂNICAS DE FUGA (FASE 1):\n\n" + \
		"• Movimentação: Use as setas do teclado.\n" + \
		"• Pulo: Aperte [Espaço] para pular.\n" + \
		"• Escalar Armários: Ande em direção a um armário de metal e segure [Cima] ou [W] para subir.\n" + \
		"• Escalar Teto: Pule em direção aos cabos ou ladeiras do teto para se pendurar e andar por cima!\n" + \
		"• Interagir: Aperte [E] para ler papéis ou mexer no terminal.\n\n" + \
		"Aperte [E] ou clique na tela para Iniciar o Jogo!"

func _input(event):
	if event.is_action_pressed("interagir") or (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		_iniciar_fase()

func _iniciar_fase():
	if primeira_fase != "":
		get_tree().change_scene_to_file(primeira_fase)
	else:
		print("Erro: Esqueceu de arrastar a Fase 1 no Inspetor do Tutorial!")
