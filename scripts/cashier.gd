extends Clickzone

@export var counter: Counter

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
		var text = ""
		var score = 2 - ticket.sandwich_match_score # TODO: What to do about this
		var color = Color.GREEN
		if score == 2:
			text = "Perfect!"
		elif score == 1:
			text = "Good"
			color = Color.YELLOW
		elif score == 0:
			text = "Okay"
			color = Color.ORANGE
		elif score < 0 and score > -5:
			text = "Wrong!"
			color = Color.RED
		elif score <= -5:
			text = "Inedible!"
			color = Color.DARK_RED
		var log = "%s %s%d" % [text, "+" if score >= 0 else "", score]
		add_child(GuiLogger.print(log, color))
		SignalBus.sale_made.emit(ticket)
		ticket = null
