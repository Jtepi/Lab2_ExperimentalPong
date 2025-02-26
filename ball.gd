extends Area2D

@export var velocity : Vector2 = Vector2(500, 250)

func _ready():
	# Connect signal from ScoreZones
	var score_zones = get_tree().get_nodes_in_group("score_zone")
	for zone in score_zones:
		zone.connect("goal_scored", Callable(self, "spawn"))

func _process(delta):
	position += velocity * delta  # Move the ball

	# Bounce off top and bottom
	if position.y <= 0 or position.y >= get_viewport_rect().size.y:
		velocity.y = -velocity.y

func _on_area_entered(area):
	if area.is_in_group("paddle"):
		velocity.x = -velocity.x  # Reverse X direction

func spawn():
	position = get_viewport_rect().size / 2  # Move ball to center
	velocity = Vector2(300 if randi() % 2 == 0 else -300, randf_range(-150, 150))  # Random direction
