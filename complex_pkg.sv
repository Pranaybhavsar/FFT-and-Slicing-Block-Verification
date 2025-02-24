package complex_pkg;
	typedef struct {
		real r, i;
	} complex;

	function complex complex_conj(complex a);
		complex res;
		res.r = a.r;
		res.i = -a.i;
		return res;
	endfunction

	function complex complex_add(complex a, b);
		complex res;
		res.r = a.r + b.r;
		res.i = a.i + b.i;
		return res;
	endfunction: complex_add

	function complex complex_sub(complex a, b);
		complex res;
		res.r = a.r - b.r;
		res.i = a.i - b.i;
		return res;
	endfunction: complex_sub

	function complex complex_mul(complex a, b);
		complex res;
		res.r = (a.r * b.r) - (a.i * b.i);
		res.i = (a.r * b.i) + (a.i * b.r);
		return res;
	endfunction: complex_mul

	function complex complex_div(complex a, b);
		complex res;
		real divisorSquaredMag;

		divisorSquaredMag = complex_abs(b);

		res.r = (a.r*b.r + a.i*b.i ) / divisorSquaredMag;
		res.i = (a.i*b.r - a.r*b.i) / divisorSquaredMag;
	endfunction: complex_div;

	function real complex_abs(complex a);
		real res;

		res = a.r**2 + a.i**2;

		return res;
	endfunction

	function bit [16:0] real_to_q2_15(real a);
		real value = a * 2**15;
		integer rounded_value = $rtoi(value);

		return rounded_value;
	endfunction
endpackage: complex_pkg
