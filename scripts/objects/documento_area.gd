extends Area2D

@onready var aviso_texto = $avisoTexto 
@onready var interface_documento: CanvasLayer = $"../../InterfaceDocumento"
@onready var interface_terminal: CanvasLayer = $"../../InterfaceTerminal"

var jogador_perto = false

func _ready():
	aviso_texto.visible = false
	
	body_entered.connect(_ao_entrar_na_area)
	body_exited.connect(_ao_sair_da_area)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		interface_documento.visible = !interface_documento.visible

func _ao_entrar_na_area(body):
	if body.name.to_lower() == "player": 
		jogador_perto = true
		aviso_texto.visible = true

func _ao_sair_da_area(body):
	if body.name.to_lower() == "player":
		jogador_perto = false
		aviso_texto.visible = false
		interface_documento.visible = false
