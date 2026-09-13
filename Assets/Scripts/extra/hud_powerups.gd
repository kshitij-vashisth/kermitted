extends CanvasLayer  # or Control
@onready var powerup_holder: Node = $"../SceneObjects/PowerUps"
@onready var t_points: RichTextLabel = $TPoints/TPoints
@export var hearts: Array[Node]
@onready var sfx_powerup = $sfx_powerup
var current_powerup_index: int = GameManager.current_powerup_index
@onready var player: CharacterBody2D = $"../SceneObjects/Player"


@export var defeated_particle: PackedScene

@export var stealth_node: Array[Node]
@export var power_node: Array[Node]
@export var armor_node: Array[Node]

@onready var stealth_uses: RichTextLabel = $Inventory/HBoxContainer/Stealth/stealth_uses
@onready var power_uses: RichTextLabel = $Inventory/HBoxContainer/Power/power_uses
@onready var armor_uses: RichTextLabel = $Inventory/HBoxContainer/Armor/armor_uses

# --- Powerup duration config ---
@export var stealth_max_time: float = 8.0
@export var power_max_time: float = 6.0
@export var armor_max_time: float = 10.0

# Stealth drains faster while the player is moving.
@export var stealth_deplete_idle: float = 1.0     # seconds of duration lost per real second, standing still
@export var stealth_deplete_moving: float = 2.5    # seconds of duration lost per real second, while moving
@export var power_deplete_rate: float = 1.0
@export var armor_deplete_rate: float = 1.0
@export var moving_speed_threshold: float = 5.0    # velocity length above this counts as "moving"

func _live_gone_screen() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/levels/LevelTransitionScreen.tscn")

func _player_collider_off() -> void:
	player.get_node("CollisionShape2DNormal").disabled = true


func spawn_defeat() -> void:
	call_deferred("_player_collider_off")
	player.set_physics_process(false)
	player.set_process(false)
	player.velocity = Vector2.ZERO
	player.hide()
	var warp_node = defeated_particle.instantiate()
	warp_node.global_position = player.global_position
	get_parent().add_child(warp_node)
	await get_tree().create_timer(2).timeout
	warp_node.queue_free()

func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/Art/game_elements/mouse-cursor.png"), Input.CURSOR_ARROW)

	update_ui()
	current_powerup_index = GameManager.current_powerup_index

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		_cycle_selection(-1)
	elif event.is_action_pressed("ui_right"):
		_cycle_selection(1)
	elif event.is_action_pressed("ui_accept"):
		_toggle_selected()

func _owned_indices() -> Array[int]:
	var result: Array[int] = []
	if GameManager.has_stealth:
		result.append(0)
	if GameManager.has_power:
		result.append(1)
	if GameManager.has_armor:
		result.append(2)
	return result

func _cycle_selection(direction: int) -> void:
	var owned := _owned_indices()
	if owned.is_empty():
		return
	var pos := owned.find(current_powerup_index)
	if pos == -1:
		pos = 0
	else:
		pos = (pos + direction + owned.size()) % owned.size()
	current_powerup_index = owned[pos]
	GameManager.current_powerup_index = current_powerup_index

func _toggle_selected() -> void:
	match current_powerup_index:
		0:
			if GameManager.has_stealth:
				GameManager.stealth_active = not GameManager.stealth_active
		1:
			if GameManager.has_power:
				GameManager.power_active = not GameManager.power_active
		2:
			if GameManager.has_armor:
				GameManager.armor_active = not GameManager.armor_active

func _game_over() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/menu/game_over.tscn")

func decrease_health(damage:int) -> void:
	if GameManager.hearts > damage:
		GameManager.hearts -= damage
		update_hearts()

	elif GameManager.hearts <= damage:
		if GameManager.lives <= 0 :
			call_deferred("_game_over")
		else:
			GameManager.lives -= 1
			if GameManager.lives <=0:
				call_deferred("_game_over")
			else:
				GameManager.hearts = 3
				spawn_defeat()
				await get_tree().create_timer(1.2).timeout
				call_deferred("_live_gone_screen")

func add_points(points: int) -> void:
	GameManager.points += points
	update_points()

func update_points() -> void:
	var final_points: String = GameManager.check_zero_add_zero()
	if t_points:
		t_points.text = final_points


func update_hearts() -> void:
	for h in 3:
		if h < GameManager.hearts:
			hearts[h].show()
		else:
			hearts[h].hide()

# STEALTH ==============================================
func stealth_picked() -> void:
	sfx_powerup.play()
	GameManager.has_stealth = true
	GameManager.stealth_time = stealth_max_time
	stealth_texture()
	_refresh_labels()

func stealth_texture() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/stealth_inventory.png")
	stealth_uses.show()
	for node in stealth_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

func stealth_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/Inventory_box.png")
	stealth_uses.hide()
	for node in stealth_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

# POWER =================================================
func power_picked() -> void:
	sfx_powerup.play()
	GameManager.has_power = true
	GameManager.power_time = power_max_time
	power_texture()
	_refresh_labels()

