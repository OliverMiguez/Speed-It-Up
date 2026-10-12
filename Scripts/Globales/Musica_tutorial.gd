extends AudioStreamPlayer

@onready var musica_tutorial: AudioStreamPlayer = $"."

func _ready() -> void:
	musica_tutorial.play()

func _on_finished() -> void:
	musica_tutorial.play()
