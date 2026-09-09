extends Node
@export var player: CharacterBody2D
var level_1_1_loaded: int = 0
var num_mosquitoes: int = 0
var num_hearts: int = 3
var points: int = 0
var lives: int = 3
#var cherries: int = 0
#inventory===========================================
var tutorial_completed: bool = false
var first_load: bool = true
var has_gun: bool = false
#var has_sword: bool = false
#var has_tome: bool = false
#var gun_ammo: int = 0
#var sword_strikes: int = 0
#var tome_spells: int = 0
#var current_weapon_index: int = 0

#var inventory: Array = [gun_ammo, sword_strikes, tome_spells]
#======================================================

@export var hearts: Array[Node]
@export var points_text: Label

#WeaponDamage==========================================
var bullet_damage: int = 1
var sword_damage: int = 2
var tome_damage: int = 5
#======================================================

#PlayerAttributes===============================================================
var player_dash_duration: float = 2.5 # seconds
var player_speed: float = 400.0
var player_jump_height: float = - 1000.0
#===============================================================================

func level_transition() -> void: 
	get_tree().change_scene_to_file("res://Assets/Scenes/TransitionScreens/level_transition_screen.tscn")

func game_over()-> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/TransitionScreens/Game_Over.tscn")

func mosquito_add_points() -> void:
	points += 200
	num_mosquitoes += 1

func decrease_lives() -> void:
	if lives > 1:
		lives -= 1
		call_deferred("level_transition")
	elif lives <= 1:
		lives = 0
		call_deferred("game_over")

func decrease_health(playerHurtDamage: int) -> void:
	num_hearts -= playerHurtDamage
	for h in 3:
		if h < num_hearts:
			hearts[h].show()
		else:
			hearts[h].hide()
	if num_hearts <= 0:
		player.change_state("dead", player.state_access)
		




#LevelTransitionUtilities==============================
var level_list: Array = [
	"Tutorial-1", "Tutorial-2", "Tutorial-3",
	"World 1-1", "World 1-2", "World 1-3",
]
var level_index: int = 0
var level_changer_list: Array = [
	"Level_0-1","Level_0-2","Level_0-3",
	"Level_1-1", "Level_1-2", "Level_1-3",
]
#======================================================
func check_zero_add_zero() -> String:
	var num_zeros: int = 7-len(str(points))
	var final_points: String = ""
	for i in range(num_zeros):
		final_points += str(0)
	final_points += str(points)
	return final_points  


func reset_game_soft() -> void:
	#has_gun = false
	#has_sword = false
	#has_tome = false
	#gun_ammo = 0
	#sword_strikes = 0
	#tome_spells = 0 
	#current_weapon_index = 0
	#cherries = 0
	#points = 0
	#num_hearts = 3
	#lives = 3
	pass
#
#
#func reset_game() -> void:
	#cherries = 0
	#points = 0
	#num_hearts = 3
	#lives = 3
	#gun_ammo = 0
	#sword_strikes = 0
	#tome_spells = 0
	#current_weapon_index = 0
	#if !tutorial_completed:
		#level_index = 0
	#else:
		#level_index = 3

##SAVEANDLOAD====================================================================
#func save_to_file():
	#var save_data = SaveGame.new()
#
	#save_data.points = points
	#save_data.lives = lives
	#save_data.hearts = num_hearts
	#save_data.mosquitoes = num_mosquitoes
	#
	#save_data.tutorial_completed = tutorial_completed
	#save_data.first_load = first_load
	#save_data.has_gun = has_gun
	#save_data.has_sword = has_sword
	#save_data.has_tome = has_tome
#
	#save_data.gun_ammo = gun_ammo
	#save_data.sword_strikes = sword_strikes
	#save_data.tome_spells = tome_spells
	#save_data.current_weapon_index = current_weapon_index
#
	#save_data.bullet_damage = bullet_damage
	#save_data.sword_damage = sword_damage
	#save_data.tome_damage = tome_damage
#
	#save_data.player_dash_duration = player_dash_duration
	#save_data.player_speed = player_speed
	#save_data.player_jump_height = player_jump_height
#
	#save_data.level_index = level_index
#
	#var result = ResourceSaver.save(save_data, "user://savegame.tres")
	#if result == OK:
		#print("✅ Game saved")
	#else:
		#print("❌ Save failed:", result)
#
#func save_file_exists()-> bool:
	#var path = "user://savegame.tres"
	#return FileAccess.file_exists(path)
		#
#
#
#func load_from_file():
	#var path = "user://savegame.tres"
	#if not FileAccess.file_exists(path):
		#print("⚠️ No save file found.")
		#return
#
	#var save_data = load(path) as SaveGame
	#if save_data == null:
		#print("❌ Failed to load save file.")
		#return
#
	#points = save_data.points
	#lives = save_data.lives
	#num_hearts = save_data.hearts
	#cherries = save_data.cherries
	#
	#tutorial_completed = save_data.tutorial_completed
	#first_load = save_data.first_load
	#has_gun = save_data.has_gun
	#has_sword = save_data.has_sword
	#has_tome = save_data.has_tome
#
	#gun_ammo = save_data.gun_ammo
	#sword_strikes = save_data.sword_strikes
	#tome_spells = save_data.tome_spells
	#current_weapon_index = save_data.current_weapon_index
#
	#bullet_damage = save_data.bullet_damage
	#sword_damage = save_data.sword_damage
	#tome_damage = save_data.tome_damage
#
	#player_dash_duration = save_data.player_dash_duration
	#player_speed = save_data.player_speed
	#player_jump_height = save_data.player_jump_height
#
	#level_index = save_data.level_index
#
	#print("✅ Game loaded")
#
##===============================================================================
