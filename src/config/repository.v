module config

import toml

@[params]
pub struct RepositoryOptions {
pub:
	config  Config
	configs map[string]Config
}

pub struct ConfigRepository {
pub mut:
	config  Config
	configs map[string]Config
}

pub fn ConfigRepository.new(opts RepositoryOptions) ConfigRepository {
	return ConfigRepository{
		config:  opts.config
		configs: opts.configs
	}
}

pub fn (cm ConfigRepository) config(path string) Config {
	return cm.configs[path] or { panic('No such config ${path}') }
}

pub fn (cm ConfigRepository) value(path string) toml.Any {
	return if path.contains('.') {
		name := path.all_before('.')
		key := path.all_after('.')
		cm.config(name).value(key)
	} else {
		cm.config(path).to_any()
	}
}

pub fn (mut cm ConfigRepository) value_or_default(key string, default toml.Any) toml.Any {
	return cm.value(key).default_to(default)
}
