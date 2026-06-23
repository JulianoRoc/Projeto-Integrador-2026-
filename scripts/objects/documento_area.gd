extends Area2D

@onready var aviso_documento: Label = get_node_or_null("avisoTexto")

@export var terminal_area_node: Area2D = null
@export var interface_documento: CanvasLayer = null

var jogador_perto = false
var lendo = false
var player_ref: CharacterBody2D = null

func _ready():
	if aviso_documento:
		aviso_documento.text = "[E] Ler Documento"
		aviso_documento.visible = false
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		if not lendo:
			abrir_documento_no_painel()
		else:
			fechar_documento_no_painel()

func _on_body_entered(body):
	if body is CharacterBody2D and body.name.to_lower() == "player":
		jogador_perto = true
		player_ref = body
		if aviso_documento:
			aviso_documento.visible = true

func _on_body_exited(body):
	if body == player_ref:
		jogador_perto = false
		player_ref = null
		if aviso_documento:
			aviso_documento.visible = false
		if interface_documento:
			interface_documento.visible = false
		lendo = false

func abrir_documento_no_painel():
	if not interface_documento: return
	lendo = true
	interface_documento.visible = true
	if aviso_documento: aviso_documento.visible = false
	
	if player_ref and "pode_se_mover" in player_ref:
		player_ref.pode_se_mover = false
		player_ref.velocity = Vector2.ZERO
		
	if terminal_area_node and terminal_area_node.has_method("liberar_terminal_do_quiz"):
		terminal_area_node.liberar_terminal_do_quiz()

func fechar_documento_no_painel():
	lendo = false
	if interface_documento:
		interface_documento.visible = false
	if aviso_documento:
		aviso_documento.visible = true
		
	if player_ref and "pode_se_mover" in player_ref:
		player_ref.pode_se_mover = true
