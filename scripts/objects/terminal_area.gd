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

# === SISTEMA DE VALIDAÇÃO DOS BOTÕES ===

# Conecte o sinal 'pressed()' do BotaoOpcao1 aqui
func _on_botao_opcao_1_pressed():
	resposta_errada()

# Conecte o sinal 'pressed()' do BotaoOpcao2 aqui (A CORRETA)
# Dentro do script do terminal da FASE 1:

func _on_botao_opcao_2_pressed():
	print("Resposta Correta! Carregando a Fase 2...")
	
	# Troca a cena atual para o arquivo da sua nova Fase 2
	# Garanta que a pasta e o nome do arquivo estejam iguaizinhos ao seu FileSystem!
	get_tree().change_scene_to_file("res://scenes/levels/fase_2.tscn")

# Conecte o sinal 'pressed()' do BotaoOpcao3 aqui
func _on_botao_opcao_3_pressed():
	resposta_errada()


# --- Funções de Consequência ---

func resposta_correta():
	print("Boa! Resposta Certa!")
	# Garanta que o nome do arquivo da fase 2 esteja certinho aqui:
	get_tree().change_scene_to_file("res://fase_2.tscn")

func resposta_errada():
	print("Xiii, resposta incorreta!")
	# Fecha a interface para o jogador ter que coletar a pista ou tentar de novo
	interface_terminal.visible = false
	
	
