extends Node

signal new_customer(customer: Customer)
signal sale_made(ticket: Ticket)

signal ingredient_grabbed(ingredient: Ingredient)
signal ingredient_dropped

signal ticket_created(ticket: Ticket)
signal counter_updated(sandwiches: Array[Bread])
signal ticket_highlighted(ticket: Ticket)
signal ticket_unhighlighted(ticked)
signal send_ticket(ticket: Ticket)
signal ticket_ready(ticket: Ticket)
signal customer_expired(customer: Customer)
signal ticket_expired(ticket: Ticket)
signal lose
signal quit
