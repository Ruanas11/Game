extends ItemList


func _ready() -> void:
	pass
	
func Add_to(Objet):
	var quantity = 0
	for i in Knapsack.Knapsack_List :
		quantity += 1
		var List = Knapsack.Knapsack_List[i]
		if List[2] == null:
			var Add = [Objet.Textu,Objet.text,Objet]
			Objet.Wenpeon_status = 2
			Knapsack.Knapsack_List[i] = Add
			Objet.Change()
			return
		
	pass
