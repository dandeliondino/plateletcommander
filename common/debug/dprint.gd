extends Node


var unassigned_category = "UNASSIGNED"
var interaction_category = "INTERACTION_STATE"

# SETTINGS
var error_template := "ERROR: %s"
var warning_template := "• WARNING: %s"
var debug_template := "- %s"
var info_template := "> %s"
var info_template_category := "> [%s] %s"

var always_print_errors := true
var always_print_warnings := true

var categories := {
	"UNASSIGNED": true,
	"INTERACTION_STATE": false,
	"EVENT": true,
	"NEIGHBOR": false,
	"ENTITY_MOVEMENT": true,
}

func error(msg, category = unassigned_category):
	push_error(msg)
	
	if always_print_errors or categories[category]:
		print()		
		printerr(error_template % msg)
		print_stack()
		print()


func warning(msg, category = unassigned_category):
	push_warning(msg)
	
	if always_print_warnings or categories[category]:
		print()
		print(warning_template % msg)
		print_stack()
		print()


func debug(msg, category = unassigned_category):
	if categories[category]:	
		print()
		print(debug_template % msg)
		print_stack()
		print()


func info(msg, category = unassigned_category):
	if categories[category]:
		if category == unassigned_category:
			print(info_template % msg)
		else:
			print(info_template_category % [category.to_lower(), msg])
