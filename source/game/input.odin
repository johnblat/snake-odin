package game


Keyboard_Key :: enum  {
	UNKNOWN = 0,

	A = 4,
	B = 5,
	C = 6,
	D = 7,
	E = 8,
	F = 9,
	G = 10,
	H = 11,
	I = 12,
	J = 13,
	K = 14,
	L = 15,
	M = 16,
	N = 17,
	O = 18,
	P = 19,
	Q = 20,
	R = 21,
	S = 22,
	T = 23,
	U = 24,
	V = 25,
	W = 26,
	X = 27,
	Y = 28,
	Z = 29,

	K_1 = 30,
	K_2 = 31,
	K_3 = 32,
	K_4 = 33,
	K_5 = 34,
	K_6 = 35,
	K_7 = 36,
	K_8 = 37,
	K_9 = 38,
	K_0 = 39,

	RETURN = 40,
		ESCAPE = 41,
	BACKSPACE = 42,
	TAB = 43,
	SPACE = 44,

	MINUS = 45,
	EQUALS = 46,
	LEFTBRACKET = 47,
	RIGHTBRACKET = 48,
	BACKSLASH = 49, /**< Located at the lower left of the return
	                 *   key on ISO keyboards and at the right end
	                 *   of the QWERTY row on ANSI keyboards.
	                 *   Produces REVERSE SOLIDUS (backslash) and
	                 *   VERTICAL LINE in a US layout, REVERSE
	                 *   SOLIDUS and VERTICAL LINE in a UK Mac
	                 *   layout, NUMBER SIGN and TILDE in a UK
	                 *   Windows layout, DOLLAR SIGN and POUND SIGN
	                 *   in a Swiss German layout, NUMBER SIGN and
	                 *   APOSTROPHE in a German layout, GRAVE
	                 *   ACCENT and POUND SIGN in a French Mac
	                 *   layout, and ASTERISK and MICRO SIGN in a
	                 *   French Windows layout.
	                 */
	NONUSHASH = 50, /**< ISO USB keyboards actually use this code
	                 *   instead of 49 for the same key, but all
	                 *   OSes I've seen treat the two codes
	                 *   identically. So, as an implementor, unless
	                 *   your keyboard generates both of those
	                 *   codes and your OS treats them differently,
	                 *   you should generate BACKSLASH
	                 *   instead of this code. As a user, you
	                 *   should not rely on this code because SDL
	                 *   will never generate it with most (all?)
	                 *   keyboards.
	                 */
	SEMICOLON = 51,
	APOSTROPHE = 52,
	GRAVE = 53, /**< Located in the top left corner (on both ANSI
	             *   and ISO keyboards). Produces GRAVE ACCENT and
	             *   TILDE in a US Windows layout and in US and UK
	             *   Mac layouts on ANSI keyboards, GRAVE ACCENT
	             *   and NOT SIGN in a UK Windows layout, SECTION
	             *   SIGN and PLUS-MINUS SIGN in US and UK Mac
	             *   layouts on ISO keyboards, SECTION SIGN and
	             *   DEGREE SIGN in a Swiss German layout (Mac:
	             *   only on ISO keyboards), CIRCUMFLEX ACCENT and
	             *   DEGREE SIGN in a German layout (Mac: only on
	             *   ISO keyboards), SUPERSCRIPT TWO and TILDE in a
	             *   French Windows layout, COMMERCIAL AT and
	             *   NUMBER SIGN in a French Mac layout on ISO
	             *   keyboards, and LESS-THAN SIGN and GREATER-THAN
	             *   SIGN in a Swiss German, German, or French Mac
	             *   layout on ANSI keyboards.
	             */
	COMMA = 54,
	PERIOD = 55,
	SLASH = 56,

	CAPSLOCK = 57,


	F1 = 58,
	F2 = 59,
	F3 = 60,
	F4 = 61,
	F5 = 62,
	F6 = 63,
	F7 = 64,
	F8 = 65,
	F9 = 66,
	F10 = 67,
	F11 = 68,
	F12 = 69,

	HOME = 74,
	PAGEUP = 75,
	DELETE = 76,
	END = 77,
	PAGEDOWN = 78,
	RIGHT = 79,
	LEFT = 80,
	DOWN = 81,
	UP = 82,

	LEFT_CTRL = 224,
	LEFT_SHIFT = 225,
	LEFT_ALT = 226,
	RIGHT_CTRL = 228,
	RIGHT_SHIFT = 229,
	RIGHT_ALT = 230
}


keyboard_key_is_down :: proc(k_id : Keyboard_Key) -> bool
{
	is_down := state.keyboard_state_current[k_id]
	return is_down
}


keyboard_key_is_just_pressed :: proc(k_id : Keyboard_Key) -> bool
{
	is_just_pressed := state.keyboard_state_current[k_id] && !state.keyboard_state_previous[k_id]
	return is_just_pressed
}


keyboard_key_is_just_released :: proc(k_id : Keyboard_Key) -> bool
{
	is_just_released := !state.keyboard_state_current[k_id] && state.keyboard_state_previous[k_id]
	return is_just_released
}