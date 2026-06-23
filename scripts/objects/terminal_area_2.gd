extends Area2D

@onready var terminal_area: Area2D = $"."
@onready var aviso_terminal: Label = $avisoTerminal
@onready var interface_documento: CanvasLayer = $"../../InterfaceDocumento"
@onready var interface_terminal: CanvasLayer = $"../../InterfaceTerminal"

var jogador_perto = false
var documento_lido = false
var player_ref: CharacterBody2D = null

func _ready():
	aviso_terminal.visible = false
	body_entered.connect(_ao_entrar_no_terminal)
	body_exited.connect(_ao_sair_do_terminal)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		if documento_lido:
			aviso_terminal.text = "[E] Interagir"
			interface_terminal.visible = !interface_terminal.visible
		else:
			interface_terminal.visible = false
			mostrar_aviso_bloqueio()

func _ao_entrar_no_terminal(body):
	if body is CharacterBody2D and body.name.to_lower() == "player":
		jogador_perto = true
		player_ref = body
		if documento_lido:
			aviso_terminal.text = "[E] Interagir"
		aviso_terminal.visible = true

func _ao_sair_do_terminal(body):
	if body == player_ref:
		jogador_perto = false
		player_ref = null
		aviso_terminal.visible = false
		interface_terminal.visible = false

func liberar_terminal_do_quiz():
	documento_lido = true
	print("Sinal recebido! Terminal liberado.")

func mostrar_aviso_bloqueio():
	aviso_terminal.text = "ACESSO NEGADO!\nProcure e leia o documento em cima do armário antes de responder."
	aviso_terminal.visible = true
	
	await get_tree().create_timer(4.0).timeout
	if jogador_perto and not interface_terminal.visible:
		aviso_terminal.text = "[E] Interagir"

func _on_botao_opcao_1_pressed():
	print("Resposta Correta! Carregando a Fase 2...")
	get_tree().change_scene_to_file("res://scenes/ui/tutorial_fase_3.tscn")

func _on_botao_opcao_2_pressed():
	resposta_errada()

func _on_botao_opcao_3_pressed():
	resposta_errada()

func resposta_errada():
	print("Resposta incorreta!")
	interface_terminal.visible = false 
	
	aviso_terminal.text = "RESPOSTA INCORRETA!\nLeia o documento no armário novamente antes de tentar de novo."
	aviso_terminal.visible = true
	
	await get_tree().create_timer(5.0).timeout
	if jogador_perto and not interface_terminal.visible:
		aviso_terminal.text = "[E] Interagir"
