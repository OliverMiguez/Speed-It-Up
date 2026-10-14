extends Control
class_name pausa

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	# El menú empieza oculto y funcional a pesar de pausas
	visible = false
	canvas_layer.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS # Evita que se congele cuando se hace pause

func _input(event: InputEvent) -> void:
	# Detecta la acción de escapar (tecla ESC por defecto)
	if event.is_action_pressed("ui_cancel"):
		var visible_botones = canvas_layer.visible
		visible_botones = not visible_botones
		alternar_pausa()

# Pausa/Despausa si se presiona ESC
func alternar_pausa() -> void:
	var esta_pausado = get_tree().paused	# Crea una variable temporal que recoge true/false segun el estado del juego
	get_tree().paused = not esta_pausado	# Si pausa = true => pausa = false y asi al revés también
	#visible = not visible					# Si los objetos no son visibles los hace visible y asi al revés también
	canvas_layer.visible = not canvas_layer.visible

#Despausa el juego si se presiona BACK
func _on_back_pressed() -> void:
	var esta_pausado = get_tree().paused # crea una variable temporal que recoge true/false segun el estado del juegio
	get_tree().paused = not esta_pausado
	visible = not visible
