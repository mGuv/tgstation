/**
 * # Speech Component
 *
 * Sends a message. Requires a shell.
 */
/obj/item/circuit_component/speech
	display_name = "Speech"
	display_desc = "A component that sends a message. Requires a shell."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The message to send
	var/datum/port/input/message

	/// The cooldown for this component of how often it can send speech messages.
	var/speech_cooldown = 1 SECONDS

/obj/item/circuit_component/speech/get_ui_notices()
	. = ..()
	. += create_ui_notice("Speech Cooldown: [DisplayTimeText(speech_cooldown)]", "orange", "stopwatch")

/obj/item/circuit_component/speech/Initialize()
	. = ..()
	message = add_input_port("Message", PORT_TYPE_STRING, FALSE)

/obj/item/circuit_component/speech/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	if(TIMER_COOLDOWN_CHECK(parent, COOLDOWN_CIRCUIT_SPEECH))
		return

	if(message.input_value)
		var/atom/movable/shell = parent.shell
		// Prevents appear as the individual component if there is a shell.
		if(shell)
			shell.say(message.input_value)
		else
			say(message.input_value)
		TIMER_COOLDOWN_START(parent, COOLDOWN_CIRCUIT_SPEECH, speech_cooldown)
