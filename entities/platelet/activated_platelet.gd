extends Entity



onready var connectionContainer := $"%ConnectionContainer"

onready var activationPowerupSecretor := $"%ActivationPowerupSecretor"
onready var fibrinPowerupSecretor := $"%FibrinPowerupSecretor"
onready var xlinkPowerupSecretor := $"%XLinkPowerupSecretor"

func _ready():
	for node in connectionContainer.get_children():
		node.entity = self
		_connections[node.direction].control = node
