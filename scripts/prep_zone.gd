class_name PrepZone
extends Dropzone

func can_place(ing: Ingredient) -> bool:
	return ing.is_edible and (!ing.is_sauce or ingredient)
