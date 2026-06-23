extends Area2D

@export var interface_dialogo: Node = null
@export var texto_label: Label = null
@export var timer_texto: Timer = null

@export var janela_sprite: Sprite2D = null

@onready var aviso_janela: Label = get_node_or_null("AvisoJanela")

var textura_cientistas = preload("res://assets/sprites/janela02.png")
var textura_original: Texture2D

var falas: Array = [
	"Cientista 1: Você leu a nova legislação? As restrições sobre testes em animais foram ampliadas...",
	"Cientista 2: Sim, deveríamos adaptar todos os protocolos do laboratório o quanto antes",
	"Cientista 1: Se não mudarmos para métodos alternativos, vamos nos meter em problemas graves"
]

var fala_atual = 0
var caractere_atual = 0
var dialogo_ativo = false
var player_ref: CharacterBody2D = null
var player_na_area: CharacterBody2D = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if timer_texto:
		timer_texto.timeout.connect(_mostrar_proxima_letra)
	
	if janela_sprite:
		textura_original = janela_sprite.texture
		
	if aviso_janela:
		aviso_janela.visible = false

func _input(event):
	if player_na_area and not dialogo_ativo and event.is_action_pressed("interagir"):
		iniciar_dialogo()
	
	elif dialogo_ativo and (event.is_action_pressed("interagir") or event.is_action_pressed("ui_accept")):
		if texto_label and texto_label.text != falas[fala_atual]:
			texto_label.text = falas[fala_atual]
		else:
			fala_atual += 1
			if fala_atual < falas.size():
				exibir_fala()
			else:
				encerrar_dialogo()

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_na_area = body
		if aviso_janela and not dialogo_ativo:
			aviso_janela.visible = true
		print("Player chegou perto da janela. Aperte E para espiar.")

func _on_body_exited(body):
	if body == player_na_area:
		player_na_area = null
		if aviso_janela:
			aviso_janela.visible = false

func iniciar_dialogo():
	dialogo_ativo = false 
	player_ref = player_na_area
	dialogo_ativo = true
	
	if aviso_janela:
		aviso_janela.visible = false
	
	if janela_sprite:
		janela_sprite.texture = textura_cientistas
	
	if "pode_se_mover" in player_ref:
		player_ref.pode_se_mover = false
		player_ref.velocity = Vector2.ZERO
		
	if interface_dialogo:
		interface_dialogo.visible = true
		
	fala_atual = 0
	exibir_fala()

func exibir_fala():
	if texto_label:
		texto_label.text = ""
	caractere_atual = 0
	if timer_texto:
		timer_texto.start()

func _mostrar_proxima_letra():
	if fala_atual < falas.size() and texto_label and timer_texto:
		if caractere_atual < falas[fala_atual].length():
			texto_label.text += falas[fala_atual][caractere_atual]
			caractere_atual += 1
			timer_texto.start()

func encerrar_dialogo():
	dialogo_ativo = false
	if interface_dialogo:
		interface_dialogo.visible = false
	
	if janela_sprite and textura_original:
		janela_sprite.texture = textura_original
	
	if player_ref and "pode_se_mover" in player_ref:
		player_ref.pode_se_mover = true
	
	print("Diálogo encerrado!")
	queue_free() 
