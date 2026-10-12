extends "res://Scripts/Protagonista/MaquinaEstados/State.gd"

@export var duracion_hasta_reiniciar: float = 1.0 # 1 segundo es ideal para un runner rápido

var ya_procesado: bool = false

func on_enter():
	# Evitamos ejecuciones dobles en el mismo intento
	if ya_procesado:
		return
		
	ya_procesado = true
	ControladorMuerte.a_muerto = true
	ControladorMuerte.muertes += 1
	
	print("--- MUERTE REGISTRADA. Total acumulado:", ControladorMuerte.muertes, "---")
		
	if father:
		father.se_puede_mover = false
		father.velocity.x = 0
		
		# 1. Leemos la causa guardada en el protagonista
		var causa = "pincho"
		if "tipo_causa_muerte" in father:
			causa = father.tipo_causa_muerte

		print("--- CAUSA DE MUERTE LEÍDA POR EL ESTADO: '", causa, "' ---")

		# 2. Reproducimos el audio correspondiente
		if causa == "flecha":
			var audio_flechas = father.get_node_or_null("MuerteFlechas")
			if audio_flechas:
				audio_flechas.play()
			elif has_node("../../MuerteFlechas"):
				$"../../MuerteFlechas".play()
		else:
			var audio_pinchos = father.get_node_or_null("MuertePinchos")
			if audio_pinchos:
				audio_pinchos.play()
			elif has_node("../../MuertePinchos"):
				$"../../MuertePinchos".play()
	
	if animation_player:
		animation_player.play("SLIDER")
	
	esperar_y_reiniciar()

func state_process(delta: float) -> void:
	if father:
		father.velocity.x = 0
		father.aplicar_gravedad(delta)

func esperar_y_reiniciar() -> void:
	await get_tree().create_timer(duracion_hasta_reiniciar).timeout
	
	# IMPORTANTE: Reseteamos las banderas locales y globales ANTES de reiniciar
	ya_procesado = false
	ControladorMuerte.a_muerto = false
	if father and "tipo_causa_muerte" in father:
		father.tipo_causa_muerte = "pincho" # Restablecer valor por defecto
	
	get_tree().reload_current_scene()
