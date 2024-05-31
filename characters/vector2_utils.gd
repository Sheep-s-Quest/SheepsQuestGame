class_name Vec2Utils
extends Object

static func calculate_direction(emmiter_position: Vector2, target_position: Vector2) -> Vector2:
	return -1 * (emmiter_position - target_position)

static func calculate_position(emmiter_position: Vector2, target_position: Vector2) -> Vector2:
	return (emmiter_position + target_position)

static func vector2_to_look_direction(direction: Vector2) -> BasicEntity.LOOK_DIRECTION:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return BasicEntity.LOOK_DIRECTION.RIGHT
		else:
			return BasicEntity.LOOK_DIRECTION.LEFT
	else:
		if direction.y > 0:
			return BasicEntity.LOOK_DIRECTION.DOWN
		else:
			return BasicEntity.LOOK_DIRECTION.UP

	
