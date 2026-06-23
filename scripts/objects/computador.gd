extends Area2D

@export var interface_doc: Node = null

@onready var aviso_interagir: Label = $AvisoInteragir

var player_na_area: CharacterBody2D = null
var documento_aberto: bool = false

func _ready():
	if aviso_interagir:
		aviso_interagir.visible = false

func _input(event):
	if player_na_area and event.is_action_pressed("interagir"):
		if not documento_aberto:
			abrir_computador()
		else:
			fechar_computador()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_na_area = body
		
		if aviso_interagir and not documento_aberto:
			aviso_interagir.visible = true
		print("Macaco chegou perto do computador!")

func _on_body_exited(body: Node2D) -> void:
	if body == player_na_area:
		if aviso_interagir:
			aviso_interagir.visible = false
			
		if not documento_aberto:
			player_na_area = null
			print("Macaco se afastou do computador.")

func abrir_computador():
	if not interface_doc: return
	documento_aberto = true
	
	if aviso_interagir:
		aviso_interagir.visible = false
	
	player_na_area.pode_se_mover = false
	player_na_area.velocity = Vector2.ZERO
	interface_doc.visible = true

func fechar_computador():
	if interface_doc:
		interface_doc.visible = false
		
	documento_aberto = false
	player_na_area.pode_se_mover = true
	
	if aviso_interagir and player_na_area:
		aviso_interagir.visible = true
