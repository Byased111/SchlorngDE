--module for SETTING the ansi codes of keys, not one for simple customization.

local KeyTable = {
	Regular = {
		a = 97,  A = 65,
		b = 98,  B = 66,
		c = 99,  C = 67,
		d = 100, D = 68,
		e = 101, E = 69,
		f = 102, F = 70,
		g = 103, G = 71,
		h = 104, H = 72,
		i = 105, I = 73,
		j = 106, J = 74,
		k = 107, K = 75,
		l = 108, L = 76,
		m = 109, M = 77,
		n = 110, N = 78,
		o = 111, O = 79,
		p = 112, P = 80,
		q = 113, Q = 81,
		r = 114, R = 82,
		s = 115, S = 83,
		t = 116, T = 84,
		u = 117, U = 85,
		v = 118, V = 86,
		w = 119, W = 87,
		x = 120, X = 88,
		y = 121, Y = 89,
		z = 122, Z = 90,
	},
	Special = {
		Enter = 13,
		Escape = 27,
		Backspace = 8,
		Alpha = 224,

		--alpha codes (the "224;#" ones)
		UpArrow = 152,
		DownArrow = 160,
		LeftArrow = 155,
		RightArrow = 157,
		Delete = 83,

	}


}

return KeyTable