func power_texture() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/power_inventory.png")
	power_uses.show()
	for node in power_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

func power_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/Inventory_box.png")
	power_uses.hide()
	for node in power_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

# ARMOR ==================================================
func armor_picked() -> void:
	sfx_powerup.play()
	GameManager.has_armor = true
	GameManager.armor_time = armor_max_time
	armor_texture()
	_refresh_labels()

func armor_texture() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/armor_inventory.png")
	armor_uses.show()
	for node in armor_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

func armor_inactive() -> void:
	var new_texture: Texture2D = preload("res://assets/Art/game_elements/Inventory_box.png")
	armor_uses.hide()
	for node in armor_node:
		if node is Sprite2D:
			node.texture = new_texture
		elif node is TextureRect:
			node.texture = new_texture

#SpawningMethods=======================================
func spawn_stealth(pos) -> void:
	call_deferred("_deferred_spawn_stealth", pos)

func _deferred_spawn_stealth(pos) -> void:
	var StealthScene = preload("res://assets/Scenes/powerups/StealthPowerUp.tscn")
	var stealth = StealthScene.instantiate()
	stealth.global_position = pos
	powerup_holder.add_child(stealth)

func spawn_power(pos) -> void:
	call_deferred("_deferred_spawn_power", pos)

func _deferred_spawn_power(pos) -> void:
	var PowerScene = preload("res://assets/Scenes/powerups/PowerPowerUp.tscn")
	var power = PowerScene.instantiate()
	power.global_position = pos
	powerup_holder.add_child(power)

func spawn_armor(pos) -> void:
	call_deferred("_deferred_spawn_armor", pos)

func _deferred_spawn_armor(pos) -> void:
	var ArmorScene = preload("res://assets/Scenes/powerups/ArmorPowerUp.tscn")
	var armor = ArmorScene.instantiate()
	armor.global_position = pos
	powerup_holder.add_child(armor)
#======================================================

func update_ui() -> void:
	update_points()
	update_hearts()
	if GameManager.has_stealth:
		stealth_texture()
	if GameManager.has_power:
		power_texture()
	if GameManager.has_armor:
		armor_texture()
	_refresh_labels()

func update_powerup_border() -> void:
	# Reset all nodes' modulate to default
	for node in stealth_node + power_node + armor_node:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = Color(1, 1, 1)  # Normal

	# Determine which group to highlight, if player has the powerup
	var selected_group: Array[Node] = []
	var is_active: bool = false

	match current_powerup_index:
		0:
			if GameManager.has_stealth:
				selected_group = stealth_node
				is_active = GameManager.stealth_active
		1:
			if GameManager.has_power:
				selected_group = power_node
				is_active = GameManager.power_active
		2:
			if GameManager.has_armor:
				selected_group = armor_node
				is_active = GameManager.armor_active

	# Bright white = selected but idle. Green tint = selected and actively draining.
	var highlight_color: Color = Color(1.3, 2.0, 1.3) if is_active else Color(1.5, 1.5, 1.5)

	for node in selected_group:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = highlight_color


func _format_time(t: float) -> String:
	return str(int(ceil(t)))

func _refresh_labels() -> void:
	stealth_uses.text = _format_time(GameManager.stealth_time)
	power_uses.text = _format_time(GameManager.power_time)
	armor_uses.text = _format_time(GameManager.armor_time)

func _is_moving() -> bool:
	return player.velocity.length() > moving_speed_threshold

func _tick_stealth(delta: float) -> void:
	if not GameManager.has_stealth or not GameManager.stealth_active:
		return
	var rate: float = stealth_deplete_moving if _is_moving() else stealth_deplete_idle
	GameManager.stealth_time = max(GameManager.stealth_time - rate * delta, 0.0)
	stealth_uses.text = _format_time(GameManager.stealth_time)
	if GameManager.stealth_time <= 0.0:
		GameManager.has_stealth = false
		GameManager.stealth_active = false
		stealth_inactive()

func _tick_power(delta: float) -> void:
	if not GameManager.has_power or not GameManager.power_active:
		return
	GameManager.power_time = max(GameManager.power_time - power_deplete_rate * delta, 0.0)
	power_uses.text = _format_time(GameManager.power_time)
	if GameManager.power_time <= 0.0:
		GameManager.has_power = false
		GameManager.power_active = false
		power_inactive()

func _tick_armor(delta: float) -> void:
	if not GameManager.has_armor or not GameManager.armor_active:
		return
	GameManager.armor_time = max(GameManager.armor_time - armor_deplete_rate * delta, 0.0)
	armor_uses.text = _format_time(GameManager.armor_time)
	if GameManager.armor_time <= 0.0:
		GameManager.has_armor = false
		GameManager.armor_active = false
		armor_inactive()

func _physics_process(delta: float) -> void:
	current_powerup_index = GameManager.current_powerup_index
	_tick_stealth(delta)
	_tick_power(delta)
	_tick_armor(delta)
	update_powerup_border()
