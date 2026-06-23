extends Control

@export_file("*.tscn") var primeira_fase: String

@onready var botao_jogar: Button = $VBoxContainer/BotaoJogar
@onready var botao_sair: Button = $VBoxContainer/BotaoSair

func _ready():
	if botao_jogar:
		botao_jogar.pressed.connect(_on_botao_jogar_pressed)
	if botao_sair:
		botao_sair.pressed.connect(_on_botao_sair_pressed)

func _on_botao_jogar_pressed():
	if primeira_fase != "":
		print("Iniciando o jogo...")
		get_tree().change_scene_to_file(primeira_fase)
	else:
		print("Erro: Você esqueceu de arrastar a sua Fase 1 para o Inspetor do Menu!")

func _on_botao_sair_pressed():
	print("Saindo do jogo...")
	get_tree().quit() 
