extends Control

@export_file("*.tscn") var primeira_fase: String

@onready var texto_contexto: Label = $TextoContexto
@onready var aviso_avancar: Label = $AvisoAvancar

var slides_texto: Array[String] = [
	"Nesta introdução, o jogador assume o controle de um primata que precisa escapar de um laboratório de pesquisas secretas onde ocorrem testes cruéis. Para conquistar a liberdade e avançar entre as fases, o objetivo principal é explorar os cenários com cuidado, encontrar documentos ocultos e usar essas informações para responder corretamente às perguntas sobre bioética e proteção animal nos terminais trancados."
]

var slide_atual: int = 0

func _ready():
	if slides_texto.size() > 0:
		texto_contexto.text = slides_texto[slide_atual]
	else:
		_ir_para_o_jogo()

func _input(event):
	if event.is_action_pressed("interagir") or (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		avancar_slide()

func avancar_slide():
	slide_atual += 1
	
	if slide_atual < slides_texto.size():
		texto_contexto.text = slides_texto[slide_atual]
	else:
		_ir_para_o_jogo()

func _ir_para_o_jogo():
	if primeira_fase != "":
		print("Introdução concluída! Carregando Fase 1...")
		get_tree().change_scene_to_file(primeira_fase)
	else:
		print("Erro: Você esqueceu de arrastar a Fase 1 no Inspetor da Introdução!")
