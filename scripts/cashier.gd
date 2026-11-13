extends Clickzone

@export var counter: Counter

var customer: Customer

func _ready():
	super()
	animator.visible = false
	SignalBus.customer_ready_to_checkout.connect(customer_ready)

func customer_ready(customer: Customer):
	animator.show()
	self.customer = customer

func do_action():
	if animator.visible and customer:
		animator.hide()
		# TODO: Money transaction here
		SignalBus.sale_made.emit(customer)
		customer = null
