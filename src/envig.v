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
}

pub fn envig(options EnvigOptions) Envig {
	return new(options)
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

pub fn (e Envig) get(key string) string {
	return e.expand(e.config(key))
}

pub fn (e Envig) value(key string) toml.Any {
	return toml.Any(e.get(key))
}

pub fn (e Envig) get_as[T](key string) T {
	return T(e.value(key))
}

pub fn (mut e Envig) get_or_default(key string, default toml.Any) string {
	return e.expand(e.config_or_default(key, default))
}

pub fn get_config(path string) toml.Any {
	return envig().config(path)
}

pub fn get_env(name string) string {
	return envig().env(name)
}

pub fn get(key string) string {
	return envig().get(key)
}

pub fn value(key string) toml.Any {
	return envig().value(key)
}

pub fn get_as[T](key string) T {
	return envig().get_as(key)
}
