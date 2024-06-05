extends ParallaxBackground

var move_speed = 100

func _process(delta):
	scroll_offset.x -= move_speed * delta
