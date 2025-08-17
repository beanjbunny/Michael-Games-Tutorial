extends Resource
class_name InventoryData

@export var slots: Array[SlotData]

func add_item(item : ItemData, count : int = 1):
	#we found something we already have, so let's stack it
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
	#we don't have the item, but we have empty slots
	for i in slots.size():
		if slots[i] == null:
			#we need to make slot data!
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots[i] = new
			#connect to the new signal
			new.changed.connect(slot_changed)
			return true
	#ope the inventory has no slots
	print("inventory is full")
	return false

func _int() -> void:
	connect_slots()

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)
			
func slot_changed() -> void:
	print("slot_changed ran")
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				emit_changed()
