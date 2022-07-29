extends Spatial

export (NodePath) onready var player_castle = get_node(player_castle) as StaticBody
export (NodePath) onready var enemy_castle = get_node(enemy_castle) as StaticBody

onready var winner_label = $"WinnerUI/WhoWins"

func _ready():
	get_tree().paused = false

func _process(delta):
	if player_castle.hp <=0 and enemy_castle.hp > 0:
		winner_label.text = "Enemy wins!"
		winner_label.get_parent().show()
	elif enemy_castle.hp <= 0 and player_castle.hp > 0:
		winner_label.text = "Player wins!"
		winner_label.get_parent().show()
	elif player_castle.hp <= 0 and enemy_castle.hp <=0:
		winner_label.text = "Draw!"
		winner_label.get_parent().show()
		
