extends Enemy
class_name MeleeEnemy

@onready var melee_ability: EnemyMeleeAbilty = %MeleeAbility
@onready var animation_player: AnimationPlayer = $Visual/sk_melee_enemy/AnimationPlayer
@onready var bt_player: BTPlayer = %BTPlayer

func die():
    #process_mode = PROCESS_MODE_DISABLED
    bt_player.active = false
    animation_player.play("MeleeEnemyDeath")
    super.die()
    
