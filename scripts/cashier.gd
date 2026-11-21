extends Clickzone

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var counter: Counter
@export var cash_sound: AudioStream
@export var yay_sound: AudioStream
@export var boo_sound: AudioStream
@export var fail_sound: AudioStream

var ticket: Ticket

func _ready():
	super()
	animator.visible = false
	SignalBus.ticket_ready.connect(ticket_ready)

func ticket_ready(ticket: Ticket):
	animator.show()
	self.ticket = ticket

func do_action():
	if animator.visible and ticket:
		animator.hide()
		# TODO: Money transaction here
		var price := ticket.get_price()
		Globals.money += price
		var text := ""
		var score := 2 - ticket.sandwich_match_score # TODO: What to do about this
		var color := Color.GREEN
		var sound: AudioStream = null
		if score == 2:
			text = "Perfect!"
			sound = yay_sound
		elif score == 1:
			text = "Good"
			color = Color.YELLOW
			sound = boo_sound
		elif score == 0:
			text = "Okay"
			color = Color.ORANGE
			sound = boo_sound
		elif score < 0 and score > -5:
			text = "Wrong!"
			color = Color.RED
			sound = fail_sound
		elif score <= -5:
			text = "Inedible!"
			color = Color.DARK_RED
			sound = fail_sound
		var log = "%s %s%d" % [text, "+" if score >= 0 else "", score]
		audio.stream = cash_sound
		audio.play()
		add_child(GuiLogger.print("$%.2f" % price))
		await get_tree().create_timer(2).timeout
		audio.stream = sound
		audio.play()
		add_child(GuiLogger.print(log, color))
		SignalBus.sale_made.emit(ticket)
