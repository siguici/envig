module config

import os
import toml

pub struct ConfigManager {
	dir  string = 'config'
	file string = 'config.toml'
pub mut:
	config  Config
	configs map[string]Config
}

pub fn ConfigManager.new(opts ConfigOptions) ConfigManager {
	return ConfigManager{
		dir:  opts.dir
		file: opts.file
	}
}

pub fn ConfigManager.load(opts ConfigOptions) ConfigManager {
	mut cm := ConfigManager.new(opts)

	return cm.load('')
}

pub fn (cm ConfigManager) real_path(path string) string {
	return '${cm.dir.trim_right('/')}/${path}'
}

pub fn (cm ConfigManager) real_dir(path string) string {
	return if path == '' { cm.dir } else { cm.real_path(path) }
}

pub fn (cm ConfigManager) real_file(path string) string {
	return if path == '' { cm.file } else { cm.real_path(path) }
}

pub fn (cm ConfigManager) is_dir(path string) bool {
	return os.is_dir(cm.real_dir(path))
}

pub fn (cm ConfigManager) is_file(path string) bool {
	return os.is_file(cm.real_file(path))
}

pub fn (cm ConfigManager) check_dir(path string) {
	if !cm.is_dir(path) {
		panic('No such directory ${cm.real_dir(path)}')
	}
}

pub fn (cm ConfigManager) check_file(path string) {
	if !cm.is_file(path) {
		panic('No such file ${cm.real_file(path)}')
	}
}

pub fn (mut cm ConfigManager) load(path string) ConfigManager {
	if path == '' {
		if cm.is_dir('') {
			cm.load_dir('')
		}

		if cm.is_file('') {
			cm.load_file('')
		}

		return cm
	}

	return if cm.is_dir(path) {
		cm.load_dir(path)
	} else if cm.is_file(path) {
		cm.load_file(path)
	} else {
		cm.load_text(path)
	}
}

pub fn (mut cm ConfigManager) load_dir(path string) ConfigManager {
	cm.check_dir(path)

	real_path := cm.real_dir(path)
	files := os.ls(real_path) or { panic('Enable to list ${real_path}: ${err}') }

	for file in files {
		if file.ends_with('.toml') {
			cm.load('${path}/${file}')
		}
	}

	return cm
}

pub fn (mut cm ConfigManager) load_file(path string) ConfigManager {
	cm.check_file(path)
	name := path.trim_left('/').all_before_last('.toml')

	c := Config.new(cm.real_file(path))
	if path == '' {
		cm.config = c
	} else {
		cm.configs[name] = c
	}

	return cm
}

pub fn (mut cm ConfigManager) load_text(text string) ConfigManager {
	cm.config = Config.new(text)

	return cm
}

pub fn (cm ConfigManager) config(path string) Config {
	return cm.configs[path] or { panic('No such config ${path}') }
}

pub fn (cm ConfigManager) value(path string) toml.Any {
	return if path.contains('.') {
		name := path.all_before('.')
		key := path.all_after('.')
		cm.config(name).value(key)
	} else {
		cm.config(path).to_any()
	}
}

pub fn (mut cm ConfigManager) value_or_default(key string, default toml.Any) toml.Any {
	return cm.value(key).default_to(default)
}
