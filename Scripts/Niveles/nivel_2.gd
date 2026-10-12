extends Node2D

@onready var jugador: protagonista = $Protagonista 
@onready var reproductor_musica: AudioStreamPlayer = $MusicaNivel 

func _ready() -> void:
	MusicaMenuV2.stop()
	if ControladorMuerte.cont_nvl_2 == false:
		$AnimationPlayer.play("Trans1")
		ControladorMuerte.cont_nvl_2 = true
	else:
		$CanvasLayer/ColorRect.queue_free()
	if jugador:
		jugador.se_puede_mover = false

func _on_cuenta_atras_conteo_finalizado() -> void:
	print("--- 1. SEÑAL DE CONTEO RECIBIDA EN EL NIVEL ---")
	# 1. Avisamos al personaje para que la FSM salga del estado Bloqueador
	if jugador:
		jugador.se_puede_mover = true
		if jugador.has_method("_on_cuenta_atras_terminada"):
			print("--- 2. LLAMANDO A _on_cuenta_atras_terminada EN EL JUGADOR ---")
			jugador._on_cuenta_atras_terminada()

	# 2. Gestión de audio
	if $MusicaNivel.has_method("iniciar_con_ritmo"):
		$MusicaNivel.iniciar_con_ritmo()
		
	if reproductor_musica and not reproductor_musica.playing:
		reproductor_musica.play()

func _on_musica_nivel_finished() -> void:
	if reproductor_musica:
		reproductor_musica.play()


func _on_victoria_body_entered(body: Node2D) -> void:
	if body is protagonista:
		$AnimationPlayer.play("Trans2")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://Escenas/Menu/Menu_inicio.tscn")
