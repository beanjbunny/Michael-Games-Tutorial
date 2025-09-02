extends EnemyState
class_name EnemyStateDestroy

@export var anim_name : String = "destroy"
@export_category("AI")
#@export var after_idle_state : EnemyState
@export var knockback_speed : float = 200.0
@export var state_animation_duration : float = 0.7
@export var decelerate_speed : float = 10.0
var _direction : Vector2 = Vector2.DOWN
var _damage_position : Vector2
const Pickup = preload("res://Items/item_pickup/item_pickup.tscn")
@export_category("Item Drops")
@export var drops : Array[DropData]

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	
func enter()->void:
	enemy.invulnerable = true
	#_animation_finished = false
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()
	drop_items()
	
func _on_animation_finished(_a : String) -> void:
	enemy.queue_free()
	
func exit()->void:
	pass
	
func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func _on_enemy_destroyed(hurt_box : HurtBox):
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func physics(_delta : float) -> EnemyState:
	return null

func disable_hurt_box():
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false

func drop_items():
	if drops.size() == 0: return
	for i in drops.size():
		if drops[i] == null or drops[i].item == null: continue
		var drop_count : int = drops[i].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = Pickup.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
