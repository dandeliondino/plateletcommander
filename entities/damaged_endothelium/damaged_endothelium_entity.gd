class_name Damaged_Endothelium_Entity
extends Entity

onready var activationPowerupSecretor := $"%ActivationPowerupSecretor"


func _on_connection_made(entity : Entity, dir : int) -> void:
	activationPowerupSecretor.queue_free()


