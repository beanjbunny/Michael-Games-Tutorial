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

#gather inventory into an array
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save
	
#convert each inventory item into a dictionary
func item_to_save(slot : SlotData) -> Dictionary:
	var result = {item = "", quantity = 0}
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result
	
func item_from_save(save_object : Dictionary) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int(save_object.quantity)
	return new_slot

func parse_save_Data(save_data : Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots()
