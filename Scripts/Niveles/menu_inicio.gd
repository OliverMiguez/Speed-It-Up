extends  Node2D
class_name MenuInicio
@onready var jugador: protagonista = $Protagonista # Ajusta el nombre/ruta a tu personaje
@onready var reproductor_musica: AudioStreamPlayer = $MusicaNivel # Tu nodo de audio si está en el nivel
@onready var audio_stream_player: AudioStreamPlayer = $MusicaNivel
@onready var mi_camara: Camera2D = $Camera2D
@onready var mi_canvas: CanvasModulate = $CanvasModulate

func _ready() -> void:
	MusicaMenuV2.registrar_nodos(mi_camara, mi_canvas)
	MusicaMenuV2.iniciar_con_ritmo()
	#$MusicaNivel.iniciar_con_ritmo()
	pass

func _on_musica_nivel_finished() -> void:
	reproductor_musica.play()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Niveles/Nivel_1.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menu/Configuracion.tscn")


func _on_play_mouse_entered() -> void:
	$AudioStreamPlayer2D.play()


func _on_exit_mouse_entered() -> void:
	$AudioStreamPlayer2D2.play()


func _on_settings_mouse_entered() -> void:
	$AudioStreamPlayer2D3.play()
