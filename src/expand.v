module envig

import regex

fn expand(val string, vars map[string]string) string {
	mut res := val

	for k, v in vars {
		res = res.replace('\$${k}', v)
		res = res.replace('\${${k}}', v)
	}

	mut re := regex.regex_opt(r'$(?:(?:\{([A-Za-z_][A-Za-z0-9_]*)(?:(:?[-+])([^}]*))?\})|([A-Za-z_][A-Za-z0-9_]*))') or {
		eprintln('Invalid regex syntax: ${err}')
		return res
	}

	res = re.replace_by_fn(res, fn [vars] (re regex.RE, in_txt string, start int, end int) string {
		gp := re.get_group_list().map(if it.start > -1 || it.end > -1 {
			in_txt[it.start..it.end]
		} else {
			''
		})
		k, op, val, arg := gp[0], gp[1], gp[2], gp[3]

		key := if arg != '' { arg } else { k }

		env := vars[key]
		mut resolved := ''

		match op {
			':-' { resolved = if env != '' { env } else { val } }
			'-' { resolved = if key in vars { env } else { val } }
			':+' { resolved = if env != '' { val } else { '' } }
			'+' { resolved = if key in vars { val } else { '' } }
			else { resolved = env }
		}

		return resolved
	})

	return res
}
