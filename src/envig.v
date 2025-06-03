module envig

import os
import toml

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
	return Envig{
		ConfigManager: ConfigManager.new(dir: options.dir, file: options.file)
		dotenv:        Dotenv.load(
			type: options.env
			vars: options.vars
		)
	}
}

pub fn (e Envig) config(name string) Config {
	return e.ConfigManager.config(name)
}

pub fn (e Envig) value(path string) toml.Any {
	return e.ConfigManager.value(path)
}

pub fn (mut e Envig) value_or_default(path string, default toml.Any) toml.Any {
	return e.ConfigManager.value_or_default(path, default)
}

pub fn (e Envig) env(name string) string {
	return e.dotenv.get(name)
}

pub fn (e Envig) env_or_default(name string, default string) string {
	return e.dotenv.get_or_default(name, default)
}
