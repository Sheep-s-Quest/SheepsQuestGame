class_name RANGED_ATTACK

enum TYPE {
	TNT
}

const SCENE : Dictionary = {
	TYPE.TNT : preload("res://characters/attacks/throwed_dynamite.tscn")
}

static func get_scene(type: TYPE) -> Resource:
	return SCENE[type]
