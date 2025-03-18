module envigure

import os
import regex

pub type EnvVars = map[string]string

@[params]
pub struct EnvOptions {
	vars EnvVars = os.environ()
}

@[params]
pub struct DotenvOptions {
	EnvOptions
	type string
}

pub struct Env {
mut:
	vars EnvVars
}

pub struct Dotenv {
	Env
	type string = os.getenv('APP_ENV')
}

pub fn Env.new(options EnvOptions) Env {
	return Env{options.vars}
}

pub fn (mut e Env) set(key string, value string) Env {
	e.vars[key] = value

	return e
}

pub fn (e Env) has(key string) bool {
	return key in e.vars
}

pub fn (e Env) get(key string) string {
	return e.get_or_default(key, '')
}

pub fn (e Env) get_or_default(key string, default string) string {
	return e.vars[key] or { default }
}

pub fn (e Env) apply() {
	for key, val in e.vars {
		os.setenv(key, val, true)
	}
}

pub fn Dotenv.new(options DotenvOptions) Dotenv {
	return Dotenv{
		Env:  Env.new(vars: options.vars)
		type: options.type
	}
}

pub fn Dotenv.load(options DotenvOptions) Dotenv {
	mut d := Dotenv.new(options)
	d.load()

	return d
}

pub fn (mut d Dotenv) load() Dotenv {
	return d.load_file('.env')
}

pub fn (mut d Dotenv) load_multiple(files []string) Dotenv {
	for file in files {
		d.load_file(file)
	}

	return d
}

pub fn (mut d Dotenv) load_file(file string) Dotenv {
	d_file := if d.type == '' {
		file
	} else {
		'${file}.${d.type}'
	}

	if os.is_file(d_file) {
		d.parse_file(d_file)
	}

	return d
}

fn (mut d Dotenv) parse_file(file string) {
	lines := os.read_lines(file) or { panic('Enable to read lines: ${err}') }
	for line in lines {
		d.parse_line(line)
	}
}

fn (mut d Dotenv) parse_line(line string) {
	mut trimmed := line.trim_space()
	if trimmed == '' || trimmed.starts_with('#') {
		return
	}

	mut l_key, mut l_value := trimmed.split_once('=') or { panic(err) }
	l_key = l_key.trim_space()
	l_value = l_value.trim_space()
	if l_key == '' || l_value == '' {
		return
	}

	trimmed = '${l_key}=${l_value}'

	mut re := regex.regex_opt(r'^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') or {
		d.set(l_key, l_value)
		return
	}

	if re.matches_string(trimmed) {
		groups := re.get_group_list()
		if groups.len == 2 {
			key_group := groups[0]
			value_group := groups[1]
			key := trimmed[key_group.start..key_group.end]
			mut value := trimmed[value_group.start..value_group.end]

			if value.starts_with('"') && value.ends_with('"') {
				value = value[1..value.len - 1]
			} else if value.starts_with("'") && value.ends_with("'") {
				value = value[1..value.len - 1]
			}

			value = d.expand(value)

			d.vars[key] = value
		}
	}
}

fn (d Dotenv) expand(value string) string {
	return expand(value, d.vars)
}
