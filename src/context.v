module envig

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
