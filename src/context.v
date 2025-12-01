module envig

import toml

pub struct EnvigContext {
pub mut:
	envig_options EnvigOptions
mut:
	envig &Envig = unsafe { nil }
}

pub fn (mut ctx EnvigContext) envig() &Envig {
	if ctx.envig == unsafe { nil } {
		v := Envig.new(ctx.envig_options)
		ctx.envig = &v
	}
	return ctx.envig
}

pub fn (mut ctx EnvigContext) value(key string) toml.Any {
	mut e := ctx.envig()
	return e.value(key)
}

pub fn (mut ctx EnvigContext) string(key string) string {
	mut e := ctx.envig()
	return e.string(key)
}

pub fn (mut ctx EnvigContext) int(key string) int {
	mut e := ctx.envig()
	return e.int(key)
}

pub fn (mut ctx EnvigContext) i64(key string) i64 {
	mut e := ctx.envig()
	return e.i64(key)
}

pub fn (mut ctx EnvigContext) u64(key string) u64 {
	mut e := ctx.envig()
	return e.u64(key)
}

pub fn (mut ctx EnvigContext) f32(key string) f32 {
	mut e := ctx.envig()
	return e.f32(key)
}

pub fn (mut ctx EnvigContext) f64(key string) f64 {
	mut e := ctx.envig()
	return e.f64(key)
}

pub fn (mut ctx EnvigContext) bool(key string) bool {
	mut e := ctx.envig()
	return e.bool(key)
}

pub fn (mut ctx EnvigContext) date(key string) toml.Date {
	mut e := ctx.envig()
	return e.date(key)
}

pub fn (mut ctx EnvigContext) time(key string) toml.Time {
	mut e := ctx.envig()
	return e.time(key)
}

pub fn (mut ctx EnvigContext) datetime(key string) toml.DateTime {
	mut e := ctx.envig()
	return e.datetime(key)
}

pub fn (mut ctx EnvigContext) array(key string) []toml.Any {
	mut e := ctx.envig()
	return e.array(key)
}

pub fn (mut ctx EnvigContext) map(key string) map[string]toml.Any {
	mut e := ctx.envig()
	return e.map(key)
}
