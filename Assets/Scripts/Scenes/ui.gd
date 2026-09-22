extends CanvasLayer
@export var game_manager: Node
@export var points_label: Label
@export var mosquito_points_label: Label
@export var player: CharacterBody2D

@export var stealth_node: Array[Node]
@export var power_node: Array[Node]
@export var armour_node: Array[Node]
var current_weapon_index: int = GameManager.current_weapon_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#
	pass

func stealth_picked() -> void:
	player.change_state("warp_in", player.state_access)
	stealth_texture()

func stealth_texture() -> void:
	var new_texture: Texture2D = preload("res://Assets/Art/game_elements/stealth_inventory.png")
	for stealth in stealth_node:
		if stealth is Sprite2D:
			stealth.texture = new_texture
		elif stealth is TextureRect:
			stealth.texture = new_texture
			
func power_texture() -> void:
	var new_texture: Texture2D = preload("res://Assets/Art/game_elements/power_inventory.png")
	for power in power_node:
		if power is Sprite2D:
			power.texture = new_texture
		elif power is TextureRect:
			power.texture = new_texture	

#func armour_texture() -> void:
	#var new_texture: Texture2D = preload("res://Assets/Art/game_elements/armour_inventory.png")
	#for armour in armour_node:
		#if armour is Sprite2D:
			#armour.texture = new_texture
		#elif armour is TextureRect:
			#armour.texture = new_texture

func set_inactive_texture(nodes: Array[Node]) -> void:
	var empty_texture: Texture2D = preload("res://Assets/Art/game_elements/Inventory_box.png")
	for node in nodes:
		if node is Sprite2D:
			node.texture = empty_texture
		elif node is TextureRect:
			node.texture = empty_texture

func update_power_ups() -> void:
	if GameManager.has_stealth:
		stealth_texture()
	else:
		set_inactive_texture(stealth_node)

	if GameManager.has_power:
		power_texture()
	else:
		set_inactive_texture(power_node)

	#if GameManager.has_armour:
		#armour_texture()
	#else:
		#set_inactive_texture(armour_node)

func stealth_inactive() -> void:
	var new_texture: Texture2D = preload("res://Assets/Art/game_elements/Inventory_box.png")


func update_weapon_border() -> void:
	# Reset all nodes' modulate to default
	for node in stealth_node + power_node + armour_node:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = Color(1, 1, 1)  # Normal

	# Determine which group to highlight, if player has the weapon
	var selected_group: Array[Node] = []

	match current_weapon_index:
		0:
			if GameManager.has_stealth:
				selected_group = stealth_node
		1:
			if GameManager.has_power:
				selected_group = power_node
		2:
			if GameManager.has_armour:
				selected_group = armour_node

	# Highlight only the valid selected group
	for node in selected_group:
		if node is TextureRect or node is Sprite2D:
			node.self_modulate = Color(1.5, 1.5, 1.5)  # Bright highlight




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	current_weapon_index= GameManager.current_weapon_index
	points_label.text = GameManager.check_zero_add_zero()
	mosquito_points_label.text = str(GameManager.num_mosquitoes)
	update_weapon_border()
	update_power_ups()
