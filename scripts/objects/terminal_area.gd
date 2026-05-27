extends Area2D

@onready var terminal_area: Area2D = $"."
@onready var aviso_terminal: Label = $avisoTerminal
@onready var interface_documento: CanvasLayer = $"../../InterfaceDocumento"
@onready var interface_terminal: CanvasLayer = $"../../InterfaceTerminal"

var jogador_perto = false

func _ready():
	aviso_terminal.visible = false
	body_entered.connect(_ao_entrar_no_terminal)
	body_exited.connect(_ao_sair_do_terminal)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		interface_terminal.visible = !interface_terminal.visible

func _ao_entrar_no_terminal(body):
	if body.name.to_lower() == "player":
		jogador_perto = true
		aviso_terminal.visible = true

func _ao_sair_do_terminal(body):
	if body.name.to_lower() == "player":
		jogador_perto = false
		aviso_terminal.visible = false
		interface_terminal.visible = false

func _on_botao_opcao_1_pressed():
	resposta_errada()

func _on_botao_opcao_2_pressed():
	print("Resposta Correta! Carregando a Fase 2...")
	get_tree().change_scene_to_file("res://scenes/levels/fase_2.tscn")

func _on_botao_opcao_3_pressed():
	resposta_errada()



func resposta_correta():
	print("Boa! Resposta Certa!")
	get_tree().change_scene_to_file("res://fase_2.tscn")

func resposta_errada():
	print("Xiii, resposta incorreta!")
	interface_terminal.visible = false
	
	
