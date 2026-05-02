extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = $Player
@onready var ground: StaticBody3D = $Ground

var is_selecting = false
var selection_start: Vector2
var selected_units: Array = []

func _ready():
	# Настройка камеры сверху
	camera.position = Vector3(0, 15, 0)
	camera.rotation_degrees = Vector3(-90, 0, 0)
	
	# Инициализация игрока
	player.position = Vector3(0, 0.5, 0)

func _input(event):
	# Выделение левой кнопкой мыши
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_selecting = true
				selection_start = event.position
			else:
				is_selecting = false
				select_units(selection_start, event.position)
	
	# Движение правой кнопкой мыши для перемещения
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed and selected_units.size() > 0:
			move_selected_units(event.position)

func select_units(start_pos: Vector2, end_pos: Vector2):
	selected_units.clear()
	
	# Создаём прямоугольник выделения
	var rect = Rect2(
		min(start_pos.x, end_pos.x),
		min(start_pos.y, end_pos.y),
		abs(end_pos.x - start_pos.x),
		abs(end_pos.y - start_pos.y)
	)
	
	# Проверяем, попадает ли игрок в прямоугольник
	var player_screen_pos = get_viewport().get_camera_3d().unproject_position(player.global_position)
	if rect.has_point(player_screen_pos):
		selected_units.append(player)
		print("Игрок выбран!")

func move_selected_units(target_screen_pos: Vector2):
	if selected_units.is_empty():
		return
	
	var camera = get_viewport().get_camera_3d()
	
	# Конвертируем позицию экрана в мировую позицию на плоскости Y=0
	var from = camera.project_ray_origin(target_screen_pos)
	var to = camera.project_ray(from, target_screen_pos)
	
	# Находим точку пересечения с плоскостью Y=0
	var direction = to - from
	var t = -from.y / direction.y
	var target_position = from + direction * t
	
	# Перемещаем выбранные юниты
	for unit in selected_units:
		unit.target_position = target_position
