extends Area2D

@onready var aviso_texto = $avisoTexto # Ajustado para o 'a' minúsculo que vi na árvore
@onready var interface_documento: CanvasLayer = $"../../InterfaceDocumento"
@onready var interface_terminal: CanvasLayer = $"../../InterfaceTerminal"

var jogador_perto = false

func _ready():
	aviso_texto.visible = false
	
	# CONEXÃO FORÇADA VIA CÓDIGO (Ignora o painel de sinais do editor)
	body_entered.connect(_ao_entrar_na_area)
	body_exited.connect(_ao_sair_da_area)

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		interface_documento.visible = !interface_documento.visible

# Nova função de entrada limpa
func _ao_entrar_na_area(body):
	if body.name.to_lower() == "player": # .to_lower() ignora se digitou Player ou player
		jogador_perto = true
		aviso_texto.visible = true

# Nova função de saída limpa
func _ao_sair_da_area(body):
	if body.name.to_lower() == "player":
		jogador_perto = false
		aviso_texto.visible = false
		interface_documento.visible = false
