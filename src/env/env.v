module env

import os

pub type EnvVars = map[string]string

@[params]
pub struct EnvOptions {
pub:
	vars EnvVars = os.environ()
}

pub struct Env {
mut:
	vars EnvVars
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
