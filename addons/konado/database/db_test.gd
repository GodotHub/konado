extends Node

@export var db: KND_Database

func _ready() -> void:
    db = KND_Database.new()
    print(db.create_data("KND_Shot"))

    db.create_data("KND_Shot")

    


    db.save_database()
    
    db = KND_Database.new()
    db.load_database()
    print(db.knd_data_dic)

