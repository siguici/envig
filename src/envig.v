module envig

import os
import toml
import config { ConfigManager }
import env { Dotenv, EnvVars }

@[params]
pub struct EnvigOptions {
	dir  string  = 'config'
	file string  = 'config.toml'
	env  string  = os.getenv('APP_ENV')
	vars EnvVars = os.environ()
}

pub struct Envig {
	ConfigManager
	dotenv Dotenv
mut:
	cache map[string]string
}

pub fn new(options EnvigOptions) Envig {
	return Envig.new(options)
}

pub fn Envig.new(options EnvigOptions) Envig {
	return Envig{
		ConfigManager: ConfigManager.load(dir: options.dir, file: options.file)
		dotenv:        Dotenv.load(
			type: options.env
			vars: options.vars
		)
	}
}

pub fn (e Envig) config(path string) toml.Any {
	return e.ConfigManager.value(path)
}

pub fn (mut e Envig) config_or_default(path string, default toml.Any) toml.Any {
	return e.ConfigManager.value_or_default(path, default)
}

pub fn (e Envig) env(name string) string {
	return e.dotenv.get(name)
}

pub fn (e Envig) env_or_default(name string, default string) string {
	return e.dotenv.get_or_default(name, default)
}

pub fn (e Envig) expand(value toml.Any) string {
	return e.dotenv.expand(value.string())
}

pub fn (mut e Envig) get(key string) string {
	if v := e.cache[key] {
		return v
	}
	v := e.expand(e.config(key))
	e.cache[key] = v
	return v
}

pub fn (mut e Envig) get_or_default(key string, default toml.Any) string {
	if v := e.cache[key] {
		return v
	}
	return e.expand(e.config_or_default(key, default))
}

pub fn (mut e Envig) value(key string) toml.Any {
	return toml.Any(e.get(key))
}

pub fn (mut e Envig) string(key string) string {
	return e.value(key).string()
}

pub fn (mut e Envig) int(key string) int {
	return e.value(key).int()
}

pub fn (mut e Envig) i64(key string) i64 {
	return e.value(key).i64()
}

pub fn (mut e Envig) u64(key string) u64 {
	return e.value(key).u64()
}

pub fn (mut e Envig) f32(key string) f32 {
	return e.value(key).f32()
}

pub fn (mut e Envig) f64(key string) f64 {
	return e.value(key).f64()
}

pub fn (mut e Envig) bool(key string) bool {
	return e.value(key).bool()
}

pub fn (mut e Envig) date(key string) toml.Date {
	return e.value(key).date()
}

pub fn (mut e Envig) time(key string) toml.Time {
	return e.value(key).time()
}

pub fn (mut e Envig) datetime(key string) toml.DateTime {
	return e.value(key).datetime()
}

pub fn (mut e Envig) array(key string) []toml.Any {
	return e.value(key).array()
}

pub fn (mut e Envig) map(key string) map[string]toml.Any {
	return e.value(key).as_map()
}
