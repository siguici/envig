# 🌟 Envig – Unified Configuration and Environment Manager for V

[![Envig](https://img.shields.io/badge/V-Module-blue.svg)](https://vpm.vlang.io/packages/siguici.envig)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/siguici/envig/blob/HEAD/LICENSE.md)
[![CI](https://github.com/siguici/envig/workflows/CI/badge.svg)](https://github.com/siguici/envig/actions)

**Envig** is a lightweight and flexible configuration
and environment manager for **V**.  
It unifies configuration loading from TOML files and environment variables,
and supports dynamic expansion like `dotenv-expand`.

---

## 🚀 Features

✅ Load configuration from TOML files dynamically  
✅ Support for environment variables via `.env` files  
✅ Dynamic variable expansion (`${VAR_NAME}` style)  
✅ Load from directories, single files, or raw text  
✅ Fallback and default values for missing keys  
✅ Type-safe retrieval with automatic conversion  
✅ Lightweight and fast, designed specifically for the V language  

---

## 📦 Installation

Install it via VPM:

```sh
v install siguici.envig
````

Or add it to your dependencies:

```v
import siguici.envig
```

---

## ⚙️ Usage

### 🔹 Loading Configuration

#### Use default options

```v
import siguici.envig

mut config := envig.new()
println(config.string('database.host'))
```

#### Specify the config file and/or directory

```v
import siguici.envig

mut config := envig.new(
  file: 'config.toml'
  dir: 'config'
)
println(config.string('database.host'))
```

#### From a Single File

```v
import siguici.envig

mut config := envig.new(file: 'config.toml')
println(config.string('database.host'))
```

#### From a Directory

```v
mut config := envig.new(dir: 'config')
println(config.bool('app.debug'))
```

#### From Raw TOML Text

```v
toml_text := """
[database]
host = "localhost"
port = 5432
"""
mut config := envig.new(raw: toml_text)
println(config.int('database.port')) // 5432
```

---

### 🔹 Handling Environment Variables

#### Loading `.env` Files

```v
import siguici.envig

mut config := envig.new(env: 'local')
println(config.env('APP_NAME'))
```

#### Expanding Variables Dynamically

```v
# .env
APP_ENV=production
DB_URL="postgres://user:password@localhost:5432/${APP_ENV}"
```

```v
mut config := envig.new(env: 'production')
println(config.env('DB_URL')) // "postgres://user:password@localhost:5432/production"
```

---

### 🔹 Unified Interface: The `Envig` Manager

Envig provides a powerful unified interface combining environment and configuration:

```v
mut e := envig.new()

port := e.env_or_default('PORT', '8080')
db_url := e.get('database.url')
debug := e.get_as[bool]('app.debug')

println('Server running on port $port')
println('Database URL: $db_url')
println('Debug mode: $debug')
```

Or specify custom options:

```v
mut e := envig.new(envig.EnvigOptions{
    dir: 'settings',
    file: 'app.toml',
    env: 'production',
})
```

---

## 💡 Examples of Unified Access

| Purpose                           | Example                                                     |
| --------------------------------- | ----------------------------------------------------------- |
| Get environment variable          | `val := e.env('PORT')`                                      |
| Get environment with default      | `val := e.env_or_default('PORT', '3000')`                   |
| Get config value (toml.Any)       | `cfg := e.config('database.url')`                           |
| Config with default fallback      | `cfg := e.config_or_default('db', 'localhost')`             |
| Expand variables in a string      | `expanded := e.expand('${DATABASE_URL}')`                   |
| Unified get (config + expansion)  | `val := e.get('database.url')`                              |
| Unified get with default fallback | `val := e.get_or_default('service.url', 'https://default')` |
| Get as a specific type            | `debug := e.get_as[bool]('app.debug')`                      |

---

## 📚 API Reference

### Config & ConfigManager (Configuration Handling)

| Method                                                         | Description                                                        |
| -------------------------------------------------------------- | ------------------------------------------------------------------ |
| Config.new(raw string)                                       | Creates a config from raw text or TOML file (panics on error).     |
| Config.new_opt(raw string) !Config                           | Optional version returning error instead of panic.                 |
| ConfigManager.new(opts ConfigOptions)                        | Creates a config manager with options (dir, file).             |
| ConfigManager.load(opts ConfigOptions)                       | Loads configuration from file, directory or raw text.              |
| ConfigManager.load_dir(path string)                          | Loads all TOML files in a directory.                               |
| ConfigManager.load_file(path string)                         | Loads a single TOML file.                                          |
| ConfigManager.load_text(text string)                         | Loads config from raw TOML text.                                   |
| ConfigManager.value(path string)                             | Retrieves a value by key (supports nested keys like config.key). |
| ConfigManager.value_or_default(key string, default toml.Any) | Retrieves a value or returns a default.                            |

### Env & Dotenv (Environment Variable Handling)

| Method                                 | Description                                               |
| -------------------------------------- | --------------------------------------------------------- |
| Env.new(options EnvOptions)          | Creates an environment with a map of variables.           |
| Env.set(key, value)                  | Sets an environment variable.                             |
| Env.get(key)                         | Retrieves a variable (returns empty if missing).          |
| Env.get_or_default(key, default)     | Retrieves a variable or returns default.                  |
| Env.apply()                          | Applies all variables to the OS environment.              |
| Dotenv.load(options DotenvOptions)   | Loads a .env file (appends .APP_ENV if defined).      |
| Dotenv.load_multiple(files []string) | Loads multiple .env files.                              |
| Dotenv.expand()                      | Expands variables inside other variables (e.g. ${VAR}). |

---

### **Envig** (Unified Manager)

| Method                             | Description                                          |
| ---------------------------------- | ---------------------------------------------------- |
| `new(options EnvigOptions)`      | Initialize a new Envig instance                      |
| `config(path string)`              | Get a configuration value (`toml.Any`)               |
| `env(name string)`                 | Get an environment variable                          |
| `get(key string)`                  | Get config with expansion                            |
| `value(key string)`                | Get as `toml.Any`                                    |
| `get_as[T](key string)`            | Type-safe retrieval (`T` can be `int`, `bool`, etc.) |
| `config_or_default(path, default)` | Config value or fallback                             |
| `env_or_default(name, default)`    | Env variable or fallback                             |
| `expand(value toml.Any)`           | Expand variable references                           |
| `get_or_default(key, default)`     | Unified get with default                             |

---

## 🏗️ Roadmap

* [ ] Support for JSON and YAML configuration formats
* [ ] CLI tool for managing environment variables
* [ ] Integration with logging and debugging tools

---

## 🤝 Contributing

Feel free to submit issues, ideas, or pull requests!
Let’s build something great together.

---

## 📜 License

Envig is released under the **MIT License**.

---

## ⭐ Show Your Support

If you like **Envig**, give it a *⭐* on [GitHub](https://github.com/siguici/envig)!

---

Enjoy seamless configuration management with **Envig**! 🚀
