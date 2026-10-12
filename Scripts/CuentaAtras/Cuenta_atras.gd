extends Control

class_name ConteoInicio

# Arrastra texturas desde el FileSystem a estos slots en el Inspector
@export var tex_3: Texture2D
@export var tex_2: Texture2D
@export var tex_1: Texture2D
@export var tex_go: Texture2D

@onready var sprite_conteo: TextureRect = $SpriteConteo
@onready var timer_conteo: Timer = $TimerConteo

# Señal para avisar al juego/jugador de que el conteo ha terminado
signal conteo_finalizado

var paso_actual: int = 0
var lista_sprites: Array[Texture2D] = []

func _ready() -> void:
	lista_sprites = [tex_3, tex_2, tex_1, tex_go]
	timer_conteo.timeout.connect(_al_terminar_timer)
	iniciar_conteo()

func iniciar_conteo() -> void:
	paso_actual = 0
	_mostrar_paso()

func _mostrar_paso() -> void:
	if paso_actual < lista_sprites.size():
		sprite_conteo.texture = lista_sprites[paso_actual]
		sprite_conteo.visible = true
		
		# Feedback visual
		sprite_conteo.scale = Vector2(1.3, 1.3)
		var tween = create_tween()
		tween.tween_property(sprite_conteo, "scale", Vector2(1.0, 1.0), 0.15)
		
		# SI LLEGAMOS A 'GO!' (último sprite de la lista):
		if paso_actual == lista_sprites.size() - 1:
			# Solo emitimos la señal para que el Nivel active al jugador y la música a la vez
			conteo_finalizado.emit()

		timer_conteo.start()
	else:
		# Conteo terminado (se acaba el tiempo de la imagen de GO!)
		sprite_conteo.visible = false

func _al_terminar_timer() -> void:
	paso_actual += 1
	_mostrar_paso()
