module envigure

import regex

fn expand(val string, vars map[string]string) string {
	mut res := val

	for k, v in vars {
		res = res.replace('\$${k}', v)
		res = res.replace('\${${k}}', v)
	}

	mut re := regex.regex_opt(r'$(?:(?:\{([A-Za-z_][A-Za-z0-9_]*)\})|([A-Za-z_][A-Za-z0-9_]*))') or {
		eprintln('Invalid regex syntax: ${err}')
		return res
	}

	res = re.replace_by_fn(res, fn [vars] (re regex.RE, in_txt string, start int, end int) string {
		g0 := re.get_group_list()[0]
		mut key := ''
		if g0.start > -1 || g0.end > -1 {
			key = in_txt[g0.start..g0.end]
		}
		g1 := re.get_group_list()[1]
		if g1.start > -1 || g1.end > -1 {
			key = in_txt[g1.start..g1.end]
		}

		if key !in vars {
			eprintln('Undefined variable ${key}')
		}

		return vars[key] or { '' }
	})

	return res
}
