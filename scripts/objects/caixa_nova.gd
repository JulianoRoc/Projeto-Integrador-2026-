extends Area2D

@export var mostrar_documento: bool = false

@export var interface_doc: Node = null

var player_na_area: CharacterBody2D = null
var player_escondido: bool = false

func _ready():
	pass

func _input(event):
	if player_na_area and event.is_action_pressed("interagir"):
		if player_escondido and mostrar_documento and interface_doc and interface_doc.visible:
			fechar_documento_da_caixa()
		elif not player_escondido:
			esconder_player()
		else:
			tirar_player()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("entrar_no_esconderijo"):
		player_na_area = body
		print("O macaco de verdade chegou na caixa!")
	else:
		print("Um cientista passou pela caixa, ignorando...")

func _on_body_exited(body: Node2D) -> void:
	if body == player_na_area and not player_escondido:
		player_na_area = null
		print("Player saiu da área da caixa.")

func esconder_player():
	if not player_na_area: return
	player_escondido = true
	
	player_na_area.entrar_no_esconderijo()
	
	if mostrar_documento and interface_doc:
		interface_doc.visible = true
		print("Documento aberto ao entrar na caixa!")
	
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func fechar_documento_da_caixa():
	if interface_doc:
		interface_doc.visible = false
		print("Documento fechado! Próximo aperto de 'E' vai tirar o macaco da caixa.")

func tirar_player():
	if not player_na_area: return
	
	if mostrar_documento and interface_doc and interface_doc.visible:
		interface_doc.visible = false
		
	player_escondido = false
	player_na_area.sair_do_esconderijo()
	
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	print("Macaco saiu da caixa!")
