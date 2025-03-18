# Envig

![Envig](https://img.shields.io/badge/V-Module-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg)

A lightweight and flexible configuration and environment manager for V.
It allows you to load configurations from files, directories, or raw text,
and manage environment variables seamlessly,
similar to `dotenv` and `dotenv-expand` in JavaScript.

## 🚀 Features

- Load configuration from TOML files dynamically.
- Support for environment variables via `.env` files.
- Ability to load configurations from directories, files, or raw text.
- Easy access to nested configuration values.
- Lightweight and fast, designed specifically for the V language.

---

## 📦 Installation

To use Envig in your V project, install it via VPM:

```sh
v install siguici.envig
```

Or add it to your dependencies manually:

```v
import siguici.envig
```

---

## 🛠️ Usage

### 1️⃣ **Loading a Configuration File**

```v
import siguici.envig

mut config := envig.ConfigManager.load(file: 'config.toml')

println(config.value('database.host'))
```

### 2️⃣ **Loading from a Directory**

```v
mut config := envig.ConfigManager.load_dir('config')
println(config.value('app.debug'))
```

### 3️⃣ **Loading from Raw Text**

```v
toml_text := """
[database]
host = "localhost"
port = 5432
"""
mut config := envig.ConfigManager.load_text(toml_text)
println(config.value('database.port')) // 5432
```

### 4️⃣ **Handling Environment Variables**

#### Loading `.env` Files

```v
import envig

mut env := envig.Env.load('.env')
println(env.get('APP_ENV'))
```

#### Expanding Variables (Like `dotenv-expand`)

```v
# .env
APP_ENV=production
DB_URL="postgres://user:password@localhost:5432/${APP_ENV}"
```

```v
mut env := envig.Env.load('.env').expand()
println(env.get('DB_URL')) // "postgres://user:password@localhost:5432/production"
```

---

## 📚 API Reference

### **ConfigManager** (Configuration Handling)

| Method                | Description |
|-----------------------|-------------|
| `load(file string)`   | Load a single TOML file as configuration. |
| `load_dir(dir string)` | Load all TOML files from a directory. |
| `load_text(text string)` | Load configuration from raw TOML text. |
| `value(key string)` | Get a configuration value. |
| `value_or_default(key string, default Any)` | Get a value or return a default. |

### **Env** (Environment Variable Handling)

| Method                | Description |
|-----------------------|-------------|
| `load(file string)`   | Load an `.env` file. |
| `get(key string)` | Retrieve an environment variable. |
| `expand()` | Expand variables inside other variables. |

---

## 🏗️ Roadmap

- [ ] Support for JSON and YAML formats.
- [ ] CLI tool for managing environment variables.
- [ ] Integration with logging and debugging tools.

---

## 🤝 Contributing

Feel free to contribute! Fork the repo, create a new branch, and submit a PR.

---

## 📜 License

Envig is released under the **MIT License**.

---

## ⭐ Show Your Support

If you like **Envig**, give it a *⭐* on GitHub!

```sh
git clone https://github.com/siguici/envig.git
```
