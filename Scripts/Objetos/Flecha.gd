extends Area2D
class_name Flecha

@export var velocidad: float = 250.0

@export var direccion: Vector2 = Vector2.LEFT:
	set(val):
		direccion = val
		ajustar_sprite()

@onready var sprite: Sprite2D = $Dibujo

func _ready() -> void:
	ajustar_sprite()

func _physics_process(delta: float) -> void:
	mover_flecha(delta)

func mover_flecha(delta: float) -> void:
	if direccion != Vector2.ZERO:
		global_position += direccion.normalized() * velocidad * delta

func ajustar_sprite() -> void:
	if not is_node_ready() or sprite == null:
		return
		
	sprite.rotation = 0
	
	if direccion.x != 0:
		sprite.flip_h = (direccion.x > 0)
		sprite.flip_v = false
	elif direccion.y != 0:
		sprite.flip_h = false
		if direccion.y < 0:
			sprite.rotation = deg_to_rad(90)
		else:
			sprite.rotation = deg_to_rad(-90)

# Detecta tanto al Jugador como al Escenario
func _on_body_entered(body: Node2D) -> void:
	if body is protagonista:
		if "tipo_causa_muerte" in body:
			body.tipo_causa_muerte = "flecha"
		ControladorMuerte.a_muerto = true
		queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		queue_free()
