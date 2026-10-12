extends Area2D
class_name Portal

@export var portal_destino: Portal # Arrastra el otro portal aquí
@export var zoom_efecto: Vector2 = Vector2(1.4, 1.4) # Zoom al entrar (ej. 1.4 para acercar / 0.8 para alejar)
@export var zoom_normal: Vector2 = Vector2(1.0, 1.0) # Zoom base de tu juego

var en_cooldown: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is protagonista and not en_cooldown and portal_destino:
		en_cooldown = true
		portal_destino.en_cooldown = true
		
		# 1. Teletransporte instantáneo al punto del destino
		body.global_position = portal_destino.global_position
		
		# 2. Efecto de cámara: Cambio rápido y vuelta a la normalidad
		var camara = get_viewport().get_camera_2d()
		if camara:
			var tween = create_tween()
			# Amplía/modifica el zoom en 0.08s
			tween.tween_property(camara, "zoom", zoom_efecto, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			# Regresa suavemente al zoom normal en 0.15s
			tween.tween_property(camara, "zoom", zoom_normal, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
		# 3. Margen de tiempo para evitar teletransportes infinitos en bucle
		await get_tree().create_timer(0.3).timeout
		en_cooldown = false
		portal_destino.en_cooldown = false
