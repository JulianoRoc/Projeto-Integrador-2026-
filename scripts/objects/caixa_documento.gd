extends Area2D

@export var interface_doc: CanvasLayer = null
@export var interface_quiz: CanvasLayer = null

@export var terminal_area_node: Area2D = null

var player_na_area: CharacterBody2D = null
var player_escondido: bool = false
var documento_lido: bool = false 

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if player_na_area and event.is_action_pressed("interagir"):
		if player_escondido:
			fechar_documento_e_caixa()
		else:
			entrar_na_caixa_e_ler()

func entrar_na_caixa_e_ler():
	if player_na_area and player_na_area.has_method("entrar_no_esconderijo"):
		player_escondido = true
		player_na_area.entrar_no_esconderijo()
		
		if interface_doc:
			interface_doc.visible = true
			documento_lido = true
			
			if terminal_area_node and terminal_area_node.has_method("liberar_terminal_do_quiz"):
				terminal_area_node.liberar_terminal_do_quiz()
		
		if interface_quiz:
			interface_quiz.visible = true
			
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)

func fechar_documento_e_caixa():
	if interface_doc: interface_doc.visible = false
	if interface_quiz: interface_quiz.visible = false
	
	player_escondido = false
	if player_na_area and player_na_area.has_method("sair_do_esconderijo"):
		player_na_area.sair_do_esconderijo()
		
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)

func _on_body_entered(body):
	if body is CharacterBody2D and body.has_method("entrar_no_esconderijo"):
		player_na_area = body

func _on_body_exited(body):
	if body == player_na_area:
		if not player_escondido:
			player_na_area = null
