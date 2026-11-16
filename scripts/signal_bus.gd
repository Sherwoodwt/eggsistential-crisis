extends Node

signal new_customer(customer: Customer)
signal sale_made(customer: Customer)

signal ingredient_grabbed(ingredient: Ingredient)
signal ingredient_dropped

signal counter_updated(sandwiches: Array[Bread])
signal send_ticket(ticket: Ticket)
signal customer_ready_to_checkout(customer: Customer)
signal line_damage
signal customer_expired(customer: Customer)
signal lose
