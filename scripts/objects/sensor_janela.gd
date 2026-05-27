extends Area2D

@onready var interface_dialogo = $"/root/Fase-2/InterfaceDialogo"
@onready var texto_label = $"/root/Fase-2/InterfaceDialogo/Panel/TextoDialogo"
@onready var timer_texto = $"/root/Fase-2/InterfaceDialogo/Panel/TimerTexto"

@onready var janela: StaticBody2D = $".."
@onready var janela_sprite: Sprite2D = $"../Sprite2D"

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

func _ready():
	body_entered.connect(_on_body_entered)
	timer_texto.timeout.connect(_mostrar_proxima_letra)
	
	if janela_sprite:
		textura_original = janela_sprite.texture

func _input(event):
	if dialogo_ativo and (event.is_action_pressed("interagir") or event.is_action_pressed("ui_accept")):
		if texto_label.text != falas[fala_atual]:
			texto_label.text = falas[fala_atual]
		else:
			fala_atual += 1
			if fala_atual < falas.size():
				exibir_fala()
			else:
				encerrar_dialogo()

func _on_body_entered(body):
	if body.name.to_lower() == "player" and not dialogo_ativo:
		player_ref = body
		dialogo_ativo = true
		
		if janela_sprite:
			janela_sprite.texture = textura_cientistas
		
		if "pode_se_mover" in player_ref:
			player_ref.pode_se_mover = false
			player_ref.velocity = Vector2.ZERO
			
		interface_dialogo.visible = true
		fala_atual = 0
		exibir_fala()

func exibir_fala():
	texto_label.text = ""
	caractere_atual = 0
	timer_texto.start()

func _mostrar_proxima_letra():
	if caractere_atual < falas[fala_atual].length():
		texto_label.text += falas[fala_atual][caractere_atual]
		caractere_atual += 1
		timer_texto.start()

func encerrar_dialogo():
	dialogo_ativo = false
	interface_dialogo.visible = false
	
	if janela_sprite and textura_original:
		janela_sprite.texture = textura_original
	
	if player_ref and "pode_se_mover" in player_ref:
		player_ref.pode_se_mover = true
	
	queue_free() 
