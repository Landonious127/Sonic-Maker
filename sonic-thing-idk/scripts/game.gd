extends Node2D

@onready var tilemap: TileMap = $TileMap
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Player/Camera2D

var grid_size: int = 16   # tile size
var cursor_pos: Vector2 = Vector2.ZERO

func _process(delta):
	if Global.editor:
		get_tree().get_root().set_content_scale_size(Vector2i(852, 480))
		queue_redraw()
		player.set_physics_process(false)
	else:
		if Global.paused:
			player.set_physics_process(false)
		else: 
			player.set_physics_process(true)
		get_tree().get_root().set_content_scale_size(Vector2i(426, 240))
		queue_redraw()
