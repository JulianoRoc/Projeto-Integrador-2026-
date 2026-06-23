extends Area2D

@export var interface_terminal: Node = null
@export var cronometro_texto: Label = null
@export var timer_fuga: Timer = null
@export var tela_game_over: Node = null

var player_na_area: CharacterBody2D = null
var alerta_disparado: bool = false
var lendo_alerta: bool = false

func _ready():
	if cronometro_texto: cronometro_texto.visible = false
	if tela_game_over: tela_game_over.visible = false
	
	if timer_fuga:
		timer_fuga.timeout.connect(_on_timer_fuga_timeout)

func _process(delta):
	if timer_fuga and not timer_fuga.is_stopped():
		var tempo_restante = int(timer_fuga.time_left)
		var minutos = tempo_restante / 60
		var segundos = tempo_restante % 60
		cronometro_texto.text = str("%02d" % minutos) + ":" + str("%02d" % segundos)

func _input(event):
	if event.is_action_pressed("interagir"):
		if lendo_alerta:
			fechar_alerta_e_iniciar_fuga()
		elif player_na_area and not alerta_disparado:
			disparar_alerta_laboratorio()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_na_area = body
		print("Macaco chegou no terminal do laboratório!")

func _on_body_exited(body: Node2D) -> void:
	if body == player_na_area:
		player_na_area = null

func disparar_alerta_laboratorio():
	alerta_disparado = true
	lendo_alerta = true
	
	player_na_area.pode_se_mover = false
	player_na_area.velocity = Vector2.ZERO
	
	if interface_terminal:
		interface_terminal.visible = true
	print("Mostrando imagem de alerta no terminal...")

func fechar_alerta_e_iniciar_fuga():
	lendo_alerta = false
	
	if interface_terminal:
		interface_terminal.visible = false
		
	player_na_area.pode_se_mover = true
	
	if cronometro_texto and timer_fuga:
		cronometro_texto.visible = true
		timer_fuga.start(60.0) 
		print("Fuga iniciada! Corra!")

func _on_timer_fuga_timeout():
	if cronometro_texto:
		cronometro_texto.visible = false
		
	if tela_game_over:
		tela_game_over.visible = true
		tela_game_over.process_mode = Node.PROCESS_MODE_ALWAYS 
		
	get_tree().paused = true
	print("Game Over: O tempo acabou!")
