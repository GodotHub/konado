extends Node


func _ready() -> void:
	KND_Database.load_database()
		

	for k in 5:
		var id = KND_Database.create_data("KND_Shot")
		var sub = KND_Database.create_sub_data("KND_Dialogue")
		KND_Database.add_sub_source_data(id, sub["id"], sub["data"])
		
	await get_tree().create_timer(0.1).timeout
	KND_Database.save_database()
	

	
