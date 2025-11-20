module config

import toml
import os

pub struct Config {
	data toml.Doc
}

@[params]
pub struct ConfigOptions {
pub:
	dir  string = 'config'
	file string = 'config.toml'
}

pub fn Config.new(raw string) Config {
	return Config.new_opt(raw) or {
		eprintln(err)
		Config{}
	}
}

pub fn Config.new_or_panic(raw string) Config {
	return Config.new_opt(raw) or { panic(err) }
}

pub fn Config.new_opt(raw string) !Config {
	return Config{parse(raw)!}
}

fn parse(raw string) !toml.Doc {
	return if os.is_file(raw) {
		toml.parse_file(raw)!
	} else {
		toml.parse_text(raw)!
	}
}

pub fn (c Config) value(key string) toml.Any {
	return c.data.value(key)
}

pub fn (c Config) to_any() toml.Any {
	return c.data.to_any()
}

pub fn (mut c Config) value_or_default(key string, default toml.Any) toml.Any {
	return c.value(key).default_to(default)
}
