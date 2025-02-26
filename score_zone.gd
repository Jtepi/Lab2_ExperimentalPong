extends Area2D

signal goal_scored  
signal game_over(winner)  

@export var player1_score_label: Label  
@export var player2_score_label: Label  
@export var paddle1: Node  
@export var paddle2: Node  
@export var game_over_label: Label  
@export var ball: Node  

var min_scale = 0.1 
var max_score = 10  
var shrink_factor = 0.9  

func _on_area_entered(area):
	if area.is_in_group("ball"):
		print("Ball entered:", name)  # Debugging check

		var new_score = null
		var winner = ""

		#Checking which zone was entered & update player's score
		if name == "ScoreZone1" and player2_score_label != null:
			new_score = int(player2_score_label.text) + 1  # Player 2 scores
			player2_score_label.text = str(new_score)
			winner = "Player 2"
			

		elif name == "ScoreZone2" and player1_score_label != null:
			new_score = int(player1_score_label.text) + 1  # Player 1 scores
			player1_score_label.text = str(new_score)
			winner = "Player 1"
			

		if new_score != null:
			if new_score >= max_score:
				end_game(winner)  # Ending the game if max score is reached
			else:
				shrink_paddles(new_score)
				emit_signal("goal_scored")  # Signal to reset the ball

func shrink_paddles(scorer_score):
	# If someone reaches 10 points, both paddles are removed
	if scorer_score >= max_score:
		print(" GAME OVER! ")

		if is_instance_valid(paddle1):
			paddle1.queue_free()
		if is_instance_valid(paddle2):
			paddle2.queue_free()

		return  

	# Shrinking both paddles
	shrink_paddle(paddle1)
	shrink_paddle(paddle2)

func shrink_paddle(paddle):
	var paddle_shape_node = paddle.get_node_or_null("CollisionShape2D")
	var paddle_sprite = paddle.get_node_or_null("Sprite2D")

	if paddle_shape_node == null or paddle_sprite == null:
		print("Error: Paddle is missing CollisionShape2D or Sprite2D!")
		return

	# Shrinking the entire paddle proportionally
	if paddle_sprite.scale.y > min_scale:
		paddle_sprite.scale.y *= shrink_factor  
		paddle_shape_node.scale.y *= shrink_factor 

func end_game(winner):
	# Displaying Game Over text
	game_over_label.text = "GAME OVER\n" + winner + " WINS!"
	game_over_label.visible = true

	# Stop the Ball
	ball.process_mode = Node.PROCESS_MODE_DISABLED  # Stops movement

	# Remove both paddles
	if is_instance_valid(paddle1):
		paddle1.queue_free()
	if is_instance_valid(paddle2):
		paddle2.queue_free()

	emit_signal("game_over", winner)

func _input(event):
	if event is InputEventKey and event.pressed:
		if game_over_label.visible:  # Only restart if game is over
			get_tree().reload_current_scene()  # Restart the game
